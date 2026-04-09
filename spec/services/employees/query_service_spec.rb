require "rails_helper"

RSpec.describe Employees::QueryService do
  describe "#call" do
    let!(:india_engineer) { create(:employee, country: "India", job_title: "Software Engineer") }
    let!(:india_hr) { create(:employee, :hr_manager, country: "India") }
    let!(:us_engineer) { create(:employee, :us_employee, job_title: "Software Engineer") }

    it "filters by country" do
      result = described_class.new(params: { country: "India" }).call

      expect(result[:data].count).to eq(2)
      expect(result[:pagination][:total_count]).to eq(2)
    end

    it "filters by country and job title" do
      result = described_class.new(params: { country: "India", job_title: "Software Engineer" }).call

      expect(result[:data].count).to eq(1)
      expect(result[:data].first.id).to eq(india_engineer.id)
    end

    it "supports search" do
      result = described_class.new(params: { search: india_hr.email }).call

      expect(result[:data].count).to eq(1)
      expect(result[:data].first.id).to eq(india_hr.id)
    end
  end
end