return function(callback) 
 --local wificonfig = dofile('read_any_config.lua')(wifi_json)
 wifi.setmode(wifi.STATION)

 station_cfg={}
 station_cfg.ssid="netnet"
 station_cfg.pwd="gol19den66gate"
 wifi.sta.config(station_cfg)

 --wifi.sta.config(wificonfig) 
 wifi.sta.connect()

 n = 0
 tmr.alarm(1, 2000, 1, function() 
  n = n + 1
  if wifi.sta.getip()== nil then 
   print("IP unavaiable, Waiting...", n, node.heap()) 
   if (n > 60) then 
    n = 0
    print('process offline logic ...')
   end 
  else 
   tmr.stop(1)
   print("Config done, IP is "..wifi.sta.getip(), " heap: ", node.heap())
   print('You have 3 seconds to abort Startup')
   print("Waiting...")
   tmr.alarm(0,3000,0, callback)
  end 
 end)
end
