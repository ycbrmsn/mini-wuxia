-- 剧情二
Story2 = MyStory:new()

function Story2:init ()
  local data = {
    title = '前往学院',
    name = '前往学院',
    desc = '先生带着我向学院出发了',
    tips = {
      '终于到了出发的时间了。我好激动。',
      '先生带着我向学院出发了。只是，没想到是要用跑的。',
      '时间有限，作者剧情就做到这里了。游戏结束标志没有设置。风颖城也还没有做完。主要把落叶村人物的作息完成了。后面的内容，作者会继续更新。希望你们喜欢，谢谢。'
      -- '这群可恶的强盗，居然要抢我的通行令。没办法了，先消灭他们再说。',
      -- '终于到风颖城了。我得去学院报到了。'
    },
    yexiaolongInitPosition = {
      { x = 0, y = 7, z = 23 },
      { x = 0, y = 7, z = 20 }
    },
    playerInitPosition = { x = 0, y = 7, z = 16 },
    movePositions1 = {
      { x = 0, y = 7, z = 70 },
      { x = 0, y = 7, z = 130 },
      { x = 0, y = 7, z = 190 },
      { x = 0, y = 7, z = 250 },
      { x = 0, y = 7, z = 280 }
    },
    movePositions2 = {
      { x = 0, y = 7, z = 65 },
      { x = 0, y = 7, z = 125 },
      { x = 0, y = 7, z = 185 },
      { x = 0, y = 7, z = 245 },
      { x = 0, y = 7, z = 275 }
    },
    leaveForAWhilePositions = {
      { x = 10, y = 7, z = 280 },
      { x = 24, y = 7, z = 230 }
    },
    eventPositions = {
      { x = 0, y = 7, z = 320 }
    },
    xiaotoumuPosition = {
      { x = 0, y = 7, z = 330 }
    },
    louluoPositions = {
      { x = -2, y = 7, z = 332 },
      { x = 2, y = 7, z = 332 },
      { x = 4, y = 7, z = 330 },
      { x = -4, y = 7, z = 330 },
      { x = 6, y = 7, z = 328 },
      { x = -6, y = 7, z = 328 },
      { x = 8, y = 7, z = 326 },
      { x = -8, y = 7, z = 326 },
      { x = 10, y = 7, z = 324 },
      { x = -10, y = 7, z = 324 }
    }
  }
  self:setData(data)
  return data
end

-- 前往学院
function Story2:goToCollege ()
  local story2 = MyStoryHelper:getStory(2)
  MyPlayerHelper:everyPlayerNotify('到了约定的时间了')
  MyPlayerHelper:everyPlayerEnableMove(false)
  -- 初始化所有人位置
  yexiaolong:wantMove('goToCollege', { story2.yexiaolongInitPosition[2] })
  yexiaolong:setPosition(story2.yexiaolongInitPosition[1])
  for i, v in ipairs(MyPlayerHelper:getAllPlayers()) do
    v:setPosition(story2.playerInitPosition)
    PlayerHelper:rotateCamera(v.objid, ActorHelper.FACE_YAW.SOUTH, 0)
  end
  -- 说话
  yexiaolong.action:speakToAllAfterSecond(1, '不错，所有人都到齐了。那我们出发吧。')
  MyPlayerHelper:everyPlayerSpeakToAllAfterSecond(4, '出发咯!')
  local hostPlayer = MyPlayerHelper:getHostPlayer()
  hostPlayer.action:speakToAllAfterSecond(6, '不过，先生，我们的马车在哪里？')
  yexiaolong.action:speakToAllAfterSecond(9, '嗯，这个嘛……')
  yexiaolong.action:speakInHeartToAllAfterSecond(11, '没想到村里的东西这么好吃。一不小心把盘缠给花光了……')
  yexiaolong.action:speakToAllAfterSecond(14, '咳咳。还没有进入学院，就想着这些让人懒惰工具。这怎么能行？')
  yexiaolong.action:speakToAllAfterSecond(17, '去学院学习可不是享福的。基本功不能落下。现在，让我们跑起来。出发！')

  MyTimeHelper:callFnAfterSecond (function (p)
    ActorHelper:addBuff(yexiaolong.objid, ActorHelper.BUFF.FASTER_RUN, 4, 6000)
    yexiaolong:wantMove('goToCollege', p.story2.movePositions1)
  end, 17, { story2 = story2 })

  MyPlayerHelper:everyPlayerSpeakToAllAfterSecond(19, '!!!')

  MyTimeHelper:callFnAfterSecond(function (p)
    MyPlayerHelper:everyPlayerEnableMove(true) -- 玩家可以行动
    for i, v in ipairs(MyPlayerHelper:getAllPlayers()) do
      if (i == 1) then
        v.action:runTo(p.story2.movePositions2, function (v)
          Story2:teacherLeaveForAWhile(v)
        end, v)
      else
        v.action:runTo(p.story2.movePositions2)
      end
    end
    MyPlayerHelper:everyPlayerAddBuff(ActorHelper.BUFF.FASTER_RUN, 4, 6000)
  end, 20, { story2 = story2 })
  
  if (#MyPlayerHelper:getAllPlayers() > 1) then
    MyPlayerHelper:everyPlayerSpeakToAllAfterSecond(21, '先生，等等我们。')
  else
    MyPlayerHelper:everyPlayerSpeakToAllAfterSecond(21, '先生，等等我。')
  end

  MyTimeHelper:callFnAfterSecond(function (p)
    MyStoryHelper:forward('跑步去学院')
  end, 21)
end

-- 先生暂时离开
function Story2:teacherLeaveForAWhile (myPlayer)
  local story2 = MyStoryHelper:getStory(2)
  MyTimeHelper:callFnAfterSecond(function (p)
    MyPlayerHelper:everyPlayerEnableMove(false)
  end, 1)
  myPlayer.action:speakToAll('先生，怎么停下来了？')
  yexiaolong.action:speakToAllAfterSecond(2, '……')
  myPlayer.action:speakToAllAfterSecond(4, '先生？')
  yexiaolong.action:speakToAllAfterSecond(6, '……')
  MyTimeHelper:callFnAfterSecond(function (p)
    yexiaolong:setFaceYaw(ActorHelper.FACE_YAW.SOUTH)
    yexiaolong.action:speakToAll('人有三急，我突然想去出恭。你们先跑着，我去去就来。')
  end, 8)
  MyTimeHelper:callFnAfterSecond(function (p)
    myPlayer.action:speakToAll('好的。')
    yexiaolong:wantMove('leaveForAWhile', p.story2.leaveForAWhilePositions)
  end, 9, { story2 = story2 })
  
  MyTimeHelper:callFnAfterSecond(function (p)
    MyPlayerHelper:everyPlayerEnableMove(true)

    for i, v in ipairs(MyPlayerHelper:getAllPlayers()) do
      if (i == 1) then
        v.action:runTo(p.story2.eventPositions, function (v)
          Story2:meetBandits(v)
        end, v)
      else
        v.action:runTo(p.story2.eventPositions)
      end
    end

    MyPlayerHelper:everyPlayerSpeakInHeartAfterSecond(2, '这里的树木好茂密啊！')
  end, 12, { story2 = story2 })
end

-- 遭遇强盗
function Story2:meetBandits (hostPlayer)
  local story2 = MyStoryHelper:getStory(2)
  qiangdaoXiaotoumu:enableMove(false)
  qiangdaoLouluo:enableMove(false)
  qiangdaoXiaotoumu:setPositions(story2.xiaotoumuPosition)
  qiangdaoLouluo:setPositions(story2.louluoPositions)

  MyTimeHelper:callFnAfterSecond(function (p)
    MyPlayerHelper:everyPlayerEnableMove(false)
  end, 2)

  MyPlayerHelper:everyPlayerSpeakToAllAfterSecond(2, '!!!')
  qiangdaoXiaotoumu.action:speakToAllAfterSecond(4, '此树乃吾栽，此路亦吾开。欲从此路过，留下……')
  qiangdaoLouluo.action:speakToAllAfterSecond(6, '买路财，老大。')
  qiangdaoXiaotoumu.action:speakToAllAfterSecond(8, '你个笨蛋，山野村民，身上能有什么值钱的东西。')
  qiangdaoXiaotoumu.action:speakToAllAfterSecond(11, '不过，这是去往风颖城的道路。如果没有通行令，可是进不了城的。')
  qiangdaoXiaotoumu.action:speakToAllAfterSecond(14, '如果我们有了通行令，找机会抢几个城里的大户……')
  qiangdaoLouluo.action:speakToAllAfterSecond(16, '高啊，老大。')
  qiangdaoLouluo.action:speakToAllAfterSecond(18, '小子，留下令牌来。')
  hostPlayer.action:speakInHeartToAllAfterSecond(20, '看样子只能拼了。')
  hostPlayer.action:speakToAllAfterSecond(22, '想要你们就来拿吧！')
  qiangdaoXiaotoumu.action:speakToAllAfterSecond(24, '看来是遇到不要命的了。大伙们一起上。')

  MyTimeHelper:callFnAfterSecond(function (p)
    qiangdaoXiaotoumu:enableMove(true)
    qiangdaoLouluo:enableMove(true)
    MyPlayerHelper:everyPlayerEnableMove(true)
    MyStoryHelper:forward('消灭强盗')
  end, 24)
end