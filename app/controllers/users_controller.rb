class UsersController < ApplicationController
  before_action :set_user

  def show
    @posts = Post.where(user_id: @user.id).active.paginate(params)
  end

  def following
    @users = @user.followings
    @followings_count = Relationship.where(user_id: @user.id).count
  end

  def followers
    @users = @user.followers
    @followers_count = Relationship.where(follow_id: @user.id).count
  end

  def timeline
    @users = @user.followings
    @posts = Post.where(user_id: @users).active.paginate(params)
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
end
