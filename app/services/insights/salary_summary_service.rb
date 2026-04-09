module Insights
  class SalarySummaryService
    def initialize(country:, job_title: nil, relation: Employee.all)
      @country = country
      @job_title = job_title
      @relation = relation
    end

    def call
      raise ArgumentError, "country is required" if country.blank?

      country_scope = relation.where(country: country)

      {
        country_stats: country_stats(country_scope),
        job_title_stats: job_title_stats(country_scope),
        average_salary_by_job_title: average_salary_by_job_title(country_scope)
      }
    end

    private

    attr_reader :country, :job_title, :relation

    def country_stats(scope)
      {
        country: country,
        employee_count: scope.count,
        min_salary: scope.minimum(:annual_salary)&.to_f,
        max_salary: scope.maximum(:annual_salary)&.to_f,
        avg_salary: scope.average(:annual_salary)&.to_f&.round(2),
        total_payroll: scope.sum(:annual_salary).to_f.round(2)
      }
    end

    def job_title_stats(scope)
      return nil if job_title.blank?

      filtered = scope.where(job_title: job_title)

      {
        country: country,
        job_title: job_title,
        employee_count: filtered.count,
        average_salary: filtered.average(:annual_salary)&.to_f&.round(2)
      }
    end

    def average_salary_by_job_title(scope)
      scope.group(:job_title)
           .average(:annual_salary)
           .transform_values { |value| value.to_f.round(2) }
    end
  end
end