-- 武器

-- 剑

-- 木剑
WoodSword = MyWeapon:new(MyWeaponAttr.woodSword)
woodSword0 = WoodSword:newLevel(4129, 0)
-- woodSword1 = WoodSword:newLevel(-1, 1)
-- woodSword2 = WoodSword:newLevel(-1, 2)
-- woodSword3 = WoodSword:newLevel(-1, 3)
-- woodSword4 = WoodSword:newLevel(-1, 4)
-- woodSword5 = WoodSword:newLevel(-1, 5)
-- woodSword6 = WoodSword:newLevel(-1, 6)
-- woodSword7 = WoodSword:newLevel(-1, 7)
-- woodSword8 = WoodSword:newLevel(-1, 8)
-- woodSword9 = WoodSword:newLevel(-1, 9)

-- 青铜剑
BronzeSword = MyWeapon:new(MyWeaponAttr.bronzeSword)
bronzeSword0 = BronzeSword:newLevel(4136, 0)
-- bronzeSword1 = BronzeSword:newLevel(-1, 1)
-- bronzeSword2 = BronzeSword:newLevel(-1, 2)
-- bronzeSword3 = BronzeSword:newLevel(-1, 3)
-- bronzeSword4 = BronzeSword:newLevel(-1, 4)
-- bronzeSword5 = BronzeSword:newLevel(-1, 5)
-- bronzeSword6 = BronzeSword:newLevel(-1, 6)
-- bronzeSword7 = BronzeSword:newLevel(-1, 7)
-- bronzeSword8 = BronzeSword:newLevel(-1, 8)
-- bronzeSword9 = BronzeSword:newLevel(-1, 9)

-- 刺虎剑
StabTigerSword = MyWeapon:new(MyWeaponAttr.stabTigerSword)
stabTigerSword0 = StabTigerSword:newLevel(4144, 0)
-- stabTigerSword1 = StabTigerSword:newLevel(-1, 1)
-- stabTigerSword2 = StabTigerSword:newLevel(-1, 2)
-- stabTigerSword3 = StabTigerSword:newLevel(-1, 3)
-- stabTigerSword4 = StabTigerSword:newLevel(-1, 4)
-- stabTigerSword5 = StabTigerSword:newLevel(-1, 5)
-- stabTigerSword6 = StabTigerSword:newLevel(-1, 6)
-- stabTigerSword7 = StabTigerSword:newLevel(-1, 7)
-- stabTigerSword8 = StabTigerSword:newLevel(-1, 8)
-- stabTigerSword9 = StabTigerSword:newLevel(-1, 9)

-- 饮血剑
DrinkBloodSword = MyWeapon:new(MyWeaponAttr.drinkBloodSword)
drinkBloodSword0 = DrinkBloodSword:newLevel(4147, 0)
-- drinkBloodSword1 = DrinkBloodSword:newLevel(-1, 1)
-- drinkBloodSword2 = DrinkBloodSword:newLevel(-1, 2)
-- drinkBloodSword3 = DrinkBloodSword:newLevel(-1, 3)
-- drinkBloodSword4 = DrinkBloodSword:newLevel(-1, 4)
-- drinkBloodSword5 = DrinkBloodSword:newLevel(-1, 5)
-- drinkBloodSword6 = DrinkBloodSword:newLevel(-1, 6)
-- drinkBloodSword7 = DrinkBloodSword:newLevel(-1, 7)
-- drinkBloodSword8 = DrinkBloodSword:newLevel(-1, 8)
-- drinkBloodSword9 = DrinkBloodSword:newLevel(-1, 9)

-- 奔袭剑
StrongAttackSword = MyWeapon:new(MyWeaponAttr.strongAttackSword)

function StrongAttackSword:useItem (objid)
  local player = MyPlayerHelper:getPlayer(objid)
  local playerPos = player:getMyPosition()
  -- 循环以距离玩家正面1米递增的间隔点开始，作为中心点，扩大1格，查找生物
  for i = 1, self.level + 1 do
    local pos = MathHelper:getDistancePosition(player:getMyPosition(), player:getFaceYaw(), i)
    local areaid = AreaHelper:createNineCubicArea(pos)
    local objids = AreaHelper:getAllCreaturesInAreaId(areaid)
    if (objids and #objids > 0) then -- 发现生物，则找到最近的生物
      local tempDistance, targetObjid
      for ii, vv in ipairs(objids) do
        local distance = WorldHelper:calcDistance(playerPos, MyActorHelper:getMyPosition(vv))
        if (not(tempDistance) or distance < tempDistance) then
          tempDistance = distance
          targetObjid = vv
        end
      end
      if (targetObjid) then -- 发现目标
        player:setDistancePosition(targetObjid, -1)
        player.action:playAttack()
        local targetPos = MyActorHelper:getMyPosition(targetObjid)
        local itemid = -1
        local dirVector3 = MyVector3:new(playerPos, targetPos)
        local projectileid = WorldHelper:spawnProjectileByDirPos(player.objid, itemid, targetPos, dirVector3)
        MyItemHelper:recordProjectile(projectileid, objid, self, self.attack * 2 - MyConstant.PROJECTILE_HURT) -- 记录伤害
        break
      end
    end
  end

end

strongAttackSword0 = StrongAttackSword:newLevel(4151, 0)
-- strongAttackSword1 = StrongAttackSword:newLevel(-1, 1)
-- strongAttackSword2 = StrongAttackSword:newLevel(-1, 2)
-- strongAttackSword3 = StrongAttackSword:newLevel(-1, 3)
-- strongAttackSword4 = StrongAttackSword:newLevel(-1, 4)
-- strongAttackSword5 = StrongAttackSword:newLevel(-1, 5)
-- strongAttackSword6 = StrongAttackSword:newLevel(-1, 6)
-- strongAttackSword7 = StrongAttackSword:newLevel(-1, 7)
-- strongAttackSword8 = StrongAttackSword:newLevel(-1, 8)
-- strongAttackSword9 = StrongAttackSword:newLevel(-1, 9)


-- 追风剑
ChaseWindSword = MyWeapon:new(MyWeaponAttr.chaseWindSword)

function ChaseWindSword:useItem (objid)
  -- body
end

chaseWindSword0 = ChaseWindSword:newLevel(4155, 0)
-- chaseWindSword1 = ChaseWindSword:newLevel(-1, 1)
-- chaseWindSword2 = ChaseWindSword:newLevel(-1, 2)
-- chaseWindSword3 = ChaseWindSword:newLevel(-1, 3)
-- chaseWindSword4 = ChaseWindSword:newLevel(-1, 4)
-- chaseWindSword5 = ChaseWindSword:newLevel(-1, 5)
-- chaseWindSword6 = ChaseWindSword:newLevel(-1, 6)
-- chaseWindSword7 = ChaseWindSword:newLevel(-1, 7)
-- chaseWindSword8 = ChaseWindSword:newLevel(-1, 8)
-- chaseWindSword9 = ChaseWindSword:newLevel(-1, 9)

-- 刀

-- 木刀
WoodKnife = MyWeapon:new(MyWeaponAttr.woodKnife)
woodKnife0 = WoodKnife:newLevel(4132, 0)
-- woodKnife1 = WoodKnife:newLevel(-1, 1)
-- woodKnife2 = WoodKnife:newLevel(-1, 2)
-- woodKnife3 = WoodKnife:newLevel(-1, 3)
-- woodKnife4 = WoodKnife:newLevel(-1, 4)
-- woodKnife5 = WoodKnife:newLevel(-1, 5)
-- woodKnife6 = WoodKnife:newLevel(-1, 6)
-- woodKnife7 = WoodKnife:newLevel(-1, 7)
-- woodKnife8 = WoodKnife:newLevel(-1, 8)
-- woodKnife9 = WoodKnife:newLevel(-1, 9)

-- 青铜刀
BronzeKnife = MyWeapon:new(MyWeaponAttr.bronzeKnife)
bronzeKnife0 = BronzeKnife:newLevel(4138, 0)
-- bronzeKnife1 = BronzeKnife:newLevel(-1, 1)
-- bronzeKnife2 = BronzeKnife:newLevel(-1, 2)
-- bronzeKnife3 = BronzeKnife:newLevel(-1, 3)
-- bronzeKnife4 = BronzeKnife:newLevel(-1, 4)
-- bronzeKnife5 = BronzeKnife:newLevel(-1, 5)
-- bronzeKnife6 = BronzeKnife:newLevel(-1, 6)
-- bronzeKnife7 = BronzeKnife:newLevel(-1, 7)
-- bronzeKnife8 = BronzeKnife:newLevel(-1, 8)
-- bronzeKnife9 = BronzeKnife:newLevel(-1, 9)

-- 割鹿刀
CutDeerKnife = MyWeapon:new(MyWeaponAttr.cutDeerKnife)
cutDeerKnife0 = CutDeerKnife:newLevel(4145, 0)
-- cutDeerKnife1 = CutDeerKnife:newLevel(-1, 1)
-- cutDeerKnife2 = CutDeerKnife:newLevel(-1, 2)
-- cutDeerKnife3 = CutDeerKnife:newLevel(-1, 3)
-- cutDeerKnife4 = CutDeerKnife:newLevel(-1, 4)
-- cutDeerKnife5 = CutDeerKnife:newLevel(-1, 5)
-- cutDeerKnife6 = CutDeerKnife:newLevel(-1, 6)
-- cutDeerKnife7 = CutDeerKnife:newLevel(-1, 7)
-- cutDeerKnife8 = CutDeerKnife:newLevel(-1, 8)
-- cutDeerKnife9 = CutDeerKnife:newLevel(-1, 9)

-- 凝霜刀
CongealFrostKnife = MyWeapon:new(MyWeaponAttr.congealFrostKnife)
congealFrostKnife0 = CongealFrostKnife:newLevel(4148, 0)
-- congealFrostKnife1 = CongealFrostKnife:newLevel(-1, 1)
-- congealFrostKnife2 = CongealFrostKnife:newLevel(-1, 2)
-- congealFrostKnife3 = CongealFrostKnife:newLevel(-1, 3)
-- congealFrostKnife4 = CongealFrostKnife:newLevel(-1, 4)
-- congealFrostKnife5 = CongealFrostKnife:newLevel(-1, 5)
-- congealFrostKnife6 = CongealFrostKnife:newLevel(-1, 6)
-- congealFrostKnife7 = CongealFrostKnife:newLevel(-1, 7)
-- congealFrostKnife8 = CongealFrostKnife:newLevel(-1, 8)
-- congealFrostKnife9 = CongealFrostKnife:newLevel(-1, 9)

-- 回春刀
RejuvenationKnife = MyWeapon:new(MyWeaponAttr.rejuvenationKnife)

function RejuvenationKnife:useItem (objid)
  -- body
end

rejuvenationKnife0 = RejuvenationKnife:newLevel(4152, 0)
-- rejuvenationKnife1 = RejuvenationKnife:newLevel(-1, 1)
-- rejuvenationKnife2 = RejuvenationKnife:newLevel(-1, 2)
-- rejuvenationKnife3 = RejuvenationKnife:newLevel(-1, 3)
-- rejuvenationKnife4 = RejuvenationKnife:newLevel(-1, 4)
-- rejuvenationKnife5 = RejuvenationKnife:newLevel(-1, 5)
-- rejuvenationKnife6 = RejuvenationKnife:newLevel(-1, 6)
-- rejuvenationKnife7 = RejuvenationKnife:newLevel(-1, 7)
-- rejuvenationKnife8 = RejuvenationKnife:newLevel(-1, 8)
-- rejuvenationKnife9 = RejuvenationKnife:newLevel(-1, 9)

-- 封魔刀
SealDemonKnife = MyWeapon:new(MyWeaponAttr.sealDemonKnife)

function SealDemonKnife:useItem (objid)
  -- body
end

sealDemonKnife0 = SealDemonKnife:newLevel(4156, 0)
-- sealDemonKnife1 = SealDemonKnife:newLevel(-1, 1)
-- sealDemonKnife2 = SealDemonKnife:newLevel(-1, 2)
-- sealDemonKnife3 = SealDemonKnife:newLevel(-1, 3)
-- sealDemonKnife4 = SealDemonKnife:newLevel(-1, 4)
-- sealDemonKnife5 = SealDemonKnife:newLevel(-1, 5)
-- sealDemonKnife6 = SealDemonKnife:newLevel(-1, 6)
-- sealDemonKnife7 = SealDemonKnife:newLevel(-1, 7)
-- sealDemonKnife8 = SealDemonKnife:newLevel(-1, 8)
-- sealDemonKnife9 = SealDemonKnife:newLevel(-1, 9)

-- 枪

-- 木枪
WoodSpear = MyWeapon:new(MyWeaponAttr.woodSpear)
woodSpear0 = WoodSpear:newLevel(4131, 0)
-- woodSpear1 = WoodSpear:newLevel(-1, 1)
-- woodSpear2 = WoodSpear:newLevel(-1, 2)
-- woodSpear3 = WoodSpear:newLevel(-1, 3)
-- woodSpear4 = WoodSpear:newLevel(-1, 4)
-- woodSpear5 = WoodSpear:newLevel(-1, 5)
-- woodSpear6 = WoodSpear:newLevel(-1, 6)
-- woodSpear7 = WoodSpear:newLevel(-1, 7)
-- woodSpear8 = WoodSpear:newLevel(-1, 8)
-- woodSpear9 = WoodSpear:newLevel(-1, 9)

-- 青铜枪
BronzeSpear = MyWeapon:new(MyWeaponAttr.bronzeSpear)
bronzeSpear0 = BronzeSpear:newLevel(4137, 0)
-- bronzeSpear1 = BronzeSpear:newLevel(-1, 1)
-- bronzeSpear2 = BronzeSpear:newLevel(-1, 2)
-- bronzeSpear3 = BronzeSpear:newLevel(-1, 3)
-- bronzeSpear4 = BronzeSpear:newLevel(-1, 4)
-- bronzeSpear5 = BronzeSpear:newLevel(-1, 5)
-- bronzeSpear6 = BronzeSpear:newLevel(-1, 6)
-- bronzeSpear7 = BronzeSpear:newLevel(-1, 7)
-- bronzeSpear8 = BronzeSpear:newLevel(-1, 8)
-- bronzeSpear9 = BronzeSpear:newLevel(-1, 9)

-- 御龙枪
ControlDragonSpear = MyWeapon:new(MyWeaponAttr.controlDragonSpear)
controlDragonSpear0 = ControlDragonSpear:newLevel(4146, 0)
-- controlDragonSpear1 = ControlDragonSpear:newLevel(-1, 1)
-- controlDragonSpear2 = ControlDragonSpear:newLevel(-1, 2)
-- controlDragonSpear3 = ControlDragonSpear:newLevel(-1, 3)
-- controlDragonSpear4 = ControlDragonSpear:newLevel(-1, 4)
-- controlDragonSpear5 = ControlDragonSpear:newLevel(-1, 5)
-- controlDragonSpear6 = ControlDragonSpear:newLevel(-1, 6)
-- controlDragonSpear7 = ControlDragonSpear:newLevel(-1, 7)
-- controlDragonSpear8 = ControlDragonSpear:newLevel(-1, 8)
-- controlDragonSpear9 = ControlDragonSpear:newLevel(-1, 9)

-- 火尖枪
FireTipSpear = MyWeapon:new(MyWeaponAttr.fireTipSpear)
fireTipSpear0 = FireTipSpear:newLevel(4149, 0)
-- fireTipSpear1 = FireTipSpear:newLevel(-1, 1)
-- fireTipSpear2 = FireTipSpear:newLevel(-1, 2)
-- fireTipSpear3 = FireTipSpear:newLevel(-1, 3)
-- fireTipSpear4 = FireTipSpear:newLevel(-1, 4)
-- fireTipSpear5 = FireTipSpear:newLevel(-1, 5)
-- fireTipSpear6 = FireTipSpear:newLevel(-1, 6)
-- fireTipSpear7 = FireTipSpear:newLevel(-1, 7)
-- fireTipSpear8 = FireTipSpear:newLevel(-1, 8)
-- fireTipSpear9 = FireTipSpear:newLevel(-1, 9)

-- 霸王枪
OverlordSpear = MyWeapon:new(MyWeaponAttr.overlordSpear)

function OverlordSpear:useItem (objid)
  -- body
end

overlordSpear0 = OverlordSpear:newLevel(4153, 0)
-- overlordSpear1 = OverlordSpear:newLevel(-1, 1)
-- overlordSpear2 = OverlordSpear:newLevel(-1, 2)
-- overlordSpear3 = OverlordSpear:newLevel(-1, 3)
-- overlordSpear4 = OverlordSpear:newLevel(-1, 4)
-- overlordSpear5 = OverlordSpear:newLevel(-1, 5)
-- overlordSpear6 = OverlordSpear:newLevel(-1, 6)
-- overlordSpear7 = OverlordSpear:newLevel(-1, 7)
-- overlordSpear8 = OverlordSpear:newLevel(-1, 8)
-- overlordSpear9 = OverlordSpear:newLevel(-1, 9)

-- 慑魂枪
ShockSoulSpear = MyWeapon:new(MyWeaponAttr.shockSoulSpear)

function ShockSoulSpear:useItem (objid)
  -- body
end

shockSoulSpear0 = ShockSoulSpear:newLevel(4157, 0)
-- shockSoulSpear1 = ShockSoulSpear:newLevel(-1, 1)
-- shockSoulSpear2 = ShockSoulSpear:newLevel(-1, 2)
-- shockSoulSpear3 = ShockSoulSpear:newLevel(-1, 3)
-- shockSoulSpear4 = ShockSoulSpear:newLevel(-1, 4)
-- shockSoulSpear5 = ShockSoulSpear:newLevel(-1, 5)
-- shockSoulSpear6 = ShockSoulSpear:newLevel(-1, 6)
-- shockSoulSpear7 = ShockSoulSpear:newLevel(-1, 7)
-- shockSoulSpear8 = ShockSoulSpear:newLevel(-1, 8)
-- shockSoulSpear9 = ShockSoulSpear:newLevel(-1, 9)

-- 弓

-- 木弓
WoodBow = MyWeapon:new(MyWeaponAttr.woodBow)
woodBow0 = WoodBow:newLevel(4128, 0)
-- woodBow1 = WoodBow:newLevel(-1, 1)
-- woodBow2 = WoodBow:newLevel(-1, 2)
-- woodBow3 = WoodBow:newLevel(-1, 3)
-- woodBow4 = WoodBow:newLevel(-1, 4)
-- woodBow5 = WoodBow:newLevel(-1, 5)
-- woodBow6 = WoodBow:newLevel(-1, 6)
-- woodBow7 = WoodBow:newLevel(-1, 7)
-- woodBow8 = WoodBow:newLevel(-1, 8)
-- woodBow9 = WoodBow:newLevel(-1, 9)

-- 青铜弓
BronzeBow = MyWeapon:new(MyWeaponAttr.bronzeBow)
bronzeBow0 = BronzeBow:newLevel(4139, 0)
-- bronzeBow1 = BronzeBow:newLevel(-1, 1)
-- bronzeBow2 = BronzeBow:newLevel(-1, 2)
-- bronzeBow3 = BronzeBow:newLevel(-1, 3)
-- bronzeBow4 = BronzeBow:newLevel(-1, 4)
-- bronzeBow5 = BronzeBow:newLevel(-1, 5)
-- bronzeBow6 = BronzeBow:newLevel(-1, 6)
-- bronzeBow7 = BronzeBow:newLevel(-1, 7)
-- bronzeBow8 = BronzeBow:newLevel(-1, 8)
-- bronzeBow9 = BronzeBow:newLevel(-1, 9)

-- 射雕弓
ShootEagleBow = MyWeapon:new(MyWeaponAttr.shootEagleBow)
shootEagleBow0 = ShootEagleBow:newLevel(4143, 0)
-- shootEagleBow1 = ShootEagleBow:newLevel(-1, 1)
-- shootEagleBow2 = ShootEagleBow:newLevel(-1, 2)
-- shootEagleBow3 = ShootEagleBow:newLevel(-1, 3)
-- shootEagleBow4 = ShootEagleBow:newLevel(-1, 4)
-- shootEagleBow5 = ShootEagleBow:newLevel(-1, 5)
-- shootEagleBow6 = ShootEagleBow:newLevel(-1, 6)
-- shootEagleBow7 = ShootEagleBow:newLevel(-1, 7)
-- shootEagleBow8 = ShootEagleBow:newLevel(-1, 8)
-- shootEagleBow9 = ShootEagleBow:newLevel(-1, 9)

-- 噬魂弓
SwallowSoulBow = MyWeapon:new(MyWeaponAttr.swallowSoulBow)
swallowSoulBow0 = SwallowSoulBow:newLevel(4150, 0)
-- swallowSoulBow1 = SwallowSoulBow:newLevel(-1, 1)
-- swallowSoulBow2 = SwallowSoulBow:newLevel(-1, 2)
-- swallowSoulBow3 = SwallowSoulBow:newLevel(-1, 3)
-- swallowSoulBow4 = SwallowSoulBow:newLevel(-1, 4)
-- swallowSoulBow5 = SwallowSoulBow:newLevel(-1, 5)
-- swallowSoulBow6 = SwallowSoulBow:newLevel(-1, 6)
-- swallowSoulBow7 = SwallowSoulBow:newLevel(-1, 7)
-- swallowSoulBow8 = SwallowSoulBow:newLevel(-1, 8)
-- swallowSoulBow9 = SwallowSoulBow:newLevel(-1, 9)

-- 坠星弓
FallStarBow = MyWeapon:new(MyWeaponAttr.fallStarBow)

function FallStarBow:useItem2 (objid)
  -- body
end

fallStarBow0 = FallStarBow:newLevel(4154, 0)
-- fallStarBow1 = FallStarBow:newLevel(-1, 1)
-- fallStarBow2 = FallStarBow:newLevel(-1, 2)
-- fallStarBow3 = FallStarBow:newLevel(-1, 3)
-- fallStarBow4 = FallStarBow:newLevel(-1, 4)
-- fallStarBow5 = FallStarBow:newLevel(-1, 5)
-- fallStarBow6 = FallStarBow:newLevel(-1, 6)
-- fallStarBow7 = FallStarBow:newLevel(-1, 7)
-- fallStarBow8 = FallStarBow:newLevel(-1, 8)
-- fallStarBow9 = FallStarBow:newLevel(-1, 9)

-- 连珠弓
OneByOneBow = MyWeapon:new(MyWeaponAttr.oneByOneBow)

function OneByOneBow:useItem2 (objid)
  -- body
end

oneByOneBow0 = OneByOneBow:newLevel(4158, 0)
-- oneByOneBow1 = OneByOneBow:newLevel(-1, 1)
-- oneByOneBow2 = OneByOneBow:newLevel(-1, 2)
-- oneByOneBow3 = OneByOneBow:newLevel(-1, 3)
-- oneByOneBow4 = OneByOneBow:newLevel(-1, 4)
-- oneByOneBow5 = OneByOneBow:newLevel(-1, 5)
-- oneByOneBow6 = OneByOneBow:newLevel(-1, 6)
-- oneByOneBow7 = OneByOneBow:newLevel(-1, 7)
-- oneByOneBow8 = OneByOneBow:newLevel(-1, 8)
-- oneByOneBow9 = OneByOneBow:newLevel(-1, 9)
