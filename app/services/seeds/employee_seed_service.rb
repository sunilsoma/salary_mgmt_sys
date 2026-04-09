module Seeds
  class EmployeeSeedService
    COUNTRIES = [
      { name: "India", currency: "INR" },
      { name: "United States", currency: "USD" },
      { name: "United Kingdom", currency: "GBP" },
      { name: "Germany", currency: "EUR" },
      { name: "Canada", currency: "CAD" }
    ].freeze

    JOB_TITLES = [
      "Software Engineer",
      "Senior Software Engineer",
      "Engineering Manager",
      "HR Manager",
      "Product Manager",
      "Designer",
      "Data Analyst",
      "Accountant"
    ].freeze

    DEPARTMENTS = [
      "Engineering",
      "HR",
      "Product",
      "Design",
      "Finance",
      "Operations"
    ].freeze

    SALARY_BANDS = {
      "Software Engineer" => 60_000..110_000,
      "Senior Software Engineer" => 90_000..150_000,
      "Engineering Manager" => 120_000..180_000,
      "HR Manager" => 70_000..120_000,
      "Product Manager" => 90_000..160_000,
      "Designer" => 55_000..100_000,
      "Data Analyst" => 65_000..115_000,
      "Accountant" => 50_000..95_000
    }.freeze

    BATCH_SIZE = 1000

    def initialize(count: 10_000, random: Random.new(1234))
      @count = count
      @random = random
    end

    def call
      now = Time.current
      rows = build_rows(now)

      Employee.transaction do
        Employee.delete_all
        rows.each_slice(BATCH_SIZE) do |batch|
          Employee.insert_all!(batch)
        end
      end
    end

    private

    attr_reader :count, :random

    def build_rows(now)
      Array.new(count) do |index|
        first_name = Seeds::NameSource.first_names.sample(random: random)
        last_name = Seeds::NameSource.last_names.sample(random: random)
        country = COUNTRIES.sample(random: random)
        job_title = JOB_TITLES.sample(random: random)

        attrs = FactoryBot.attributes_for(
          :employee,
          employee_code: format("EMP%05d", index + 1),
          first_name: first_name,
          last_name: last_name,
          full_name: "#{first_name} #{last_name}",
          email: "#{first_name.downcase}.#{last_name.downcase}.#{index + 1}@example.com",
          job_title: job_title,
          department: DEPARTMENTS.sample(random: random),
          country: country[:name],
          currency: country[:currency],
          annual_salary: random.rand(SALARY_BANDS.fetch(job_title)),
          employment_status: random.rand < 0.9 ? "active" : "inactive",
          hire_date: Date.current - random.rand(3650)
        )

        attrs.merge(created_at: now, updated_at: now)
      end
    end
  end
end