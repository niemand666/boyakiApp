class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_search, only: :index
  impressionist actions: [:show]

  def index
    @posts = Post.includes(:user).order("created_at DESC").page(params[:page]).per(5)
    @user = current_user
  end

  def new
    @post = Post.new
    @picture = @post.pictures.build
  end

  def create
    @post = Post.new(post_params)
    @post.save
    if @post.save
      unless params[:pictures].nil?
        params[:pictures]['picture'].reverse_each do |i|
          @picture = @post.pictures.create!(picture: i)
        end
      end
      redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find_by(id: @post.user_id)
    @pictures = @post.pictures
    @comments = @post.comments.includes(:user).order("created_at DESC")
    @comments_count = Comment.where(post_id: @post.id).count
    @like = Like.new
    @likes = @post.likes.includes(:user)
    impressionist(@post, nil, unique: [:session_hash])
    @page_views = @post.impressionist_count
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to user_path(current_user)
  end

  def search
    @search = Post.ransack(params[:q])
    @results = @search.result.includes(:user).order("created_at DESC").page(params[:page]).per(5)
  end

  private
  def post_params
    params.require(:post).permit(
      :title,
      :content,
      {pictures_attributes: [:picture, :_destroy, :id]}
    ).merge(user_id: current_user.id)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def set_search
    @search = Post.ransack(params[:q])
  end
end
