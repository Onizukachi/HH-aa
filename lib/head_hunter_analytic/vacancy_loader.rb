# frozen_string_literal: true

module HeadHunterAnalytic
  # fetches filtered vacancy ids for a specific language
  class VacancyLoader
    def initialize(language:, client:)
      @language = language
      @client = client
      @filter = VacancyFilterFactory.create_filter(language)
      @vacancy_ids = []
    end

    def fetch
      first_response = client.vacancies(text: language)
      urls = extract_vacancy_ids(filter.call(first_response.body['items']))
      @vacancy_ids.push(*urls)

      (1..first_response.pages).each do |page|
        sleep HeadHunterAnalytic.configuration.request_sleep_time
        response = client.vacancies(text: language, page:)

        @vacancy_ids.push(*extract_vacancy_ids(filter.call(response.body['items'])))
      end

      @vacancy_ids
    end

    private

    attr_reader :client, :language, :filter

    def extract_vacancy_ids(data)
      data.map { |item| item['id'] }
    end
  end
end
