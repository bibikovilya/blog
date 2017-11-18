class PostsController < ApplicationController

  def create
    ps = PostServices::Create.new(post_params)
    if ps.call
      render json: ps.post.as_json
    else
      render json: { errors: ps.errors }, status: 422
    end
  end

  def top
    ps = PostServices::Top.new(top_params[:count])
    if ps.call
      render json: ps.posts
    else
      render json: { errors: ps.errors }, status: 422
    end
  end

  private

  def post_params
    params.permit(:title, :body, :login, :ip)
  end

  def top_params
    params.permit(:count)
  end
end
