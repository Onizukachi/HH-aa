# frozen_string_literal: true

module HeadHunterAnalytic
  class Configuration
    attr_accessor :base_url, :request_sleep_time

    def initialize
      @base_url = 'https://api.hh.ru/'
      @request_sleep_time = 0.4
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configuration=(config)
    @configuration = config
  end

  def self.configure
    yield configuration
  end
end
