--[[
Reads temperature and humidity from a DHT11 sensor and logs to
an SD card connected via SPI.
]]

local dht_pin = 4

spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, 8, 8)

file.mount('/SD0', 8)
local f do
  if file.exists('/SD0/log') then
    f = file.open('/SD0/log', 'a')
  else
    f = file.open('/SD0/log', 'w')
    if f then
      f:flush()
      f:writeline('C, F, RH')
    end
  end
end

tmr.create():alarm(1000, tmr.ALARM_AUTO, function()
  local status, tc, h = dht.read(dht_pin)
  if status == dht.OK then
    local tf = tc * 9 / 5 + 32
    print(tc .. 'C ' .. tf .. 'F ' .. h .. '%')
    if f then
      f:writeline(table.concat({ tc, tf, h }), ', ')
      f:flush()
    end
  else
    print(status)
  end
end)
