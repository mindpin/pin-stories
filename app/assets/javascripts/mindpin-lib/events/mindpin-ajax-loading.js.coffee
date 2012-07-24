pie.load ->
  jQuery(document.body)
    .bind 'ajaxStart', ->
      return if true == window.DONT_SHOW_AJAX_LOADING_BAR
      _show_loading_bar()

    .bind 'ajaxComplete', ->
      window.DONT_SHOW_AJAX_LOADING_BAR = false
      _hide_loading_bar()

  _show_loading_bar = ->
    jQuery('.ajax-loading-bar').remove()
    $bar = jQuery('<div class="ajax-loading-bar">正在加载 …</div>')
    jQuery(document.body).append($bar)
    $bar

  _hide_loading_bar = ->
    jQuery('.ajax-loading-bar').remove()

  pie.dont_show_loading_bar = ->
    window.DONT_SHOW_AJAX_LOADING_BAR = true