json.text  @comment.text
json.date  @comment.created_at.strftime("%Y/%m/%d %H:%M")
json.user_id  @comment.user.id
json.user_name  @comment.user.nickname
json.user_image  @comment.user.image.url