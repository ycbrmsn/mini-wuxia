-- 位置工具类
PositionHelper = {
  luoyecunPos = MyPosition:new(0, 8, 19), -- 落叶村位置
  pingfengzhaiPos = MyPosition:new(-363, 8, 556), -- 平风寨位置
  doorPositions = {
    MyPosition:new(31, 8, 2), -- 主角家的门
    MyPosition:new(9, 8, -21), -- 江枫家的门
    MyPosition:new(-13, 8, -21), -- 村长家的门
    MyPosition:new(-12, 8, -21), -- 村长家的门
    MyPosition:new(-30, 8, -22), -- 苗兰家一楼的门
    MyPosition:new(-30, 13, -21), -- 苗兰家二楼的门
    MyPosition:new(-29, 9, -37), -- 王大力家的门
    MyPosition:new(-30, 9, -37), -- 王大力家的门
    MyPosition:new(15, 9, -39), -- 花小楼客栈的门
    MyPosition:new(16, 9, -39), -- 花小楼客栈的门
    MyPosition:new(26, 9, -39), -- 客栈客房外门
    MyPosition:new(29, 9, -42), -- 客栈客房中门
    MyPosition:new(26, 9, -44), -- 客栈客房内门
    MyPosition:new(24, 9, -41), -- 客栈客房走廊门
    MyPosition:new(24, 8, -19), -- 文羽家的门
    MyPosition:new(252, 14, 0), -- 强盗营地的门
    MyPosition:new(252, 14, 1), -- 强盗营地的门
    MyPosition:new(-55, 8, 498), -- 二牛门
    MyPosition:new(-54, 7, 532), -- 千兵卫门1
    MyPosition:new(-54, 7, 533), -- 千兵卫门2
    MyPosition:new(-46, 8, 501), -- 风颖马厩门1
    MyPosition:new(-46, 8, 500), -- 风颖马厩门2
    MyPosition:new(-59, 8, 492), -- 风颖马厩门3
    MyPosition:new(-58, 8, 492), -- 风颖马厩门4
    MyPosition:new(-37, 8, 546), -- 风颖议事厅门1
    MyPosition:new(-36, 8, 546), -- 风颖议事厅门2
    MyPosition:new(-40, 16, 547), -- 城主书房门
    MyPosition:new(-33, 16, 547) -- 城主卧房门
  }
}

-- 获取所有的门位置
function PositionHelper:getDoorPositions ()
  return self.doorPositions
end

-- 第二人是不是在第一人前面
function PositionHelper:isTwoInFrontOfOne (objid1, objid2)
  local curPlaceDir = ActorHelper:getCurPlaceDir(objid1)
  local x1, y1, z1 = ActorHelper:getPosition(objid1)
  local x2, y2, z2 = ActorHelper:getPosition(objid2)
  -- 获取的方向是反的，不知道是不是bug
  if (curPlaceDir == FACE_DIRECTION.DIR_NEG_X) then -- 东
    return x2 > x1
  elseif (curPlaceDir == FACE_DIRECTION.DIR_POS_X) then -- 西
    return x2 < x1
  elseif (curPlaceDir == FACE_DIRECTION.DIR_NEG_Z) then -- 北
    return z2 > z1
  elseif (curPlaceDir == FACE_DIRECTION.DIR_POS_Z) then -- 南
    return z2 < z1
  else
    return false
  end
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