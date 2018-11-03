local function write_object(aFileName, aData)
 if file.open(aFileName, "w+") then
  file.write(aData)
  file.close()   
  print(aFileName .. " written")
 end
end 

return function(fName, rawString)
 print('new settings:', rawString)
 for k, v in string.gmatch(rawString, "([^=,]+)=([^=,]+)") do
  settings[k] = v
 end
 local ok, json = pcall(cjson.encode,settings)
 if ok then 
  write_object(fName, json)
  node.restart()
 end 
end 
