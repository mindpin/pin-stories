// wiki 新建预览
jQuery(document).ready(function(){
  var bind_preview = function(form_elm){
    form_elm.find('a.form-preview').live('click', function(){
      var url = form_elm.find('.form-url-preview').data('url');

      var title   = form_elm.find('#wiki_page_title').val();
      var content = form_elm.find('#wiki_page_content').val();
      var preview_result_elm = form_elm.find('.preview_result');

      preview_result_elm.html('正在生成预览...');
      jQuery.post(
        url, 
        { 
          title : title,
          content : content
        },
        function(data) {
          preview_result_elm.html(data);        
        }
      );
    })
  }

  bind_preview(jQuery('.page-new-wiki-page form'));
  bind_preview(jQuery('.page-edit-wiki-page form'));

});

// 输入表单体验改进
jQuery(document).ready(function(){

  var FOCUS = false;

  jQuery(document).live('keydown', function(evt){
    var key_code = evt.keyCode;
    // console.log(key_code);

    if(FOCUS){
      var elm = jQuery('.page-new-wiki-page form textarea, .page-edit-wiki-page form textarea');
      var dom = elm[0];

      var start_pos = dom.selectionStart;
      var end_pos = dom.selectionEnd;
      var cursor_pos = start_pos;
      var str = dom.value;
      var scroll_top = elm.scrollTop();

      if(9 == key_code){  // press tab
        evt.preventDefault();
        dom.value = str.substring(0, start_pos) + '  ' + str.substring(end_pos, str.length);
        dom.selectionStart = dom.selectionEnd = (cursor_pos + 2);
        elm.scrollTop(scroll_top);
      }

      if(8 == key_code){  //press backspace
        if(start_pos == end_pos && str.substring(start_pos - 2, start_pos) == '  '){
          evt.preventDefault();
          dom.value = str.substring(0, start_pos - 2) + str.substring(start_pos, str.length);
          dom.selectionStart = dom.selectionEnd = (cursor_pos - 2);
          elm.scrollTop(scroll_top);
        }
      }
    }
  })

  jQuery('.page-new-wiki-page form textarea, .page-edit-wiki-page form textarea')
    .live('focus', function(){
      FOCUS = true;
    })
    .live('blur', function(){
      FOCUS = false;
    });
})