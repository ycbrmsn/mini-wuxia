-- 剧情工具类
StoryHelper = {
  mainIndex = 1,
  mainProgress = 1,
  stories = {},
  initKey = {}, -- 剧情重新加载时校验使用
  alreadyLoad = false, -- 是否已经加载了
}

-- 检查剧情前置条件是否满足
function StoryHelper.check (mainIndex, mainProgress)
  mainProgress = StoryHelper.getRealProgress(mainProgress)
  return mainIndex == StoryHelper.mainIndex and mainProgress == StoryHelper.mainProgress
end

-- 剧情前进 两个progress都是要跳到剧情的前置
function StoryHelper.forward (mainIndex, mainProgress, endProgress)
  if StoryHelper.forward2(mainIndex, mainProgress, endProgress) then -- 剧情前进
    local hostPlayer = PlayerHelper.getHostPlayer()
    GameDataHelper.updateGameData(hostPlayer)
    EventHelper.customEvent('mainStoryForward', StoryHelper.getMainStoryIndex(),
      StoryHelper.getMainStoryProgress()) -- 主线剧情更新
    return true
  else
    return false
  end
end

-- 剧情前进，不更新剧情数据道具
function StoryHelper.forward2 (mainIndex, mainProgress, endProgress)
  if not StoryHelper.check(mainIndex, mainProgress) then -- 不是当前剧情进度
    return false
  end
  StoryHelper.setLoad(true)
  if endProgress then -- 如果有跳转剧情
    endProgress = StoryHelper.getRealProgress(endProgress)
    StoryHelper.mainProgress = endProgress + 1
  else -- 没有则顺延
    StoryHelper.mainProgress = StoryHelper.mainProgress + 1
  end
  if StoryHelper.mainProgress > #StoryHelper.stories[StoryHelper.mainIndex].tips then -- 进度越界，则到下一大剧情
    StoryHelper.mainIndex = StoryHelper.mainIndex + 1
    StoryHelper.mainProgress = 1
  end
  return true
end

--[[
  所有人剧情至少统一为房主主线，至少的意思是某些非房主可能剧情超过房主主线
  @param    {number} mainIndex 剧情序号，从1开始
  @param    {string} progressTitle 需要推进的小剧情名称
  @param    {string} endProgressTitle 推进到的小剧情名称（可选）
  @return   {boolean} true房主剧情推动 false房主剧情未推动
  @author   莫小仙
  @datetime 2021-10-16 22:10:38
]]
function StoryHelper.forwardAll (mainIndex, progressTitle, endProgressTitle)
  if StoryHelper.forward(mainIndex, progressTitle, endProgressTitle) then -- 剧情前进
    local index = StoryHelper.getMainStoryIndex()
    local progress = StoryHelper.getMainStoryProgress()
    PlayerHelper.everyPlayerDoSomeThing(function (player)
      TaskHelper.addStoryTask(player.objid, index, progress - 1)
    end)
    return true
  end
  return false
end

--[[
  根据玩家推荐剧情，房主可推进大小剧情，房客仅能推进小剧情
  @param    {number} objid 玩家id
  @param    {number} mainIndex 剧情序号，从1开始
  @param    {string} progressTitle 需要推进的小剧情名称
  @param    {string} endProgressTitle 推进到的小剧情名称（可选）
  @return   {boolean} true房主剧情推动 false房主剧情未推动 nil非房主记录任务
  @author   莫小仙
  @datetime 2021-10-03 22:26:16
]]
function StoryHelper.forwardByPlayer (objid, mainIndex, progressTitle, endProgressTitle)
  if PlayerHelper.isMainPlayer(objid) then -- 是房主，则更新剧情数据
    return StoryHelper.forward(mainIndex, progressTitle, endProgressTitle)
  else -- 反之，添加任务标记
    local story = StoryHelper.getStory(mainIndex)
    local taskid = story:getTaskIdByName(endProgressTitle or progressTitle)
    TaskHelper.addTask(objid, taskid) -- 加入剧情任务
    if endProgressTitle then -- 如果是跳转任务，则需要检查是否是从后往前跳的情况
      local taskid0 = story:getTaskIdByName(progressTitle)
      if taskid < taskid0 then -- 跳转的任务id比原任务id小，表示是从后往前跳。为了使主线剧情显示不出问题，则需要将之后的任务都删掉
        for i = taskid + 1, taskid0 do
          TaskHelper.removeTask(objid, i) -- 移除过头的剧情任务
        end
      end
    end
  end
end

-- 剧情跳转
function StoryHelper.goTo (mainIndex, mainProgress)
  StoryHelper.mainIndex = mainIndex
  StoryHelper.mainProgress = mainProgress
end

-- 获得实际进度序数
function StoryHelper.getRealProgress (progress)
  if type(progress) == 'string' then -- 是别名
    local story = StoryHelper.getStory(mainIndex)
    progress = story:getProgressPrepose(progress) or -1 -- 找不到就-1
  end
  return progress
end

-- 获得主线剧情序号
function StoryHelper.getMainStoryIndex ()
  return StoryHelper.mainIndex
end

-- 更新主线剧情序号
function StoryHelper.setMainStoryIndex (mainIndex)
  StoryHelper.mainIndex = mainIndex
end

-- 获得主线剧情进度序号
function StoryHelper.getMainStoryProgress ()
  return StoryHelper.mainProgress
end

-- 更新主线剧情进度序号
function StoryHelper.setMainStoryProgress (mainProgress)
  StoryHelper.mainProgress = mainProgress
end

-- 获得主线剧情序号与进度号
function StoryHelper.getIndexAndProgress ()
  return StoryHelper.getMainStoryIndex(), StoryHelper.getMainStoryProgress()
end

-- 获得剧情标题和内容
function StoryHelper.getMainStoryTitleAndTip (index, progress)
  progress = progress or StoryHelper.getMainStoryProgress()
  -- LogHelper.debug(index, '-', progress)
  local story = StoryHelper.getStory(index)
  return story.title, story.tips[progress]
end

--[[
  获取主剧情信息（标题与内容）
  @param    {number} objid 玩家id
  @return   {string string} 标题、提示
  @author   莫小仙
  @datetime 2021-10-01 18:31:43
]]
function StoryHelper.getMainStoryInfo (objid)
  local index, progress
  if PlayerHelper.isMainPlayer(objid) then -- 房主
    -- do nothing
  else -- 房客
    local taskid = TaskHelper.getMaxStoryTaskid(objid)
    index = math.floor(taskid / 100)
    progress = taskid % 100 + 1
  end
  return StoryHelper.getMainStoryTitleAndTip(index, progress)
end

-- 获取剧情
function StoryHelper.getStory (index)
  index = index or StoryHelper.getMainStoryIndex()
  return StoryHelper.stories[index]
end

-- 新增剧情
function StoryHelper.addStory (story)
  table.insert(StoryHelper.stories, story)
end

-- 获取所有剧情
function StoryHelper.getStorys ()
  return StoryHelper.stories
end

-- 设置剧情
function StoryHelper.setStorys (stories)
  StoryHelper.stories = stories
end

-- 剧情对应的任务id
function StoryHelper.getStoryTaskid (index, progress)
  return index * 100 + progress
end

-- 玩家重新进入游戏时恢复剧情
function StoryHelper.recover (player)
  if #StoryHelper.stories == 0 then -- 为0表示还没有初始化过
    MyStoryHelper.init()
  end
  if player then -- 非初始化剧情
    if PlayerHelper.isMainPlayer(player.objid) then -- 房主
      local story = StoryHelper.getStory()
      if story then -- 如果存在剧情
        if StoryHelper.isLoad() then -- 如果剧情已加载
          return false
        else
          StoryHelper.setLoad(true)
          for i, v in ipairs(PlayerHelper.getActivePlayers()) do
            story:recover(v)
            ChatHelper.sendMsg(v.objid, '游戏进度加载完成')
          end
          return true
        end
      end
    else -- 房客
      local story = StoryHelper.getStory()
      if story then -- 如果存在剧情
        story:recover(player)
      end
    end
  end
  
end

-- 剧情是否已经加载过
function StoryHelper.isLoad ()
  return StoryHelper.alreadyLoad
end

-- 设置剧情加载情况
function StoryHelper.setLoad (isLoad)
  StoryHelper.alreadyLoad = isLoad
end

-- 显示初始化剧情错误
function StoryHelper.showInitError (key, name)
  key = key or 'defaultInitKey'
  name = name or '必需角色'
  StoryHelper.initKey[key] = StoryHelper.initKey[key] or 1
  if StoryHelper.initKey[key] % 30 == 5 then -- 每30次执行一次
    ChatHelper.sendMsg(nil, '地图错误：', name, '未找到，找到', name, '后方可继续后续剧情')
  end
  StoryHelper.initKey[key] = StoryHelper.initKey[key] + 1
end

-- 进入未加载提示
function StoryHelper.loadTip (objid, seconds)
  seconds = seconds or 30
  if not StoryHelper.isLoad() then -- 未加载
    ChatHelper.sendMsg(objid, '当前游戏进度未加载，请加载进度')
    TimeHelper.callFnAfterSecond(function ()
      StoryHelper.loadTip(objid, seconds)
    end, seconds)
  end
end

-- 事件

-- 世界时间到[n]点
function StoryHelper.atHour (hour)
  -- body
end