local function pub(line)
 m:publish('/filepub',line,0,0,function(conn)
  local nextline = file.readline()
  if nextline ~= nil then 
   print('line:',nextline)
   pub(nextline)
  else
   file.close()
   print('done')
  end
 end)
end

return function(aName)
 print('publishing file', aName)
 if file.exists(aName) then 
  print('exists')
  if file.open(aName) then 
   print('opened')
   pub(file.readline())
  end
 end
end
