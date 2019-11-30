class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params)
    @post.create_notification_comment!(current_user, @comment.id)
    redirect_back(fallback_location: root_path)
  end

  private
  def comment_params
    params.require(:comment).permit(:text, :post_id).merge(user_id: current_user.id)
  end
end
