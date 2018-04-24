local sda = 3
local scl = 2
local led = 1

gpio.mode(led, gpio.OUTPUT)
gpio.write(led, gpio.HIGH)

i2c.setup(0, sda, scl, i2c.SLOW)

print('setup: ', tcs34725.setup())

tcs34725.enable(function()
  tmr.create():alarm(500, tmr.ALARM_AUTO, function()
    print('crgb: ' .. table.concat({ tcs34725.raw() }, ', '))
  end)
end)
