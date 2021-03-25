-- 落叶村对话详情

-- 杨万里
yangwanliTalkInfos = {
  -- 采集落叶松木
  TaskHelper.generateAcceptTalk(KanshuTask.id, {
    { 3, '有什么我能帮忙的吗？' },
    { 1, '村里的房子又需要修葺一下了。' },
    { 1, '我需要一些落叶松木，你可以帮我砍一些回来吗？' },
    { '没问题。', '村长我正忙着呢。' },
  }, KanshuTask),
  TaskHelper.generateQueryTalk(KanshuTask.id, {
    { 3, '村长，我没有找到落叶松木。' },
    { 1, '村子外面就有一片落叶松林。' },
    { 3, '哦，我知道了。' },
  }),
  TaskHelper.generatePayTalk(KanshuTask.id, {
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
  -- 消灭野狗
  TalkInfo:new({
    id = 1,
    ants = {
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