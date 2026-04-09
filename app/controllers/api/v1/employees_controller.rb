module Api
  module V1
    class EmployeesController < ApplicationController
      before_action :set_employee, only: %i[show update destroy]

      def index
        result = Employees::QueryService.new(params: params).call

        render json: {
          data: result[:data].as_json,
          pagination: result[:pagination]
        }
      end

      def show
        render json: @employee
      end

      def create
        service = Employees::PersistService.new(
          employee: Employee.new,
          attributes: employee_params.to_h
        )

        if service.call
          render json: service.employee, status: :created
        else
          render json: { errors: service.errors }, status: :unprocessable_entity
        end
      end

      def update
        service = Employees::PersistService.new(
          employee: @employee,
          attributes: employee_params.to_h
        )

        if service.call
          render json: service.employee
        else
          render json: { errors: service.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @employee.destroy
        head :no_content
      end

      private

      def set_employee
        @employee = Employee.find(params[:id])
      end

      def employee_params
        params.require(:employee).permit(
          :employee_code,
          :first_name,
          :last_name,
          :email,
          :job_title,
          :department,
          :country,
          :currency,
          :annual_salary,
          :employment_status,
          :hire_date
        )
      end
    end
  end
end