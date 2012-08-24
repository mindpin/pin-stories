pie.load ->
  $for_story_form = jQuery('.add-ideas form')
  $add_link = jQuery('.add-idea a')

  $add_link.click ->
    $for_story_form.find('textarea').val('')
    $for_story_form.slideDown()

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