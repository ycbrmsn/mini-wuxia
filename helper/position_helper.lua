-- 位置工具类
PositionHelper = {
  doorPositions = {
    { x = 31, y = 8, z = 2 }, -- 主角家的门
    { x = 9, y = 8, z = -21 }, -- 江枫家的门
    { x = -13, y = 8, z = -21 }, -- 村长家的门
    { x = -12, y = 8, z = -21 }, -- 村长家的门
    { x = -30, y = 8, z = -22 }, -- 苗兰家一楼的门
    { x = -30, y = 13, z = -21 }, -- 苗兰家二楼的门
    { x = -30, y = 9, z = -37 }, -- 王大力家的门
    { x = 15, y = 9, z = -39 }, -- 花小楼客栈的门
    { x = 16, y = 9, z = -39 }, -- 花小楼客栈的门
    { x = 26, y = 9, z = -39 }, -- 客栈客房外门
    { x = 29, y = 9, z = -42 }, -- 客栈客房中门
    { x = 26, y = 9, z = -44 }, -- 客栈客房内门
    { x = 24, y = 8, z = -19 } -- 文羽家的门
  }
}

-- 获取所有的门位置
function PositionHelper:getDoorPositions ()
  return self.doorPositions
end

-- 位置字符串
function PositionHelper:posToString (pos)
  if (pos) then
    local x, y, z = pos.x, pos.y, pos.z
    if (not(x)) then
      x = 'nil'
    end
    if (not(y)) then
      y = 'nil'
    end
    if (not(z)) then
      z = 'nil'
    end
    return '{ x = ' .. x .. ', y = ' .. y .. ', z = '.. z .. ' }'
  else
    return 'nil'
  end
end