# frozen_string_literal: true
class Impl::DataProviders::ReportBuilder
  include Sidekiq::Worker
  sidekiq_options backtrace: true

  # Creates report for a particular provider.
  #
  # @param aggregation_id [Fixnum] id of the instance of Impl:Aggregation.
  def perform(aggregation_id)
    aggregation = Impl::Aggregation.find(aggregation_id)
    aggregation.update_attributes(status: 'Building Report', error_messages: nil)
    begin
      variable_object, core_template = Impl::DataProviders::ReportBuilder.get_report_variable_object(aggregation)
      html_content = ''

      Impl::Report.create_or_update(aggregation.name, aggregation_id, core_template.id, html_content, variable_object, true, aggregation.name.parameterize('-'))
      aggregation.update_attributes(status: 'Report built', error_messages: nil)
    rescue => e
      aggregation.update_attributes(status: 'Failed to build report', error_messages: e.to_s)
    end
  end

  # Returns a Hash with the data to create the line chart, top countries, total items count and items available for reuse.
  #
  # @param aggregation [Object] an instance of Impl::Aggregation with scope of where genre is europeana.
  # @return [Hash, Object] hash of content of entities and a reference to Core::Template scoped as the default europeana template.
  def self.get_report_variable_object(aggregation)
    variable_object = {}
    core_template = Core::Template.default_europeana_template
    required_variables = core_template.required_variables['required_variables']
    core_vizs = aggregation.core_vizs

    # "$main_chart$"
    line_chart_content_key = required_variables.shift
    line_chart_content_value = core_vizs.line_chart.first.auto_html_json
    variable_object[line_chart_content_key] = line_chart_content_value

    # "$topcountries$"
    top_countries_content_key = required_variables.shift
    top_countries_content_value = core_vizs.top_country.first.auto_html_json
    variable_object[top_countries_content_key] = top_countries_content_value

    # "$total_items$"
    media_type_key = required_variables.shift
    media_type_value = core_vizs.media_type_donut_chart.first.auto_html_json
    variable_object[media_type_key] = media_type_value

    # "$open_for_reuse$"
    reusable_content_key = required_variables.shift
    reusable_content_value = core_vizs.reusable.first.auto_html_json
    variable_object[reusable_content_key] = reusable_content_value

    [variable_object, core_template]
  end
end
