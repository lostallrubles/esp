return function(cli, topic, data)
 local pin = string.match(topic,'%d+',-2)
 local value = gpio.LOW
 if (data == '1') then 
  value = gpio.HIGH
 end
 gpio.write(pin, value)
 print("gpio", pin, data)
 dofile('stat.lua')(cli)
end 
