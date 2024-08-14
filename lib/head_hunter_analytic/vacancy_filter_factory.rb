# frozen_string_literal: true

require_relative 'vacancy_filters/base_filter'
Dir[File.join(__dir__, 'vacancy_filters', '*.rb')].each { |file| require_relative file }

module HeadHunterAnalytic
  class VacancyFilterFactory
    FACTORY_MATCHING = {
      'Ruby on Rails' => VacancyFilters::RubyFilter,
      '1C' => VacancyFilters::OneCFilter,
      'Angular' => VacancyFilters::AngularFilter,
      'C#' => VacancyFilters::SharpFilter,
      'DevOps' => VacancyFilters::DevopsFilter,
      'Go' => VacancyFilters::GoFilter,
      'Java' => VacancyFilters::JavaFilter,
      'Node.js' => VacancyFilters::NodeJsFilter,
      'PHP' => VacancyFilters::PhpFilter,
      'Python' => VacancyFilters::PythonFilter,
      'React' => VacancyFilters::ReactFilter,
      'Swift' => VacancyFilters::SwiftFilter,
      'Vue' => VacancyFilters::VueFilter
    }.freeze

    def self.create_filter(language)
      FACTORY_MATCHING[language] || VacancyFilters::BaseFilter
    end
  end
end
