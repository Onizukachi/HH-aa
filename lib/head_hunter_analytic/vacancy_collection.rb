# frozen_string_literal: true

require 'forwardable'

module HeadHunterAnalytic
  class VacancyCollection
    include Enumerable
    extend Forwardable

    def_delegators :@vacancies, :size, :<<, :length, :[], :empty?, :last, :first, :index

    attr_reader :vacancies

    def initialize
      @vacancies = []
    end

    def each(&block)
      vacancies.each(&block)
    end
  end
end
