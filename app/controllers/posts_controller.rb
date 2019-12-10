class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_search, only: :index
  impressionist actions: [:show]

  def index
    @posts = Post.recent.active.paginate(params)
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
      create_pictures and redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create_pictures
    unless params[:pictures].nil?
      params[:pictures]['picture'].reverse_each do |i|
        @picture = @post.pictures.create!(picture: i)
      end
    end
  end

  def show
    @user = User.find_by(id: @post.user_id)
    @pictures = @post.pictures
    @comments = @post.comments.recent.active
    @comments_count = Comment.where(post_id: @post.id).count
    @like = Like.new
    @likes = @post.likes.recent
    impressionist(@post, nil, unique: [:session_hash])
    @page_views = @post.impressionist_count
  end

  def edit
    gon.post = @post
    gon.pictures = @post.pictures
    gon.pictures_binary_datas = []
    require 'aws-sdk'
    require 'base64'

    if Rails.env.production?
      client = Aws::S3::Client.new(
        region: 'ap-northeast-1',
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        )
      @post.pictures.each do |image|
        binary_data = client.get_object(bucket: 'boyakiapp', key: image.picture.file.path).body.read
        gon.pictures_binary_datas << Base64.strict_encode64(binary_data)
      end
    else
      @post.pictures.each do |image|
        binary_data = File.read(image.picture.file.file)
        gon.pictures_binary_datas << Base64.strict_encode64(binary_data)
      end
    end
  end

  def update
    ids = @post.pictures.map{|image| image.id }
    exist_ids = registered_image_params[:ids].map(&:to_i)
    exist_ids.clear if exist_ids[0] == 0

    if @post.update(post_params)

      unless ids.length == exist_ids.length
        delete_ids = ids - exist_ids
        delete_ids.each do |id|
          @post.pictures.find(id).destroy
        end
      end
      
      unless new_image_params[:images][0] == " "
        params[:pictures]['picture'].reverse_each do |i|
          @picture = @post.pictures.create!(picture: i)
        end
      end
      redirect_to @post
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy and redirect_to user_path(current_user)
  end

  def search
    @search = Post.ransack(params[:q])
    @results = @search.result.recent.active.paginate(params)
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

  def registered_image_params
    params.require(:registered_images_ids).permit({ids: []})
  end

  def new_image_params
    params.require(:new_images).permit({images: []})
  end
end
