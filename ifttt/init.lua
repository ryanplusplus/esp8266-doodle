--init.lua
local ssid = "ssid"
local password = "password"

-- To create an event and generate a key
-- Create an account on https://ifttt.com
-- Search for webhooks
-- Click on Web hooks to see your key.  Replace "key" with your key.
local ifttt_key = "key"
-- When creating a new app select web hooks and key in an event name
-- Then replace "event" with your event name.
local ifttt_event = "event"

local function IFTTT_SendTrigger()

	conn = nil
	-- create a plain (unencripted) TCP connection,
	conn=net.createConnection(net.TCP)

	-- call back for receive to print what is received
	conn:on("receive", function(conn, payload)
			 print(payload)
			 end)

	-- call back for connection, when connected send the trigger
	conn:on("connection", function(conn, payload)
			 print('\nConnected')
			 conn:send("POST /trigger/"..ifttt_event.."/with/key/"..ifttt_key
				.." HTTP/1.1\r\n"
				.."Host: maker.ifttt.com\r\n"
				.."Accept: */*\r\n"
				.."User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n"
				.."\r\n")
			 end)

	 -- resolve the server name
	 conn:dns("maker.ifttt.com",function(conn,ip)
			 if (ip) then
					 print("We can connect to " .. ip)
			 else
					 print("DNS Failed \r\n" )
			 end
	 end)

  -- call back for disconnect
	conn:on("disconnection", function(conn, payload)
				print('\nDisconnected')
				end)

	print('Posting to ifttt.com')
	-- connct to the remote server
	conn:connect(80,'maker.ifttt.com')
end

function debounce (func)
		local last = 0
		local delay = 200000

		return function (...)
				local now = tmr.now()
				if now - last < delay then return end

				last = now
				return func(...)
		end
end

function on_gpio_change(level, when, eventcount)
		if gpio.read(buttonPin) == 0 then
				print("That was easy! ")

				IFTTT_SendTrigger()

				tmr.delay(500000)
		end
end

local function show_wifi_configuration()
	--Get SoftAP configuration table (NEW FORMAT)
	do
	  print("\n  Current SoftAP configuration:")
	  for k,v in pairs(wifi.ap.getconfig(true)) do
	      print("   "..k.." :",v)
	  end
	end
end

wifi.setmode(wifi.STATION)
wifi.sta.config({ ssid = ssid, pwd = password })
wifi.sta.connect()

wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T)
		print("\tSTA - GOT IP")
		print("\tStation IP: "..T.IP)
		print("\tSubnet mask: "..T.netmask)
		print("\tGateway IP: "..T.gateway)
end)

tmr.alarm(1, 2000, tmr.ALARM_AUTO, function()
	if wifi.sta.getip()== nil then
		print("Waiting for IP...")
	else
		  tmr.stop(1)

			show_wifi_configuration()
	    print("5 seconds to stop timer 0")
	    tmr.alarm(0, 5000, 0, function()
				print("Starting button listener...")

				buttonPin = 1
				print("Set gpio.mode");
				gpio.mode(buttonPin, gpio.INT, gpio.PULLUP)

				print("Set gpio.trig");
				gpio.trig(buttonPin, "down", debounce(on_gpio_change))

	  end)
  end
end)
