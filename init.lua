
    print("WIFI control")
    -- put module in AP mode
    wifi.setmode(wifi.SOFTAP)
    print("ESP8266 mode is: " .. wifi.getmode())
    cfg={}
    -- Set the SSID of the module in AP mode and access password
    cfg.ssid="ESP_S"
    cfg.pwd="the_ESP8266_WIFI_password"
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
            c:send("<html lang='en'>")
            c:send("<body>")
            c:send("<h1>ESP8266 Wireless control setup</h1>")
            mac_mess1 = "The module MAC address is: " .. ap_mac
            mac_mess2 = "You will need this MAC address to find the IP address of the module, please take note of it."
            c:send("<h2>" .. mac_mess1 .. "</h2>")
            c:send("<h2>" .. mac_mess2 .. "</h2>")
            c:send("<h2>Enter SSID and Password for your WIFI router</h2>")
            c:send("</form> </body> </html>")
            c:send("<form action='' method='get'>")
            c:send("SSID:")
            c:send("<input type='text' name='SSID' value='' maxlength='100' />")
            c:send("<br />")
            c:send("Password:")
            c:send("<input type='text' name='Password' value='' maxlength='100' />")
            c:send("<input type='submit' value='Submit' />")
        end)
        c:on("sent",function(c) c:close() end)
    end)
