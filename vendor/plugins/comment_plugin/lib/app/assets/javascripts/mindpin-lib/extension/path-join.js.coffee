# @author fushang318
# @useage 拼接路径，类似于 ruby 中的 File.join

# jQuery.path_join('abc', '123', '/test')
#   -> 'abc/123/test'

jQuery.extend
  path_join: ->
    path = ''

    for _str in arguments
      str = "#{_str}"
      str = str
        .replace /// ^/ ///, ''
        .replace /// /$ ///, ''

      path = "#{path}/#{str}" if str != ''

    return path