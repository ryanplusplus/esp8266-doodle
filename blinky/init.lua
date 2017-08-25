local pin = 1

gpio.mode(pin, gpio.OUTPUT)

tmr.create():alarm(500, tmr.ALARM_AUTO, coroutine.wrap(function()
  while true do
    gpio.write(pin, gpio.HIGH)
    coroutine.yield()

    gpio.write(pin, gpio.LOW)
    coroutine.yield()
  end
end))
