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
    },
    startPos = MyPosition:new(-19, 7, 584),
    startArea = -99
  }
  self:checkData(data)

  if (StoryHelper:getMainStoryIndex() < 3) then -- 剧情没有进展到3时
    data.startArea = AreaHelper:getAreaByPos(data.startPos)
  end

  setmetatable(data, self)
  self.__index = self
  return data
end

-- 来到学院
function Story3:comeToCollege ()
  local px = 0
  PlayerHelper:everyPlayerDoSomeThing(function (player)
    player:setPosition(self.startPos.x + x, self.startPos.y, self.startPos.z)
    if (px == 0) then
      px = 1
    elseif (px > 0) then
      px = -px
    else
      px = 1 - px
    end
  end)
  PlayerHelper:everyPlayerEnableMove(false)

  local ws = WaitSeconds:new()
  PlayerHelper:everyPlayerSpeakToSelf(ws:use(3), '这就是紫荆学院。')
  PlayerHelper:everyPlayerSpeakToSelf(ws:use(3), '希望我能在这里学得一身本事。')
  yexiaolong:speak(ws:use(), '小高小高，我终于找到你了。')
  PlayerHelper:everyPlayerThinkToSelf(ws:use(), '咦，是先生的声音。进去看看。')
  StoryHelper:forward('再见先生')
  gaoxiaohu:speak(ws:use(), '说了多少遍了，叫我小虎，别把我叫矮了。你也回来了。')
  yexiaolong:speak(ws:use(), '回来一阵子了，一直没找到你。小高，看看你的新学生。')
  gaoxiaohu:speak(ws:use(), '每次你都这样，真受不了你。我身边这位就是我新收的学生，月无双。')

  gaoxiaohu:speak(ws:use(), '这位就是之前跟你提起过的叶先生。')
  yuewushuang:speak(ws:use(), '见过叶先生。')
  yexiaolong:speak(ws:use(), '不错……')

  gaoxiaohu:speak(ws:use(), '那是，为此，我可是走遍了十里八乡。你的学生呢？')
  PlayerHelper:everyPlayerSpeakToSelf(ws:use(), '先生先生。')

  yexiaolong:speak(ws:use(), '哦，你来了。')

  yexiaolong:speak(ws:use(), '这就是我的学生了。虽然看上去弱不禁风，不过我们也是经过了强盗的洗礼。')
  gaoxiaohu:speak(ws:use(), '强盗？还有强盗敢打劫你？')
  yexiaolong:speak(ws:use(), '回来的路上我发现了强盗的埋伏，就交给学生处理了。')
  PlayerHelper:everyPlayerSpeakToSelf(ws:use(), '！！！')
  gaoxiaohu:speak(ws:use(), '没想到现在强盗这么猖獗了。这事我们得好好说说。')
  yexiaolong:speak(ws:use(), '是得好好说说。一会儿再说吧，找你老半天，累死我了，我先去歇歇脚。')
  gaoxiaohu:speak(ws:use(), '好好好。')

  yexiaolong:speak(ws:use(), '这位是学院的高先生。学院任务主要就是他在负责，学院的事找他就对了。')
  PlayerHelper:everyPlayerSpeakToSelf(ws:use(), '高先生好。')
  gaoxiaohu:speak(ws:use(), '嗯……')
  yexiaolong:speak(ws:use(), '好了，我先走了。')
  PlayerHelper:everyPlayerSpeakToSelf(ws:use(), '先生走好。')
  StoryHelper:forward('3先生离开')
end