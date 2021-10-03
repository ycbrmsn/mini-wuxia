-- 风颖城对话详情

-- 叶小龙
yexiaolongTalkInfos = {
  -- 主线
  TalkInfo:new({
    id = 100,
    ants = {
      TalkAnt:orAnts(
        TalkAnt:andAnts(
          TalkAnt:isHostPlayer(true),
          TalkAnt:justItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 1), -- 剧情一
          TalkAnt:justItem(MyMap.ITEM.GAME_DATA_MAIN_PROGRESS_ID, 4) -- 进度4
        ), -- 房主
        TalkAnt:andAnts(
          TalkAnt:isHostPlayer(false),
          TalkAnt:hosterJustItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 1), -- 剧情一
          TalkAnt:includeTask(function ()
            return story1:getTaskIdByName('村长的礼物')
          end),
          TalkAnt:excludeTask(function ()
            return story1:getTaskIdByName('考核任务')
          end)
        ) -- 非房主
      ),
    },
    progress = {
      [0] = {
        TalkSession:reply('你是来报名的吗？'),
        TalkSession:speak('是的，是的。'),
        TalkSession:reply('嗯，我看你天庭饱满，骨骼惊奇，应该没什么大问题。'),
        TalkSession:speak('真的吗？那我可以进入学院了吗？'),
        TalkSession:reply('必要的考验还是需要的。听说这里附近有一个恶狼谷。你去杀十匹恶狼证明你的实力。'),
        TalkSession:speak('好，我这就去。'):call(function (player, actor)
          TaskHelper.acceptTask(player.objid, xiaomieelangTask)
          TaskHelper.addTask(player.objid, story1:getTaskIdByName('考核任务'))
          StoryHelper.forward(1, '村长的礼物')
        end),
      },
    },
  }),
  TalkInfo:new({
    id = 2,
    ants = {
      TalkAnt:includeTask(xiaomieelangTask:getRealid(), 1), -- 消灭恶狼任务未完成
    },
    progress = {
      [0] = {
        TalkSession:reply('据说出了村沿河流向东走就可以到达恶狼谷。'),
        TalkSession:speak('我知道了。'),
      },
    }
  }),
  TalkInfo:new({
    id = 3,
    ants = {
      TalkAnt:includeTask(xiaomieelangTask:getRealid(), 2), -- 消灭恶狼任务已完成
    },
    progress = {
      [0] = {
        TalkSession:noDialogue():call(function(player, actor)
          player:speak(0, '先生，我已经消灭了足够的恶狼了。')
          TaskHelper.finishTask(player.objid, xiaomieelangTask)
        end),
      },
    }
  }),
}

-- 千兵卫
qianbingweiTalkInfos = {
  -- 击败叛军
  TalkInfo:new({
    id = 1,
    ants = {
      TalkAnt:excludeTask(jibaipanjunTask:getRealid()), -- 未接受过此任务
      TalkAnt:atLeastLevel(15), -- 至少15级
    },
    progress = {
      [0] = {
        TalkSession:reply('城外的叛军似乎越来越壮大了。'),
        TalkSession:speak('发生了什么事？'),
        TalkSession:reply('有一股叛军盘踞在风颖城外的东方，似乎蠢蠢欲动。'),
        TalkSession:speak('我能够做些什么吗？'),
        TalkSession:reply('因为一些原因，我们的人无法前往。你能帮我消灭一些吗？'),
        TalkSession:choose({
          PlayerTalk:stop('没问题'):call(function (player, actor)
            TaskHelper.acceptTask(player.objid, jibaipanjunTask)
          end),
          PlayerTalk:continue('等我再厉害些再说。'),
        }),
        TalkSession:reply('……'),
      },
    }
  }),
  TalkInfo:new({
    id = 2,
    ants = {
      TalkAnt:includeTask(jibaipanjunTask:getRealid(), 1), -- 任务未完成
    },
    progress = {
      [0] = {
        TalkSession:reply('叛军就盘踞在城外东方。'),
        TalkSession:speak('我知道了。'),
      },
    }
  }),
  TalkInfo:new({
    id = 3,
    ants = {
      TalkAnt:includeTask(jibaipanjunTask:getRealid(), 2), -- 任务已完成
    },
    progress = {
      [0] = {
        TalkSession:speak('我击败了一些叛军。'),
        TalkSession:reply('干得不错。这是你的奖励。'):call(function(player, actor)
          TaskHelper.finishTask(player.objid, jibaipanjunTask)
        end),
      },
    }
  }),
}