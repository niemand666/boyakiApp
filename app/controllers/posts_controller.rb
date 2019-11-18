class PostsController < ApplicationController

  def index
    @posts = Post.includes(:user).order("created_at DESC").page(params[:page]).per(5)
    @user = current_user
  end


  def new
    @post = Post.new
  end


  def create
    @post = Post.new(post_params)
    @post.save

    if @post.save
      redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end


  def show
    @post = Post.find(params[:id])
    @user = User.find_by(id: @post.user_id)
    @comments = @post.comments.includes(:user).order("created_at DESC")
    @comments_count = Comment.where(post_id: @post.id).count
  end


  def edit
    @post = Post.find(params[:id])
  end


  def update
    @post = Post.find(params[:id])
  
    if @post.update(post_params)
      redirect_to @post
    else
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    @post = Post.find(params[:id])
    @post.destroy
  
    redirect_to posts_path
  end


  private
  def post_params
    params.require(:post).permit(:title,:content).merge(user_id: current_user.id)
  end
end
