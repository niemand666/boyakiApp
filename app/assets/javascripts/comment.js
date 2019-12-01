$(document).on('turbolinks:load', function(){
  function buildHTML(comment){
    var html = `<div class="details__username">
                  <a href=/users/${comment.user_id}>
                    <img class="liked-users" src=${comment.user_image}>
                  </a>
                  ${comment.user_name}
                  <div class="details__comment">
                    <p>${comment.text}</p>
                  </div>
                  <div class="details__timezone">
                    ${comment.date}
                  </div>
                  <hr width="100%">
                </div>`
    return html;
  }

  $('#new_comment').on('submit', function(e){
    e.preventDefault();
    var formData = new FormData(this);
    var url = $(this).attr('action');
    $.ajax({
      url: url,
      type: "POST",
      data: formData,
      dataType: 'json',
      processData: false,
      contentType: false
    })
    //成功時の処理
    .done(function(data){
      var html = buildHTML(data);
      $('.details__comments-list').append(html);
      $('#new_comment')[0].reset();
      $('.comment-area').val('')
      $('.post').prop('disabled', false);
    })
    //エラー時の処理
    .fail(function(){
      alert("コメントの送信に失敗しました。");
    })
  })
})
