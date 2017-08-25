local function read_file(filename)
  local file = io.open(filename, 'rb')
  local content = file:read('*all')
  io.close(file)
  return content
end

net.createServer(net.TCP):listen(80, function(connection)
  connection:on('receive', function(connection, payload)
    local response =
      'HTTP/1.0 200 OK\r\nServer: NodeMCU on ESP8266\r\nContent-Type: text/html\r\n\r\n' ..
      read_file("gui.html")

    print(payload)

    connection:send(response, function()
      connection:close()
    end)
  end)
end)
