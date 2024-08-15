# frozen_string_literal: true

require 'byebug'
require_relative 'lib/head_hunter_analytics'

HeadHunterAnalytics.configure do |config|
  config.base_url = 'https://api.hh.ru/'
  config.request_sleep_time = 0.1
end

vacancy_collection = HeadHunterAnalytics::Vacancy::Loader.load(language: 'Ruby on Rails')
p vacancy_collection.collection
