return function(cli, topic, data)
 local b,e = string.find(topic, '/WFILE/CREATE')
 if ((e ~= nil) and (e > 1)) then 
  file.open(data,'w+')
 else
  b,e = string.find(topic, '/WFILE/CLOSE')
  if ((e ~= nil) and (e > 1)) then 
   file.close()
  else
   b,e = string.find(topic, '/WFILE/DATA')
   if ((e ~= nil) and (e > 1)) then 
    file.writeline(data)
   end 
  end
 end
end
