-- 我的自定义UI工具类
MyCustomUIHelper = {
  taskPannel = {}, -- objid -> boolean
}

function MyCustomUIHelper.init (objid)
  CustomuiHelper.hideElement(objid, MyMap.UI.SCREEN, MyMap.UI.TASK_PANNEL) -- 隐藏任务栏
  PlayerHelper.openUIView(objid, MyMap.UI.SCREEN) -- 显示UI界面
end

-- 点击
function MyCustomUIHelper.clickTaskBtn (objid, uiid)
  if MyCustomUIHelper.taskPannel[objid] then -- 任务栏显示着，则隐藏
    MyCustomUIHelper.taskPannel[objid] = false
    CustomuiHelper.hideElement(objid, uiid, MyMap.UI.TASK_PANNEL)
  else -- 隐藏着，则显示
    MyCustomUIHelper.taskPannel[objid] = true
    CustomuiHelper.showElement(objid, uiid, MyMap.UI.TASK_PANNEL)
  end
end

EventHelper.addEvent('clickButton', function (objid, uiid, elementid)
  if uiid == MyMap.UI.SCREEN then -- 点击初始界面
    if elementid == MyMap.UI.TASK_BTN then -- 点击任务按钮
      MyCustomUIHelper.clickTaskBtn(objid, uiid)
    end
  end
end)