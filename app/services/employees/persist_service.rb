module Employees
  class PersistService
    attr_reader :employee

    def initialize(employee:, attributes:)
      @employee = employee
      @attributes = attributes
    end

    def call
      employee.assign_attributes(attributes)
      employee.save
    end

    def errors
      employee.errors.full_messages
    end

    private

    attr_reader :attributes
  end
end