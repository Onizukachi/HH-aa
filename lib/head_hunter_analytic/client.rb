# frozen_string_literal: true

require_relative 'error'
require 'ostruct'

module HeadHunterAnalytic
  class Client
    include Connection

    def vacancies(params = {})
      text = params[:text] || ''
      page = params[:page] || 0
      per_page = params[:per_page] || 100

      response = handle_response(connection.get('vacancies') do |req|
        req.params['text'] = text
        req.params['page'] = page
        req.params['per_page'] = per_page
      end)

      OpenStruct.new(body: response.body, pages: response.body['pages'])
    end

    def vacancy(id)
      response = handle_response(connection.get("vacancies/#{id}"))

      OpenStruct.new(body: response.body)
    end

    private

    def handle_response(response)
      p response.status
      raise HeadHunterAnalytic::Error, 'An error happened while making your request' unless response.success?

      response
    end
  end
end
