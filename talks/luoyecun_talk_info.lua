-- 落叶村对话详情

-- 杨万里
yangwanliTalkInfos = {
  -- 主线
  TalkInfo:new({
    id = 100,
    ants = {
      TalkAnt:orAnts(
        TalkAnt:andAnts(
          TalkAnt:isHostPlayer(true),
          TalkAnt:justItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 1), -- 剧情一
          TalkAnt:justItem(MyMap.ITEM.GAME_DATA_MAIN_PROGRESS_ID, 3) -- 进度三
        ), -- 房主
        TalkAnt:andAnts(
          TalkAnt:isHostPlayer(false),
          TalkAnt:hosterJustItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 1), -- 剧情一
          TalkAnt:includeTask(function ()
            return story1:getTaskIdByName('文羽的礼物')
          end),
          TalkAnt:excludeTask(function ()
            return story1:getTaskIdByName('村长的礼物')
          end)
        ) -- 非房主
      ),
    },
    progress = {
      [0] = {
        TalkSession:reply('你来了，我正有好消息要通知你呢。'),
        TalkSession:speak('是招生的事情吗？'),
        TalkSession:reply('原来你知道了。没错，这么多年了，紫荆学院又来招生了。'),
        TalkSession:speak('在哪里，在哪里？'),
        TalkSession:reply('哈哈，这么着急。知道你一直想外出闯荡，这的确是个好机会。'),
        TalkSession:speak('在哪里，快说嘛。'),
        TalkSession:reply('好好，听好了。学院的负责人现在住在客栈里。具体的事宜，你可以前去问他。'),
        TalkSession:speak('我知道了。那我先走了，村长。'),
        TalkSession:reply('别急，这个拿着，你也许用得上。'),
        TalkSession:speak('太好了，村长，我会努力的。先走了。'):call(function (player, actor)
          local itemid = MyMap.ITEM.YANGWANLI_PACKAGE_ID
          if (BackpackHelper.gainItem(player.objid, itemid)) then -- 获得村长的包裹
            PlayerHelper.notifyGameInfo2Self(player.objid, '获得' .. ItemHelper.getItemName(itemid))
            TaskHelper.addTask(player.objid, story1:getTaskIdByName('村长的礼物'))
            StoryHelper.forward(1, '文羽的礼物')
          end
        end),
      },
    },
  }),
  -- 采集落叶松木
  TaskHelper.generateAcceptTalk(kanshuTask, {
    { 3, '有什么我能帮忙的吗？' },
    { 1, '村里的房子又需要修葺一下了。' },
    { 1, '我需要一些落叶松木，你可以帮我砍一些回来吗？' },
    { '没问题。', '村长我正忙着呢。' },
  }),
  TaskHelper.generateQueryTalk(kanshuTask, {
    { 3, '村长，我没有找到落叶松木。' },
    { 1, '村子外面就有一片落叶松林。' },
    { 3, '哦，我知道了。' },
  }),
  TaskHelper.generatePayTalk(kanshuTask, {
    { 3, '村长我采回来了。' },
    { 1, '真是个好孩子。' },
  }),
  TalkInfo:new({
    id = 1,
    progress = {
      [0] = {
        TalkSession:reply('{{:getName}}，你来啦。'),
        TalkSession:init(function ()
          local playerTalks = MyArr:new(TaskHelper.initTaskTalkChoices(player, kanshuTask))
          playerTalks:add(PlayerTalk:continue('闲聊'))
          local sessions = MyArr:new()
          sessions:add(TalkSession:choose(playerTalks:get()))
          sessions:add(TalkSession:speak('对呢，我来逛逛。'))
          return sessions:get()
        end),
      },
    }
  }),
}

-- 王大力
wangdaliTalkInfos = {
  -- 采集铜矿石
  -- 不满足接受条件
  TaskHelper.generateUnableAcceptTalk(caijitongkuangshiTask, {
    { 3, '有什么我能帮忙的吗？' },
    { 1, '嗯……' },
    { 2, '还没有到10级，也帮不上什么忙。' },
    { 1, '没什么大问题啦。' },
    { 3, '哦，那好的。' },
  }, {
    TalkAnt:atMostLevel(9) -- 最多9级，即小于10级
  }),
  -- 满足接受条件
  TaskHelper.generateAcceptTalk(caijitongkuangshiTask, {
    { 3, '有什么我能帮忙的吗？' },
    { 1, '我最近在研究青铜武器，可惜没有材料。' },
    { 1, '在恶狼谷附近有一处矿脉，盛产铜矿。可是最近却被一群强盗霸占了。' },
    { 3, '强盗？好像很危险。' },
    { 1, '确实如此。你需要去矿洞里采集十块铜矿石给我。如果你能完成，我送你一把青铜武器。' },
    { '没问题。', '我先看看情况再说。' },
  }),
  TaskHelper.generateQueryTalk(caijitongkuangshiTask, {
    { 3, '我转了一圈，没有找到矿石。' },
    { 1, '矿洞就在水池旁，很容易看到。注意安全。' },
    { 3, '哦，我知道了。' },
  }),
  TaskHelper.generatePayTalk(caijitongkuangshiTask, {
    { 3, '我采集到足够的矿石了。' },
    { 1, '不错，你采集到了足够的矿石。你想要件什么武器？' },
    { 5,
      {
        PlayerTalk:stop('我想我需要一把剑。'):call(function (player, actor)
          actor:speakTo(player.objid, 0, '拿稳了。')
          BackpackHelper.gainItem(player.objid, MyWeaponAttr.bronzeSword.levelIds[1])
          TaskHelper.finishTask(player.objid, caijitongkuangshiTask)
        end),
        PlayerTalk:stop('我想要一把刀。'):call(function (player, actor)
          actor:speakTo(player.objid, 0, '拿稳了。')
          BackpackHelper.gainItem(player.objid, MyWeaponAttr.bronzeKnife.levelIds[1])
          TaskHelper.finishTask(player.objid, caijitongkuangshiTask)
        end),
        PlayerTalk:stop('我想舞枪。'):call(function (player, actor)
          actor:speakTo(player.objid, 0, '拿稳了。')
          BackpackHelper.gainItem(player.objid, MyWeaponAttr.bronzeSpear.levelIds[1])
          TaskHelper.finishTask(player.objid, caijitongkuangshiTask)
        end),
        PlayerTalk:stop('我想来一张弓。'):call(function (player, actor)
          actor:speakTo(player.objid, 0, '拿稳了。')
          BackpackHelper.gainItem(player.objid, MyWeaponAttr.bronzeBow.levelIds[1])
          TaskHelper.finishTask(player.objid, caijitongkuangshiTask)
        end),
      }
    }
  }),
  TalkInfo:new({
    id = MyTask.ST12,
    ants = {
      TalkAnt:includeTask(MyTask.ST12),
    },
    progress = {
      [0] = {
        TalkSession:speak('嗯，我想买把武器，但是对武器不太了解，你能给我说说吗？'),
        TalkSession:reply('你可是问对人了。听好了哟。'),
        TalkSession:reply('虽说世上武器各种各样，但主流武器一共分为4类。分别为剑、刀、枪、弓。'),
        TalkSession:speak('它们有什么区别呢？'),
        TalkSession:reply('剑的伤害最低，但可以增加少许防御。刀的伤害较剑高，略微增加防御。'),
        TalkSession:reply('枪的伤害最高，但使用更耗体力，会更容易饥饿。弓与枪的伤害差别不大，但攻速慢。'),
        TalkSession:speak('那一定很少有人用剑了。'),
        TalkSession:reply('当然不是。武器还有品质高低之分，高品质的剑也是很多人喜爱的。'),
        TalkSession:speak('那武器分几种品质呢？'),
        TalkSession:reply('武器品质可以分为白、绿、蓝、紫。听说紫品之上还有橙、红，但那只是传说。'),
        TalkSession:speak('不同品质有什么差别呢？'),
        TalkSession:reply('品质决定武器可使用的技能。绿品武器带有被动技能，蓝、紫品武器则带有主动技能。'),
        TalkSession:reply('所以，一件蓝品武器的属性，不一定比一件白品武器的属性好。'),
        TalkSession:reply('武器除了有品质的差异，还有强化等级的不同。'),
        TalkSession:speak('强化等级？'),
        TalkSession:reply('是的，可以对武器进行强化，强化后会增强武器的属性和技能。每件武器最多强化3级。'),
        TalkSession:speak('那强化需要什么呢？'),
        TalkSession:reply('强化很简单，只要有强化武器所需要的材料就行。你可以使用工具箱自己进行强化。'),
        TalkSession:reply('差不多就这些了。行走江湖，这些常识还是需要知道的。'),
        TalkSession:speak('嗯嗯，我记下了。'),
      },
    }
  }),
  TalkInfo:new({
    id = 1,
    progress = {
      [0] = {
        TalkSession:reply('这不是{{:getName}}嘛。'),
        TalkSession:init(function ()
          local playerTalks = MyArr:new(TaskHelper.initTaskTalkChoices(player, caijitongkuangshiTask))
          playerTalks:add(PlayerTalk:continue('武器介绍'):call(function (player)
            TaskHelper.addTempTask(player.objid, MyTask.ST12)
            player:resetTalkIndex(0)
          end))
          playerTalks:add(PlayerTalk:continue('闲聊'))
          local sessions = MyArr:new()
          sessions:add(TalkSession:choose(playerTalks:get()))
          sessions:add(TalkSession:speak('嗯，我来看看。'))
          return sessions:get()
        end),
      },
    }
  }),
}

-- 苗兰
miaolanTalkInfos = {
  -- 收集兽骨
  TaskHelper.generateAcceptTalk(shoujishouguTask, {
    { 3, '有什么我能帮忙的吗？' },
    { 1, '最近做药丸的材料不够用了。' },
    { 1, '我需要一些兽骨，你可以帮我收集一些吗？' },
    { '没问题。', '我先看看情况再说。' },
  }),
  TaskHelper.generateQueryTalk(shoujishouguTask, {
    { 3, '苗大夫，哪里有兽骨呢？' },
    { 1, '击败野狗、恶狼、狂牛都有几率获得兽骨，注意安全。' },
    { 3, '嗯嗯，我知道了。' },
  }),
  TaskHelper.generatePayTalk(shoujishouguTask, {
    { 3, '苗大夫，看这些兽骨够了吗？' },
    { 1, '够用了。这些给你。' },
  }),
  -- 疗伤
  TalkInfo:new({
    id = MyTask.ST10,
    ants = {
      TalkAnt:includeTask(MyTask.ST10),
    },
    progress = {
      [0] = {
        TalkSession:speak('我受伤了，需要治疗一下。'),
        TalkSession:noDialogue():call(function (player, actor)
          actor:setPlayerClickEffective(player.objid, false)
          actor:speakTo(player.objid, 0, '我来看看。')
          player:enableMove(false, '检查中')
          TimeHelper.callFnAfterSecond (function (p)
            local hp = PlayerHelper.getHp(player.objid)
            local maxHp = PlayerHelper.getMaxHp(player.objid)
            if (hp < maxHp) then -- 受伤了
              actor:speakTo(objid, 0, '确实是呢。不要动哦。')
              actor.action:playAttack()
              actor.action:playAttack(1)
              actor.action:playAttack(2)
              TimeHelper.callFnAfterSecond (function (p)
                ActorHelper.playBodyEffectById(player.objid, BaseConstant.BODY_EFFECT.LIGHT26, 1)
                PlayerHelper.setHp(player.objid, maxHp)
                player:speakTo(player.objid, 0, '谢谢苗大夫，我觉得舒服多了。')
                actor:speakTo(player.objid, 2, '不用谢。要爱护身体哦。')
                player:speakTo(player.objid, 4, '我知道了。')
                TimeHelper.callFnAfterSecond (function (p)
                  local talkIndex = TalkHelper.getTalkIndex(player.objid, actor)
                  if (talkIndex ~= 1) then
                    TalkHelper.turnTalkIndex(player.objid, actor)
                  end
                  player:enableMove(true, true)
                  actor:setPlayerClickEffective(player.objid, true)
                end, 4)
              end, 3)
            else -- 没受伤
              actor:speakTo(player.objid, 0, '身体棒棒的，可不能说谎哟。')
              player:speakTo(player.objid, 2, '我可能产生幻觉了。')
              actor:speakTo(objid, 4, '呵呵呵呵……')
              TimeHelper.callFnAfterSecond (function (p)
                local talkIndex = TalkHelper.getTalkIndex(player.objid, actor)
                if (talkIndex ~= 1) then
                  TalkHelper.turnTalkIndex(player.objid, actor)
                end
                player:enableMove(true, true)
                actor:setPlayerClickEffective(player.objid, true)
              end, 4)
            end
          end, 2)
        end),
      },
    },
  }),
  -- 药品介绍
  TalkInfo:new({
    id = MyTask.ST11,
    ants = {
      TalkAnt:includeTask(MyTask.ST11),
    },
    progress = {
      [0] = {
        TalkSession:speak('苗大夫，我对药品不太了解，你能给我说说吗？'),
        TalkSession:reply('那你可要仔细听哟。'),
        TalkSession:reply('药品主要用来恢复或改变状态。改变状态包括加上增益状态与去掉减益状态。'),
        TalkSession:reply('很多药品都是用来恢复生命的。当你生命为1时，将进入重伤状态。'),
        TalkSession:reply('此时，你无法再控制行动。你可能需要回来修养疗伤。'),
        TalkSession:reply('总之，需要等生命恢复上去后方可恢复行动。'),
        TalkSession:reply('所以，出门在外，身上带一些药品是聪明的行为。'),
        TalkSession:reply('差不多就这些了。另外，如果你受伤了，我可以给你免费治疗哦。'),
        TalkSession:speak('嗯嗯，我知道了。'),
      },
    },
  }),
  TalkInfo:new({
    id = 1,
    progress = {
      [0] = {
        TalkSession:reply('{{:getName}}，又见到你了。'),
        TalkSession:init(function ()
          local playerTalks = MyArr:new(TaskHelper.initTaskTalkChoices(player, shoujishouguTask))
          playerTalks:add(PlayerTalk:continue('疗伤'):call(function (player)
            TaskHelper.addTempTask(player.objid, MyTask.ST10)
            player:resetTalkIndex(0)
          end))
          playerTalks:add(PlayerTalk:continue('药品介绍'):call(function (player)
            TaskHelper.addTempTask(player.objid, MyTask.ST11)
            player:resetTalkIndex(0)
          end))
          playerTalks:add(PlayerTalk:continue('闲聊'))
          local sessions = MyArr:new()
          sessions:add(TalkSession:choose(playerTalks:get()))
          sessions:add(TalkSession:speak('嗯，我来看看。'))
          return sessions:get()
        end),
      },
    }
  }),
}

-- 文羽
wenyuTalkInfos = {
  -- 主线
  TalkInfo:new({
    id = 100,
    ants = {
      TalkAnt:orAnts(
        TalkAnt:andAnts(
          TalkAnt:isHostPlayer(true),
          TalkAnt:justItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 1), -- 剧情一
          TalkAnt:justItem(MyMap.ITEM.GAME_DATA_MAIN_PROGRESS_ID, 2) -- 进度二
        ), -- 房主
        TalkAnt:andAnts(
          TalkAnt:isHostPlayer(false),
          TalkAnt:hosterJustItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 1), -- 剧情一
          TalkAnt:excludeTask(function ()
            return story1:getTaskIdByName('文羽的礼物')
          end)
        ) -- 非房主
      ),
    },
    progress = {
      [0] = {
        TalkSession:reply('我今天看见城里学院的人来了。'),
        TalkSession:speak('城里学院？难道是……'),
        TalkSession:reply('没错，一定是紫荆学院又来村里招生了。'),
        TalkSession:speak('真的吗？那太好了。'),
        TalkSession:reply('具体情况，你去问问村长吧，他一定知道。'),
        TalkSession:speak('好的，文羽。我这就去。'),
        TalkSession:reply('对了，这是我的一点心意，你也许用得上。'),
        TalkSession:speak('谢谢你，文羽。'):call(function (player, actor)
          local itemid = MyMap.ITEM.WENYU_PACKAGE_ID
          if (BackpackHelper.gainItem(player.objid, itemid)) then -- 获得文羽的包裹
            TaskHelper.addTask(player.objid, story1:getTaskIdByName('文羽的礼物'))
            PlayerHelper.notifyGameInfo2Self(player.objid, '获得' .. ItemHelper.getItemName(itemid))
            if (StoryHelper.forward(1, '文羽通知')) then
              wenyu:doItNow() -- 不再跟随
            end
          end
        end),
      },
    },
  }),
  -- 消灭野狗
  TalkInfo:new({
    id = 1,
    ants = {
      TalkAnt:excludeItem(xiaomieyegouTask.rewards[1].itemid), -- 没有皮头盔
      TalkAnt:excludeTask(xiaomieyegouTask:getRealid()), -- 未接受杀狗任务
      TalkAnt:atLeastLevel(3), -- 至少3级
    },
    progress = {
      [0] = {
        TalkSession:reply('你可以帮帮我吗？'),
        TalkSession:speak('怎么了，发生了什么事情？'),
        TalkSession:reply('昨天我带着我的小鸡们去村外山泉边散步的时候，被野狗袭击了。'),
        TalkSession:speak('啊，那你没事吧。'),
        TalkSession:reply('我虽然没事，但是我的小鸡被叼走了几只。'),
        TalkSession:speak('人没事就好。'),
        TalkSession:reply('这些野狗太可恶了。你可以帮我消灭一些吗？'),
        TalkSession:choose({
          PlayerTalk:stop('没问题'):call(function (player, actor)
            TaskHelper.acceptTask(player.objid, xiaomieyegouTask)
          end),
          PlayerTalk:continue('我先看看情况再说。'),
        }),
        TalkSession:reply('……'),
      },
    }
  }),
  TalkInfo:new({
    id = 2,
    ants = {
      TalkAnt:includeTask(xiaomieyegouTask:getRealid(), 1), -- 杀狗任务未完成
    },
    progress = {
      [0] = {
        TalkSession:speak('你说的野狗在哪里？'),
        TalkSession:reply('野狗就在村外山泉旁游荡，你要小心哦。'),
        TalkSession:speak('我知道了，我会的。'),
      },
    }
  }),
  TalkInfo:new({
    id = 3,
    ants = {
      TalkAnt:includeTask(xiaomieyegouTask:getRealid(), 2), -- 杀狗任务已完成
    },
    progress = {
      [0] = {
        TalkSession:speak('我消灭了一些野狗了。'),
        TalkSession:reply('真是太好了。这是我的小帽子，送给你了。'):call(function(player, actor)
          TaskHelper.finishTask(player.objid, xiaomieyegouTask)
        end),
      },
    }
  }),
}