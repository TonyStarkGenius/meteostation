function decodeRain(rain)
local out
if rain==1024 then out=0 end
if rain<1024 and rain>=824 then out=1 end
if rain<824 and rain>=624 then out=2 end
if rain<624 and rain>=424 then out=3 end
if rain<424 and rain>=224 then out=3 end
if rain<224 and rain>=0 then out=4 end
return out
end
tmr.delay(5000000)
print(wifi.sta.status())
clock=0
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
            node.dsleep(900*1000*1000)
            clock=0
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
    --    connout:close();
       collectgarbage();
    end)
 
    connout:connect(80,'api.thingspeak.com')
    --connout:on("sent",function(connout) connout:close() end)
  end
  postThingSpeak('9MYXUNRD9B828UQA', 'field1='..T..'&field2='..P..'&field3='..H..'&field4='..rain)
  collectgarbage()
  print("OK")
  local function postTelegram()
                                        conn = nil
conn=net.createConnection(net.TCP, 0)
conn:on("receive", function(conn, payload) end)
conn:connect(80,'maker.ifttt.com')
conn:on("connection", function(conn, payload)
conn:send("POST /trigger/post_telegram/with/key/dAZ1lcXbHinubo7Y1TGeik HTTP/1.1\r\n"..
  "Host: maker.ifttt.com\r\nConnection: close\r\nAccept: */*\r\nContent-Type: application/json\r\n" ..
  "Content-Length: "..num.."\r\n\r\n{\"value1\":".. P ..",\"value2\":".. T ..",\"value3\":"..H.."}\r\n") end)
                                        end
                                      postTelegram()
                                      local function postTelegramRain()
                                        conn = nil
                                        rainy=decodeRain(rain)
                                        if P>=1000 then num=41 else num=40 end
conn=net.createConnection(net.TCP, 0)
conn:on("receive", function(conn, payload) end)
conn:connect(80,'maker.ifttt.com')
conn:on("connection", function(conn, payload)
conn:send("POST /trigger/post_rain/with/key/dAZ1lcXbHinubo7Y1TGeik HTTP/1.1\r\n"..
  "Host: maker.ifttt.com\r\nConnection: close\r\nAccept: */*\r\nContent-Type: application/json\r\n" ..
  "Content-Length: 14\r\n\r\n{\"value1\":\"".. rainy .."\"}\r\n") end)
                                        
                                        end
                                      postTelegramRain()
                                      collectgarbage()

                                      
                                      clock=clock+1
                                      print(clock)
                                     if (clock==5) then
                                     tmr.stop(0)
dofile("wi-fi.lua")
end
end
measure()
tmr.alarm(0, 10000, 1, function () measure()  end)
print("ok2")
