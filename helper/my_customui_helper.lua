-- 我的自定义UI工具类
MyCustomUIHelper = {
  PAGE_SIZE = 3, -- 每页条数
  taskInfo = {}, -- objid -> { isShow, page, pageSize, tasks, taskid }
  centerBox = {}, -- objid -> { isShow, txt }
}

--[[
  初始化玩家的UI界面
  @param    {number} objid 玩家id
  @author   莫小仙
  @datetime 2021-10-01 17:26:48
]]
function MyCustomUIHelper.init (objid)
  CustomuiHelper.hideElement(objid, MyMap.UI.SCREEN, MyMap.UI.TASK_PANNEL) -- 隐藏任务栏
  MyCustomUIHelper.hideCenterBox(objid) -- 隐藏中心文字板
  PlayerHelper.openUIView(objid, MyMap.UI.SCREEN) -- 显示UI界面
end

--[[
  获取玩家的任务信息，包括任务面板是否显示、任务显示页数等
  @param    {number} objid 玩家id
  @return   {table} 显示任务相关信息
  @author   莫小仙
  @datetime 2021-10-01 20:50:39
]]
function MyCustomUIHelper.getTaskInfo (objid)
  local info = MyCustomUIHelper.taskInfo[objid]
  if not info then
    info = { isShow = false, page = 1, pageSize = MyCustomUIHelper.PAGE_SIZE, tasks = {}, taskid = -1 }
    MyCustomUIHelper.taskInfo[objid] = info
  end
  return info
end

--[[
  玩家点击任务按钮
  @param    {number} objid 玩家id
  @author   莫小仙
  @datetime 2021-10-01 18:09:21
]]
function MyCustomUIHelper.clickTaskBtn (objid)
  local uiid = MyMap.UI.SCREEN
  local taskInfo = MyCustomUIHelper.getTaskInfo(objid)
  if taskInfo.isShow then -- 任务栏显示着，则隐藏
    taskInfo.isShow = false
    CustomuiHelper.hideElement(objid, uiid, MyMap.UI.TASK_PANNEL)
    if taskInfo.taskid > -1 then -- 如果中心文字面板是显示的任务，则也隐藏
      MyCustomUIHelper.hideCenterBox(objid) -- 隐藏中心文字板
    end
  else -- 隐藏着，则显示
    MyCustomUIHelper.refreshTaskPanel(objid) -- 刷新任务面板
    -- 显示
    taskInfo.isShow = true
    CustomuiHelper.showElement(objid, uiid, MyMap.UI.TASK_PANNEL)
  end
end

--[[
  刷新任务面板
  @param    {number} objid 玩家id
  @param    {number} page 当前页数，默认为当前页
  @author   莫小仙
  @datetime 2021-10-01 21:18:45
]]
function MyCustomUIHelper.refreshTaskPanel (objid, page)
  local uiid = MyMap.UI.SCREEN
  local taskInfo = MyCustomUIHelper.getTaskInfo(objid)
  page = page or taskInfo.page
  taskInfo.tasks = {}
  -- 查询主线任务
  local title, content = StoryHelper.getMainStoryInfo(objid)
  CustomuiHelper.setText(objid, uiid, MyMap.UI.TASK_TXT1, title) -- 设置主剧情标题
  table.insert(taskInfo.tasks, { name = title, desc = content })
  -- 查询支线任务
  local tasks = TaskHelper.getTasks(objid)
  local taskArr = {} -- 支线任务数组
  for k, task in pairs(tasks) do
    if type(task) == 'table' then
      table.insert(taskArr, task)
    end
  end
  local pageSize = taskInfo.pageSize
  local hasNextPage = true
  if #taskArr <= pageSize then -- 任务数不足一页
    page = 1
    taskInfo.page = 1
    hasNextPage = false
  elseif #taskArr <= pageSize * (page - 1) then -- 表示没有当前页
    page = 1
    taskInfo.page = 1
  end
  local taskIndex = (page - 1) * pageSize
  local num = #taskArr - taskIndex < taskInfo.pageSize and #taskArr or taskInfo.pageSize -- 要显示的任务按钮数
  for i = 1, num do -- 循环显示任务按钮
    local task = taskArr[i + taskIndex]
    table.insert(taskInfo.tasks, task)
    if task:isComplete(objid) then -- 如果任务完成，则修改标签图案
      CustomuiHelper.setTexture(objid, uiid, MyMap.UI['TASK_BTN' .. (i + 1)], '10309') -- 绿色
    else -- 没完成，则修改为原图案
      CustomuiHelper.setTexture(objid, uiid, MyMap.UI['TASK_BTN' .. (i + 1)], '10312') -- 黄色
    end
    CustomuiHelper.setText(objid, uiid, MyMap.UI['TASK_TXT' .. (i + 1)], task.name)
    CustomuiHelper.showElement(objid, uiid, MyMap.UI['TASK_BTN' .. (i + 1)])
  end
  for i = 1, 3 - num do -- 循环隐藏任务按钮
    CustomuiHelper.hideElement(objid, uiid, MyMap.UI['TASK_BTN' .. (5 - i)])
  end
  if hasNextPage then -- 有下一页，则显示翻页按钮
    CustomuiHelper.showElement(objid, uiid, MyMap.UI.TASK_BTN5)
  else -- 反之，隐藏翻页按钮
    CustomuiHelper.hideElement(objid, uiid, MyMap.UI.TASK_BTN5)
  end
end

--[[
  获取中心文字板信息，包括是否显示、显示内容
  @param    {number} objid 玩家id
  @return   {table} 文字板信息
  @author   莫小仙
  @datetime 2021-10-01 21:04:29
]]
function MyCustomUIHelper.getCenterBoxInfo (objid)
  local info = MyCustomUIHelper.centerBox[objid]
  if not info then -- 不存在，则初始化一个
    info = { isShow = false, txt = '' }
    MyCustomUIHelper.centerBox[objid] = info
  end
  return info
end

--[[
  显示中心文字板内容
  @param    {number} objid 玩家id
  @param    {string} txt 显示字符串
  @author   莫小仙
  @datetime 2021-10-01 20:48:34
]]
function MyCustomUIHelper.showCenterBox (objid, txt)
  local info = MyCustomUIHelper.getCenterBoxInfo(objid)
  info.isShow = true
  info.txt = txt
  CustomuiHelper.setText(objid, MyMap.UI.SCREEN, MyMap.UI.CENTER_TXT, txt) -- 设置中心文字
  CustomuiHelper.showElement(objid, MyMap.UI.SCREEN, MyMap.UI.CENTER_PANEL) -- 显示中心文字板
end

--[[
  隐藏中心文字板
  @param    {number} objid 玩家id
  @author   莫小仙
  @datetime 2021-10-01 20:49:17
]]
function MyCustomUIHelper.hideCenterBox (objid)
  local info = MyCustomUIHelper.getCenterBoxInfo(objid)
  info.isShow = false
  CustomuiHelper.hideElement(objid, MyMap.UI.SCREEN, MyMap.UI.CENTER_PANEL) -- 隐藏中心文字板
end

--[[
  切换显示：隐藏时则显示；显示时，如果内容相同，则隐藏；如果内容不同，则更新
  @param    {number} objid 玩家id
  @param    {string} txt 字符串
  @author   莫小仙
  @datetime 2021-10-01 21:10:20
]]
function MyCustomUIHelper.toggleCenterBox (objid, txt)
  local info = MyCustomUIHelper.getCenterBoxInfo(objid)
  if not info.isShow then -- 如果没显示
    MyCustomUIHelper.showCenterBox(objid, txt)
  else -- 显示了
    if info.txt == txt then -- 显示内容相同，则隐藏
      MyCustomUIHelper.hideCenterBox(objid)
    else -- 不相同，则更新内容
      MyCustomUIHelper.showCenterBox(objid, txt)
    end
  end
end

--[[
  更新剧情信息（如果目前是显示的剧情信息）
  @param    {number} objid 玩家id
  @author   莫小仙
  @datetime 2021-10-02 16:06:58
]]
function MyCustomUIHelper.updateStoryMessage (objid)
  local taskInfo = MyCustomUIHelper.getTaskInfo(objid)
  if taskInfo.taskid == 0 then -- 表示中心文字显示的是剧情信息
    local title, content = StoryHelper.getMainStoryInfo(objid)
    MyCustomUIHelper.showCenterBox(objid, content)
  end
end

--[[
  更新任务信息
  @param    {number} objid 玩家id
  @param    {table} task 任务对象
  @param    {boolean} ignoreOther 是否忽略显示内容是不是其他的
  @author   莫小仙
  @datetime 2021-10-01 23:33:14
]]
function MyCustomUIHelper.updateTaskMessage (objid, task, ignoreOther)
  local taskInfo = MyCustomUIHelper.getTaskInfo(objid)
  local messages = task:getMessage(objid)
  local txt = StringHelper.join(messages, '\n')
  if ignoreOther then -- 如果不在意当前是什么内容都替换
    MyCustomUIHelper.toggleCenterBox(objid, txt)
  else -- 仅当显示当前内容时替换
    if taskInfo.taskid == task.id then -- 显示相同任务内容
      MyCustomUIHelper.showCenterBox(objid, txt)
    end
  end
end

--[[
  监听玩家点击按钮事件
  @author   莫小仙
  @datetime 2021-10-01 18:12:19
]]
EventHelper.addEvent('clickButton', function (objid, uiid, elementid)
  if uiid == MyMap.UI.SCREEN then -- 点击初始界面
    local taskInfo = MyCustomUIHelper.getTaskInfo(objid)
    if elementid == MyMap.UI.TASK_BTN then -- 点击任务按钮
      MyCustomUIHelper.clickTaskBtn(objid)
    elseif elementid == MyMap.UI.TASK_BTN1 then -- 点击主剧情按钮
      taskInfo.taskid = 0
      local title, content = StoryHelper.getMainStoryInfo(objid)
      MyCustomUIHelper.toggleCenterBox(objid, content)
    elseif elementid == MyMap.UI.TASK_BTN2 then -- 点击任务按钮1
      local task = taskInfo.tasks[2]
      taskInfo.taskid = task.id
      MyCustomUIHelper.updateTaskMessage(objid, task, true)
    elseif elementid == MyMap.UI.TASK_BTN3 then -- 点击任务按钮2
      local task = taskInfo.tasks[3]
      taskInfo.taskid = task.id
      MyCustomUIHelper.updateTaskMessage(objid, task, true)
    elseif elementid == MyMap.UI.TASK_BTN4 then -- 点击任务按钮3
      local task = taskInfo.tasks[4]
      taskInfo.taskid = task.id
      MyCustomUIHelper.updateTaskMessage(objid, task, true)
    elseif elementid == MyMap.UI.TASK_BTN5 then -- 点击翻页按钮
      MyCustomUIHelper.refreshTaskPanel(objid, taskInfo.page + 1)
    end
  end
end)

--[[
  监听玩家获得任务道具事件
  @author   莫小仙
  @datetime 2021-10-02 00:30:59
]]
EventHelper.addEvent('playerAddTaskItem', function (objid, task, itemid)
  MyCustomUIHelper.refreshTaskPanel(objid) -- 刷新任务面板
  MyCustomUIHelper.updateTaskMessage(objid, task) -- 有可能更新中心文字
end)

--[[
  监听玩家失去任务道具事件
  @author   莫小仙
  @datetime 2021-10-02 00:31:02
]]
EventHelper.addEvent('playerLoseTaskItem', function (objid, task, itemid)
  MyCustomUIHelper.refreshTaskPanel(objid) -- 刷新任务面板
  MyCustomUIHelper.updateTaskMessage(objid, task) -- 有可能更新中心文字
end)

--[[
  监听玩家击败任务生物事件
  @author   莫小仙
  @datetime 2021-10-02 00:31:05
]]
EventHelper.addEvent('playerDefeatTaskActor', function (objid, task, actorid)
  MyCustomUIHelper.refreshTaskPanel(objid) -- 刷新任务面板
  MyCustomUIHelper.updateTaskMessage(objid, task) -- 有可能更新中心文字
end)

--[[
  监听主线剧情更新事件
  @author   莫小仙
  @datetime 2021-10-02 15:56:50
]]
EventHelper.addEvent('mainStoryForward', function (index, progress)
  PlayerHelper.everyPlayerDoSomeThing(function (player)
    MyCustomUIHelper.refreshTaskPanel(player.objid) -- 刷新任务面板
    MyCustomUIHelper.updateStoryMessage(player.objid) -- 有可能更新中心文字
  end)
end)
