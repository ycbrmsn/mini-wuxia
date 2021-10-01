-- 自定义UI工具类
CustomuiHelper = {}

-- 事件

-- 当前界面按钮被点击
function CustomuiHelper.clickButton (objid, uiid, elementid)
  -- body
end

-- 界面隐藏
function CustomuiHelper.hideUI (objid, uiid)
  -- body
end

-- 界面显示
function CustomuiHelper.showUI (objid, uiid)
  -- body
end

-- 封装原始接口

function CustomuiHelper.setText (playerid, uiid, elementid, text)
  return CommonHelper.callIsSuccessMethod(function ()
    return Coustomui:setText(playerid, uiid, elementid, text)
  end, '设置文本元件内容', 'playerid=', playerid, ',uiid=', uiid, ',elementid=', elementid, ',text=', text)
end

function CustomuiHelper.setTexture (playerid, uiid, elementid, url)
  return CommonHelper.callIsSuccessMethod(function ()
    return Coustomui:setTexture(playerid, uiid, elementid, url)
  end, '设置文本元件图案纹理', 'playerid=', playerid, ',uiid=', uiid, ',elementid=', elementid, ',url=', url)
end

function CustomuiHelper.setSize (playerid, uiid, elementid, width, height)
  return CommonHelper.callIsSuccessMethod(function ()
    return Coustomui:setSize(playerid, uiid, elementid, width, height)
  end, '设置元件大小', 'playerid=', playerid, ',uiid=', uiid, ',elementid=', elementid, ',width=', width, ',height=', height)
end

function CustomuiHelper.setFontSize (playerid, uiid, elementid, size)
  return CommonHelper.callIsSuccessMethod(function ()
    return Coustomui:setFontSize(playerid, uiid, elementid, size)
  end, '设置文本元件字体大小', 'playerid=', playerid, ',uiid=', uiid, ',elementid=', elementid, ',size=', size)
end

function CustomuiHelper.setColor (playerid, uiid, elementid, color)
  return CommonHelper.callIsSuccessMethod(function ()
    return Coustomui:setColor(playerid, uiid, elementid, color)
  end, '设置文本元件颜色', 'playerid=', playerid, ',uiid=', uiid, ',elementid=', elementid, ',color=', color)
end

function CustomuiHelper.showElement (playerid, uiid, elementid)
  return CommonHelper.callIsSuccessMethod(function ()
    return Coustomui:showElement(playerid, uiid, elementid)
  end, '显示元件', 'playerid=', playerid, ',uiid=', uiid, ',elementid=', elementid)
end

function CustomuiHelper.hideElement (playerid, uiid, elementid)
  return CommonHelper.callIsSuccessMethod(function ()
    return Coustomui:hideElement(playerid, uiid, elementid)
  end, '隐藏元件', 'playerid=', playerid, ',uiid=', uiid, ',elementid=', elementid)
end

function CustomuiHelper.rotateElement (playerid, uiid, elementid, rotate)
  return CommonHelper.callIsSuccessMethod(function ()
    return Coustomui:rotateElement(playerid, uiid, elementid, rotate)
  end, '旋转元件', 'playerid=', playerid, ',uiid=', uiid, ',elementid=', elementid, ',rotate=', rotate)
end

function CustomuiHelper.setAlpha (playerid, uiid, elementid, alpha)
  return CommonHelper.callIsSuccessMethod(function ()
    return Coustomui:setAlpha(playerid, uiid, elementid, alpha)
  end, '设置透明度', 'playerid=', playerid, ',uiid=', uiid, ',elementid=', elementid, ',alpha=', alpha)
end

function CustomuiHelper.setState (playerid, uiid, elementid, state)
  return CommonHelper.callIsSuccessMethod(function ()
    return Coustomui:setState(playerid, uiid, elementid, state)
  end, '设置状态', 'playerid=', playerid, ',uiid=', uiid, ',elementid=', elementid, ',state=', state)
end

function CustomuiHelper.setPosition (playerid, uiid, elementid, x, y)
  return CommonHelper.callIsSuccessMethod(function ()
    return Coustomui:setPosition(playerid, uiid, elementid, x, y)
  end, '设置位置', 'playerid=', playerid, ',uiid=', uiid, ',elementid=', elementid, ',x=', x, ',y=', y)
end
