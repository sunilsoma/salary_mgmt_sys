require "factory_bot_rails"

FactoryBot.definition_file_paths = [Rails.root.join("spec/factories").to_s]
# FactoryBot.find_definitions

puts "Seeding employees..."
Seeds::EmployeeSeedService.new(count: 10_000).call
puts "Done. Seeded #{Employee.count} employees."