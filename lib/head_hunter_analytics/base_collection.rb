# frozen_string_literal: true

require 'forwardable'

module HeadHunterAnalytics
  class BaseCollection
    include Enumerable
    extend Forwardable

    def_delegators :@collection, *[].public_methods

    attr_reader :collection

    def initialize
      @collection = []
    end

    def each(&)
      collection.each(&)
    end
  end
end
