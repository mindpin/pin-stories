pie.load ->
  # 删除选项
  jQuery('.page-http-api-form .item-list .item a.delete').live 'click', ->
    $item = jQuery(this).closest('.item')

    # 如果就剩一项了，那么不再可删除
    $list = $item.closest('.item-list')
    if $list.find('.item').length == 1
      return

    $item.remove()

  # 增加选项
  jQuery('.page-http-api-form form .add-new-item').live 'click', ->
    $list = jQuery(this).closest('.items').find('.item-list')
    $item = $list.find('.item').first().clone()
    
    $item
      .find('input').val('').end()
      .appendTo($list)


  # jQuery('.page-http-api-form form .add-new-item').click(function(){
  #   var item_elm = jQuery('<div class="item"></div>')
  #   .append(jQuery('<input type="text" name="http_api[http_api_params_attributes][][name]" />'))
  #   .append(jQuery('<select name="http_api[http_api_params_attributes][][need]"><option value="1">必须</option><option value="0">可选</option></select>'))
  #   .append(jQuery('<input type="text" name="http_api[http_api_params_attributes][][desc]" />'))
  #   .append(jQuery('<a class="delete" href="javascript:;">删除</a>'))
  #   .appendTo(jQuery(this).closest('.field').find('.item-list'));
  # });