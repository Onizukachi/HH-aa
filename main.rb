# frozen_string_literal: true

require 'byebug'
require_relative './lib/head_hunter_analytic'


# Передаем апи ключ в конфиг
# HeadHunterAnalytic.configure do |config|
#   config.base_url = 'https://api.hh.ru/'
# end

analytic = HeadHunterAnalytic::Analytic.new(language: 'Ruby on Rails')
analytic.load_vacancies
# p analytic.vacancies
