pie.load ->
  $for_story_form = jQuery('.add-ideas form')
  $add_link = jQuery('.add-idea')

  $add_link.click ->
    $for_story_form.find('textarea').val('')
    $for_story_form.slideToggle()

  jQuery('.cancel-idea').click ->
    $for_story_form.find('textarea').val('')
    $for_story_form.slideUp()

  $for_story_form.find('.submit-idea').click ->
    $request = jQuery.ajax
      type: 'POST'
      url: $for_story_form.attr('action')
      data: $for_story_form.serialize()

    $request.success (response)->
      $('.add-ideas .ideas').html(response)
      $for_story_form.slideUp()

  jQuery('.idea .remove-idea').click ->
    jQuery(this).confirm_dialog '确定删除吗?', =>
      $request = jQuery.ajax
        type: 'DELETE'
        url: jQuery(this).data('url')

      $request.success =>
        jQuery(this).closest('.idea').slideUp()

