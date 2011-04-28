local function _split_curve(p,c1,c2,q,c)
   local p,c1,c2,q,coll_ind = p,c1,c2,q,coll_ind
   local  intervals = {}
   coll_ind = c
   local last_value = -1
   bit=4
   L=math.ldexp(1,bit)
   values={0};for i=1,L-1 do values[i+1]= math.ldexp(i,-bit) end; values[#values+1]=1
   if #coll_ind <=1 then 
      return {}
   end
   if #coll_ind == 2 and coll_ind[1]+1 == coll_ind[2] then 
      intervals[1] = {coll_ind[1],coll_ind[2]}
      return intervals
   end
   if #coll_ind == 2 and not(coll_ind[1]+1 == coll_ind[2]) then 
      return {}
   end

   first_value = coll_ind[1]
   last_value = first_value
   for v=2,#coll_ind do
      if last_value +1 == coll_ind[v] then 
	 last_value = last_value +1 
      else
	 print("find step f="..first_value.. ' l='..last_value)
	 if first_value ~= last_value then intervals[#intervals+1] = {first_value,last_value} end
	 first_value = coll_ind[v]
	 last_value = first_value
      end
   end
   print("find step f="..first_value.. ' l='..last_value)
   if first_value ~= last_value then intervals[#intervals+1] = {first_value,last_value} end
   return intervals
end

coll_ind = {1,3,4,5,}
res = _split_curve(1,1,1,1,coll_ind)
--,function(x) table.foreach(x,print) end)
table.foreach(res,function(i,t) table.foreach(t,print) end)
--coll_ind = {1,2,3,4,5,6,7,8,9,10,12,13,14,16,17}
--res = _split_curve(1,1,1,1,coll_ind)



