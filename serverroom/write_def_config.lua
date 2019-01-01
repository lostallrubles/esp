return function(aWifiName, aSettingsName)

 local function write_object(aFileName, aObject)
  local ok, json = pcall(sjson.encode, aObject)
  if ok then 
   print("json encoded for " .. aFileName)
   if file.open(aFileName, "w+") then
    file.write(json)
    file.close()   
    print(aFileName .. " written")
   end
  else
   print("ERROR json encoding for", aFileName)
  end
 end 

 local function write_default_wifi(aFileName)
  if not(file.exists(aFileName)) then 
   local json = {ssid="netnet", pwd="gol19den66gate", auto=true}
   write_object(aFileName, json)
  end
 end 

 local function write_default_config(aFileName)
  if not(file.exists(aFileName)) then 
   local json = {tempInterval=10000, baudRate=115200, mqttIP="10.20.1.100", mqttPort=1883}
   write_object(aFileName, json)
  else
   print("config already exists", aFileName)
  end
 end

 write_default_wifi(aWifiName)
 write_default_config(aSettingsName)
end
