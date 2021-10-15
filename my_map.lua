-- 地图相关数据
MyMap = {
  BLOCK = {
    COPPER_ORE_ID = 2036, -- 铜矿石
  },
  ITEM = {
    COIN_ID = 4101, -- 铜板ID
    POTION_ID = 4102, -- 回血药剂
    LOG_PAPER_ID = 4106, -- 江湖日志ID
    TOKEN_ID = 4111, -- 风颖城通行令牌ID
    WENYU_PACKAGE_ID = 4116, -- 文羽包裹
    YANGWANLI_PACKAGE_ID = 4117, -- 村长包裹
    APPLE_ID = 4125, -- 苹果
    ZHIXUEDAN_ID = 4140, -- 止血丹
    CREATE_BLOOD_PILL_ID = 4142, -- 生血丹
    WINE_ID = 4256, -- 最香酒
    CARRIAGE_LUOYECUN_ID = 4285, -- 落叶村车票
    CARRIAGE_PINGFENGZHAI_ID = 4286, -- 平风寨车票
    CARRIAGE_PANJUNYINGDI_ID = 4321, -- 叛军营地车票
    CARRIAGE_JUSHAN_ID = 4322, -- 橘山车票
    GAME_DATA_MAIN_INDEX_ID = 4288, -- 主线剧情序号
    GAME_DATA_MAIN_PROGRESS_ID = 4289, -- 主线剧情进度数据
    GAME_DATA_LEVEL_ID = 4290, -- 人物等级数据
    GAME_DATA_EXP_ID = 4291, -- 人物经验数据
    PROTECT_GEM_ID = 4294, -- 守护宝石
    ANIMAL_BONE_ID = 4295, -- 兽骨
    MUSIC_PLAYER_ID = 4297, -- 音乐播放器
    CHEST_GAO_ID = 4302, -- 高小虎给的宝箱
    GAME_DATA_TALK_WITH_GAO_ID = 4303, -- 与高小虎交谈的数据
    GAME_DATA_GET_WEAPON_ID = 4304, -- 领取新生武器的数据
    GAME_DATA_JIANGHUO_EXP_ID = 4308, -- 江火的经验的数据
    LETTER_JIANGHUO_ID = 4307, -- 江火的信

    GREEN_WEAPON_BOX_ID = 4275, -- 绿品武器匣
    BLUE_WEAPON_BOX_ID = 4276, -- 蓝品武器匣
    PURPLE_WEAPON_BOX_ID = 4277, -- 紫品武器匣

    FASTER_RUN_PILL1_ID = 4310, -- 速行丸
    FASTER_RUN_PILL2_ID = 4311, -- 疾行丸
    FASTER_RUN_PILL3_ID = 4312, -- 神行丸
    SAVE_GAME_ID = 4313, -- 保存游戏道具物品
    LOAD_GAME_ID = 4314, -- 加载进度道具物品
    EGG1_ID = 4316, -- 落叶村生物蛋
    EGG2_ID = 4317, -- 风颖城生物蛋甲
    EGG3_ID = 4318, -- 风颖城生物蛋乙

    ARROW_ID = 4130, -- 箭矢ID
    QUIVER_ID = 4133, -- 箭袋ID
    COMMON_PROJECTILE_ID = 4159, -- 通用投掷物ID

    YANGWANLI_EGG_ID = 4097, -- 杨万里生物蛋ID
    WANGDALI_EGG_ID = 4098, -- 王大力生物蛋ID
    MIAOLAN_EGG_ID = 4099, -- 苗兰生物蛋ID
    HUAXIAOLOU_EGG_ID = 4103, -- 花小楼生物蛋ID
    JIANGFENG_EGG_ID = 4104, -- 江枫生物蛋ID
    JIANGYU_EGG_ID = 4107, -- 江渔生物蛋ID
    WENYU_EGG_ID = 4100, -- 文羽生物蛋ID
    LUDAOFENG_EGG_ID = 4113, -- 陆道风生物蛋ID
    QIANBINGWEI_EGG_ID = 4114, -- 千兵卫生物蛋ID
    YEXIAOLONG_EGG_ID = 4108, -- 叶小龙生物蛋ID
    GAOXIAOHU_EGG_ID = 4300, -- 高小虎生物蛋ID
    JIANGHUO_EGG_ID = 4306, -- 江火生物蛋ID
    YUEWUSHUANG_EGG_ID = 4305, -- 月无双生物蛋ID
    SUNKONGWU_EGG_ID = 4271, -- 孙孔武生物蛋ID
    LIMIAOSHOU_EGG_ID = 4272, -- 李妙手生物蛋ID
    MURONGXIAOTIAN_EGG_ID = 4299, -- 慕容笑天生物蛋ID
    QIANDUO_EGG_ID = 4274, -- 钱多生物蛋ID
    DANIU_EGG_ID = 4258, -- 大牛生物蛋ID
    ERNIU_EGG_ID = 4284, -- 二牛生物蛋ID

    MISSION_KANSHU = 4323, -- 砍树（采集落叶松木）任务书
    MISSION_XIAOMIEYEGOU = 4324, -- 消灭野狗任务书
    MISSION_SHOUJISHOUGU = 4325, -- 收集兽骨任务书
    MISSION_CAIJITONGKUANGSHI = 4326, -- 采集铜矿石任务书
    MISSION_XIAOMIEELANG = 4327, -- 消灭恶狼任务书
    MISSION_XIAOMIEQIANGDAO = 4328, -- 消灭强盗任务书
    MISSION_JIBAIPANJUN = 4329, -- 击败叛军任务书
    MISSION_SONGXIN = 4330, -- 送信任务书
  },
  ACTOR = {
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
    DANIU_ACTOR_ID = 18, -- 大牛
    ERNIU_ACTOR_ID = 40, -- 二牛
    SUNKONGWU_ACTOR_ID = 31, -- 孙孔武
    LIMIAOSHOU_ACTOR_ID = 32, -- 李妙手
    QIANDUO_ACTOR_ID = 33, -- 钱多
    MURONGXIAOTIAN_ACTOR_ID = 44, -- 慕容笑天
    GAOXIAOHU_ACTOR_ID = 45, -- 高小虎
    YUEWUSHUANG_ACTOR_ID = 47, -- 月无双
    JIANGHUO_ACTOR_ID = 48, -- 江火

    -- 怪物ID
    WOLF_ACTOR_ID = 11, -- 恶狼ID
    QIANGDAO_LOULUO_ACTOR_ID = 8, -- 强盗喽啰ID
    QIANGDAO_XIAOTOUMU_ACTOR_ID = 12, -- 强盗小头目ID
    GUARD_ACTOR_ID = 15, -- 卫兵（剑）
    OX_ACTOR_ID = 17, -- 狂牛
    DOG_ACTOR_ID = 43, -- 野狗
    QIANGDAO_DATOUMU_ACTOR_ID = 46, -- 强盗大头目
    PANTAOJIANSHIBING_ACTOR_ID = 51, -- 叛逃士兵（剑）
    PANTAOGONGSHIBING_ACTOR_ID = 52, -- 叛逃士兵（弓）

    -- boss
    JUYIDAO_ACTOR_ID = 42, -- 橘一刀
  },
  BUFF = {
    PROTECT_ID = 50000001, -- 守护状态
    SEAL_ID = 50000002, -- 封魔状态
    IMPRISON_ID = 50000003, -- 慑魂状态
    FREEZE1 = 50000004, -- 冰冻1级
    FREEZE2 = 50000005, -- 冰冻2级
    FREEZE3 = 50000006, -- 冰冻3级
    FREEZE4 = 50000007, -- 冰冻4级
    FIRE1 = 50000008, -- 着火1级
    FIRE2 = 50000009, -- 着火2级
    FIRE3 = 50000010, -- 着火3级
    FIRE4 = 50000011, -- 着火4级
    SOUL1 = 50000012, -- 噬魂1级
    SOUL2 = 50000013, -- 噬魂2级
    SOUL3 = 50000014, -- 噬魂3级
    SOUL4 = 50000015, -- 噬魂4级
  },
  CUSTOM = {
    INIT_HOUR = 7, -- 初始时间
    PROJECTILE_HURT = 6, -- 通用投掷物固定伤害
  },
  UI = {
    SCREEN = '6987379653541324323', -- 界面

    TASK_BTN = '6987379653541324323_11', -- 任务按钮
    TASK_PANNEL = '6987379653541324323_3', -- 任务面板
    TASK_BTN1 = '6987379653541324323_15', -- 任务按钮1
    TASK_TXT1 = '6987379653541324323_16', -- 任务文字1
    TASK_BTN2 = '6987379653541324323_19', -- 任务按钮2
    TASK_TXT2 = '6987379653541324323_20', -- 任务文字2
    TASK_BTN3 = '6987379653541324323_21', -- 任务按钮3
    TASK_TXT3 = '6987379653541324323_22', -- 任务文字3
    TASK_BTN4 = '6987379653541324323_23', -- 任务按钮4
    TASK_TXT4 = '6987379653541324323_24', -- 任务文字4
    TASK_BTN5 = '6987379653541324323_27', -- 任务按钮5

    CENTER_PANEL = '6987379653541324323_13', -- 中心文字板
    CENTER_TXT = '6987379653541324323_14', -- 中心文字

    TALK_BTN = '6987379653541324323_36', -- 对话按钮

    HELP_BTN = '6987379653541324323_37', -- 帮助按钮
    HELP_PANNEL = '6987379653541324323_39', -- 帮助面板
  }
}

-- 模板
MyTemplate = {
  GAIN_EXP_MSG = '你获得{exp}点经验', -- exp（获得经验）
  GAIN_DEFEATED_EXP_MSG = '历经生死，你获得{exp}点经验', -- exp（获得经验）
  UPGRADE_MSG = '你升级了', -- exp（获得经验）、level（玩家等级）
  -- UNUPGRADE_MSG = '当前为{level}级。还差{needExp}点经验升级' -- level（玩家等级）、needExp（升级还需要的经验）
  TEAM_MSG = '当前红队有{1}人，蓝队有{2}人，准备玩家有{0}人', -- 0（无队伍人数）、1（红队人数）、2（蓝队人数）
}

-- 武器属性
MyWeaponAttr = {
  -- 剑
  woodSword = { -- 木剑
    meleeAttack = 10,
    meleeDefense = 5,
    remoteDefense = 5,
    addAttPerLevel = 1,
    addDefPerLevel = 2
  },
  bronzeSword = { -- 青铜剑
    meleeAttack = 22,
    meleeDefense = 5,
    remoteDefense = 5,
    addAttPerLevel = 3,
    addDefPerLevel = 2
  },
  stabTigerSword = { -- 刺虎剑
    meleeAttack = 35,
    meleeDefense = 10,
    remoteDefense = 10,
    addAttPerLevel = 4,
    addDefPerLevel = 4
  },
  drinkBloodSword = { -- 饮血剑
    meleeAttack = 14,
    meleeDefense = 5,
    remoteDefense = 5,
    hp = 5,
    addAttPerLevel = 3,
    addDefPerLevel = 2,
    addHpPerLevel = 2
  },
  strongAttackSword = { -- 闪袭剑
    meleeAttack = 20,
    meleeDefense = 3,
    remoteDefense = 3,
    distance = 1,
    multiple = 2,
    cd = 15,
    cdReason = '闪袭技能冷却中',
    skillname = '闪袭',
    addAttPerLevel = 4,
    addDefPerLevel = 4,
    addDistancePerLevel = 2,
    addMultiplePerLevel = 1
  },
  chaseWindSword = { -- 追风剑
    meleeAttack = 30,
    meleeDefense = 10,
    remoteDefense = 10,
    flyTime = 2,
    damage = 5,
    cd = 15,
    cdReason = '追风技能冷却中',
    skillname = '追风',
    addAttPerLevel = 8,
    addDefPerLevel = 8,
    addFlyTimePerLevel = 1,
    addDamagePerLevel = 1
  },

  -- 刀
  woodKnife = { -- 木刀
    meleeAttack = 13,
    meleeDefense = 2,
    remoteDefense = 2,
    addAttPerLevel = 2,
    addDefPerLevel = 1
  },
  bronzeKnife = { -- 青铜刀
    meleeAttack = 27,
    meleeDefense = 2,
    remoteDefense = 2,
    addAttPerLevel = 4,
    addDefPerLevel = 1
  },
  cutDeerKnife = { -- 割鹿刀
    meleeAttack = 41,
    meleeDefense = 5,
    remoteDefense = 5,
    addAttPerLevel = 6,
    addDefPerLevel = 2
  },
  congealFrostKnife = { -- 凝霜刀
    meleeAttack = 17,
    meleeDefense = 2,
    remoteDefense = 2,
    addAttPerLevel = 4,
    addDefPerLevel = 1
  },
  rejuvenationKnife = { -- 回春刀
    meleeAttack = 25,
    meleeDefense = 5,
    remoteDefense = 5,
    skillTime = 5,
    cd = 15,
    cdReason = '回春技能冷却中',
    skillname = '回春',
    addAttPerLevel = 6,
    addDefPerLevel = 2,
    addSkillTimePerLevel = 2
  },
  sealDemonKnife = { -- 封魔刀
    meleeAttack = 35,
    meleeDefense = 5,
    remoteDefense = 5,
    skillRange = 3,
    skillTime = 5,
    cd = 15,
    cdReason = '封魔技能冷却中',
    skillname = '封魔',
    addAttPerLevel = 10,
    addDefPerLevel = 6,
    addSkillRangePerLevel = 1,
    addSkillTimePerLevel = 2
  },

  -- 枪
  woodSpear = { -- 木枪
    meleeAttack = 17,
    strength = 30,
    addAttPerLevel = 3,
    addDefPerLevel = 0
  },
  bronzeSpear = { -- 青铜枪
    meleeAttack = 33,
    strength = 40,
    addAttPerLevel = 5,
    addDefPerLevel = 0
  },
  controlDragonSpear = { -- 御龙枪
    meleeAttack = 51,
    strength = 50,
    addAttPerLevel = 8,
    addDefPerLevel = 0
  },
  fireTipSpear = { -- 火尖枪
    meleeAttack = 19,
    strength = 40,
    addAttPerLevel = 5,
    addDefPerLevel = 0
  },
  overlordSpear = { -- 霸王枪
    meleeAttack = 36,
    strength = 50,
    coverHp = 0.2,
    skillRange = 3,
    cd = 15,
    cdReason = '霸王技能冷却中',
    skillname = '霸王',
    addAttPerLevel = 8,
    addDefPerLevel = 0,
    addCoverHpPerLevel = 0.1,
    addSkillRangePerLevel = 1
  },
  shockSoulSpear = { -- 慑魂枪
    meleeAttack = 55,
    strength = 100,
    skillRange = 2,
    skillTime = 1,
    cd = 15,
    cdReason = '慑魂技能冷却中',
    skillname = '慑魂',
    addAttPerLevel = 16,
    addDefPerLevel = 0,
    addSkillRangePerLevel = 1,
    addSkillTimePerLevel = 1
  },

  -- 弓
  woodBow = { -- 木弓
    meleeAttack = 5,
    remoteAttack = 15,
    addAttPerLevel = 3,
    addDefPerLevel = 0
  },
  bronzeBow = { -- 青铜弓
    meleeAttack = 10,
    remoteAttack = 32,
    addAttPerLevel = 5,
    addDefPerLevel = 0
  },
  shootEagleBow = { -- 射雕弓
    meleeAttack = 15,
    remoteAttack = 47,
    addAttPerLevel = 8,
    addDefPerLevel = 0
  },
  swallowSoulBow = { -- 噬魂弓
    meleeAttack = 5,
    remoteAttack = 17,
    addAttPerLevel = 5,
    addDefPerLevel = 0
  },
  fallStarBow = { -- 坠星弓
    meleeAttack = 12,
    remoteAttack = 35,
    skillRange = 8,
    cd = 15,
    cdReason = '坠星技能冷却中',
    skillname = '坠星',
    addAttPerLevel = 8,
    addDefPerLevel = 0,
    addSkillRangePerLevel = 1
  },
  oneByOneBow = { -- 连珠弓
    meleeAttack = 15,
    remoteAttack = 47,
    arrowNum = 3,
    cd = 15,
    cdReason = '连珠技能冷却中',
    skillname = '连珠',
    addAttPerLevel = 16,
    addDefPerLevel = 0,
    addArrowNumPerLevel = 2
  }
}

-- 武器id
MyWeaponAttr.woodSword.levelIds = { 4129, 4179, 4210, 4227 } -- 木剑
MyWeaponAttr.bronzeSword.levelIds = { 4136, 4182, 4207, 4228 } -- 青铜剑
MyWeaponAttr.stabTigerSword.levelIds = { 4144, 4187, 4209, 4235 } -- 刺虎剑
MyWeaponAttr.drinkBloodSword.levelIds = { 4147, 4190, 4213, 4236 } -- 饮血剑
MyWeaponAttr.strongAttackSword.levelIds = { 4162, 4192, 4219, 4240 } -- 闪袭剑
MyWeaponAttr.chaseWindSword.levelIds = { 4165, 4196, 4223, 4244 } -- 追风剑
MyWeaponAttr.chaseWindSword.projectileid = 4168 -- 风行的追风剑
MyWeaponAttr.woodKnife.levelIds = { 4132, 4178, 4200, 4224 } -- 木刀
MyWeaponAttr.bronzeKnife.levelIds = { 4138, 4180, 4204, 4230 } -- 青铜刀
MyWeaponAttr.cutDeerKnife.levelIds = { 4145, 4186, 4208, 4233 } -- 割鹿刀
MyWeaponAttr.congealFrostKnife.levelIds = { 4148, 4188, 4212, 4238 } -- 凝霜刀
MyWeaponAttr.rejuvenationKnife.levelIds = { 4163, 4194, 4218, 4241 } -- 回春刀
MyWeaponAttr.sealDemonKnife.levelIds = { 4166, 4198, 4220, 4247 } -- 封魔刀
MyWeaponAttr.woodSpear.levelIds = { 4131, 4177, 4203, 4226 } -- 木枪
MyWeaponAttr.bronzeSpear.levelIds = { 4137, 4183, 4205, 4229 } -- 青铜枪
MyWeaponAttr.controlDragonSpear.levelIds = { 4146, 4185, 4211, 4232 } -- 御龙枪
MyWeaponAttr.fireTipSpear.levelIds = { 4149, 4189, 4215, 4239 } -- 火尖枪
MyWeaponAttr.overlordSpear.levelIds = { 4164, 4195, 4217, 4243 } -- 霸王枪
MyWeaponAttr.shockSoulSpear.levelIds = { 4167, 4199, 4222, 4246 } -- 慑魂枪
MyWeaponAttr.woodBow.levelIds = { 4170, 4176, 4202, 4225 } -- 木弓
MyWeaponAttr.bronzeBow.levelIds = { 4171, 4181, 4206, 4231 } -- 青铜弓
MyWeaponAttr.shootEagleBow.levelIds = { 4172, 4184, 4210, 4234 } -- 射雕弓
MyWeaponAttr.swallowSoulBow.levelIds = { 4173, 4191, 4214, 4237 } -- 噬魂弓
MyWeaponAttr.fallStarBow.levelIds = { 4174, 4193, 4216, 4242 } -- 坠星弓
MyWeaponAttr.oneByOneBow.levelIds = { 4175, 4197, 4221, 4245 } -- 连珠弓
