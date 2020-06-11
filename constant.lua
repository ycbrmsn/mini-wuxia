-- 常量
MyConstant = {
  INIT_HOUR = 7, -- 初始时间
  PROJECTILE_HURT = 0, -- 通用投掷物固定伤害
  -- 人物ID
  -- 落叶村人物
  YANGWANLI_ACTOR_ID = 2, -- 杨万里村长ID
  WANGDALI_ACTOR_ID = 3, -- 王大力铁匠ID
  MIAOLAN_ACTOR_ID = 4, -- 苗兰大夫ID
  WENYU_ACTOR_ID = 5, -- 文羽ID
  HUAXIAOLOU_ACTOR_ID = 6, -- 花小楼ID
  JIANGFENG_ACTOR_ID = 7, -- 江枫ID
  JIANGYU_ACTOR_ID = 9, -- 江渔ID

  -- 风颖城人物
  YEXIAOLONG_ACTOR_ID = 10, -- 叶小龙ID
  LUDAOFENG_ACTOR_ID = 13, -- 陆道风
  QIANBINGWEI_ACTOR_ID = 14, -- 千兵卫

  -- 怪物ID
  WOLF_ACTOR_ID = 11, -- 恶狼ID
  QIANGDAO_LOULUO_ACTOR_ID = 8, -- 强盗喽啰ID
  QIANGDAO_XIAOTOUMU_ACTOR_ID = 12, -- 强盗小头目ID
  GUARD_ACTOR_ID = 15, -- 卫兵

  -- 道具ID
  ITEM = {
    COIN_ID = 4101, -- 铜板ID
    POTION_ID = 4102, -- 回血药剂
    LOG_PAPER_ID = 4106, -- 江湖日志ID
    TOKEN_ID = 4111, -- 风颖城通行令牌ID
    WENYU_PACKAGE_ID = 4116, -- 文羽包裹
    YANGWANLI_PACKAGE_ID = 4117 -- 村长包裹
  },
  WEAPON = {
    ARROW_ID = 4130, -- 箭矢ID
    QUIVER_ID = 4133, -- 箭袋ID
    COMMON_PROJECTILE_ID = 4159 -- 通用投掷物ID
  },
  BODY_EFFECT = {
    SMOG1 = 1226, -- 一团小烟雾随即消失

    BOOM1 = 1186, -- 黄色的小爆炸脚下一个圈

    LIGHT3 = 1008, -- 一颗心加血特效
    LIGHT9 = 1150, -- 一堆心加血特效
    LIGHT10 = 1185, -- 两格大小的两个气旋不停旋转
    LIGHT19 = 1223, -- 一格大小的淡蓝色方框气流圈住流动
    LIGHT22 = 1227, -- 一圈紫色光幕围住并盘旋着锁链
    LIGHT24 = 1231, -- 黄色的无敌盾保护圈
    LIGHT26 = 1235, -- 红十字加血特效
    LIGHT47 = 1337, -- 接近一格大小的一团蓝色光雾周围一些小蓝点

    PARTICLE24 = 1341 -- 两格大小的一个黄色小光源
  },
  SOUND_EFFECT = {
    SKILL9 = 10086 -- 一阵风的声音
  }
}

MyWeaponAttr = {
  -- 剑
  woodSword = { -- 木剑
    levelIds = { 4129 },
    attack = 10,
    defense = 5,
    addAttPerLevel = 1,
    addDefPerLevel = 0
  },
  bronzeSword = { -- 青铜剑
    levelIds = { 4136 },
    attack = 22,
    defense = 5,
    addAttPerLevel = 1,
    addDefPerLevel = 0
  },
  stabTigerSword = { -- 刺虎剑
    levelIds = { 4144 },
    attack = 35,
    defense = 10,
    addAttPerLevel = 2,
    addDefPerLevel = 1
  },
  drinkBloodSword = { -- 饮血剑
    levelIds = { 4147 },
    attack = 14,
    defense = 5,
    hp = 5,
    addAttPerLevel = 2,
    addDefPerLevel = 0,
    addHpPerLevel = 1
  },
  strongAttackSword = { -- 闪袭剑
    levelIds = { 4162 },
    attack = 20,
    defense = 3,
    cd = 15,
    addAttPerLevel = 2,
    addDefPerLevel = 1
  },
  chaseWindSword = { -- 追风剑
    levelIds = { 4165 },
    projectileid = 4168,
    attack = 30,
    defense = 10,
    cd = 15,
    addAttPerLevel = 3,
    addDefPerLevel = 0
  },

  -- 刀
  woodKnife = { -- 木刀
    levelIds = { 4132 },
    attack = 13,
    defense = 2,
    addAttPerLevel = 1,
    addDefPerLevel = 0
  },
  bronzeKnife = { -- 青铜刀
    levelIds = { 4138 },
    attack = 27,
    defense = 2,
    addAttPerLevel = 1,
    addDefPerLevel = 0
  },
  cutDeerKnife = { -- 割鹿刀
    levelIds = { 4145 },
    attack = 41,
    defense = 5,
    addAttPerLevel = 2,
    addDefPerLevel = 1
  },
  congealFrostKnife = { -- 凝霜刀
    levelIds = { 4148 },
    attack = 17,
    defense = 2,
    addAttPerLevel = 2,
    addDefPerLevel = 0
  },
  rejuvenationKnife = { -- 回春刀
    levelIds = { 4163 },
    attack = 25,
    defense = 5,
    cd = 15,
    addAttPerLevel = 2,
    addDefPerLevel = 1
  },
  sealDemonKnife = { -- 封魔刀
    levelIds = { 4166 },
    attack = 35,
    defense = 5,
    cd = 15,
    addAttPerLevel = 3,
    addDefPerLevel = 0
  },

  -- 枪
  woodSpear = { -- 木枪
    levelIds = { 4131 },
    attack = 17,
    defense = 0,
    strength = 20,
    addAttPerLevel = 1,
    addDefPerLevel = 0
  },
  bronzeSpear = { -- 青铜枪
    levelIds = { 4137 },
    attack = 33,
    defense = 0,
    strength = 30,
    addAttPerLevel = 1,
    addDefPerLevel = 0
  },
  controlDragonSpear = { -- 御龙枪
    levelIds = { 4146 },
    attack = 51,
    defense = 0,
    strength = 40,
    addAttPerLevel = 2,
    addDefPerLevel = 1
  },
  fireTipSpear = { -- 火尖枪
    levelIds = { 4149 },
    attack = 19,
    defense = 0,
    strength = 20,
    addAttPerLevel = 2,
    addDefPerLevel = 0
  },
  overlordSpear = { -- 霸王枪
    levelIds = { 4164 },
    attack = 36,
    defense = 0,
    strength = 30,
    cd = 15,
    addAttPerLevel = 2,
    addDefPerLevel = 1
  },
  shockSoulSpear = { -- 慑魂枪
    levelIds = { 4167 },
    attack = 55,
    defense = 0,
    strength = 40,
    cd = 15,
    addAttPerLevel = 3,
    addDefPerLevel = 0
  },

  -- 弓
  woodBow = { -- 木弓
    levelIds = { 4128 },
    attack = 15,
    defense = 0,
    addAttPerLevel = 1,
    addDefPerLevel = 0
  },
  bronzeBow = { -- 青铜弓
    levelIds = { 4139 },
    attack = 32,
    defense = 0,
    addAttPerLevel = 1,
    addDefPerLevel = 0
  },
  shootEagleBow = { -- 射雕弓
    levelIds = { 4143 },
    attack = 47,
    defense = 0,
    addAttPerLevel = 2,
    addDefPerLevel = 1
  },
  swallowSoulBow = { -- 噬魂弓
    levelIds = { 4150 },
    attack = 17,
    defense = 0,
    addAttPerLevel = 2,
    addDefPerLevel = 0
  },
  fallStarBow = { -- 坠星弓
    levelIds = { 4154 },
    attack = 35,
    defense = 0,
    cd = 15,
    addAttPerLevel = 2,
    addDefPerLevel = 1
  },
  oneByOneBow = { -- 连珠弓
    levelIds = { 4158 },
    attack = 47,
    defense = 0,
    cd = 15,
    addAttPerLevel = 3,
    addDefPerLevel = 0
  }
}