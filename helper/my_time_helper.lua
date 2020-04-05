-- 我的时间工具类
MyTimeHelper = {
  hour = nil,
  time = 0,
  fns = {}, -- second -> { { f, p }, { f, p }, ... }
  fnIntervals = {}, -- second -> { objid = { t = { f, p }, t = { f, p } }, objid = { t = { f, p }, t = { f, p } }, ... }
  fnCanRuns = {} -- second -> { objid = { t, t }, objid = { t, t } ... }
}

function MyTimeHelper:updateHour (hour)
  self.hour = hour
end

-- 更新时间
function MyTimeHelper:updateTime (second)
  self.time = second
end

function MyTimeHelper:setHour (hour)
  if (WorldHelper:setHours(hour)) then
    self.hour = hour
    return true
  end
  return false
end

function MyTimeHelper:getHour ()
  if (not(self.hour)) then
    self.hour = WorldHelper:getHours()
  end
  return self.hour
end

-- 添加方法
function MyTimeHelper:addFn (f, time, p)
  local fs = self.fns[time]
  if (not(fs)) then
    fs = {}
    self.fns[time] = fs
  end
  table.insert(fs, { f, p })
end

-- 运行方法，然后删除
function MyTimeHelper:runFnAfterSecond (time)
  local fs = self.fns[time]
  if (fs) then
    for i, v in ipairs(fs) do
      v[1](v[2])
    end
    fs = nil
  end
end

-- 参数为：函数、秒、函数的参数table
function MyTimeHelper:callFnAfterSecond (f, second, p)
  if (type(f) ~= 'function') then
    return
  end
  second = second or 1
  local time = self.time + second
  self:addFn(f, time, p)
end

function MyTimeHelper:runFnInterval (time)
  local fs = self.fnIntervals[time]
  if (fs) then
    for oid, ts in pairs(fs) do
      for k, v in pairs(ts) do
        v[1](v[2])
      end
    end
  end
  -- 清除较长时间间隔的数据
  local longIntervalTime = time - 20
  if (self.fnIntervals[longIntervalTime]) then
    self.fnIntervals[longIntervalTime] = nil
  end
end

-- 获取最近的间隔时间，如果间隔内找不到，则返回nil
function MyTimeHelper:getLastFnIntervalTime (objid, t, second)
  for i = self.time, self.time - second + 1, -1 do
    local fnIs = self.fnIntervals[i]
    if (fnIs) then
      local ts = fnIs[objid]
      if (ts and ts[t]) then
        return i
      end
    end
  end
  return nil
end

function MyTimeHelper:setFnInterval (objid, t, f, time, p)
  local o = self.fnIntervals[time]
  if (not(o)) then
    o = {}
    self.fnIntervals[time] = o
  end
  if (not(o[objid])) then
    o[objid] = {}
  end
  if (f) then
    o[objid][t] = { f, p }
  else
    o[objid][t] = nil
  end
end

-- 至少间隔多少秒执行一次，如果当前符合条件，则执行；不符合，则记录下来，时间到了执行
function MyTimeHelper:callFnInterval (objid, t, f, second, p)
  if (not(objid)) then
    return
  end
  if (type(f) ~= 'function') then
    return
  end
  t = t or 'default'
  second = second or 1
  p = p or {}
  p.objid = objid
  local time, result
  local lastTime = self:getLastFnIntervalTime(objid, t, second)
  if (lastTime) then
    time = lastTime + second
  else
    time = self.time
    result = f(p)
    -- LogHelper:call(f, p)
  end
  self:setFnInterval(objid, t, f, time, p)
  return result
end

-- 查询最近间隔内的执行时间，如果没找到，则返回nil
function MyTimeHelper:getLastFnCanRunTime (objid, t, second)
  for i = self.time, self.time - second + 1, -1 do
    local fns = self.fnCanRuns[i]
    if (fns) then
      local arr = fns[objid]
      for i, v in ipairs(arr) do
        if (v == t) then
          return i
        end
      end
    end
  end
  return nil
end

function MyTimeHelper:addLastFnCanRunTime (objid, t)
  if (not(self.fnCanRuns[self.time])) then
    self.fnCanRuns[self.time] = {}
    self.fnCanRuns[self.time][objid] = { t }
  elseif (not(self.fnCanRuns[self.time][objid])) then
    self.fnCanRuns[self.time][objid] = { t }
  else
    table.insert(self.fnCanRuns[self.time][objid], t)
  end
end

-- 如果方法能执行则标记，然后执行；否则不执行
function MyTimeHelper:callFnCanRun (objid, t, f, second, p)
  if (not(objid)) then
    return
  end
  if (type(f) ~= 'function') then
    return
  end
  t = t or 'default'
  second = second or 0
  local lastTime = self:getLastFnCanRunTime(objid, t, second)
  if (not(lastTime)) then -- 没找到则标记，然后执行
    self:addLastFnCanRunTime(objid, t)
    LogHelper:call(f, p)
  end
end

function MyTimeHelper:callIntervalUntilSuccess ()
  return function (param)
    MyTimeHelper:setFnInterval(param.objid, param.t, nil, self.time)
    local result = MyTimeHelper:callFnInterval(param.objid, param.t, param.f, param.second, param.p)
    if (type(result) == 'nil') then -- 说明近期执行过，还会再次执行
      -- LogHelper:info(param.objid, ': nil')
    elseif (result) then -- 说明执行成功
      -- LogHelper:info('true')
    else -- 说明执行失败，则准备再次执行
      MyTimeHelper:setFnInterval(param.objid, param.t, MyTimeHelper:callIntervalUntilSuccess(), MyTimeHelper.time + param.second, param)
      -- LogHelper:info(param.objid, ': false')
    end
  end
end

-- 定时重复执行直到f返回true
function MyTimeHelper:repeatUtilSuccess (objid, t, f, second, p)
  self:callIntervalUntilSuccess()({ objid = objid, t = t, f = f, second = second, p = p })
end

function MyTimeHelper:initActor (myActor)
  self:repeatUtilSuccess(myActor.objid, 'initActor', function (myActor)
    return myActor:init()
  end, 10, myActor)
end