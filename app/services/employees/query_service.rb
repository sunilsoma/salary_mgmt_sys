module Employees
  class QueryService
    DEFAULT_PAGE = 1
    DEFAULT_PER_PAGE = 20
    MAX_PER_PAGE = 100

    def initialize(relation: Employee.all, params: {})
      @relation = relation
      @params = params
    end

    def call
      scoped = apply_filters(relation.order(:id))
      page = normalized_page
      per_page = normalized_per_page
      total_count = scoped.count
      total_pages = (total_count.to_f / per_page).ceil

      {
        data: scoped.offset((page - 1) * per_page).limit(per_page),
        pagination: {
          page: page,
          per_page: per_page,
          total_count: total_count,
          total_pages: total_pages
        }
      }
    end

    private

    attr_reader :relation, :params

    def apply_filters(scope)
      scope = scope.where(country: value_for(:country)) if value_for(:country).present?
      scope = scope.where(job_title: value_for(:job_title)) if value_for(:job_title).present?
      scope = scope.where(department: value_for(:department)) if value_for(:department).present?

      if value_for(:search).present?
        query = "%#{value_for(:search).strip}%"
        scope = scope.where(
          "full_name LIKE :q OR email LIKE :q OR employee_code LIKE :q",
          q: query
        )
      end

      scope
    end

    def normalized_page
      [value_for(:page).to_i, 1].max.nonzero? || DEFAULT_PAGE
    end

    def normalized_per_page
      per_page = value_for(:per_page).to_i
      per_page = DEFAULT_PER_PAGE if per_page <= 0
      per_page.clamp(1, MAX_PER_PAGE)
    end

    def value_for(key)
      params[key] || params[key.to_s]
    end
  end
end