pie.load ->
  $stories = jQuery('.page-stories')
  if $stories.exists()
    $stories.masonry({
      itemSelector: '.product'
    })
    $stories.animate({
      'opacity': 1
    }, 200)

pie.load ->
  $stories = jQuery('.page-product-stories')
  if $stories.exists()
    $stories.masonry({
      itemSelector: '.stream, .product-headbar'
    })
    $stories.animate({
      'opacity': 1
    }, 200)


pie.load ->
  jQuery(document).delegate '.page-story-show .status .toggle-st', 'click', ->
    status = jQuery(this).data('status')
    story_id = jQuery(this).closest('.page-story-show').data('story-id')
    $status = jQuery(this).closest('.status')

    jQuery.ajax
      url: "/stories/#{story_id}/change_status"
      type: 'put'
      data: {'status' : status}
      success: (res)->
        $status.after(res).remove()