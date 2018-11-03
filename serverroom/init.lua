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
 if (lvl == gpio.LOW) then 
  local diff = mseconds - lastTicks
  if diff < 0 then diff = (-1 * diff) end
  if diff > 500000 then 
   print(mseconds)
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
end

gpio.trig(pinSwitch, "down", switch)

dofile("write_def_config.lua")(wifi_json, sett_json)
collectgarbage()

function startup()
 print("=== START ===")
 dofile('mqtt_connect.lua')('mqtt_main.lua')
 collectgarbage()
end

settings   = dofile('read_any_config.lua')(sett_json)
uart.setup(0, settings.baudRate, 8, uart.PARITY_NONE, uart.STOPBITS_1, 1)

-- this callback does not support arguments!
dofile('wifi_connect.lua')(startup)
