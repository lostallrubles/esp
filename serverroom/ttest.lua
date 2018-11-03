sett_json    = "conf.json"
wifi_json    = "wifi.json"
sensors_json = "sensors.json"
pinRelay   = 4 -- GPIO2
pinSwitch  = 3 -- GPIO0
settings   = nil
sensors    = nil
settings   = nil
wificonfig = nil
lastTicks = 0
gpio.mode(pinRelay,  gpio.OUTPUT)
gpio.write(pinRelay, gpio.LOW)
--interrupt gpio0 (pin3) for manual switch
gpio.mode(pinSwitch, gpio.INT)
local function switch(lvl, mseconds)
 if (math.abs(mseconds - lastTicks) > 500000) and (lvl == gpio.LOW) then 
  lastTicks = mseconds
  local value = gpio.read(pinRelay)
  if (value == gpio.HIGH) then
   value = gpio.LOW
  else
   value = gpio.HIGH
  end
  gpio.write(pinRelay, value)
 end
end
gpio.trig(pinSwitch, "low", switch)
dofile("write_def_config.lua")(wifi_json, sett_json)
collectgarbage()
function startup()
 print("=== START ===")
 dofile('mqtt_connect.lua')('mqtt_main.lua')
 collectgarbage()
end
settings   = dofile('read_any_config.lua')(sett_json)
uart.setup(0, settings.baudRate, 8, uart.PARITY_NONE, uart.STOPBITS_1, 1)
dofile('wifi_connect.lua')(startup)
