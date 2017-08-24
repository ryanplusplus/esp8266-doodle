pwm.setup(1, 1000, 0)
pwm.start(1)

tmr.create():alarm(1, tmr.ALARM_AUTO, coroutine.wrap(function()
  while true do
    for i = 0, 1023 do
      pwm.setduty(1, i)
      coroutine.yield()
    end

    for i = 1023, 1, -1 do
      pwm.setduty(1, i)
      coroutine.yield()
    end
  end
end))
