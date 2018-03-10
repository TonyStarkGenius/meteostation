-- BME280 Example
sda,scl=6,5
 i2c.setup(0,sda,scl,i2c.SLOW)
bme280.setup(5,5,5,1,7,4)
local P, T = bme280.baro()
tmr.delay(100000)  
local P, T = bme280.baro()
local H, t = bme280.humi()
T = T/100
H = H/1000
P=P/1000
print (P, T, H)