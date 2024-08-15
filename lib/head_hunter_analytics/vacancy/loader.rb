# frozen_string_literal: true

require_relative 'filter_factory'
require_relative 'collection'
require_relative 'builder'

module HeadHunterAnalytics
  module Vacancy
    class Loader
      def initialize(language:, client: HeadHunterAnalytics::Client.new)
        @language = language
        @client = client
        @filter = FilterFactory.create_filter(language)
        @vacancy_collection = Collection.new
      end

      def self.load(**args)
        new(**args).load
      end

      def load
        fetch_ids
        fetch_vacancies
      end

      private

      attr_reader :client, :language, :filter

      def fetch_ids
        @vacancy_ids = []

        first_response = client.vacancies(text: language)
        ids = extract_vacancy_ids(filter.call(first_response.body['items']))
        @vacancy_ids.push(*ids)

        (1..first_response.pages).each do |page|
          sleep HeadHunterAnalytics.configuration.request_sleep_time
          response = client.vacancies(text: language, page:)

          @vacancy_ids.push(*extract_vacancy_ids(filter.call(response.body['items'])))
        end
      end

      def fetch_vacancies
        @vacancy_ids.each do |vacancy_id|
          sleep HeadHunterAnalytics.configuration.request_sleep_time
          response = client.vacancy(vacancy_id)
          @vacancy_collection << Builder.build(response.body)
        end

        @vacancy_collection
      end

      def extract_vacancy_ids(data)
        data.map { |item| item['id'] }
      end
    end
  end
end
