return function (aSettName)
 if file.open(aSettName) then 
  local ok, json = pcall(sjson.decode,file.read())
  if ok then 
   return json
  else
   return nil
  end
 else
  return nil
 end
end
