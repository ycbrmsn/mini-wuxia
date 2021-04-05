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
          TalkAnt:justItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 1), -- 剧情一
          TalkAnt:justItem(MyMap.ITEM.GAME_DATA_MAIN_PROGRESS_ID, 3) -- 进度三
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
          end
        end),
      },
    },
  }),
  -- 采集落叶松木
  TaskHelper.generateAcceptTalk(KanshuTask, {
    { 3, '有什么我能帮忙的吗？' },
    { 1, '村里的房子又需要修葺一下了。' },
    { 1, '我需要一些落叶松木，你可以帮我砍一些回来吗？' },
    { '没问题。', '村长我正忙着呢。' },
  }),
  TaskHelper.generateQueryTalk(KanshuTask, {
    { 3, '村长，我没有找到落叶松木。' },
    { 1, '村子外面就有一片落叶松林。' },
    { 3, '哦，我知道了。' },
  }),
  TaskHelper.generatePayTalk(KanshuTask, {
    { 3, '村长我采回来了。' },
    { 1, '真是个好孩子。' },
  }),
  TalkInfo:new({
    id = 1,
    progress = {
      [0] = {
        TalkSession:reply('{{:getName}}，你来啦。'):call(function (player, actor)
          local playerTalks = {}
          local talkid, progressid, clearIndex = 1, 0, 2
          TalkHelper.clearProgressContent(actor, talkid, progressid, clearIndex)
          TaskHelper.appendPlayerTalk(playerTalks, player, KanshuTask)
          -- 其他
          table.insert(playerTalks, PlayerTalk:continue('闲聊'))
          TalkHelper.addProgressContent(actor, talkid, progressid, TalkSession:choose(playerTalks))
          TalkHelper.addProgressContent(actor, talkid, progressid, TalkSession:speak('对呢，我来逛逛。'))
        end),
      },
    }
  }),
}

-- 王大力
-- wangdaliTalkInfos = {
--   TalkInfo:new({
--     id = 1,
--     progress = {
--       [0] = {
--         TalkSession:reply('你要买点武器吗？'),
--         TalkSession:choose({
--           PlayerTalk:stop('买武器'):call(function (player)
--             player:addTalkTask(zixunwuqiTask)
--           end),
--           PlayerTalk:continue('咨询武器'),
--         }),
--       },
--     }
--   }),
-- }

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
          TalkAnt:excludeItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID) -- 无剧情
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
            PlayerHelper.notifyGameInfo2Self(player.objid, '获得' .. ItemHelper.getItemName(itemid))
          end
        end),
      },
    },
  }),
  -- 消灭野狗
  TalkInfo:new({
    id = 1,
    ants = {
      TalkAnt:excludeItem(XiaomieyegouTask.rewards[1].itemid), -- 没有皮头盔
      TalkAnt:excludeTask(XiaomieyegouTask:getRealid()), -- 未接受杀狗任务
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
            TaskHelper.acceptTask(player.objid, XiaomieyegouTask)
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
      TalkAnt:includeTask(XiaomieyegouTask:getRealid(), 1), -- 杀狗任务未完成
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
      TalkAnt:includeTask(XiaomieyegouTask:getRealid(), 2), -- 杀狗任务已完成
    },
    progress = {
      [0] = {
        TalkSession:speak('我消灭了一些野狗了。'),
        TalkSession:reply('真是太好了。这是我的小帽子，送给你了。'):call(function(player, actor)
          TaskHelper.finishTask(player.objid, XiaomieyegouTask)
        end),
      },
    }
  }),
}