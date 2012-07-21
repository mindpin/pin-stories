# @author ben7th
# @useage 在 dom 容器中加载图片的几种方法


# 在某个容器中加载其上的由 data-src 声明的图片，
# 并且图片通过调整以最佳自适应容器大小，填满容器同时避免宽高比变化

jQuery.fn.load_fit_image = (time)->
  src = this.data('src')
  time = time || 500

  if !src
    console.log('load_fit_image 方法必须声明 data-src')
    return

  that = this
  $img = jQuery("<img style='display:none;' src='#{src}' />")
    .bind 'load', ->
      $img.fadeIn(time)
      that.resize_fit_image()
    .appendTo(that.empty().show())

# 计算某容器内图片缩放宽度，高度，负margin
# 图片通过调整以最佳自适应容器大小，填满容器同时避免宽高比变化
# 分两步走：
#   1 如果宽度不等，调齐宽度，计算高度
#   2 如果此时高度不足，补齐高度
# 最后计算margin

jQuery.fn.resize_fit_image = ->
  $img = this.find('img')
  return if !$img.exists()

  box_width  = this.width()
  box_height = this.height()

  img_width  = $img.width()
  img_height = $img.height()

  # step 1 如果宽度不等，调齐宽度，计算高度
  w1 = box_width
  if img_width != box_width
    h1 = img_height * box_width / img_width
  else
    h1 = img_height
  
  # step 2 如果此时高度不足，补齐高度
  if h1 < box_height
    rh = box_height
    rw = w1 * box_height / h1
  else
    rh = h1
    rw = w1

  # set margin
  ml = (box_width  - rw) / 2
  mt = (box_height - rh) / 2

  $img
    .css('width', rw)
    .css('height', rh)
    .css('margin-left', ml)
    .css('margin-top', mt)