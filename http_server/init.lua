local function send_header(status, connection, callback)
  local message = {
    [200] = 'OK',
    [404] = 'FILE NOT FOUND'
  }

  local header =
    'HTTP/1.0 ' .. status .. ' ' .. message[status] .. '\r\n' ..
    'Server: NodeMCU on ESP8266\r\n' ..
    'Content-Type: text/html\r\n\r\n'

  connection:send(header, callback)
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

local function parse_request(request)
  local args = {}
  local method, resource = request:match('(%w*) ([^%?%s]*)%??')
  local arg_string = request:match('?([^%s]*)') or ''

  for name, value in arg_string:gmatch('(%w*)=(%w*)') do
    args[name] = value
  end

  return {
    method = method,
    resource = resource,
    args = args
  }
end

net.createServer(net.TCP):listen(80, function(connection)
  connection:on('receive', function(response, request)
    print(request)

    request = parse_request(request)

    if request.method == 'GET' then
      if request.resource == '/' then
        send_header(200, response, function()
          send_file('index.html', response, function()
            response:close()
          end)
        end)
      else
        send_header(404, response, function()
          send_file('whoops.html', response, function()
            response:close()
          end)
        end)
      end
    elseif request.method == 'POST' then
      if request.resource == '/gpio' then
        gpio.write(args.pin, args.state)

        send_header(200, response, function()
          response:close()
        end)
      else
        send_header(404, response, function()
          send_file('whoops.html', response, function()
            response:close()
          end)
        end)
      end
    else
      send_header(404, response, function()
        send_file('whoops.html', response, function()
          response:close()
        end)
      end)
    end
  end)
end)
