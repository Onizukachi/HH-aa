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

    def vacancies(params = {})
      text = params[:text] || ''
      page = params[:page] || 0
      per_page = params[:per_page] || 100

      response = with_retries do
        @response_handler.handle(connection.get('vacancies') do |req|
          req.params['text'] = text
          req.params['page'] = page
          req.params['per_page'] = per_page
        end)
      end

      p response.status
      OpenStruct.new(body: response.body, pages: response.body['pages'])
    end

    def vacancy(id)
      response = with_retries do
        @response_handler.handle(connection.get("vacancies/#{id}"))
      end

      p response.status
      OpenStruct.new(body: response.body)
    end
  end
end
