# TODO: find a good home to keep custom exceptions
class QueryParamError < StandardError ; end

class ApplicationController < ActionController::API
  #
  # TODO:
  #   - for now keeping almost all error response same
  #
  # To standarize the error response
  #
  rescue_from StandardError do |exception|
    raise exception if (Rails.env.development? && params[:force].blank?) || params[:debug].present?

    message = 'something happened which was not quite expected'
    code = 1000

    if exception.class == QueryParamError
      message = exception.message
      code = 2000
    end

    render json: {
      status: 'error',
      error: {
        message: message,
        code: code
      }
    }, status: :unprocessable_entity
  end

  #
  # To standarize the api response
  #
  def jsonator data
    render json: {
      status: 'success',
      data: data
    }, status: :ok
  end
end
