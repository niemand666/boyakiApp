class CommentsController < ApplicationController
  def create
    Comment.create(text: comment_params[:text], post_id: comment_params[:post_id], user_id: current_user.id)
    redirect_to root_path
  end

  private
  def comment_params
    params.permit(:text, :post_id)
  end
end
