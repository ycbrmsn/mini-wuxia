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
  }
}

MyWeaponAttr = {
  -- 剑
  woodSword = {
    attack = 10,
    defense = 5,
    addAttPerLevel = 1,
    addDefPerLevel = 0
  }, -- 木剑
  bronzeSword = {
    attack = 22,
    defense = 5,
    addAttPerLevel = 1,
    addDefPerLevel = 0
  }, -- 青铜剑
  stabTigerSword = {
    attack = 35,
    defense = 10,
    addAttPerLevel = 2,
    addDefPerLevel = 1
  }, -- 刺虎剑
  drinkBloodSword = {
    attack = 14,
    defense = 5,
    hp = 5,
    addAttPerLevel = 2,
    addDefPerLevel = 0,
    addHpPerLevel = 1
  }, -- 饮血剑
  strongAttackSword = {
    attack = 20,
    defense = 3,
    cd = 30,
    addAttPerLevel = 2,
    addDefPerLevel = 1
  }, -- 强袭剑
  chaseWindSword = {
    attack = 30,
    defense = 10,
    cd = 30,
    addAttPerLevel = 3,
    addDefPerLevel = 0
  }, -- 追风剑

  -- 刀
  woodKnife = {
    attack = 13,
    defense = 2,
    addAttPerLevel = 1,
    addDefPerLevel = 0
  }, -- 木刀
  bronzeKnife = {
    attack = 27,
    defense = 2,
    addAttPerLevel = 1,
    addDefPerLevel = 0
  }, -- 青铜刀
  cutDeerKnife = {
    attack = 41,
    defense = 5,
    addAttPerLevel = 2,
    addDefPerLevel = 1
  }, -- 割鹿刀
  congealFrostKnife = {
    attack = 17,
    defense = 2,
    addAttPerLevel = 2,
    addDefPerLevel = 0
  }, -- 凝霜刀
  rejuvenationKnife = {
    attack = 25,
    defense = 5,
    cd = 30,
    addAttPerLevel = 2,
    addDefPerLevel = 1
  }, -- 回春刀
  sealDemonKnife = {
    attack = 35,
    defense = 5,
    cd = 30,
    addAttPerLevel = 3,
    addDefPerLevel = 0
  }, -- 封魔刀

  -- 枪
  woodSpear = {
    attack = 17,
    defense = 0,
    strength = 20,
    addAttPerLevel = 1,
    addDefPerLevel = 0
  }, -- 木枪
  bronzeSpear = {
    attack = 33,
    defense = 0,
    strength = 30,
    addAttPerLevel = 1,
    addDefPerLevel = 0
  }, -- 青铜枪
  controlDragonSpear = {
    attack = 51,
    defense = 0,
    strength = 40,
    addAttPerLevel = 2,
    addDefPerLevel = 1
  }, -- 御龙枪
  fireTipSpear = {
    attack = 19,
    defense = 0,
    strength = 20,
    addAttPerLevel = 2,
    addDefPerLevel = 0
  }, -- 火尖枪
  overlordSpear = {
    attack = 36,
    defense = 0,
    strength = 30,
    cd = 30,
    addAttPerLevel = 2,
    addDefPerLevel = 1
  }, -- 霸王枪
  shockSoulSpear = {
    attack = 55,
    defense = 0,
    strength = 40,
    cd = 30,
    addAttPerLevel = 3,
    addDefPerLevel = 0
  }, -- 慑魂枪

  -- 弓
  woodBow = {
    attack = 15,
    defense = 0,
    addAttPerLevel = 1,
    addDefPerLevel = 0
  }, -- 木弓
  bronzeBow = {
    attack = 32,
    defense = 0,
    addAttPerLevel = 1,
    addDefPerLevel = 0
  }, -- 青铜弓
  shootEagleBow = {
    attack = 47,
    defense = 0,
    addAttPerLevel = 2,
    addDefPerLevel = 1
  }, -- 射雕弓
  swallowSoulBow = {
    attack = 17,
    defense = 0,
    addAttPerLevel = 2,
    addDefPerLevel = 0
  }, -- 噬魂弓
  fallStarBow = {
    attack = 35,
    defense = 0,
    cd = 30,
    addAttPerLevel = 2,
    addDefPerLevel = 1
  }, -- 坠星弓
  oneByOneBow = {
    attack = 47,
    defense = 0,
    cd = 30,
    addAttPerLevel = 3,
    addDefPerLevel = 0
  } -- 连珠弓
}