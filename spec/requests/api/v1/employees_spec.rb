require "rails_helper"

RSpec.describe "Api::V1::Employees", type: :request do
  describe "GET /api/v1/employees" do
    before do
      create_list(:employee, 3, country: "India")
      create(:employee, :us_employee)
    end

    it "returns filtered employees" do
      get "/api/v1/employees", params: { country: "India" }

      expect(response).to have_http_status(:ok)
      expect(json_response["data"].size).to eq(3)
      expect(json_response["pagination"]["total_count"]).to eq(3)
    end
  end

  describe "POST /api/v1/employees" do
    let(:params) do
      {
        employee: attributes_for(:employee)
      }
    end

    it "creates an employee" do
      expect do
        post "/api/v1/employees", params: params
      end.to change(Employee, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe "PATCH /api/v1/employees/:id" do
    let!(:employee) { create(:employee) }

    it "updates an employee" do
      patch "/api/v1/employees/#{employee.id}", params: {
        employee: { job_title: "Product Manager" }
      }

      expect(response).to have_http_status(:ok)
      expect(employee.reload.job_title).to eq("Product Manager")
    end
  end

  describe "DELETE /api/v1/employees/:id" do
    let!(:employee) { create(:employee) }

    it "deletes an employee" do
      expect do
        delete "/api/v1/employees/#{employee.id}"
      end.to change(Employee, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end