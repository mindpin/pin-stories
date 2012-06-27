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