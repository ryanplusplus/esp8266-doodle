local Display = require 'Display'
local get = require 'get'
local show = require 'show'
local delay = require 'delay'

local config = {
  tls = true,
  server = 'ci.openquake.org',
  port = 443,
  host = 'ci.openquake.org',
  resource = 'https://ci.openquake.org/computer/api/json'
}

return function()
  -- local display = Display(require 'ssd1306')
  local display = Display(require 'pcd8544')

  while true do
    local json_parser = require 'JsonParser'()
    collectgarbage()
    print('created parser', collectgarbage('count'))

    get(config, json_parser.feed)
    collectgarbage()
    print('did a get', print(collectgarbage('count')))

    show(display, json_parser.finalize())
    collectgarbage()
    print('showed', print(collectgarbage('count')))

    delay(3 * 1000)
    collectgarbage()
    print('delayed', print(collectgarbage('count')))
  end
end
