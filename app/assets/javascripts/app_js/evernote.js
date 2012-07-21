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

// 导入笔记读条
jQuery(document).ready(function(){

  var status_elm = jQuery('.page-evernote-import-confirm span.status');
  var url = jQuery('.page-evernote-import-confirm form').attr('action');

  jQuery('.page-evernote-import-confirm .form-submit-button-no-default-event').live('click', function(){

    var guids  = [];
    jQuery('.page-evernote-import-confirm .notes .note').each(function(){
      var guid = jQuery(this).data('guid');
      guids.push(guid);
    })

    jQuery('.page-evernote-import-confirm form .field.submit a').hide();

    var repeat_deal = jQuery('.page-evernote-import-confirm form').serialize().split('repeat_deal=')[1]
    import_one(repeat_deal, guids, 0);
  })

  var import_one = function(repeat_deal, guids, index){
    if(index == guids.length){
      status_elm.html('导入完毕！');

      jQuery('a.form-cancel').show().html('返回');

      return;
    } // 导入完了


    var guid  = guids[index];
    var title = jQuery('.page-evernote-import-confirm .note[data-guid=' + guid + ']').data('title');

    console.log(repeat_deal, index, title, guid);

    status_elm.html("正在导入 " + (index + 1) + '/' + guids.length + ' ' + guid)

    jQuery.ajax({
      url  : url,
      type : 'post',
      data : {
        'guid' : guid,
        'title' : title,
        'repeat_deal' : repeat_deal
      },
      success : function(){
        import_one(repeat_deal, guids, index + 1);
      },
      error : function(){
        status_elm.html('导入出错');
      }
    })
  }

})