-- 计时器工具类
TimerHelper = {}

-- 如果timerid不存在就创建计时器
function TimerHelper:createTimerIfNotExist (timername, timerid)
  if (timerid) then
    if (not(self:isExist(timerid))) then -- 计时器不存在
      timerid = self:createTimer(timername)
    end
    return timerid
  else
    return self:createTimer(timername)
  end
end

-- 封装原始接口

-- 判断计时器是否存在
function TimerHelper:isExist (timerid)
  return MiniTimer:isExist(timerid)
end

-- 创建计时器
function TimerHelper:createTimer (timername)
  local onceFailMessage = '创建计时器失败一次'
  local finillyFailMessage = '创建计时器失败'
  return CommonHelper:callOneResultMethod(function (p)
    return MiniTimer:createTimer(p.timername)
  end, { timername = timername }, onceFailMessage, finillyFailMessage)
end

-- 启动正向计时器
function TimerHelper:startForwardTimer (timerid)
  local onceFailMessage = '启动正向计时器失败一次'
  local finillyFailMessage = '启动正向计时器失败'
  return CommonHelper:callIsSuccessMethod(function (p)
    return MiniTimer:startForwardTimer(p.timerid)
  end, { timerid = timerid }, onceFailMessage, finillyFailMessage)
end