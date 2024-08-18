# frozen_string_literal: true

module HeadHunterAnalytics
  module Resources
    module Vacancies
      class VacancyCollection < HeadHunterAnalytics::BaseCollection
        def skills_stat
          collection.flat_map(&:key_skills).each_with_object(Hash.new(0)) do |skill, hash|
            hash[skill] += 1
          end
        end

        # count the average salary
        def avg_salary
          all_avg_salaries = collection.map(&:avg_salary).compact

          return 0 if all_avg_salaries.empty?

          (all_avg_salaries.sum / all_avg_salaries.size * 1.0).round
        end
      end
    end
  end
end
