return function(display, data)
  local offline = {}
  local online_count = 0
  local total_count = 0
  for _, computer in ipairs(data) do
    if computer.displayName:sub(1, 1) ~= '_' then
      total_count = total_count + 1
      if not computer.offline then online_count = online_count + 1 end
      if computer.offline then
        table.insert(offline, computer.displayName)
      end
    end
  end

  display.draw(function(display)
    display:drawStr(0, 0, 'Online: ' .. online_count .. ' / ' .. total_count)
    for i, name in ipairs(offline) do
      display:drawStr(0, 5 + 10 * i, name)
    end
  end)
end
