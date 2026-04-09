class Employee < ApplicationRecord
  before_validation :set_full_name

  validates :employee_code, presence: true, uniqueness: true
  validates :first_name, :last_name, :full_name, :email, :job_title, :department,
            :country, :currency, :employment_status, :hire_date, presence: true
  validates :email, uniqueness: true
  validates :annual_salary, presence: true, numericality: { greater_than: 0 }
  validates :employment_status, inclusion: { in: %w[active inactive] }

  private

  def set_full_name
    return if first_name.blank? || last_name.blank?

    self.full_name = "#{first_name} #{last_name}".strip
  end
end
