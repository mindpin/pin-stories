jQuery(document).ready(function(){

  // 初始化选项
  var form_elm = jQuery('.page-evernote-notebook-list form');

  form_elm
    .find('.all-notebook input').attr('checked', true).end()
    .find('.notebooks .notebook input').attr('checked', false).css('opacity', 0.2).end()
    .find('.all-tag input').attr('checked', true).end()
    .find('.tags .tag input').attr('checked', false).css('opacity', 0.2).end()

  // events
  form_elm

    .find('.all-notebook input').live('click', function(){
      if(jQuery(this).attr('checked')){
        form_elm.find('.notebooks .notebook input').attr('checked', false).css('opacity', 0.2);
      }else{
        form_elm.find('.notebooks .notebook input').css('opacity', 1);
      }
    }).end()

    .find('.notebooks .notebook input').live('click', function(){
      if(jQuery(this).attr('checked')){
        form_elm.find('.all-notebook input').attr('checked', false);
        form_elm.find('.notebooks .notebook input').css('opacity', 1);
      }
    }).end()

    .find('.all-tag input').live('click', function(){
      if(jQuery(this).attr('checked')){
        form_elm.find('.tags .tag input').attr('checked', false).css('opacity', 0.2);
      }else{
        form_elm.find('.tags .tag input').css('opacity', 1);
      }
    }).end()

    .find('.tags .tag input').live('click', function(){
      if(jQuery(this).attr('checked')){
        form_elm.find('.all-tag input').attr('checked', false);
        form_elm.find('.tags .tag input').css('opacity', 1);
      }
    }).end()

})