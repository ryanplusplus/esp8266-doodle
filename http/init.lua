net.createServer(net.TCP):listen(80, function(connection)
  connection:on('receive', function(connection, payload)
    local response = [[
      'HTTP/1.0 200 OK\r\nServer: NodeMCU on ESP8266\r\nContent-Type: text/html\r\n\r\n' ..
      '<!DOCTYPE html><html><body><h1>Hello, World!</h1></body></html>'
    ]]
    
    connection:send(response, function()
      connection:close()
    end)
  end)
end)
