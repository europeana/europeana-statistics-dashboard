# frozen_string_literal: true
class Impl::DataProviders::DataSetBuilder
  include Sidekiq::Worker
  sidekiq_options backtrace: true

  # Fetches data sets using the Europeana API and store them in the data base.
  #
  # @param aggregation_id [Fixnum] id of the instance of Impl:Aggregation.
  def perform(aggregation_id)
    aggregation = Impl::Aggregation.find(aggregation_id)
    unless aggregation.genre == 'europeana'
      aggregation.update_attributes(status: 'Building Data Sets', error_messages: nil)
      begin
        parsed_json = JSON.parse(Nestful.get("#{ENV['EUROPEANA_API_URL']}/search.json?wskey=#{ENV['WSKEY']}&query=#{CGI.escape(aggregation.genre.upcase + ':"' + aggregation.name + '"')}&rows=0&profile=facets,params&facet=europeana_collectionName").body)
        all_data_sets = parsed_json['facets'] ? parsed_json['facets'].first : nil
        if all_data_sets.present? && all_data_sets['fields'].present?
          all_data_sets['fields'].each do |data_set|
            d_set = Impl::DataSet.find_or_create(data_set['label'])
            Impl::AggregationDataSet.find_or_create(aggregation.id, d_set.id)
          end
          # Run the TrafficBuilder worker for the same Impl::Aggregation instance.
          Impl::DataProviders::TrafficBuilder.perform_async(aggregation_id)
        else
          raise 'No data set found'
        end
      rescue => e

        aggregation.update_attributes(status: 'Failed to build data sets', error_messages: e.to_s)
      end
    end
  end
end
