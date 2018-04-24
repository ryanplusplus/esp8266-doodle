print('i am ' .. tostring(node.chipid()))

-- init mqtt client without logins, keepalive timer 120s
m = mqtt.Client('client_' .. tostring(node.chipid()), 120)

-- setup Last Will and Testament (optional)
-- Broker will publish a message with qos = 0, retain = 0, data = 'offline'
-- to topic '/lwt' if client don't send keepalive packet
m:lwt('/lwt', 'offline', 0, 0)

m:on('connect', function(client) print ('connected') end)
m:on('offline', function(client) print ('offline') end)

m:on('message', function(client, topic, data)
  print(topic .. ':' )
  if data then print(data) end
end)

local mqtt_connect

local function mqtt_error(_, reason)
  print('failed reason: ' .. reason)
  tmr.create():alarm(1000, tmr.ALARM_SINGLE, mqtt_connect)
end

mqtt_connect = function()
  print('trying to connect...')
  m:connect('192.168.195.183', 12345, 0, function(client)
    print('connected')

    -- subscribe topic with qos = 0
    client:subscribe('/topic', 0, function(client) print('subscribe success') end)

    -- publish a message with data = hello, QoS = 0, retain = 0
    client:publish('/topic', 'hello from ' .. tostring(node.chipid()), 0, 0, function(client) print('sent') end)
  end,
  mqtt_error)
end

mqtt_connect()
