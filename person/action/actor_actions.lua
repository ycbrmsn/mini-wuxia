-- 基本行为
BaseAction = {
  restTime = 0,
  currentRestTime = 0,
}

function BaseAction:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function BaseAction:setPosition (x, y, z)
  self.actor:setPosition(x, y, z)
end

function BaseAction:runTo (pos, speed)
  speed = speed or self.actor.defaultSpeed
  local x, y, z = math.floor(pos.x) + 0.5, math.floor(pos.y) + 0.5, math.floor(pos.z) + 0.5
  return ActorHelper:tryMoveToPos(self.actor.objid, x, y, z, speed)
end

-- 跟随行为
FollowAction = BaseAction:new()

function FollowAction:new (actor, think, toobjid, speed)
  local think = think or 'follow'
  local o = {
    actor = actor,
    think = think,
    style = think,
    toobjid = toobjid,
    speed = speed,
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function FollowAction:execute ()
  if (self.currentRestTime > 0) then
    self.currentRestTime = self.currentRestTime - 1
  else
    if (self.actor.cantMoveTime > BaseActorAction.maxCantMoveTime) then
      self:setPosition(self.toPos)
      self.actor.cantMoveTime = 0
    else
      local selfPos = ActorHelper:getMyPosition(self.actor.objid)
      if (selfPos) then
        local toPos = ActorHelper:getMyPosition(self.toobjid)
        if (toPos) then
          local distance = MathHelper:getDistance(selfPos, toPos)
          if (distance < 4) then -- 就在附近
            ActorHelper:lookAt(self.actor.objid, self.toobjid)
          else
            self:runTo(toPos, self.speed)
          end
        end
      end
    end
  end
end