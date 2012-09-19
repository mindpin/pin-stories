# @author ben7th
# 用于判断某元素是否在屏幕显示区域之内（以元素顶部是否高于屏幕底边为准）

# 用法:
#   jQuery(xxx).is_in_screen()
#   返回 
#     true  在屏幕内
#     false 不在屏幕内

jQuery.fn.is_in_screen = ->
  bottom = jQuery(window).height() + jQuery(window).scrollTop()
  elm_top = this.offset().top
  return elm_top < bottom