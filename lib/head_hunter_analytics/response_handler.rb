# frozen_string_literal: true

require_relative 'errors/error'
require_relative 'errors/bad_request'
require_relative 'errors/unauthorized'
require_relative 'errors/captcha_required'
require_relative 'errors/internal_server_error'
require_relative 'errors/not_found'
require_relative 'errors/too_many_requests'
require_relative 'errors/unprocessable_entity'

module HeadHunterAnalytics
  class ResponseHandler
    ERROR_MAP = {
      400 => BadRequest,
      401 => Unauthorized,
      403 => CaptchaRequired,
      404 => NotFound,
      429 => TooManyRequests,
      422 => UnprocessableEntity,
      500 => InternalServerError
    }.freeze

    def handle(response)
      raise error(response), response.body['description'] unless response.success?

      response
    end

    private

    def error(response)
      ERROR_MAP[Integer(response.status)] || Error
    end
  end
end
