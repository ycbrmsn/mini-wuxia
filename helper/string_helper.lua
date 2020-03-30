-- 字符串工具类
StringHelper = {}

--[[
utf-8编码规则
单字节 - 0起头
   1字节  0xxxxxxx   0 - 127
多字节 - 第一个字节n个1加1个0起头
   2 字节 110xxxxx   192 - 223
   3 字节 1110xxxx   224 - 239
   4 字节 11110xxx   240 - 247
可能有1-4个字节
--]]
-- 转自网上
function StringHelper:getBytes (char)
  if (not(char)) then
    return 0
  end
  local code = string.byte(char)
  if (code < 127) then
    return 1
  elseif (code <= 223) then
    return 2
  elseif (code <= 239) then
    return 3
  elseif (code <= 247) then
    return 4
  else
    -- 讲道理不会走到这里^_^
    return 0
  end
end

-- 转自网上
function StringHelper:sub (str, beginIndex, endIndex)
  local tempStr = str 
  local byteBegin = 1 -- string.sub截取的开始位置
  local byteEnd = -1 -- string.sub截取的结束位置
  local index = 0  -- 字符记数
  local bytes = 0  -- 字符的字节记数

  beginIndex = math.max(beginIndex, 1)
  endIndex = endIndex or -1
  while (string.len(tempStr) > 0) do     
    if (index == beginIndex - 1) then
       byteBegin = bytes + 1
    elseif (index == endIndex) then
       byteEnd = bytes
       break
    end
    bytes = bytes + self:GetBytes(tempStr)
    tempStr = string.sub(str, bytes + 1)

    index = index + 1
  end
  return string.sub(str, byteBegin, byteEnd)
end

-- 截取全中文
function StringHelper:subZh (str, i, j)
  if (i > 1) then
    i = i * 3 - 2
  end
  return string.sub(str, i, j)
end

-- 连接数组中的字符串t:table, c:连接符, k:如果table中的元素是table, k则是元素的键值
function StringHelper:join (t, c, k)
  c = c or ' '
  local str = ''
  local index, len = 1, #t
  for i, v in ipairs(t) do
    if (k) then
      str = str .. v[k]
    else
      str = str .. v
    end
    if (index ~= len) then
      str = str .. c
    end
  end
  return str
end