# frozen_string_literal: true

require 'faraday'

module HeadHunterAnalytic
  module Connection
    def connection
      @connection ||= Faraday.new do |conn|
        conn.url_prefix = HeadHunterAnalytic.configuration.base_url
        conn.request :json
        conn.response :json, content_type: 'application/json'
        conn.adapter Faraday.default_adapter
      end
    end
  end
end
