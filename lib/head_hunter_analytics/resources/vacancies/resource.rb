# frozen_string_literal: true

require 'active_support/core_ext/array/extract_options'
require_relative 'filter_factory'
require_relative 'vacancy_builder'
require_relative 'vacancy_collection'

module HeadHunterAnalytics
  module Resources
    module Vacancies
      # Exposes the operations available for a collection of vacancies
      #
      # @see { HeadHunterAnalytics::Client.vacancies }
      class Resource < HeadHunterAnalytics::Resources::Base
        # rubocop:disable Metrics/AbcSize
        def list(params = {})
          params = params.dup

          params[:text] ||= ''
          params[:page] ||= 0
          params[:per_page] ||= 100
          params[:date_from] = (Date.today - params[:last_days]).iso8601 if params[:last_days]
          filter = params[:filter] || FilterFactory.create_filter(params[:text])

          response = client.get(make_path('vacancies'), params)
          OpenStruct.new(items: filter.call(response.body['items']), pages: response.body['pages'])
        end
        # rubocop:enable Metrics/AbcSize

        def show(id)
          response = client.get(make_path("vacancies/#{id}"))

          VacancyBuilder.build(response.body)
        end

        def collection(text, last_days = nil)
          ids = collect_ids(text, last_days)

          ids.each_with_object(VacancyCollection.new) do |vacancy_id, collection|
            sleep HeadHunterAnalytics.configuration.request_sleep_time
            collection << show(vacancy_id)
          end
        end

        private

        def collect_ids(text, last_days)
          ids = []

          first_response = list(text:, last_days:)
          ids.push(*extract_ids(first_response.items))

          (1..first_response.pages).each_with_object(ids) do |page, arr|
            sleep HeadHunterAnalytics.configuration.request_sleep_time

            response = list(text:, last_days:, page:)
            arr.push(*extract_ids(response.items))
          end
        end

        def extract_ids(data)
          data.map { |item| item['id'] }
        end
      end
    end
  end
end
