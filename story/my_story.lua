-- 剧情类
MyStory = {
  name = '', -- 剧情名称
  desc = '', -- 剧情描述
  mainIndex = 1, -- 主线剧情进度
  areaid = -99, -- 触发区域
  posBeg = {}, -- 触发区域起点
  posEnd = {} -- 触发区域终点
}

myStories = {
  {
    name = '学院招生通知',
    desc = '文羽前来通知我说风颖城的武术学院开始招生了',
    mainIndex = 1,
    posBeg = { x = 31, y = 8, z = 1 },
    posEnd = { x = 31, y = 9, z = 1 },
    -- createPos = { x = 15, y = 7, z = 3 },
    createPos = { x = 28, y = 7, z = -28 },
    movePos = { x = 31, y = 8, z = 1 }
  }
} -- 存放所有剧情
