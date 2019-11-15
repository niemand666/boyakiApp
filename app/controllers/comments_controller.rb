class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    #@comment = @post.comments.create(comment_params)
    Comment.create!(text: comment_params[:text], post_id: comment_params[:post_id], user_id: current_user.id)
    redirect_to post_path(@post)
  end

  private
  def comment_params
    params.permit(:text, :post_id)
    #params.require(:comment).permit(:text)
  end
end
