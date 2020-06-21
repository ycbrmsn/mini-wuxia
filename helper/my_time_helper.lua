-- 我的时间工具类
MyTimeHelper = {
  hour = nil,
  time = 0,
  frame = 0, -- 帧
  frameInfo = {}, -- 帧对应信息
  fns = {}, -- second -> { { f, p }, { f, p }, ... }
  fnIntervals = {}, -- second -> { objid = { t = { f, p }, t = { f, p } }, objid = { t = { f, p }, t = { f, p } }, ... }
  fnCanRuns = {}, -- second -> { objid = { t, t }, objid = { t, t } ... }
  fnLastRuns = {}, -- second -> { objid = { t = { f, p }, t = { f, p } }, objid = { t = { f, p }, t = { f, p } }, ... }
  fnFastRuns = {}, -- { { second, f, t } }
  fnContinueRuns = {} -- { t = { second, f, p }, t = { second, f, p }, ... }
}

function MyTimeHelper:updateHour (hour)
  self.hour = hour
end

-- 更新时间
function MyTimeHelper:updateTime (second)
  self.time = second
end

function MyTimeHelper:addFrame ()
  if (self.frameInfo[self.frame]) then
    self.frameInfo[self.frame] = nil
  end
  self.frame = self.frame + 1
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

function MyTimeHelper:getFrameInfo (key)
  if (not(self.frameInfo[self.frame])) then
    return nil
  end
  return self.frameInfo[self.frame][key]
end

function MyTimeHelper:setFrameInfo (key, val)
  if (not(self.frameInfo[self.frame])) then
    self.frameInfo[self.frame] = {}
  end
  self.frameInfo[self.frame][key] = val
end

-- 添加方法
function MyTimeHelper:addFn (f, time, p)
  local fs = self.fns[time]
  if (not(fs)) then
    fs = {}
    self.fns[time] = fs
  end
  table.insert(fs, { f, p })
  return #fs
end

-- 删除方法
function MyTimeHelper:delFn (time, index)
  if (not(index)) then
    self.fns[time] = nil
  else
    if (self.fns[time]) then
      self.fns[time][index] = nil
    end
  end
end

-- 运行方法，然后删除
function MyTimeHelper:runFnAfterSecond (time)
  local fs = self.fns[time]
  if (fs) then
    for i, v in ipairs(fs) do
      if (v) then
        v[1](v[2])
      end
    end
    self:delFn(time)
  end
end

-- 参数为：函数、秒、函数的参数table。大致几秒后执行方法
function MyTimeHelper:callFnAfterSecond (f, second, p)
  if (type(f) ~= 'function') then
    return
  end
  second = second or 1
  local time = self.time + second
  local index = self:addFn(f, time, p)
  return time, index
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

-- 至少间隔多少秒执行一次，如果当前符合条件，则立即执行；不符合，则记录下来，时间到了（间隔上次执行多少秒后）执行
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

-- 如果方法能执行（间隔上次执行多少秒之后）则标记，然后执行；否则（间隔时间不够）不执行
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
    f(p)
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

function MyTimeHelper:runFnLastRuns (time)
  local fs = self.fnLastRuns[time]
  if (fs) then
    for oid, ts in pairs(fs) do
      for k, v in pairs(ts) do
        v[1](v[2])
      end
    end
  end
  -- 清除较长时间间隔的数据
  local longIntervalTime = time - 20
  if (self.fnLastRuns[longIntervalTime]) then
    self.fnLastRuns[longIntervalTime] = nil
  end
end

-- 删除最后执行时间之前的相同类型的数据
function MyTimeHelper:delLastFnLastRunTime (objid, t, second)
  for i = self.time + second - 1, self.time, -1 do
    local fnIs = self.fnLastRuns[i]
    if (fnIs) then
      local ts = fnIs[objid]
      if (ts and ts[t]) then
        ts[t] = nil
      end
    end
  end
end

function MyTimeHelper:setFnLastRun (objid, t, f, time, p)
  local o = self.fnLastRuns[time]
  if (not(o)) then
    o = {}
    self.fnLastRuns[time] = o
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

-- 多少秒之后（时间点）执行一次，记录下来，时间点到了执行。记录时如果该时间点之前有该类型数据，则删除
function MyTimeHelper:callFnLastRun (objid, t, f, second, p)
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
  self:delLastFnLastRunTime(objid, t, second)
  self:setFnLastRun(objid, t, f, self.time + second, p)
end

-- 添加方法
function MyTimeHelper:addFnFastRuns (f, second, t)
  table.insert(self.fnFastRuns, { second * 1000, f, t })
end

-- 删除方法
function MyTimeHelper:delFnFastRuns (t)
  for i = #self.fnFastRuns, 1, -1 do
    if (self.fnFastRuns[i][3] and self.fnFastRuns[i][3] == t) then
      table.remove(self.fnFastRuns, i)
    end
  end
end

-- 运行方法，然后删除
function MyTimeHelper:runFnFastRuns ()
  for i = #self.fnFastRuns, 1, -1 do
    self.fnFastRuns[i][1] = self.fnFastRuns[i][1] - 50
    if (self.fnFastRuns[i][1] <= 0) then
      self.fnFastRuns[i][2]()
      table.remove(self.fnFastRuns, i)
    end
  end
end

-- 参数为：函数、秒、类型。精确几秒后执行方法，精确到0.05秒
function MyTimeHelper:callFnFastRuns (f, second, t)
  if (type(f) ~= 'function') then
    return
  end
  second = second or 1
  self:addFnFastRuns(f, second, t)
end

-- 添加方法
function MyTimeHelper:addFnContinueRuns (f, second, t, p)
  self.fnContinueRuns[t] = { second * 1000, f, p }
end

-- 删除方法
function MyTimeHelper:delFnContinueRuns (t)
  self.fnContinueRuns[t] = nil
end

-- 运行方法，然后删除
function MyTimeHelper:runFnContinueRuns ()
  for k, v in pairs(self.fnContinueRuns) do
    v[1] = v[1] - 50
    v[2](v[3])
    if (v[1] <= 0) then
      self:delFnContinueRuns(k)
    end
  end
end

-- 参数为：函数、秒、函数的参数table。持续执行方法，精确到0.05秒
function MyTimeHelper:callFnContinueRuns (f, second, t, p)
  if (type(f) ~= 'function') then
    return
  end
  second = second or 1
  t = t or os.time()
  self:addFnContinueRuns(f, second, t, p)
end

function MyTimeHelper:doPerSecond (second)
  self:updateTime(second)
  self:runFnAfterSecond(second)
  self:runFnInterval(second)
  self:runFnLastRuns(second)
end