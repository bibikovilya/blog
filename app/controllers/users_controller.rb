class UsersController < ApplicationController
  def index
    render json: UserServices::GetIps.call
  end
end
