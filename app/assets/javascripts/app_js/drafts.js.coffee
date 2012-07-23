pie.load ->
  $form = jQuery('.page-new-story form')
  if $form.exists()
    $save_draft_button = $form.find('a.save-draft')

    $save_draft_button.bind 'click', ->
      save_as_draft()

    save_as_draft = ->
      params = $form.serialize()

      jQuery.ajax {
        type: 'POST',
        url: "/stories/save_new_draft",
        data: params,
        success: (res)->
          console.log(res)
          $form.find('input[name=draft_temp_id]').val(res)
          now = new Date()
          $form.find('.draft-status-notice')
            .html("草稿保存于 #{now.getFormatValue('yyyy-MM-dd hh:mm:ss')}")
            .hide().fadeIn(500)
      }

    # setInterval("save_as_draft()", 30000)