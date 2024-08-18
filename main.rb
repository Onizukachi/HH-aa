# frozen_string_literal: true

require 'byebug'
require_relative 'lib/head_hunter_analytics'

HeadHunterAnalytics.configure do |config|
  config.base_url = 'https://api.hh.ru/'
  config.request_sleep_time = 0.1
end

client = HeadHunterAnalytics::Client.new

vacancy_collection = client.vacancies.collection('Ruby on Rails')
p vacancy_collection.skills_stat
p vacancy_collection.avg_salary

