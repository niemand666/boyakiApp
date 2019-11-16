class CommentsController < ApplicationController
  def create
    Comment.create(text: comment_params[:text], post_id: comment_params[:post_id], user_id: current_user.id)
    redirect_to root_path
    #post = Post.find(params[:post_id])
    #post.comments.create params[:comment]
    #@comment = @post.comments.create(comment_params)
    #@comment = Comment.new(text: params[:text], post_id: params[:post_id], user_id: params[:user_id])
    #@comment.save
    #@comment = post.comments.build(comment_params)
    #@comment = Comment.create!(text: comment_params[:text], post_id: comment_params[:post_id], user_id: current_user.id)
    #redirect_to post_path(@post)
    #(text: comment_params[:text], post_id: comment_params[:post_id], user_id: current_user.id)
  end

  private
  def comment_params
    params.permit(:text, :post_id)
    #params.require(:comment).permit(:text)
  end
end
