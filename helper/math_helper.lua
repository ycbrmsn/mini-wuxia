-- 数学工具类
MathHelper = {}

function MathHelper:getActorFaceYaw (myVector3)
  local tempAngle = self:getTwoVector2Angle(0, -1, myVector3.x, myVector3.z)
  if (myVector3.x > 0) then
    tempAngle = -tempAngle
  end
  return tempAngle
end

function MathHelper:getActorFacePitch (myVector3)
  local tempAngle = self:getTwoVector3Angle(myVector3.x, 0, myVector3.z, myVector3:get())
  if (myVector3.y > 0) then
    tempAngle = - tempAngle
  end
  return tempAngle
end

-- x0 * x1 + y0 * y1 = |x0y0| * |x1y1| * cosAngle
function MathHelper:getTwoVector2Angle (x0, y0, x1, y1)
  local cosAngle = (x0 * x1 + y0 * y1) / self:getVector2Length(x0, y0) / self:getVector2Length(x1, y1)
  return math.deg(math.acos(cosAngle))
end

function MathHelper:getTwoVector3Angle (x0, y0, z0, x1, y1, z1)
  local cosAngle = (x0 * x1 + y0 * y1 + z0 * z1) / self:getVector3Length(x0, y0, z0) / self:getVector3Length(x1, y1, z1)
  return math.deg(math.acos(cosAngle))
end

-- 二维向量长度
function MathHelper:getVector2Length (x, y)
  return math.sqrt(math.pow(x, 2) + math.pow(y, 2))
end

-- 三维向量长度
function MathHelper:getVector3Length (x, y, z)
  return math.sqrt(math.pow(x, 2) + math.pow(y, 2) + math.pow(z, 2))
end