-- 风颖城对话详情

-- 叶小龙
yexiaolongTalkInfos = {
  -- 主线1对话叶先生
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
            return story1:getTaskIdByName('对话村长')
          end),
          TalkAnt:excludeTask(function ()
            return story1:getTaskIdByName('对话叶先生')
          end)
        ) -- 非房主
      ),
    },
    progress = {
      [0] = {
        TalkSession:reply('你是来报名的吗？'),
        TalkSession:speak('是的，是的。'),
        TalkSession:reply('……'):ant(TalkAnt:atMostLevel(4)),
        TalkSession:noReply('这还不到5级，去了和送死差不多。'):ant(TalkAnt:atMostLevel(4)),
        TalkSession:reply('你现在太羸弱了。等你变强一点再来吧。'):ant(
          TalkAnt:atMostLevel(4)
        ):call(function (player, actor)
          TalkHelper.turnTalkIndex(player.objid, actor)
        end),
        TalkSession:reply('嗯，我看你天庭饱满，骨骼惊奇，应该没什么大问题。'),
        TalkSession:speak('真的吗？那我可以进入学院了吗？'),
        TalkSession:reply('必要的考验还是需要的。听说这里附近有一个恶狼谷。你去杀十匹恶狼证明你的实力。'),
        TalkSession:speak('好，我这就去。'):call(function (player, actor)
          TaskHelper.acceptTask(player.objid, xiaomieelangTask)
          StoryHelper.forwardByPlayer(player.objid, 1, '对话叶先生')
        end),
      },
    },
  }),
  -- 主线1未消灭恶狼
  TalkInfo:new({
    id = 101,
    ants = {
      TalkAnt:hosterJustItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 1), -- 剧情一
      TalkAnt:includeTask(xiaomieelangTask:getRealid(), 1), -- 消灭恶狼任务未完成
    },
    progress = {
      [0] = {
        TalkSession:reply('据说出了村沿河流向东走就可以到达恶狼谷。'),
        TalkSession:speak('我知道了。'),
      },
    }
  }),
  -- 主线1已消灭恶狼
  TalkInfo:new({
    id = 102,
    ants = {
      TalkAnt:hosterJustItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 1), -- 剧情一
      TalkAnt:includeTask(xiaomieelangTask:getRealid(), 2), -- 消灭恶狼任务已完成
    },
    progress = {
      [0] = {
        TalkSession:noDialogue():call(function (player, actor)
          player:speak(0, '先生，我已经消灭了足够的恶狼了。')
          TaskHelper.finishTask(player.objid, xiaomieelangTask)
        end),
      },
    }
  }),
  -- 主线3对话叶先生
  TalkInfo:new({
    id = 103,
    ants = {
      TalkAnt:orAnts(
        TalkAnt:andAnts(
          TalkAnt:isHostPlayer(true),
          TalkAnt:justItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 3), -- 剧情三
          TalkAnt:justItem(MyMap.ITEM.GAME_DATA_MAIN_PROGRESS_ID, 7) -- 进度7
        ), -- 房主
        TalkAnt:andAnts(
          TalkAnt:isHostPlayer(false),
          TalkAnt:hosterJustItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 3), -- 剧情三
          TalkAnt:includeTask(function ()
            return story3:getTaskIdByName('消灭大头目')
          end),
          TalkAnt:excludeTask(function ()
            return story3:getTaskIdByName('对话叶先生')
          end)
        ) -- 非房主
      ),
    },
    progress = {
      [0] = {
        TalkSession:reply('看样子你应该消灭强盗了。'),
        TalkSession:speak('是的。虽然他们不讲武德，但是我还是成功消灭了他们。'),
        TalkSession:reply('干得很好，不愧是我的学生。'),
        TalkSession:speak('先生过誉了。'),
        TalkSession:reply('嗯，在学院这么久，你应该也学到了不少东西。'),
        TalkSession:think('好像……'),
        TalkSession:reply('学院一向主张读万卷书，行万里路。因此当学生在学习到一定阶段后，便需要外出历练一番。'),
        TalkSession:reply('不过，在外出历练之前，需要经过学院考试。只有通过的学生，才有外出历练的资格。'),
        TalkSession:reply('如今，你也到了该历练的时候了。'),
        TalkSession:speak('啊，要考试了丫。'),
        TalkSession:reply('哈哈，考试不难的，不用担心。当然，不好好准备一番，可也是很容易不通过的。'),
        TalkSession:reply('如果你准备好了，就来找我。你先去准备吧。'),
        TalkSession:speak('好的，先生。'):call(function (player, actor)
          StoryHelper.forwardByPlayer(player.objid, 3, '对话叶先生')
        end),
      },
    },
  }),
  -- 主线3接受考试
  TalkInfo:new({
    id = 104,
    ants = {
      TalkAnt:includeTask(MyTask.T308), -- 接受考试任务
    },
    progress = {
      [0] = {
        TalkSession:speak('先生，我准备好了。'),
        TalkSession:reply('这天还没亮，等天亮了再说。'):ant(
          TalkAnt:betweenHour(0, 5) -- 天没亮
        ):call(function (player, actor)
          TalkHelper.turnTalkIndex(player.objid, actor)
        end),
        TalkSession:reply('今天不早了，等明天再说。'):ant(
          TalkAnt:betweenHour(20, 23) -- 已天黑
        ):call(function (player, actor)
          TalkHelper.turnTalkIndex(player.objid, actor)
        end),
        TalkSession:reply('还有人在考试呢。先等一等。'):ant(
          TalkAnt:custom(function ()
            return story3.testObjid and true or false
          end) -- 有人在考试
        ):call(function (player, actor)
          TalkHelper.turnTalkIndex(player.objid, actor)
        end),
        TalkSession:reply('很好。这就送你去练武场。'):call(function (player, actor)
          story3:startTest(player)
        end),
      },
    },
  }),
  -- 准备考试
  TalkInfo:new({
    id = 110,
    ants = {
      TalkAnt:orAnts(
        TalkAnt:andAnts(
          TalkAnt:isHostPlayer(true),
          TalkAnt:justItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 3), -- 剧情三
          TalkAnt:justItem(MyMap.ITEM.GAME_DATA_MAIN_PROGRESS_ID, 8) -- 进度8
        ), -- 房主
        TalkAnt:andAnts(
          TalkAnt:isHostPlayer(false),
          TalkAnt:hosterJustItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 3), -- 剧情三
          TalkAnt:includeTask(function ()
            return story3:getTaskIdByName('对话叶先生')
          end),
          TalkAnt:excludeTask(function ()
            return story3:getTaskIdByName('开始考试')
          end)
        ) -- 非房主
      ),
    },
    progress = {
      [0] = {
        TalkSession:reply('怎么样，你做好考试的准备的了吗？'),
        TalkSession:choose({
          PlayerTalk:continue('准备好了'):call(function (player)
            TaskHelper.addTempTask(player.objid, MyTask.T308)
            player:resetTalkIndex(0)
          end),
          PlayerTalk:continue('还没准备好'),
        }),
        TalkSession:speak('我还没准备好。'),
        TalkSession:reply('无妨，再好好准备准备也不错。'),
      },
    },
  }),
  -- 考试没通过
  TalkInfo:new({
    id = 111,
    ants = {
      TalkAnt:orAnts(
        TalkAnt:andAnts(
          TalkAnt:isHostPlayer(true),
          TalkAnt:justItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 3), -- 剧情三
          TalkAnt:justItem(MyMap.ITEM.GAME_DATA_MAIN_PROGRESS_ID, 10) -- 进度10
        ), -- 房主
        TalkAnt:andAnts(
          TalkAnt:isHostPlayer(false),
          TalkAnt:hosterJustItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 3), -- 剧情三
          TalkAnt:includeTask(function ()
            return story3:getTaskIdByName('考试没通过')
          end),
          TalkAnt:excludeTask(function ()
            return story3:getTaskIdByName('开始考试')
          end),
          TalkAnt:excludeTask(function ()
            return story3:getTaskIdByName('考试通过')
          end)
        ) -- 非房主
      ),
    },
    progress = {
      [0] = {
        TalkSession:reply('上次没有好好准备吧。你做好补考的准备的了吗？'),
        TalkSession:choose({
          PlayerTalk:continue('准备好了'):call(function (player)
            TaskHelper.addTempTask(player.objid, MyTask.T308)
            player:resetTalkIndex(0)
          end),
          PlayerTalk:continue('还没准备好'),
        }),
        TalkSession:speak('我还没准备好。'),
        TalkSession:reply('无妨，再好好准备准备也不错。'),
      },
    },
  }),
  -- 考试通过
  TalkInfo:new({
    id = 112,
    ants = {
      TalkAnt:orAnts(
        TalkAnt:andAnts(
          TalkAnt:isHostPlayer(true),
          TalkAnt:justItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 3), -- 剧情三
          TalkAnt:justItem(MyMap.ITEM.GAME_DATA_MAIN_PROGRESS_ID, 11) -- 进度10
        ), -- 房主
        TalkAnt:andAnts(
          TalkAnt:isHostPlayer(false),
          TalkAnt:hosterJustItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 3), -- 剧情三
          TalkAnt:includeTask(function ()
            return story3:getTaskIdByName('考试通过')
          end)
        ) -- 非房主
      ),
    },
    progress = {
      [0] = {
        TalkSession:reply('你果然通过了考试。你成长的速度快赶上当年的我了。'),
        TalkSession:speak('都是学院与先生的功劳。'),
        TalkSession:reply('嗯……学院的历练还有一段时间。你先四处去逛逛吧。'),
      },
    },
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
          PlayerTalk:acceptTask('没问题', jibaipanjunTask),
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
        TalkSession:reply('干得不错。这是你的奖励。'):call(function (player, actor)
          TaskHelper.finishTask(player.objid, jibaipanjunTask)
        end),
      },
    }
  }),
}

-- 高小虎
gaoxiaohuTalkInfos = {
  -- 主线
  TalkInfo:new({
    id = 100,
    ants = {
      TalkAnt:orAnts(
        TalkAnt:andAnts(
          TalkAnt:isHostPlayer(true),
          TalkAnt:justItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 3), -- 剧情三
          TalkAnt:justItem(MyMap.ITEM.GAME_DATA_MAIN_PROGRESS_ID, 3) -- 进度三
        ), -- 房主
        TalkAnt:andAnts(
          TalkAnt:isHostPlayer(false),
          TalkAnt:hosterJustItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 3), -- 剧情三
          TalkAnt:includeTask(function ()
            return story3:getTaskIdByName('先生的声音')
          end),
          TalkAnt:excludeTask(function ()
            return story3:getTaskIdByName('对话高先生')
          end)
        ) -- 非房主
      ),
    },
    progress = {
      [0] = {
        TalkSession:reply('听小龙说你们被强盗袭击了。'),
        TalkSession:speak('是的，先生。'),
        TalkSession:reply('现在的强盗真是太猖狂了。据我所知，他们似乎是盘踞在你们村不远处。'),
        TalkSession:speak('好像是的。'),
        TalkSession:reply('此事我还要跟小龙商榷一番。对了，初入学院，你可以去真宝阁领取一件不错的武器。'),
        TalkSession:speak('真宝阁？'),
        TalkSession:reply('是的，就在学院对面。武器虽然品质不错，但却是随机的，趁不趁手就看你运气了。'),
        TalkSession:speak('好的，我这就去看看。'):call(function (player, actor)
          StoryHelper.forwardByPlayer(player.objid, 3, '对话高先生')
        end),
      },
    },
  }),
  -- 主线
  TalkInfo:new({
    id = 101,
    ants = {
      TalkAnt:orAnts(
        TalkAnt:andAnts(
          TalkAnt:isHostPlayer(true),
          TalkAnt:justItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 3), -- 剧情三
          TalkAnt:justItem(MyMap.ITEM.GAME_DATA_MAIN_PROGRESS_ID, 5) -- 进度五
        ), -- 房主
        TalkAnt:andAnts(
          TalkAnt:isHostPlayer(false),
          TalkAnt:hosterJustItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 3), -- 剧情三
          TalkAnt:includeTask(function ()
            return story3:getTaskIdByName('新生武器')
          end),
          TalkAnt:excludeTask(function ()
            return story3:getTaskIdByName('接受任务')
          end)
        ) -- 非房主
      ),
    },
    progress = {
      [0] = {
        TalkSession:reply('怎么样，领取的武器还趁手吗？'),
        TalkSession:speak('嗯，还不错。'),
        TalkSession:reply('那挺好。我跟小龙商议了一番，强盗不除隐患不小。我们决定派你去消灭他们。'),
        TalkSession:speak('我？！'),
        TalkSession:reply('既然小龙选中你，那就证明了你的不凡。并且如今有利器在手，自然不会如上次那般。'),
        TalkSession:speak('可是强盗那么多人。'),
        TalkSession:reply('并不需要消灭所有强盗。你只需要消灭他们的大头目。'),
        TalkSession:speak('消灭大头目就行了吗？'),
        TalkSession:reply('正所谓射人射马，擒贼擒王。消灭他们首领，其他强盗便如一盘散沙，就不足为虑了。'),
        TalkSession:speak('消灭一个人问题不大。'),
        TalkSession:reply('虽说就一人，但能当上大头目实力自不容小觑。如果你没有准备好，就不要贸然行动。'),
        TalkSession:speak('我知道了。'),
        TalkSession:reply('强盗大头目应该在营地深处。切记不要陷入他们的包围，否则凶多吉少。'),
        TalkSession:speak('嗯，我这就去准备。'):call(function (player, actor)
          TaskHelper.acceptTask(player.objid, xiaomieqiangdaoTask)
          StoryHelper.forwardByPlayer(player.objid, 3, '接受任务')
        end),
      },
    },
  }),
  TalkInfo:new({
    id = 102,
    ants = {
      TalkAnt:hosterJustItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 3), -- 剧情三
      TalkAnt:includeTask(xiaomieqiangdaoTask:getRealid(), 1), -- 消灭大头目任务未完成
    },
    progress = {
      [0] = {
        TalkSession:reply('任务前必要的准备还是需要的。'),
        TalkSession:speak('嗯嗯，我知道。'),
      },
    }
  }),
  TalkInfo:new({
    id = 103,
    ants = {
      TalkAnt:hosterJustItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 3), -- 剧情三
      TalkAnt:includeTask(xiaomieqiangdaoTask:getRealid(), 2), -- 消灭大头目任务已完成
    },
    progress = {
      [0] = {
        TalkSession:speak('高先生，不辱使命。'),
        TalkSession:reply('你果然做到了。嗯，这个给你。你去找小龙吧，他有话对你说。'):call(function (player, actor)
          TaskHelper.finishTask(player.objid, xiaomieqiangdaoTask)
          StoryHelper.forwardByPlayer(player.objid, 3, '消灭大头目')
        end),
      },
    }
  }),
}

-- 钱多
qianduoTalkInfos = {
  -- 主线
  TalkInfo:new({
    id = 100,
    ants = {
      TalkAnt:orAnts(
        TalkAnt:andAnts(
          TalkAnt:isHostPlayer(true),
          TalkAnt:justItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 3), -- 剧情三
          TalkAnt:justItem(MyMap.ITEM.GAME_DATA_MAIN_PROGRESS_ID, 4) -- 进度四
        ), -- 房主
        TalkAnt:andAnts(
          TalkAnt:isHostPlayer(false),
          TalkAnt:hosterJustItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 3), -- 剧情三
          TalkAnt:includeTask(function ()
            return story3:getTaskIdByName('对话高先生')
          end),
          TalkAnt:excludeTask(function ()
            return story3:getTaskIdByName('新生武器')
          end)
        ) -- 非房主
      ),
    },
    progress = {
      [0] = {
        TalkSession:reply('你好，想买点什么吗？'),
        TalkSession:speak('我是来领武器的。'),
        TalkSession:reply('哦，你就是今年新入学院的新生吧。我听说过你的事情，强盗猖獗啊。'),
        TalkSession:speak('嗯，还好有叶先生在。'),
        TalkSession:reply('小龙的武艺确实不凡。不过，如果你有一件神兵利器在手，那这种事情也不难解决。'),
        TalkSession:speak('我可以领神兵利器吗？'),
        TalkSession:reply('咳咳，武器再好，也需要一定的武术修为。一个三岁孩童，即使手持神兵我也不怕。'),
        TalkSession:speak('好像是的。'),
        TalkSession:reply('初入学院，你可以领取一件绿品武器。不过，你也可以购买更高品质的武器。'),
        TalkSession:speak('你这里有神兵卖吗？'),
        TalkSession:reply('橙品红品武器没有，毕竟那只是传说。紫品武器却是有的，不过价格不菲。'),
        TalkSession:speak('嗯，我知道了。'),
        TalkSession:reply('好，这是绿品武器匣，里面放着一把绿品武器。不过是不是你想要的，就看你运气了。'),
        TalkSession:speak('好的，谢谢。'):call(function (player, actor)
          BackpackHelper.gainItem(player.objid, MyMap.ITEM.GREEN_WEAPON_BOX_ID, 1) -- 绿品武器匣
          StoryHelper.forwardByPlayer(player.objid, 3, '新生武器')
        end),
      },
    },
  }),
}

-- 江火
jianghuoTalkInfos = {
  -- 帮江火送信
  TalkInfo:new({
    id = 1,
    ants = {
      TalkAnt:hosterJustItem(MyMap.ITEM.GAME_DATA_MAIN_INDEX_ID, 3), -- 剧情三
      TalkAnt:excludeTask(songxinTask:getRealid()), -- 未接受送信任务
    },
    progress = {
      [0] = {
        TalkSession:reply('咦，你怎么来学院了？'),
        TalkSession:speak('叶先生招我来的。'),
        TalkSession:reply('嗯，不错不错。当初我就觉得你砍树挺厉害的，叶先生一定是看中你的才能了。'),
        TalkSession:speak('我不是来砍树的！！！'),
        TalkSession:reply('哈哈，我知道。听说你被强盗打了，怎么样，没事吧。'),
        TalkSession:speak('看我现在好好的。'),
        TalkSession:reply('没事就好。转眼来学院这么多年了，不知道我哥哥们可好？'),
        TalkSession:speak('他们挺好的，天天都在村门口晃来晃去。'),
        TalkSession:reply('真想回去看看他们。奈何如今学艺未成，不可半途而归。'),
        TalkSession:speak('你看我就天天到处跑。'),
        TalkSession:reply('……'),
        TalkSession:reply('也罢，我这有封书信，一直犹豫要不要寄。你可以帮忙送回去吗？'),
        TalkSession:choose({
          PlayerTalk:acceptTask('答应', songxinTask, '没问题。'):call(function (player, actor)
            BackpackHelper.gainItem(player.objid, MyMap.ITEM.LETTER_JIANGHUO_ID, 1) -- 江火的信
          end),
          PlayerTalk:stop('拒绝', '我暂时不回去。'),
        }),
      },
    },
  }),
  TalkInfo:new({
    id = 2,
    ants = {
      TalkAnt:includeTask(songxinTask:getRealid(), 1), -- 任务未完成
    },
    progress = {
      [0] = {
        TalkSession:speak('我要将信送给谁呢？'),
        TalkSession:reply('你把信交给我大哥就行了。'),
        TalkSession:speak('好的，我知道了。'),
      },
    }
  }),
  TalkInfo:new({
    id = 3,
    ants = {
      TalkAnt:includeTask(songxinTask:getRealid(), 2), -- 任务已完成
    },
    progress = {
      [0] = {
        TalkSession:reply('你把信送到了吗？'),
        TalkSession:speak('是的。'),
        TalkSession:reply('总算了却了一桩心事。来，给你传授一些我这些年的武学经验。'):call(function (player, actor)
          jianghuo.action:playFree2()
          ActorHelper.playAndStopBodyEffect(jianghuo.objid, BaseConstant.BODY_EFFECT.LIGHT4)
        end),
        TalkSession:think('你不是学艺未成吗？不会有问题吧……'):call(function (player, actor)
          TaskHelper.finishTask(player.objid, songxinTask)
        end),
      },
    }
  }),
}