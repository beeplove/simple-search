class ApplicationController < ActionController::API
  #
  # To standarize the error response
  # TODO:
  #   - for now keeping all error response same
  #
  rescue_from StandardError do |exception|
    raise exception if Rails.env.development?
    render json: {
      status: 'error',
      error: {
        message: 'something happened which was not quite expected',
        code: 1000
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
