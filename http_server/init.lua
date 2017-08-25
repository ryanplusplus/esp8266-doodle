local function send_header(status, connection, callback)
  connection:send('HTTP/1.0 200 OK\r\nServer: NodeMCU on ESP8266\r\nContent-Type: text/html\r\n\r\n', callback)
end

local function send_file(filename, connection, callback)
  local f = file.open(filename, 'r')

  local function send_next_chunk()
    local chunk = f:read(1000)
    if chunk then
      connection:send(chunk, send_next_chunk)
    else
      f:close()
      callback()
    end
  end

  send_next_chunk()
end

net.createServer(net.TCP):listen(80, function(connection)
  connection:on('receive', function(response, request)
    print(request)

    send_header(200, response, function()
      send_file('index.html', response, function()
        response:close()
      end)
    end)
  end)
end)

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
