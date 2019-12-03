$(document).on('turbolinks:load', function(){
  let dropzone = $('.pictures-uploads-area');
  let images = [];
  let inputs  =[];
  let input_area = $('.pictures-uploads-area');
  let preview = $('#new-post-images-preview');

  $(document).on('change', 'input[type= "file"].upload-image',function() {
    let file = $(this).prop('files')[0];
    let reader = new FileReader();
    inputs.push($(this));
    let img = $(`<div class="img_view"><img></div>`);
    reader.onload = function(e) {
      let btn_wrapper = $('<div class="btn_wrapper"><div class="picture-btn edit">編集</div><div class="picture-btn delete">削除</div></div>');
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

    if(images.length == 5) {
      dropzone.css({
        'display': 'none'
      })
      return;
    }
    let new_image = $(`<input multiple= "multiple" name="pictures[picture][]" class="upload-image" data-image= ${images.length} type="file" id="upload-image" style="opacity:0;">`);
    input_area.prepend(new_image);
  });

  $(document).on('click', '.delete', function() {
    let target_image = $(this).parent().parent();
    $.each(inputs, function(index, input){
      if ($(this).data('image') == target_image.data('image')){
        $(this).remove();
        target_image.remove();
        let num = $(this).data('image');
        images.splice(num, 1);
        inputs.splice(num, 1);
        if(inputs.length == 0) {
          $('input[type= "file"].upload-image').attr({
            'data-image': 0
          })
        }
      }
    })

    let new_image = $(`<input multiple= "multiple" name="pictures[picture][]" class="upload-image" data-image= ${images.length} type="file" id="upload-image" style="opacity:0;">`);
    input_area.prepend(new_image);
    $.each(inputs, function(index, input) {
      let input = $(this)
      input.attr({
        'data-image': index
      })
      $('input[type= "file"].upload-image:first').after(input)
    })

      $.each(images, function(index, image) {
        image.attr('data-image', index);
        preview.append(image);
      })
      dropzone.css({
        'width': `calc(100% - (135px * ${images.length}))`
      })

    if(images.length == 4) {
      dropzone.css({
        'display': 'block'
      })
    }
    if(images.length == 3) {
      dropzone.find('i').replaceWith('<p>ココをクリックしてください</p>')
    }
  })
});
