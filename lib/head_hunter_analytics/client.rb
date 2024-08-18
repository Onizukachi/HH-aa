# frozen_string_literal: true

require_relative 'response_handler'
require_relative 'retryable'
require_relative 'connection'
require 'ostruct'

module HeadHunterAnalytics
  class Client
    include Connection
    include Retryable

    def initialize
      @response_handler = ResponseHandler.new
    end

    def get(path, params = {})
      with_retries { @response_handler.handle(connection.get(path, params)) }
    end

    # Access the vacancies resource to perform operations.
    #
    # @example
    #   client.vacancies
    #
    # @return [ HeadHunterAnalytics::Resources::Vacancies::Resource ] entry to the vacancies resource.
    def vacancies
      Resources::Vacancies::Resource.new(self)
    end
  end
end
