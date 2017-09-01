local function write_header(response, callback)
  local header =
    'HTTP/1.0 200 OK\r\n' ..
    'Server: NodeMCU on ESP8266\r\n' ..
    'Content-Type: text/html\r\n\r\n'

  response:send(header, callback)
end

local function write_file(filename, response, callback)
  local f = file.open(filename, 'r')

  local function send_next_chunk()
    local chunk = f:read(1000)
    if chunk then
      response:send(chunk, send_next_chunk)
    else
      f:close()
      callback()
    end
  end

  send_next_chunk()
end

local function parse_request(request)
  local params = {}
  local method, url = request:match('(%w*) ([^%?%s]*)%??')
  local param_string = request:match('?([^%s]*)') or ''

  for name, value in param_string:gmatch('(%w*)=(%w*)') do
    params[name] = value
  end

  return {
    method = method,
    url = url,
    params = params
  }
end

return function(port)
  local routes = {
    GET = {},
    PUT = {},
    POST = {},
    DELETE = {}
  }

  net.createServer(net.TCP):listen(port, function(connection)
    connection:on('receive', function(response, request)
      request = parse_request(request)

      if routes[request.method][request.url] then
        routes[request.method][request.url](request, {
          begin = function(callback) write_header(response, callback) end,
          write = function(value, callback) response:send(value, callback) end,
          write_file = function(filename, callback) write_file(filename, response, callback) end,
          finish = function() response:close() end
        })
      end
    end)
  end)

  return {
    get = function(url, handler) routes.GET[url] = handler end,
    put = function(url, handler) routes.PUT[url] = handler end,
    post = function(url, handler) routes.POST[url] = handler end,
    delete = function(url, handler) routes.DELETE[url] = handler end
  }
end
