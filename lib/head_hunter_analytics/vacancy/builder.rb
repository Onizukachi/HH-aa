# frozen_string_literal: true

module HeadHunterAnalytics
  module Vacancy
    # Build object vacancy from raw hash
    class Builder
      class << self
        def build(hash)
          OpenStruct.new(
            id: hash['id'],
            name: hash['name'],
            location: hash.dig('area', 'name'),
            salary_currency: hash.dig('salary', 'currency'),
            avg_salary: extract_avg_salary(hash['salary']),
            published_at: format_date(hash['published_at']),
            employer: hash.dig('employer', 'name'),
            key_skills: extract_skills(hash['key_skills'])
          )
        end

        private

        def extract_avg_salary(salary)
          return unless salary

          from, to = salary['from'], salary['to']
          return from unless to
          return to unless from

          ((from + to) / 2.0).round
        end

        def format_date(date)
          DateTime.parse(date)
        end

        def extract_skills(skills)
          return [] unless skills

          skills.map { |skill| skill['name'] }
        end
      end
    end
  end
end
