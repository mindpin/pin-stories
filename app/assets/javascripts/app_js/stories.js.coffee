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