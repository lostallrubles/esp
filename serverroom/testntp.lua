sntp.sync("0.pool.ntp.org",
  function(sec, usec, server, info)
    print('sync', sec, usec, server, info)
  end,
  function()
   print('failed!')
  end
)
