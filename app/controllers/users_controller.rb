class UsersController < ApplicationController
  include JSONAPI::Filtering

  def index
    allowed = [ :archived ]

    jsonapi_filter(User.all, allowed) do |filtered|
      render jsonapi: filtered.result
    end
  end
end
