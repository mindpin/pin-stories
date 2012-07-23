// confirm对话框，取代系统默认
jQuery.fn.confirm_dialog = function(str, func){
  var elm = jQuery(this);
  var off = elm.offset();

  func == func || function(){};

  var dialog_elm = jQuery(
    '<div class="page-confirm-dialog popdiv">'+
      '<div class="d">'+
        '<div class="data">'+str+'</div>'+
        '<div class="btns">'+
          '<a class="button editable-submit" href="javascript:;">确定</a>'+
          '<a class="button editable-cancel" href="javascript:;">取消</a>'+
        '</div>'+
      '</div>'+
    '</div>'
  );

  jQuery('.page-confirm-dialog').remove();
  dialog_elm.css('left',off.left - 100 + elm.outerWidth()/2).css('top',off.top - 83);
  jQuery('body').append(dialog_elm);

  dialog_elm.hide().fadeIn(200);
  pie.show_page_overlay();

  jQuery('.page-confirm-dialog .editable-submit').unbind();
  jQuery('.page-confirm-dialog .editable-submit').bind('click',function(){
    jQuery('.page-confirm-dialog').remove();
    pie.hide_page_overlay();
    func();
  });
}

jQuery('.page-confirm-dialog .editable-cancel').live('click',function(){
  jQuery('.page-confirm-dialog').remove();
  pie.hide_page_overlay();
})