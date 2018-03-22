local Display = require 'Display'
local get = require 'get'
local show = require 'show'
local delay = require 'delay'

-- local config = {
--   tls = true,
--   server = 'ci.openquake.org',
--   port = 443,
--   host = 'ci.openquake.org',
--   resource = 'https://ci.openquake.org/computer/api/json'
-- }

local config = {
  tls = false,
  server = 'http-proxy.appl.ge.com',
  port = 8080,
  host = 'jenkins.tech.geappl.io',
  resource = 'https://jenkins.tech.geappl.io/computer/api/json'
}

return function()
  local display = Display(require 'ssd1306')
  -- local display = Display(require 'pcd8544')

  display.draw(function(display)
    display:drawStr(0, 0, 'Connecting...')
  end)

  while true do
    local json_parser = require 'JsonParser'()
    get(config, json_parser.feed)
    show(display, json_parser.finalize())
    delay(30 * 1000)
  end
end
