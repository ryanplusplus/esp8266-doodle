local display = dofile('pcd8544.lc')
-- local display = dofile('ssd1406.lc')

display:setFont(u8g.font_chikita)
display:setFontRefHeightExtendedText()
display:setDefaultForegroundColor()
display:setFontPosTop()

local function draw(f, on_complete)
  display:firstPage()

  local function draw_page()
    f()

    if display:nextPage() then
      node.task.post(draw_page)
    elseif on_complete then
      on_complete()
    end
  end

  draw_page()
end

draw(function()
  display:drawStr(0, 0, 'Something')
  display:drawStr(0, 25, 'Another something')
end)

local socket = tls.createConnection()
socket:on('receive', function(_, data) print(data) end)
socket:on('connection', function()
  socket:send('GET / HTTP/1.1\r\nHost: www.google.com\r\nAccept: */*\r\n\r\n')
end)
socket:connect(443, 'www.google.com')
