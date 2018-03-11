wifi.setmode(wifi.STATION)
local cfg={}
cfg.ssid="SSID"
cfg.pwd="PASSWORD"
wifi.sta.config(cfg)
wifi.sta.connect()
tmr.alarm(0, 1000, 1, function ()
local ip = wifi.sta.getip()
if ip then
  tmr.stop(0)
  print(ip)
else
  print("Connecting to WIFI...")
end
end)
