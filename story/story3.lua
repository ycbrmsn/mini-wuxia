-- 剧情三
Story3 = MyStory:new()

function Story3:new ()
  local data = {
    title = '学院',
    name = '学院任务',
    desc = '来到学院就开始做任务了',
    tips = {
      '终于到学院了。先生好像说要报名来着，希望没有来晚。',
      '是先生的声音，我进去看看。',
      '先生说学院的任务主要是由高先生负责，我去问问看。',
      '原来新生还有兵器可以领，真是太棒了。先生好像说是真宝阁来着，我去看看。',
      '拿着新武器好开心。接下来做什么呢，要不要找先生问问。',
      '先生让我去消灭强盗大头目，我觉得目前对我来说还是挺难的，我得好好准备一番。',
      '终于消灭了强盗的威胁。先生说快要考试了，有点小紧张。',
      -- '目前剧情到此',
    },
    prepose = {
      ['来到学院'] = 1,
      ['先生的声音'] = 2,
      ['对话高先生'] = 3,
      ['新生武器'] = 4,
      ['先生的任务'] = 5,
      ['准备消灭大头目'] = 6,
      ['学院考试'] = 7,
    },
    index = 3,
    posBeg = MyPosition:new(-31, 7, 590),
    posEnd = MyPosition:new(-7, 8, 576),
    startPos = MyPosition:new(-19, 7, 584), -- 剧情开始位置
    startArea = -99,
    yexiaolongInitPos = MyPosition:new(-17, 7.5, 593),
    gaoxiaohuInitPos = MyPosition:new(-16, 7.5, 594),
    yuewushuangInitPos = MyPosition:new(-16, 7.5, 595.5),
    playerPos = MyPosition:new(-20, 7.5, 594.5),
    airWallPosBeg = MyPosition:new(-19, 10, 592), -- 空气墙起点
    airWallPosEnd = MyPosition:new(-19, 7, 596), -- 空气墙终点
    airWallArea = nil
  }
  self:checkData(data)

  if (StoryHelper.getMainStoryIndex() <= 3) then -- 剧情没有超过3时
    data.startArea = AreaHelper.createAreaRectByRange(data.posBeg, data.posEnd)
  end

  self.__index = self
  setmetatable(data, self)
  return data
end

-- 来到学院
function Story3:comeToCollege ()
  local name
  if (not(yexiaolong and yexiaolong:isFinishInit())) then -- 校验叶小龙
    name = '叶小龙'
  elseif (not(yexiaolong and yexiaolong:isFinishInit())) then -- 校验高小虎
    name = '高小虎'
  elseif (not(yuewushuang and yuewushuang:isFinishInit())) then -- 校验月无双
    name = '月无双'
  end
  if (name) then
    TimeHelper.callFnAfterSecond(function ()
      self:comeToCollege()
    end, 1)
    StoryHelper.showInitError('comeToCollege', name)
    return
  end

  local px = 0
  PlayerHelper.everyPlayerDoSomeThing(function (player)
    player:setPosition(self.startPos.x + px, self.startPos.y, self.startPos.z)
    PlayerHelper.changeVMode(player.objid, VIEWPORTTYPE.BACKVIEW)
    PlayerHelper.rotateCamera(player.objid, ActorHelper.FACE_YAW.SOUTH, 0)
    if (px == 0) then
      px = 1
    elseif (px > 0) then
      px = -px
    else
      px = 1 - px
    end
  end)
  local hostPlayer = PlayerHelper.getHostPlayer()
  PlayerHelper.everyPlayerEnableMove(false)
  yexiaolong:setPosition(self.yexiaolongInitPos)
  gaoxiaohu:setPosition(self.gaoxiaohuInitPos)
  yuewushuang:setPosition(self.yuewushuangInitPos)
  self.airWallArea = AreaHelper.createAreaRectByRange(self.airWallPosBeg, self.airWallPosEnd)
  AreaHelper.fillBlock(self.airWallArea, 1001) -- 区域填充空气墙

  local ws = WaitSeconds:new()
  PlayerHelper.everyPlayerSpeakToSelf(ws:use(3), '这就是紫荆学院。')
  PlayerHelper.everyPlayerSpeakToSelf(ws:use(3), '希望我能在这里学得一身本事。')
  yexiaolong:lookAt(gaoxiaohu, ws:get())
  gaoxiaohu:lookAt(yexiaolong, ws:get())
  yuewushuang:lookAt(yexiaolong, ws:get())
  yexiaolong:speak(ws:use(), '小高小高，我终于找到你了。')
  PlayerHelper.everyPlayerEnableMove(true, ws:get())
  PlayerHelper.everyPlayerRunTo({ self.playerPos }, function (player)
    player:lookAt(yexiaolong)
    player:enableMove(false, true)
  end, ws:get())
  PlayerHelper.everyPlayerThinkToSelf(ws:use(), '咦，是先生的声音。进去看看。')
  TimeHelper.callFnAfterSecond(function ()
    StoryHelper.forward(3, '来到学院')
  end, ws:get())
  gaoxiaohu:speak(ws:use(), '说了多少遍了，叫我小虎，别把我叫矮了。你也回来了。')
  yexiaolong:speak(ws:use(), '回来一阵子了，一直没找到你。小高，看看你的新学生。')
  gaoxiaohu:speak(ws:use(), '每次你都这样，真受不了你。我身边这位就是我新收的学生，月无双。')
  gaoxiaohu:lookAt(yuewushuang, ws:get())
  gaoxiaohu:speak(ws:use(), '这位就是之前跟你提起过的叶先生。')
  yuewushuang:lookAt(yexiaolong, ws:get())
  yexiaolong:lookAt(yuewushuang, ws:get())
  yuewushuang.action:playThank(ws:get())
  yuewushuang:speak(ws:use(), '见过叶先生。')
  yexiaolong:speak(ws:use(), '不错……')
  gaoxiaohu:lookAt(yexiaolong, ws:get())
  gaoxiaohu:speak(ws:use(), '那是，为此，我可是走遍了十里八乡。你的学生呢？')
  PlayerHelper.everyPlayerDoSomeThing(function (player)
    player.action:playHappy()
  end, ws:get())
  PlayerHelper.everyPlayerSpeakToSelf(ws:use(), '先生先生。')
  yexiaolong:lookAt(hostPlayer, ws:get())
  gaoxiaohu:lookAt(hostPlayer, ws:get())
  yuewushuang:lookAt(hostPlayer, ws:get())
  yexiaolong:speak(ws:use(), '哦，你来了。')
  yexiaolong:lookAt(gaoxiaohu, ws:get())
  yexiaolong:speak(ws:use(), '这就是我的学生了。虽然看上去弱不禁风，不过我们也是经过了强盗的洗礼。')
  gaoxiaohu:lookAt(yexiaolong, ws:get())
  yuewushuang:lookAt(yexiaolong, ws:get())
  gaoxiaohu:speak(ws:use(), '强盗？他们还敢打劫你？')
  yexiaolong:speak(ws:use(), '回来的路上我发现了强盗的埋伏，就交给学生处理了。')
  PlayerHelper.everyPlayerDoSomeThing(function (player)
    player.action:playDown()
  end, ws:get())
  PlayerHelper.everyPlayerSpeakToSelf(ws:use(), '！！！')
  gaoxiaohu:speak(ws:use(), '没想到现在强盗这么猖獗了。这事我们得好好说说。')
  yexiaolong:speak(ws:use(), '是得好好说说。一会儿再说吧，找你老半天，累死我了，我先去歇歇脚。')
  gaoxiaohu:speak(ws:use(), '好好好。')
  yexiaolong:lookAt(hostPlayer, ws:get())
  PlayerHelper.everyPlayerDoSomeThing(function (player)
    player.action:playStand()
  end, ws:get())
  yexiaolong:speak(ws:use(), '这位是学院的高先生。学院任务主要就是他在负责，学院的事找他就对了。')
  PlayerHelper.everyPlayerLookAt(gaoxiaohu, ws:get())
  PlayerHelper.everyPlayerDoSomeThing(function (player)
    player.action:playThank()
  end, ws:get())
  PlayerHelper.everyPlayerSpeakToSelf(ws:use(), '高先生好。')
  gaoxiaohu:lookAt(hostPlayer, ws:get())
  gaoxiaohu:speak(ws:use(), '嗯……')
  yexiaolong:speak(ws:use(), '好了，我先走了。')
  PlayerHelper.everyPlayerLookAt(yexiaolong, ws:get())
  PlayerHelper.everyPlayerDoSomeThing(function (player)
    player.action:playHi()
  end, ws:get())
  PlayerHelper.everyPlayerSpeakToSelf(ws:use(), '先生走好。')
  TimeHelper.callFnAfterSecond(function ()
    AreaHelper.clearAllBlock(self.airWallArea, 1001) -- 清除空气墙
    StoryHelper.forward(3, '先生的声音')
    PlayerHelper.everyPlayerEnableMove(true)
    gaoxiaohu:doItNow()
    yuewushuang:doItNow()
    yexiaolong:doItNow()
  end, ws:get())
end

function Story3:recover (player)
  local mainProgress = StoryHelper.getMainStoryProgress()
  local hostPlayer = PlayerHelper.getHostPlayer()
  PlayerHelper.setPlayerEnableBeKilled(player.objid, true) -- 能被杀死
  TaskHelper.addStoryTask(player.objid)
  if (mainProgress == 1 or mainProgress == 2) then
    player:enableMove(true)
    if (player == hostPlayer) then
      story3:comeToCollege()
    else
      player:setMyPosition(hostPlayer:getMyPosition())
    end
  end
end

function Story3:getProgressPrepose (name)
  return self.prepose[name]
end
