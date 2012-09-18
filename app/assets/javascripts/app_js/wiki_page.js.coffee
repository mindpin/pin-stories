# wiki 新建预览
pie.load ->
  bind_preview = ($form)->
    $form.find('a.form-preview').live 'click', ->
      url = $form.find('.form-url-preview').data('url')
      data = $form.find('[name!=_method]').serialize()

      $preview_result = $form.find('.preview_result')
      $preview_result.html('正在生成预览...')

      jQuery.ajax
        url: url,
        type: 'POST'
        data: data
        success: (res)->
          $preview_result.html(res)
        error: ->
          $preview_result.html('无法创建预览')

  bind_preview(jQuery('.page-new-wiki-page form'))
  bind_preview(jQuery('.page-edit-wiki-page form'))

  # 保存草稿
  $form = jQuery('.page-new-wiki-page form')
  if $form.exists()
    $save_draft_button = $form.find('a.save-draft')

    $save_draft_button.bind 'click', ->
      save_as_draft()

    save_as_draft = ->
      params = $form.serialize()

      jQuery.ajax {
        type: 'POST',
        url: "/wiki_save_draft",
        data: params,
        success: (res)->
          console.log(res)
          $form.find('input[name=draft_temp_id]').val(res)
          now = new Date()
          $form.find('.draft-status-notice')
            .html("草稿保存于 #{now.getFormatValue('yyyy-MM-dd hh:mm:ss')}")
            .hide().fadeIn(500)
      }
      
    setInterval("save_as_draft()", 30000)
  # 结束 保存草稿

# 输入表单体验改进
pie.load ->
  FOCUS = false

  jQuery(document).live 'keydown', (evt)->
    key_code = evt.keyCode

    if FOCUS
      $textarea = jQuery('.page-new-wiki-page form textarea, .page-edit-wiki-page form textarea')
      dom = $textarea[0]

      start_pos = dom.selectionStart
      end_pos = dom.selectionEnd
      cursor_pos = start_pos
      str = dom.value
      scroll_top = $textarea.scrollTop()

      switch key_code
        when 9
          evt.preventDefault()
          dom.value = str.substring(0, start_pos) + '  ' + str.substring(end_pos, str.length)
          dom.selectionStart = dom.selectionEnd = (cursor_pos + 2)
          $textarea.scrollTop(scroll_top)

        when 8
          if start_pos == end_pos && str.substring(start_pos - 2, start_pos) == '  '
            evt.preventDefault()
            dom.value = str.substring(0, start_pos - 2) + str.substring(start_pos, str.length)
            dom.selectionStart = dom.selectionEnd = (cursor_pos - 2)
            $textarea.scrollTop(scroll_top)

  jQuery('.page-new-wiki-page form textarea, .page-edit-wiki-page form textarea')
    .live 'focus', ->
      FOCUS = true

    .live 'blur', ->
      FOCUS = false

