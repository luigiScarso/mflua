local f_int_log
local lines

f_int_log = io.open('intersec.log')
lines =  f_int_log:read("*all")
f_int_log:close()

local ij=string.gmatch(lines,"BEGIN i=([0-9]+),j=([0-9]+)")
local tu=string.gmatch(lines,">> ([-0-9.]+)")
local e=string.gmatch(lines,"END")

while true do 
   i,j = ij()
   if i == nil then break end
   t = tu()
   u = tu()
   print(i,j,t,u)
end

