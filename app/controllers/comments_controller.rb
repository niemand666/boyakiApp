class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params)
    respond_to do |format|
      format.html { redirect_to post_path(params[:post_id]) }
      format.json
    end
    @post.create_notification_comment!(current_user, @comment.id)
  end

  private
  def comment_params
    params.require(:comment).permit(:text, :post_id).merge(user_id: current_user.id)
  end
end
