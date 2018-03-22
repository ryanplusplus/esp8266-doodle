return function(display, data)
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

  print('Online: ' .. online_count .. ' / ' .. #data)

  display.draw(function(display)
    display:drawStr(0, 0, 'Online: ' .. online_count .. ' / ' .. #data)
    for i, name in ipairs(offline) do
      display:drawStr(0, 5 + 10 * i, name)
    end
  end)
end
