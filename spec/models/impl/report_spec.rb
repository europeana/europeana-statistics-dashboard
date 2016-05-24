require "rails_helper"

RSpec.describe Impl::Report, type: :model do

  context '#create_or_update' do
    it "should return a new Impl::Report" do
      name = "TestImpl::Report"
      aggregation_id = -1
      core_template_id = -1
      html_content = "<h1> Sample Test HTML String </h1>"
      variable_object = {}
      is_autogenerated = false
      slug = 'testimpl-report'


      impl_report = Impl::Report.where(name: name, impl_aggregation_id: aggregation_id, core_template_id: core_template_id).first
      expect(impl_report).to eq(nil)

      impl_report = Impl::Report.create_or_update(name, aggregation_id, core_template_id, html_content, variable_object, is_autogenerated, slug)
      expect(impl_report.id.class).to eq(Fixnum)
      expect(impl_report).not_to eq(nil)
    end

    it "should update a Impl::Report" do

      name = "TestImpl::Report"
      aggregation_id = -1
      core_template_id = -1
      html_content = "<h1> Sample Test HTML String </h1>"
      variable_object = {}
      is_autogenerated = false
      slug = 'testimpl-report'

      Impl::Report.create_or_update(name, aggregation_id, core_template_id, html_content, variable_object, is_autogenerated, slug)

      variable_object = {test: "TestVariableObject"}
      is_autogenerated = false
      slug = 'testimpl-report'

      impl_report = Impl::Report.where(name: name, impl_aggregation_id: aggregation_id, core_template_id: core_template_id).first
      expect(impl_report).not_to eq(nil)
      expect(impl_report.variable_object).to eq({})

      impl_report = Impl::Report.create_or_update(name, aggregation_id, core_template_id, html_content, variable_object, is_autogenerated, slug)
      expect(impl_report.variable_object).to eq({"test" => "TestVariableObject"})
      impl_report.delete
    end
  end

  context 'testing scope manual' do
    it 'should return all rows where is_autogenerated is false' do
      impl_report = Impl::Report.manual.first
      expect(impl_report.is_autogenerated).to eq(false)
    end
  end
end