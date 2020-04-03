-- 我的时间工具类
MyTimeHelper = {
  time = 0,
  fns = {}, -- second -> { { f, p }, { f, p }, ... }
  fnIntervals = {}, -- second -> { objid = { t, f, p }, objid = { t, f, p }, ... }
  fnCanRuns = {} -- second -> { objid = t, objid = t, ... }
}

-- 更新时间
function MyTimeHelper:updateTime (second)
  self.time = second
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
function MyTimeHelper:runFn (time)
  local fs = self.fns[time]
  if (fs) then
    for i, v in ipairs(fs) do
      v[1](v[2])
    end
    fs = nil
  end
end

-- 参数为：函数、秒、函数的参数table
function MyTimeHelper:runFnAfterSecond (f, second, p)
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
    for k, v in pairs(fs) do
      v[2](v[3])
    end
  end
  -- 清除较长时间间隔的数据
  local longIntervalTime = time - 10
  if (self.fnIntervals[longIntervalTime]) then
    self.fnIntervals[longIntervalTime] = nil
  end
end

-- 获取最近的间隔时间，如果间隔内找不到，则返回nil
function MyTimeHelper:getLastFnIntervalTime (objid, t, second)
  for i = self.time, self.time - second, -1 do
    local fnIs = self.fnIntervals[i]
    if (fnIs) then
      local arr = fnIs[objid]
      if (arr and arr[0] == t) then
        return i
      end
    end
  end
  return nil
end

-- 至少间隔多少秒执行一次，如果当前符合条件，则执行；不符合，则记录下来，时间到了执行
function MyTimeHelper:runFnInterval (objid, t, f, second, p)
  if (not(objid)) then
    return
  end
  if (type(f) ~= 'function') then
    return
  end
  t = t or 'default'
  second = second or 1
  p.objid = objid
  local time
  local lastTime = self:getLastFnIntervalTime(objid, t, second)
  if (lastTime) then
    time = lastTime + second
  else
    time = self.time
    LogHelper:call(f, p)
  end
  self.fnIntervals[time][objid] = { t, f, p }
end

-- 查询最近间隔内的执行时间，如果没找到，则返回nil
function MyTimeHelper:getLastFnCanRunTime (objid, t, second)
  for i = self.time, self.time - second, -1 do
    local fns = self.fnCanRuns[i]
    if (fns) then
      local tt = fns[objid]
      if (tt and tt == t) then
        return i
      end
    end
  end
  return nil
end

-- 如果方法能执行则标记，然后执行；否则不执行
function MyTimeHelper:runFnCanRun (objid, t, f, second, p)
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
    self.fnCanRuns[self.time][objid] = t
    LogHelper:call(f, p)
  end
end