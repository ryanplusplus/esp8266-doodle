return function(display)
  display:setFont(u8g.font_6x10)
  display:setFontRefHeightExtendedText()
  display:setDefaultForegroundColor()
  display:setFontPosTop()

  local draw = function(f)
    local co = coroutine.running()
    display:firstPage()

    while true do
      f(display)

      if display:nextPage() then
        node.task.post(function() coroutine.resume(co) end)
        coroutine.yield()
      else
        break
      end
    end
  end

  return {
    draw = draw
  }
end
