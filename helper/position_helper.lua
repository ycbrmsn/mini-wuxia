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
    { x = 24, y = 8, z = -19 } -- 文羽家的门
  }
}

-- 获取所有的门位置
function PositionHelper:getDoorPositions ()
  return self.doorPositions
end
