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
    YANGWANLI_PACKAGE_ID = 4117, -- 村长包裹
    APPLE_ID = 4125 -- 苹果
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
    LIGHT4 = 1023, -- 三格大小四散旋转的黄光
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

-- 武器属性
MyWeaponAttr = {
  -- 剑
  woodSword = { -- 木剑
    attack = 10,
    defense = 5,
    addAttPerLevel = 1,
    addDefPerLevel = 2
  },
  bronzeSword = { -- 青铜剑
    attack = 22,
    defense = 5,
    addAttPerLevel = 3,
    addDefPerLevel = 2
  },
  stabTigerSword = { -- 刺虎剑
    attack = 35,
    defense = 10,
    addAttPerLevel = 4,
    addDefPerLevel = 4
  },
  drinkBloodSword = { -- 饮血剑
    attack = 14,
    defense = 5,
    hp = 5,
    addAttPerLevel = 3,
    addDefPerLevel = 2,
    addHpPerLevel = 2
  },
  strongAttackSword = { -- 闪袭剑
    attack = 20,
    defense = 3,
    distance = 1,
    multiple = 2,
    cd = 15,
    addAttPerLevel = 4,
    addDefPerLevel = 4,
    addDistancePerLevel = 2,
    addMultiplePerLevel = 1
  },
  chaseWindSword = { -- 追风剑
    attack = 30,
    defense = 10,
    flyTime = 2,
    damage = 5,
    cd = 15,
    addAttPerLevel = 8,
    addDefPerLevel = 8,
    addFlyTimePerLevel = 1,
    addDamagePerLevel = 1
  },

  -- 刀
  woodKnife = { -- 木刀
    attack = 13,
    defense = 2,
    addAttPerLevel = 2,
    addDefPerLevel = 1
  },
  bronzeKnife = { -- 青铜刀
    attack = 27,
    defense = 2,
    addAttPerLevel = 4,
    addDefPerLevel = 1
  },
  cutDeerKnife = { -- 割鹿刀
    attack = 41,
    defense = 5,
    addAttPerLevel = 6,
    addDefPerLevel = 2
  },
  congealFrostKnife = { -- 凝霜刀
    attack = 17,
    defense = 2,
    addAttPerLevel = 4,
    addDefPerLevel = 1
  },
  rejuvenationKnife = { -- 回春刀
    attack = 25,
    defense = 5,
    skillTime = 5,
    cd = 15,
    addAttPerLevel = 6,
    addDefPerLevel = 2,
    addSkillTimePerLevel = 2
  },
  sealDemonKnife = { -- 封魔刀
    attack = 35,
    defense = 5,
    skillRange = 3,
    skillTime = 5,
    cd = 15,
    addAttPerLevel = 10,
    addDefPerLevel = 6,
    addSkillRangePerLevel = 1,
    addSkillTimePerLevel = 2
  },

  -- 枪
  woodSpear = { -- 木枪
    attack = 17,
    defense = 0,
    strength = 30,
    addAttPerLevel = 3,
    addDefPerLevel = 0
  },
  bronzeSpear = { -- 青铜枪
    attack = 33,
    defense = 0,
    strength = 40,
    addAttPerLevel = 5,
    addDefPerLevel = 0
  },
  controlDragonSpear = { -- 御龙枪
    attack = 51,
    defense = 0,
    strength = 50,
    addAttPerLevel = 8,
    addDefPerLevel = 0
  },
  fireTipSpear = { -- 火尖枪
    attack = 19,
    defense = 0,
    strength = 40,
    addAttPerLevel = 5,
    addDefPerLevel = 0
  },
  overlordSpear = { -- 霸王枪
    attack = 36,
    defense = 0,
    strength = 50,
    coverHp = 0.2,
    skillRange = 3,
    cd = 15,
    addAttPerLevel = 8,
    addDefPerLevel = 0,
    addCoverHpPerLevel = 0.1,
    addSkillRangePerLevel = 1
  },
  shockSoulSpear = { -- 慑魂枪
    attack = 55,
    defense = 0,
    strength = 100,
    skillRange = 2,
    skillTime = 1,
    cd = 15,
    addAttPerLevel = 16,
    addDefPerLevel = 0,
    addSkillRangePerLevel = 1,
    addSkillTimePerLevel = 1
  },

  -- 弓
  woodBow = { -- 木弓
    attack = 15,
    defense = 0,
    addAttPerLevel = 3,
    addDefPerLevel = 0
  },
  bronzeBow = { -- 青铜弓
    attack = 32,
    defense = 0,
    addAttPerLevel = 5,
    addDefPerLevel = 0
  },
  shootEagleBow = { -- 射雕弓
    attack = 47,
    defense = 0,
    addAttPerLevel = 8,
    addDefPerLevel = 0
  },
  swallowSoulBow = { -- 噬魂弓
    attack = 17,
    defense = 0,
    addAttPerLevel = 5,
    addDefPerLevel = 0
  },
  fallStarBow = { -- 坠星弓
    attack = 35,
    defense = 0,
    skillRange = 8,
    cd = 15,
    addAttPerLevel = 8,
    addDefPerLevel = 0,
    addSkillRangePerLevel = 1
  },
  oneByOneBow = { -- 连珠弓
    attack = 47,
    defense = 0,
    arrowNum = 3,
    cd = 15,
    addAttPerLevel = 16,
    addDefPerLevel = 0,
    addArrowNumPerLevel = 2
  }
}

-- 武器id
MyWeaponAttr.woodSword.levelIds = { 4129 } -- 木剑
MyWeaponAttr.bronzeSword.levelIds = { 4136 } -- 青铜剑
MyWeaponAttr.stabTigerSword.levelIds = { 4144 } -- 刺虎剑
MyWeaponAttr.drinkBloodSword.levelIds = { 4147 } -- 饮血剑
MyWeaponAttr.strongAttackSword.levelIds = { 4162 } -- 闪袭剑
MyWeaponAttr.chaseWindSword.levelIds = { 4165 } -- 追风剑
MyWeaponAttr.chaseWindSword.projectileid = 4168 -- 风行的追风剑
MyWeaponAttr.woodKnife.levelIds = { 4132 } -- 木刀
MyWeaponAttr.bronzeKnife.levelIds = { 4138 } -- 青铜刀
MyWeaponAttr.cutDeerKnife.levelIds = { 4145 } -- 割鹿刀
MyWeaponAttr.congealFrostKnife.levelIds = { 4148 } -- 凝霜刀
MyWeaponAttr.rejuvenationKnife.levelIds = { 4163 } -- 回春刀
MyWeaponAttr.sealDemonKnife.levelIds = { 4166 } -- 封魔刀
MyWeaponAttr.woodSpear.levelIds = { 4131 } -- 木枪
MyWeaponAttr.bronzeSpear.levelIds = { 4137 } -- 青铜枪
MyWeaponAttr.controlDragonSpear.levelIds = { 4146 } -- 御龙枪
MyWeaponAttr.fireTipSpear.levelIds = { 4149 } -- 火尖枪
MyWeaponAttr.overlordSpear.levelIds = { 4164 } -- 霸王枪
MyWeaponAttr.shockSoulSpear.levelIds = { 4167 } -- 慑魂枪
MyWeaponAttr.woodBow.levelIds = { 4170 } -- 木弓
MyWeaponAttr.bronzeBow.levelIds = { 4171 } -- 青铜弓
MyWeaponAttr.shootEagleBow.levelIds = { 4172 } -- 射雕弓
MyWeaponAttr.swallowSoulBow.levelIds = { 4173 } -- 噬魂弓
MyWeaponAttr.fallStarBow.levelIds = { 4174 } -- 坠星弓
MyWeaponAttr.oneByOneBow.levelIds = { 4175 } -- 连珠弓
