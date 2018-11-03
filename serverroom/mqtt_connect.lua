return function(afilename)
 m = mqtt.Client("esp8266"..node.chipid(), 120)
 n = 0
 tmr.alarm(1, 3000, 1, function()
  print('try connect to broker '..settings.mqttIP, n)
  m:connect(settings.mqttIP , settings.mqttPort, 0, function(conn)
   tmr.alarm(1, 1000, 0, function()
    m:close()
    m = nil
    collectgarbage()
    dofile(afilename)
   end)
  end)
  n = n + 1
  if (n > 20) then 
   n = 0
   print('offline logic processing ....')
  end 
 end)
end
