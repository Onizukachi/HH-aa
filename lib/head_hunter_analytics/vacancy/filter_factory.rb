# frozen_string_literal: true

require_relative 'filters/base_filter'
Dir[File.join(__dir__, 'filters', '*.rb')].each { |file| require_relative file }

module HeadHunterAnalytics
  module Vacancy
    class FilterFactory
      FACTORY_MATCHING = {
        'Ruby on Rails' => RubyFilter,
        '1C' => OneCFilter,
        'Angular' => AngularFilter,
        'C#' => SharpFilter,
        'DevOps' => DevopsFilter,
        'Go' => GoFilter,
        'Java' => JavaFilter,
        'Node.js' => NodeJsFilter,
        'PHP' => PhpFilter,
        'Python' => PythonFilter,
        'React' => ReactFilter,
        'Swift' => SwiftFilter,
        'Vue' => VueFilter
      }.freeze

      def self.create_filter(language)
        FACTORY_MATCHING[language] || BaseFilter
      end
    end
  end
end
