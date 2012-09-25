# 删除选项
  jQuery('a.delete-story-attach, a.delete-issue-attach').live 'click', ->
    $item = jQuery(this).closest('.item')

    # 如果就剩一项了，那么不再可删除
    $list = $item.closest('.item-list')
    if $list.find('.item').length == 1
      return

    $item.remove()

  # 增加选项
  jQuery('.add-story-attach, .add-issue-attach').live 'click', ->
    $list = jQuery(this).closest('.items').find('.item-list')
    $item = $list.find('.item').first().clone()
    
    $item
      .find('input').val('').end()
      .appendTo($list)
