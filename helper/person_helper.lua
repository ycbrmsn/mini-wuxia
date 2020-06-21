-- 人物工具类
PersonHelper = {}

-- 初始化人物
function PersonHelper:init ()
  wenyu = Wenyu:new()
  jiangfeng = Jiangfeng:new()
  jiangyu = Jiangyu:new()
  wangdali = Wangdali:new()
  miaolan = Miaolan:new()
  yangwanli = Yangwanli:new()
  huaxiaolou = Huaxiaolou:new()
  yexiaolong = Yexiaolong:new()

  daniu = Daniu:new()
  erniu = Erniu:new()
  qianbingwei = Qianbingwei:new()
  ludaofeng = Ludaofeng:new()
  sunkongwu = Sunkongwu:new()
  local myActors = { jiangfeng, jiangyu, wangdali, miaolan, wenyu, yangwanli, huaxiaolou, yexiaolong, daniu, erniu, qianbingwei, ludaofeng, sunkongwu }
  for i, v in ipairs(myActors) do
    MyTimeHelper:initActor(v)
    -- LogHelper:debug('创建', v:getName(), '完成')
  end
  guard = Guard:new()
  guard:init()
  LogHelper:debug('创建人物完成')
end