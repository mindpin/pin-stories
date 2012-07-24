# 产生一个随机字符串
def randstr(length = 8)
  base = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
  size = base.size
  re = '' << base[rand(size - 10)]
  (length - 1).times {
    re << base[rand(size)]
  }
  return re
end

# utf8下将中文当成两个字符处理的自定义的truncate方法
# 取自javaeye上庄表伟和quake wang的方法
# 由于quake wang的方法在需要截取的字符数大于30时有较严重的效率问题，导致卡死进程
# 因此需要截取长度大于30时使用庄表伟的方法
def truncate_u(_text, length = 30, truncate_string = '...')
  text = _text || ''

  if length >= 30
    l = 0
    char_array = text.unpack('U*')
    char_array.each_with_index do |c, i|
      l = l + (c < 127 ? 0.5 : 1)
      if l >= length
        return char_array[0..i].pack('U*') + (i < char_array.length - 1 ? truncate_string : '')
      end
    end
    return text
  end

  if r = Regexp.new("(?:(?:[^\xe0-\xef\x80-\xbf]{1,2})|(?:[\xe0-\xef][\x80-\xbf][\x80-\xbf])){#{length}}", true, 'n').match(text)
    return r[0].length < text.length ? r[0] + truncate_string : r[0]
  end

  return text
end