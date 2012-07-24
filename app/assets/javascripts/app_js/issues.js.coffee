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


#   $('.show-comment').live('click', function(){
#     var comment_elm = jQuery(this).closest('.show-comment');
#     var id = comment_elm.data('id');
#     $('#comment-box-' + id).show();
#   });

#   $('.cancel-comment').live('click', function(){
#     var elm = jQuery(this).closest('.cancel-comment');
#     var id = elm.data('id');

#     $('#comment-box-' + id).hide();
#   });


#   $('.add-comment').live('click', function(){
#     var elm = jQuery(this).closest('.add-comment');
#     var id = elm.data('id');
#     var content = $('#comment-issue-' + id).val();

#     $.ajax({
#       type: 'POST',
#       url: "/issue_comments/",
#       data: {comment: content, issue_id: id},
#       dataType: "html"
#     }).done(function ( data ) {
#       $('#issue-' + id + '-comments').html(data);
#     });

#   });


#   $('.del-comment').live('click', function(){
#     var r = confirm("确定删除!")
#     if (r == false) {
#       return false;
#     }
#     var elm = jQuery(this).closest('.del-comment');
#     var id = elm.data('id');

#     $.ajax({
#       type: 'DELETE',
#       url: "/issue_comments/" + id,
#       dataType: "html"
#     }).done(function ( data ) {
    
#     });

#     $('#comment-' + id + '-box').remove();
#   });


#   $('.show-reply').live('click', function(){
#     var elm = jQuery(this).closest('.show-reply');
#     var id = elm.data('id');
#     $('#reply-box-' + id).show();
#   });

#   $('.cancel-reply').live('click', function(){
#     var elm = jQuery(this).closest('.cancel-reply');
#     var id = elm.data('id');

#     $('#reply-box-' + id).hide();
#   });


#   $('.add-reply').live('click', function(){
#     var elm = jQuery(this).closest('.add-reply');
#     var id = elm.data('id');
#     var issue_id = elm.data('issue');
#     var content = $('#reply-content-' + id).val();

#     $.ajax({
#       type: 'POST',
#       url: "/issue_comments/reply",
#       data: {comment: content, id: id, issue_id: issue_id},
#       dataType: "html"
#     }).done(function ( data ) {
#       $('#issue-' + issue_id + '-comments').html(data);
#     });

#   });

# });    