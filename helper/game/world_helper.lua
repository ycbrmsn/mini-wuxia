-- 世界工具类
WorldHelper = {
  PARTICLE_ID = {
    BOOM1 = 1007,
    BOOM16 = 1186 -- 爆炸16特效
  },
  SOUND_ID = {
    BE_ATTACK = 10102, -- 被攻击
    CLOSE_DOOR = 10652, -- 关门的声音id
    OPEN_DOOR = 10653 -- 开门的声音id
  },
  volume = 100,
  pitch = 1
}

-- 在指定位置上播放开门的声音
function WorldHelper:playOpenDoorSoundOnPos (pos)
  return self:playSoundEffectOnPos(pos, self.SOUND_ID.OPEN_DOOR)
end

-- 在指定位置上播放关门的声音
function WorldHelper:playCloseDoorSoundOnPos (pos)
  return self:playSoundEffectOnPos(pos, self.SOUND_ID.CLOSE_DOOR)
end

function WorldHelper:playBeAttackedSoundOnPos (pos)
  return self:playSoundEffectOnPos(pos, self.SOUND_ID.BE_ATTACK)
end

-- 攻击特效
function WorldHelper:playAttackEffect (pos)
  return self:playEffect(pos, self.PARTICLE_ID.BOOM1)
end

function WorldHelper:stopAttackEffect (pos)
  return self:stopEffect(pos, self.PARTICLE_ID.BOOM1)
end

-- 击退特效
function WorldHelper:playRepelEffect (pos)
  return self:playEffect(pos, self.PARTICLE_ID.BOOM16)
end

function WorldHelper:stopRepelEffect (pos)
  return self:stopEffect(pos, self.PARTICLE_ID.BOOM16)
end

function WorldHelper:playEffect (pos, particleId, scale)
  scale = scale or 1
  return self:playParticalEffect(pos.x, pos.y, pos.z, particleId, scale)
end

function WorldHelper:stopEffect (pos, particleId)
  return self:stopEffectOnPosition(pos.x, pos.y, pos.z, particleId)
end

-- 指定地点播放特效然后关闭
function WorldHelper:playAndStopEffectById (pos, particleId, scale, time)
  scale = scale or 1
  time = time or 3
  local posString = pos:toString()
  self:playParticalEffect(pos.x, pos.y, pos.z, particleId, scale)
  MyTimeHelper:callFnLastRun(posString, posString .. 'stopPosEffect' .. particleId, function ()
    self:stopEffectOnPosition(pos.x, pos.y, pos.z, particleId)
  end, time)
end

-- 通过地点与方向生成投掷物
function WorldHelper:spawnProjectileByDirPos (shooter, itemid, pos, dirVector3, speed)
  speed = speed or 100
  return self:spawnProjectileByDir(shooter, itemid, pos.x, pos.y, pos.z, dirVector3.x, dirVector3.y, dirVector3.z, speed)
end

-- 封装原始接口

-- 生成生物
function WorldHelper:spawnCreature (x, y, z, actorid, actorCnt)
  local onceFailMessage = '生成生物失败一次'
  local finillyFailMessage = StringHelper:concat('生成生物失败，参数：x=', x, ', y=', y, ', z=', z, ', actorid=', actorid, ', actorCnt=', actorCnt)
  return CommonHelper:callOneResultMethod(function (p)
    return World:spawnCreature(x, y, z, actorid, actorCnt)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 移除生物
function WorldHelper:despawnCreature (objid)
  local onceFailMessage = '移除生物失败一次'
  local finillyFailMessage = StringHelper:concat('移除生物失败，参数：objid=', objid)
  return CommonHelper:callIsSuccessMethod(function (p)
    return World:despawnCreature(objid)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 在指定位置上播放音效
function WorldHelper:playSoundEffectOnPos (pos, soundId, isLoop)
  local onceFailMessage = '播放声音失败一次'
  local finillyFailMessage = StringHelper:concat('播放声音失败，参数：pos=', pos, ', soundId=', soundId, ', isLoop=', isLoop)
  return CommonHelper:callIsSuccessMethod(function (p)
    return World:playSoundEffectOnPos(pos, soundId, self.volume, self.pitch, isLoop)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 停止指定位置上播放的音效
function WorldHelper:stopSoundEffectOnPos (pos, soundId)
  local onceFailMessage = '停止播放声音失败一次'
  local finillyFailMessage = StringHelper:concat('停止播放声音失败，参数：pos=', pos, ', soundId=', soundId)
  return CommonHelper:callIsSuccessMethod(function (p)
    return World:stopSoundEffectOnPos(pos, soundId)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 获取当前几点
function WorldHelper:getHours ()
  local onceFailMessage = '获取当前几点失败一次'
  local finillyFailMessage = '获取当前几点失败，无参数'
  return CommonHelper:callOneResultMethod(function (p)
    return World:getHours()
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 设置当前几点
function WorldHelper:setHours (hour)
  local onceFailMessage = '设置当前几点失败一次'
  local finillyFailMessage = StringHelper:concat('设置当前几点失败，参数：hour=', hour)
  return CommonHelper:callIsSuccessMethod(function (p)
    return World:setHours(hour)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 计算位置之间的距离
function WorldHelper:calcDistance (pos1, pos2)
  return World:calcDistance(pos1, pos2)
end

-- 在指定位置生成道具
function WorldHelper:spawnItem (x, y, z, itemId, itemCnt)
  local onceFailMessage = '在指定位置生成道具失败一次'
  local finillyFailMessage = StringHelper:concat('在指定位置生成道具失败，参数：x=', x, ',y=', y, ',z=', z, ',itemId=', itemId, ',itemCnt=', itemCnt)
  return CommonHelper:callOneResultMethod(function (p)
    return World:spawnItem(x, y, z, itemId, itemCnt)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 在指定位置播放特效
function WorldHelper:playParticalEffect (x, y, z, particleId, scale)
  local onceFailMessage = '在指定位置播放特效失败一次'
  local finillyFailMessage = StringHelper:concat('在指定位置播放特效失败，参数：x=', x, ',y=', y, ',z=', z, ',particleId=', particleId, ',scale=', scale)
  return CommonHelper:callIsSuccessMethod(function (p)
    return World:playParticalEffect(x, y, z, particleId, scale)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 停止指定位置的特效
function WorldHelper:stopEffectOnPosition (x, y, z, particleId)
  local onceFailMessage = '停止指定位置的特效失败一次'
  local finillyFailMessage = StringHelper:concat('停止指定位置的特效失败，参数：x=', x, ',y=', y, ',z=', z, ',particleId=', particleId)
  return CommonHelper:callIsSuccessMethod(function (p)
    return World:stopEffectOnPosition(x, y, z, particleId)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 生成投掷物(通过方向)
function WorldHelper:spawnProjectileByDir (shooter, itemid, x, y, z, dirx, diry, dirz, speed)
  local onceFailMessage = '生成投掷物(通过方向)失败一次'
  local finillyFailMessage = StringHelper:concat('生成投掷物(通过方向)失败，参数：shooter=', shooter, ',itemid=', itemid, ',x=', x, ',y=', y, ',z=', z, ',dirx=', dirx, ',diry=', diry, ',dirz=', dirz, ',speed=', speed)
  return CommonHelper:callOneResultMethod(function (p)
    return World:spawnProjectileByDir(shooter, itemid, x, y, z, dirx, diry, dirz, speed)
  end, nil, onceFailMessage, finillyFailMessage)
end