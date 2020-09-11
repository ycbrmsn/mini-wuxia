-- 剧情三
Story3 = MyStory:new()

function Story3:new ()
  local data = {
    title = '学院',
    name = '学院任务',
    desc = '来到学院就开始做任务了',
    tips = {
      '终于到学院了。先生好像说要报名来着，先进去看看。',
      '先生说学院的任务主要是由高先生负责，我去问问看。',
      '原来新生还有兵器可以领，真是太棒了。先生好像说是真宝阁来着，我去看看。',
      '拿着新武器好开心。接下来做什么呢，要不要找先生问问。',
      '先生让我去消灭强盗大头目，我觉得目前对我来说还是挺难的，我得好好准备一番。',
    },
  }
  self:checkData(data)

  setmetatable(data, self)
  self.__index = self
  return data
end