require "rails_helper"

RSpec.describe Insights::SalarySummaryService do
  describe "#call" do
    before do
      create(:employee, country: "India", annual_salary: 50_000, job_title: "Software Engineer")
      create(:employee, country: "India", annual_salary: 100_000, job_title: "Software Engineer")
      create(:employee, country: "India", annual_salary: 150_000, job_title: "HR Manager", department: "HR")
      create(:employee, :us_employee, annual_salary: 200_000)
    end

    it "returns country salary stats" do
      result = described_class.new(country: "India").call

      expect(result[:country_stats][:employee_count]).to eq(3)
      expect(result[:country_stats][:min_salary]).to eq(50_000.0)
      expect(result[:country_stats][:max_salary]).to eq(150_000.0)
      expect(result[:country_stats][:avg_salary]).to eq(100_000.0)
    end

    it "returns job title average salary in a country" do
      result = described_class.new(country: "India", job_title: "Software Engineer").call

      expect(result[:job_title_stats][:employee_count]).to eq(2)
      expect(result[:job_title_stats][:average_salary]).to eq(75_000.0)
    end
  end
end