# 通过 a.form-submit-button 提交表单
# 如果按钮是 disabled 状态，不允许提交
pie.load ->
  jQuery('form a.form-submit-button').live 'click', ->
    $button = jQuery(this)
    return if $button.hasClass('disabled')
    $button.closest('form').submit()


# 通过回车键提交 form.enter-to-submit 表单
pie.load ->
  jQuery('form[data-enter-to-submit=true] input').live 'keypress', (evt)->
    if evt.keyCode == 13 # 回车
      jQuery(this).closest('form').submit()


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