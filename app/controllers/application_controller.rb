class ApplicationController < ActionController::Base
	# commented this to be able to access the api's without AuthenticityToken
  # protect_from_forgery with: :exception
end
