# 自动加载以下dom中的图片
# .auto-fit-image{:'data-src'=>'...'}

pie.load ->
  jQuery('div.auto-fit-image[data-src]').load_fit_image()