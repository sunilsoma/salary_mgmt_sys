require "rails_helper"

RSpec.describe "Api::V1::Insights", type: :request do
  before do
    create(:employee, country: "India", annual_salary: 50_000, job_title: "Software Engineer")
    create(:employee, country: "India", annual_salary: 100_000, job_title: "Software Engineer")
    create(:employee, country: "India", annual_salary: 150_000, job_title: "HR Manager", department: "HR")
  end

  it "returns salary insights for a country" do
    get "/api/v1/insights", params: { country: "India" }

    expect(response).to have_http_status(:ok)
    expect(json_response["country_stats"]["employee_count"]).to eq(3)
    expect(json_response["country_stats"]["avg_salary"]).to eq(100000.0)
  end

  it "returns salary insights for a job title in a country" do
    get "/api/v1/insights", params: { country: "India", job_title: "Software Engineer" }

    expect(response).to have_http_status(:ok)
    expect(json_response["job_title_stats"]["employee_count"]).to eq(2)
    expect(json_response["job_title_stats"]["average_salary"]).to eq(75000.0)
  end
end