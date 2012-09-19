pie.load ->
  class CommentForm
    constructor: ($page_comments)->
      @$page_comments = $page_comments
      
      $form = $page_comments.find('form')

      @$input     = $form.find('textarea')
      @POST_URL   = $form.attr('action')
      @model_type = $form.find('input[name=model_type]').val()
      @model_id   = $form.find('input[name=model_id]').val()

    submit: ->
      content = jQuery.string(@$input.val()).strip().str
      return if jQuery.string(content).blank()

      # 判断是回复评论，还是新增评论
      reply_comment_id = @$input.data('reply-comment-id')
      $be_replied_comment = @$page_comments.find(".comments .comment[data-id=#{reply_comment_id}]")

      if $be_replied_comment.exists()
        user_name = $be_replied_comment.data('user-name')
        prefix = "回复@#{user_name}:"
        is_reply = jQuery.string(content).startsWith(prefix)

        if is_reply
          jQuery.ajax
            url: @POST_URL
            type: 'POST'
            data: {
              'reply_comment_id' : reply_comment_id
              'content'    : content
              'model_type' : @model_type
              'model_id'   : @model_id
            }
            success: (res)=>
              @comment_success(res)
          return

      # 新增评论
      jQuery.ajax
        url: @POST_URL
        type: 'POST'
        data:{
          'content'    : content
          'model_type' : @model_type
          'model_id'   : @model_id
        }
        success: (res)=>
          @comment_success(res)

    comment_success: (res)->
      $new_comment = jQuery(res).find('.comment')

      @$input.val('')

      @$page_comments.find('.comments .comment.blank').remove();
      @$page_comments.find('.comments').prepend($new_comment);

      $new_comment.hide().fadeIn(200);

      $next_comment = $new_comment.next('.comment')

      if $new_comment.data('user-name') == $next_comment.data('user-name')
        $next_comment.addClass('same-user')

    remove: ($delete_button)->
      $delete_button.confirm_dialog '确定删除吗', =>
        $comment = $delete_button.closest('.comment')
        comment_id = $comment.data('id')
        
        # DELETE
        jQuery.ajax
          url: "/comments/#{comment_id}"
          type: 'DELETE',
          success: ->
            $comment.fadeOut 200, ->
              $comment.next('.comment').removeClass('same-user')
              $comment.remove()

    prepare_reply: ($reply_button)->
      $comment = $reply_button.closest('.comment')
      user_name = $comment.data('user-name')
      reply_comment_id = $comment.data('id')

      prefix = "回复@#{user_name}:"
      @$input.focus().val(prefix).data('reply-comment-id', reply_comment_id)

  # 发评论

  # 此处分为 新增评论 和 回复评论 两个分支逻辑
  # 网页上的回复是比较繁琐的过程，当符合以下条件时，判断为是正在回复一条评论
  #   1 回复框上能够取得 data-reply-comment-id
  #   2 根据该 data-reply-comment-id 能够在当前页面显示的评论列表内找到对应评论的 dom
  #   3 当前评论框内的内容，以 '回复@用户名' 开头
  # 
  # 不符合条件的，都认为是普通的新增评论

  jQuery('.page-comments form a.form-submit-button').live 'click', ->
    $page_comments = jQuery(this).closest('.page-comments')
    new CommentForm($page_comments).submit()


  # 删除评论
  jQuery('.page-comments .comment .ops a.delete').live 'click', ->
    $page_comments = jQuery(this).closest('.page-comments')
    new CommentForm($page_comments).remove(jQuery(this))


  # 回复评论
  jQuery('.page-comments .comment .ops a.reply').live 'click', ->
    $page_comments = jQuery(this).closest('.page-comments')
    new CommentForm($page_comments).prepare_reply(jQuery(this))

