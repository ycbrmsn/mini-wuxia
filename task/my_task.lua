-- 我的任务
MyTask = {
  -- 对话任务
  ST10 = 10, -- 苗兰疗伤
  ST11 = 11, -- 药品介绍
  -- 剧情一
  ST102 = 102, -- 文羽
  ST103 = 103, -- 村长
  ST104 = 104 -- 叶小龙
}

-- 具体任务

-- 砍树任务
kanshuTask = BaseTask:new({
  id = BaseTask:autoid(),
  name = '采集落叶松木',
  itemid = MyMap.ITEM.MISSION_KANSHU,
  desc = '收集几根落叶松木，交给村长。',
  -- appendDesc = { 'desc', 'actorname', '。' },
  category = 2, -- 交付道具
  -- actorid = MyMap.ACTOR.YANGWANLI_ACTOR_ID, -- 交付NPC
  itemInfos = {
    { itemid = 201, num = 5 }, -- 落叶松木5个
  },
  rewards = {
    TaskReward:new({
      desc = '获得铜板数枚',
      category = 1,
      itemid = MyMap.ITEM.COIN_ID,
      num = 5,
    }),
  },
})

-- 消灭野狗
xiaomieyegouTask = BaseTask:new({
  id = BaseTask:autoid(),
  name = '消灭野狗',
  itemid = MyMap.ITEM.MISSION_XIAOMIEYEGOU,
  desc = '消灭几条野狗，然后回复文羽。',
  category = 1, -- 击败生物
  beatInfos = {
    { actorid = MyMap.ACTOR.DOG_ACTOR_ID, actorname = '野狗', num = 5, curnum = 0 }, -- 野狗5只
  },
  rewards = {
    TaskReward:new({
      desc = '获得一顶头盔',
      category = 1,
      itemid = 12201, -- 皮头盔
      num = 1,
    }),
  },
})

-- 收集兽骨任务
shoujishouguTask = BaseTask:new({
  id = BaseTask:autoid(),
  name = '收集兽骨',
  itemid = MyMap.ITEM.MISSION_SHOUJISHOUGU,
  desc = '收集几根兽骨，交给苗兰。',
  category = 2, -- 交付道具
  itemInfos = {
    { itemid = MyMap.ITEM.ANIMAL_BONE_ID, num = 5 }, -- 兽骨5个
  },
  rewards = {
    TaskReward:new({
      desc = '获得铜板数枚',
      category = 1,
      itemid = MyMap.ITEM.COIN_ID,
      num = 3,
    }),
    TaskReward:new({
      desc = '获得止血丹',
      category = 1,
      itemid = MyMap.ITEM.ZHIXUEDAN_ID,
      num = 1,
    }),
  },
})

-- 采集铜矿石任务
caijitongkuangshiTask = BaseTask:new({
  id = BaseTask:autoid(),
  name = '采集铜矿石',
  itemid = MyMap.ITEM.MISSION_CAIJITONGKUANGSHI,
  desc = '收集少量铜矿石，交给王大力。',
  category = 2, -- 交付道具
  itemInfos = {
    { itemid = MyMap.BLOCK.COPPER_ORE_ID, num = 10 }, -- 铜矿石10个
  },
  rewards = {
    TaskReward:new({
      desc = '获得武器一件',
      category = 1,
      itemid = MyMap.ITEM.COIN_ID,
      num = 0,
    }),
  },
})

-- 消灭恶狼
xiaomieelangTask = BaseTask:new({
  id = BaseTask:autoid(),
  name = '消灭恶狼',
  itemid = MyMap.ITEM.MISSION_XIAOMIEELANG,
  desc = '去恶狼谷消灭一些恶狼，回来向叶小龙报告。',
  category = 1, -- 击败生物
  beatInfos = {
    { actorid = MyMap.ACTOR.WOLF_ACTOR_ID, actorname = '恶狼', num = 10, curnum = 0 }, -- 恶狼10匹
  },
  rewards = {
    TaskReward:new({
      desc = '奖励不详',
      category = 1,
      itemid = MyMap.ITEM.TOKEN_ID, -- 令牌
      num = 1,
    }):call(function (objid)
      PlayerHelper.setItemDisableThrow(objid, MyMap.ITEM.TOKEN_ID)
      StoryHelper.forward(1, '考核任务')
      story1:finishNoticeEvent(objid)
    end),
  },
})

-- 消灭强盗
xiaomieqiangdaoTask = BaseTask:new({
  id = BaseTask:autoid(),
  name = '消灭强盗大头目',
  itemid = MyMap.ITEM.MISSION_XIAOMIEQIANGDAO,
  desc = '消灭强盗营地的强盗大头目，回来向高小虎报告。',
  category = 1, -- 击败生物
  beatInfos = {
    { actorid = MyMap.ACTOR.QIANGDAO_DATOUMU_ACTOR_ID, actorname = '强盗大头目', num = 1, curnum = 0 },
  },
  rewards = {
    TaskReward:new({
      desc = '奖励不详',
      category = 1,
      itemid = MyMap.ITEM.CHEST_GAO_ID, -- 宝箱
      num = 1,
    }):call(function (objid)
      StoryHelper.forward(3, '准备消灭大头目')
    end),
  },
})

-- 击败叛军
jibaipanjunTask = BaseTask:new({
  id = BaseTask:autoid(),
  name = '击败叛军',
  itemid = MyMap.ITEM.MISSION_JIBAIPANJUN,
  desc = '击败风颖城附近的叛军，回来向千兵卫报告。',
  category = 1, -- 击败生物
  beatInfos = {
    { actorid = MyMap.ACTOR.PANTAOJIANSHIBING_ACTOR_ID, actorname = '叛逃士兵（剑）', num = 10, curnum = 0 },
    { actorid = MyMap.ACTOR.PANTAOGONGSHIBING_ACTOR_ID, actorname = '叛逃士兵（弓）', num = 10, curnum = 0 },
  },
  rewards = {
    TaskReward:new({
      desc = '奖励不详',
      category = 1,
      itemid = MyMap.ITEM.CHEST_GAO_ID, -- 宝箱
      num = 1,
    }):call(function (objid)
      -- todo
      -- StoryHelper.forward(1, '村长的礼物')
      -- story1:finishNoticeEvent(objid)
    end),
  },
})

-- 送信
songxinTask = BaseTask:new({
  id = BaseTask:autoid(),
  name = '送信',
  itemid = MyMap.ITEM.MISSION_SONGXIN,
  desc = '帮江火送信给江枫。',
  category = 2, -- 交付道具
  itemInfos = {
    -- { itemid = MyMap.BLOCK.COPPER_ORE_ID, num = 10 }, -- 江枫的回信
  },
  rewards = {
    TaskReward:new({
      desc = '奖励不详',
      category = 2, -- 经验
      num = 100,
    }),
  },
})