module Seeds
  class NameSource
    class << self
      def first_names
        @first_names ||= read_file("first_names.txt")
      end

      def last_names
        @last_names ||= read_file("last_names.txt")
      end

      private

      def read_file(file_name)
        File.readlines(Rails.root.join("db/data/#{file_name}"), chomp: true)
            .map(&:strip)
            .reject(&:blank?)
      end
    end
  end
end