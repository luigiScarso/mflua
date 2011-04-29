print("\n······· mflua_end_program says: 'Hello world!' ·······")




local function _eval(q,offset)
   local qx,qy,xo,yo
   local w 
   w=string.gmatch(q,"[-0-9.]+"); qx,qy=w(),w()
   w=string.gmatch(offset,"[-0-9.]+"); xo,yo=w(),w()
   return string.format("(%s,%s)",qx+xo,qy+yo)
end


local function _coord_str_to_table(p,c1,c2,q,shifted)
   local w
   if shifted==nil then shifted = '(0,0)' end
   w=string.gmatch(p,"[-0-9.]+"); p={w(),w()}
   w=string.gmatch(c1,"[-0-9.]+"); c1={w(),w()}
   w=string.gmatch(c2,"[-0-9.]+"); c2={w(),w()}
   w=string.gmatch(q,"[-0-9.]+"); q={w(),w()}
   w=string.gmatch(shifted,"[-0-9.]+"); shifted={w(),w()}
   return p,c1,c2,q,shifted
end


local function _coord_table_to_str(p,c1,c2,q,shifted)
   p = string.format("(%s,%s)",p[1],p[2]) 
   c1 = string.format("(%s,%s)",c1[1],c1[2])
   c2 = string.format("(%s,%s)",c2[1],c2[2])
   q = string.format("(%s,%s)",q[1],q[2])
   shifted = string.format("(%s,%s)",shifted[1],shifted[2])
   return p,c1,c2,q,shifted
end




local function bez(p,c1,c2,q,t)
   local b00,b01,b02,b03 =  {},{},{},{}
   local b10,b11,b12=  {},{},{}
   local b20,b21=  {},{}
   local b30=  {}
   local T=1-t
   --
   -- de Castljau Algorithm
   -- 
   b00=p 
   b01=c1 
   b02=c2 
   b03=q
   -- print(string.format("BEZ p=(%s,%s)",p[1],p[2]))
   -- print(string.format("BEZ c1=(%s,%s)",c1[1],c1[2]))
   -- print(string.format("BEZ c2=(%s,%s)",c2[1],c2[2]))
   -- print(string.format("BEZ q=(%s,%s)",q[1],q[2]))

   if t+0 == 1 then -- T = 0
      b10=  {b01[1],b01[2]}
      b11=  {b02[1],b02[2]}
      b12=  {b03[1],b03[2]}
      
      b20=  {b11[1],b11[2]}
      b21=  {b12[1],b12[2]}
      
      b30=  {b21[1],b21[2]}
   elseif t+0 == 0 then -- T = 1
      b10=  {b00[1] ,b00[2] }
      b11=  {b01[1] ,b01[2] }
      b12=  {b02[1] ,b02[2] }
      
      b20=  {b10[1] ,b10[2] }
      b21=  {b11[1] ,b11[2] }
      
      b30=  {b20[1] ,b20[2] }

   else
      b10=  {T*b00[1] + t*b01[1],T*b00[2] + t*b01[2]}
      b11=  {T*b01[1] + t*b02[1],T*b01[2] + t*b02[2]}
      b12=  {T*b02[1] + t*b03[1],T*b02[2] + t*b03[2]}
      
      b20=  {T*b10[1] + t*b11[1],T*b10[2] + t*b11[2]}
      b21=  {T*b11[1] + t*b12[1],T*b11[2] + t*b12[2]}
      
      b30=  {T*b20[1] + t*b21[1],T*b20[2] + t*b21[2]}

   end

   -- b10=  {b00[1] + t*(b01[1]-b00[1]),b00[2] + t*(b01[2]-b00[2])}
   -- b11=  {b01[1] + t*(b02[1]-b01[1]),b01[2] + t*(b02[2]-b01[2])}
   -- b12=  {b02[1] + t*(b03[1]-b02[1]),b02[2] + t*(b03[2]-b02[2])}

   -- b20=  {b10[1] + t*(b11[1]-b10[1]),b10[2] + t*(b11[2]-b10[2])}
   -- b21=  {b11[1] + t*(b12[1]-b11[1]),b11[2] + t*(b12[2]-b11[2])}

   -- b30=  {b20[1] + t*(b21[1]-b20[1]),b20[2] + t*(b21[2]-b20[2])}



   -- p=b00 c1=b01 c2=b02 q=b03 0<= t' <= 1 is C(t')
   -- C(t'=t) is x(t)=b30[1], y(t)=b30[2] 
   -- p=b00 c1=b10 c2=b20 q=b30 0<= t' <= 1 is  C(0<=t'<=t)
   -- p=b30 c1=b21 c2=b12 q=b03 0<= t' <= 1 is  C(t<=t'<=1)
   return b30[1],b30[2],b00,b10,b20,b30,b21,b12,b03

end

local function _make_straight_line(p,q) 
   local w,c,c1,P,Q
   w=string.gmatch(p,"[-0-9.]+"); P={w(),w()}
   w=string.gmatch(q,"[-0-9.]+"); Q={w(),w()}
   c = mflua.vec(P,Q)
   c1 = {P[1]+0.5*c[1],P[2]+0.5*c[2]}
   c1 = string.format("(%s,%s)",c1[1],c1[2])
   -- c2 = c1
   -- return {p,c1,c1,q}
   return c1 
end



local function _find_intersection(valid_curves,i,j,f_int)
   local bez1 = valid_curves[i]
   local bez2 = valid_curves[j]
   local p,c1,c2,q,shifted
   local f_int = f_int

   p,c1,c2,q,shifted = bez1[1],bez1[2],bez1[3],bez1[4],bez1[5]
   --print("BEZ _find_intersec",i,j, p,c1,c2,q,shifted)
   f_int:write(string.format("batchmode;\n",i,j))
   f_int:write(string.format("message \"BEGIN i=%s,j=%s\";\n",i,j))
   f_int:write(string.format("path p[]; p1:=%s .. controls %s and %s .. %s;\n",
		       _eval(p,shifted),_eval(c1,shifted),_eval(c2,shifted),_eval(q,shifted)))
   p,c1,c2,q,shifted = bez2[1],bez2[2],bez2[3],bez2[4],bez2[5]
   f_int:write(string.format("p2:=%s .. controls %s and %s .. %s;\n",
		       _eval(p,shifted),_eval(c1,shifted),_eval(c2,shifted),_eval(q,shifted)))
   f_int:write(string.format("numeric t,u; (t,u) = p1 intersectiontimes p2;\n"))
   f_int:write(string.format("numeric i,j; i:=%s;j:=%s;\n",i,j))
   f_int:write(string.format("show t,u;\n"))
   --f_int:write(string.format("message \"END\" ;\n"))
   f_int:write(string.format("message \"\" ;\n"))
end

local function _calculate_all_intersections(valid_curves)
   local mflua = './mf' 
   local temp = "intersec"
   local temp_file = temp .. ".mf"
   local f_int_log = temp .. ".log"
   local lines
   local f_inters = io.open(temp_file,'w')
   local matrix_inters = {}
   local res 
   local ij
   local tu
   for i=1,#valid_curves do 
      if i > 1 then 
	 for j=1,i-1 do 
	    _find_intersection(valid_curves,i,j,f_inters)
	 end -- j=1,#valid_curves do 
      end
   end
   f_inters:write(string.format("bye.\n"))
   f_inters:close()
   io.open('LOCK1','w')
   os.execute(string.format("%s %s",mflua,temp_file));
   os.remove('LOCK1')

   f_int_log = io.open('intersec.log')
   lines =  f_int_log:read("*all")
   f_int_log:close()

   local ij=string.gmatch(lines,"BEGIN i=([0-9]+),j=([0-9]+)")
   local tu=string.gmatch(lines,">> ([-0-9.]+)")
   local tab
   while true do 
      i,j = ij()
      if i == nil then break end
      t,u = tu(), tu()
      if not( t=='-1' and u=='-1' ) then 
	 tab  = matrix_inters[i] or {}
	 tab[#tab+1] = {j,t,u}
	 matrix_inters[i] = tab
	 tab  = matrix_inters[j] or {}
	 tab[#tab+1] = {i,u,t}
	 matrix_inters[j] = tab
	 -- print(string.format("BEZ i=%s,j=%s,t=%s,u=%s",i,j,t,u))
      end
   end
   print("BEZ #matrix_inters="..#matrix_inters)
   return matrix_inters
end


-- local function _bez(p,c1,c2,q,offset,t)
--    local qu = (1-t)*(1-t)
--    local qu1 = t*t
--    local m = 1-t
--    local a,b,c,d = qu*m, 3*qu*t, 3*m*qu1,  qu1*t
--    local x,y,X,Y
--    -- better horner rule here
--    x = a*p[1] + b*c1[1] + c*c2[1] + d*q[1] 
--    y = a*p[2] + b*c1[2] + c*c2[2] + d*q[2] 
--    check_X,check_Y = math.abs(x-math.floor(x)),math.abs(y-math.floor(y))

--    --if math.abs(x-math.floor(x)) < 0.05 then X = math.floor(x) end
--    --if math.abs(x-math.ceil(x)) < 0.05 then X = math.ceil(x) end
--    --if math.abs(y-math.floor(y)) < 0.05 then Y = math.floor(y) end
--    --if math.abs(y-math.ceil(y)) < 0.05 then Y = math.ceil(y) end
--    return x,y
-- end



local function _split_indexes(c)
   local  intervals = {}
   local first_value, last_value
   local coll_ind = c
   if #coll_ind <=1 then 
      return {}
   end
   if #coll_ind == 2 and coll_ind[1]+1 == coll_ind[2] then 
      intervals[1] = {coll_ind[1],coll_ind[2]}
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
	 --print("BEZ find step f="..first_value.. ' l='..last_value)
	 if first_value ~= last_value then intervals[#intervals+1] = {first_value,last_value} end
	 first_value = coll_ind[v]
	 last_value = first_value
      end
   end
   --print("BEZ find step f="..first_value.. ' l='..last_value)
   if first_value ~= last_value then intervals[#intervals+1] = {first_value,last_value} end
   return intervals
end



local function _split_curve(p,c1,c2,q,offset,c)
   local p,c1,c2,q,shifted, coll_ind = p,c1,c2,q,offset,c
   local  intervals = {}
   local curves = {}
   local first_value, last_value
   local t1,t2
   local p_left,c1_left,c2_left,q_left
   local p_right,c1_right,c2_right,q_right

   coll_ind = c
   intervals = _split_indexes(coll_ind)

   --print("BEZ #intervals="..#intervals)
   if #intervals == 0 then return curves end
   --print(string.format("BEZ p=%s,c1=%s,c2=%s,q=%s,shifted=%s",p,c1,c2,q,shifted))

   w=string.gmatch(p,"[-0-9.]+"); p={w(),w()}
   w=string.gmatch(c1,"[-0-9.]+"); c1={w(),w()}
   w=string.gmatch(c2,"[-0-9.]+"); c2={w(),w()}
   w=string.gmatch(q,"[-0-9.]+"); q={w(),w()}
   --w=string.gmatch(shifted,"[-0-9.]+"); shifted={w(),w()}
   bit=mflua.bit
   L=math.ldexp(1,bit)
   values={0};for i=1,L-1 do values[i+1]= math.ldexp(i,-bit) end; values[#values+1]=1
   for i,v in pairs(intervals) do
      --print("BEZ i="..i,"v[1]="..v[1])
      t1 = values[v[1]]
      t2 = values[v[2]]
      print("BEZ t1="..tostring(t1).. " t2="..tostring(t2))
      _1,_2,_3,_4,_5,_6,_7,_8,_9 =  bez(p,c1,c2,q,t1)
      -- _1,_2,_3,_4,_5,_6,_7,_8,_9 =  bez_int(p,c1,c2,q,0+v[1])
      -- print("BEZ right ok")
      p_right,c1_right,c2_right,q_right = _6,_7,_8,_9
      _1,_2,_3,_4,_5,_6,_7,_8,_9 =  bez(p_right,c1_right,c2_right,q_right,t2)
      -- _1,_2,_3,_4,_5,_6,_7,_8,_9 =  bez_int(p_right,c1_right,c2_right,q_right,0+v[2])
      -- print("BEZ left ok")
      p_left,c1_left,c2_left,q_left = _3,_4,_5,_6
      p_left = string.format("(%s,%s)",p_left[1],p_left[2])
      c1_left= string.format("(%s,%s)",c1_left[1],c1_left[2])
      c2_left = string.format("(%s,%s)",c2_left[1],c2_left[2])
      q_left =  string.format("(%s,%s)",q_left[1],q_left[2])
      curves[#curves+1] = {p_left,c1_left,c2_left,q_left,shifted}
   end
   return curves 
end


local function _open_loop(valid_curves,matrix_inters)
   --
   -- loops
   --
   local valid_curves = valid_curves 
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v end
   local dropped = {}
   print("BEZ loops")
   for i, bezier in pairs(temp_valid_curves) do
      local intersection  = matrix_inters[tostring(i)] or {}
      local drop = dropped[tostring(i)] or false 
      -- print("BEZ check i=" ..i) and (intersection[4]==nil)
      if not(intersection==nil) and not(intersection[2]==nil) and not(intersection[3]==nil)  and not(drop) then 
	 print("BEZ i=" ..i,"3 intersections")
	 local check = {}
	 local j1 = intersection[1][1]
	 local j2 = intersection[2][1]
	 local j3 = intersection[3][1]
	 check[tostring(i)] = true
	 check[tostring(j1)] = true
	 check[tostring(j2)] = true
	 check[tostring(j3)] = true
	 print("BEZ j1="..j1,"j2="..j2,"j3="..j3)
	 local intersection1 = matrix_inters[tostring(j1)] 
	 local intersection2 = matrix_inters[tostring(j2)] 
	 local intersection3 = matrix_inters[tostring(j3)] 

	 -- print("BEZ check j3="..j3, not(intersection3==nil),  not(intersection3[2]==nil), (intersection3[3]==nil))
	 -- j1 has 2 intersections and can be remove to open the  loop

	 print("BEZ check[tostring(i="..i..")]=",check[tostring(i)])
	 print("BEZ check[tostring(j1="..j2..")]=",check[tostring(j1)])
	 print("BEZ check[tostring(j2="..j2..")]=",check[tostring(j2)])
	 print("BEZ check[tostring(j3="..j3..")]=",check[tostring(j3)])
	 
	 
	 print("BEZ intersection1=",intersection1)
	 print("BEZ intersection2=",intersection2)
	 print("BEZ intersection3=",intersection3)
	 

	 


	 if not(intersection1==nil) and not(intersection1[2]==nil) and (intersection1[3]==nil) then 
	    print("BEZ check[tostring(intersection1[1][1])] and  check[tostring(intersection1[2][1])]",check[tostring(intersection1[1][1])] and  check[tostring(intersection1[2][1])])
	    if check[tostring(intersection1[1][1])] and  check[tostring(intersection1[2][1])] then 
	       dropped[tostring(j1)] = true 
	    end
	 end
	 if not(intersection2==nil) and not(intersection2[2]==nil) and (intersection2[3]==nil) then 
	    print("BEZ check[tostring(intersection2[1][1])] and  check[tostring(intersection2[2][1])] ",check[tostring(intersection2[1][1])] and  check[tostring(intersection2[2][1])] )
	    if check[tostring(intersection2[1][1])] and  check[tostring(intersection2[2][1])] then 
	       dropped[tostring(j2)] = true 
	    end
	 end
	 if not(intersection3==nil) and not(intersection3[2]==nil) and (intersection3[3]==nil) then 
	    print("BEZ check[tostring(intersection3[1][1])] and  check[tostring(intersection3[2][1])] ",check[tostring(intersection3[1][1])] and  check[tostring(intersection3[2][1])] )
	    if check[tostring(intersection3[1][1])] and  check[tostring(intersection3[2][1])] then 
	       dropped[tostring(j3)] = true 
	    end
	 end
      end
   end
   valid_curves = {}
   for k,v in pairs(temp_valid_curves) do 
      if not(dropped[tostring(k)]) then
	 local intersection  = matrix_inters[tostring(k)] or {}
	 local temp = {}
	 valid_curves[k] = v 
	 for _,v in ipairs( intersection) do 
	    if not(dropped[tostring(v[1])]) then 
	       temp[#temp+1] = {v[1],v[2],v[3]}
	    end
	 end
	 matrix_inters[tostring(k)] = temp 
      else
	 matrix_inters[tostring(k)] = nil
	 print("BEZ k="..k.." cutted")
      end
   end
   print("BEZ loops end")
   return valid_curves,matrix_inters
end



local function _print_curve_intersections(label,curves,matrix_inters,i)
   local label = label or ''
   print("BEZ _print_curve_intersections")
   --print("BEZ #curves="..#curves)
   if i ==  nil then 
      for i, bezier in pairs(curves) do
	 print()
	 print("BEZ "..label .." i=" .. i)
	 local intersection  = matrix_inters[tostring(i)] or {}
	 for _,v in ipairs( intersection) do print(string.format("BEZ " ..label .." all intersections of i=%s: j=%s ,t=%s, u=%s",i,v[1],v[2],v[3])) end 
      end
   else
      print("BEZ "..label .." i=" .. i,"type(i)="..type(i))
      local intersection  = matrix_inters[tostring(i)] or {}
      for _,v in ipairs( intersection) do print(string.format("BEZ " ..label .." all intersections of i=%s: j=%s ,t=%s, u=%s",i,v[1],v[2],v[3])) end 
   end
end



local function _check_pen_outside_function(v,x,y)
   local xq, xr = v[2], v[3]
   local ok0 = 0
   local ok1 = 0
   local ok2 = 0
   local ok_hole = 0
   local X
   print("BEZ _check_pen_outside_function x=".. x .. " y=" ..y.." " .. v[1])
   
   X = x
   if not(X ==(0.0+xr[#xr][1])) and not(X ==(0.0+xr[1][1])) then 
      for j=1,#xr-1 do  if   xr[j][3]>0 and (xr[j][1]+0.0 <= X) and (X<xr[j+1][1]+0.0) then ok0 = 1;  break end     end
   end
   X = x + 0.5 
   if not(X ==(0.0+xr[#xr][1])) and not(X ==(0.0+xr[1][1])) then 
      for j=1,#xr-1 do  if   xr[j][3]>0 and (xr[j][1]+0.0 <= X) and (X<xr[j+1][1]+0.0) then ok1 = 1;  break end     end
   end
   X = x -0.5
   if not(X ==(0.0+xr[#xr][1])) and not(X ==(0.0+xr[1][1])) then 
      for j=1,#xr-1 do  if   xr[j][3]>0 and (xr[j][1]+0.0 <= X) and (X<xr[j+1][1]+0.0) then ok2 = 1;  break end     end
   end
   print(string.format("BEZ _check_pen_outside_function ok0=%s, ok1=%s, ok2=%s", ok0,ok1,ok2))
   local res 
   if (ok0==0) and (ok1==0) and (ok2==0) then
      -- point is not into the edge structure
      res = 0
   else 
      -- point is  into the edge structure
      res = 1
   end
   return res 
end




local function _check_pen_function(v,x,y)
   local xq, xr = v[2], v[3]
   local ok0 = 0
   local ok1 = 0
   local ok2 = 0
   local ok_hole = 0
   local X
   -- print("BEZ _check_function x=".. x .. " y=" ..y.." " .. v[1])
   
   X = x
   if not(X ==(0.0+xr[#xr][1])) and not(X ==(0.0+xr[1][1])) then 
      for j=1,#xr-1 do  if   xr[j][3]>0 and (xr[j][1]+0.0 <= X) and (X<xr[j+1][1]+0.0) then ok0 = 1;  break end     end
   end
   X = x + 0.5 
   if not(X ==(0.0+xr[#xr][1])) and not(X ==(0.0+xr[1][1])) then 
      for j=1,#xr-1 do  if   xr[j][3]>0 and (xr[j][1]+0.0 <= X) and (X<xr[j+1][1]+0.0) then ok1 = 1;  break end     end
   end
   X = x -0.5
   if not(X ==(0.0+xr[#xr][1])) and not(X ==(0.0+xr[1][1])) then 
      for j=1,#xr-1 do  if   xr[j][3]>0 and (xr[j][1]+0.0 <= X) and (X<xr[j+1][1]+0.0) then ok2 = 1;  break end     end
   end
   -- print(string.format("BEZ _check_function ok0=%s, ok1=%s, ok2=%s", ok0,ok1,ok2))

   if (ok0==1) and (ok1==1) and (ok2==1) then
      return 1,ok0,ok1,ok2
   else 
      -- point can be outside (ie not "just near" the frontier or on the frontier) 
      X = x
      -- the simplest case: we have a continuos row from xr[1][1] to xr[#xr][1]
      if (math.ceil(X) +1 < 0+xr[1][1]) or (0.0+xr[#xr][1] < math.floor(X) -1 ) then 
	 return 0,-1000,-1000,-1000
      end
      -- we may have holes inside the row
      --print("BEZ check hole")
      ok_hole = 0
      for j=1,#xr-1 do 
	 if xr[j][3]==0 and ( (0+xr[j][1]< math.floor(X)-1) and ( math.ceil(X)+1< 0+xr[j+1][1]))  then ok_hole = 1;break;end;end
      --print("BEZ check hole="..ok_hole)
      if ok_hole==1 then
	 return 0,-1000,-1000,-1000
      else -- point is on the frontier, or near it
	 return 0,ok0,ok1,ok2
      end
   end
end


local function _check_function(v,x,y)
   local xq, xr = v[2], v[3]
   local ok0 = 0
   local ok1 = 0
   local ok2 = 0
   local ok_hole = 0
   local X
   --print("BEZ _check_function ".. x .. " " ..y.." " .. v[1])
   
   X = x
   if not(X ==(0.0+xr[#xr][1])) and not(X ==(0.0+xr[1][1])) then 
      for j=1,#xr-1 do  if   xr[j][3]>0 and (xr[j][1]+0.0 <= X) and (X<xr[j+1][1]+0.0) then ok0 = 1;  break end     end
   end
   X = x + 0.5 
   if not(X ==(0.0+xr[#xr][1])) and not(X ==(0.0+xr[1][1])) then 
      for j=1,#xr-1 do  if   xr[j][3]>0 and (xr[j][1]+0.0 <= X) and (X<xr[j+1][1]+0.0) then ok1 = 1;  break end     end
   end
   X = x -0.5
   if not(X ==(0.0+xr[#xr][1])) and not(X ==(0.0+xr[1][1])) then 
      for j=1,#xr-1 do  if   xr[j][3]>0 and (xr[j][1]+0.0 <= X) and (X<xr[j+1][1]+0.0) then ok2 = 1;  break end     end
   end
   --print(string.format("_check_function ok0=%s, ok1=%s, ok2=%s", ok0,ok1,ok2))

   if (ok0==1) and (ok1==1) and (ok2==1) then
      return 1,ok0,ok1,ok2
   else 
      -- point can be outside (ie not "near" the frontier or on the frontier) 
      X = x
      -- the simplest case: we have a continuos row from xr[1][1] to xr[#xr][1]
      if (math.ceil(X) +1 < 0+xr[1][1]) or (0.0+xr[#xr][1] < math.floor(X) -1 ) then 
	 return 0,-1000,-1000,-1000
      end
      -- we may have holes inside the row
      --print("BEZ check hole")
      ok_hole = 0
      for j=1,#xr-1 do 
	 if xr[j][3]==0 and ( (0+xr[j][1]< math.floor(X)-1) and ( math.ceil(X)+1< 0+xr[j+1][1]))  then ok_hole = 1;break;end;end
      --print("BEZ check hole="..ok_hole)
      if ok_hole==1 then
	 return 0,-1000,-1000,-1000
      else -- point is on the frontier, or near it
	 return 0,ok0,ok1,ok2
      end
   end
end




local function _check_pen_point_outside(char,p,offset)
   local x,y 
   local px,py
   local w
   local f = mflua.print_specification.outfile1
   local L,bit,values,index
   local edges = char['edges']
   local ye,v,x_off,y_off
   local ye_map = {}
   -- local J=0
   local coll_ind = {}
   local Yf,Yfs

   print("BEZ _check_pen_point_outside BEGIN")

   ye     = edges[1][1]
   x_off  = edges[1][2]
   y_off  = edges[1][3]
   ye_map = char['edges_map']

   w=string.gmatch(p,"[-0-9.]+") px,py=w(),w()
   w=string.gmatch(offset,"[-0-9.]+"); xo,yo=w(),w()
   x = px
   y = py
   x=x +xo
   y=y +yo
   local ok,Y,X, ok1,ok2,ok3 
   local xq, xr 
   local t_prev = 0
   local check_X,check_Y , cond 
   Y=y+ y_off 
   X=x+ x_off 
   ok1 = -1
   ok2 = -1
   ok3 = -1
   check_X,check_Y = math.abs(x-math.floor(x)),math.abs(y-math.floor(y))
   --
   Yf=math.floor(Y)
   Yfs = tostring(Yf)
   ok=-1
   --write("%% RULES\n")
   --write(string.format("draw (%s,%s) -- (%s,%s) withpen pencircle scaled 0.01pt withcolor red ;\n",0,y,100,y)) 
   print("BEZ Yfs="..Yfs,ye_map[Yfs],ye[ye_map[Yfs]])
   --write(string.format("draw (%s,%s) -- (%s,%s) withpen pencircle scaled 0.01pt withcolor blue ;\n",0,Yfs,100,Yfs)) 
   if ok == -1 and not(ye_map[Yfs]==nil) and not(ye[ye_map[Yfs]]==nil) then 
      v = ye[ye_map[Yfs]]
      ok1  = _check_pen_outside_function(v,X,Y) 
      ok = ok1
   end
   --
   Yfs = tostring(Yf-1)
   print("BEZ Yfs="..Yfs,ye_map[Yfs],ye[ye_map[Yfs]])
   --write(string.format("draw (%s,%s) -- (%s,%s) withpen pencircle scaled 0.01pt withcolor blue ;\n",0,Yfs,100,Yfs)) 
   --print(string.format("BEZ Y-math.floor(Y) <=0.5?%s,=%s",tostring(Y-math.floor(Y) <=0.5),Y-math.floor(Y)))
   if ok ~= 1 and Y-math.floor(Y) <=0.5 and  not(ye_map[Yfs]==nil) and not(ye[ye_map[Yfs]]== nil) then 
      v = ye[ye_map[Yfs]]
      ok2 = _check_pen_outside_function(v,X,Y)
      ok = ok2
   end
   --
   Yfs = tostring(Yf+1)
   print("BEZ Yfs="..Yfs,ye_map[Yfs],ye[ye_map[Yfs]])
   --f:write(string.format("draw (%s,%s) -- (%s,%s) withpen pencircle scaled 0.01pt withcolor blue ;\n",0,Yfs,100,Yfs)) 
   --print(string.format("BEZ Y-math.floor(Y) >0.5?%s,=%s",tostring(Y-math.floor(Y) >0.5),Y-math.floor(Y)))
   if ok ~= 1 and Y-math.floor(Y) >0.5 and  not(ye_map[Yfs]==nil) and not(ye[ye_map[Yfs]]== nil) then 
      v = ye[ye_map[Yfs]]
      ok3 = _check_pen_outside_function(v,X,Y)
      ok = ok3
   end
   --
   print("BEZ _check_pen_point_outside ok="..ok,"ok1="..ok1,"ok2="..ok2,"ok3="..ok3)
   print(string.format("BEZ x=%s,x_off=%s,y=%s,y_off=%s,X=%s,Y=%s",
		       x,x_off,y,y_off,X,Y))

   print("BEZ _check_pen_point_outside END")
   return ok
end


local function _check_single(char,p,offset)
   local x,y 
   local px,py
   local w
   local f = mflua.print_specification.outfile1
   local L,bit,values,index
   local edges = char['edges']
   local ye,v,x_off,y_off
   local nr_ok=0
   local ye_map = {}
   -- local J=0
   local coll_ind = {}
   local Yf,Yfs

   --print("BEZ check single BEGIN")

   ye     = edges[1][1]
   x_off  = edges[1][2]
   y_off  = edges[1][3]
   ye_map = char['edges_map']



   w=string.gmatch(p,"[-0-9.]+") px,py=w(),w()
   w=string.gmatch(offset,"[-0-9.]+"); xo,yo=w(),w()
   x = px
   y = py
   x=x +xo
   y=y +yo
   local ok,Y,X, ok1,ok2,ok3 
   local xq, xr 
   local t_prev = 0
   local check_X,check_Y , cond 
   Y=y+ y_off 
   X=x+ x_off 
   ok1 = -1
   ok2 = -1
   ok3 = -1
   check_X,check_Y = math.abs(x-math.floor(x)),math.abs(y-math.floor(y))
   --
   Yf=math.floor(Y)
   Yfs = tostring(Yf)
   ok=0
   if ok == 0 and not(ye_map[Yfs]==nil) and not(ye[ye_map[Yfs]]==nil) then 
      v = ye[ye_map[Yfs]]
      ok1  = _check_function(v,X,Y) 
      ok = ok1
   end
   --
   Yfs = tostring(Yf-1)
   --print(string.format("BEZ Y-math.floor(Y) <=0.5?%s,=%s",tostring(Y-math.floor(Y) <=0.5),Y-math.floor(Y)))
   if ok == 1 and Y-math.floor(Y) <=0.5 and  not(ye_map[Yfs]==nil) and not(ye[ye_map[Yfs]]== nil) then 
      v = ye[ye_map[Yfs]]
      ok2 = _check_function(v,X,Y)
      ok = ok + ok2
   end
   --
   Yfs = tostring(Yf+1)
   --print(string.format("BEZ Y-math.floor(Y) >0.5?%s,=%s",tostring(Y-math.floor(Y) >0.5),Y-math.floor(Y)))
   if ok == 1 and Y-math.floor(Y) >0.5 and  not(ye_map[Yfs]==nil) and not(ye[ye_map[Yfs]]== nil) then 
      v = ye[ye_map[Yfs]]
      ok3 = _check_function(v,X,Y)
      ok = ok + ok3
   end
   --
   --print("BEZ check single",ok,ok1,ok2,ok3)
  -- print(string.format("BEZ x=%s,x_off=%s,y=%s,y_off=%s,X=%s,Y=%s",
	--		  x,x_off,y,y_off,X,Y))

   if ok ==2 then 
      nr_ok = nr_ok+1
      f:write(string.format("draw (%s,%s) withpen pencircle scaled 0.4pt withcolor (1,0.1,0.1) ;\n",x,y)) 
   end
   if ok < 2 then 
      coll_ind[#coll_ind+1] = index
      f:write(string.format("draw (%s,%s) withpen pencircle scaled 0.4pt withcolor (0.1,1,0.1) ;\n",x,y)) 
      --f:write(string.format("label(\"%s,%s\",(%s+0.5,%s+0.5)) ;\n",x,y,x,y)) 
   end
   --print("BEZ check single END")
   return nr_ok, 1
end





local function _check_pen_point(char,p,c1,c2,q,offset)
   --must do a deep clean up !!
   local x,y 
   local px,py,c1x,c1y,c2x,c2y,qx,qy
   local w
   local f = mflua.print_specification.outfile1
   local L,bit,values,index
   local max_values = 0
   local edges = char['edges']
   local ye,lm,lq,v,x_off,y_off
   local nr_ok=0
   local coll_ind = {}
   local coll_ind_ii = {}
   local coll_ind_temp = {}
   local ye_map = {}
   local red_flag,last_flag_index = -1,-1   


   local cnt = mflua._check_point_temp_cnt1  or 0
   cnt = cnt +1 
   --print("BEZ  BEGIN check_point "..cnt .." *************************************")
   ye     = edges[1][1]
   x_off  = edges[1][2]
   y_off  = edges[1][3]
   ye_map = char['edges_map'] 



   w=string.gmatch(p,"[-0-9.]+") px,py=w(),w()
   w=string.gmatch(c1,"[-0-9.]+"); c1x,c1y=w(),w()
   w=string.gmatch(c2,"[-0-9.]+"); c2x,c2y=w(),w()
   w=string.gmatch(q,"[-0-9.]+"); qx,qy=w(),w()
   w=string.gmatch(offset,"[-0-9.]+"); xo,yo=w(),w()
   bit=mflua.bit  or nil 
   L=math.ldexp(1,bit)
   values={0};for i=1,L-1 do values[i+1]= math.ldexp(i,-bit) end; values[#values+1]=1
   max_values = #values 
   for index,t in ipairs(values) do
      x,y = bez({px,py},{c1x,c1y},{c2x,c2y},{qx,qy},t)
      x=x +xo
      y=y +yo
      local ok,Y,X, ok1,ok2,ok3,ok4,outside
      local outside, out1,out2,ou3
      local xq, xr 
      local t_prev = 0
      local check_X,check_Y , cond 
      local Yf,Yfs

      Y=y+ y_off 
      X=x+ x_off 
      ok1 = -1
      ok2 = -1
      ok3 = -1
      outside = 0
      out1,out2,out3 = 0,0,0


      check_X,check_Y = math.abs(x-math.floor(x)),math.abs(y-math.floor(y))
      -- print("BEZ",check_X,check_Y,(check_X<=0.1) and (check_Y<=0.1))

      --cond =  (check_X<=0.1) and (check_Y<=0.1)
      --cond =  (check_Y<=0.1) 
      --cond =  false
      cond =  true

      Yf=math.floor(Y+0*0.5)
      Yfs = tostring(Yf)
      ok=0
      --print(string.format("BEZ x=%s,x_off=%s,y=%s,y_off=%s,X=%s,Y=%s,Yfs=%s,i=%s",
	--		  	  x,x_off,y,y_off,X,Y,Yfs,index))
      -- 
      if ok == 0 and not(ye_map[Yfs]==nil) and not(ye[ye_map[Yfs]]==nil) then 
	 --print("BEZ check Yfs",Yfs)
	 v = ye[ye_map[Yfs]]
	 ok1,out1  = _check_function(v,X,Y) 
	 ok = ok1
	 outside = out1
      end
      --
      Yfs = tostring(Yf-1)
      if ok == 1 and Y-math.floor(Y) <=0.5 and  not(ye_map[Yfs]==nil) and not(ye[ye_map[Yfs]]== nil) then 
	 --print("BEZ check Yfs-1",Yfs)
	 v = ye[ye_map[Yfs]]
	 ok2,out2 = _check_function(v,X,Y)
	 ok = ok + ok2
	 outside= outside + out2
      end
      --
      Yfs = tostring(Yf+1)
      if ok == 1 and Y-math.floor(Y) >0.5 and not(ye_map[Yfs]==nil) and not(ye[ye_map[Yfs]]==nil) then 
	 --print("BEZ check Yfs+1",Yfs)
	 v = ye[ye_map[Yfs]]
	 ok3,out3 = _check_function(v,X,Y)
	 ok = ok + ok3
	 outside= outside + out3
      end
      -- print("BEZ OK="..ok)
      if ok ==2 then -- the point is internal
	 nr_ok = nr_ok+1
	 f:write(string.format("draw (%s,%s) withpen pencircle scaled 0.01pt withcolor red ;\n",x,y)) 
	 -- f:write(string.format("label(\"%s\",(%s+0.5,%s+0.5)) ;\n",index,x,y)) 
	 if red_flag==-1 then -- first time
	    red_flag = 1
	    coll_ind[#coll_ind+1] = index
	    coll_ind_temp[1] = false
	    --print("BEZ (1) RED:first time :#coll_ind=" .. #coll_ind," index="..index ..'RED')
	 elseif red_flag==0 then 
	    red_flag = 1
	    coll_ind[#coll_ind+1] = index
	    coll_ind_temp[#coll_ind_temp+1] = false
	    -- print("BEZ (1) RED: prev red_flag==0 :#coll_ind=" .. #coll_ind," index="..index..'RED')
	    --f:write(string.format("%% #coll_ind=%s, index=%s\n",coll_ind,index))
	 elseif  red_flag==1 then 
	    coll_ind[#coll_ind+1] = index
	    coll_ind_temp[#coll_ind_temp+1] = false
	    -- print("BEZ (1) RED: prev red_flag==1 :#coll_ind=" .. #coll_ind," index="..index..'RED')
	 end
      end
      --
      if ok < 2 then -- the point is external or on the frontier
	 --print(string.format("\nBEZ BEGIN ok=%s,ok1=%s,ok2=%s,ok3=%s",ok,ok1,ok2,ok3))
	 --print(string.format("BEZ BEGIN outside=%s,out1=%s,out2=%s,out3=%s",outside,out1,out2,out3)) 
	 Yfs = tostring(Yf)
	 --print(string.format("BEZ the point is external or on the frontier x=%s,x_off=%s,y=%s,y_off=%s,X=%s,Y=%s,Yfs=%s,ye_map[Yfs]=%s",
	--		     x,x_off,y,y_off,X,Y,Yfs,ye_map[Yfs] or 'nil'))
	 v = (ye_map[Yfs]~= nil) and  ye[ye_map[Yfs]]  or nil
	 if not(v==nil) then 
	    xr = v[3]
	    ok1,out1  = _check_pen_function(v,X,Y) 
	    --for j=1,#xr-1 do  
	       --print(string.format("X=%s,x=%s,Y=%s,y=%s,Row=%s,xr[j][3]=%s,xr[j][1]=%s ,xr[j+1][1]=%s",
		--		    X,   x,   Y,   y,   v[1],  xr[j][3],   xr[j][1],    xr[j+1][1]   )) 
	    --end; 
	    --print(_check_function(v,X,Y))
	    --print()
	 else
	    out1 = -1000
	 end
	 --
	 Yfs = tostring(Yf-1)
	 --print(string.format("BEZ x=%s,x_off=%s,y=%s,y_off=%s,X=%s,Y=%s,Yfs=%s,ye_map[Yfs]=%s",
		--	     x,x_off,y,y_off,X,Y,Yfs,ye_map[Yfs] or 'nil'))
	 v = (ye_map[Yfs]~= nil) and ye[ye_map[Yfs]] or nil 
	 if not(v==nil) then 
	    xr = v[3]
	    ok1,out2  = _check_pen_function(v,X,Y) 
	    --for j=1,#xr-1 do  
	       --print(string.format("X=%s,x=%s,Y=%s,y=%s,Row=%s,xr[j][3]=%s,xr[j][1]=%s ,xr[j+1][1]=%s",
		--		    X,   x,   Y,   y,   v[1],  xr[j][3],   xr[j][1],    xr[j+1][1]   )) 
	    --end; 
	    --print(_check_function(v,X,Y))
	    --print()
	 else
	    out2 = -1000
	 end
	 --
	 Yfs = tostring(Yf+1)
	 --print(string.format("BEZ x=%s,x_off=%s,y=%s,y_off=%s,X=%s,Y=%s,Yfs=%s,ye_map[Yfs]=%s",
		--	     x,x_off,y,y_off,X,Y,Yfs,ye_map[Yfs] or 'nil'))
	 v = (ye_map[Yfs]~= nil) and ye[ye_map[Yfs]] or nil
	 if not(v==nil) then 
	    xr = v[3]
	    ok1,out3  = _check_pen_function(v,X,Y) 
	    --for j=1,#xr-1 do  
	       --print(string.format("X=%s,x=%s,Y=%s,y=%s,Row=%s,xr[j][3]=%s,xr[j][1]=%s ,xr[j+1][1]=%s",
			--	    X,   x,   Y,   y,   v[1],  xr[j][3],   xr[j][1],    xr[j+1][1]   )) 
	    --end; 
	    --print(_check_function(v,X,Y))
	    --print()
	 else
	    out3 = -1000
	 end
	 if (out1+out2+out3)<=-3000 then 
	    --print("BEZ RED x="..x,"y="..y,"X="..X,"Y="..Y)
	    f:write(string.format("draw (%s,%s) withpen pencircle scaled 0.1pt withcolor (0.4,0,0) ;\n",x,y)) 
	    f:write(string.format("%%label(\"%s :Y=%s\",(%s+0.5,%s+0.5)) ;\n",index,Y,x,y)) 
	    if red_flag==-1 then -- first time 
	       red_flag = 1
	       coll_ind[#coll_ind+1] = index 
	       coll_ind_temp[1] = false
	       -- print("BEZ (2) RED:first time :#coll_ind=" .. #coll_ind," index="..index..'RED')
	    elseif red_flag==0 then -- first was valid point
	       --print("BEZ transition 1 to 0 index=" ..  index)
	       red_flag = 1
	       coll_ind[#coll_ind+1] = index 
	       coll_ind_temp[#coll_ind_temp+1] = false
	       -- print("BEZ (2) RED: first was a valid point :#coll_ind=" .. #coll_ind," index="..index..'RED')
	    end
	 else
	    f:write(string.format("draw (%s,%s) withpen pencircle scaled 0.1pt withcolor (0,0.8,0.8) ;\n",x,y)) 
	    -- f:write(string.format("label(\"%s\",(%s+0.5,%s+0.5)) ;\n",index,x,y)) 
	    if red_flag==-1 then -- first time 
	       red_flag = 0 
	    elseif red_flag==1 then -- prev. point was an internal point
	       --print("BEZ transition 1 to 0 index=" ..  index)
	       red_flag = 0
	       -- if (#coll_ind > 0) and (coll_ind[#coll_ind] <  (index -1) ) and  index > 1 then 
	       -- 	  print("BEZ (#coll_ind > 0) and (coll_ind[#coll_ind] <  (index -1) ) and  index > 1 is true" )
	       -- 	  print("BEZ :coll_ind[#coll_ind]="..coll_ind[#coll_ind])
	       -- 	  coll_ind[#coll_ind+1] = index -1 
	       -- 	  print("BEZ add index-1:coll_ind[#coll_ind]="..coll_ind[#coll_ind])
	       -- end 
	    end
	    coll_ind[#coll_ind+1] = index
	    coll_ind_temp[#coll_ind_temp+1] = true
	    -- print("BEZ BLUE prev point was internal:#coll_ind="..#coll_ind,' index='..index..'BLUE')
	 end
      end
-- end
   end
   local coll_ind_ii = {}
   local prev_v =coll_ind_temp[1] 
   -- prev_v == true then blue point: the point is not inside. Also: not(prev_v) == false
   -- prev_v == false then red point: the point is inside. Also not(prev_v) == true
   --
   -- TODO : tie the tt bound to a deltay=2 and/or deltax=2 pixel so we can use a lower bit (bit=4)
   -- 
   for ii,v in ipairs(coll_ind_temp) do 
      if v then -- point is not inside  (blue point) 
	 if not(prev_v) then -- prev_v  is  inside (red point) 
	    -- local x_ii,y_ii 
	    -- x_ii,y_ii = bez({px,py},{c1x,c1y},{c2x,c2y},{qx,qy},values[ii])
	    -- for tt=ii-1,2,-1 do 
	    --    local x_tt,y_tt 
	    --    x_tt,y_tt = bez({px,py},{c1x,c1y},{c2x,c2y},{qx,qy},values[tt])
	    --    local m= mflua.modul_vec({x_ii,y_ii},{x_tt,y_tt})

	    --    if m <2 then 
	    --  	  --coll_ind_ii[#coll_ind_ii+1] = ii-tt 
	    -- 	  print("BEZ m="..m, "ii="..ii, "tt="..tt,"ii-tt="..ii-tt)
	    --    end
	    -- end
	     for tt=4,2,-1 do 
	        if ii-tt >0 then 
	     	  coll_ind_ii[#coll_ind_ii+1] = ii-tt 
	        end
	     end
	    coll_ind_ii[#coll_ind_ii+1] = ii-1 
	 end
	 coll_ind_ii[#coll_ind_ii+1] = ii 
      else -- v == false,  the point is inside (red point) 
	 if prev_v then  -- prev_== true, point is not inside 
	    coll_ind_ii[#coll_ind_ii+1] = ii 
	    -- tt bound = 2
	    for tt=1,2  do 
	       if ii + tt <= max_values then 
		  coll_ind_ii[#coll_ind_ii+1] = ii +tt
	       end
	    end
	 end
      end
      prev_v = v
   end       
   -- for ii,v in ipairs(coll_ind_ii) do print("BEZ char[index]=" ..char['index'], "coll_ind_ii ii=" ..ii ,"v="..v) end    
   -- -- for ii,v in ipairs(coll_ind) do print("BEZ char[index]=" ..char['index'], "coll_ind ii=" ..ii ,"v="..v) end    
   -- print("BEZ END*************************************")
   --print()
   mflua._check_point_temp_cnt1 = cnt 
   return nr_ok, #values,coll_ind_ii
  --return nr_ok, J
end






local function _check_point(char,p,c1,c2,q,offset)
   --must do a deep clean up !!
   local x,y 
   local px,py,c1x,c1y,c2x,c2y,qx,qy
   local w
   local f = mflua.print_specification.outfile1
   local L,bit,values,index
   local max_values = 0
   local edges = char['edges']
   local ye,lm,lq,v,x_off,y_off
   local nr_ok=0
   local coll_ind = {}
   local coll_ind_ii = {}
   local coll_ind_temp = {}
   local ye_map = {}
   local red_flag,last_flag_index = -1,-1   


   local cnt = mflua._check_point_temp_cnt1  or 0
   cnt = cnt +1 
   --print("BEZ  BEGIN check_point "..cnt .." *************************************")
   ye     = edges[1][1]
   x_off  = edges[1][2]
   y_off  = edges[1][3]
   ye_map = char['edges_map'] 

   --for i,v in ipairs(ye) do
   --   ye_map[v[1]] = i 
   --   print("BEZ",i,v[1],#v[3],ye_map[v[1]])
   --end

   w=string.gmatch(p,"[-0-9.]+") px,py=w(),w()
   w=string.gmatch(c1,"[-0-9.]+"); c1x,c1y=w(),w()
   w=string.gmatch(c2,"[-0-9.]+"); c2x,c2y=w(),w()
   w=string.gmatch(q,"[-0-9.]+"); qx,qy=w(),w()
   w=string.gmatch(offset,"[-0-9.]+"); xo,yo=w(),w()
   bit=mflua.bit  or nil 
   L=math.ldexp(1,bit)
   values={0};for i=1,L-1 do values[i+1]= math.ldexp(i,-bit) end; values[#values+1]=1
   max_values = #values 
   for index,t in ipairs(values) do
      x,y = bez({px,py},{c1x,c1y},{c2x,c2y},{qx,qy},t)
      x=x +xo
      y=y +yo
      local ok,Y,X, ok1,ok2,ok3,ok4,outside
      local outside, out1,out2,ou3
      local xq, xr 
      local t_prev = 0
      local check_X,check_Y , cond 
      local Yf,Yfs

      Y=y+ y_off 
      X=x+ x_off 
      ok1 = -1
      ok2 = -1
      ok3 = -1
      outside = 0
      out1,out2,out3 = 0,0,0


      check_X,check_Y = math.abs(x-math.floor(x)),math.abs(y-math.floor(y))
      -- print("BEZ",check_X,check_Y,(check_X<=0.1) and (check_Y<=0.1))

      --cond =  (check_X<=0.1) and (check_Y<=0.1)
      --cond =  (check_Y<=0.1) 
      --cond =  false
      cond =  true

-- if cond then 
      --J=J+1
      Yf=math.floor(Y)
      Yfs = tostring(Yf)
      ok=0
      --print(string.format("BEZ x=%s,x_off=%s,y=%s,y_off=%s,X=%s,Y=%s,Yfs=%s,i=%s",
		--	  x,x_off,y,y_off,X,Y,Yfs,index))
      -- 
      if ok == 0 and not(ye_map[Yfs]==nil) and not(ye[ye_map[Yfs]]==nil) then 
	 --print("BEZ check Yfs",Yfs)
	 v = ye[ye_map[Yfs]]
	 ok1,out1  = _check_function(v,X,Y) 
	 ok = ok1
	 outside = out1
      end
      --
      Yfs = tostring(Yf-1)
      if ok == 1 and Y-math.floor(Y) <=0.5 and  not(ye_map[Yfs]==nil) and not(ye[ye_map[Yfs]]== nil) then 
	 --print("BEZ check Yfs-1",Yfs)
	 v = ye[ye_map[Yfs]]
	 ok2,out2 = _check_function(v,X,Y)
	 ok = ok + ok2
	 outside= outside + out2
      end
      --
      Yfs = tostring(Yf+1)
      if ok == 1 and Y-math.floor(Y) >0.5 and not(ye_map[Yfs]==nil) and not(ye[ye_map[Yfs]]==nil) then 
	 --print("BEZ check Yfs+1",Yfs)
	 v = ye[ye_map[Yfs]]
	 ok3,out3 = _check_function(v,X,Y)
	 ok = ok + ok3
	 outside= outside + out3
      end
      -- print("BEZ OK="..ok)
      if ok ==2 then -- the point is internal
	 nr_ok = nr_ok+1
	 f:write(string.format("draw (%s,%s) withpen pencircle scaled 0.1pt withcolor red ;\n",x,y)) 
	 -- f:write(string.format("label(\"%s\",(%s+0.5,%s+0.5)) ;\n",index,x,y)) 
	 if red_flag==-1 then -- first time
	    red_flag = 1
	    coll_ind[#coll_ind+1] = index
	    coll_ind_temp[1] = false
	    --print("BEZ (1) RED:first time :#coll_ind=" .. #coll_ind," index="..index ..'RED')
	 elseif red_flag==0 then 
	    red_flag = 1
	    coll_ind[#coll_ind+1] = index
	    coll_ind_temp[#coll_ind_temp+1] = false
	    -- print("BEZ (1) RED: prev red_flag==0 :#coll_ind=" .. #coll_ind," index="..index..'RED')
	    --f:write(string.format("%% #coll_ind=%s, index=%s\n",coll_ind,index))
	 elseif  red_flag==1 then 
	    coll_ind[#coll_ind+1] = index
	    coll_ind_temp[#coll_ind_temp+1] = false
	    -- print("BEZ (1) RED: prev red_flag==1 :#coll_ind=" .. #coll_ind," index="..index..'RED')
	 end
      end
      --
      if ok < 2 then -- the point is external or on the frontier
	 --print(string.format("\nBEZ BEGIN ok=%s,ok1=%s,ok2=%s,ok3=%s",ok,ok1,ok2,ok3))
	 --print(string.format("BEZ BEGIN outside=%s,out1=%s,out2=%s,out3=%s",outside,out1,out2,out3)) 
	 Yfs = tostring(Yf)
	 --print(string.format("BEZ x=%s,x_off=%s,y=%s,y_off=%s,X=%s,Y=%s,Yfs=%s,ye_map[Yfs]=%s",
		--	     x,x_off,y,y_off,X,Y,Yfs,ye_map[Yfs] or 'nil'))
	 v = (ye_map[Yfs]~= nil) and  ye[ye_map[Yfs]]  or nil
	 if not(v==nil) then 
	    xr = v[3]
	    ok1,out1  = _check_function(v,X,Y) 
	    --for j=1,#xr-1 do  
	       --print(string.format("X=%s,x=%s,Y=%s,y=%s,Row=%s,xr[j][3]=%s,xr[j][1]=%s ,xr[j+1][1]=%s",
		--		    X,   x,   Y,   y,   v[1],  xr[j][3],   xr[j][1],    xr[j+1][1]   )) 
	    --end; 
	    --print(_check_function(v,X,Y))
	    --print()
	 else
	    out1 = -1000
	 end
	 --
	 Yfs = tostring(Yf-1)
	 --print(string.format("BEZ x=%s,x_off=%s,y=%s,y_off=%s,X=%s,Y=%s,Yfs=%s,ye_map[Yfs]=%s",
		--	     x,x_off,y,y_off,X,Y,Yfs,ye_map[Yfs] or 'nil'))
	 v = (ye_map[Yfs]~= nil) and ye[ye_map[Yfs]] or nil 
	 if not(v==nil) then 
	    xr = v[3]
	    ok1,out2  = _check_function(v,X,Y) 
	    --for j=1,#xr-1 do  
	       --print(string.format("X=%s,x=%s,Y=%s,y=%s,Row=%s,xr[j][3]=%s,xr[j][1]=%s ,xr[j+1][1]=%s",
		--		    X,   x,   Y,   y,   v[1],  xr[j][3],   xr[j][1],    xr[j+1][1]   )) 
	    --end; 
	    --print(_check_function(v,X,Y))
	    --print()
	 else
	    out2 = -1000
	 end
	 --
	 Yfs = tostring(Yf+1)
	 --print(string.format("BEZ x=%s,x_off=%s,y=%s,y_off=%s,X=%s,Y=%s,Yfs=%s,ye_map[Yfs]=%s",
		--	     x,x_off,y,y_off,X,Y,Yfs,ye_map[Yfs] or 'nil'))
	 v = (ye_map[Yfs]~= nil) and ye[ye_map[Yfs]] or nil
	 if not(v==nil) then 
	    xr = v[3]
	    ok1,out3  = _check_function(v,X,Y) 
	    --for j=1,#xr-1 do  
	       --print(string.format("X=%s,x=%s,Y=%s,y=%s,Row=%s,xr[j][3]=%s,xr[j][1]=%s ,xr[j+1][1]=%s",
			--	    X,   x,   Y,   y,   v[1],  xr[j][3],   xr[j][1],    xr[j+1][1]   )) 
	    --end; 
	    --print(_check_function(v,X,Y))
	    --print()
	 else
	    out3 = -1000
	 end
	 if (out1+out2+out3)<=-3000 then 
	    f:write(string.format("draw (%s,%s) withpen pensquare scaled 0.2pt withcolor red ;\n",x,y)) 
	    -- f:write(string.format("label(\"%s\",(%s+0.5,%s+0.5)) ;\n",index,x,y)) 
	    if red_flag==-1 then -- first time 
	       red_flag = 1
	       coll_ind[#coll_ind+1] = index 
	       coll_ind_temp[1] = false
	       -- print("BEZ (2) RED:first time :#coll_ind=" .. #coll_ind," index="..index..'RED')
	    elseif red_flag==0 then -- first was valid point
	       --print("BEZ transition 1 to 0 index=" ..  index)
	       red_flag = 1
	       coll_ind[#coll_ind+1] = index 
	       coll_ind_temp[#coll_ind_temp+1] = false
	       -- print("BEZ (2) RED: first was a valid point :#coll_ind=" .. #coll_ind," index="..index..'RED')
	    end
	 else
	    f:write(string.format("draw (%s,%s) withpen pencircle scaled 0.1pt withcolor blue ;\n",x,y)) 
	    -- f:write(string.format("label(\"%s\",(%s+0.5,%s+0.5)) ;\n",index,x,y)) 
	    if red_flag==-1 then -- first time 
	       red_flag = 0 
	    elseif red_flag==1 then -- prev. point was an internal point
	       --print("BEZ transition 1 to 0 index=" ..  index)
	       red_flag = 0
	       -- if (#coll_ind > 0) and (coll_ind[#coll_ind] <  (index -1) ) and  index > 1 then 
	       -- 	  print("BEZ (#coll_ind > 0) and (coll_ind[#coll_ind] <  (index -1) ) and  index > 1 is true" )
	       -- 	  print("BEZ :coll_ind[#coll_ind]="..coll_ind[#coll_ind])
	       -- 	  coll_ind[#coll_ind+1] = index -1 
	       -- 	  print("BEZ add index-1:coll_ind[#coll_ind]="..coll_ind[#coll_ind])
	       -- end 
	    end
	    coll_ind[#coll_ind+1] = index
	    coll_ind_temp[#coll_ind_temp+1] = true
	    -- print("BEZ BLUE prev point was internal:#coll_ind="..#coll_ind,' index='..index..'BLUE')
	 end
      end
-- end
   end
   local coll_ind_ii = {}
   local prev_v =coll_ind_temp[1] 
   -- prev_v == true then blue point: the point is not inside. Also: not(prev_v) == false
   -- prev_v == false then red point: the point is inside. Also not(prev_v) == true
   --
   -- TODO : tie the tt bound to a deltay=2 and/or deltax=2 pixel so we can use a lower bit (bit=4)
   -- 
   for ii,v in ipairs(coll_ind_temp) do 
      if v then -- point is not inside  (blue point) 
	 if not(prev_v) then -- prev_v  is  inside (red point) 
	    -- local x_ii,y_ii 
	    -- x_ii,y_ii = bez({px,py},{c1x,c1y},{c2x,c2y},{qx,qy},values[ii])
	    -- for tt=ii-1,2,-1 do 
	    --    local x_tt,y_tt 
	    --    x_tt,y_tt = bez({px,py},{c1x,c1y},{c2x,c2y},{qx,qy},values[tt])
	    --    local m= mflua.modul_vec({x_ii,y_ii},{x_tt,y_tt})

	    --    if m <2 then 
	    --  	  --coll_ind_ii[#coll_ind_ii+1] = ii-tt 
	    -- 	  print("BEZ m="..m, "ii="..ii, "tt="..tt,"ii-tt="..ii-tt)
	    --    end
	    -- end
	    -- 
	     --for tt=4,2,-1 do 
	     --   if ii-tt >0 then 
	     --	  coll_ind_ii[#coll_ind_ii+1] = ii-tt 
	     --   end
	     --end
	    coll_ind_ii[#coll_ind_ii+1] = ii-1 
	 end
	 coll_ind_ii[#coll_ind_ii+1] = ii 
      else -- v == false,  the point is inside (red point) 
	 if prev_v then  -- prev_== true, point is not inside 
	    coll_ind_ii[#coll_ind_ii+1] = ii 
	    -- tt bound = 2
	    --
	    --for tt=1,2  do 
	    --   if ii + tt <= max_values then 
	    --	  coll_ind_ii[#coll_ind_ii+1] = ii +tt
	    --   end
	    --end
	 end
      end
      prev_v = v
   end       
   -- for ii,v in ipairs(coll_ind_ii) do print("BEZ char[index]=" ..char['index'], "coll_ind_ii ii=" ..ii ,"v="..v) end    
   -- -- for ii,v in ipairs(coll_ind) do print("BEZ char[index]=" ..char['index'], "coll_ind ii=" ..ii ,"v="..v) end    
   -- print("BEZ END*************************************")
   --print()
   mflua._check_point_temp_cnt1 = cnt 
   return nr_ok, #values,coll_ind_ii
  --return nr_ok, J
end


local function _remove_isolate_path(valid_curves,matrix_inters)
   --
   -- remove isolate path
   --
   local temp_removed = {}
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v temp_removed[k]=false end
   for i, bezier in pairs(temp_valid_curves) do 
      if temp_removed[i]==false then 
	 local intersection  = matrix_inters[tostring(i)] or {}
	 local nr_inters = 0
	 for _,inters in ipairs(intersection) do  nr_inters = nr_inters +1 end
	 if nr_inters == 0 then temp_removed[i] =true  end 
      end --if temp_removed[k]==false then 
   end -- for 
   --
   local valid_curves = {}
   for k,v in pairs(temp_valid_curves) do 
      if not(temp_removed[k]) then
	 local intersection  = matrix_inters[tostring(k)] or {}
	 local temp = {}
	 valid_curves[k] = v 
	 for _,v in ipairs( intersection) do 
	    if not(temp_removed[tonumber(v[1])]) then 
	       temp[#temp+1] = {v[1],v[2],v[3]}
	    end
	 end
	 matrix_inters[tostring(k)] = temp 
      else
	 matrix_inters[tostring(k)] = nil
	 --print("BEZ k="..k.." cutted")
      end
   end
   return valid_curves,matrix_inters
end 


local function _remove_duplicate_path_I(valid_curves,matrix_inters)
   --
   -- remove duplicate path
   --
   local temp_removed = {}
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v temp_removed[k]=false end
   --local valid_curves = {}
   for i, bezier in pairs(temp_valid_curves) do 
      if temp_removed[i]==false then 
	 local intersection  = matrix_inters[tostring(i)] or {}
	 for _,inters in ipairs(intersection) do  
	    local j1,t,u= tonumber(inters[1]),inters[2],inters[3]
	    -- if t=='0' and u=='0' and temp_removed[j1]==false then -- or t=='1' and u=='1'
	    if ((t=='0' and u=='0') or (t=='1' and u=='1')) and temp_removed[j1]==false then -- or 
	       local match_1 =  {}
	       match_1[i] = true 
	       for _,inters_1 in ipairs(intersection) do match_1[tonumber(inters_1[1])]=true end
	       local match_2 =  {}
	       local intersection_2  = matrix_inters[tostring(j1)] or {}
	       for _,inters_2 in ipairs(intersection_2) do match_2[tonumber(inters_2[1])]=true end
	       local  check = true
	       for _,inters_2 in ipairs(intersection_2) do 
		  if match_1[tonumber(inters_2[1])] ==nil or not(match_1[tonumber(inters_2[1])]) then 
		     check = false
		     break
		  end
	       end
	       --print("BEZ i="..i,"on")	 
	       if check == true then 
		  temp_removed[j1] =true 
		  --print("BEZ removed duplicate j1="..j1)
	       else
		  --print("BEZ removed i="..i)
		 --temp_removed[i] =true 
	       end
	    end
	 end
      end --if temp_removed[k]==false then 
   end -- for 
   local valid_curves = {}
   for k,v in pairs(temp_valid_curves) do 
      if not(temp_removed[k]) then
	 local intersection  = matrix_inters[tostring(k)] or {}
	 local temp = {}
	 valid_curves[k] = v 
	 for _,v in ipairs( intersection) do 
	    if not(temp_removed[tonumber(v[1])]) then 
	       temp[#temp+1] = {v[1],v[2],v[3]}
	    end
	 end
	 matrix_inters[tostring(k)] = temp 
      else
	 matrix_inters[tostring(k)] = nil
	 --print("BEZ k="..k.." cutted")
      end
   end
   return valid_curves,matrix_inters
end


local function _remove_duplicate_path_II(valid_curves,matrix_inters)
   print("BEZ remove duplicate path")
   local temp_removed = {}
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v temp_removed[k]=false end
   for i, bezier in pairs(temp_valid_curves) do 
      if temp_removed[i] == false then 
	 local intersection  = matrix_inters[tostring(i)] or {}
	 local children_i =  {}
	 for _,v in ipairs( intersection) do  children_i[tonumber(v[1])] = true  end children_i[tonumber(i)] = true 
	 for _,v in ipairs( intersection) do  
	    if temp_removed[tonumber(v[1])] == false then 
	       local j =v[1]
	       local remove_node = true
	       local children_j = {}
	       intersection_j  = matrix_inters[tostring(j)] or {}
	       for _,vv in pairs( intersection_j) do  children_j[tonumber(vv[1])] = true  end children_j[tonumber(j)]=true 
	       --print("BEZ i="..i,"j="..j,#children_j,#intersection_j)
	       for ll,_ in pairs(children_j) do
		  print("BEZ i="..i,"j="..j,"ll="..ll, "children_i[ll]="..tostring(children_i[tonumber(ll)]))
		  if children_i[tonumber(ll)] == nil then 
		     remove_node = false 
		     print("BEZ cannot remove j="..j)
		     break
		  end
	       end
	       if remove_node == true then 
		  temp_removed[tonumber(j)] = true 
		  print("BEZ removed j="..j)
	       end
	    end
	 end
      end
   end
   local valid_curves = {}
   for k,v in pairs(temp_valid_curves) do 
      if not(temp_removed[tonumber(k)]) then
	 local intersection  = matrix_inters[tostring(k)] or {}
	 local temp = {}
	 valid_curves[k] = v 
	 for _,v in ipairs( intersection) do 
	    -- print("BEZ k="..k,"v]1]="..v[1],"temp_removed[tonumber(v[1])]=",temp_removed[v[1]])
	    if not(temp_removed[tonumber(v[1])]) then 
	       temp[#temp+1] = {v[1],v[2],v[3]}
	    end
	 end
	 matrix_inters[tostring(k)] = temp 
      else
	 --print("BEZ k="..k,"temp_removed[k]="..tostring(temp_removed[tostring(k)]))
	 matrix_inters[tostring(k)] = nil
      end
   end
   print("BEZ remove duplicate path end")
   return valid_curves,matrix_inters
end

local function _remove_pending_pen_path(valid_curves,matrix_inters,valid_curves_p_set)
   --
   -- remove_pending_pen_path
   -- An attempt to remove pending pen paths
   local temp_removed = {}
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v; temp_removed[k]=false end
   print("BEZ remove_pending_pen_path")
   for i, bezier in pairs(temp_valid_curves) do 
      --print("BEZ i="..i,"valid_curves_p_set[i]="..tostring(valid_curves_p_set[i]))
      --if valid_curves_p_set[i] ~=nil then 
      if valid_curves_p_set[i] ==true then 
	 print("BEZ i="..i,"valid_curves_p_set[i]="..tostring(valid_curves_p_set[i]))
	 local intersection  = matrix_inters[tostring(i)] or {}
	 local check = false 
	 for _,inters in ipairs(intersection) do  
	    local j,t,u= tonumber(inters[1]),tonumber(inters[2]),tonumber(inters[3])
	    print("BEZ math.abs(1-t)="..math.abs(1-t))
	    print("BEZ mflua.threshold_small_pen_path="..mflua.threshold_small_pen_path)
	    if (math.abs(1-t) < mflua.threshold_small_pen_path) then -- or  (math.abs(t) < mflua.threshold_small_pen_path) then 
	       check = true
	    else
	       check = false
	       break
	    end
	 end -- for _,inters in ipairs(intersection) do  
	 print("BEZ i="..i,"check="..tostring(check))
	 if check == true then 
	    temp_removed[i] = true 
	 else
	    temp_removed[i] = false
	 end
      end --if valid_curves_p[i]~=nil then 
   end --for i, bezier in pairs(temp_valid_curves) do 
   local valid_curves = {}
   for k,v in pairs(temp_valid_curves) do 
      if not(temp_removed[k]) then
	 local intersection  = matrix_inters[tostring(k)] or {}
	 local temp = {}
	 valid_curves[k] = v 
	 for _,v in ipairs( intersection) do 
	    if not(temp_removed[tonumber(v[1])]) then 
	       temp[#temp+1] = {v[1],v[2],v[3]}
	    end
	 end
	 matrix_inters[tostring(k)] = temp 
      else
	 matrix_inters[tostring(k)] = nil
	 print("BEZ k="..k.." cutted")
      end
   end
   print("BEZ remove_pending_pen_path end")
   print("BEZ ---------------------------")
   return valid_curves,matrix_inters
end






local function _remove_duplicate_path_III(valid_curves,matrix_inters,valid_curves_p_set)
   --
   -- remove duplicate path III
   -- An attempt to remove duplicate  (triangular  <| paths)
   local temp_removed = {}
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v temp_removed[k]=false end
   print("BEZ _remove_duplicate_path_III")
   for i, bezier in pairs(temp_valid_curves) do 
      if temp_removed[i]==false then 
	 print("BEZ i="..i)
	 local intersection  = matrix_inters[tostring(i)] or {}
	 local count_tj=0
	 local count_uj=0
	 for _,inters in ipairs(intersection) do  
	    local j,t,u= tonumber(inters[1]),inters[2],inters[3]
	    if (t=='0') and temp_removed[j]==false then
	       count_tj= count_tj+1
	    end
	    if (u=='1') and temp_removed[j]==false then
	       count_uj= count_uj+1
	    end
	 end
	 print("BEZ count_tj="..count_tj,"count_uj="..count_uj)
	 for _,inters in ipairs(intersection) do  
	    local j,t,u= tonumber(inters[1]),inters[2],inters[3]
	    print("BEZ #intersection="..#intersection)
	    if (#intersection ~=2) and ((t=='0' and u=='0') or (t=='1' and u=='1')) and temp_removed[j]==false  and valid_curves_p_set[j]==false then 
	       local match_i =  {}
	       for _,inters_1 in ipairs(intersection) do match_i[tonumber(inters_1[1])]=true end;match_i[tonumber(i)]=true
	       local match_j =  {}
	       local intersection_j  = matrix_inters[tostring(j)] or {}
	       for _,inters_j in ipairs(intersection_j) do match_j[tonumber(inters_j[1])]=true end; match_j[j]=true
	       local  check = true
	       for _,inters_j in ipairs(intersection_j) do 
		  if match_i[tonumber(inters_j[1])] == true then 
		     temp_removed[j] =true 
		     print("BEZ removed j="..j)
		     if valid_curves_p_set[i]==false and (count_tj == 1 or count_uj == 1) then 
			temp_removed[i] =true 
			print("BEZ removed i="..i)
		     end
		  end
	       end --_,inters_j in ipairs(intersection_j) do 
	    end -- if ((t=='0' and u=='0') or (t=='1' and u=='1')) and temp_removed[j]==false then 
	 end -- for _,inters in ipairs(intersection) do  
      end --if temp_removed[k]==false then 
   end -- for 
   local valid_curves = {}
   for k,v in pairs(temp_valid_curves) do 
      print("BEZ k="..k, "temp_removed[k]="..tostring(temp_removed[k]))
      if not(temp_removed[k]) then
	 local intersection  = matrix_inters[tostring(k)] or {}
	 local temp = {}
	 valid_curves[k] = v 
	 for _,v in ipairs( intersection) do 
	    if not(temp_removed[tonumber(v[1])]) then 
	       temp[#temp+1] = {v[1],v[2],v[3]}
	    end
	 end
	 matrix_inters[tostring(k)] = temp 
      else
	 matrix_inters[tostring(k)] = nil
	 print("BEZ k="..k.." cutted")
      end
   end
   return valid_curves,matrix_inters
end




local function _open_pen_loop_I(valid_curves,matrix_inters,valid_curves_p_set)
   --
   -- open pen loops
   --
   local valid_curves = valid_curves 
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v end
   local dropped = {}
   print("BEZ pen loops")
   for i, bezier in pairs(temp_valid_curves) do
      local intersection  = matrix_inters[tostring(i)] or {}
      local drop = dropped[tostring(i)] or false 
      -- print("BEZ check i=" ..i) and (intersection[4]==nil)
      if not(intersection==nil) and not(intersection[2]==nil) and not(intersection[3]==nil) and valid_curves_p_set[i]==true  and not(drop) then 
	 print("BEZ i=" ..i,"3 intersections")
	 local nodes = {}
	 nodes[#nodes+1] = i
	 local check = {}
	 local j1 = intersection[1][1]
	 local j2 = intersection[2][1]
	 local j3 = intersection[3][1]
	 check[tostring(i)] = true
	 check[tostring(j1)] = true
	 check[tostring(j2)] = true
	 check[tostring(j3)] = true
	 print("BEZ j1="..j1,"j2="..j2,"j3="..j3)
	 local intersection1 = matrix_inters[tostring(j1)] 
	 local intersection2 = matrix_inters[tostring(j2)] 
	 local intersection3 = matrix_inters[tostring(j3)] 

	 -- print("BEZ check j3="..j3, not(intersection3==nil),  not(intersection3[2]==nil), (intersection3[3]==nil))
	 -- j1 has 2 intersections and can be remove to open the  loop

	 print("BEZ check[tostring(i="..i..")]=",check[tostring(i)])
	 print("BEZ check[tostring(j1="..j1..")]=",check[tostring(j1)])
	 print("BEZ check[tostring(j2="..j2..")]=",check[tostring(j2)])
	 print("BEZ check[tostring(j3="..j3..")]=",check[tostring(j3)])
	 print("BEZ valid_curves_p_set[j1]=",valid_curves_p_set[0+j1])
	 print("BEZ valid_curves_p_set[j2]=",valid_curves_p_set[0+j2])
	 print("BEZ valid_curves_p_set[j3]=",valid_curves_p_set[0+j3])

	 if not(intersection1==nil) and not(intersection1[2]==nil) and not(intersection1[3]==nil) and valid_curves_p_set[0+j1]==false then 
	    print("BEZ j1="..j1,"intersection1[1][1]="..intersection1[1][1],
		  "intersection1[2][1]="..intersection1[2][1],"intersection1[3][1]="..intersection1[3][1])
	    local count = 0
	    for l=1,3 do if check[tostring(intersection1[l][1])] then count=count+1 end end
	    if count == 2 then nodes[#nodes+1]=j1 end 
	 end
	 if not(intersection2==nil) and not(intersection2[2]==nil) and not(intersection2[3]==nil) and valid_curves_p_set[0+j2]==false then 
	    print("BEZ j2="..j2,"intersection2[1][1]="..intersection2[1][1],
		  "intersection2[2][1]="..intersection2[2][1],"intersection2[3][1]="..intersection2[3][1])
	    local count = 0
	    for l=1,3 do if check[tostring(intersection2[l][1])] then count=count+1 end end
	    if count == 2 then nodes[#nodes+1]=j2 end 
	 end
	 if not(intersection3==nil) and not(intersection3[2]==nil) and not(intersection3[3]==nil)  and valid_curves_p_set[0+j3]==false then 
	    print("BEZ j3="..j3,"intersection3[1][1]="..intersection3[1][1],
		  "intersection3[2][1]="..intersection3[2][1],"intersection3[3][1]="..intersection3[3][1])
	    local count = 0
	    for l=1,3 do if check[tostring(intersection3[l][1])] then count=count+1 end end
	    if count == 2 then nodes[#nodes+1]=j3 end 
	 end
	 if #nodes == 3  then -- ok we have a loop
	    -- we should check that we can remove it... 
	    dropped[tostring(i)] = true 
	 end
      end
   end
   valid_curves = {}
   for k,v in pairs(temp_valid_curves) do 
      if not(dropped[tostring(k)]) then
	 local intersection  = matrix_inters[tostring(k)] or {}
	 local temp = {}
	 valid_curves[k] = v 
	 for _,v in ipairs( intersection) do 
	    if not(dropped[tostring(v[1])]) then 
	       temp[#temp+1] = {v[1],v[2],v[3]}
	    end
	 end
	 matrix_inters[tostring(k)] = temp 
      else
	 matrix_inters[tostring(k)] = nil
	 print("BEZ k="..k.." cutted")
      end
   end
   print("BEZ pen loops end")
   return valid_curves,matrix_inters
end


local function _open_pen_loop_0(valid_curves,matrix_inters,valid_curves_p_set,char)
   --
   -- try to remove pen paths outside the edges structure
   --
   local valid_curves = valid_curves 
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v end
   local dropped = {}
   print("BEZ pen loops 0")
   for i, bezier in pairs(temp_valid_curves) do
      local intersection  = matrix_inters[tostring(i)] or {}
      local drop = dropped[tostring(i)] or false 
      if valid_curves_p_set[i]==true  and not(drop) then 
	 print("BEZ ---------")
	 print("BEZ i="..i)
	 local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
         local check_p,check_q = -1,-1
	 print("BEZ i="..i,"p="..p)
	 check_p = _check_pen_point_outside(char,p,shifted)
	 print("BEZ i="..i,"q="..q)
	 check_q = _check_pen_point_outside(char,q,shifted)
	 print("BEZ i="..i,"check_p="..check_p,"check_q="..check_q)
	 if check_p == 0 or check_q == 0 then 
	    dropped[tostring(i)] = true 
	 end
      end
   end
   valid_curves = {}
   for k,v in pairs(temp_valid_curves) do 
      if not(dropped[tostring(k)]) then
	 local intersection  = matrix_inters[tostring(k)] or {}
	 local temp = {}
	 valid_curves[k] = v 
	 for _,v in ipairs( intersection) do 
	    if not(dropped[tostring(v[1])]) then 
	       temp[#temp+1] = {v[1],v[2],v[3]}
	    end
	 end
	 matrix_inters[tostring(k)] = temp 
      else
	 matrix_inters[tostring(k)] = nil
	 print("BEZ k="..k.." cutted")
      end
   end
   print("BEZ pen loops 0 end")
   return valid_curves,matrix_inters
end




local function _remove_duplicate_pen_path(valid_curves,matrix_inters,valid_curves_p_set)
   --
   -- try to remove duplicate pen path assumes that shi
   --
   local valid_curves = valid_curves 
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v end
   local temp_temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_temp_valid_curves[k] = v end
   local dropped = {}
   local abs = mflua.modul_vec
   local eps = mflua.threshold_equal_path
   print("BEZ _remove_duplicate_pen_path")
   for i, bezier in pairs(temp_valid_curves) do
      local intersection  = matrix_inters[tostring(i)] or {}
      local drop = dropped[tostring(i)] or false 
      if valid_curves_p_set[i]==true  and not(drop) then 
	 local p,c1,c2,q = _coord_str_to_table(bezier[1],bezier[2],bezier[3],bezier[4],bezier[5])
	 --print("BEZ i="..i,p,c1,c2,q)
	 for ii, bez_bezier in pairs(temp_temp_valid_curves) do
	    local pp,cc1,cc2,qq = _coord_str_to_table(bez_bezier[1],bez_bezier[2],bez_bezier[3],bez_bezier[4],bez_bezier[5])
	    --print("BEZ ii="..ii,pp,cc1,cc2,qq)
	    local drop_drop = dropped[tostring(ii)] or false 
	    if valid_curves_p_set[ii]==true  and not(drop_drop) and ii ~= i then 
	       local cond_1 = (abs(p,pp) < eps) and (abs(c1,cc1)<eps) and (abs(c2,cc2)<eps) and (abs(q,qq)<eps) 
	       local cond_2 = (abs(q,pp) < eps) and (abs(c2,cc1)<eps) and (abs(c1,cc2)<eps) and (abs(p,qq)<eps) 
	       if cond_1 or cond_2 then 
		  dropped[tostring(ii)] = true
	       end
	    end
	 end
      end
   end
   valid_curves = {}
   for k,v in pairs(temp_valid_curves) do 
      if not(dropped[tostring(k)]) then
	 local intersection  = matrix_inters[tostring(k)] or {}
	 local temp = {}
	 valid_curves[k] = v 
	 for _,v in ipairs( intersection) do 
	    if not(dropped[tostring(v[1])]) then 
	       temp[#temp+1] = {v[1],v[2],v[3]}
	    end
	 end
	 matrix_inters[tostring(k)] = temp 
      else
	 matrix_inters[tostring(k)] = nil
	 print("BEZ k="..k.." cutted")
      end
   end
   return valid_curves,matrix_inters
end








local function  _fix_wrong_pending_path(valid_curves,matrix_inters)
   --
   -- fix pending path that should be consecutive 
   --
   --local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v  end
   local temp_single_inters =  {}
   local bez_done ={}
   print("BEZ _fix_wrong_pending_path")
   for i, bezier in pairs(valid_curves) do
      local intersection  = matrix_inters[tostring(i)] or {}
      --print("BEZ i="..i,"intersection="..#intersection)
      if #intersection==1 then 
	 temp_single_inters[#temp_single_inters+1] = i
	 bez_done[i] = false
      end
   end
   if #temp_single_inters > 0 then 
      for i=1,#temp_single_inters do
	 local ii = temp_single_inters[i]
	 print("BEZ ii="..ii)
	 if bez_done[ii] then print("BEZ ii="..ii,"already done") break end
	 local bezier = valid_curves[ii]
	 local p_1,c1_1,c2_1,q_1 = _coord_str_to_table(bezier[1],bezier[2],bezier[3],bezier[4])
	 for j=1, #temp_single_inters do
	    if j==i then  break end 
	    local jj = temp_single_inters[j]
	    if bez_done[jj] then print("BEZ jj="..jj,"already done") break end
	    print("BEZ doing jj="..jj)
	    local bezier = valid_curves[jj]
	    local p_2,c1_2,c2_2,q_2 = _coord_str_to_table(bezier[1],bezier[2],bezier[3],bezier[4])
	    local min, jjj 
	    local m = {}
	    m[1] = mflua.modul_vec(p_1,p_2)
	    m[2] = mflua.modul_vec(p_1,q_2)
	    m[3] = mflua.modul_vec(q_1,p_2)
	    m[4] = mflua.modul_vec(q_1,q_2)
	    min = m[1] 
	    for n=1, 4 do if m[n]<=min then jjj = n; min = m[n] end end
	    print("BEZ i="..temp_single_inters[i],"jj="..jj,"jjj="..jjj,m[jjj])
	    if (min <mflua.threshold_fix) and (jjj== 1) then
	       print("BEZ fix p_1,p_2")
	       local p = {};local q = {}; local c1,c2 
	       -- ii
	       p[1] = 0.5*(p_1[1]+p_2[1]);q[2] = 0.5*(p_1[2]+p_2[2]);
	       q[1] = q_1[1];q[2]=q_1[2]
	       bezier =  valid_curves[ii]
	       p,c1,c2,q = _coord_table_to_str(p,c1_1,c2_1,q,{0,0})
	       valid_curves[ii]={p,c1,c2,q,bezier[5]}
	       -- jj
	       p = {}; q= {} 
	       p[1] = 0.5*(p_1[1]+p_2[1]);q[2] = 0.5*(p_1[2]+p_2[2]);
	       q[1] = q_2[1];q[2] = q_2[2];
	       bezier =  valid_curves[jj]
	       p,c1,c2,q = _coord_table_to_str(p,c1_2,c2_2,q,{0,0})
	       valid_curves[jj]={p,c1,c2,q,bezier[5]}
	       -- update matrix intersection
	       local intersection  = matrix_inters[tostring(ii)] or {}
	       intersection[#intersection+1] = {tonumber(jj),'0','0'}
	       intersection  = matrix_inters[tostring(jj)] or {}
	       intersection[#intersection+1] = {tonumber(ii),'0','0'}
	    end
	    if (min <mflua.threshold_fix) and (jjj== 2) then
	       print("BEZ fix p_1,q_2")
	       local p = {};local q = {}; local c1,c2 
	       -- ii
	       p[1] = 0.5*(p_1[1]+q_2[1]);q[2] = 0.5*(p_1[2]+q_2[2]);
	       q[1] = q_1[1];q[2] = q_1[2]
	       bezier =  valid_curves[ii]
	       p,c1,c2,q = _coord_table_to_str(p,c1_1,c2_1,q,{0,0})
	       valid_curves[ii]={p,c1,c2,q,bezier[5]}
	       -- jj
	       p = {}; q= {} 
	       p[1] = p_2[1];p[2] = p_2[2]
	       q[1] = 0.5*(q_2[1]+p_1[1]);q[2] = 0.5*(q_2[2]+p_1[2]);
	       bezier =  valid_curves[jj]
	       p,c1,c2,q = _coord_table_to_str(p,c1_2,c2_2,q,{0,0})
	       valid_curves[jj]={p,c1,c2,q,bezier[5]}
	       -- update matrix intersection
	       local intersection  = matrix_inters[tostring(ii)] or {}
	       intersection[#intersection+1] = {tonumber(jj),'0','1'}
	       intersection  = matrix_inters[tostring(jj)] or {}
	       intersection[#intersection+1] = {tonumber(ii),'1','0'}
	    end
	    if (min <mflua.threshold_fix) and (jjj== 3) then
	       print("BEZ fix q_1,p_2")
	       local p = {};local q = {}; local c1,c2 
	       -- ii
	       p[1] = p_1[1];p[2] = p_1[2]
	       q[1] = 0.5*(q_1[1]+p_2[1]);q[2] = 0.5*(q_1[2]+p_2[2]);
	       bezier =  valid_curves[ii]
	       p,c1,c2,q = _coord_table_to_str(p,c1_1,c2_1,q,{0,0})
	       valid_curves[ii]={p,c1,c2,q,bezier[5]}
	       -- jj
	       p = {}; q= {} 
	       p[1] = 0.5*(p_2[1]+q_1[1]);p[2] = 0.5*(p_2[2]+q_1[2]);
	       q[1] = q_2[1];q[2] = q_2[2];
	       bezier =  valid_curves[jj]
	       p,c1,c2,q = _coord_table_to_str(p,c1_2,c2_2,q,{0,0})
	       valid_curves[jj]={p,c1,c2,q,bezier[5]}
	       -- update matrix intersection
	       local intersection  = matrix_inters[tostring(ii)] or {}
	       intersection[#intersection+1] = {tonumber(jj),'1','0'}
	       intersection  = matrix_inters[tostring(jj)] or {}
	       intersection[#intersection+1] = {tonumber(ii),'0','1'}
	    end
	    if (min <mflua.threshold_fix) and (jjj== 4) then
	       print("BEZ fix q_1,q_2")
	       local p = {};local q = {}; local c1,c2 
	       -- ii
	       p[1] = p_1[1];q[2]=p_1[2]
	       q[1] = 0.5*(q_1[1]+q_2[1]);q[2] = 0.5*(q_1[2]+q_2[2]);
	       bezier =  valid_curves[ii]
	       p,c1,c2,q = _coord_table_to_str(p,c1_1,c2_1,q,{0,0})
	       valid_curves[ii]={p,c1,c2,q,bezier[5]}
	       -- jj
	       p = {}; q= {} 
	       p[1] = p_2[1];q[2] = p_2[2];
	       q[1] = 0.5*(q_1[1]+q_2[1]);q[2] = 0.5*(q_1[2]+q_2[2]);
	       bezier =  valid_curves[jj]
	       p,c1,c2,q = _coord_table_to_str(p,c1_2,c2_2,q,{0,0})
	       valid_curves[jj]={p,c1,c2,q,bezier[5]}
	       -- update matrix intersection
	       local intersection  = matrix_inters[tostring(ii)] or {}
	       intersection[#intersection+1] = {tonumber(jj),'1','1'}
	       intersection  = matrix_inters[tostring(jj)] or {}
	       intersection[#intersection+1] = {tonumber(ii),'1','1'}
	    end
	    bez_done[jj] = true 
	 end -- for j=1, #temp_single_inters do
      end --for i=1,#temp_single_inters do
   end
   return valid_curves,matrix_inters
end


local function _remove_path(valid_curves,matrix_inters,paths)
   --
   -- utility : remove paths . Paths is a table
   --

   if #paths == 0 then 
      return valid_curves,matrix_inters
   end

   local temp_removed = {}
   local temp_valid_curves = {}
   for i, bezier in pairs(valid_curves) do temp_valid_curves[i] = bezier end
   for i, k in ipairs(paths) do print("BEZ k="..k) temp_valid_curves[tonumber(k)] = nil; temp_removed[tostring(k)] = true end

   -- remove references to deleted paths
   for i, bezier in pairs(temp_valid_curves) do
      local intersection  = matrix_inters[tostring(i)] or {}
      local temp_intersection = {}
      for _,v in ipairs( intersection) do 
	 local j  = tostring(v[1])
	 if not(temp_removed[j]==true) then 
	    temp_intersection[#temp_intersection +1] = v
	 else
	    print("BEZ removed for path i="..i .. ' path j='..v[1])
	 end
      end 
      if #temp_intersection > 0 then 
	 matrix_inters[tostring(i)] = temp_intersection
      else
	 matrix_inters[tostring(i)] = nil
      end
   end
   return temp_valid_curves,matrix_inters
end




local function _remove_useless_path(valid_curves,matrix_inters)
   --
   -- 
   -- 
   print("_remove_useless_path")
   local temp_removed = {}
   local good_path = {}
   local frontier_path =  {}
   local temp_valid_curves = {};  
   local removable = false 
   for k,v in pairs(valid_curves) do 
      temp_valid_curves[k] = v ; 
      temp_removed[tonumber(k)]=false;
      good_path[k]=false 
      frontier_path[tonumber(k)] =  false
   end

   for i, bezier in pairs(temp_valid_curves) do 
      local intersection  = matrix_inters[tostring(i)] or {}
      local count_i = 0
      for _,inters in ipairs(intersection) do  count_i = count_i+1 end
      if count_i == 2 then 
	 local j1,t1 = intersection[1][1],intersection[1][2]
	 local j2,t2 = intersection[2][1],intersection[2][2]
	 -- WARN !!! should be	 if tonumber(t1) ==tonumber(t2) then 
	 if tonumber(t1) <=tonumber(t2) then 
	    good_path[i] = {["begin"]=tonumber(j1),["end"]=tonumber(j2)}
	 else
	    good_path[i] = {["begin"]=tonumber(j2),["end"]=tonumber(j1)}
	 end
      end
   end 

   for i, bezier in pairs(temp_valid_curves) do 
      if good_path[i] == false  then 
	 print("BEZ i="..i, "is not a good_path")
	 local intersection  = matrix_inters[tostring(i)] or {}
	 local check_i =  {}
	 local paths_i = {}
	 for k,v in ipairs(intersection) do check_i[tonumber(v[1])] = true  end
	 local paths_i = {}
	 for k,v in ipairs(intersection) do 
	    local j,t,u = v[1],v[2],v[3]
	    paths_i[#paths_i+1] = {tonumber(i)}
	    print("BEZ -------------")
	    print("BEZ i="..i,"check j="..j)
	    if good_path[tonumber(j)] and temp_removed[tonumber(j)] == false  then
	       print("BEZ j="..j,"good_path[j][begin]"..good_path[tonumber(j)]["begin"],"good_path[j][end]="..good_path[tonumber(j)]["end"])
	       local temp_t = paths_i[#paths_i] 
	       temp_t[#temp_t+1] = tonumber(j)
	       local current_i = i
	       local current_j = j
	       local cond = true 

	       while cond == true do
		  local prev_j =  good_path[tonumber(current_j)]["begin"]
		  if prev_j == current_i then prev_j =  good_path[tonumber(current_j)]["end"] end
		  print("BEZ current_i="..current_i,"j="..current_j, "prev_j="..prev_j)
		  if tonumber(current_i) == tonumber(prev_j) then -- a pending path
		     cond = false
		     removable = true 
		     print("BEZ found removable in j="..current_j)
		     temp_t[#temp_t+1] = tonumber(prev_j)
		  else
		     current_i = current_j
		     current_j = prev_j
		     -- print("BEZ else")
		     -- print("BEZ current_i="..current_i,"j="..current_j, "(old)prev_j="..prev_j)
		     -- print("BEZ current_j="..current_j, "good_path[tonumber(current_j)][\"end\"]="..good_path[tonumber(current_j)]["end"])
		     -- print("BEZ current_j="..current_j, "good_path[tonumber(current_j)][\"begin\"]="..good_path[tonumber(current_j)]["begin"])
		     -- prev_j =  good_path[tonumber(current_j)]["end"]
		     -- print("BEZ current_i="..current_i,"j="..current_j, "prev_j="..prev_j)
		     -- if prev_j == current_i then prev_j =  good_path[tonumber(current_j)]["end"] end
		     -- print("BEZ current_i="..current_i,"j="..current_j, "prev_j="..prev_j)
		     -- print("BEZ current_i="..current_i,"i="..i,"check_i[tonumber(prev_j)]=check_i[tonumber("..prev_j..")]="..tostring(check_i[tonumber(prev_j)]))
		     if check_i[tonumber(prev_j)] == true  then   
			cond = false 
			temp_t[#temp_t+1] = tonumber(current_j)
			print ("BEZ cond false: found prev_j="..prev_j) 
		     else
			temp_t[#temp_t+1] = tonumber(current_j)
		     end
		  end
	       end --while
	       paths_i[#paths_i] = temp_t
	       print("BEZ #paths_i[#paths_i]="..#paths_i[#paths_i])
	       --for _,v in ipairs(paths_i[#paths_i]) do print("BEZ v="..v)end
	       if removable == true then 
		  print("BEZ paths_i="..#paths_i,"is removable")
		  for i=1,#paths_i[#paths_i] do print("BEZ i="..i,"v="..tonumber(paths_i[#paths_i][i])) end
		  for i=2,#paths_i[#paths_i]-1 do 
		     temp_removed[tonumber(paths_i[#paths_i][i])] = true 
		  end
		  -- exit for i, bezier in pairs(temp_valid_curves) do 
		  break
	       end
	    end -- if good_path[tonumber(j)] then
	 end -- for k,v in ipairs(intersection) do 
	 if removable == true then 
	    --print("BEZ find a removable")
	    break 
	 end
      end --if not(good_path[i]) 
   end --   for i, bezier in pairs(temp_valid_curves) do 
   if removable == true then 
      print("BEZ find a removable")
      local rm = {}
      for k,v in pairs(temp_removed) do
	 if v == true then 
	    print("BEZ removed k="..k, tostring(v))
	    rm[#rm+1] = tostring(k)
	 end
      end
      print("BEZ #rm="..#rm,rm[1],rm[2])
      valid_curves,matrix_inters = _remove_path(valid_curves,matrix_inters,rm)
   end
   return valid_curves,matrix_inters
end





-- local function _remove_path(valid_curves,matrix_inters,paths)
--    --
--    -- utility : remove paths . Paths is a table
--    --

--    if #path == 0 then 
--       return valid_curves,matrix_inters
--    end

--    local temp_removed = {}
--    local temp_valid_curves = {}
--    for i, bezier in pairs(valid_curves) do temp_valid_curves[i] = bezier end
--    for i, k in ipairs(paths) do print("BEZ k="..k) temp_valid_curves[tonumber(k)] = nil; temp_removed[tostring(k)] = true end

--    -- remove references to deleted paths
--    for i, bezier in pairs(temp_valid_curves) do
--       local intersection  = matrix_inters[tostring(i)] or {}
--       local temp_intersection = {}
--       for _,v in ipairs( intersection) do 
-- 	 local j  = tostring(v[1])
-- 	 if not(temp_removed[j]==true) then 
-- 	    temp_intersection[#temp_intersection +1] = v
-- 	 else
-- 	    print("BEZ removed for path i="..i .. ' path j='..v[1])
-- 	 end
--       end 
--       if #temp_intersection > 0 then 
-- 	 matrix_inters[tostring(i)] = temp_intersection
--       else
-- 	 matrix_inters[tostring(i)] = nil
--       end
--    end
--    return temp_valid_curves,matrix_inters
-- end


local function _remove_pending_path_I(valid_curves,matrix_inters)
   --
   -- pending paths
   --
   local temp_removed = {}
   local temp_valid_curves = {}
   print("BEZ _remove_pending_path_I")
   for i, bezier in pairs(valid_curves) do 
      local intersection  = matrix_inters[tostring(i)] or {}
      --print("BEZ removed check intersections")
      --for _,v in ipairs( intersection) do print(string.format("BEZ all intersections of i=%s: j=%s ,t=%s, u=%s",i,v[1],v[2],v[3])) end 
      if (intersection==nil) or #intersection <=1 then 
	 temp_removed[tostring(i)]=true
	 print("BEZ removed i="..i)
      --elseif #intersection > 1 then 
      elseif #intersection > 1 then  --  not > 2 otherwise most of curves are deleted !
	 local check_init_0 = 0
	 local check_init_1 = 0
	 for iv,v in ipairs( intersection) do
	    local t,u = v[2],v[3]
	    --print("BEZ i="..i,"iv="..iv)
	    if t=='0' or u == '1'  then check_init_0 = check_init_0 +1 end
	    if t=='1' or u=='0'    then check_init_1 = check_init_1 +1 end
	 end
	 --print("BEZ ",i,check_init_0,check_init_1,check_init_0+check_init_1,#intersection)
	 -- can be t=0 and u=0
	 if #intersection > 2 and (check_init_0==#intersection or  check_init_1==#intersection)   then 
            -- ??? 
	    temp_removed[tostring(i)]=true
	    --print("BEZ removed pending path i="..i)
	 else
	    temp_valid_curves[i] = bezier 
	 end
      end
   end
   -- remove references to pending paths
   for i, bezier in pairs(temp_valid_curves) do
      local intersection  = matrix_inters[tostring(i)] or {}
      local temp_intersection = {}
      for _,v in ipairs( intersection) do 
	 local j  = tostring(v[1])
	 if not(temp_removed[j]==true) then 
	    temp_intersection[#temp_intersection +1] = v
	 else
	    --print("BEZ for path i="..i .. ' removed pending path j='..v[1])
	 end
      end 
      if #temp_intersection > 0 then 
	 matrix_inters[tostring(i)] = temp_intersection
      else
	 matrix_inters[tostring(i)] = nil
      end
   end
   -- valid_curves = temp_valid_curves
   return temp_valid_curves,matrix_inters
end





local function _remove_pending_path_II(valid_curves,matrix_inters)
   --
   -- pending paths
   --
   local temp_removed = {}
   local temp_valid_curves = {}
   print("BEZ _remove_pending_path_II")
   for i, bezier in pairs(valid_curves) do 
      local intersection  = matrix_inters[tostring(i)] or {}
      --print("BEZ removed check intersections")
      --for _,v in ipairs( intersection) do print(string.format("BEZ all intersections of i=%s: j=%s ,t=%s, u=%s",i,v[1],v[2],v[3])) end 
      if (intersection==nil) or #intersection <=1 then 
	 temp_removed[tostring(i)]=true
	 print("BEZ removed i="..i)
      --elseif #intersection > 1 then 
      else
	    temp_valid_curves[i] = bezier 
      end
   end
   -- remove references to pending paths
   for i, bezier in pairs(temp_valid_curves) do
      local intersection  = matrix_inters[tostring(i)] or {}
      local temp_intersection = {}
      for _,v in ipairs( intersection) do 
	 local j  = tostring(v[1])
	 if not(temp_removed[j]==true) then 
	    temp_intersection[#temp_intersection +1] = v
	 else
	    --print("BEZ for path i="..i .. ' removed pending path j='..v[1])
	 end
      end 
      if #temp_intersection > 0 then 
	 matrix_inters[tostring(i)] = temp_intersection
      else
	 matrix_inters[tostring(i)] = nil
      end
   end
   -- valid_curves = temp_valid_curves
   return temp_valid_curves,matrix_inters
end



local function _try_to_remove(i,valid_curves,matrix_inters)
   local temp_valid_curves  = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v end
   local temp_matrix_inters = {};  for k,v in pairs(matrix_inters) do temp_matrix_inters[k] = v end
   local dropped = {}

   dropped[tostring(i)] = true 
   local temp_temp_valid_curves = {}
   for k,v in pairs(temp_valid_curves) do 
      if not(dropped[tostring(k)]) then
   	 local intersection  = temp_matrix_inters[tostring(k)] or {}
   	 local temp = {}
   	 temp_temp_valid_curves[k] = v 
   	 for _,v in ipairs( intersection) do 
   	    if not(dropped[tostring(v[1])]) then 
   	       temp[#temp+1] = {v[1],v[2],v[3]}
   	    end
   	 end
   	 temp_matrix_inters[tostring(k)] = temp 
      else
   	 temp_matrix_inters[tostring(k)] = nil
	 print("BEZ k="..k,"removed")
      end
   end

   local cnt_0,cnt_1,cnt = 0,0,0
   local check_loop,result = true ,true 
   
   for _k,_v in pairs(temp_temp_valid_curves) do cnt_0 = cnt_0 +1 end 
   while check_loop do 
      temp_temp_valid_curves,temp_matrix_inters =  _remove_pending_path_II(temp_temp_valid_curves,temp_matrix_inters)
      cnt = 0
      for _k,_v in pairs(temp_temp_valid_curves) do cnt = cnt +1 end 
      print("BEZ cnt_1="..cnt_1,"cnt="..cnt,"cnt_0="..cnt_0)
      if cnt == cnt_1 then 
	 check_loop = false
	 result = true 
      else
	 if cnt_0 - cnt > mflua.threshold_path_removed then 
	    check_loop = false
	    result = false
	 else 
	    cnt_1=cnt
	 end
      end
   end
   return result,temp_temp_valid_curves,temp_matrix_inters
end



local function _open_pen_loop_II(valid_curves,matrix_inters)
   --
   -- most of case these are loops from pens
   --
   local valid_curves = valid_curves 
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v end
   local dropped = {}
   --local ye_map = char['edges_map'] 
   print("BEZ pen loops II")
   for i, bezier in pairs(temp_valid_curves) do
      local intersection  = matrix_inters[tostring(i)] or {}
      local drop = dropped[tostring(i)] or false 
      -- only 3 intersection with at least 2 in t=0
      if not(intersection==nil) and not(intersection[3]==nil) and (intersection[4]==nil) and not(drop) then 
	 print("BEZ i=" ..i)
	 local res,_,_ = _try_to_remove(i,valid_curves,matrix_inters)
	 print("BEZ res=",res)
	 if res == true then 
	    dropped[tostring(i)] = true 
	    break 
	 end
	 local j1,t1,u1 = intersection[1][1],intersection[1][2],intersection[1][3]
	 local j2,t2,u2 = intersection[2][1],intersection[2][2],intersection[2][3]
	 local j3,t3,u3 = intersection[3][1],intersection[3][2],intersection[3][3]
	 if (t1=='0' and t2=='0') or (t2=='0' and t3=='0') or (t3=='0' and t1=='0') then 
	    if t1=='0' then 
	       res,_,_ = _try_to_remove(j1,valid_curves,matrix_inters)
	       if res == true then 
		  dropped[tostring(j1)] = true 
		  break 
	       end
	    end
	    if t2=='0' then 
	       res,_,_ = _try_to_remove(j2,valid_curves,matrix_inters)
	       if res == true then 
		  dropped[tostring(j2)] = true 
		  break 
	       end
	    end
	    if t3=='0' then 
	       res,_,_ = _try_to_remove(j3,valid_curves,matrix_inters)
	       if res == true then 
		  dropped[tostring(j3)] = true 
		  break 
	       end
	    end
	 end -- if (t1=='0' and t2=='0') or (t2=='0' and t3=='0') or (t3=='0' and t1=='0') then 
      end -- if not(intersection==nil) and not(intersection[3]==nil) and (intersection[4]==nil) and not(drop) then 
   end --for i, bezier in pairs(temp_valid_curves) do
   valid_curves = {}
   for k,v in pairs(temp_valid_curves) do 
      if not(dropped[tostring(k)]) then
   	 local intersection  = matrix_inters[tostring(k)] or {}
   	 local temp = {}
   	 valid_curves[k] = v 
   	 for _,v in ipairs( intersection) do 
   	    if not(dropped[tostring(v[1])]) then 
   	       temp[#temp+1] = {v[1],v[2],v[3]}
   	    end
   	 end
   	 matrix_inters[tostring(k)] = temp 
      else
   	 matrix_inters[tostring(k)] = nil
   	 print("BEZ k="..k.." cutted")
      end
   end
   print("BEZ pen loops II end")
   return valid_curves,matrix_inters
end






local function _remove_overlaps(valid_curves,matrix_inters)
   --
   -- remove curve  overlaps 
   --
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v end
   local valid_curves = {}
   print("BEZ remove curve  overlaps ")
   for i, bezier in pairs(temp_valid_curves) do
      print("BEZ --------------------------")
      print("BEZ i="..i)
      local intersection  = matrix_inters[tostring(i)] or {}
      --for _,v in ipairs( intersection) do print(string.format("BEZ all intersections of i=%s: j=%s ,t=%s, u=%s",i,v[1],v[2],v[3])) end 
      if not(intersection==nil) and not(intersection[2]==nil) and (intersection[3]==nil) then 
	 local cnt = 0
	 local m1 = intersection[1]
	 local j1,t1,u1 = m1[1],m1[2],m1[3]
	 --print(string.format("BEZ i=%s,j1=%s,t1=%s,u1=%s",i,j1,t1,u1))
	 local m2 = intersection[2] 
	 local j2,t2,u2 = m2[1],m2[2],m2[3]
	 print(string.format("BEZ i=%s,j2=%s,t2=%s,u2=%s",i,j2,t2,u2))
	 --if (u1 == '1') then t1 = '0' end
	 --if (u2 == '0') then t2 = '1' end
	 local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
	 local w
	 if (t2+0<t1+0) then 
	    local t; t=t2 t2=t1 t1=t 
	    local u; u=u2 u2=u1 u1=u 
	    local j; j=j2 j2=j1 j1=j 
	 end 
	 print("BEZ t1="..t1,"t2="..t2,"u1="..u1,"u2="..u2)
	 w=string.gmatch(p,"[-0-9.]+"); p={w(),w()}
	 w=string.gmatch(c1,"[-0-9.]+"); c1={w(),w()}
	 w=string.gmatch(c2,"[-0-9.]+"); c2={w(),w()}
	 w=string.gmatch(q,"[-0-9.]+"); q={w(),w()}
	 --w=string.gmatch(shifted,"[-0-9.]+"); s={w(),w()}
	 print("BEZ i="..i,"p="..string.format("(%s,%s)",p[1],p[2]),"q="..string.format("(%s,%s)",q[1],q[2]) )
	 _1,_2,_3,_4,_5,_6,_7,_8,_9 =  bez(p,c1,c2,q,t1)
	 local res_p,res_c1 =  _6,_7
	 _1,_2,_3,_4,_5,_6,_7,_8,_9 =  bez(p,c1,c2,q,t2)
	 local res_c2,res_q = _5,_6
	 p,c1,c2,q =res_p,res_c1,res_c2,res_q
	 p = string.format("(%s,%s)",p[1],p[2]) 
	 c1 = string.format("(%s,%s)",c1[1],c1[2])
	 c2 = string.format("(%s,%s)",c2[1],c2[2])
	 q = string.format("(%s,%s)",q[1],q[2])
	 print("BEZ i="..i,p,c1,c2,q,shifted)
	 -- --
	 -- -- CHECK 
	 -- --
	 -- print("BEZ check")
	 -- local bez_t1 = temp_valid_curves[0+j1]
	 -- local bez_t2 = temp_valid_curves[0+j2]
	 -- local intersection_t1  = matrix_inters[tostring(j1)] or {}
	 -- local intersection_t2  = matrix_inters[tostring(j2)] or {}
	 -- local t_t1,t_t2 
	 -- local p_t1,c1_t1,c2_t1,q_t1
	 -- local p_t2,c1_t2,c2_t2,q_t2

	 -- --print("BEZ j1="..j1,bez_t1[1],bez_t1[2],bez_t1[3],bez_t1[4],bez_t1[5])
	 -- --print("BEZ j1="..j1,intersection_t1[1][1],intersection_t1[1][2],intersection_t1[1][3])
	 -- --print("BEZ j1="..j1,intersection_t1[2][1],intersection_t1[2][2],intersection_t1[2][3])
	 -- if tonumber(intersection_t1[1][1]) == tonumber(i) then 
	 --    t_t1 = intersection_t1[1][2]
	 -- elseif tonumber(intersection_t1[2][1]) == tonumber(i) then 
	 --    t_t1 = intersection_t1[2][2]
	 -- else
	 --    t_t1 = '-1'
	 -- end
	 -- --print("BEZ t_t1="..t_t1)
	 -- p_t1,c1_t1,c2_t1,q_t1 = _coord_str_to_table(bez_t1[1],bez_t1[2],bez_t1[3],bez_t1[4])
	 -- _1,_2,_3,_4,_5,_6,_7,_8,_9 =  bez(p_t1,c1_t1,c2_t1,q_t1,t_t1)
	 -- p_t1,c1_t1,c2_t1,q_t1 = _6,_7,_8,_9
	 -- print("BEZ j1="..j1,"t_t1="..t_t1,"p="..string.format("(%s,%s)",p_t1[1],p_t1[2]),"q="..string.format("(%s,%s)",q_t1[1],q_t1[2]) )

	 -- --print("BEZ ")
	 -- --print("BEZ j2="..j2,bez_t2[1],bez_t2[2],bez_t2[3],bez_t2[4],bez_t2[5])
	 -- --print("BEZ j1="..j1,intersection_t2[1][1],intersection_t2[1][2],intersection_t2[1][3])
	 -- --print("BEZ j1="..j1,intersection_t2[2][1],intersection_t2[2][2],intersection_t2[2][3])
	 -- if tonumber(intersection_t2[1][1]) == tonumber(i) then 
	 --    t_t2 = intersection_t2[1][2]
	 -- elseif tonumber(intersection_t2[2][1]) == tonumber(i) then 
	 --    t_t2 = intersection_t2[2][2]
	 -- else
	 --    t_t2 = '-1'
	 -- end
	 -- --print("BEZ t_t2="..t_t2)
	 -- p_t2,c1_t2,c2_t2,q_t2 = _coord_str_to_table(bez_t2[1],bez_t2[2],bez_t2[3],bez_t2[4])
	 -- _1,_2,_3,_4,_5,_6,_7,_8,_9 =  bez(p_t2,c1_t2,c2_t2,q_t2,t_t2)
	 -- p_t2,c1_t2,c2_t2,q_t2 = _6,_7,_8,_9
	 -- print("BEZ j2="..j2,"t_t2="..t_t2,"p="..string.format("(%s,%s)",p_t2[1],p_t2[2]),"q="..string.format("(%s,%s)",q_t2[1],q_t2[2]) )
	 -- --
	 -- -- A TABLE
	 -- --
	 -- local p_t,c1_t,c2_t,q_t,shifted_t = _coord_str_to_table(bezier[1],bezier[2],bezier[3],bezier[4],bezier[5])
	 -- for dd=-3,4 do 
	 --    local dd_t1 = dd*1/(2^16) + t1 
	 --    local dd_p,dd_q
	 --    _1,_2,_3,_4,_5,_6,_7,_8,_9 =  bez(p_t,c1_t,c2_t,q_t,dd_t1)
	 --    dd_p,dd_q = _1,_2
	 --    print("BEZ i="..i,"t1="..t1,"dd_t1="..dd_t1,"p="..string.format("(%s,%s)",dd_p,dd_q))
	 -- end
	 -- for dd=-7,8 do 
	 --    local dd_t2 = dd*1/(2^16) + t2 
	 --    local dd_p,dd_q
	 --    _1,_2,_3,_4,_5,_6,_7,_8,_9 =  bez(p_t,c1_t,c2_t,q_t,dd_t2)
	 --    dd_p,dd_q = _1,_2
	 --    print("BEZ i="..i,"t2="..t2,"dd_t1="..dd_t2,"p="..string.format("(%s,%s)",dd_p,dd_q))
	 -- end
	 valid_curves[i] = {p,c1,c2,q,shifted}
      end
   end
   return valid_curves,matrix_inters
end


local function remove_small_curve_with_overlap(valid_curves,matrix_inters)
  --
  -- check for curves almost null with overlap
  --
  temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v end
  dropped = {}
  for i, bezier in pairs(temp_valid_curves) do
     local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
     local d
     local w=string.gmatch(p,"[-0-9.]+"); p={w(),w()}
     --w=string.gmatch(c1,"[-0-9.]+"); c1={w(),w()}
     --w=string.gmatch(c2,"[-0-9.]+"); c2={w(),w()}
     w=string.gmatch(q,"[-0-9.]+"); q={w(),w()}
     d = math.pow( (q[1]-p[1])^2 + (q[2]-p[2])^2, 0.5 )
     --print("BEZ i="..i,"d="..d)
     if (d<1) then 
	print()
	print("BEZ SMALL i="..i, "p="..p[1].." "..p[2],"q="..q[1].." "..q[2],"d="..d)
	local intersection  = matrix_inters[tostring(i)] or {}
	-- for _,v in ipairs( intersection) do print(string.format("BEZ all intersections of i=%s: j=%s ,t=%s, u=%s",i,v[1],v[2],v[3])) end 
	if not(intersection==nil) and not(intersection[2]==nil) and (intersection[3]==nil) then 
	   local m = intersection[1]
	   local j1,t1,u1 = m[1],m[2],m[3]
	   m = intersection[2] 
	   local j2,t2,u2 = m[1],m[2],m[3]
	   local intersection1 = matrix_inters[tostring(j1)] or {}
	   local intersection2 = matrix_inters[tostring(j2)] or {}
	   --
	   -- triple point
	   --
	   if (not(intersection1[1]==nil) and not(intersection1[2]==nil) and not(intersection1[3]==nil)) and
	      (not(intersection2[1]==nil) and not(intersection2[2]==nil) and not(intersection2[3]==nil)) then 
	      dropped[tostring(i)] = true 
	   end
	end   
     end
  end
  local valid_curves = {}
  for k,v in pairs(temp_valid_curves) do 
     if not(dropped[tostring(k)]) then
	local intersection  = matrix_inters[tostring(k)] or {}
	local temp = {}
	valid_curves[k] = v 
	for _,v in ipairs( intersection) do 
	   if not(dropped[tostring(v[1])]) then 
	      temp[#temp+1] = {v[1],v[2],v[3]}
	   end
	end
	matrix_inters[tostring(k)] = temp 
     else
	matrix_inters[tostring(k)] = nil
	--print("BEZ k="..k.." cutted")
     end
  end
  return valid_curves,matrix_inters
end



local function _remove_small_path(valid_curves,matrix_inters)
   --
   -- remove & merge small ~ straight curves 
   --
   local dropped = {}
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v end
   local small_curve = {}
   local threshold = mflua.threshold
   for i, bezier in pairs(temp_valid_curves) do
      local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
      local d
      local w=string.gmatch(p,"[-0-9.]+"); p={w(),w()}
      w=string.gmatch(c1,"[-0-9.]+"); c1={w(),w()}
      w=string.gmatch(c2,"[-0-9.]+"); c2={w(),w()}
      w=string.gmatch(q,"[-0-9.]+"); q={w(),w()}
      d = math.pow( (q[1]-p[1])^2 + (q[2]-p[2])^2, 0.5 )+0.0
      small_curve[i] = false
      if (d<threshold) then 
	 small_curve[i] = true
      end
   end
   for i, bezier in pairs(temp_valid_curves) do
      local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
      local d
      local w=string.gmatch(p,"[-0-9.]+"); p={w(),w()}
      w=string.gmatch(c1,"[-0-9.]+"); c1={w(),w()}
      w=string.gmatch(c2,"[-0-9.]+"); c2={w(),w()}
      w=string.gmatch(q,"[-0-9.]+"); q={w(),w()}
      d = math.pow( (q[1]-p[1])^2 + (q[2]-p[2])^2, 0.5 )+0.0
      --print()
      --print("BEZ CHECK FOR SMALL i="..i, "p="..p[1].." "..p[2],"q="..q[1].." "..q[2],"c1="..c1[1].. " " ..c1[2],"c2="..c2[1].. " " ..c2[2],"d="..d)
      if small_curve[i] then 
	 -- print("BEZ SMALL i="..i, "p="..p[1].." "..p[2],"q="..q[1].." "..q[2],"c1="..c1[1].. " " ..c1[2],"c2="..c2[1].. " " ..c2[2],"d="..d)
	 local intersection  = matrix_inters[tostring(i)] or {}
	 --for _,v in ipairs( intersection) do print(string.format("BEZ all intersections of i=%s: j=%s ,t=%s, u=%s",i,v[1],v[2],v[3])) end 
	 --for _,v in ipairs( intersection) do print(string.format("BEZ i=%s, j=%s is SMALL:%s",i,v[1],tostring(small_curve[0+v[1]])))end 
	 local cond1 = not(intersection==nil) and not(intersection[1]==nil) and not(intersection[2]==nil) and (intersection[3]==nil)
	 -- horizontal line
	 local cond2 =  math.abs(p[2]-c1[2]) <1 and math.abs(q[2]-c2[2]) <1
	 -- i is a small curve between two normal ones
	 local cond3 = false
	 for _,v in ipairs( intersection) do 
	    if small_curve[0+v[1]] then cond3 = true break end
	 end 
	 --print("BEZ cond1="..tostring(cond1),"cond2="..tostring(cond2),"not(cond3)="..tostring(not(cond3)))
	 if  cond1 and cond2 and not(cond3) then 
	    p[1] = 0.5*(p[1]+q[1])
	    p[2] = 0.5*(p[2]+q[2])
	    local m = intersection[1]
	    local j1,t1,u1 = m[1],m[2],m[3]
	    m = intersection[2] 
	    local j2,t2,u2 = m[1],m[2],m[3]
	    local pre_bez,post_bez 
	    local pre,post
	    if(t1+0<t2+0) then 
	       pre_bez = temp_valid_curves[j1+0]
	       post_bez = temp_valid_curves[j2+0]
	       pre = j1+0; post =j2+0
	    else
	       pre_bez = temp_valid_curves[j2+0]
	       post_bez = temp_valid_curves[j1+0]
	       pre = j2+0; post =j1+0
	    end
	    --local bez = pre_bez
	    local pre_p,pre_c1,pre_c2,pre_q,pre_shifted = pre_bez[1],pre_bez[2],pre_bez[3],pre_bez[4],pre_bez[5]
	    --bez = post_bez
	    local post_p,post_c1,post_c2,post_q,post_shifted = post_bez[1],post_bez[2],post_bez[3],post_bez[4],post_bez[5]
	    local w
	    w=string.gmatch(pre_c2,"[-0-9.]+"); pre_c2={w(),w()}
	    w=string.gmatch(pre_q,"[-0-9.]+"); pre_q={w(),w()}
	    w=string.gmatch(post_p,"[-0-9.]+"); post_p={w(),w()}
	    w=string.gmatch(post_c1,"[-0-9.]+"); post_c1={w(),w()}
	    --mflua.vec(p,q) is not correct we should use vec(c1,p)
	    local fi_pre = 180/mflua.pi * mflua.angle(mflua.vec(pre_c2,pre_q),mflua.vec(p,q))
	    -- print("BEZ fi_pre="..pre.." <(|_c2->_q|,|p->c1|)=".. fi_pre, "180-fi_pre="..(180-fi_pre))
	    --mflua.vec(p,q) is not correct we should use vec(c2,q)
	    local fi_post = 180/mflua.pi * mflua.angle(mflua.vec(p,q),mflua.vec(post_p,post_c1))
	    -- print("BEZ fi_post="..post.." <(|c2->q|,|_p->_c1|)=".. fi_post, "180-fi_post="..(180-fi_post))
	    local fi_pre_post = 180/mflua.pi * mflua.angle(mflua.vec(pre_c2,pre_q),mflua.vec(post_p,post_c1))
	    -- print("BEZ fi_pre_post="..fi_pre_post.." <(|_c2->_q|,|_p->_c1|)=".. fi_pre_post)

	    local check1 = (fi_pre<mflua.threshold_degree)
	    local check2 = (fi_post<mflua.threshold_degree)
	    local check3 = (mflua.threshold_degree_1<=fi_pre_post) and (fi_pre_post<=mflua.threshold_degree_2)
	    
	    if check1  and check2  or (not(check1) and not(check1) and not(check3)) then 
	       p[1] = 0.5*(q[1]+p[1]);p[2] = 0.5*(q[2]+p[2]);
	       pre_c2 = string.format("(%s,%s)",pre_c2[1],pre_c2[2])
	       pre_q = string.format("(%s,%s)",p[1],p[2])
	       post_p = string.format("(%s,%s)",p[1],p[2])
	       post_c1 = string.format("(%s,%s)",post_c1[1],post_c1[2])
	       temp_valid_curves[pre] = {pre_p,pre_c1,pre_c2,pre_q,pre_shifted}
	       temp_valid_curves[post] = {post_p,post_c1,post_c2,post_q,post_shifted}
	       dropped[tostring(i)]= true
	    elseif (check1 and not(check2)) or (not(check1) and not(check1) and check3) then 
	       p[1] = 0+p[1];p[2] = 0+p[2];
	       pre_c2 = string.format("(%s,%s)",pre_c2[1],pre_c2[2])
	       pre_q = string.format("(%s,%s)",q[1],q[2])
	       post_p = pre_q --string.format("(%s,%s)",pre_q[1],pre_q[2])
	       post_c1 = string.format("(%s,%s)",post_c1[1],post_c1[2])
	       temp_valid_curves[pre] = {pre_p,pre_c1,pre_c2,pre_q,pre_shifted}
	       temp_valid_curves[post] = {post_p,post_c1,post_c2,post_q,post_shifted}
	       dropped[tostring(i)]= true
	    elseif not(check1) and check2 then 
	       p[1] = 0+p[1];p[2] = 0+p[2];
	       pre_c2 = string.format("(%s,%s)",pre_c2[1],pre_c2[2])
	       pre_q = string.format("(%s,%s)",pre_q[1],pre_q[2])
	       post_p = pre_q --string.format("(%s,%s)",pre_q[1],pre_q[2])
	       post_c1 = string.format("(%s,%s)",post_c1[1],post_c1[2])
	       temp_valid_curves[pre] = {pre_p,pre_c1,pre_c2,pre_q,pre_shifted}
	       -- perhaps we need to modify also post_c1 ?
	       temp_valid_curves[post] = {post_p,post_c1,post_c2,post_q,post_shifted}
	       dropped[tostring(i)]= true
	    end
	 end   
      end
   end
   local valid_curves = {}
   for k,v in pairs(temp_valid_curves) do 
      if not(dropped[tostring(k)]) then
	 local intersections  = matrix_inters[tostring(k)] or {}
	 local temp = {}
	 valid_curves[k] = v 
	 for _,vv in ipairs( intersections) do 
	    if not(dropped[tostring(vv[1])]) then 
	       temp[#temp+1] = {vv[1],vv[2],vv[3]}
	    end
	 end
	 matrix_inters[tostring(k)] = temp 
      else
	 local intersections  = matrix_inters[tostring(k)] or {}
	 if intersections[1] ~= nil and intersections[2] ~= nil then 
	    local j1,t1,u1 = intersections[1][1], intersections[1][2], intersections[1][3]
	    local j2,t2,u2 = intersections[2][1], intersections[2][2], intersections[2][3]
	    temp = matrix_inters[tostring(j1)]
	    temp[#temp+1] = {j2,t2,u2}
	    temp = matrix_inters[tostring(j2)]
	    temp[#temp+1] = {j1,t1,u1}
	 end
	 matrix_inters[tostring(k)] = nil
	 print("BEZ k="..k.." cutted")
      end
   end
   return valid_curves,matrix_inters
end -- _remove_small_path

local function _adjust_times(valid_curves,matrix_inters)
   --
   -- adjust times
   --
   print("BEZ adjust times")
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v end
   for i,bezier in pairs(temp_valid_curves) do
      local intersections = matrix_inters[tostring(i)] or {}
      local p,q,c1,c2,shifted 
      p,c1,c2,q,shifted= bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
      if not(intersections[1]==nil) and not(intersections[2]==nil) and (intersections[3]==nil)   then 
	 local j1,t1,u1 = intersections[1][1], intersections[1][2], intersections[1][3]
	 local j2,t2,u2 = intersections[2][1], intersections[2][2], intersections[2][3]
         -- o-->--o-----<------o-->--o
	 if math.abs(t1-u1)<0.1 and math.abs(t2-u2)<0.1 then 
	    print(string.format("BEZ  i=%s,p=%s,c1=%s,c2=%s,q=%s, shifted=%s",i,p,c1,c2,q,tostring(shifted)))
	    q,c2,c1,p,shifted= bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
	    intersections[1]={j1,u1,t1}
	    intersections[2]={j2,u2,t2}
	    matrix_inters[tostring(i)] = {intersections[1],intersections[2]}
	 end
      end
      valid_curves[i] = {p,c1,c2,q,shifted}
   end
   return valid_curves,matrix_inters
end


local function _adjust_times_I(valid_curves,matrix_inters)
   --
   -- adjust times TODO !!!!!!!!!!!!!
   --
   print("BEZ adjust times I")
   local done = {}
   local next_path = 1e12 -- wil be the minimum path 
   local prev_path = -1
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do done[k]=false ; if k< next_path then next_path=k end end
   local modified = true
   local reverse  = false 
   local exit_loop = false
   --local max_cnt = 0
   while exit_loop == false do
      --max_cnt = max_cnt +1;if max_cnt >#valid_curves then break end
      for k,v in pairs(valid_curves) do temp_valid_curves[k] = v end
      print("BEZ -------------------------------------------")
      print("BEZ begin loop, -------------------------------")
      print("BEZ modified=",modified,"reverse=",reverse)
      print("BEZ next_path="..next_path)

      if modified == false and reverse == false then 
	 -- get anothore path to check
	 exit_loop = true
	 for k,v in pairs(valid_curves) do
	    print("BEZ k="..k,"done[k]=",done[k])
	    if done[k] == false then 
	       next_path= k ; 
	       print("BEZ choose another path="..next_path) 
	       exit_loop = false
	       break 
	    end 
	 end
      end
      if exit_loop == true then break end

      local i,bezier =tonumber(next_path),temp_valid_curves[tonumber(next_path)]
  --for i,bezier in pairs(temp_valid_curves) do
      local intersections = matrix_inters[tostring(i)] or {}
      local p,q,c1,c2,shifted 
      p,c1,c2,q,shifted= bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
      modified = false
      print("BEZ i="..i,done[i])

      if not(intersections[1]==nil) and not(intersections[2]==nil) and (intersections[3]==nil) and done[i] == false  then 
	 local j1,t1,u1 = intersections[1][1], intersections[1][2], intersections[1][3]
	 local j2,t2,u2 = intersections[2][1], intersections[2][2], intersections[2][3]
	 local intersection_1,intersection_2 = intersections[1],intersections[2]
	 local temp_j,temp_t,temp_u
	 -- establish the correct order
	 print("BEZ ----------------")
	 print("BEZ i="..i,done[i])
	 if t1 > t2 then 
	    print("BEZ t1>t2")
	    temp_j,temp_t,temp_u = j1,t1,u1
	    j1,t1,u1 = j2,t2,u2
	    j2,t2,u2 = temp_j,temp_t,temp_u
	    intersection_1,intersection_2 = intersections[2], intersections[1]
	 end
	 print("BEZ i="..i,"j1="..j1,"t1="..t1,"u1="..u1)
	 print("BEZ i="..i,"j2="..j2,"t2="..t2,"u2="..u2)
	 --_print_curve_intersections('3a',valid_curves,matrix_inters,i)      
	 if math.abs(t1-u1)<0.1 and done[i] == false and reverse == false then --and math.abs(t2-u2)<0.1 then 
	   modified = true
	    done[0+j1] = true 
	    print("BEZ  i="..i,"math.abs(t1-u1)<0.1")
	    print(string.format("BEZ  i=%s,p=%s,c1=%s,c2=%s,q=%s, shifted=%s",i,p,c1,c2,q,tostring(shifted)))
	    print("BEZ store for i {j1,t1,tostring(1-u1)}=",j1,t1,tostring(1-u1))
	    matrix_inters[tostring(i)] =  {{j1,t1,tostring(1-u1)},{j2,t2,u2}}
	    --
	    -- modify j1
	    -- 
	    local _bezier = temp_valid_curves[0+j1]
	    p,c1,c2,q,shifted= _bezier[1],_bezier[2],_bezier[3],_bezier[4],_bezier[5]
	    valid_curves[0+j1] = {q,c2,c1,p,shifted}
	   -- arrange j1 intersection only for t, not for u
	    intersections = matrix_inters[tostring(j1)] or {}
	    local jj1,tt1,uu1 = intersections[1][1], intersections[1][2], intersections[1][3]
	    local jj2,tt2,uu2 = intersections[2][1], intersections[2][2], intersections[2][3]
	    print("BEZ j1="..j1, "jj1="..jj1,"jj2="..jj2,"i="..i,tonumber(jj1)==i)
	    _print_curve_intersections('(pre) t1-u1<0.1',valid_curves,matrix_inters,j1)      
	    if tonumber(jj1) == i then 
	       print("BEZ 1-tt1",1-tt2)
	       intersections[1][1], intersections[1][2], intersections[1][3] = jj1,tostring(1-tt1),tostring(uu1)
	       intersections[2][2], intersections[2][3] = tostring(1-tt2),tostring(1-uu2)
	       reverse = true 
	       next_path = jj2
	       prev_path =j1
	    elseif tonumber(jj2) == i then 
	       print("BEZ 1-tt2",1-tt2)
	       intersections[2][1], intersections[2][2], intersections[2][3] = jj2,tostring(1-tt2),uu2
	       intersections[2][2], intersections[2][3] = tostring(1-tt1),tostring(1-uu1)
	       reverse = true 
	       next_path = jj1
	       prev_path =j1
	    end
	    _print_curve_intersections('t1-u1<0.1',valid_curves,matrix_inters,j1)      
	    done[i]=true
	 elseif math.abs(t2-u2)<0.1 and done[i] == false and reverse == false then 
	    modified = true
	    done[0+j2] = true 
	    print("BEZ  i="..i,"math.abs(t2-u2)<0.1")
	    print(string.format("BEZ  i=%s,p=%s,c1=%s,c2=%s,q=%s, shifted=%s",i,p,c1,c2,q,tostring(shifted)))
	    intersections_2={j2,t2,tostring(1-u2)}
	    print("BEZ intersections_2=",j2,t2,tostring(1-u2))
	    print("BEZ store for i {j2,t2,tostring(1-u2)} = ",j2,t2,tostring(1-u2))
	    matrix_inters[tostring(i)] =  {{j1,t1,u1},{j2,t2,tostring(1-u2)}}
	    --
	    -- modify j2
	    --
	    local _bezier = temp_valid_curves[0+j2]
	    p,c1,c2,q,shifted= _bezier[1],_bezier[2],_bezier[3],_bezier[4],_bezier[5]
	    valid_curves[0+j2] = {q,c2,c1,p,shifted}
	    -- arrange j2 intersection only for t, not for u
	    intersections = matrix_inters[tostring(j2)] or {}
	    local jj1,tt1,uu1 = intersections[1][1], intersections[1][2], intersections[1][3]
	    local jj2,tt2,uu2 = intersections[2][1], intersections[2][2], intersections[2][3]
	    print("BEZ jj1="..jj1,"jj2="..jj2,"i="..i,tonumber(jj1)==i)
	    _print_curve_intersections('(pre)t2-u2<0.1',valid_curves,matrix_inters,j2)      
	    if tonumber(jj1) == i then 
	       print("BEZ 1-tt1",1-tt1)
	       intersections[1][1], intersections[1][2], intersections[1][3] = jj1,tostring(1-tt1),uu1
	       intersections[2][2], intersections[2][3] = tostring(1-tt2),tostring(1-uu2)
	       reverse = true 
	       next_path = jj2
	       prev_path =j2
	    elseif tonumber(jj2) == i then 
	       print("BEZ 1-tt2",1-tt2)
	       intersections[2][1], intersections[2][2], intersections[2][3] = jj2,tostring(1-tt2),uu2
	       intersections[1][2], intersections[1][3] = tostring(1-tt1),tostring(1-uui)
	       reverse = true 
	       next_path = jj1
	       prev_path = j2
	    end
	    _print_curve_intersections('t2-u2<0.1',valid_curves,matrix_inters,j2)      
	    done[i]=true
	 elseif reverse == true and done[i]==false then 
	    -- check if we must reverse this path
	    print("BEZ **reverse i="..i,"prev_path="..prev_path,type(prev_path))
	    _print_curve_intersections('(pre) reverse',valid_curves,matrix_inters,i)      
	    --valid_curves[0+i] = {q,c2,c1,p,shifted}

	    local jj1,tt1,uu1 = intersections[1][1], intersections[1][2], intersections[1][3]
	    local jj2,tt2,uu2 = intersections[2][1], intersections[2][2], intersections[2][3]
	    print("BEZ jj1,tt1,uu1=",jj1,tt1,uu1,jj1==prev_path,type(jj1))
	    print("BEZ jj2,tt2,uu2=",jj2,tt2,uu2,jj2==prev_path,type(jj2))

	    if jj1 == tostring(prev_path) then 
	       print("BEZ jj1==prev_path,jj1="..jj1)
	       if math.abs(1-tt1) < 0.1 then -- it's ok  t1~1
		  -- useless 
		  intersections[1][2], intersections[1][3] = tostring(tt1),tostring(uu1)
		  if math.abs(tt2-uu2) < 0.1  then
		     intersections[2][2], intersections[2][3] = tostring(tt2),tostring(1-uu2)
		     reverse = true 
		     next_path = jj2
		     prev_path = i
		     modified = true
		  end
	       end
	       if math.abs(1-tt1) > 0.1 then -- it's not ok  t1~0
		  intersections[1][2], intersections[1][3] = tostring(1-tt1),tostring(1-uu1)
		  valid_curves[0+i] = {q,c2,c1,p,shifted}
		  modified = true
		  if math.abs(tt2-uu2) < 0.1  then -- tt2~
		     intersections[2][2], intersections[2][3] = tostring(tt2),tostring(1-uu2)
		     reverse = true 
		     next_path = jj2
		     prev_path = i
		     modified = true
		  end
	       end



	       if math.abs(1-tt1) > 0.1 then 
		  intersections[1][2], intersections[1][3] = tostring(1-tt1),tostring(1-uu1)
		  valid_curves[0+i] = {q,c2,c1,p,shifted}
		  modified = true
	       end
	       if math.abs(tt2-uu2) < 0.1  then
		  intersections[2][2], intersections[2][3] = tostring(1-tt2),uu2
		  reverse = false 
	       else
		  intersections[2][2], intersections[2][3] = tostring(1-tt2),tostring(1-uu2)
		  reverse = true 
		  next_path = jj2
		  prev_path = i
		  modified = true
	       end
	    elseif jj2 == tostring(prev_path) then
	       print("BEZ jj2==prev_path,jj2="..jj2)
	       if math.abs(1-tt2) < 0.1 then --it's ok t2~1
		  -- useless
		  intersections[2][2], intersections[2][3] = tostring(tt2),tostring(uu2)
		  if math.abs(tt1-uu1) < 0.1  then
		     intersections[1][2], intersections[1][3] = tostring(tt1),tostring(1-uu1)
		     reverse = true  
		     next_path = jj1
		     prev_path = i
		     modified = true
		  end
	       end
	       if math.abs(1-tt2) > 0.1 then -- not ok t2~0
		  intersections[2][2], intersections[2][3] = tostring(1-tt2),tostring(1-uu2)
		  valid_curves[0+i] = {q,c2,c1,p,shifted}
		  modified = true
		  if math.abs(tt1-uu1) < 0.1  then -- t1~1 
		     intersections[1][2], intersections[1][3] = tostring(tt1),tostring(1-uu1)
		     reverse = true
		     next_path = jj1
		     prev_path = i
		     modified = true
		  end
	       end
	    end
	    done[i]=true
	    print("BEZ reverse=", reverse,"next_path=",next_path)
	    _print_curve_intersections('should be',valid_curves,matrix_inters,i)      
	 end
	 done[i]=true
	 print("BEZ i="..i,done[i])
      end --if not(intersections[1]==nil) and not(intersections[2]==nil) and (intersections[3]==nil)   then 
      --end --for i,bezier in pairs(temp_valid_curves) do
      print("BEZ modified=",modified,"reverse=",reverse,"next_path="..next_path)
      print("BEZ done[next_path]=",done[0+next_path])
      if done[0+next_path]==true  and reverse == true then reverse = false end
      print("BEZ end loop, -------------------------------")
      print("BEZ ")

      
   end --while
   return valid_curves,matrix_inters
end




local function _adjust_points(valid_curves,matrix_inters)
   --
   -- sanitize points 
   --
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v end
   local marked_curve = {}
   local valid_curves = {} --; for k,v in pairs(temp_valid_curves) do valid_curves[k] = v end

   for i,bezier in pairs(temp_valid_curves) do marked_curve[i]={}; marked_curve[i]['p'] = false;marked_curve[i]['q'] = false end
   for i,bezier in pairs(temp_valid_curves) do
      local intersections = matrix_inters[tostring(i)] or {}
      local p,q,c1,c2,shifted
      p,c1,c2,q,shifted= bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
      --local bezier1 = {bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]}
      print()
      print("BEZ (1) i="..i,"type(i)="..type(i),"p="..p,"q="..q)
      local w=string.gmatch(p,"[-0-9.]+"); p={w(),w()}
      w=string.gmatch(q,"[-0-9.]+"); q={w(),w()}
      print("BEZ i="..i, intersections[1], intersections[2], intersections[3])
      if not(intersections[1]==nil) and not(intersections[2]==nil) and (intersections[3]==nil)   then 
	 local j1,t1,u1 = intersections[1][1], intersections[1][2], intersections[1][3]
	 local j2,t2,u2 = intersections[2][1], intersections[2][2], intersections[2][3]
	 local p1,q1,p2,q2
	 local bez1 = temp_valid_curves[0+j1]
	 local bez2 = temp_valid_curves[0+j2]
	 j1 = tonumber(j1)
	 j2 = tonumber(j2)
	 p1,_,_,q1,_ = bez1[1],bez1[2],bez1[3],bez1[4],bez1[5]
	 p2,_,_,q2,_ = bez2[1],bez2[2],bez2[3],bez2[4],bez2[5]
	 print("BEZ j1="..j1,"type(j1)="..type(j1),"p1="..p1,"q1="..q1)
	 print("BEZ j2="..j2,"type(j2)="..type(j2),"p2="..p2,"q2="..q2)
	 w=string.gmatch(p1,"[-0-9.]+"); p1={w(),w()}
	 w=string.gmatch(q1,"[-0-9.]+"); q1={w(),w()}
	 w=string.gmatch(p2,"[-0-9.]+"); p2={w(),w()}
	 w=string.gmatch(q2,"[-0-9.]+"); q2={w(),w()}
	 
	 if math.floor(mflua.modul_vec(p,q1)) == 0 and marked_curve[i]['p'] ==false then 
	    local qq = q1
	    local M = mflua.modul_vec(p,qq)
	    local fi = (M>0 and mflua.angle(p,qq)) or 0
	    local P = string.format("(%s,%s)", p[1]+0.5*M*math.cos(fi),p[2]+0.5*M*math.sin(fi))
	    local Q = P
	    local t = marked_curve[i] or {}; t['p'] = P ; t['prev'] = j1; marked_curve[i]=t
	    t = marked_curve[j1] or {}; t['q'] = Q ; t['next'] = i; marked_curve[j1]=t
	    print("BEZ j1 marked_curve["..j1.."]['q']=" .. tostring(marked_curve[j1]['q']))
	 elseif   math.floor(mflua.modul_vec(p,q2)) == 0 and marked_curve[i]['p'] ==false then 
	    local qq = q2
	    local M = mflua.modul_vec(p,qq)
	    local fi = (M>0 and mflua.angle(p,qq)) or 0
	    local P = string.format("(%s,%s)", p[1]+0.5*M*math.cos(fi),p[2]+0.5*M*math.sin(fi))
	    local Q = P
	    local t = marked_curve[i] or {}; t['p'] = P ; t['prev']= j2; marked_curve[i]=t
	    t = marked_curve[j2] or {}; t['q'] = Q ; t['next'] = i; marked_curve[j2]=t
	    print("BEZ j2 marked_curve["..j2.."]['q']=" .. tostring(marked_curve[0+j2]['q']))
	end
	if math.floor(mflua.modul_vec(q,p1)) == 0 and marked_curve[i]['q'] ==false then 
	   local pp = p1
	   local M = mflua.modul_vec(q,pp)
	   local fi = (M>0 and mflua.angle(q,pp)) or 0
	   local Q = string.format("(%s,%s)", q[1]+0.5*M*math.cos(fi),q[2]+0.5*M*math.sin(fi))
	   local P = Q
	   local t = marked_curve[i] or {}; t['q'] = Q ; t['next'] = j1 ; marked_curve[i]=t
	   t = marked_curve[j1] or {}; t['p'] = P ; t['prev'] = i ;marked_curve[j1]=t
	   print("BEZ j1 marked_curve["..j1.."]['p']=" .. tostring(marked_curve[j1]['p']))
	elseif math.floor(mflua.modul_vec(q,p2)) == 0 and marked_curve[i]['q'] ==false then 
	   local pp = p2
	   local M = mflua.modul_vec(q,pp)
	   local fi = (M>0 and mflua.angle(q,pp)) or 0
	   local Q = string.format("(%s,%s)", q[1]+0.5*M*math.cos(fi),q[2]+0.5*M*math.sin(fi))
	   local P = Q
	   local t = marked_curve[i] or {}; t['q'] =Q ; t['next'] = j2 ;marked_curve[i]=t
	   --print("BEZ P="..P,"M="..M,"fi="..fi,"q="..q[1],q[2],"pp="..pp[1],pp[2])
	   --print("BEZ q="..type(q[1]),type(q[2]),"pp="..type(pp[1]),type(pp[2]))
	   local dot = mflua.dot
	   --print("BEZ acos(f)="	..   math.acos(dot(q,pp)/(math.sqrt(dot(q,q))*math.sqrt(dot(pp,pp)))))
	   --print("BEZ acos(f)="	..   dot(q,pp),math.sqrt(dot(q,q)),math.sqrt(dot(pp,pp)),  (math.sqrt(dot(q,q))*math.sqrt(dot(pp,pp))))
	   t = marked_curve[j2] or {}; t['p'] = P ;t['prev']=i; marked_curve[j2]=t
	   print("BEZ j2 marked_curve["..j2.."]['p']=" .. tostring(marked_curve[j2]['p']))
	end
	--print("BEZ vec(p,q1)="..mflua.modul_vec(p,q1))
	--print("BEZ vec(p,q2)="..mflua.modul_vec(p,q2))
	--print("BEZ vec(q,p1)="..mflua.modul_vec(q,p1))
	--print("BEZ vec(q,p2)="..mflua.modul_vec(q,p2))
	print("BEZ i="..i,"marked_curve[i]['p']=",marked_curve[i]['p'])
	print("BEZ i="..i,"marked_curve[i]['q']=",marked_curve[i]['q'])
	valid_curves[i] = {'(0,0)',c1,c2,'(0,0)',shifted}
	valid_curves[i][1] = marked_curve[i]['p'] or  '(0,0)'
	valid_curves[i][4] = marked_curve[i]['q'] or  '(0,0)'
	-- r = mflua.round5
	--p,q = valid_curves[i+0][1],valid_curves[i][4]
	--print("BEZ i, p="..r(p),"q="..r(q))
	--valid_curves[i][1] = r(p)
	-- valid_curves[i][4] = r(q)
     end
   end
   return valid_curves,matrix_inters
end -- _adjust_points

local function _adjust_boundaries(valid_curves) 
   --
   -- we add  mflua.threshold_extra_step  to begin/end of coll_ind
   --
   print("BEZ _adjust_boundaries")
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v end
   local valid_curves = {}
   -- local min = -1 -- coll_ind[1]
   -- local max = -1 -- coll_ind[#coll_ind]
   local coll_ind_inf = {}		     
   local coll_ind_sup = {}
   local extra = 2*mflua.threshold_extra_step 
   local values = math.ldexp(1,mflua.bit)+1
   for i, bezier in pairs(temp_valid_curves) do
      print("BEZ i="..i)
      local p,c1,c2,q,offset,coll_ind = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5],bezier[6]
      print("BEZ p,c1,c2,q,offset=",p,c1,c2,q,offset)
      for j,v in ipairs(coll_ind) do print("BEZ coll_ind i="..i,"j="..j,"v="..v) end
      -- adjust pixels boundaries  for horizontal/vertical lines
      local _p,_c1,_c2,_q =  _coord_str_to_table(p,c1,c2,q)
      local check = false 
      -- horizontal line
      if #coll_ind > 0 and (_p[2] == _c1[2]) and (_p[2] == _q[2] )  and (_q[2] == _c2[2]) and math.abs(_p[1]-_q[1]) <mflua.threshold_small_path_check_point then 
	 check = true 
	 -- vertical line
      elseif #coll_ind > 0 and (_p[1] == _c1[1]) and (_p[1] == _q[1] )  and (_q[1] == _c2[1]) and math.abs(_p[2]-_q[2]) <mflua.threshold_small_path_check_point then 
	 check = true 			   
      end
      if check == true then   print("BEZ i="..i,"adjust pixels boundaries  for horizontal/vertical lines") end

      coll_ind_inf = {}
      if check==true and (coll_ind[1] < values/mflua.threshold_small_path_check_point) then 
	 print("BEZ i="..i,"coll_ind_inf")
	 local l = coll_ind[1]
	 for k=1,l do coll_ind_inf[k] = k end 
      end
      coll_ind_sup = {}
      if check==true and (coll_ind[#coll_ind] > values - values/mflua.threshold_small_path_check_point) then 
	 print("BEZ i="..i,"coll_ind_sup")
	 local l = coll_ind[#coll_ind]
	 print("BEZ i="..i,"l="..l)
	 for k=l,values do coll_ind_sup[k] = k print("BEZ i="..i,"k="..k,coll_ind_sup[k]) end 
      end
      --print("BEZ #coll_ind_sup="..#coll_ind_sup)
      if check==true then -- and (#coll_ind_inf > 0 or #coll_ind_sup > 0) then 
	 print("BEZ merge")
	 local coll_ind_temp = {}
	 for i,v in pairs(coll_ind_inf) do coll_ind_temp[i] = v end
	 for i,v in pairs(coll_ind) do coll_ind_temp[#coll_ind_temp+1] = v end
	 print("BEZ #coll_ind_sup="..#coll_ind_sup)
	 for i,v in pairs(coll_ind_sup) do coll_ind_temp[#coll_ind_temp+1] = v print("BEZ v="..v) end
	 coll_ind = coll_ind_temp
	 for ii,v in pairs(coll_ind) do print("BEZ i="..i,"ii="..ii,"coll_ind[ii]="..v) end 
      end
      if check==false and #coll_ind>0 then 
	 print("BEZ i="..i,"adjust pixels boundaries  for general lines") 
	 -- we assume a single interval , but it's not true !!
	 coll_ind_inf = {}
	 if coll_ind[1] > 1  then 
	    local start =1
	    if coll_ind[1] - extra >0 then start = coll_ind[1] - extra end
	    for v=start,coll_ind[1]-1 do coll_ind_inf[#coll_ind_inf+1] = v  end
	    --for i,v in ipairs(coll_ind) do coll_ind_temp[#coll_ind_temp+1] = v end
	 end
	 coll_ind_sup = {}
	 print("BEZ coll_ind[#coll_ind]="..coll_ind[#coll_ind],"values="..values)
	 if coll_ind[#coll_ind] < values  then 
	    print("BEZ coll_ind[#coll_ind] < values")
	    local _end = values 
	    if coll_ind[#coll_ind] + extra <values then _end = coll_ind[#coll_ind] + extra end
	    for v=coll_ind[#coll_ind]+1,_end  do coll_ind_sup[#coll_ind_sup+1] = v  end
	 elseif #coll_ind>extra and coll_ind[#coll_ind] == values  and not(coll_ind[#coll_ind-extra]== values-extra) then
	 -- we should extend this also to coll_ind_inf and envelopes   
	    print("BEZ coll_ind[#coll_ind] == values")
	    for v=values-extra,values do coll_ind_sup[#coll_ind_sup+1] = v  end
	 end
	 if #coll_ind_inf > 0 or #coll_ind_sup > 0 then 
	    local coll_ind_temp = {}
	    for i,v in ipairs(coll_ind_inf) do coll_ind_temp[i] = v end
	    for i,v in ipairs(coll_ind) do coll_ind_temp[#coll_ind_temp+1] = v end
	    for i,v in ipairs(coll_ind_sup) do coll_ind_temp[#coll_ind_temp+1] = v end
	    coll_ind = coll_ind_temp
	 end


	 --coll_ind = coll_ind_temp
	 for j,v in ipairs(coll_ind) do print("BEZ coll_ind i="..i,"j="..j,"v="..v) end
      end
      -- if check==false then 
      -- 	 local coll_ind_temp = {}
      -- 	 for i,v in ipairs(coll_ind) do coll_ind_temp[#coll_ind_temp+1] = v end
      -- 	 -- we assume a single interval , but it's not true !!
      -- 	 if coll_ind[1] > 1  then 
      -- 	    coll_ind_temp = {}
      -- 	    local start =1
      -- 	    if coll_ind[1] - extra >0 then start = coll_ind[1] - extra end
      -- 	    for v=start,coll_ind[1]-1 do coll_ind_temp[#coll_ind_temp+1] = v  end
      -- 	    for i,v in ipairs(coll_ind) do coll_ind_temp[#coll_ind_temp+1] = v end
      -- 	    --coll_ind = coll_ind_temp
      -- 	 end
      -- 	 coll_ind = coll_ind_temp
      -- end
      valid_curves[i] ={p,c1,c2,q,offset,coll_ind}
      --print("BEZ i="..#valid_curves,p,c1,c2,q)
      --for k,v in ipairs(coll_ind) do print("BEZ coll_ind i="..#valid_curves,k,v) end
   end
   return valid_curves
end




local function _adjust_boundaries_envelope(valid_curves) 
   --
   -- we add  mflua.threshold_extra_step  to begin/end of coll_ind
   --
   print("BEZ _adjust_boundaries_envelope")
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v end
   local valid_curves = {}
   -- local min = -1 --coll_ind[1]
   -- local max = -1 --coll_ind[#coll_ind]
   local coll_ind_inf = {}		     
   local coll_ind_sup = {}
   local extra = 3*mflua.threshold_extra_step 
   local values = math.ldexp(1,mflua.bit)+1
   for i, bezier in pairs(temp_valid_curves) do
      --print("BEZ -----")
      local p,c1,c2,q,offset,coll_ind = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5],bezier[6]
      --for j,v in ipairs(coll_ind) do print("BEZ coll_ind i="..i,"j="..j,"v="..v) end

      -- adjust pixels boundaries  for horizontal/vertical lines
      local _p,_c1,_c2,_q =  _coord_str_to_table(p,c1,c2,q)
      local check = false 
      -- horizontal line
      if #coll_ind > 0 and (_p[2] == _c1[2]) and (_p[2] == _q[2] )  and (_q[2] == _c2[2]) and math.abs(_p[1]-_q[1]) <mflua.threshold_small_path_check_point then 
	 check = true 
	 -- vertical line
      elseif #coll_ind > 0 and (_p[1] == _c1[1]) and (_p[1] == _q[1] )  and (_q[1] == _c2[1]) and math.abs(_p[2]-_q[2]) <mflua.threshold_small_path_check_point then 
	 check = true 			   
      end
      if check == true then       print("BEZ adjust pixels boundaries  for horizontal/vertical lines") end

      coll_ind_inf = {}
      if check==true and (coll_ind[1] < values/mflua.threshold_small_path_check_point) then 
	 local l = coll_ind[1]
	 for k=1,l do coll_ind_inf[k] = k end 
      end
      coll_ind_sup = {}
      if check==true and (coll_ind[#coll_ind] > values - values/mflua.threshold_small_path_check_point) then 
	 local l = coll_ind[#coll_ind]
	 for k=l,values do coll_ind_sup[k] = k end 
      end
      if check==true then -- and (#coll_ind_inf > 0 or #coll_ind_sup > 0) then 
	 local coll_ind_temp = {}
	 for i,v in pairs(coll_ind_inf) do coll_ind_temp[i] = v end
	 for i,v in pairs(coll_ind) do coll_ind_temp[#coll_ind_temp+1] = v end
	 for i,v in pairs(coll_ind_sup) do coll_ind_temp[#coll_ind_temp+1] = v end
	 coll_ind = coll_ind_temp
      end
      if check==false and #coll_ind>0 then 
	 -- we assume a single interval , but it's not true !!
	 coll_ind_inf = {}
	 if coll_ind[1] > 1  then 
	    local start =1
	    if coll_ind[1] - extra >0 then start = coll_ind[1] - extra end
	    for v=start,coll_ind[1]-1 do coll_ind_inf[#coll_ind_inf+1] = v  end
	    --for i,v in ipairs(coll_ind) do coll_ind_temp[#coll_ind_temp+1] = v end
	 end
	 coll_ind_sup = {}
	 if coll_ind[#coll_ind] < values  then 
	     local _end = values 
	     if coll_ind[#coll_ind] + extra <values then _end = coll_ind[#coll_ind] + extra end
	     for v=coll_ind[#coll_ind]+1,_end  do coll_ind_sup[#coll_ind_sup+1] = v  end
	     --for i,v in ipairs(coll_ind) do coll_ind_temp[#coll_ind_temp+1] = v end
	 end
	 if #coll_ind_inf > 0 or #coll_ind_sup > 0 then 
	    local coll_ind_temp = {}
	    for i,v in ipairs(coll_ind_inf) do coll_ind_temp[i] = v end
	    for i,v in ipairs(coll_ind) do coll_ind_temp[#coll_ind_temp+1] = v end
	    for i,v in ipairs(coll_ind_sup) do coll_ind_temp[#coll_ind_temp+1] = v end
	    coll_ind = coll_ind_temp
	 end
	 --coll_ind = coll_ind_temp
      end
      valid_curves[i] ={p,c1,c2,q,offset,coll_ind}
      --print("BEZ i="..#valid_curves,p,c1,c2,q)
      --for k,v in ipairs(coll_ind) do print("BEZ coll_ind i="..#valid_curves,k,v) end
   end
   return valid_curves
end


local function _fix_intersection_bug(valid_curves,matrix_inters)
   --
   -- a fix for an error found on ccr5 y 
   --
   local  bit=mflua.bit  or nil 
   local L=math.ldexp(1,bit)

   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v end
   local temp_temp_valid_curves = {}
   --local marked_curve = {}
   local valid_curves = {} --; for k,v in pairs(temp_valid_curves) do valid_curves[k] = v end
   print("BEZ _fix_intersection_bug")
   --for i,bezier in pairs(temp_valid_curves) do marked_curve[i]={}; marked_curve[i]['p'] = false;marked_curve[i]['q'] = false end
   for i,bezier in pairs(temp_valid_curves) do
      local intersection  = matrix_inters[tostring(i)] or {}
      if not(intersection==nil) and not(intersection[2]==nil) and (intersection[3]==nil) then 
	 local intersections = matrix_inters[tostring(i)] or {}
	 local p,q,c1,c2,shifted
	 p,c1,c2,q,shifted= bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
	 local m1 = intersection[1]
	 local j1,t1,u1 = m1[1]+0.,m1[2]+0.,m1[3]+0.
	 local m2 = intersection[2] 
	 local j2,t2,u2 = m2[1]+0.,m2[2]+0.,m2[3]+0.
	 --
	 -- we assume a correct timeline
	 --
	 if (0.2<t1 and t1<0.5) and (0.5<u1 and u1<0.99) then 
	    print("BEZ i="..i,"found j1="..j1)
	    print("BEZ t1="..t1,"u1="..u1)
	    local bez1 = temp_valid_curves[j1]
	    local p_1,c1_1,c2_1,q_1,shifted_1= bez1[1],bez1[2],bez1[3],bez1[4],bez1[5]
	    local bez2 = temp_valid_curves[j2]
	    local p_2,c1_2,c2_2,q_2,shifted_2= bez2[1],bez2[2],bez2[3],bez2[4],bez2[5]
	    
	    local px,py,c1x,c1y,c2x,c2y,qx,qy
	    local values={0};for i=1,L-1 do values[i+1]= math.ldexp(i,-bit) end; values[#values+1]=1
	    local min = {mflua.threshold_bug,t}
	    print("BEZ p="..p,"q="..q)
	    print("BEZ p_2="..p_2, "q_2="..q_2)
	    p_2,c1_2,c2_2,q_2,shifted_2= _coord_str_to_table(bez2[1],bez2[2],bez2[3],bez2[4],bez2[5])
	    w=string.gmatch(p_1,"[-0-9.]+") px,py=w(),w()
	    w=string.gmatch(c1_1,"[-0-9.]+"); c1x,c1y=w(),w()
	    w=string.gmatch(c2_1,"[-0-9.]+"); c2x,c2y=w(),w()
	    w=string.gmatch(q_1,"[-0-9.]+"); qx,qy=w(),w()
	    w=string.gmatch(shifted_1,"[-0-9.]+"); xo,yo=w(),w()
	    for index,t in ipairs(values) do
	       local x,y,new_p,new_c1,new_c2,new_q = bez({px,py},{c1x,c1y},{c2x,c2y},{qx,qy},t)
	       if mflua.modul_vec({x,y},p_2) < min[1] then 
		  min = {mflua.modul_vec({x,y},p_2),new_p,new_c1,new_c2,new_q,{xo,yo},t} 
	       end
	    end
	    print("min |p-(x,y)| = "..min[1],min[2])
	    if min[1] < mflua.threshold_min_bug then 
	       local new_p,new_c1,new_c2,new_q,new_o,t = min[2],min[3],min[4],min[5],min[6],min[7]
	       p_1,c1_1,c2_1,q_1,shifted_1 = _coord_table_to_str(new_p,new_c1,new_c2,new_q,new_o)
	       q_1 = string.format("(%s,%s)",p_2[1],p_2[2])
	       print("BEZ shifted_1=",shifted_1,p_1,c1_1,c2_1,q_1)
	       temp_temp_valid_curves[j1+0] = {p_1,c1_1,c2_1,q_1,shifted_1}
	       -- correct matrix_inters
	       local intersec_j2 = matrix_inters[tostring(j2)]  
	       local intersec_j1 = matrix_inters[tostring(j1)] 
	       if 1.0*intersec_j1[1][1] == i then 
		  intersec_j1[1][1] = j2
		  intersec_j1[1][2] = '1'
		  intersec_j1[1][3] = '0'
		  matrix_inters[tostring(j1)]  = intersec_j1
	       elseif 1.0*intersec_j1[2][1] == i then 
		  intersec_j1[2][1] = j2
		  intersec_j1[2][2] = '1'
		  intersec_j1[2][3] = '0'
		  matrix_inters[tostring(j1)]  = intersec_j1
	       end
	       if 1.0*intersec_j2[1][1] == i then 
		  intersec_j2[1][1] = j1
		  intersec_j2[1][2] = '0'
		  intersec_j2[1][3] = '1'
		  matrix_inters[tostring(j2)]  = intersec_j2
	       elseif 1.0*intersec_j2[2][1] == i then 
		  intersec_j2[2][1] = j1
		  intersec_j2[2][2] = '0'
		  intersec_j2[2][3] = '1'
		  matrix_inters[tostring(j2)]  = intersec_j2
	       end
	       dropped[tostring(i)] = true 
	    end

	 elseif (0.2<t2 and t2<0.5) and (0.5<u2 and u2<0.99) then 
	    print("BEZ i="..i,"found j2="..j2)
	    print("BEZ t2="..t2,"u2="..u2)
	 end
	 -- local w=string.gmatch(p,"[-0-9.]+"); p={w(),w()}
	 -- w=string.gmatch(q,"[-0-9.]+"); q={w(),w()}
      end
   end
   valid_curves = {}
   for k,v in pairs(temp_valid_curves) do 
      if not(dropped[tostring(k)]) then
	 local intersection  = matrix_inters[tostring(k)] or {}
	 local temp = {}
	 valid_curves[k] = v 
	 for _,v in ipairs( intersection) do 
	    if not(dropped[tostring(v[1])]) then 
	       temp[#temp+1] = {v[1],v[2],v[3]}
	    end
	 end
	 matrix_inters[tostring(k)] = temp 
      else
	 matrix_inters[tostring(k)] = nil
	 print("BEZ k="..k.." cutted")
      end
   end
   for k,v in pairs(temp_temp_valid_curves) do 
      print("BEZ k="..k,matrix_inters[tostring(k)][1][1],matrix_inters[tostring(k)][2])
      valid_curves[k] = v 
   end
   return valid_curves,matrix_inters
end



local function _clean_up_contour(char)
   local res = ''
   local f = mflua.print_specification.outfile1
   local beziers = char['contour'] or  {}
   local offset = '(0,0)'
   local valid_curves = {}
   local coll_ind = {}
   for i1, bezier in ipairs(beziers) do
      for i, contour in ipairs(bezier) do
	 local path_list = contour['path_list']
	 for j=1 ,#path_list do
	    local path = path_list[j]
	    local p,c1,c2,q = path['p'],path['control1'],path['control2'],path['q']
	    if not(q==nil) then 
	       res = res  .. string.format("label(\"i1=%s, i=%s\",0.5(%s+%s));\n",i1,i,q,p)
	       f:write(res)
	       res =''
	       local nr_ok,values,coll_ind =  _check_point(char,p,c1,c2,q,offset)
	       if (nr_ok-values) == 0 then 
		  res = res .. "drawoptions(withcolor yellow withpen pencircle scaled 0.04pt);\n"
		  res = res  .. string.format("draw %s -- %s -- %s --%s -- cycle;\n",p,c1,c2,q)
		  f:write(res)
		  res = ''
		  -- a patch !!!
		  valid_curves[#valid_curves+1] ={p,c1,c2,q,offset,{1}}
		  -- why not this ?
		  --valid_curves[#valid_curves+1] ={p,c1,c2,q,offset,{values-2,values-1,values}}
		  else 
		     valid_curves[#valid_curves+1] ={p,c1,c2,q,offset,coll_ind}
		  end
	    end
	 end
      end
   end
   --return res
   return valid_curves
end

local function _clean_up_envelope(char)
   local res = ''
   local f = mflua.print_specification.outfile1
   local bezier_octant
   local offsets,path_list,offset_list
   local shifted 
   local p,c1,c2,q,offset,segment
   local pen
   local beziers
   local first_point, last_point 
   local first_point_with_offset={}
   local last_point_with_offset={}
   local knots_list = char['knots'] or {} 
   local knots, knot
   local first_pen = {} 
   local last_pen  ={}
   local knots_set = {}
   local valid_curves = {}
   local valid_curves_pen = {}
   bezier_octant = char['envelope'] or  {}
   char['envelope'] = bezier_octant
   print("BEZ ENV.",#char['envelope'])
   --for h,bezier_octant in ipairs(char['envelope']) do 
   for m=1, #char['envelope']  do ---(#char['envelope']-1) do
      bezier_octant = char['envelope'][m]
      --for i,v in ipairs(bezier_octant) do
      --print("BEZ #bezier_octant="..#bezier_octant)
      first_point= ''
      last_point = ''
      knots = knots_list[m]
      for i=1, #bezier_octant do
	 beziers = bezier_octant[i]
	 -- maybe pen is of  envelope ?
	 pen = beziers['pen']
	 offsets = beziers['offsets']
	 path_list = beziers['path_list'] or {}
	 offset_list = beziers['offset_list']
	 for j=1,#path_list do
	    path=path_list[j]
	    p,c1,c2,q,offset = path['p'],path['control1'],path['control2'],path['q'],path['offset']  	 
	    for i,v in ipairs(offset_list) do 
	       if v[1] == (0+offset) then 
		  shifted = v[2] 
		  break 
	       end 
	    end 
	    if string.len(first_point) == 0 then
	       first_point = _eval(p,shifted)
	       first_point_with_offset={p,shifted}
	    end
	    if (q == nil) then
	       -- it's  a ?
	       local nr_ok,values,coll_ind
	       res = res .. "drawoptions(withcolor red withpen pencircle scaled 2pt);\n"
	       res = res  .. string.format("path p; p:= %s ;draw p  shifted %s ;\n",p,shifted)
	       --res = res ..  string.format("label(\"e=%s,o=%s,p=%s\",(%s+%s)) ;\n",m,i,j,p,shifted) 
	       if string.len(last_point) > 0 and not(last_point == _eval(p,shifted)) then 
		  nr_ok,values,coll_ind =  _check_point(char,last_point,last_point,_eval(p,shifted),_eval(p,shifted),'(0,0)')
		  if (nr_ok-values) == 0 then 
		     res = res .. "drawoptions(withcolor (0.5,0,0) withpen pencircle scaled 0.4pt);\n"
		     res = res  .. string.format("path p; p:= %s .. controls  %s and %s .. %s; draw p;\n",
						 last_point,last_point,_eval(p,shifted),_eval(p,shifted))
		  elseif tonumber(nr_ok) == 0 then  
		     valid_curves[#valid_curves+1] ={last_point,last_point,_eval(p,shifted),_eval(p,shifted),'(0,0)',coll_ind}
		     --print("BEZ 1) #valid_curves="..#valid_curves)
		  end
	       end
	       f:write(res)
	       last_point = _eval(p,shifted)
	       last_point_with_offset={p,shifted}
	       res = ''
	    else -- not(q == nil)
	       local nr_ok,values 
	       if string.len(last_point) > 0 and not(last_point == _eval(p,shifted)) then 
		  
		  nr_ok,values,coll_ind =  _check_point(char,last_point,last_point,_eval(p,shifted),_eval(p,shifted),'(0,0)')
		  if (nr_ok-values) == 0 then 
		     res = res .. "drawoptions(withcolor (0.5,0,0) withpen pencircle scaled 0.4pt);\n"
		     res = res  .. string.format("path p; p:= %s .. controls  %s and %s .. %s; draw p;\n",
						 last_point,last_point,_eval(p,shifted),_eval(p,shifted))
		  --else
		  elseif tonumber(nr_ok) >= 0 then  
		     valid_curves[#valid_curves+1] ={last_point,last_point,_eval(p,shifted),_eval(p,shifted),'(0,0)',coll_ind}
		     --print("BEZ 2) #valid_curves="..#valid_curves)
		  end
	       end
	       last_point = _eval(q,shifted)
	       last_point_with_offset={q,shifted}
	       nr_ok,values,coll_ind =  _check_point(char,p,c1,c2,q,shifted)
	       if (nr_ok-values) == 0 then 
		  -- res = res .. "drawoptions(withcolor red withpen pencircle scaled 0.4pt);\n"
		  -- res = res  .. string.format("path p; p:= %s .. controls  %s and %s .. %s; draw p  shifted %s ;\n",p,c1,c2,q,shifted)
		  --res = res ..  string.format("label(\"P,e=%s,o=%s,p=%s\",(%s+%s)) ;\n",m,i,j,p,shifted) 
		  --res = res ..  string.format("label(\"Q,e=%s,o=%s,p=%s\",(%s+%s)) ;\n",m,i,j,q,shifted) 
		  -- f:write(res)
		  res = ''
	       else
		  --res = res ..  string.format("label(\"P,e=%s,o=%s,p=%s\",(%s+%s)) ;\n",m,i,j,p,shifted) 
		  --res = res ..  string.format("label(\"Q,e=%s,o=%s,p=%s\",(%s+%s)) ;\n",m,i,j,q,shifted) 
		  --f:write(res)
		  res = ''
		  valid_curves[#valid_curves+1] ={p,c1,c2,q,shifted,coll_ind}
		  --print("BEZ 3) #valid_curves="..#valid_curves)
	       end
	    end -- if (q==nil=
	 end -- for j=1,#path_list do
	 --
	 -- check pen
	 --
	 local coll_ind_pen = {}
	 for i = 1,1+math.ldexp(1,mflua.bit) do coll_ind_pen[i] = i end
	 --knots_set = {} 
	 --for k=1,#knots do -- should be this but it's too much slow. and broke s of ccr5  By the way, it must be set for sym.mf .
         -- a solution is to use #knots when #knots is small
	 for _,k in ipairs({1,math.floor(#knots/2),1+math.floor(#knots/2),#knots}) do
         -- for _,k in ipairs({1,math.floor(#knots/2)}) do
	    local key =''
	    knot = knots[k]
	    p,c1,c2,q,s = knot[1],knot[2],knot[3],knot[4],knot[5]
	    -- try to avoid useless check
	    key = p ..c1 ..c2 ..q .. table.concat(pen)
	    -- print("BEZ key="..key,"knots_set[key]="..tostring(knots_set[key]))
	    if knots_set[key]~=nil  then break else  knots_set[key]=true end
	    local limit_pen = #pen
	    pen[#pen+1] = pen[1]
	    for l=1,limit_pen do 
	       local nr_ok,nr_ok_1,values =1,1,1
	       -- p = pen[l] q = pen[l+1]
	       local w 
	       local pen_c1 = _make_straight_line(pen[l],pen[l+1]) 
	       nr_ok,values =  _check_single(char,pen[l],p)
	       nr_ok_1,values =  _check_single(char,pen[l+1],p)
	       if nr_ok==1 and nr_ok_1==1 then 
		  --
	       else
		  f:write("%%%%%%% check pen \n")
		  res = "drawoptions(withcolor green withpen pencircle scaled 0.1pt);\n"
		  res = res  .. string.format("path p; p:= %s .. controls  %s and %s .. %s; draw p  shifted %s ;\n",pen[l],pen_c1,pen_c1,pen[l+1],p)
		  f:write(res)
		  res = ''
		  nr_ok,values,coll_ind_pen =  _check_pen_point(char,pen[l],pen_c1,pen_c1,pen[l+1],p)
		  f:write("%%%%%%% check pen nr_ok="..nr_ok," values="..values,"\n")
		  if (nr_ok-values) ~= 0 then 
		     valid_curves_pen[#valid_curves_pen+1] ={pen[l],pen_c1,pen_c1,pen[l+1],p,coll_ind_pen}
		     --print("BEZ 4) #valid_curves="..#valid_curves_pen)
		  end
	       end
	       nr_ok,nr_ok_1,values =1,1,1
	       -- p = pen[l] q = pen[l+1]
	       local w 
	       local pen_c1 = _make_straight_line(pen[l],pen[l+1]) 
	       nr_ok,values =  _check_single(char,pen[l],q)
	       nr_ok_1,values =  _check_single(char,pen[l+1],q)
	       if nr_ok==1 and nr_ok_1==1 then 
		  --
	       else
		  f:write("%%%%%%% check pen \n")
		  res = "drawoptions(withcolor green withpen pencircle scaled 0.1pt);\n"
		  res = res  .. string.format("path p; p:= %s .. controls  %s and %s .. %s; draw p  shifted %s ;\n",pen[l],pen_c1,pen_c1,pen[l+1],q)
		  f:write(res)
		  res = ''
		  nr_ok,values,coll_ind_pen =  _check_pen_point(char,pen[l],pen_c1,pen_c1,pen[l+1],q)
		  f:write("%%%%%%% check pen nr_ok="..nr_ok," values="..values,"\n")
		  if (nr_ok-values) ~= 0 then 
		     valid_curves_pen[#valid_curves_pen+1] ={pen[l],pen_c1,pen_c1,pen[l+1],q,coll_ind_pen}
		     --print("BEZ 5) #valid_curves="..#valid_curves_pen)
		  end
	       end
	    end;
	    --f:write(res); res = ''
	 end -- for k=1,#knots
	 --print("BEZ the pen end")
      end -- for i=1, #bezier_octant do
      local nr_ok,values 
      if not(last_point == first_point) then 
	 nr_ok,values,coll_ind =  _check_point(char,last_point,last_point,first_point,first_point,'(0,0)')
	 if (nr_ok-values) == 0 then 
	    res = res .. "drawoptions(withcolor (0.5,0,0) withpen pencircle scaled 0.4pt);\n"
	    res = res  .. string.format("path p; p:= %s .. controls  %s and %s .. %s; draw p;\n",
					last_point,last_point,first_point,first_point)
	    f:write(res)
	    res = ''
	 else
	    valid_curves[#valid_curves+1] ={last_point,last_point,first_point,first_point,'(0,0)',coll_ind}
	    --print("BEZ 6) #valid_curves="..#valid_curves)
	 end
      end -- if not(last_point == first_point) 
   end --    for m=1,#char['envelope'] 
   return valid_curves,valid_curves_pen
end



function end_program()
   local chartable = mflua.chartable 
   local f = mflua.print_specification.outfile1 or nil
   -- some mflua instances cannot have this file open
   if f==nil then return end
   local res = ""
   local t = {}
   f:write("\\starttext\n\\setupbodyfont[tt,2pt]\\bf\n")
   for k,_ in pairs(chartable) do t[#t+1]=k end
   table.sort(t)
   for i,_ in ipairs(t) do
      local valid_curves_e = {}
      local valid_curves_c = {}
      local valid_curves_p = {}
      local valid_curves_p_set= {}
      local valid_curves = {}
      local matrix_inters = {}
      local dropped = {}
      local coll_ind= {}
      local index = t[i]
      local char= chartable[index]
      local edges = char['edges']
      local ye_map = {}
      for i,v in ipairs(edges[1][1]) do ye_map[v[1]] = i  end
      char['edges_map'] = ye_map 
      f:write("\\startMPpage\n")
      res = res .. "%% char " .. index .."\n"
      local pre_res = char['pre_res'] or ""
      res = res .. pre_res .."\n"
      local v_res = char['res'] or ""
      res = res .. v_res .."\n"
      local post_res = char['post_res'] or ""
      res = res .. post_res .."\n"
      f:write(res)
      res = ''
      -- clean contours
      valid_curves_c =  _clean_up_contour(char)
      -- clean envelopes 
      valid_curves_e,valid_curves_p =   _clean_up_envelope(char)
      f:write("\n\\stopMPpage\n")
      res = ''
      f:write("\\startMPpage\n")

      --
      -- adjust boundaries
      --
      valid_curves_c =_adjust_boundaries(valid_curves_c) 
      valid_curves_e =_adjust_boundaries_envelope(valid_curves_e) 

      --
      -- merge the sets of curves 
      --
      if #valid_curves_c > 0 then 
	 valid_curves = valid_curves_c 
      end
      if #valid_curves_e > 0 then 
	  for i=1, #valid_curves_e do valid_curves[#valid_curves+1] = valid_curves_e[i] end
      end
      if #valid_curves_p > 0 then 
	  for i=1, #valid_curves_p do valid_curves[#valid_curves+1] = valid_curves_p[i]; valid_curves_p_set[#valid_curves]=true end
      end
      -- a set for valid_curves_p_set (only true or false, not nil)
      -- Maybe when a pen path is deleted it must be deleted also in this set
      for k,v in pairs(valid_curves) do if  valid_curves_p_set[k]==nil then valid_curves_p_set[k]=false end end


      --
      -- include the offset
      --
      temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v end
      for i, bezier in pairs(temp_valid_curves) do
	 local p,c1,c2,q,shifted,coll_ind = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5],bezier[6]
	 local w
	 w=string.gmatch(p,"[-0-9.]+"); p={w(),w()}
	 w=string.gmatch(c1,"[-0-9.]+"); c1={w(),w()}
	 w=string.gmatch(c2,"[-0-9.]+"); c2={w(),w()}
	 w=string.gmatch(q,"[-0-9.]+"); q={w(),w()}
	 w=string.gmatch(shifted,"[-0-9.]+"); shifted={w(),w()}
	 p[1] = p[1]+shifted[1];p[2] = p[2]+shifted[2];
	 c1[1] = c1[1]+shifted[1];c1[2] = c1[2]+shifted[2];
	 c2[1] = c2[1]+shifted[1];c2[2] = c2[2]+shifted[2];
	 q[1] = q[1]+shifted[1];q[2] = q[2]+shifted[2];
	 p = string.format("(%s,%s)",p[1],p[2]) 
	 c1 = string.format("(%s,%s)",c1[1],c1[2])
	 c2 = string.format("(%s,%s)",c2[1],c2[2])
	 q = string.format("(%s,%s)",q[1],q[2])
	 valid_curves[i] = {p,c1,c2,q,'(0,0)',coll_ind}
      end


      --matrix_inters = _calculate_all_intersections(valid_curves)
      --_print_curve_intersections('0',valid_curves,matrix_inters)


      --
      -- re-arrange valid_curves by _split_curve
      -- 
      local temp_valid_curves = {}
      local temp_removed = {}
      for i=1, #valid_curves do
	 print("BEZ i="..i,"_split_curve")
	 local bez1 = valid_curves[i]
	 local p,c1,c2,q,shifted,coll_ind = bez1[1],bez1[2],bez1[3],bez1[4],bez1[5],bez1[6] 
	 for ii,v in ipairs(coll_ind) do print("BEZ i="..i,"ii=" ..ii ,"v="..v) end 
	 print("BEZ #coll_ind , 1+math.ldexp(1,mflua.bit)", #coll_ind , 1+math.ldexp(1,mflua.bit) )
	 print("BEZ #coll_ind < 1+math.ldexp(1,mflua.bit)?", #coll_ind < 1+math.ldexp(1,mflua.bit) )
	 if #coll_ind < 1+math.ldexp(1,mflua.bit) then 
	    print(string.format("BEZ i=%s,p=%s,c1=%s,c2=%s,q=%s,shifted=%s,#coll_ind=%s,max=%s",i,p,c1,c2,q,shifted,#coll_ind,1+math.ldexp(1,mflua.bit)))
	    local tab = _split_curve(p,c1,c2,q,shifted,coll_ind)
	    print("BEZ #tab=" ..#tab)
	    for j=1, #tab do 
	       print("BEZ #temp_valid_curves=" ..#temp_valid_curves)
	       print("BEZ tab[j]=" ) table.foreach(tab[j],print)
	       temp_valid_curves[#temp_valid_curves+1] = tab[j]
	       print("BEZ #temp_valid_curves="..#temp_valid_curves)
	    end
	 else 
	    temp_valid_curves[#temp_valid_curves+1] = {bez1[1],bez1[2],bez1[3],bez1[4],bez1[5]}
	    --temp_valid_curves[i] = {bez1[1],bez1[2],bez1[3],bez1[4],bez1[5]}
	 end
      end
      valid_curves = temp_valid_curves



      --
      -- calculate all intersections
      -- -rw-r--r-- 1 root root 110308890 2011-03-22 07:06 intersec.mf
      temp_valid_curves = {}
      temp_removed =  {}
      matrix_inters = _calculate_all_intersections(valid_curves)
      --_print_curve_intersections('1',valid_curves,matrix_inters)


      local check_loop = true 
      local check_valid_curves_1,check_valid_curves



      --
      -- remove isolate path
      --
      valid_curves, matrix_inters =  _remove_isolate_path(valid_curves,matrix_inters)
      --_print_curve_intersections('2',valid_curves,matrix_inters)



      -- PROBLEMS with s of ccr5 !!!!!!!!!!!!!!!!!
      -- the serifs of s are 
      -- remove duplicate paths 

      valid_curves, matrix_inters =  _remove_duplicate_path_I(valid_curves,matrix_inters)
      --_print_curve_intersections('3',valid_curves,matrix_inters)



      --
      -- try to remove pen path outside the edge structure
      --
      valid_curves,matrix_inters = _open_pen_loop_0(valid_curves,matrix_inters,valid_curves_p_set,char)


      --
      -- try to remove duplicate pen path 
      --
      valid_curves,matrix_inters = _remove_duplicate_pen_path(valid_curves,matrix_inters,valid_curves_p_set)





      --
      -- pending paths I
      --
      check_loop = true 
      check_valid_curves = 0 ; for _,_ in pairs(valid_curves) do check_valid_curves = check_valid_curves +1 end
      while check_loop do 
      	 valid_curves, matrix_inters =  _remove_pending_path_I(valid_curves,matrix_inters)
      	 check_valid_curves_1 = 0;for _,_ in pairs(valid_curves) do check_valid_curves_1 = check_valid_curves_1 +1 end
      	 if (check_valid_curves ~= check_valid_curves_1) then 
      	    check_valid_curves = check_valid_curves_1
      	 else check_loop = false 
      	 end
      end 



      --
      -- remove duplicate paths  II, but really it removes loops
      -- also _remove_path(valid_curves,matrix_inters,{'11','12'})
      valid_curves, matrix_inters =  _remove_duplicate_path_II(valid_curves,matrix_inters)


      --
      -- max loops = max {#matrix_inters[j] for j a  valid curve}
      --
      check_loop = true 
      check_valid_curves = 0 ; for _,_ in pairs(valid_curves) do check_valid_curves = check_valid_curves +1 end
      while check_loop do 
      	 valid_curves,matrix_inters = _open_loop(valid_curves,matrix_inters)
      	 check_valid_curves_1 = 0;for _,_ in pairs(valid_curves) do check_valid_curves_1 = check_valid_curves_1 +1 end
      	 if (check_valid_curves ~= check_valid_curves_1) then 
      	    check_valid_curves = check_valid_curves_1
      	 else check_loop = false 
      	 end
      end 


      --
      -- check for curves almost null with overlap
      --
      valid_curves,matrix_inters = remove_small_curve_with_overlap(valid_curves,matrix_inters)


      -- THE NEXT TWO STEPS  SHOULD BE AVOIDED !!! 
      -- --
      -- -- pending paths II 
      -- --
      check_loop = true 
      check_valid_curves = 0 ; for _,_ in pairs(valid_curves) do check_valid_curves = check_valid_curves +1 end
      while check_loop do 
      	 valid_curves, matrix_inters =  _remove_pending_path_II(valid_curves,matrix_inters)
      	 check_valid_curves_1 = 0;for _,_ in pairs(valid_curves) do check_valid_curves_1 = check_valid_curves_1 +1 end
      	 if (check_valid_curves ~= check_valid_curves_1) then 
      	    check_valid_curves = check_valid_curves_1
      	 else check_loop = false 
      	 end
      end 
      _print_curve_intersections('2',valid_curves,matrix_inters)      
      --
      -- remove duplicate paths 
      --
      valid_curves, matrix_inters =  _remove_duplicate_path_I(valid_curves,matrix_inters)
      _print_curve_intersections('3',valid_curves,matrix_inters)      


      --
      -- third attempt to remove duplicate  (triangular  <| paths)
      --
      valid_curves, matrix_inters =  _remove_duplicate_path_III(valid_curves,matrix_inters,valid_curves_p_set)


      --
      -- attempt to remove duplicate  (triangular  <| paths) only for pen
      --  see r for ccr5
      check_loop = true 
      check_valid_curves = 0 ; for _,_ in pairs(valid_curves) do check_valid_curves = check_valid_curves +1 end
      while check_loop do 
      	 valid_curves,matrix_inters = _open_pen_loop_I(valid_curves,matrix_inters,valid_curves_p_set)
      	 check_valid_curves_1 = 0;for _,_ in pairs(valid_curves) do check_valid_curves_1 = check_valid_curves_1 +1 end
      	 if (check_valid_curves ~= check_valid_curves_1) then 
      	    check_valid_curves = check_valid_curves_1
      	 else check_loop = false 
      	 end
      end 



      --
      -- loops maded by pen path
      --
      valid_curves,matrix_inters = _open_pen_loop_II(valid_curves,matrix_inters)


      -- -- next we need
      -- -- pending paths II 
      -- --
      check_loop = true 
      check_valid_curves = 0 ; for _,_ in pairs(valid_curves) do check_valid_curves = check_valid_curves +1 end
      while check_loop do 
      	 valid_curves, matrix_inters =  _remove_pending_path_II(valid_curves,matrix_inters)
      	 check_valid_curves_1 = 0;for _,_ in pairs(valid_curves) do check_valid_curves_1 = check_valid_curves_1 +1 end
      	 if (check_valid_curves ~= check_valid_curves_1) then 
      	    check_valid_curves = check_valid_curves_1
      	 else check_loop = false 
      	 end
      end 
      -- and again
      -- remove duplicate paths 
      --
      valid_curves, matrix_inters =  _remove_duplicate_path_I(valid_curves,matrix_inters)


      --
      -- we should check that we have not created wrong pending path 
      --
      valid_curves, matrix_inters =  _fix_wrong_pending_path(valid_curves,matrix_inters)


      --
      -- remove pen paths that make <| 
      -- and are pending
      valid_curves, matrix_inters =  _remove_pending_pen_path(valid_curves,matrix_inters,valid_curves_p_set)

      --_remove_path(valid_curves,matrix_inters,{'49'})


      --
      -- fourth attempt to remove useless paths
      --
     valid_curves, matrix_inters =  _remove_useless_path(valid_curves,matrix_inters)
      -- -- valid_curves,matrix_inters = _remove_path(valid_curves,matrix_inters,{'388','350','386'})

      --
      -- remove curve  overlaps 
      --
      --valid_curves,matrix_inters = _remove_path(valid_curves,matrix_inters,{'129'})
      valid_curves,matrix_inters = _remove_overlaps(valid_curves,matrix_inters)


      --
      -- remove & merge small ~ straight curves 
      -- TODO: preserve horiz, vert, pi/4 + k*pi/2 lines
      -- 
      --valid_curves,matrix_inters = _remove_small_path(valid_curves,matrix_inters)

      

      --
      -- a fix for an error found on ccr5 y 
      --
      valid_curves,matrix_inters = _fix_intersection_bug(valid_curves,matrix_inters)

      --
      -- we need the correct time for each curve
      --
      -- wrong !!!! todo 
      -- _print_curve_intersections('2',valid_curves,matrix_inters)
      --valid_curves,matrix_inters =  _adjust_times(valid_curves,matrix_inters)
       --- valid_curves,matrix_inters,check_loop =  _adjust_times_I(valid_curves,matrix_inters)
      -- 
      


      --
      -- sanitize points 
      --  enable when _adjust_times will be ok
      -- valid_curves,matrix_inters =  _adjust_points(valid_curves,matrix_inters)

--[====[XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX]====]--
      --
      -- DRAW THEM 
      --
      print("BEZ DRAW")
      local drawed_point =  {}
      local lp,lq
      for i,bezier in pairs(valid_curves) do
	 local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
	 print("BEZ i="..i)
	 print(string.format("BEZ draw p=%s,c1=%s,c2=%s,q=%s, shifted=%s",p,c1,c2,q,tostring(shifted)))
	 f:write(string.format("%%i=%s\n",i))
	 f:write(string.format("path p[]; p1:=%s .. controls %s and %s .. %s;\n",
			       _eval(p,shifted),_eval(c1,shifted),_eval(c2,shifted),_eval(q,shifted)))
	 f:write("drawoptions(withcolor (0,0,0)  withpen pencircle scaled 0.5pt);\n")
	 lp = string.format("(%s+(1.5,1.5))",_eval(p,shifted))
	 if drawed_point[lp] == nil then 
	    -- f:write(string.format("draw %s -- (%s+(1.05,1.5)) withcolor blue;\n",_eval(p,shifted),_eval(p,shifted)))
	    -- f:write(string.format("draw %s -- (%s+(-1.05,-1.5)) withcolor green ;\n",_eval(q,shifted),_eval(q,shifted)))
	    -- f:write(string.format("label( \"%s\", (%s+(1.05,1.5)) );\n",i,_eval(p,shifted)))
	    -- f:write(string.format("label( \"%s\", (%s+(-1.05,-1.5)) );\n",i,_eval(q,shifted)))
	    drawed_point[lp] = 1
	 -- elseif drawed_point[lp] == 1 then 
	 --    drawed_point[lp] = drawed_point[lp] + 1
	 --    lp = string.format("(%s+(1.5,1.5)+(1.5,1.5))",_eval(p,shifted))
	 --    lq = string.format("(%s+(-1.5,-1.5)+(-1.5,-1.5))",_eval(q,shifted))
	 --    f:write(string.format("draw %s -- %s withcolor blue;\n",_eval(p,shifted),lp))
	 --    f:write(string.format("draw %s -- %s withcolor green;\n",_eval(q,shifted),lq))
	 --    f:write(string.format("label( \"%s\", %s );\n",i,lp))
	 --    f:write(string.format("label( \"%s\", %s );\n",i,lq))
	 -- elseif drawed_point[lp] == 2 then 
	 --    drawed_point[lp] = drawed_point[lp] + 1
	 --    lp = string.format("(%s+(1.5,1.5)+(1.5,1.5)+(1.5,1.5)+(1.5,1.5))",_eval(p,shifted))
	 --    lq = string.format("(%s+(-1.5,-1.5)+(-1.5,-1.5)+(-1.5,-1.5)+(-1.5,-1.5))",_eval(q,shifted))
	 --    f:write(string.format("draw %s -- %s withcolor blue;\n",_eval(p,shifted),lp))
	 --    f:write(string.format("draw %s -- %s withcolor green;\n",_eval(q,shifted),lq))
	 --    f:write(string.format("label( \"%s\", %s );\n",i,lp))
	 --    f:write(string.format("label( \"%s\", %s );\n",i,lq))
	 -- elseif drawed_point[lp] == 2 then 
	 --    drawed_point[lp] = drawed_point[lp] + 1
	 --    lp = string.format("(%s+(1.5,1.5)+(1.5,1.5)+(1.5,1.5)+(1.5,1.5)+(1.5,1.5)+(1.5,1.5))",_eval(p,shifted))
	 --    lq = string.format("(%s+(-1.5,-1.5)+(-1.5,-1.5)+(-1.5,-1.5)+(-1.5,-1.5)+(-1.5,-1.5)+(-1.5,-1.5))",_eval(q,shifted))
	 --    f:write(string.format("draw %s -- %s withcolor blue;\n",_eval(p,shifted),lp))
	 --    f:write(string.format("draw %s -- %s withcolor green;\n",_eval(q,shifted),lq))
	 --    f:write(string.format("label( \"%s\", %s );\n",i,lp))
	 --    f:write(string.format("label( \"%s\", %s );\n",i,lq))
	 else
	    drawed_point[lp] = drawed_point[lp] + 1
	    local s = drawed_point[lp]
	    lp = string.format("(%s+(1.05,1.5)+%s*(0.05,0.5))",_eval(p,shifted),s)
	    lq = string.format("(%s+(-1.05,-1.5)+%s*(-0.05,-0.5))",_eval(q,shifted),s)
	    --f:write(string.format("draw %s -- %s withcolor blue;\n",_eval(p,shifted),lp))
	    --f:write(string.format("draw %s -- %s withcolor green;\n",_eval(q,shifted),lq))
	    --f:write(string.format("label( \"%s\", %s );\n",i,lp))
	    --f:write(string.format("label( \"%s\", %s );\n",i,lq))
	 end
	 f:write("drawoptions(withcolor (0,0,0)  withpen pencircle scaled 0.4pt);\n")
	 f:write(string.format("draw p1;\n"))
      end
      
      f:write("\n\\stopMPpage\n")
   end
   f:write("\n\\stoptext\n")
   f:close()
   return 0
end

end_program()