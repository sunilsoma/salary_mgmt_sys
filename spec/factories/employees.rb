FactoryBot.define do
  factory :employee do
    sequence(:employee_code) { |n| "EMP#{n.to_s.rjust(5, '0')}" }
    sequence(:first_name) { |n| "First#{n}" }
    sequence(:last_name) { |n| "Last#{n}" }
    full_name { "#{first_name} #{last_name}" }
    sequence(:email) { |n| "employee#{n}@example.com" }

    job_title { "Software Engineer" }
    department { "Engineering" }
    country { "India" }
    currency { "INR" }
    annual_salary { 100_000 }
    employment_status { "active" }
    hire_date { Date.current - 365 }

    trait :inactive do
      employment_status { "inactive" }
    end

    trait :hr_manager do
      job_title { "HR Manager" }
      department { "HR" }
    end

    trait :us_employee do
      country { "United States" }
      currency { "USD" }
    end
  end
end