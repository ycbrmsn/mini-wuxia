-- 角色工具类
ActorHelper = {
  ACT = {
    HI = 1, -- 打招呼
    THINK = 2, -- 低头思考
    CRY = 3, -- 哭泣
    ANGRY = 4, -- 生气
    STRETCH = 5,  -- 伸懒腰
    HAPPY = 6, -- 胜利（高兴）
    THANK = 7, -- 感谢
    FREE = 8, -- 休闲动作
    DOWN = 9, -- 倒地
    POSE = 10, -- 摆姿势
    STAND = 11, -- 站立
    RUN = 12, -- 跑
    SLEEP = 13, -- 躺下睡觉
    SIT = 14, -- 坐下
    SWIM = 15, -- 游泳
    ATTACK = 16, -- 攻击
    DIE = 17, -- 死亡
    BEAT = 18, -- 受击
    FREE2 = 19, -- 休闲
    JUMP = 20 -- 跳
  },
  BUFF = {
    FASTER_RUN = 4, -- 疾跑
    NIGHT_LOOK = 16 -- 夜视
  },
  FACE_YAW = {
    EAST = -90,
    WEST = 90,
    SOUTH = 0,
    NORTH = 180
  }
}

-- 设置生物可移动状态
function ActorHelper:setEnableMoveState (objid, switch)
  return self:setActionAttrState(objid, CREATUREATTR.ENABLE_MOVE, switch)
end

-- 获取生物可移动状态
function ActorHelper:getEnableMoveState (objid)
  return self:getActionAttrState(objid, CREATUREATTR.ENABLE_MOVE)
end

-- 设置生物可被杀死状态
function ActorHelper:setEnableBeKilledState (objid, switch)
  return self:setActionAttrState(objid, CREATUREATTR.ENABLE_BEKILLED, switch)
end

-- 获取生物可被杀死状态
function ActorHelper:getEnableBeKilledState (objid)
  return self:getActionAttrState(objid, CREATUREATTR.ENABLE_BEKILLED)
end

-- 封装原始接口

-- 向目标位置移动
function ActorHelper:tryMoveToPos (objid, x, y, z, speed)
  local onceFailMessage = '向目标移动失败一次'
  local finillyFailMessage = StringHelper:concat('向目标移动失败，参数：objid=', objid, ', x=', x, ', y=', y, ', z=', z, ', speed=', speed)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Actor:tryMoveToPos(objid, x, y, z, speed)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 寻路到目标位置
function ActorHelper:tryNavigationToPos (objid, x, y, z, cancontrol)
  local onceFailMessage = '寻路到目标位置失败一次'
  local finillyFailMessage = StringHelper:concat('寻路到目标位置失败，参数：objid=', objid, ', x=', x, ', y=', y, ', z=', z, ', cancontrol=', cancontrol)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Actor:tryNavigationToPos(objid, x, y, z, cancontrol)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 设置生物行为状态
function ActorHelper:setActionAttrState (objid, actionattr, switch)
  local onceFailMessage = '设置生物行为状态失败一次'
  local finillyFailMessage = StringHelper:concat('设置生物行为状态失败，参数：objid=', objid, ', actionattr=', actionattr, ', switch=', switch)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Actor:setActionAttrState(objid, actionattr, switch)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 获取生物行为状态
function ActorHelper:getActionAttrState (objid, actionattr)
  local onceFailMessage = '获取生物行为状态失败一次'
  local finillyFailMessage = StringHelper:concat('获取生物行为状态失败，参数：objid=', objid, ', actionattr=', actionattr)
  return CommonHelper:callOneResultMethod(function (p)
    return Actor:getActionAttrState(objid, actionattr)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 获取生物位置
function ActorHelper:getPosition (objid)
  local onceFailMessage = '获取生物位置失败一次'
  local finillyFailMessage = StringHelper:concat('获取生物位置失败，参数：objid=', objid)
  return CommonHelper:callThreeResultMethod(function (p)
    return Actor:getPosition(objid)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 设置生物位置
function ActorHelper:setPosition (objid, x, y, z)
  local onceFailMessage = '设置生物位置失败一次'
  local finillyFailMessage = StringHelper:concat('设置生物位置失败，参数：objid=', objid, ', x=', x, ', y=', y, ', z=', z)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Actor:setPosition(objid, x, y, z)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 清除生物ID为actorid的生物
function ActorHelper:clearActorWithId (actorid, bkill)
  local onceFailMessage = '清除生物失败一次'
  local finillyFailMessage = StringHelper:concat('清除生物失败，参数：actorid=', actorid, ', bkill=', bkill)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Actor:clearActorWithId(actorid, bkill)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 是否是玩家
function ActorHelper:isPlayer (objid)
  return Actor:isPlayer(objid) == ErrorCode.OK
end

-- 播放动作
function ActorHelper:playAct (objid, actid)
  local onceFailMessage = '播放动作失败一次'
  local finillyFailMessage = StringHelper:concat('播放动作失败，参数：objid=', objid, ', actid=', actid)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Actor:playAct(objid, actid)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 获取当前朝向
function ActorHelper:getCurPlaceDir (objid)
  local onceFailMessage = '获取当前朝向失败一次'
  local finillyFailMessage = StringHelper:concat('获取当前朝向失败，参数：objid=', objid)
  return CommonHelper:callOneResultMethod(function (p)
    return Actor:getCurPlaceDir(objid)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 增加指定BUFF
function ActorHelper:addBuff (objid, buffid, bufflv, customticks)
  local onceFailMessage = '增加指定BUFF失败一次'
  local finillyFailMessage = StringHelper:concat('增加指定BUFF失败，参数：objid=', objid, ', buffid=', buffid, ', bufflv=', bufflv, ', customticks=', customticks)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Actor:addBuff(objid, buffid, bufflv, customticks)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 设置actor原地旋转偏移角度
function ActorHelper:setFaceYaw (objid, yaw)
  local onceFailMessage = '设置actor原地旋转偏移角度失败一次'
  local finillyFailMessage = StringHelper:concat('设置actor原地旋转偏移角度失败，参数：objid=', objid, ', yaw=', yaw)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Actor:setFaceYaw(objid, yaw)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 获取actor原地旋转偏移角度
function ActorHelper:getFaceYaw (objid)
  local onceFailMessage = '获取actor原地旋转偏移角度失败一次'
  local finillyFailMessage = StringHelper:concat('获取actor原地旋转偏移角度失败，参数：objid=', objid)
  return CommonHelper:callOneResultMethod(function (p)
    return Actor:getFaceYaw(objid)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 获取眼睛位置
function ActorHelper:getEyePosition (objid)
  local onceFailMessage = '获取眼睛位置失败一次'
  local finillyFailMessage = StringHelper:concat('获取眼睛位置失败，参数：objid=', objid)
  return CommonHelper:callThreeResultMethod(function (p)
    return Actor:getEyePosition(objid)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 设置actor视角仰望角度
function ActorHelper:setFacePitch (objid, pitch)
  local onceFailMessage = '设置actor视角仰望角度失败一次'
  local finillyFailMessage = StringHelper:concat('设置actor视角仰望角度失败，参数：objid=', objid, ', pitch=', pitch)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Actor:setFacePitch(objid, pitch)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 获取actor视角仰望角度
function ActorHelper:getFacePitch (objid)
  local onceFailMessage = '获取actor视角仰望角度失败一次'
  local finillyFailMessage = StringHelper:concat('获取actor视角仰望角度失败，参数：objid=', objid)
  return CommonHelper:callOneResultMethod(function (p)
    return Actor:getFacePitch(objid)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 获取眼睛高度
function ActorHelper:getEyeHeight (objid)
  local onceFailMessage = '获取眼睛高度失败一次'
  local finillyFailMessage = StringHelper:concat('获取眼睛高度失败，参数：objid=', objid)
  return CommonHelper:callOneResultMethod(function (p)
    return Actor:getEyeHeight(objid)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 在指定Actor身上播放特效
function ActorHelper:playBodyEffectById (objid, particleId, scale)
  local onceFailMessage = '在指定Actor身上播放特效失败一次'
  local finillyFailMessage = StringHelper:concat('在指定玩家身上播放特效失败，参数：objid=', objid, ',particleId=', particleId, ',scale=', scale)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Actor:playBodyEffectById(objid, particleId, scale)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 停止指定Actor身上的特效
function ActorHelper:stopBodyEffectById (objid, particleId)
  local onceFailMessage = '停止指定Actor身上的特效失败一次'
  local finillyFailMessage = StringHelper:concat('停止指定玩家身上的特效失败，参数：objid=', objid, ',particleId=', particleId)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Actor:stopBodyEffectById(objid, particleId)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 在指定Actor身上播放音效
function ActorHelper:playSoundEffectById (objid, soundId, volume, pitch, isLoop)
  local onceFailMessage = '在指定Actor身上播放音效失败一次'
  local finillyFailMessage = StringHelper:concat('在指定Actor身上播放音效失败，参数：objid=', objid, ',soundId=', soundId)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Actor:playSoundEffectById(objid, soundId, volume, pitch, isLoop)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 停止指定Actor身上的音效
function ActorHelper:stopSoundEffectById (objid, soundId)
  local onceFailMessage = '停止指定Actor身上的音效失败一次'
  local finillyFailMessage = StringHelper:concat('停止指定Actor身上的音效失败，参数：objid=', objid, ',soundId=', soundId)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Actor:stopSoundEffectById(objid, soundId)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 给actor附加一个速度
function ActorHelper:appendSpeed (objid, x, y, z)
  local onceFailMessage = '给actor附加一个速度失败一次'
  local finillyFailMessage = StringHelper:concat('给actor附加一个速度失败，参数：objid=', objid, ',x=', x, ',y=', y, ',z=', z)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Actor:appendSpeed(objid, x, y, z)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 杀死自己
function ActorHelper:killSelf (objid)
  local onceFailMessage = '杀死自己失败一次'
  local finillyFailMessage = StringHelper:concat('杀死自己失败，参数：objid=', objid)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Actor:killSelf(objid)
  end, nil, onceFailMessage, finillyFailMessage)
end

-- 清除全部减益BUFF
function ActorHelper:clearAllBadBuff (objid)
  local onceFailMessage = '清除全部减益BUFF失败一次'
  local finillyFailMessage = StringHelper:concat('清除全部减益BUFF失败，参数：objid=', objid)
  return CommonHelper:callIsSuccessMethod(function (p)
    return Actor:clearAllBadBuff(objid)
  end, nil, onceFailMessage, finillyFailMessage)
end