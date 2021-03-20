-- 落叶村对话详情

-- 杨万里
yangwanliTalkInfos = {
  -- 采集落叶松木
  TaskHelper.generateAcceptTalk(KanshuTask.id, {
    { 3, '有什么我能帮忙的吗？' },
    { 1, '村里的房子又需要修葺一下了。' },
    { 1, '我需要一些落叶松木，你可以帮我砍一些回来吗？' },
    { '没问题。', '村长我正忙着呢。' },
  }, KanshuTask),
  TaskHelper.generateQueryTalk(KanshuTask.id, {
    { 3, '村长，我没有找到落叶松木。' },
    { 1, '村子外面就有一片落叶松林。' },
    { 3, '哦，我知道了。' },
  }),
  TaskHelper.generatePayTalk(KanshuTask.id, {
    { 3, '村长我采回来了。' },
    { 1, '真是个好孩子。' },
  }),
  TalkInfo:new({
    id = 1,
    -- ants = {
    --   TalkAnt:includeTask(KanshuTask:getRealid()),
    -- },
    progress = {
      [0] = {
        TalkSession:reply('村子会越来越好的。'):call(function (player, actor)
          local playerTalks = {}
          local talkid, progressid, clearIndex = 1, 0, 2
          TalkHelper.clearProgressContent(actor, talkid, progressid, clearIndex)
          TaskHelper.appendPlayerTalk(playerTalks, player, KanshuTask)
          -- 其他
          table.insert(playerTalks, PlayerTalk:continue('闲聊'))
          TalkHelper.addProgressContent(actor, talkid, progressid, TalkSession:choose(playerTalks))
          TalkHelper.addProgressContent(actor, talkid, progressid, TalkSession:speak('村长说得对。'))
        end),
      },
    }
  }),
}