class Impl::DataProviders::TopDigitalObjectsBuilder
  include Sidekiq::Worker
  sidekiq_options backtrace: true

  def perform(data_provider_id, user_start_date = "2012-01-01",user_end_date = (Date.today.at_beginning_of_week - 1).strftime("%Y-%m-%d"))
    data_provider = Impl::Aggregation.data_providers.find(data_provider_id)
    begin
      raise "'Dismarc' data set" if data_provider.dismarc_data_set?
    rescue => e
      data_provider.update_attributes(status: "Failed", error_messages: e.to_s)
      return nil
    end
    data_provider.update_attributes(status: "Building top digital objects", error_messages: nil)
    begin
      top_digital_objects = Impl::DataProviders::TopDigitalObjectsBuilder.fetch_data_for_all_quarters_between(user_start_date, user_end_date, data_provider)
      Core::TimeAggregation.create_digital_objects_aggregation(top_digital_objects,"quarterly", data_provider_id)
      data_provider.update_attributes(status: "Processed top 10 digital objects")
      next_start_date = (Date.today.at_beginning_of_week).strftime("%Y-%m-%d")
      next_end_date = (Date.today.at_end_of_week).strftime("%Y-%m-%d")
      # Impl::DataProviders::TrafficBuilder.perform_at(1.week.from_now,data_provider_id,next_start_date, next_end_date)
    rescue => e
      data_provider.update_attributes(status: "Failed to build top digital objects",error_messages: e.to_s)
    end
  end

  def self.fetch_data_for_all_quarters_between(start_date, end_date, data_provider)
    top_digital_objects_data = []
    ga_access_token = Impl::DataSet.get_access_token
    europeana_base_url = "http://europeana.eu/api/v2/"
    base_title_url = "http://www.europeana.eu/portal/record/"
    ga_metrics="ga:pageviews"
    ga_dimensions="ga:pagePath,ga:month,ga:year"
    ga_sort= "-ga:pageviews"
    ga_filters  = data_provider.get_aggregated_filters
    ga_start_date = start_date
    ga_end_date = end_date
    top_digital_objects_per_quarter = JSON.parse(open("https://www.googleapis.com/analytics/v3/data/ga?access_token=#{ga_access_token}&start-date=#{ga_start_date}&end-date=#{ga_end_date}&ids=ga:#{GA_IDS}&metrics=#{ga_metrics}&dimensions=#{ga_dimensions}&filters=#{ga_filters}&sort=#{ga_sort}").read)["rows"]
    if top_digital_objects_per_quarter.present?
      top_digital_objects_per_quarter.each do |digital_object|
        page_path = digital_object[0].split("/")
        size = digital_object[3].to_i
        begin
          digital_object_europeana_data = JSON.parse(open("#{europeana_base_url}#{page_path[2]}/#{page_path[3]}/#{page_path[4].split(".")[0]}.json?wskey=api2demo&profile=full").read)
        rescue => e
          next
        end
        next if digital_object_europeana_data.nil?
        image_url = digital_object_europeana_data["object"]['europeanaAggregation']['edmPreview'].present? ? digital_object_europeana_data["object"]['europeanaAggregation']['edmPreview'] : "http://europeanastatic.eu/api/image?size=FULL_DOC&type=VIDEO"
        begin
          title = digital_object_europeana_data["object"]["proxies"][0]['dcTitle'].first[1].first
        rescue => e
          title = "No Title Found"
        end
        title_middle_url = digital_object_europeana_data["object"]['europeanaAggregation']['about'].split("/")
        title_url = "#{base_title_url}#{title_middle_url[3]}/#{title_middle_url[4]}.html"
        top_digital_objects_data << {"image_url" => image_url, "title" => title, "title_url" => title_url, "size" => size, "year" => digital_object[2], "month" =>digital_object[1] }
      end
    end
    return top_digital_objects_data
  end
end