local mplib = require('mplib')
local mp = mplib.new ({ ini_version = false,
                        mem_name    = 'mpost' })
if mp then
  local l = mp:execute([[outputformat :="svg";beginfig(1);
                         fill fullcircle scaled 20;
                         endfig;
                       ]])
  if l and l.fig and l.fig[1] then
    print (l.fig[1]:svg())
  end
  mp:finish();
end

