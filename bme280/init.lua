local sda = 2
local scl = 3

i2c.setup(0, sda, scl, i2c.SLOW)

bme280.setup()

tmr.create():alarm(1000, tmr.ALARM_AUTO, function()
  local humidity, temperature = bme280.humi()
  if humidity and temperature then
    humidity = humidity / 100
    temperature = temperature / 100
    print('Temperature: ' .. temperature .. 'C, Humidity: ' .. humidity .. '%')
  end
end)
