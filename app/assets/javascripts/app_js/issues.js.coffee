pie.load ->

  # 编辑 issue
  jQuery('.page-product-issues .issue a.edit-issue').live 'click', ->
    jQuery(this).confirm_dialog '功能还未实现', ->
      console.log(1)

  # 删除 issue
  jQuery('.page-product-issues .issue a.delete-issue').live 'click', ->
    $delete = jQuery(this)
    $issue = $delete.closest('.issue')

    $delete.confirm_dialog '确定要删除吗', ->
      id = $issue.data('id')
      jQuery.ajax
        url: "/issues/#{id}"
        type: 'DELETE'
        success: (res)->
          $issue.fadeOut 200, ->
            $issue.remove()

  # 评论
  jQuery('.page-product-issues .issue a.comments-count').live 'click', ->
    $issue = jQuery(this).closest('.issue')
    model_id = $issue.data('id')
    model_type = 'Issue'

    if $issue.find('.page-comments').exists()
      $issue.find('.page-comments').fadeOut 200, ->
        $issue.find('.page-comments').remove()
    else
      jQuery.ajax
        url: '/comments/show_model_comments'
        type: 'GET'
        data: {
          'model_id' : model_id
          'model_type' : model_type
        }
        success: (res)->
          $comments = jQuery(res)
          $comments.appendTo($issue).hide().fadeIn(200)

  # 打开/关闭 issue
  jQuery('.page-issue-show .state-change a.close').live 'click', ->
    $show = jQuery(this).closest('.page-issue-show')
    id = $show.data('id')
    jQuery.ajax
      url: "/issues/#{id}/close"
      type: 'PUT'
      success: (res)->
        $new = jQuery(res)
        $show.before($new).remove()

  jQuery('.page-issue-show .state-change a.reopen').live 'click', ->
    $show = jQuery(this).closest('.page-issue-show')
    id = $show.data('id')
    jQuery.ajax
      url: "/issues/#{id}/reopen"
      type: 'PUT'
      success: (res)->
        $new = jQuery(res)
        $show.before($new).remove()

  # 暂缓 issue
  jQuery('.page-issue-show .state-change a.pause').live 'click', ->
    $show = jQuery(this).closest('.page-issue-show')
    id = $show.data('id')
    jQuery.ajax
      url: "/issues/#{id}/pause"
      type: 'PUT'
      success: (res)->
        $new = jQuery(res)
        $show.before($new).remove()


# $(document).ready(function(){
#   $('.edit-issue').live('click', function(){
#     var elm = jQuery(this).closest('.edit-issue');
#     var id = elm.data('id');

#     $('#content-' + id).hide();
#     $('#edit-box-' + id).show();
#   });

#   $('.cancel').live('click', function(){
#     var cancel_elm = jQuery(this).closest('.cancel');
#     var id = cancel_elm.data('id');

#     $('#content-' + id).show();
#     $('#edit-box-' + id).hide();
#   });

#   $('.update').live('click', function(){
#     var update_elm = jQuery(this).closest('.update');
#     var id = update_elm.data('id');
#     var content = $('#edit-content-' + id).val();

#     $.ajax({
#       type: 'PUT',
#       url: "/products/#{@product.id}/issues/" + id,
#       data: {content: content},
#       dataType: "html"
#     }).done(function ( data ) {
#       if (data != '') {
#         $('#content-' + id).html(data);
#         $('#edit-content-' + id).html(data);
#       }
      
#     });

#     $('#content-' + id).show();
#     $('#edit-box-' + id).hide();
#   });