local Display = require 'Display'
local ssd1306 = require 'ssd1306'

return function()
  local display = Display(ssd1306)

  display.draw(function(display)
    display:drawStr(0, 0, 'Hello, world!')
    display:drawStr(15, 15, 'Hello, world!')
  end)
end
