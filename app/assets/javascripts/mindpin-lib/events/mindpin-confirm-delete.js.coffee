pie.load ->
  jQuery(document).delegate 'a.page-jdelete', 'click', ->
    confirm = jQuery(this).data('jconfirm')

    jQuery(this).confirm_dialog confirm, =>

      href = jQuery(this).data('jhref')

      csrf_token = jQuery('meta[name=csrf-token]').attr('content')
      csrf_param = jQuery('meta[name=csrf-param]').attr('content')

      $form = jQuery("<form method='post' action='#{href}'></form>")
      metadata_input = "<input name='_method' value='delete' type='hidden' />"

      if (csrf_param != undefined && csrf_token != undefined)
        metadata_input += "<input name='#{csrf_param}' value='#{csrf_token}' type='hidden' />"

      $form.hide().append(metadata_input).appendTo('body')
      $form.submit()