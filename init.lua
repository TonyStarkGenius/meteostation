function decodeChar(hex)
return string.char(tonumber(hex,16))
end
function decodeString(str)
local output,t=string.gsub(str,"%%(%x%x)",decodeChar)
return output
end
    print("WIFI control")
    -- put module in AP mode
    wifi.setmode(wifi.SOFTAP)
    print("ESP8266 mode is: " .. wifi.getmode())
    cfg={}
    -- Set the SSID of the module in AP mode and access password
    cfg.ssid="Meteostation"
    cfg.pwd="Industries"
    if ssid and password then
        print("ESP8266 SSID is: " .. cfg.ssid .. " and PASSWORD is: " .. cfg.pwd)
    end
    -- Now you should see an SSID wireless router named ESP_STATION when you scan for available WIFI networks
    -- Lets connect to the module from a computer of mobile device. So, find the SSID and connect using the password selected
    wifi.ap.config(cfg)
    ap_mac = wifi.ap.getmac()
    -- create a server on port 80 and wait for a connection, when a connection is coming in function c will be executed
    sv=net.createServer(net.TCP,30)
    sv:listen(80,function(c)
        c:on("receive", function(c, pl)
             -- print the payload pl received from the connection
            print(pl)
            print(string.len(pl))
            -- wait until SSID comes back and parse the SSID and the password
            print(string.match(pl,"GET"))
            ssid_start,ssid_end=string.find(pl,"SSID=")
            if ssid_start and ssid_end then
                    amper1_start, amper1_end =string.find(pl,"&", ssid_end+1)
                    if amper1_start and amper1_end then
                        http_start, http_end =string.find(pl,"HTTP/1.1", ssid_end+1)
                        if http_start and http_end then
                            ssid=string.sub(pl,ssid_end+1, amper1_start-1)
                            password=string.sub(pl,amper1_end+10, http_start-2)
                            ssid=decodeString(ssid)
                            password=decodeString(password)
                            
                            print("ESP8266 connecting to SSID: " .. ssid .. " with PASSWORD: " .. password)
                            if ssid and password then
                                sv:close()
                                -- close the server and set the module to STATION mode
                                wifi.setmode(wifi.STATION)
                                print("ESP8266 mode now is: " .. wifi.getmode())
                                -- configure the module wso it can connect to the network using the received SSID and password
                                cfgw={}
                                cfgw.ssid=ssid
                                cfgw.pwd=password
                                wifi.sta.config(cfgw)
                                wifi.sta.connect()
                                tmr.alarm(0, 1000, 1, function ()
                                    local ip = wifi.sta.getip()
                                    if ip then
                                      tmr.stop(0)
                                      print(ip)
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
                                    
                                      local function postTelegram()
                                        conn = nil
conn=net.createConnection(net.TCP, 0)
conn:on("receive", function(conn, payload) end)
conn:connect(80,'maker.ifttt.com')
conn:on("connection", function(conn, payload)
conn:send("POST /trigger/post_telegram/with/key/dAZ1lcXbHinubo7Y1TGeik HTTP/1.1\r\n"..
  "Host: maker.ifttt.com\r\nConnection: close\r\nAccept: */*\r\nContent-Type: application/json\r\n" ..
  "Content-Length: 52\r\n\r\n{\"value1\":".. P ..",\"value2\":".. T ..",\"value3\":"..H.."}\r\n") end)
                                        end
                                      postTelegram()
                                      collectgarbage()
                                    end
                                    if wifi.getmode()==1 then
                                        measure()
                                        tmr.alarm(0, 36000, 1, function() measure() end )
                                    end
                                    else
                                      print("Connecting to WIFI...")
                                    end
                                end)
                            end
                        end
                    end
            end
            -- this is the web page that requests the SSID and password from the user
            c:send("HTTP/1.1 200 OK\r\nServer: ESP8266\r\nContent-Type: text/html\r\n\r\n")
            c:send("<!DOCTYPE html>")
            c:send("<html>")
            c:send("<head>")
            c:send("<title>Wi-Fi Setup</title>")
            c:send("<style>")
            c:send("body{font-family:Arial;background-color:#ff9900;padding:50px;}")
            c:send(".login{margin:20px auto;width:300px;}")
            c:send(".login-screen{background-color:#fff;padding:20px;border-radius:5px;}")
            c:send(".app-title{text-align:center;color:#777;}")
            c:send(".login-form{text-align:center;}")
            c:send(".control-group{margin-bottom:10px;}")
            c:send("input{text-align:center;background-color:#f2f2f2;border:2px solid transparent;border-radius: 3px;font-size:16px;font-weight:200;padding:10px 0;width:250px;transition:border .5s;}")
            c:send("input:focus{border:2px solid #3498db;box-shadow:none;}")
            c:send(".btn {border: 2px solid transparent;background: #0099ff;color: #ffffff;font-size: 16px;line-height: 25px;padding: 10px 0;text-decoration: none;text-shadow: none;")
            c:send("border-radius: 3px;box-shadow: none;transition: 0.25s;display: block;width: 250px;margin: 0 auto;}")
            c:send(".btn:hover{background-color:#2980b9;}")
            c:send("</style>")
            c:send("</head>")
            c:send("<body>")
            c:send("<div class='login'>")
            c:send("<div class='login-screen'>")
            c:send("<div class='app-title'>")
            c:send("<h1>Wi-Fi Setup</h1>")
            c:send("</div>")
            c:send("<form method='get'>")
            c:send("<div class='login-form'>")
            c:send("<div class='control-group'>")
            c:send("<input type='text' placeholder='SSID' name='SSID' />")
            c:send("</div>")
            c:send("<div class='control-group'>")
            c:send("<input type='text' placeholder='Password' name='Password' />")
            c:send("</div>")
            c:send("<button type='submit' class='btn'>Login</button>")
            c:send("</div></form></div></div> </body> </html>")
        end)
        c:on("sent",function(c) c:close() end)
    end)
