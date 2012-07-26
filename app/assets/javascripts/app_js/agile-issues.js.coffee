pie.load ->
  $button = jQuery('.add-agile-issue a.open-dialog')

  return if !$button.exists()

  $button.click ->
    pie.show_page_overlay()
    jQuery('.page-inline-new-dialog')
      .show()
      .animate({'top' : 0})
      .find('textarea').val('')

  jQuery('.page-inline-new-dialog a.close').live 'click', ->
    $dialog = jQuery(this).closest('.page-inline-new-dialog')
    
    $dialog
      .animate({'top' : '-100%'}, ->
        $dialog.hide()
      )

    pie.hide_page_overlay()

  jQuery('.page-inline-new-dialog a.send').live 'click', ->
    $button = jQuery(this)
    $dialog = $button.closest('.page-inline-new-dialog')
    $form = $dialog.find('form')
    data = $form.serialize()
    url = $form.attr('action')

    if pie.is_form_all_need_filled($form)
      jQuery.ajax
        url: url
        type: 'POST'
        data: data
        dataType: 'json'
        success: (res)->
          $form.closest('.data-form').hide()
          $button.css('visibility','hidden')

          jQuery("<div>BUG发送成功，<a href='/products/1/issues'>前往查看</a></div>")
            .addClass('res success')
            .appendTo($dialog)
        error: ->
          $form.closest('.data-form').hide()
          $button.css('visibility','hidden')

          jQuery('<div>BUG发送失败</div>')
            .addClass('res error')
            .appendTo($dialog)
