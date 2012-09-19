# 通过 a.form-submit-button 提交表单
# 如果按钮是 disabled 状态，不允许提交
# 如果按钮时 stop 状态，也不允许提交
pie.load ->
  jQuery('form a.form-submit-button').live 'click', ->
    $button = jQuery(this)
    return if $button.hasClass('disabled')
    return if $button.hasClass('stop')

    $form = $button.closest('form')
    if pie.is_form_all_need_filled($form)
      $form.submit()

pie.load ->
  jQuery('form.page-search-bar a.go').live 'click', ->
    $form = jQuery(this).closest('form')
    if pie.is_form_all_need_filled($form)
      $form.submit()

# 按回车时，跳到还没有填写的必填字段
# 如果所有字段必填字段都已经填写了，则如果表单上有
#   data-enter-to-submit = true
#   提交表单

pie.load ->
  jQuery('form .field input').live 'keypress', (evt)->
    if evt.keyCode == 13 # 回车
      evt.preventDefault()

      $form = jQuery(this).closest('form')

      is_all_need_filled = pie.is_form_all_need_filled($form)
      enter_to_submit = $form.data('enter-to-submit') || $form.data('enter-to-submit') == ''

      if is_all_need_filled && enter_to_submit
        $form.submit()


# 在页面使用如下结构时
# form
#   .field.placeholder
#     %label 提示文字
#     %input
#
# 自动加载 placeholder 扩展
pie.load ->
  jQuery('form .field.placeholder input').each ->
    jQuery(this).placeholder()


# 加载 jcheckbox 事件
pie.load ->
  jQuery('.pie-j-checkbox span.c, .pie-j-checkbox a.text').live 'click', ->
    $jelm = jQuery(this).closest('.pie-j-checkbox')

    $span = $jelm.find('span.c')
    $checkbox = $span.find('input[type=checkbox]')
    if $span.hasClass('checked')
      $span.removeClass('checked')
      $checkbox.attr('checked', false)
    else
      $span.addClass('checked')
      $checkbox.attr('checked', true)

# 检查表单是否把所有必填字段填写完整的方法
pie.is_form_all_need_filled = ($form)->
  all_need_is_filled = true

  $form.find('.field.need').each ->
    $ipt = jQuery(this).find('input, textarea')
    if $ipt.val() == ''
      $ipt[0].focus()
      all_need_is_filled = false
      return false

  return all_need_is_filled