mcli = mqtt.Client("esp8266"..node.chipid(), 120)
mcli:connect(settings.mqttIP , settings.mqttPort, 0, function(conn) print("success", settings.mqttIP)end)

mcli:on("connect", function(con)
 print("Mqtt Connected to:" .. settings.mqttIP)
 mcli:subscribe("/ESP"..node.chipid().."/CMD/#",0, function(conn) print("subscribe success") end)
 tmr.alarm(0, settings.tempInterval, 1, function() dofile('stat.lua')(mcli) end ) 
end)

mcli:on("message", function(client, topic, data) 
 print("got topic: ".. topic .. ":") 
 if data ~= nil then
  print(data)
  if topic == "/ESP"..node.chipid().."/CMD/SETTINGS" then
   dofile('update_settings.lua')(sett_json, data)
  elseif (topic == "/ESP"..node.chipid()..'/CMD/FILE') then 
   dofile('publish_file.lua')(data)
  else
   local b,e = string.find(topic, '/ESP'..node.chipid()..'/CMD/GPIO/')
   if ((e ~= nil) and (e > 1)) then 
    dofile('process_gpio.lua')(mcli,topic,data)
   else
    b,e = string.find(topic, '/ESP'..node.chipid()..'/CMD/WFILE/')
    if ((e ~= nil) and (e > 1)) then 
     dofile('process_fwrite.lua')(mcli,topic,data)
    end
   end
  end
 end
end)

mcli:on("offline", function(con)
 tmr.stop(0)
 mcli = nil
 dofile('wifi_connect.lua')(function() dofile('mqtt_connect.lua')('mqtt_main.lua') end)
end)
