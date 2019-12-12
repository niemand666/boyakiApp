$(document).on('turbolinks:load', function(){
  if ($('#edit-pictures-form').length){
    var input_area = $(".pictures-uploads-area-edit");
    var preview = $("#edit-post-images-preview");

    // 登録済画像と新規追加画像を全て格納する配列（ビュー用）
    var images = [];
    // 登録済画像データだけの配列（DB用）
    var registered_images_ids = [];
    // 新規追加画像データだけの配列（DB用）
    var new_image_files = [];

    // 登録済画像のプレビュー表示
    gon.pictures.forEach(function(image, index){
      var img = $(`<div class= "img_view"><div class="img_area"><img class="image"></div></div>`);

      // カスタムデータ属性を付与
      img.data("image", index)

      var btn_wrapper = $('<div class="btn_wrapper"><a class="picture-btn edit">編集</a><a class="picture-btn delete">削除</a></div>');

      // 画像に編集・削除ボタンをつける
      img.append(btn_wrapper);

      binary_data = gon.pictures_binary_datas[index]

      // 表示するビューにバイナリーデータを付与
      img.find("img").attr({
        src: "data:image/jpeg;base64," + binary_data,
        width: '110px',
        height: '110px'
      });

      // 登録済画像のビューをimagesに格納
      images.push(img)
      registered_images_ids.push(image.id)

      $.each(images, function(index, image) {
        image.attr('data-image', index);
        preview.append(image);
      });

      var new_image = $(`<input multiple="multiple" name="pictures[picture][]" class="upload-image" data-image= ${images.length} type="file" id="upload-image" style="opacity:0;">`);
      input_area.prepend(new_image);
    });

    $(document).on("change", 'input[type="file"].upload-image', function() {
      var file = $(this).prop('files')[0];
      var reader = new FileReader();
      new_image_files.push($(this));
      var img = $(`<div class="img_view"><img></div>`);
      reader.onload = function(e) {
        var btn_wrapper = $('<div class="btn_wrapper"><div class="picture-btn edit">編集</div><div class="picture-btn delete">削除</div></div>');
        img.append(btn_wrapper);
        img.find('img').attr({
          src: e.target.result,
          width: '110px',
          height: '110px'
        })
      }
      reader.readAsDataURL(file);
      images.push(img);

      $.each(images, function(index, image) {
        image.attr('data-image', index);
        preview.append(image);
      })
    });

    $(document).on('click', '.delete', function(){
      // 削除ボタンを押した画像を取得
      var target_image = $(this).parent().parent();
      // 削除画像のdata-image番号を取得
      var target_image_num = target_image.data('image');
      // 対象の画像をビュー上で削除
      target_image.remove();
      // 対象の画像を削除した新たな配列を生成
      images.splice(target_image_num, 1);

      if (target_image_num < registered_images_ids.length){
        registered_images_ids.splice(target_image_num, 1);
      }else{
        new_image_files.splice((target_image_num - registered_images_ids.length), 1);
      }

      if(images.length == 0) {
        $('input[type= "file"].upload-image').attr({
          'data-image': 0
        })
      };
    });

    $('#edit-pictures-form').on('submit', function(e) {
      // 通常のsubmitイベントを止める
      e.preventDefault();
      // images以外のform情報をformDataに追加
      var formData = new FormData($(this).get(0));

      // 登録済画像が残っていない場合は便宜的に0を入れる
      if (registered_images_ids.length == 0) {
        formData.append('registered_images_ids[ids][]', 0)
        // 登録済画像で、まだ残っている画像があればidをformDataに追加していく
      } else {
        registered_images_ids.forEach(function(registered_image) {
          formData.append('registered_images_ids[ids][]', registered_image)
        });
      }

      // 新しく追加したimagesがない場合は便宜的に空の文字列を入れる
      if (new_image_files.length == 0) {
        formData.append("new_images[images][]", " ")
        // 新しく追加したimagesがある場合はformDataに追加する
      } else {
        new_image_files.forEach(function(file){
          formData.append("new_images[images][]", file)
        });
      }

      $.ajax({
        url:         '/posts/' + gon.post.id,
        type:        "PATCH",
        data:        formData,
        contentType: false,
        processData: false,
      })
    });
  }; 
});
