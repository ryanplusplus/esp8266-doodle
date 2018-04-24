return function(config, on_data)
  local co = coroutine.running()
  local timer = tmr.create()
  local got_header
  local timed_out
  local socket = (config.tls and tls or net).createConnection()

  timer:alarm(7000, tmr.ALARM_SINGLE, function()
    timed_out = true
    socket:close()
    timer:unregister()
    node.task.post(function()
      assert(coroutine.resume(co))
    end)
  end)

  socket:on('receive', function(socket, data)
    if not timed_out then
      if not got_header then
        local data = data:match('\r\n\r\n(.*)')
        if data then
          got_header = true
          on_data(data)
        end
      else
        on_data(data)
      end
    end
  end)

  socket:on('connection', function(socket)
    if not timed_out then
      socket:send('GET ' .. config.resource .. ' HTTP/1.1\r\nConnection: close\r\nHost: ' .. config.host .. '\r\nAccept: */*\r\n\r\n')
    end
  end)

  socket:connect(config.port, config.server)

  coroutine.yield()
end
