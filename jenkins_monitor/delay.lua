return function(msec)
  local co = coroutine.running()
  local timer = tmr.create()
  timer:register(msec, tmr.ALARM_SINGLE, function()
    timer:unregister()
    assert(coroutine.resume(co))
  end)
  timer:start()
  coroutine.yield()
end
