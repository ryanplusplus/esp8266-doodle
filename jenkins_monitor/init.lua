coroutine.resume(coroutine.create(function()
  -- local display = dofile('pcd8544.lc')
  local display = dofile('ssd1306.lc')

  display:setFont(u8g.font_6x10)
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
    display:drawStr(0, 0, 'Gathering data...')
  end)

  local data = {}

  local json_decoder = sjson.decoder({ metatable = {
    checkpath = function(t, path)
      if #path <= 1 then return true end

      if #path == 2 then
        table.insert(data, {})
        local i = #data
        setmetatable(t, {
          __newindex = function(_, k, v)
            if k == 'displayName' or k == 'offline' then
              data[i][k] = v
            end
          end
        })

        return true
      end
    end
  } })

  local got_header
  local socket = net.createConnection()
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
  socket:on('disconnection', function()
    local offline = {}
    local online_count = 0
    for _, computer in ipairs(data) do
      if not computer.offline then online_count = online_count + 1 end
      if computer.offline then
        table.insert(offline, computer.displayName)
      end
    end

    if #offline > 0 then
      gpio.mode(0, gpio.OUTPUT)
      gpio.write(0, 0)
    end

    node.task.post(function()
      coroutine.resume(coroutine.create(function()
        draw(function()
          display:drawStr(0, 0, 'Online: ' .. online_count .. ' / ' .. #data)
          for i, name in ipairs(offline) do
            display:drawStr(0, 5 + 10 * i, name)
          end
        end)
      end))
    end)
  end)
  socket:on('connection', function()
    socket:send('GET https://jenkins.tech.geappl.io/computer/api/json HTTP/1.1\r\nConnection: close\r\nHost: jenkins.tech.geappl.io\r\nAccept: */*\r\n\r\n')
  end)
  socket:connect(8080, 'http-proxy.appl.ge.com')
end))
