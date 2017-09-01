local port = 80

wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function()
  gpio.mode(8, gpio.OUTPUT)
  gpio.write(8, gpio.HIGH)
  print('Server running on http://' .. wifi.sta.getip() .. ':' .. port)
end)

local Server = dofile('Server.lc')
local server = Server(port)

server.get('/', function(request, response)
  response.begin(function()
    response.write_file('index.html', function()
      response.finish()
    end)
  end)
end)

server.post('/gpio', function(request, response)
  gpio.mode(request.params.pin, gpio.OUTPUT)
  gpio.write(request.params.pin, request.params.state)

  response.begin(function()
    response.finish()
  end)
end)

server.post('/pwm', function(request, response)
  pwm.setup(request.params.pin,100,0)
  pwm.start(request.params.pin)
  pwm.setduty(request.params.pin, request.params.duty)
  response.begin(function()
    response.finish()
  end)
end)

server.get('/adc', function(request, response)
  response.begin(function()
    response.write(adc.read(request.params.pin), function()
      response.finish()
    end)
  end)
end)
