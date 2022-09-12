class UsersController < ApplicationController
  include Pundit::Authorization
  include JSONAPI::Filtering
  include JSONAPI::Errors
  include JSONAPI::Deserialization

  before_action :set_user, except: :index

  rescue_from Pundit::NotAuthorizedError do |e|
    render json: { errors: [{ status: "403", title: "Forbidden", error: "You cannot delete or archive yourself" }] }, status: :forbidden
  end

  def index
    allowed = [ :archived ]

    jsonapi_filter(User.all, allowed) do |filtered|
      render jsonapi: filtered.result
    end
  end

  def destroy
    @user.destroy

    render jsonapi: @user
  end

  def archive
    if @user.update(jsonapi_deserialize(params, only: :archived))
      if @user.saved_change_to_archived?
        render jsonapi: @user
      else
        render json: { errors: [{ status: "422", title: "Unprocessable Change", error: "You cannot archive an archived user" }] }, status: :unprocessable_entity 
      end
    else
      render jsonapi_error: @user.errors
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
      authorize @user
    end
end
