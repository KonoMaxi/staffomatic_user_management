class UsersController < ApplicationController
  include Pundit::Authorization
  include JSONAPI::Filtering
  include JSONAPI::Errors

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

  private

    def set_user
      @user = User.find(params[:id])
      authorize @user
    end
end
