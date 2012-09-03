# 领取分配对象
pie.load ->
  jQuery(document).delegate '.page-user-assigns .assign-to-me a.do-assign-to-me', 'click', ->
    $assigns = jQuery(this).closest('.page-user-assigns')

    id = $assigns.data('id')
    type = $assigns.data('type')

    jQuery.ajax
      url: '/user_assigns/assign_to_me'
      type: 'POST'
      data:
        model_id: id
        model_type: type
      success: (res)->
        $new_assigns = jQuery(res)
        $assigns.after($new_assigns).remove()