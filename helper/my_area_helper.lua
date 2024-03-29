-- 我的区域工具类
MyAreaHelper = {
  doorPositionData = {
    -- { 31, 8, 2 }, -- 主角家的门
    -- { 9, 8, -21 }, -- 江枫家的门
    -- { -13, 8, -21 }, -- 村长家的门
    -- { -12, 8, -21 }, -- 村长家的门
    -- { -30, 8, -22 }, -- 苗兰家一楼的门
    -- { -30, 13, -21 }, -- 苗兰家二楼的门
    -- { -29, 9, -37 }, -- 王大力家的门
    -- { -30, 9, -37 }, -- 王大力家的门
    -- { 15, 9, -39 }, -- 花小楼客栈的门
    -- { 16, 9, -39 }, -- 花小楼客栈的门
    -- { 26, 9, -39 }, -- 客栈客房外门
    -- { 29, 9, -42 }, -- 客栈客房中门
    -- { 26, 9, -44 }, -- 客栈客房内门
    -- { 24, 9, -41 }, -- 客栈客房走廊门
    -- { 24, 8, -19 }, -- 文羽家的门
    -- { 252, 14, 0 }, -- 强盗营地的门
    -- { 252, 14, 1 }, -- 强盗营地的门
    -- { -55, 8, 498 }, -- 二牛门
    -- { -54, 7, 532 }, -- 千兵卫门1
    -- { -54, 7, 533 }, -- 千兵卫门2
    -- { -46, 8, 501 }, -- 风颖马厩门1
    -- { -46, 8, 500 }, -- 风颖马厩门2
    -- { -59, 8, 492 }, -- 风颖马厩门3
    -- { -58, 8, 492 }, -- 风颖马厩门4
    -- { -37, 8, 546 }, -- 风颖议事厅门1
    -- { -36, 8, 546 }, -- 风颖议事厅门2
    -- { -40, 16, 547 }, -- 城主书房门
    -- { -33, 16, 547 }, -- 城主卧房门
    -- { 6, 8, 559 }, -- 孔武坊门1
    -- { 7, 8, 559 }, -- 孔武坊门2
    -- { 5, 8, 566 }, -- 孔武坊门3
    -- { 5, 8, 567 }, -- 孔武坊门4
    -- { 11, 12, 564 }, -- 孔武坊门5
    -- { 11, 12, 563 }, -- 孔武坊门6
    -- { 18, 8, 559 }, -- 李妙手门1
    -- { 19, 8, 559 }, -- 李妙手门2
    -- { 20, 8, 561 }, -- 李妙手门3
    -- { 20, 8, 567 }, -- 李妙手门4
    -- { 20, 8, 566 }, -- 李妙手门5
    -- { 14, 12, 563 }, -- 李妙手门6
    -- { 14, 12, 564 }, -- 李妙手门7
    -- { 7, 8, 580 }, -- 真宝阁门1
    -- { 6, 8, 580 }, -- 真宝阁门2
    -- { 11, 8, 573 }, -- 真宝阁门3
    -- { 17, 8, 573 }, -- 真宝阁门4
  },
  doorPositions = {},
  luoyecunPos = MyPosition:new(0, 8, 19), -- 落叶村位置
  panjunyingdiPos = MyPosition:new(217, 7, 516), -- 叛军营地位置
  jushanPos = MyPosition:new(278, 7, 676), -- 橘山位置
  pingfengzhaiPos = MyPosition:new(-363, 8, 556), -- 平风寨位置
  playerInHomePos = { x = 31, y = 9, z = 3 },
  prisonAreas = {}, -- 监狱区域
  prisonPoses = {}, -- 监狱区域中的位置
}

-- 初始化
function MyAreaHelper.init ()
  MyAreaHelper:initDoorAreas()
  MyAreaHelper:initShowToastAreas()
  -- body
  MyAreaHelper.playerInHomeAreaId = AreaHelper.getAreaByPos(MyAreaHelper.playerInHomePos)
  MyAreaHelper.initPrisons()
end

-- 初始化显示飘窗区域
function MyAreaHelper.initShowToastAreas ()
  local arr = { dog, wolf, qiangdaoLouluo, ox, jianshibing }
  for i, v in ipairs(arr) do
    if v.generate then -- 如果需要生成怪物
      AreaHelper.addToastArea(v.areaids[2], { v.areaids[1], v.areaName, v.generate })
    else
      AreaHelper.addToastArea(v.areaids[2], { v.areaids[1], v.areaName })
    end
  end
  for i, v in ipairs(guard.initAreas) do
    if i >= 5 then
      break
    end
    AreaHelper.showToastAreas[guard.initAreas2[i]] = { v.areaid, '风颖城' }
  end
end

-- 初始化所有actor可打开的门的位置
function MyAreaHelper.initDoorAreas ()
  for i, v in ipairs(MyAreaHelper.doorPositionData) do
    local pos = MyPosition:new(v[1], v[2], v[3])
    local areaid = AreaHelper.getAreaByPos(pos)
    table.insert(AreaHelper.allDoorAreas, areaid, pos)
  end
end

-- 获取所有的门位置
function MyAreaHelper.getDoorPositions ()
  return MyAreaHelper.doorPositions
end

-- 初始化监狱区域
function MyAreaHelper.initPrisons ()
  for i = 541, 570, 5 do
    local areaid = AreaHelper.createAreaRectByRange(MyPosition:new(-18, 7, i), MyPosition:new(-16, 9, i + 3))
    table.insert(MyAreaHelper.prisonAreas, areaid)
    table.insert(MyAreaHelper.prisonPoses, MyPosition:new(-17, 8, i + 1))
  end
end

-- 获得一间空监狱位置
function MyAreaHelper.getEmptyPrisonPos ()
  local pos = MyAreaHelper.prisonPoses[1]
  for i, v in ipairs(MyAreaHelper.prisonAreas) do
    local objids = AreaHelper.getAllPlayersInAreaId(v)
    if objids and #objids == 0 then
      pos = MyAreaHelper.prisonPoses[i]
      break
    end
  end
  return pos
end