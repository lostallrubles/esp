return function (mclient)

 local function get_state()
  h = node.heap()
  local ok, json = pcall(cjson.encode, {heap=h, uptime=tmr.time(), relayPinNum=pinRelay, State=gpio.read(pinRelay)})
  if ok then return json else return '{}' end
 end

 local function publish_state()
  local data = get_state()
  local topic = "/ESP"..node.chipid().."/STAT"
  mclient:publish(topic, data, 0, 0, function(conn) 
   print("sent webstate!")
  end)
 end

 publish_state()
 collectgarbage()
end
