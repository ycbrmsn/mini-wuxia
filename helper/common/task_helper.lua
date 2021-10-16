-- 任务工具类
TaskHelper = {
  tasks = {}, -- { 玩家 -> 任务id集合 } { playerid -> { taskid -> task/true } }
  needRemoveTasks = {}, -- map, 终止对话后需要删除的任务，即临时任务
  needBookTasks = {}, -- 需要任务书的任务 { task, task, ... }
}

-- 玩家是否有该任务
function TaskHelper.hasTask (playerid, taskid)
  local tasks = TaskHelper.getTasks(playerid)
  -- LogHelper.debug(tasks)
  if tasks[taskid] then
    -- LogHelper.debug('has task: ', taskid)
    return true
  else
    -- LogHelper.debug('no task: ', taskid)
    return false
  end
end

-- 获取任务
function TaskHelper.getTask (playerid, taskid)
  local tasks = TaskHelper.getTasks(playerid)
  return tasks[taskid]
end

-- 获取玩家已领取的所有任务
function TaskHelper.getTasks (playerid)
  if not TaskHelper.tasks[playerid] then
    TaskHelper.tasks[playerid] = {}
  end
  return TaskHelper.tasks[playerid]
end

-- 获取最大的任务id（主要用于剧情id）
function TaskHelper.getMaxStoryTaskid (playerid)
  local tasks = TaskHelper.getTasks(playerid)
  local maxId = -1
  for k, v in pairs(tasks) do
    if k < 10000 and k > maxId then -- 10000以上为任务各种状态
      maxId = k
    end
  end
  return maxId
end

-- 获取未结束的有效任务 state(任务状态1未完成2已完成3已结束)
function TaskHelper.getActiveTasks (playerid, state)
  local tasks = {}
  for taskid, task in pairs(TaskHelper.getTasks(playerid)) do
    if type(task) == 'table' then
      if state then
        local taskState = TaskHelper.getTaskState(playerid, taskid)
        if state == taskState then
          tasks[taskid] = task
        end
      elseif not task:isFinish() then
        tasks[taskid] = task
      end
    end
  end
  return tasks
end

-- 新增玩家任务
function TaskHelper.addTask (playerid, taskid, task)
  local tasks = TaskHelper.getTasks(playerid)
  if type(taskid) == 'table' then
    task = taskid
    taskid = task.id
  end
  if task then -- 有具体任务
    tasks[taskid] = task
  else
    tasks[taskid] = true
  end
  return task
end

-- 新增临时任务，仅用于控制对话
function TaskHelper.addTempTask (playerid, taskid)
  TaskHelper.addTask(playerid, taskid)
  TaskHelper.needRemoveTasks[taskid] = true
end

-- 新增剧情任务
function TaskHelper.addStoryTask (playerid, index, progress)
  index = index or StoryHelper.getMainStoryIndex()
  progress = progress or StoryHelper.getMainStoryProgress() - 1
  LogHelper.debug(index, 'add-', progress)
  TaskHelper.addTask(playerid, StoryHelper.getStoryTaskid(index, progress))
end

-- 删除玩家任务
function TaskHelper.removeTask (playerid, taskid)
  local tasks = TaskHelper.getTasks(playerid)
  if tasks[taskid] then
    tasks[taskid] = nil
    return true
  else
    return false
  end
end

-- 删除一些玩家任务
function TaskHelper.removeTasks (playerid, tids)
  local result = true
  for taskid, v in pairs(tids) do
    if not TaskHelper.removeTask(playerid, taskid) then -- 只要有任务删除失败，则提示失败
      result = false
    end
  end
  return result
end

-- 清空所有任务
function TaskHelper.clearTask (playerid)
  TaskHelper.tasks[playerid] = {}
end

-- 结束任务
function TaskHelper.tryFinishTask (playerid, taskid)
  local state = TaskHelper.getTaskState(playerid, taskid)
  if state == 1 then
    return false
  elseif state == 3 then
    return true
  else
    local task = TaskHelper.getTask(playerid, taskid)
    if task.category == 2 then -- 交付道具
      for i, itemInfo in ipairs(task.itemInfos) do
        BackpackHelper.removeGridItemByItemID(playerid, itemInfo.itemid, itemInfo.num)
      end
    end
    for i, reward in ipairs(task.rewards) do
      if reward.category == 1 then -- 道具
        BackpackHelper.gainItem(playerid, reward.itemid, reward.num)
      elseif reward.category == 2 then -- 经验
        local player = PlayerHelper.getPlayer(playerid)
        player:gainExp(reward.num)
      end
      if reward.f then -- 回调
        reward.f(playerid)
      end
    end
    if task.itemid then -- 需要任务书，则销毁任务书
      if BackpackHelper.hasItem(playerid, task.itemid, true) then
        BackpackHelper.removeGridItemByItemID(playerid, task.itemid, 1)
      end
    end
    task:setFinish()
    return true
  end
end

-- 玩家任务状态(1未完成2已完成3已结束)
function TaskHelper.getTaskState (playerid, taskid)
  local task = TaskHelper.getTask(playerid, taskid)
  if type(task) == 'table' then -- 具体任务
    if task:isFinish() then -- 已结束
      return 3
    elseif task:isComplete(playerid) then -- 已完成
      return 2
    else
      return 1
    end
  else -- 无具体任务，表示是一个简单任务。简单任务接受即完成。
    return 3
  end
end

-- 击杀角色 isShow是否提示击杀任务角色
function TaskHelper.playerDefeatActor (playerid, actorid, isShow)
  local tasks = TaskHelper.getActiveTasks(playerid)
  for taskid, task in pairs(tasks) do -- 所有任务
    if type(task) == 'table' and task.category == 1 then -- 击败任务
      for i, beatInfo in ipairs(task.beatInfos) do
        if actorid == beatInfo.actorid then -- 击败该生物
          beatInfo.curnum = beatInfo.curnum + 1
          if beatInfo.curnum <= beatInfo.num then -- 未超过任务数量
            local state = TaskHelper.getTaskState(playerid, taskid)
            if isShow then -- 显示
              TaskHelper.showTaskTips(playerid, task, 'chat')
              -- 暂时不显示任务进度
              -- ChatHelper.sendMsg(playerid, '击败', beatInfo.actorname, '（', beatInfo.curnum,
              --   '/', beatInfo.num, '）')
              -- if state == 2 then
              --   ChatHelper.sendMsg(playerid, task.name, '任务#G可交付')
              -- end
            end
            EventHelper.customEvent('playerDefeatTaskActor', playerid, task, actorid) -- 自定义击杀任务怪物
          end
          return
        end
      end
    end
  end
end

-- 获得道具 showType:none、chat、toast
function TaskHelper.playerAddItem (playerid, itemid, showType)
  showType = showType or 'none'
  local tasks = TaskHelper.getActiveTasks(playerid)
  for taskid, task in pairs(tasks) do -- 所有任务
    if type(task) == 'table' and task.category == 2 then -- 交付任务
      for i, itemInfo in ipairs(task.itemInfos) do
        if itemid == itemInfo.itemid then -- 获得该道具
          local curnum = BackpackHelper.getItemNumAndGrid(playerid, itemid)
          -- LogHelper.debug('当前有', curnum)
          if not itemInfo.curnum or itemInfo.curnum ~= curnum then -- 当前数量发生变化时提示
            itemInfo.curnum = curnum
            if curnum >= itemInfo.num then -- 达到目标
              if not task.enough then -- 之前道具不够
                task.enough = true
                TaskHelper.showTaskTips(playerid, task, 'chat')
                -- TaskHelper.showTips(showType, playerid, itemid, curnum, itemInfo.num, task)
              end
            else -- 未达到目标
              task.enough = false
              -- TaskHelper.showTips(showType, playerid, itemid, curnum, itemInfo.num, task)
              TaskHelper.showTaskTips(playerid, task, 'chat')
            end
            EventHelper.customEvent('playerAddTaskItem', playerid, task, itemid) -- 自定义获得任务道具
          end
          return
        end
      end
    end
  end
end

--[[
  玩家失去道具
  @param    {number} playerid 玩家id
  @param    {number} itemid 道具id
  @author   莫小仙
  @datetime 2021-10-02 00:19:39
]]
function TaskHelper.playerLoseItem (playerid, itemid)
  local tasks = TaskHelper.getActiveTasks(playerid)
  for taskid, task in pairs(tasks) do -- 所有任务
    if type(task) == 'table' and task.category == 2 then -- 交付任务
      for i, itemInfo in ipairs(task.itemInfos) do
        if itemid == itemInfo.itemid then -- 失去该道具
          itemInfo.curnum = curnum
          EventHelper.customEvent('playerLoseTaskItem', playerid, task, itemid) -- 自定义获得任务道具
          return
        end
      end
    end
  end
end

-- 显示获得任务道具后的提示
function TaskHelper.showTips (showType, objid, itemid, curnum, neednum, task)
  if showType == 'none' then
    return
  end
  -- 暂时不显示任务进度
  -- local msg = StringHelper.concat('获得', ItemHelper.getItemName(itemid),
  --   '#n（', curnum, '/', neednum, '）')
  local state = TaskHelper.getTaskState(objid, task.id)
  if showType == 'chat' then -- 聊天框信息提示
    -- ChatHelper.sendMsg(objid, msg)
    if state == 2 then
      ChatHelper.sendMsg(objid, task.name, '任务#G可交付')
    end
  elseif showType == 'toast' then -- 飘窗提示
    -- PlayerHelper.notifyGameInfo2Self(objid, msg)
    if state == 2 then
      PlayerHelper.notifyGameInfo2Self(objid, task.name .. '任务#G可交付')
    end
  end
end

--[[
  显示任务提示，目前仅当任务完成时提示
  @param    {number} objid 玩家id
  @param    {table} task 实际任务
  @param    {string} showType 提示类型 nil时不提示
  @author   莫小仙
  @datetime 2021-10-16 20:46:44
]]
function TaskHelper.showTaskTips (objid, task, showType)
  if not showType then
    return
  end
  local state = TaskHelper.getTaskState(objid, task.id)
  if state == 2 then -- 任务完成
    if showType == 'chat' then -- 聊天框提示
      ChatHelper.sendMsg(objid, task.name, '任务#G可交付')
    elseif showType == 'toast' then -- 飘窗提示
      PlayerHelper.notifyGameInfo2Self(objid, task.name .. '任务#G可交付')
    end
  end
end

-- 定义规则
--[==[
  如果有一任务id为n，则
  玩家接受此任务，获得新任务，其id为n * 10000
  玩家查询此任务，获得新任务，其id为n * 10000 + 1
  玩家交付此任务，获得新任务，其id为n * 10000 + 2
]==]--

-- 插入选项，未插入时返回false
function TaskHelper.appendPlayerTalk (playerTalks, player, cTask)
  local realid = cTask:getRealid()
  table.insert(playerTalks, PlayerTalk:continue(cTask.name .. '任务#G(已接受)')
    :ant(TalkAnt:includeTask(realid, 1)):call(function (player)
    TaskHelper.addTempTask(player.objid, realid + 1)
    player:resetTalkIndex(0)
  end))
  table.insert(playerTalks, PlayerTalk:continue(cTask.name .. '任务#G(可交付)')
    :ant(TalkAnt:includeTask(realid, 2)):call(function (player)
    TaskHelper.addTempTask(player.objid, realid + 2)
    player:resetTalkIndex(0)
  end))
  table.insert(playerTalks, PlayerTalk:continue(cTask.name .. '任务')
    :ant(TalkAnt:excludeTask(realid)):call(function (player)
    TaskHelper.addTempTask(player.objid, cTask.id)
    player:resetTalkIndex(0)
  end))
  -- if type(taskid) == 'table' then
  --   taskid, taskname = taskid.id, taskid.name
  -- end
  -- if TaskHelper.hasTask(player.objid, taskid * 10000) then -- 已有任务
  --   local state = TaskHelper.getTaskState(player.objid, taskid * 10000)
  --   if state == 1 then -- 未完成
  --     table.insert(playerTalks, PlayerTalk:continue(taskname .. '任务#G(已接受)'):call(function (player)
  --       TaskHelper.addTempTask(player.objid, taskid * 10000 + 1)
  --       player:resetTalkIndex(0)
  --     end))
  --     return true
  --   elseif state == 2 then -- 已完成
  --     table.insert(playerTalks, PlayerTalk:continue(taskname .. '任务#G(可交付)'):call(function (player)
  --       TaskHelper.addTempTask(player.objid, taskid * 10000 + 2)
  --       player:resetTalkIndex(0)
  --     end))
  --     return true
  --   else -- 已结束
  --     return false
  --   end
  -- else -- 未接任务
  --   table.insert(playerTalks, PlayerTalk:continue(taskname .. '任务'):call(function (player)
  --     TaskHelper.addTempTask(player.objid, taskid)
  --     player:resetTalkIndex(0)
  --   end))
  --   return true
  -- end
end

-- 初始化任务相关选项 ...能够接受所需达到的条件
function TaskHelper.initTaskTalkChoices (player, cTask, ...)
  local ants = { ... }
  local arr = {}
  local realid = cTask:getRealid()
  table.insert(arr, PlayerTalk:continue(cTask.name .. '任务#G(已接受)')
    :ant(TalkAnt:includeTask(realid, 1)):call(function (player)
      TaskHelper.addTempTask(player.objid, realid + 1)
      player:resetTalkIndex(0)
  end))
  table.insert(arr, PlayerTalk:continue(cTask.name .. '任务#G(可交付)')
    :ant(TalkAnt:includeTask(realid, 2)):call(function (player)
      TaskHelper.addTempTask(player.objid, realid + 2)
      player:resetTalkIndex(0)
  end))
  if cTask.isSingleton then -- 如果是唯一任务
    table.insert(ants, TalkAnt:excludeTask(realid))
  else -- 不是唯一任务
    table.insert(ants, TalkAnt:excludeTask(realid, 1)) -- 排除 任务未完成
    table.insert(ants, TalkAnt:excludeTask(realid, 2)) -- 排除 任务可交付
  end
  table.insert(arr, PlayerTalk:continue(cTask.name .. '任务')
    :ant(table.unpack(ants)):call(function (player)
      TaskHelper.addTempTask(player.objid, cTask.id)
      player:resetTalkIndex(0)
  end))
  return arr
end

-- 接受具体任务
function TaskHelper.acceptTask (objid, cTask)
  local task = cTask:realTask()
  TaskHelper.addTask(objid, task)
  if task.itemid then -- 需要任务书
    if not BackpackHelper.hasItem(objid, task.itemid, true) then -- 如果没有任务书，则给玩家一个
      BackpackHelper.gainItem(objid, task.itemid, 1)
    end
  end
  PlayerHelper.notifyGameInfo2Self(objid, '接受#G' .. task.name .. '任务')
end

--[[
  完成任务，手动设置为完成状态
  @param    {number} objid 玩家id
  @param    {table} cTask 任务
  @author   莫小仙
  @datetime 2021-10-04 23:36:55
]]
function TaskHelper.completeTask (objid, cTask)
  local task = TaskHelper.getTask(objid, cTask:getRealid())
  if task then -- 如果任务存在，则设置任务为完成
    task:setComplete(true) -- 设置为完成
    EventHelper.customEvent('playerCompleteTask', objid, task) -- 完成自定义任务
  end
end

-- 完成具体任务
function TaskHelper.finishTask (objid, cTask)
  if TaskHelper.tryFinishTask(objid, cTask:getRealid()) then
    PlayerHelper.notifyGameInfo2Self(objid, '完成#G' .. cTask.name .. '任务')
  end
end

-- 生成无法接任务对话选项
function TaskHelper.generateUnableAcceptTalk (cTask, talks, ants)
  local sessions = {}
  for i, v in ipairs(talks) do
    table.insert(sessions, TalkSession:new({ t = v[1], msg = v[2] }))
  end
  local taskid = cTask.id
  local realid = cTask:getRealid()
  local talkAnts = ants or {}
  table.insert(talkAnts, TalkAnt:includeTask(taskid)) -- 选择任务
  table.insert(talkAnts, TalkAnt:excludeTask(realid, 1)) -- 排除 任务未完成
  table.insert(talkAnts, TalkAnt:excludeTask(realid, 2)) -- 排除 任务可交付
  return TalkInfo:new({
    id = realid + 3,
    ants = talkAnts,
    progress = {
      [0] = sessions
    },
  })
end

-- 生成接任务对话选项
function TaskHelper.generateAcceptTalk (cTask, talks, ants)
  local sessions = {}
  for i, v in ipairs(talks) do
    if i ~= #talks then
      table.insert(sessions, TalkSession:new({ t = v[1], msg = v[2] }))
    else
      table.insert(sessions, TalkSession:choose({
        PlayerTalk:acceptTask('接受', cTask, v[1]),
        PlayerTalk:stop('拒绝', v[2]),
      }))
    end
  end
  local taskid = cTask.id
  local realid = cTask:getRealid()
  local talkAnts = ants or {}
  table.insert(talkAnts, TalkAnt:includeTask(taskid)) -- 选择任务
  table.insert(talkAnts, TalkAnt:excludeTask(realid, 1)) -- 排除 任务未完成
  table.insert(talkAnts, TalkAnt:excludeTask(realid, 2)) -- 排除 任务可交付
  return TalkInfo:new({
    id = taskid,
    ants = talkAnts,
    progress = {
      [0] = sessions
    }
  })
end

-- 生成查询任务对话
function TaskHelper.generateQueryTalk (cTask, talks)
  local sessions = {}
  for i, v in ipairs(talks) do
    table.insert(sessions, TalkSession:new({ t = v[1], msg = v[2] }))
  end
  local realid = cTask:getRealid()
  return TalkInfo:new({
    id = realid + 1,
    ants = {
      TalkAnt:includeTask(realid + 1),
    },
    progress = {
      [0] = sessions
    },
  })
end

-- 生成交付任务对话
function TaskHelper.generatePayTalk (cTask, talks, callback)
  local sessions = {}
  for i, v in ipairs(talks) do
    if i ~= #talks then
      table.insert(sessions, TalkSession:new({ t = v[1], msg = v[2] }))
    else
      local session = TalkSession:new({ t = v[1], msg = v[2] })
      if callback then
        callback()
      else -- 正常结束
        session:call(function (player)
          TaskHelper.finishTask(player.objid, cTask)
        end)
      end
      table.insert(sessions, session)
    end
  end
  local realid = cTask:getRealid()
  return TalkInfo:new({
    id = realid + 2,
    ants = {
      TalkAnt:includeTask(realid + 2),
      TalkAnt:includeTask(realid, 2),
    },
    progress = {
      [0] = sessions
    },
  })
end