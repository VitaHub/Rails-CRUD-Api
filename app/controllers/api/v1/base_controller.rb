class Api::V1::BaseController < ApplicationController
  include Pundit
  include ActiveHashRelation

  protect_from_forgery with: :null_session,
      if: Proc.new { |c| c.request.format =~ %r{application/json} }

  before_action :destroy_session

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Pundit::NotAuthorizedError, with: :unauthorized!

  attr_accessor :current_user
  
  	protected

  def destroy_session
    request.session_options[:skip] = true
  end

  def unauthenticated!
    response.headers['WWW-Authenticate'] = "Token realm=Application"
    render json: { error: 'Bad credentials' }, status: 401
  end

  def unauthorized!
    render json: { error: 'not authorized' }, status: 403
  end

  def invalid_resource!(errors = [])
    api_error(status: 422, errors: errors)
  end

  def not_found
    return api_error(status: 404, errors: 'Not found')
  end

  def api_error(status: 500, errors: [])
    unless Rails.env.production?
      puts errors.full_messages if errors.respond_to? :full_messages
    end
    head status: status and return if errors.empty?

    render json: jsonapi_format(errors).to_json, status: status
  end

  def paginate(resource)

    resource = resource.page(1)
    resource = resource.per_page(200)

    if params[:page].present?
      resource = resource.page(params[:page].to_i)
    end
    
    if params[:per_page].present?
      resource = resource.per_page(params[:per_page].to_i)
    end

    return resource
  end

  def meta_attributes(object)
    {
      current_page: object.current_page,
      next_page: object.next_page,
      prev_page: object.previous_page,
      total_pages: object.total_pages,
      total_count: object.total_entries
    }
  end

   def authenticate_user!
    token, options = ActionController::HttpAuthentication::Token.token_and_options(request)

    user_email = options.blank?? nil : options[:email]
    user = user_email && User.find_by(email: user_email)

    if user && ActiveSupport::SecurityUtils.secure_compare(user.authentication_token, token)
      @current_user = user
    else
      return unauthenticated!
    end
  end

  private

  def jsonapi_format(errors)
    return errors if errors.is_a? String
    errors_hash = {}
    errors.messages.each do |attribute, error|
      array_hash = []
      error.each do |e|
        array_hash << {attribute: attribute, message: e}
      end
      errors_hash.merge!({ attribute => array_hash })
    end

    return errors_hash
  end
end