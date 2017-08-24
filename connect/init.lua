local ssid = "SSID"
local password = "password"

wifi.setmode(wifi.STATION)
wifi.sta.config({ ssid = ssid, pwd = password })

if wifi.sta.getip() then
  print(wifi.sta.getip())
else
  wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function()
    print(wifi.sta.getip())
  end)
end
