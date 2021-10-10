-- 我的选项工具类
MyOptionHelper = {
  optionMap = {
    sleep = {
      { '不睡觉', function (player)
          player:enableMove(true)
          player:thinks(0, '现在还不想休息。')
          MyOptionHelper.removeClickBedLimit(player) -- 移除点击限制
        end
      },
      { '睡半个时辰', function (player)
          player:enableMove(true)
          MyStoryHelper.addHour(1)
          PlayerHelper.everyPlayerNotify('时间过去半个时辰')
          PlayerHelper.everyPlayerRecoverHp(10)
          MyOptionHelper.removeClickBedLimit(player) -- 移除点击限制
        end
      },
      { '睡一个时辰', function (player)
          player:enableMove(true)
          if MyStoryHelper.addHour(2) then
            PlayerHelper.everyPlayerNotify('时间过去一个时辰')
            PlayerHelper.everyPlayerRecoverHp(20)
            ActorHelper.doItNow()
          else
            PlayerHelper.notifyGameInfo2Self(player.objid, '快到约定的时间了，不能睡那么久了')
          end
          MyOptionHelper.removeClickBedLimit(player) -- 移除点击限制
        end
      },
      { '睡两个时辰', function (player)
          player:enableMove(true)
          if MyStoryHelper.addHour(4) then
            PlayerHelper.everyPlayerNotify('时间过去两个时辰')
            PlayerHelper.everyPlayerRecoverHp(40)
            ActorHelper.doItNow()
          else
            PlayerHelper.notifyGameInfo2Self(player.objid, '快到约定的时间了，不能睡那么久了')
          end
          MyOptionHelper.removeClickBedLimit(player) -- 移除点击限制
        end
      },
    },
    look = {
      { '看看', function (player)
          -- ChatHelper.showChooseItems(playerid, { '游戏简介', '更新内容', '退出' })
          -- player.whichChoose = 'readme1'
          MyOptionHelper.showOptions(player, 'readme')
        end
      },
      { '不看', function (player)
          MyOptionHelper.exitChoose(player)
        end
      }, -- 退出
    },
    readme = {
      { '游戏简介', function (player)
          ChatHelper.sendMsg(player.objid, '\t\t这是一个简单的角色扮演类游戏，有')
          ChatHelper.sendMsg(player.objid, '几个简单的剧情。剧情推进依赖于游戏数')
          ChatHelper.sendMsg(player.objid, '据道具，请勿随意将其移出背包，否则可')
          ChatHelper.sendMsg(player.objid, '能会导致游戏错误。目前剧情还未做完，')
          ChatHelper.sendMsg(player.objid, '正常情况下月更。退出地图后记得备份。')
          MyOptionHelper.showOptions(player, 'back')
        end
      }, -- 游戏简介
      { '更新内容', function (player)
          -- ChatHelper.showChooseItems(playerid, { 'v0.3.4', '返回' })
          -- player.whichChoose = 'readmeUpdate'
          MyOptionHelper.showOptions(player, 'readmeUpdate')
        end
      }, -- 更新内容
      { '退出', function (player)
          MyOptionHelper.exitChoose(player)
        end
      }, -- 退出
    },
    readmeUpdate = {
      { 'v0.3.4', function (player)
          ChatHelper.sendMsg(player.objid, '1.新增叛军营地、橘山。', StringHelper.repeatStrs('\t', 7))
          ChatHelper.sendMsg(player.objid, '2.新增挖城墙事件。', StringHelper.repeatStrs('\t', 9))
          ChatHelper.sendMsg(player.objid, '3.调低了升级后玩家增长的属性。', StringHelper.repeatStrs('\t', 3))
          ChatHelper.sendMsg(player.objid, '4.调高了部分怪物的伤害。', StringHelper.repeatStrs('\t', 6))
          ChatHelper.sendMsg(player.objid, '5.修复车票无法送达的问题。', StringHelper.repeatStrs('\t', 5))
          ChatHelper.sendMsg(player.objid, '6.微调了一些其他东西。', StringHelper.repeatStrs('\t', 7))
          MyOptionHelper.showOptions(player, 'back')
        end
      },
      { 'v0.3.5', function (player)
          ChatHelper.sendMsg(player.objid, '1.新增床睡觉功能。', StringHelper.repeatStrs('\t', 9))
          ChatHelper.sendMsg(player.objid, '2.新增挖城墙事件。', StringHelper.repeatStrs('\t', 9))
          ChatHelper.sendMsg(player.objid, '3.调低了升级后玩家增长的属性。', StringHelper.repeatStrs('\t', 3))
          ChatHelper.sendMsg(player.objid, '4.调高了部分怪物的伤害。', StringHelper.repeatStrs('\t', 6))
          ChatHelper.sendMsg(player.objid, '5.修复车票无法送达的问题。', StringHelper.repeatStrs('\t', 5))
          ChatHelper.sendMsg(player.objid, '6.微调了一些其他东西。', StringHelper.repeatStrs('\t', 7))
          MyOptionHelper.showOptions(player, 'back')
        end
      },
      { '返回', function (player)
          MyOptionHelper.showOptions(player, 'readme')
        end
      }, -- 返回
    },
    back = {
      { '返回', function (player)
          MyOptionHelper.showOptions(player, 'readme')
        end
      },
    },
    breakCity = {
      { '跟他走', function (player)
          player.whichChoose = nil
          local ws = WaitSeconds:new(2)
          player:speakSelf(0, '我愿意跟你走。')
          guard:speakTo(player.objid, ws:use(), '这样最好了。')
          TimeHelper.callFnAfterSecond(function ()
            local pos = MyAreaHelper.getEmptyPrisonPos()
            player:setMyPosition(pos)
            player:enableMove(true)
            WorldHelper.despawnActor(player.chooseMap.objid)
            for i, v in ipairs(player.destroyBlock) do
              BlockHelper.placeBlock(v.blockid, v.x, v.y, v.z)
            end
            player.destroyBlock = {}
          end, ws:get())
        end
      },
      { '不跟他走', function (player)
          player.whichChoose = nil
          local ws = WaitSeconds:new(2)
          player:speakSelf(0, '想让我跟你走，想都别想！')
          guard:speakTo(player.objid, ws:use(1), '那么抱歉了……')
          TimeHelper.callFnAfterSecond(function ()
            MyStoryHelper.beatBreakCityPlayer(player)
          end, ws:get())
        end
      },
    },
  }
}

-- 退出选择
function MyOptionHelper.exitChoose (player)
  player.whichChoose = nil
  player:enableMove(true, true)
  player:thinkSelf(0, '算了，我都知道了。')
  TimeHelper.delFnCanRun(10, player.objid .. 'clickBookcase') -- 解除点击限制
end

-- 显示选项
function MyOptionHelper.showOptions (player, optionname)
  local arr = MyOptionHelper.optionMap[optionname]
  ChatHelper.showChooseItems(player.objid, arr, 1)
  player.whichChoose = optionname
end

-- 设置选项
function MyOptionHelper.setOption (optionname, chooseItems)
  MyOptionHelper.optionMap[optionname] = chooseItems
end

-- 设置任务选项
function MyOptionHelper.setTaskOption (player, tasks)
  local chooseItems = {}
  for taskid, task in ipairs(tasks) do
    table.insert(chooseItems, {
      task.name .. '任务',
      function (player)
        task:show(player.objid)
        MyOptionHelper.showOptions(player, 'back')
      end
    })
  end
  table.insert(chooseItems, {
    '返回',
    function (player)
      MyOptionHelper.showOptions(player, 'index')
    end
  })
  MyOptionHelper.setOption(player.objid .. '', chooseItems)
end

--[[
  移除玩家点击床后短时间内不能再次点击床的限制
  @param    {table} player 玩家
  @author   莫小仙
  @datetime 2021-10-02 22:33:29
]]
function MyOptionHelper.removeClickBedLimit (player)
  TimeHelper.delFnCanRun(10, player.objid .. 'clickBed')
end