class RatesController < ApplicationController
  def create
    ps = PostServices::AddMark.new(rate_params)
    if ps.call
      render json: ps.average_rate
    else
      render json: { errors: ps.errors }, status: 422
    end
  end

  private

  def rate_params
    params.permit(:post_id, :mark)
  end
end
