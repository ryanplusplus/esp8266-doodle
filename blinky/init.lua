gpio.mode(0, gpio.OUTPUT)

local timer = tmr.create()

local current = gpio.HIGH
timer:alarm(500, tmr.ALARM_AUTO, function()
  gpio.write(0, current)
  if current == gpio.HIGH then
    current = gpio.LOW
  else
    current = gpio.HIGH
  end
end)
