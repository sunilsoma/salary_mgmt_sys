require "rails_helper"

RSpec.describe Employee, type: :model do
  it "has a valid factory" do
    expect(build(:employee)).to be_valid
  end

  it "is invalid with non-positive salary" do
    employee = build(:employee, annual_salary: 0)
    expect(employee).not_to be_valid
  end

  it "sets full_name before validation" do
    employee = build(:employee, first_name: "John", last_name: "Doe", full_name: nil)
    employee.valid?
    expect(employee.full_name).to eq("John Doe")
  end
end