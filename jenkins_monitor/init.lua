coroutine.resume(coroutine.create(function()
  local display = dofile('pcd8544.lc')
  -- local display = dofile('ssd1406.lc')

  display:setFont(u8g.font_chikita)
  display:setFontRefHeightExtendedText()
  display:setDefaultForegroundColor()
  display:setFontPosTop()

  local function draw(f)
    local co = coroutine.running()
    display:firstPage()

    while true do
      f()

      if display:nextPage() then
        node.task.post(function() coroutine.resume(co) end)
        coroutine.yield()
      else
        break
      end
    end
  end

  draw(function()
    display:drawStr(0, 0, 'Something')
    display:drawStr(0, 25, 'Another something')
  end)

  local json_decoder = sjson.decoder({ metatable = {
    checkpath = function(_, path)
      print(unpack(path))
    end
  } })

  local got_header
  local socket = tls.createConnection()
  socket:on('receive', function(_, data)
    if not got_header then
      local data = data:match('\r\n\r\n(.*)')
      if data then
        got_header = true
        json_decoder:write(data)
      end
    else
      json_decoder:write(data)
    end
  end)
  socket:on('connection', function()
    socket:send('GET /computer/api/json HTTP/1.1\r\nHost: ci.openquake.org\r\nAccept: */*\r\n\r\n')
  end)
  socket:connect(443, 'ci.openquake.org')
end))
