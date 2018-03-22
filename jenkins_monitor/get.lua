return function(config, on_data)
  local co = coroutine.running()
  local timer = tmr.create()
  local got_header
  local socket = (config.tls and tls or net).createConnection()
  socket:on('receive', function(_, data)
    timer:register(500, tmr.ALARM_SINGLE, function()
      socket:close()
      timer:unregister()
      node.task.post(function()
        coroutine.resume(co)
      end)
    end)
    timer:start()

    if not got_header then
      local data = data:match('\r\n\r\n(.*)')
      if data then
        got_header = true
        on_data(data)
      end
    else
      on_data(data)
    end
  end)
  socket:on('connection', function()
    socket:send('GET ' .. config.resource .. ' HTTP/1.1\r\nConnection: close\r\nHost: ' .. config.host .. '\r\nAccept: */*\r\n\r\n')
  end)
  socket:connect(config.port, config.server)
  coroutine.yield()
end
