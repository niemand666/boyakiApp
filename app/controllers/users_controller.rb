class UsersController < ApplicationController
  before_action :set_user

  def show
    @posts = Post.where(user_id: @user.id).page(params[:page]).per(10).order("created_at DESC")
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
    @posts = Post.where(user_id: @users).page(params[:page]).per(10).order("created_at DESC")
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
end
