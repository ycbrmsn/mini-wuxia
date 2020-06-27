-- 剧情二工具类
Story2Helper = {}

function Story2Helper:getData ()
  return {
    title = '启程',
    name = '前往学院',
    desc = '先生带着我向学院出发了',
    tips = {
      '终于到了出发的时间了。我好激动。',
      '先生带着我向学院出发了。只是，没想到是要用跑的。',
      '这群可恶的强盗，居然要抢我的通行令。没办法了，先消灭他们再说。',
      '可恶的强盗终于被我消灭了。看来我还是很厉害的嘛。',
      '#G目前剧情到此。'
      -- '先生先离开了。风颖城，我来了。'
    },
    yexiaolongInitPosition = {
      { x = 0, y = 7, z = 23 },
      { x = 0, y = 7, z = 20 }
    },
    playerInitPosition = { x = 0, y = 7, z = 16 },
    movePositions1 = {
      { x = 0, y = 7, z = 70 },
      { x = 0, y = 7, z = 130 },
      { x = 0, y = 7, z = 190 },
      { x = 0, y = 7, z = 250 },
      { x = 0, y = 7, z = 280 }
    },
    movePositions2 = {
      { x = 0, y = 7, z = 65 },
      { x = 0, y = 7, z = 125 },
      { x = 0, y = 7, z = 185 },
      { x = 0, y = 7, z = 245 },
      { x = 0, y = 7, z = 275 }
    },
    leaveForAWhilePositions = {
      { x = 10, y = 7, z = 280 },
      { x = 24, y = 7, z = 230 }
    },
    eventPositions = {
      { x = 0, y = 7, z = 320 }
    },
    xiaotoumuPositions = {
      { x = 0, y = 7, z = 330 }
    },
    louluoPositions = {
      { x = -2, y = 7, z = 330 },
      { x = 2, y = 7, z = 330 },
      { x = 4, y = 7, z = 330 },
      { x = -4, y = 7, z = 330 },
      { x = 6, y = 7, z = 328 },
      { x = -6, y = 7, z = 328 },
      { x = 8, y = 7, z = 326 },
      { x = -8, y = 7, z = 326 },
      { x = 10, y = 7, z = 324 },
      { x = -10, y = 7, z = 324 }
    },
    xiaotoumus = {},
    xiaolouluos = {},
    killXiaotoumuNum = 0,
    killLouluoNum = 0,
    toCollegePositions = {
      { x = 0, y = 7, z = 359 },
      { x = 0, y = 7, z = 420 },
      { x = -36, y = 7, z = 458 },
      { x = -36, y = 7, z = 500 },
      { x = -6, y = 7, z = 525 },
      { x = -6, y = 7, z = 580 },
      { x = -16, y = 7, z = 600 }
    },
    standard = 1
  }
end

-- 初始化所有强盗位置
function Story2Helper:initQiangdao ()
  local story2 = MyStoryHelper:getStory(2)
  qiangdaoXiaotoumu:initStoryMonsters()
  qiangdaoLouluo:initStoryMonsters()
  qiangdaoXiaotoumu:setAIActive(false)
  qiangdaoLouluo:setAIActive(false)
  qiangdaoXiaotoumu:setPositions(story2.xiaotoumuPositions)
  qiangdaoLouluo:setPositions(story2.louluoPositions)
  for i, v in ipairs(qiangdaoXiaotoumu.monsters) do
    table.insert(story2.xiaotoumus, { objid = v, killed = false })
  end
  for i, v in ipairs(qiangdaoLouluo.monsters) do
    table.insert(story2.xiaolouluos, { objid = v, killed = false })
  end
end

-- 初始化位置
function Story2Helper:getInitPosition (index, myPosition)
  local pos = MyPosition:new(myPosition)
  if (index > 1) then
    local temp = math.floor(index / 2)
    if (math.mod(index, 2) == 0) then
      temp = temp * -1
    end
    pos.x = pos.x + temp
  end
  return pos
end

-- 取得空气位置
function Story2Helper:getAirPosition ()
  local hostPlayer = MyPlayerHelper:getHostPlayer()
  local pos = MyPosition:new(hostPlayer:getPosition())
  local pos2 = MyPosition:new(hostPlayer:getPosition())
  for i = 6, 1, -1 do
    pos.x = pos.x + i
    pos2.x = pos2.x + i + 1
    if (MyAreaHelper:isAirArea(pos) and MyAreaHelper:isAirArea(pos2)) then
      return pos, pos2
    else
      pos.x = pos.x - i
      pos2.x = pos2.x - i - 1
    end
    pos.z = pos.z + i
    pos2.z = pos2.z + i + 1
    if (MyAreaHelper:isAirArea(pos) and MyAreaHelper:isAirArea(pos2)) then
      return pos, pos2
    else
      pos.z = pos.z - i
      pos2.z = pos2.z - i - 1
    end
  end
  return pos, pos2
end

-- 显示剩余强盗数
function Story2Helper:showMessage (objid)
  local actorid = CreatureHelper:getActorID(objid)
  MyTimeHelper:callFnAfterSecond(function ()
    local story2 = MyStoryHelper:getStory(2)
    local isRight = false
    if (qiangdaoLouluo.actorid == actorid) then
      for i, v in ipairs(story2.xiaolouluos) do
        if (v.objid == objid) then
          v.killed = true
          break
        end
      end
      story2.killLouluoNum = story2.killLouluoNum + 1
      isRight = true
    elseif (qiangdaoXiaotoumu.actorid == actorid) then
      for i, v in ipairs(story2.xiaotoumus) do
        if (v.objid == objid) then
          v.killed = true
          break
        end
      end
      story2.killXiaotoumuNum = story2.killXiaotoumuNum + 1
      isRight = true
      if (story2.killXiaotoumuNum > 0) then
        MyTimeHelper:callFnAfterSecond(function ()
          Story2Helper:killXiaotoumuEvent()
        end, 1)
      end
    end
    if (isRight) then
      local remainXiaolouluoNum = #story2.louluoPositions - story2.killLouluoNum
      local remainXiaotoumuNum = #story2.xiaotoumuPositions - story2.killXiaotoumuNum
      if (remainXiaotoumuNum + remainXiaolouluoNum > 0) then
        local msg = '剩余强盗喽罗数：' .. remainXiaolouluoNum .. '。剩余强盗小头目数：' .. remainXiaotoumuNum .. '。'
        ChatHelper:sendSystemMsg(msg)
      else
        ChatHelper:sendSystemMsg('消灭所有强盗。')
        if (story2.standard == 1) then
          story2:wipeOutQiangdao()
        end
      end
    end
  end, 1)
end

-- 生物跑出范围圈让他回来
function Story2Helper:comeBack (objid, areaid)
  local pos = MyPosition:new(ActorHelper:getPosition(objid))
  local x, y, z = 0, 0, 0
  if (pos.x < -29) then
    pos.x = -26
    x = 1
  elseif (pos.x > 27) then
    pos.x = 24
    x = -1
  end
  if (pos.z < 298) then
    pos.z = 301
    z = 1
  elseif (pos.z > 359) then
    pos.z = 356
    z = -1
  end
  if (ActorHelper:isPlayer(objid)) then
    MyPlayerHelper:showToast(objid, '你不能跑得太远')
    -- local player = MyPlayerHelper:getPlayer(objid)
    -- PlayerHelper:setPosition(objid, pos.x, pos.y, pos.z)
  end
  ActorHelper:appendSpeed(objid, x, y, z)
  ActorHelper:tryNavigationToPos(objid, pos.x, pos.y, pos.z, false)
end

-- 干掉了强盗小头目事件
function Story2Helper:killXiaotoumuEvent ()
  local story2 = MyStoryHelper:getStory(2)
  if (story2.standard == 1 and story2.killLouluoNum < #story2.louluoPositions) then -- 还有喽罗
    qiangdaoLouluo:speak(0, '他杀了老大！干掉他！')
    for i, v in ipairs(story2.xiaolouluos) do
      if (not(v.killed)) then
        CreatureHelper:setAIActive(v.objid, false)
      end
    end
    MyTimeHelper:callFnAfterSecond(function ()
      for i, v in ipairs(story2.xiaolouluos) do
        if (not(v.killed)) then
          CreatureHelper:setAIActive(v.objid, true)
          ActorHelper:addBuff(v.objid, 17, 3, 6000) -- 强力攻击3级
        end
      end
    end, 1)
  end
end

function Story2Helper:recover (player)
  local mainProgress = MyStoryHelper:getMainStoryProgress()
  if (mainProgress >= 5) then
    player:enableMove(true)
  end
end