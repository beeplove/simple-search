class ApplicationController < ActionController::API
  #
  # To standarize the error response
  # TODO: for now keeping all error response same
  #
  rescue_from StandardError do |exception|
    render json: {
      status: 'error',
      error: {
        message: 'something happened which was not quite expected',
        code: 1000
      }
    }, status: :ok
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
