# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Aggregations::Europeana::ReportBuilder do
  it { is_expected.to be_kind_of( Sidekiq::Worker) }
  describe '#perform' do
  end
end