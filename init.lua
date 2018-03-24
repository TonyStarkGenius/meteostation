wifi.setmode(wifi.STATION)
local cfg={}
cfg.ssid="home28"
cfg.pwd="21458613"
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
local function measure()
  sda,scl=6,5
  i2c.setup(0,sda,scl,i2c.SLOW)
  bme280.setup(5,5,5,1,7,4)
  function readData()
    P, T = bme280.baro()
    H, T = bme280.humi()
    P=P/1000
    T=T/100
    H=H/1000
    print("PRESSURE=".. P)
    print("TEMPERATURE=".. T)
    print("HUMIDITY=".. H)
    adc.force_init_mode(adc.INIT_ADC)
    rain=adc.read(0)
    print(rain)
  end
   readData();

  local function postThingSpeak(api_key, data)
    local connout = nil
    local connout = net.createConnection(net.TCP, 0)
 
    connout:on("receive", function(connout, payloadout)
        if (string.find(payloadout, "Status: 200 OK") ~= nil) then
            print("Sent to thingspeak.com OK");
        end
    end)
 
    connout:on("connection", function(connout, payloadout)
        connout:send("GET /update?api_key="..api_key.."&"..data
        .. " HTTP/1.1\r\n"
        .. "Host: api.thingspeak.com\r\n"
        .. "Connection: close\r\n"
        .. "Accept: */*\r\n"
        .. "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n"
        .. "\r\n")
    end)
 
    connout:on("disconnection", function(connout, payloadout)
        --connout:close();
        collectgarbage();
    end)
 
    connout:connect(80,'api.thingspeak.com')
  end
  postThingSpeak('9MYXUNRD9B828UQA', 'field1='..T..'&field2='..P..'&field3='..H..'&field4='..rain)
  collectgarbage()
end

measure()
tmr.alarm(0, 36000, 1, function() measure() end )
