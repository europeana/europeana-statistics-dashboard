# frozen_string_literal: true
class Aggregations::Europeana::PageviewsBuilder
  include Sidekiq::Worker

  sidekiq_options backtrace: true
  require 'open-uri'

  # Fetches pageviews and clickthroughs data from Google Analytics.
  def perform
    aggregation = Impl::Aggregation.europeana
    aggregation_id = aggregation.id
    if aggregation.europeana?
      ga_start_date   = aggregation.last_updated_at.present? ? (aggregation.last_updated_at + 1).strftime('%Y-%m-%d') : '2013-01-01'
      ga_end_date     = (Date.today.at_beginning_of_month - 1).strftime('%Y-%m-%d')
      return unless ga_start_date < ga_end_date
      aggregation.update_attributes(status: 'Fetching pageviews', error_messages: nil)
      aggregation_output = Impl::Output.find_or_create(aggregation_id, 'Impl::Aggregation', 'pageviews')
      aggregation_output.update_attributes(status: 'Fetching pageviews', error_messages: nil)
      ga_access_token = Impl::DataSet.get_access_token
      ga_base_url     =  "#{GA_ENDPOINT}?access_token=#{ga_access_token}&start-date=#{ga_start_date}&end-date=#{ga_end_date}&ids=ga:#{GA_IDS}"
      begin
        ga_dimensions   = 'ga:month,ga:year'
        ga_metrics      = 'ga:pageviews'
        ga_filters      = 'ga:hostname=~europeana.eu;ga:pagePath=~/portal/(../)?record/'


        page_views = self.class.parsed_json_for("#{ga_base_url}&metrics=#{ga_metrics}&dimensions=#{ga_dimensions}&filters=#{ga_filters}")['rows']
        page_views_data = page_views.map { |a| { 'month' => a[0], 'year' => a[1], 'pageviews' => a[2].to_i } }
        page_views_data = page_views_data.sort_by { |d| [d['year'], d['month']] }
        Core::TimeAggregation.create_time_aggregations('Impl::Output', aggregation_output.id, page_views_data, 'pageviews', 'monthly')
        aggregation.update_attributes(status: 'Fetched pageviews', error_messages: nil)
        aggregation_output.update_attributes(status: 'Fetched Pageviews', error_messages: nil)

        # Fetching Visits
        ga_dimensions   = 'ga:month,ga:year,ga:medium'
        ga_metrics      = 'ga:visits'
        ga_filters      = 'ga:hostname=~europeana.eu'
        ga_access_token = Impl::DataSet.get_access_token
        ga_base_url     =  "#{GA_ENDPOINT}?access_token=#{ga_access_token}&start-date=#{ga_start_date}&end-date=#{ga_end_date}&ids=ga:#{GA_IDS}"

        mediums = self.class.parsed_json_for("#{ga_base_url}&metrics=#{ga_metrics}&dimensions=#{ga_dimensions}&filters=#{ga_filters}")['rows']
        mediums_data = mediums.map { |a| { 'month' => a[0], 'year' => a[1], 'medium' => a[2], 'visits' => a[3] } }
        mediums_data = mediums_data.sort_by { |d| [d['year'], d['month']] }

        Core::TimeAggregation.create_aggregations(mediums_data, 'monthly', aggregation_id, 'Impl::Aggregation', 'visits', 'medium')

        # Fetching ClickThroughs
        data_provider_click_through_output = Impl::Output.find_or_create(aggregation_id, 'Impl::Aggregation', 'clickThrough')

        ga_dimensions = 'ga:year'
        click_metrics = 'ga:totalEvents'
        ga_filter = 'ga:hostname=~europeana.eu;ga:pagePath=~/portal/(../)?record/;ga:eventCategory==Europeana Redirect,ga:eventCategory==Redirect'
        ga_access_token = Impl::DataSet.get_access_token
        ga_base_url     =  "#{GA_ENDPOINT}?access_token=#{ga_access_token}&start-date=#{ga_start_date}&end-date=#{ga_end_date}&ids=ga:#{GA_IDS}"

        # click Through
        click_through = self.class.parsed_json_for("#{ga_base_url}&metrics=#{click_metrics}&dimensions=#{ga_dimensions}&filters=#{ga_filter}")['rows']
        click_through_data = click_through.map { |a| { 'year' => a[0], 'clickThrough' => a[1].to_i } }
        click_through_data = click_through_data.sort_by { |d| [d['year']] }

        Core::TimeAggregation.create_time_aggregations('Impl::Output', data_provider_click_through_output.id, click_through_data, 'clickThrough', 'yearly')

        # Fetching Countries
        country_output = Impl::Aggregation.fetch_GA_data_between(ga_start_date, ga_end_date, nil, 'country', 'pageviews')
        Core::TimeAggregation.create_aggregations(country_output, 'monthly', aggregation_id, 'Impl::Aggregation', 'pageviews', 'country') unless country_output.nil?

        # Top Digital Objects
        top_digital_objects = Aggregations::Europeana::PageviewsBuilder.fetch_data_for_all_items_between(ga_start_date, ga_end_date)
        Core::TimeAggregation.create_digital_objects_aggregation(top_digital_objects, 'monthly', aggregation.id)

        Aggregations::Europeana::PropertiesBuilder.perform_async
        aggregation.update_attributes(status: 'Fetched data successfully', last_updated_at: Date.today.at_beginning_of_month - 1)
      rescue => e
        aggregation_output.update_attributes(status: 'Failed to fetch pageviews', error_messages: e.to_s)
        aggregation.update_attributes(status: 'Failed Fetching pageviews', error_messages: e.to_s)
      end
    end
  end

  # Returns data of pageviews for all top digital objects from Google Analytics fetching, the details of digital objects from Europeana API's
  #
  # @param start_date [String] valid start date to fetch Google Analytics data from.
  # @param end_date [String] a valid date till which Google Analytics data is to be fetched.
  # @return [Array] an array of Hash that is formatted output of Google Analytics and Europeana API's.
  def self.fetch_data_for_all_items_between(start_date, end_date)
    top_digital_objects_data = []
    europeana_base_url = ENV['EUROPEANA_API_URL']
    base_title_url = 'http://www.europeana.eu/portal/record/'
    ga_metrics = 'ga:pageviews'
    ga_dimensions = 'ga:pagePath,ga:month,ga:year'
    ga_sort = '-ga:pageviews'
    ga_filters = 'ga:hostname=~europeana.eu;ga:pagePath=~/portal/(../)?record/'

    # setup dates
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)
    period_end_date = (start_date + 1.month).at_beginning_of_month - 1
    # Go through each month and gather statisitcs
    while period_end_date <= end_date do
      ga_access_token = Impl::DataSet.get_access_token

      # Format dates as strings for google
      ga_start_date = start_date.strftime('%Y-%m-%d')
      ga_end_date = period_end_date.strftime('%Y-%m-%d')

      ga_max_results = 50
      top_digital_objects = parsed_json_for("#{GA_ENDPOINT}?access_token=#{ga_access_token}&start-date=#{ga_start_date}&end-date=#{ga_end_date}&ids=ga:#{GA_IDS}&metrics=#{ga_metrics}&dimensions=#{ga_dimensions}&filters=#{ga_filters}&sort=#{ga_sort}&max-results=#{ga_max_results}")['rows']
      if top_digital_objects.present?
        top_digital_objects.each do |digital_object|
          page_path = digital_object[0].split('/')

          # checking if the url contains a language code and if so, removing it
          if page_path.count == 6 && page_path[3] == 'record'
            page_path.delete_at(2)
          end

          next if page_path[2].downcase != 'record'

          size = digital_object[3].to_i
          begin
            digital_object_europeana_data = parsed_json_for("#{europeana_base_url}/#{page_path[2]}/#{page_path[3]}/#{page_path[4].split('.')[0]}.json?wskey=#{ENV['WSKEY']}&profile=full")
          rescue => e
            #puts "TODO log this error #{e.inspect}"
            #puts "URL was: #{europeana_base_url}#{page_path[2]}/#{page_path[3]}/#{page_path[4].split('.')[0]}.json?wskey=#{ENV['WSKEY']}&profile=full"
            next
          end
          next if digital_object_europeana_data.nil? || (digital_object_europeana_data['success'] == false)
          image_url = digital_object_europeana_data['object']['europeanaAggregation']['edmPreview'].present? ? digital_object_europeana_data['object']['europeanaAggregation']['edmPreview'] : 'http://europeanastatic.eu/api/image?size=FULL_DOC&type=VIDEO'
          begin
            title = digital_object_europeana_data['object']['proxies'][0]['dcTitle'].first[1].first
          rescue
            title = 'No Title Found'
          end
          title_middle_url = digital_object_europeana_data['object']['europeanaAggregation']['about'].split('/')
          title_url = "#{base_title_url}#{title_middle_url[3]}/#{title_middle_url[4]}.html"
          top_digital_objects_data << { 'image_url' => image_url, 'title' => title, 'title_url' => title_url, 'size' => size, 'year' => digital_object[2], 'month' => digital_object[1] }
        end
      end


      start_date = (start_date + 1.month).at_beginning_of_month
      period_end_date = (start_date + 1.month).at_beginning_of_month - 1
    end
    top_digital_objects_data
  end

  ##
  # Open a url and parse the json from it.
  #
  # @param url [String] the string for the url to read json from.
  def self.parsed_json_for(url)
    JSON.parse(open(url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE).read)
  end
end
