# frozen_string_literal: true

require 'active_support/core_ext/array/extract_options'

module HeadHunterAnalytics
  module Retryable
    # These errors will be handled automatically
    DEFAULT_ERROR_CLASSES = [
      CaptchaRequired,
      TooManyRequests
    ].freeze

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def with_retries(*args)
      options = args.extract_options!
      exceptions = args

      options[:max_retry] ||= HeadHunterAnalytics.configuration.max_retry
      options[:sleep_time] ||= HeadHunterAnalytics.configuration.request_sleep_time
      options[:sleep_multiplier] ||= HeadHunterAnalytics.configuration.sleep_multiplier
      exceptions = DEFAULT_ERROR_CLASSES if exceptions.empty?

      retried = 0
      begin
        yield
      rescue *exceptions => e
        if retried >= options[:max_retry]
          puts "Retryable failed after #{retried} attempts, exception: #{e}"
          raise e
        end

        retried += 1
        sleep(options[:sleep_time])
        options[:sleep_time] *= options[:sleep_multiplier]
        puts "Retry #{retried}  #{e.class}: #{e.message}"
        retry
      end
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize
  end
end
