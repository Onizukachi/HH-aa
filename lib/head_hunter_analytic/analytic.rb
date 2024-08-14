# frozen_string_literal: true

require_relative 'vacancy_filter_factory'
require_relative 'vacancy_collection'
require_relative 'vacancy_builder'
require_relative 'vacancy_loader'

module HeadHunterAnalytic
  class Analytic
    attr_reader :language, :client, :vacancy_collection

    def initialize(language:, client: HeadHunterAnalytic::Client.new, vacancy_collection: VacancyCollection.new)
      @client = client
      @language = language
      @vacancy_collection = vacancy_collection
    end

    def load_vacancies
      vacancy_ids = VacancyLoader.new(language:, client:).fetch

      vacancy_ids.each do |vacancy_id|
        sleep HeadHunterAnalytic.configuration.request_sleep_time
        response = client.vacancy(vacancy_id)
        @vacancy_collection << VacancyBuilder.build(response.body)
      end
    end

    def skills_stat
      vacancy_collection.flat_map(&:key_skills).each_with_object(Hash.new(0)) do |skill, hash|
        hash[skill] += 1
      end
    end

    def avg_salary
      all_avg_salaries = vacancy_collection.map(&:avg_salary).compact

      return 0 if all_avg_salaries.empty?

      (all_avg_salaries.sum / all_avg_salaries.size * 1.0).round
    end
  end
end
