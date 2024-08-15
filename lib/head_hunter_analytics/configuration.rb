# frozen_string_literal: true

module HeadHunterAnalytics
  class Configuration
    attr_accessor :base_url, :request_sleep_time, :max_retry, :sleep_multiplier

    def initialize
      @base_url = 'https://api.hh.ru/'
      @request_sleep_time = 0.4
      @sleep_multiplier = 2
      @max_retry = 10
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
