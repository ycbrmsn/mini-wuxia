-- 世界工具类
WorldHelper = {
  closeDoorSoundId = 10652, -- 关门的声音id
  openDoorSoundId = 10653, -- 开门的声音id
  volume = 100,
  pitch = 1
}

-- 在指定位置上播放开门的声音
function WorldHelper:playOpenDoorSoundOnPos (pos)
  return self:playSoundEffectOnPos(pos, self.openDoorSoundId)
end

-- 在指定位置上播放关门的声音
function WorldHelper:playCloseDoorSoundOnPos (pos)
  return self:playSoundEffectOnPos(pos, self.closeDoorSoundId)
end

-- 封装原始接口

-- 生成生物
function WorldHelper:spawnCreature (x, y, z, actorid, actorCnt)
  local onceFailMessage = '生成生物失败一次'
  local finillyFailMessage = StringHelper:concat('生成生物失败，参数：x=', x, ', y=', y, ', z=', z, ', actorid=', actorid, ', actorCnt=', actorCnt)
  return CommonHelper:callOneResultMethod(function (p)
    return World:spawnCreature(p.x, p.y, p.z, p.actorid, p.actorCnt)
  end, { x = x, y = y, z = z, actorid = actorid, actorCnt = actorCnt }, onceFailMessage, finillyFailMessage)
end

-- 移除生物
function WorldHelper:despawnCreature (objid)
  local onceFailMessage = '移除生物失败一次'
  local finillyFailMessage = StringHelper:concat('移除生物失败，参数：objid=', objid)
  return CommonHelper:callIsSuccessMethod(function (p)
    return World:despawnCreature(p.objid)
  end, { objid = objid }, onceFailMessage, finillyFailMessage)
end

-- 在指定位置上播放音效
function WorldHelper:playSoundEffectOnPos (pos, soundId, isLoop)
  local onceFailMessage = '播放声音失败一次'
  local finillyFailMessage = StringHelper:concat('播放声音失败，参数：pos=', pos, ', soundId=', soundId, ', isLoop=', isLoop)
  return CommonHelper:callIsSuccessMethod(function (p)
    return World:playSoundEffectOnPos(p.pos, p.soundId, self.volume, self.pitch, p.isLoop)
  end, { pos = pos, soundId = soundId, isLoop = isLoop }, onceFailMessage, finillyFailMessage)
end

-- 停止指定位置上播放的音效
function WorldHelper:stopSoundEffectOnPos (pos, soundId)
  local onceFailMessage = '停止播放声音失败一次'
  local finillyFailMessage = StringHelper:concat('停止播放声音失败，参数：pos=', pos, ', soundId=', soundId)
  return CommonHelper:callIsSuccessMethod(function (p)
    return World:stopSoundEffectOnPos(p.pos, p.soundId)
  end, { pos = pos, soundId = soundId }, onceFailMessage, finillyFailMessage)
end

-- 获取当前几点
function WorldHelper:getHours ()
  local onceFailMessage = '获取当前几点失败一次'
  local finillyFailMessage = '获取当前几点失败，无参数'
  return CommonHelper:callOneResultMethod(function (p)
    return World:getHours()
  end, {}, onceFailMessage, finillyFailMessage)
end

-- 设置当前几点
function WorldHelper:setHours (hour)
  local onceFailMessage = '设置当前几点失败一次'
  local finillyFailMessage = StringHelper:concat('设置当前几点失败，参数：hour=', hour)
  return CommonHelper:callIsSuccessMethod(function (p)
    return World:setHours(p.hour)
  end, { hour = hour }, onceFailMessage, finillyFailMessage)
end

-- 计算位置之间的距离
function WorldHelper:calcDistance (pos1, pos2)
  return World:calcDistance(pos1, pos2)
end