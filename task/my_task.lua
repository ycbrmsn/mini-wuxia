-- 我的任务

-- 对话任务

-- 咨询武器
zixunwuqiTask = BaseTask:new({ id = 1 })

-- 具体任务

-- 砍树任务
KanshuTask = BaseTask:new({
  id = 10000,
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
XiaomieyegouTask = BaseTask:new({
  id = 10001,
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
ShoujishouguTask = BaseTask:new({
  id = 10002,
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
