print("\n······· mflua_end_program says: 'Hello world!' ·······")


local function _eval(q,offset)
   local qx,qy,xo,yo
   local w 
   w=string.gmatch(q,"[-0-9.]+"); qx,qy=w(),w()
   w=string.gmatch(offset,"[-0-9.]+"); xo,yo=w(),w()
   return string.format("(%s,%s)",qx+xo,qy+yo)
end

local function _eval3f(q,offset)
   local qx,qy,xo,yo
   local w 
   w=string.gmatch(q,"[-0-9.]+"); qx,qy=w(),w()
   w=string.gmatch(offset,"[-0-9.]+"); xo,yo=w(),w()
   return string.format("(%.3f,%.3f)",qx+xo,qy+yo)
end


local function _eval_tonumber(q,offset)
   local qx,qy,xo,yo
   local w 
   w=string.gmatch(q,"[-0-9.]+"); qx,qy=w(),w()
   w=string.gmatch(offset,"[-0-9.]+"); xo,yo=w(),w()
   return {qx+xo,qy+yo}
end

local function _eval_tonumber3f(q,offset)
   local qx,qy,xo,yo
   local w 
   w=string.gmatch(q,"[-0-9.]+"); qx,qy=w(),w()
   w=string.gmatch(offset,"[-0-9.]+"); xo,yo=w(),w()
   return {string.format("%.3f",qx+xo),string.format("%.3f",qy+yo)}
end




local function _eval_diff_tonumber(p,q)
   local px,py,qx,qy
   local w 
   w=string.gmatch(p,"[-0-9.]+"); px,py=w(),w()
   w=string.gmatch(q,"[-0-9.]+"); qx,qy=w(),w()
   return math.sqrt(math.pow(qx-px,2)+math.pow(qy-py,2))
end

local function _curve_is_vertical(p,c1,c2,q,eps)
   local px,py,c1x,c2x,qx,qy
   if eps == nil then eps = 0.01 end
   local w 
   w=string.gmatch(p ,"[-0-9.]+"); px ,py =w(),w()
   w=string.gmatch(c1,"[-0-9.]+"); c1x,c1y=w(),w()
   w=string.gmatch(c2,"[-0-9.]+"); c2x,c2y=w(),w()
   w=string.gmatch(q ,"[-0-9.]+"); qx ,qy =w(),w()
   return ((math.abs(px-c1x)<eps) and (math.abs(px-c2x)<eps) and (math.abs(px-qx)<eps)) or false
end

local function _curve_is_horizontal(p,c1,c2,q,eps)
   local px,py,c1x,c2x,qx,qy
   if eps == nil then eps = 0.01 end
   local w 
   w=string.gmatch(p ,"[-0-9.]+"); px ,py =w(),w()
   w=string.gmatch(c1,"[-0-9.]+"); c1x,c1y=w(),w()
   w=string.gmatch(c2,"[-0-9.]+"); c2x,c2y=w(),w()
   w=string.gmatch(q ,"[-0-9.]+"); qx ,qy =w(),w()
   return ((math.abs(py-c1y)<eps) and (math.abs(py-c2y)<eps) and (math.abs(py-qy)<eps)) or false
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


local function _coord_str_to_num(p)
   local w
   w=string.gmatch(p,"[-0-9.]+"); p={tonumber(w()),tonumber(w())}
   return p
end

local function _coord_str_to_table_num(p,c1,c2,q,shifted)
   local w
   if shifted==nil then shifted = '(0,0)' end
   w=string.gmatch(p,"[-0-9.]+"); p={tonumber(w()),tonumber(w())}
   w=string.gmatch(c1,"[-0-9.]+"); c1={tonumber(w()),tonumber(w())}
   w=string.gmatch(c2,"[-0-9.]+"); c2={tonumber(w()),tonumber(w())}
   w=string.gmatch(q,"[-0-9.]+"); q={tonumber(w()),tonumber(w())}
   w=string.gmatch(shifted,"[-0-9.]+"); shifted={tonumber(w()),tonumber(w())}
   return p,c1,c2,q,shifted
end




local function _round_points(p_i,p_j)
   --
   -- equal two point 
   --
   --print("BEZ _round_points")
   --print("BEZ p_i=",p_i[1],p_i[2])
   --print("BEZ p_j=",p_j[1],p_j[2])
   if math.floor(p_i[1]) == p_i[1] then 
      p_j[1] = p_i[1] 
   elseif math.floor(p_j[1]) == p_j[1] then 
      p_i[1] = p_j[1] 
   else 
      local temp = 0.5*(p_i[1]+p_j[1])
      p_i[1],p_j[1] = temp,temp
   end
   if math.floor(p_i[2]) == p_i[2] then 
      p_j[2] = p_i[2] 
   elseif math.floor(p_j[2]) == p_j[2] then 
      p_i[2] = p_j[2] 
   else 
      local temp = 0.5*(p_i[2]+p_j[2])
      p_i[2],p_j[2] = temp,temp
   end
   return p_i,p_j
end


local function _round_points_x(p_i,p_j)
   --
   -- equal two x coords 
   --
   return {(p_i[1]+p_j[1])*0.5,p_i[2]}, {(p_i[1]+p_j[1])*0.5,p_j[2]} --p_i,p_j
   --return p_i,p_j
end


local function _round_points_y(p_i,p_j)
   --
   -- equal two y coords
   --
   return {p_i[1],(p_i[2]+p_j[2])*0.5}, {p_j[1],(p_i[2]+p_j[2])*0.5} 
   --return p_i,p_j
end

local function _coord_table_to_str(p,c1,c2,q,shifted)
   p = string.format("(%s,%s)",p[1],p[2]) 
   c1 = string.format("(%s,%s)",c1[1],c1[2])
   c2 = string.format("(%s,%s)",c2[1],c2[2])
   q = string.format("(%s,%s)",q[1],q[2])
   shifted = string.format("(%s,%s)",shifted[1],shifted[2])
   return p,c1,c2,q,shifted
end

local function _dump_edges(char)
   local edges = char['edges']
   local y      = edges[1][1]
   local x_off  = edges[1][2]
   local y_off  = edges[1][3]
   local xq,xr,res,edge
   local bitmap ={}
   --print("BEZ x_off="..x_off)
   --print("BEZ y_off="..y_off)
   --
   --
   local x_min,x_max,y_min,y_max=1e9,-1e9,1e9,-1e9
   for i,v in ipairs(y) do 
      xq,xr = v[2],v[3]
      for j=1, #xr-1, 1 do 
	 local xb,xe = xr[j][1],xr[j+1][1]
	 local x_begin = tonumber(xb)+tonumber(x_off)
	 local x_end = tonumber(xe)+tonumber(x_off)
	 local y_row = tonumber(v[1])+ tonumber(y_off)
	 if y_row < y_min then y_min = y_row end
	 if y_row > y_max then y_max = y_row end
	 if x_begin < x_min then x_min = x_begin end
	 if x_begin > x_max then x_max = x_begin end
	 if x_end < x_min then x_min = x_end end
	 if x_end > x_max then x_max = x_end end
      end
   end
   print("BEZ x_min,x_max,y_min,y_max=",x_min,x_max,y_min,y_max)

   for i,v in ipairs(y) do 
      local row = {}
      local y_row = tonumber(v[1])+ tonumber(y_off)
      xq,xr = v[2],v[3]
      -- empty row
      for i=x_min,x_max do row[i] = 0 end ;
      --print("BEZ y_row="..y_row)
      bitmap[y_row]=row
      for j=1, #xr-1, 1 do 
	 local xb,xe = xr[j][1],xr[j+1][1]
	 local xsb,xse = xr[j][3],xr[j+1][3]
	 --print("BEZ v[1]="..v[1],"xsb="..xsb,"xse="..xse)
	 res = ""
	 local x_begin = tonumber(xb)+tonumber(x_off)
	 local x_end = tonumber(xe)+tonumber(x_off)
	 if xsb == 0 then
	    -- blank  row[x_begin] → row[x_end]  ?
	 end
	 if xsb>0 then
	    local color = {'0.7white','0.5white','0.4white'}
	    local col = color[xsb] or 'black'
	    --edge = string.format("%s: (%s,%s)",y_row,x_begin,x_end)
	    for i=x_begin,x_end do row[i] = 1 end
	    --res = res .. edge 
	 end
	 -- print(v[1],xr[j][1],xr[j][2],xr[j][3])
	 --print(res)
      end
      --bitmap[y_row]=row
   end
   for j=y_max,y_min,-1 do
      --print("BEZ j="..j)
      local row = bitmap[j] 
      if row == nil then 
	 -- empty row
	 row = {}
	 for i=x_min,x_max do row[i] = 0 end ;
	 bitmap[j] = row
      end
   end
   return x_min,y_min,x_max,y_max,bitmap
end


local function _dump(valid_curves,matrix_inters,cycles,filename)
   --
   -- serialize valid curves
   --
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v end
   local c = 'local cycles={}'.."\n"
   local s = 'local s={}'.."\n"
   s = s.."s={"
   for i,bezier in pairs(temp_valid_curves) do
      s= s.."['"..tostring(i).."']={"
      p,c1,c2,q,shifted= bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
      s= s.."'"..p.."',"
      s= s.."'"..c1.."',"
      s= s.."'"..c2.."',"
      s= s.."'"..q.."',"
      s= s.."'"..shifted.."'},\n"
   end
   s = s.."}\n"
   if  cycles ~= nil then 
      c = c .. "cycles={"
      for k,v in pairs(cycles) do
	 c = c.."['"..tostring(k).."']={"
	 for j,i in ipairs(v) do
	    local bezier = temp_valid_curves[i]
	    c= c.."["..tostring(j).."]={"
	    p,c1,c2,q,shifted= bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
	    c= c.."'"..i.."',"
	    c= c.."'"..p.."',"
	    c= c.."'"..c1.."',"
	    c= c.."'"..c2.."',"
	    c= c.."'"..q.."',"
	    c= c.."'"..shifted.."'},\n"
	 end
	 c = c.."},\n"
      end
   end
   c = c.."}\n"
   local ret = s..c.."return s,cycles\n"
   f=io.open(filename,'w')
   f:write(ret)
   f:close()
end



local function _print_curve_intersections(label,curves,matrix_inters,i)
   local label = label or ''
   --print("BEZ _print_curve_intersections")
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


local function _print_curve_info(label,curves,matrix_inters,i)
   local label = label or ''
   print("BEZ _print_curve_info")
   --print("BEZ #curves="..#curves)
   local drw1= "  c1       c2\n"
   local drw2= "  /°       °\\\n"
   local drw3= " /           \\\n"
   local drw4= "/∡𝛼         ∡𝛽\\\n"
   local drw5= "°p-------------°q"
   local draw = drw1 .. drw2 .. drw3 .. drw4 .. drw5
   if i ==  nil or #i == 0 then 
      for i, bezier in pairs(curves) do
	 local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
	 local p_i,c1_i,c2_i,q_i,shifted_i =  _coord_str_to_table_num(p,c1,c2,q,shifted)
	 print("BEZ ------")
	 print("BEZ i="..i,
	       "p c1 c2 q="..p..c1..c2..q,
	       "∡𝛼="..math.deg(math.atan2(-p_i[2]+c1_i[2],-p_i[1]+c1_i[1])),
	       "∡𝛽="..math.deg(math.atan2(-c2_i[2]+q_i[2],-c2_i[1]+q_i[1])),
	       "|qp|="..mflua.modul_vec(p_i,q_i),"|pc1|="..mflua.modul_vec(p_i,c1_i), "|qc2|="..mflua.modul_vec(c2_i,q_i),
	       "max length = ".. mflua.approx_curve_lenght(p_i,c1_i,c2_i,q_i))
	 local intersection  = matrix_inters[tostring(i)] or {}
	 for _,v in ipairs( intersection) do print(string.format("BEZ " ..label .." all intersections of i=%s: j=%s ,t=%s, u=%s",i,v[1],v[2],v[3])) end 
      end
   else
      for k,v  in pairs(i) do 
	 local bezier=curves[v]
	 local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
	 local p_i,c1_i,c2_i,q_i,shifted_i =  _coord_str_to_table_num(p,c1,c2,q,shifted)
	 print("BEZ i="..v,
	       "p c1 c2 q="..p..c1..c2..q,
	       "∡𝛼="..math.deg(math.atan2(-p_i[2]+c1_i[2],-p_i[1]+c1_i[1])),
	       "∡𝛽="..math.deg(math.atan2(-c2_i[2]+q_i[2],-c2_i[1]+q_i[1])),
	       "|qp|="..mflua.modul_vec(p_i,q_i),"|pc1|="..mflua.modul_vec(p_i,c1_i), "|qc2|="..mflua.modul_vec(c2_i,q_i),
	       "max length = ".. mflua.approx_curve_lenght(p_i,c1_i,c2_i,q_i))
	 local intersection  = matrix_inters[tostring(i)] or {}
	 for _,v in ipairs( intersection) do print(string.format("BEZ " ..label .." all intersections of i=%s: j=%s ,t=%s, u=%s",i,v[1],v[2],v[3])) end 
      end
   end
end

local function _is_included(s,S)
   print("BEZ is included")
   local res = true 
   --table.foreach(s,function(...) print("BEZ s=",...) end)
   --table.foreach(S,function(...) print("BEZ S=",...) end)
   for k,_ in pairs(s) do
      --print("BEZ k="..k, "S[k]=",S[k])
      if S[k] ~= true   then res = false ; break;end
   end
   --print("BEZ res=",tostring(res))
   return res
end

local function _remove_path(valid_curves,matrix_inters,paths)
   --
   -- utility : remove paths . Paths is a table
   --
   print("BEZ _remove_path")
   if #paths == 0 then 
      --print("#paths == 0")
      return valid_curves,matrix_inters
   end

   local temp_removed = {}
   local temp_valid_curves = {}
   for i, bezier in pairs(valid_curves) do temp_valid_curves[i] = bezier end
   --for i, k in ipairs(paths) do print("BEZ k="..k) temp_valid_curves[tonumber(k)] = nil; temp_removed[tostring(k)] = true end
   for i, k in ipairs(paths) do temp_valid_curves[tonumber(k)] = nil; temp_removed[tostring(k)] = true end
   -- remove references to deleted paths
   for i, bezier in pairs(temp_valid_curves) do
      local intersection  = matrix_inters[tostring(i)] or {}
      local temp_intersection = {}
      for _,v in ipairs( intersection) do 
	 local j  = tostring(v[1])
	 if not(temp_removed[j]==true) then 
	    temp_intersection[#temp_intersection +1] = v
	 else
	    --print("BEZ removed  path i="..i .. ' path j='..v[1])
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




local function bez(p,c1,c2,q,t)
   local b00,b01,b02,b03 =  {},{},{},{}
   local b10,b11,b12=  {},{},{}
   local b20,b21=  {},{}
   local b30=  {}
   local T=1-t
   --
   -- de Casteljau Algorithm
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

local function _get_subcurve(p,c1,c2,q,t1,t2)
   --
   -- if C(t) = bezier_cubic(p,c1,c2,q) ,t ∈ [0,1]
   -- then return the subcurve between t1 and t2 iff t1 ⩽ t2,
   -- otherwise ⵁ
   if t1 > t2 then return {} end
   local p_left,c1_left,c2_left,q_left
   local p_right,c1_right,c2_right,q_right
   _1,_2,_3,_4,_5,_6,_7,_8,_9 =  bez(p,c1,c2,q,t1)
   --print("BEZ  subcurve right:",_coord_table_to_str(_6,_7,_8,_9,{0,0}))
   p_right,c1_right = _6,_7
   _1,_2,_3,_4,_5,_6,_7,_8,_9 =  bez(p,c1,c2,q,t2)
   --print("BEZ  subcurve left:",_coord_table_to_str(_3,_4,_5,_6,{0,0}))
   c2_left,q_left = _5,_6
   --print("BEZ  subcurve:",_coord_table_to_str(p_right,c1_right,c2_left,q_left,{0,0}))
   return _coord_table_to_str(p_right,c1_right,c2_left,q_left,{0,0})
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



local function _is_a_straight_segment(p,c1,c2,q) 
   --
   -- check if it's a strainght line
   --
   local eps = mflua.threshold_straight_line or 0.125
   -- horizontal line 
   if math.abs(p[2]-c1[2])<eps and math.abs(q[2]-c2[2])<eps and math.abs(p[2]-q[2])<eps then 
      return 0 
   -- vertical line
   elseif math.abs(p[1]-c1[1])<eps and math.abs(q[1]-c2[1])<eps and math.abs(p[1]-q[1])<eps then 
      return 1 
   -- y=mx +q line   
   else
      local m  = (q[2]-p[2])/(q[1]-p[1]) 
      local q  = p[2] - m*p[1] 
      --local m1  = (c1[2]-p[2])/(c1[1]-p[1]) 
      --local m2  = (q[2]-c2[2])/(q[1]-c2[1]) 
      --local m12 = (c2[2]-c1[2])/(c2[1]-c1[1]) 
      if math.abs(c1[2]-m*c1[1]-q)<eps and  math.abs(c2[2]-m*c2[1]-q)<eps then 
	 return 2
      else
	 return -1
      end
   end
   return -1
end


local function _remove_isolate_path(valid_curves,matrix_inters)
   --
   -- remove isolate path
   --
   print("BEZ _remove_isolate_path")
   local temp_removed = {}
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v temp_removed[k]=false end
   local modified  = false 
   for i, bezier in pairs(temp_valid_curves) do 
      if temp_removed[i]==false then 
	 local intersection  = matrix_inters[tostring(i)] or {}
	 local nr_inters = 0
	 for _,inters in ipairs(intersection) do  nr_inters = nr_inters +1 end
	 if nr_inters <= 1 then temp_removed[i] =true  ; modified  = true  end 
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
   -- Recursive remove
   if modified == true then valid_curves,matrix_inters = _remove_isolate_path(valid_curves,matrix_inters) end 
   return valid_curves,matrix_inters
end 



local function _remove_path_and_clean_up(valid_curves,matrix_inters,paths_removed) 
   valid_curves,matrix_inters = _remove_path(valid_curves,matrix_inters,paths_removed)
   valid_curves,matrix_inters =  _remove_isolate_path(valid_curves,matrix_inters)
   return valid_curves,matrix_inters
end



local function _remove_redundant_segments(valid_curves,valid_curves_p,valid_curves_p_set,pen_over_knots,matrix_inters)
   --
   -- remove Ri: ax+by+c=0 curves that are redundant, ie Rj is inside Rk
   --
   print("BEZ _remove_redundant_segments")
   local dropped = {}

   for i, bezier in pairs(valid_curves) do
      local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
      local p_i,c1_i,c2_i,q_i,shifted_i =  _coord_str_to_table_num(p,c1,c2,q,shifted)
      bezier[1] = "(" .. tonumber(string.format("%.3f",p_i[1])) .. "," .. tonumber(string.format("%.3f",p_i[2])) .. ")"
      bezier[2] = "(" .. tonumber(string.format("%.3f",c1_i[1])) .. "," .. tonumber(string.format("%.3f",c1_i[2])) .. ")"
      bezier[3] = "(" .. tonumber(string.format("%.3f",c2_i[1])) .. "," .. tonumber(string.format("%.3f",c2_i[2])) .. ")"
      bezier[4] = "(" .. tonumber(string.format("%.3f",q_i[1])) .. "," .. tonumber(string.format("%.3f",q_i[2])) .. ")"
      bezier[5] = "(" .. tonumber(string.format("%.3f",shifted_i[1])) .. "," .. tonumber(string.format("%.3f",shifted_i[2])) .. ")"
   end

   
   --
   --
   -- small segments
   --
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v;  dropped[k]=false;end
   local temp_straight_curves = {};  
   local eps = mflua.threshold_straight_line or 0.125
   for i, bezier in pairs(temp_valid_curves) do
      local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
      local p_i,c1_i,c2_i,q_i,shifted_i =  _coord_str_to_table_num(p,c1,c2,q,shifted)
      if mflua.modul_vec(p_i,q_i) < eps then 
	 --print("BEZ i="..i, "is small ",mflua.modul_vec(p_i,q_i))
	 --
	 -- WRONG !!! if we delete a small segment than we can open a hole !!
	 -- see Ξ curves 30,31,32
	 dropped[i] = true
      end
   end
   for i, bezier in pairs(temp_valid_curves) do
      local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
      local p_i,c1_i,c2_i,q_i,shifted_i =  _coord_str_to_table_num(p,c1,c2,q,shifted)
      local segment_type = _is_a_straight_segment(p_i,c1_i,c2_i,q_i)
      --print("BEZ i=:"..i,p,c1,c2,q," segment type:"..segment_type) 
      if segment_type >=0 and dropped[i]==false then 
	 --print("BEZ i=:"..i,p,c1,c2,q," is a segment "..segment_type) 
	 temp_straight_curves[i] = {segment_type,p_i,c1_i,c2_i,q_i,shifted_i,mflua.modul_vec(p_i,q_i)}
      end
   end
   --
   -- We check only the segments
   --
   -- almost identical segments
   for i, bezier in pairs(temp_straight_curves) do
      local segment_type_i, p_i,c1_i,c2_i,q_i,shifted_i,l_i  = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5],bezier[6],bezier[7]
      for j, bez_j in pairs(temp_straight_curves) do
	 local segment_type_j, p_j,c1_j,c2_j,q_j,shifted_j,l_j  = bez_j[1],bez_j[2],bez_j[3],bez_j[4],bez_j[5],bez_j[6],bez_j[7]
	 if not(j==i) and not(dropped[j]) and not(dropped[i])then 
	    if math.abs(p_i[1]-p_j[1])<=eps and math.abs(c1_i[1]-c1_j[1])<=eps and math.abs(c2_i[1]-c2_j[1])<=eps and math.abs(q_i[1]-q_j[1])<=eps 
           and math.abs(p_i[2]-p_j[2])<=eps and math.abs(c1_i[2]-c1_j[2])<=eps and math.abs(c2_i[2]-c2_j[2])<=eps and math.abs(q_i[2]-q_j[2])<=eps then
	       --print("BEZ i="..i," a) dropped j="..j)
	       dropped[j] = true
	    elseif math.abs(p_i[1]-q_j[1])<=eps and math.abs(c1_i[1]-c2_j[1])<=eps and math.abs(c2_i[1]-c1_j[1])<=eps and math.abs(q_i[1]-p_j[1])<=eps 
	    and    math.abs(p_i[2]-q_j[2])<=eps and math.abs(c1_i[2]-c2_j[2])<=eps and math.abs(c2_i[2]-c1_j[2])<=eps and math.abs(q_i[2]-p_j[2])<=eps then
	       --print("BEZ i="..i," b) dropped j="..j)
	       dropped[j] = true
	    elseif segment_type_j>=0 and (segment_type_j == segment_type_i) and not(valid_curves_p_set[j] == true) 
	            and p_i[1]==p_j[1] and q_i[1]==q_j[1] and  p_i[2]==p_j[2] and q_i[2]==q_j[2] then 
	       --print("BEZ i="..i," c) dropped j="..j)
	       dropped[j] = true
	    elseif segment_type_j>=0 and (segment_type_j == segment_type_i) and not(valid_curves_p_set[j] == true) 
	        and p_i[1]==q_j[1] and q_i[1]==p_j[1] and p_i[2]==q_j[2] and q_i[2]==p_j[2] then
	       --print("BEZ i="..i," d) dropped j="..j)
	       dropped[j] = true
	    end
	 end
      end
   end

   -- segment that is inside another segment
   --print("BEZ segment that is inside another segment")
   for i, bezier in pairs(temp_straight_curves) do
      local segment_type_i, p_i,c1_i,c2_i,q_i,shifted_i,l_i  = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5],bezier[6],bezier[7]
      for j, bez_j in pairs(temp_straight_curves) do
	 if not(j==i) and not(dropped[j]) and not(dropped[i])then 
	    local segment_type_j, p_j,c1_j,c2_j,q_j,shifted_j,l_j  = bez_j[1],bez_j[2],bez_j[3],bez_j[4],bez_j[5],bez_j[6],bez_j[7]
	    if segment_type_i==0 and segment_type_j==0 and math.abs(p_i[2]-p_j[2])<=eps  and l_i> l_j then 
	       -- h0rizontal segment
	       if p_i[1] < q_i[1] then 
		  if p_j[1] < q_j[1] and (p_i[1]<=p_j[1] and q_j[1]<=q_i[1]) then 
		     dropped[j] = true 
		     --print("BEZ i="..i,"a1) hor. j="..j.." dropped") 
		  end 
		  if q_j[1] < p_j[1] and (p_i[1]<=q_j[1] and p_j[1]<=q_i[1]) then 
		     dropped[j] = true 
		     --print("BEZ i="..i,"a2) hor. j="..j.." dropped") 
		  end 
		  --print("BEZ i="..i,"a) hor. j="..j.." dropped")
	       end
	       if q_i[1] < p_i[1] then 
		  if p_j[1] < q_j[1] and (q_i[1]<=p_j[1] and q_j[1]<=p_i[1]) then 
		     dropped[j] = true 
		     --print("BEZ i="..i,"b1) hor. j="..j.." dropped") 
		  end
		  if q_j[1] < p_j[1] and (q_i[1]<=q_j[1] and p_j[1]<=p_i[1]) then 
		     dropped[j] = true 
		     --print("BEZ i="..i,"b2) hor. j="..j.." dropped") 
		  end 
		  --print("BEZ i="..i,"b) hor. j="..j.." dropped")
	       end
	    end
	    if segment_type_i==1 and segment_type_j==1 and math.abs(p_i[1]-p_j[1])<=eps and l_i> l_j then 
	       -- vert1ca1 segment
	       if p_i[2] < q_i[2] then 
		  if p_j[2] < q_j[2] and (p_i[2]<=p_j[2] and q_j[2]<=q_i[2]) then 
		     dropped[j] = true 
		     --print("BEZ i="..i,"c1) hor. j="..j.." dropped") 
		  end
		  if q_j[2] < p_j[2] and (p_i[2]<=q_j[2] and p_j[2]<=q_i[2]) then 
		     dropped[j] = true 
		     --print("BEZ i="..i,"c2) hor. j="..j.." dropped") 
		  end
	       end
	       if q_i[2] < p_i[2] then 
		  if p_j[2] < q_j[2] and (q_i[2]<=p_j[2] and q_j[2]<=p_i[2]) then 
		     dropped[j] = true 
		     --print("BEZ i="..i,"d1) hor. j="..j.." dropped") 
		  end
		  if q_j[2] < p_j[2] and (q_i[2]<=q_j[2] and p_j[2]<=p_i[2]) then 
		     dropped[j] = true 
		     --print("BEZ i="..i,"d2) hor. j="..j.." dropped") 
		  end 
	       end

	    end
	    if segment_type_i==2 and segment_type_j==2 and l_i> l_j then 
               -- generic segment
	       local A,B,C,D,m1,m2, y00,y01
	       local pi4=math.atan(1)
	       if p_i[1] <= q_i[1] then   A,B = p_i,q_i   else 	  B,A = p_i,q_i   end
	       if p_j[1] <= q_j[1] then   C,D = p_j,q_j   else   D,C = p_j,q_j   end
	       m1 = 45/pi4*math.atan2(B[2]-A[2],B[1]-A[1])
	       m2 = 45/pi4*math.atan2(D[2]-C[2],D[1]-C[1])
	       y00 = A[2]-(A[2]-B[2])/(A[1]-B[1])*B[1]
	       y01 = C[2]-(C[2]-D[2])/(C[1]-D[1])*C[1]
	       -- print("BEZ ")
	       -- print("BEZ m0,y00=", (A[2]-B[2])/(A[1]-B[1]), y00)
	       -- print("BEZ m1,y01=", (C[2]-D[2])/(C[1]-D[1]), y01)
	       -- print("BEZ i="..i, "j="..j,A[1],C[1],D[1],B[1])
	       -- print("BEZ i="..i, "j="..j,m1,m2,math.abs(m1-m2)<eps)
	       -- print("BEZ i="..i, "j="..j,(A[1]<=C[1] and D[1]<B[1]), (A[1]<C[1] and D[1]<B[1]) , (A[1]<C[1] and D[1]<=B[1]))
	       if math.abs(m1-m2)<eps and ((m1>0 and m2>0) or (m1<0 and m2<0)) and math.abs(y00-y01) <1e-5 then
		  if m1> 0 and (A[2]<=C[2]) and (D[2]<=B[2]) then 
		     if (A[1]<=C[1] and D[1]<B[1]) or (A[1]<C[1] and D[1]<B[1]) or (A[1]<C[1] and D[1]<=B[1])  then 
			dropped[j] = true 
		     end 
		  end
		  if m1< 0 and (A[2]>=C[2]) and (D[2]>=B[2]) then 
		     if (A[1]<=C[1] and D[1]<B[1]) or (A[1]<C[1] and D[1]<B[1]) or (A[1]<C[1] and D[1]<=B[1])  then 
			dropped[j] = true 
		     end 
		  end
	       end
	       if dropped[j] == true then print("BEZ i="..i, "j="..j,"dropped") end
	    end
	 end
      end
   end

   --local valid_curves = {};for k,v in pairs(temp_valid_curves) do if not(dropped[k] == true ) then valid_curves[k] = v else print("BEZ k="..k, "dropped") end  end   if true then return valid_curves end

   -- segment that is in between 2 segments; only vertical and horizontal segments 
   local temp_joined_curves ={} 
   local N = 0 
   for i, bezier in pairs(temp_straight_curves) do if N<i then N = i end end 
   --print("BEZ N="..N)
   for i, bezier in pairs(temp_straight_curves) do
      local segment_type_i, p_i,c1_i,c2_i,q_i  = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
      for j, bez_j in pairs(temp_straight_curves) do
	 if not(j==i) and not(dropped[j]) and not(dropped[i]) then 
	    local segment_type_j, p_j,c1_j,c2_j,q_j  = bez_j[1],bez_j[2],bez_j[3],bez_j[4],bez_j[5]
	    if segment_type_i==0 and segment_type_j==0 and (math.abs(p_i[2]-p_j[2])<=eps)  
	     and ( (math.abs(p_i[1]-q_j[1])<=eps  and math.abs(q_i[1]-p_j[1])>2) or (math.abs(q_i[1]-p_j[1])<=eps  and math.abs(p_i[1]-q_j[1])>2) ) then 
	     if i<=j then 
		temp_joined_curves[1+(j-1)*j/2+(i-1)] ={i,j}
	     else
		temp_joined_curves[1+(i-1)*i/2+(j-1)] ={i,j}
	     end
	    end
	    if segment_type_i==1 and segment_type_j==1 and (math.abs(p_i[1]-p_j[1])<=eps)  
	     and ( (math.abs(p_i[2]-q_j[2])<=eps  and math.abs(q_i[2]-p_j[2])>2) or  (math.abs(q_i[2]-p_j[2])<=eps  and math.abs(p_i[2]-q_j[2])>2) ) then 
	     if i<=j then 
		temp_joined_curves[1+(j-1)*j/2+(i-1)] ={i,j}
	     else
		temp_joined_curves[1+(i-1)*i/2+(j-1)] ={i,j}
	     end
	    end
	 end
      end
   end
   --for k,p in pairs(temp_joined_curves) do  print("BEZ k="..k,"p="..p[1],p[2]) end
   -- segment that is in between 2 segments; only vertical and horizontal segments 
   -- continued
   for m, bezier in pairs(temp_straight_curves) do
      local segment_type_m, p_m,c1_m,c2_m,q_m  = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
      for k,p in pairs(temp_joined_curves) do
	 local bezier = temp_straight_curves[p[1]]
	 local bez_j =  temp_straight_curves[p[2]]
	 local segment_type_i, p_i,c1_i,c2_i,q_i  = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
	 local segment_type_j, p_j,c1_j,c2_j,q_j  = bez_j[1],bez_j[2],bez_j[3],bez_j[4],bez_j[5]
	 if not(dropped[m]) and (p[1]~=m and p[2]~=m) and segment_type_i == segment_type_m and (segment_type_i == 0) and math.abs(p_i[2]-p_m[2])< eps then 
	    local A=0
	    local B=0
	    --
	    --  A     p_m       p_j       q_m        B
	    --  o------x-------oo----------x---------o
	    -- p_i             q_i                   q_j
	    local sort_table = {p_i[1],q_i[1],p_j[1],q_j[1]}
            --table.foreach(sort_table,print)
	    table.sort(sort_table)
            --table.foreach(sort_table,print)
	    A = sort_table[1]
	    B = sort_table[4]
	    --print("BEZ m="..m,"i="..p[1],"j="..p[2])
	    --print("BEZ A="..A,"p_i[1]="..p_i[1],"q_i[1]="..q_i[1],"B="..B)
	    --print("BEZ A="..A,"p_j[1]="..p_j[1],"q_j[1]="..q_j[1],"B="..B)
	    --print("BEZ A="..A,"p_m[1]="..p_m[1],"q_m[1]="..q_m[1],"B="..B)
	    --if (p_m[1]-q_m[1]<=0 ) and A-p_m[1]<=0 and q_m[1]-B<=0 then print("BEZ a) dropped m="..m,p[1],p[2]) end  --dropped[m] = true end
	    --if (q_m[1]-p_m[1]<=0 ) and A-q_m[1]<=0 and p_m[1]-B<=0 then print("BEZ b) dropped m="..m,p[1],p[2]) end  --dropped[m] = true end
	    if (p_m[1]-q_m[1]<=0 ) and A-p_m[1]<=0 and q_m[1]-B<=0 then dropped[m] = true end
	    if (q_m[1]-p_m[1]<=0 ) and A-q_m[1]<=0 and p_m[1]-B<=0 then dropped[m] = true end
	 end
	 if not(dropped[m]) and (p[1]~=m and p[2]~=m) and segment_type_i == segment_type_m and (segment_type_i == 1) and math.abs(p_i[1]-p_m[1])< eps then 
	    local A=0
	    local B=0
	    --
	    --  vertical lines
	    local sort_table = {p_i[2],q_i[2],p_j[2],q_j[2]}
            --table.foreach(sort_table,print)
	    table.sort(sort_table)
            --table.foreach(sort_table,print)
	    A = sort_table[1]
	    B = sort_table[4]
	    --if (p_m[2]-q_m[2]<=0 ) and A-p_m[2]<=0 and q_m[2]-B<=0 then print("BEZ a) dropped m="..m,p[1],p[2]) end  --dropped[m] = true end
	    --if (q_m[2]-p_m[2]<=0 ) and A-q_m[2]<=0 and p_m[2]-B<=0 then print("BEZ b) dropped m="..m,p[1],p[2]) end  --dropped[m] = true end
	    if (p_m[2]-q_m[2]<=0 ) and A-p_m[2]<=0 and q_m[2]-B<=0 then dropped[m] = true end
	    if (q_m[2]-p_m[2]<=0 ) and A-q_m[2]<=0 and p_m[2]-B<=0 then dropped[m] = true end
	 end
      end
   end


   -- segment that has  starting and ending point in a pen's path
   --
   --
   for m, bez_m in pairs(temp_straight_curves) do
      --print("BEZ m="..m,"is pen=",valid_curves_p_set[m])
      if not(dropped[m]) and not(valid_curves_p_set[m]) then 
   	 local segment_type_m,p_m,c1_m,c2_m,q_m,shifted = bez_m[1],bez_m[2],bez_m[3],bez_m[4],bez_m[5],bez_m[6]
   	 --print("BEZ m="..m,"is pen=",valid_curves_p_set[tonumber(m)], "segment_type_m="..segment_type_m,string.format("(%s,%s) (%s,%s) shift=(%s,%s)",p_m[1],p_m[2],q_m[1],q_m[2],shifted[1],shifted[2]))
   	 --print("draw " .. string.format("(%s,%s) -- (%s,%s);\n",p_m[1],p_m[2],q_m[1],q_m[2]))
   	 --print("BEZ m="..m,"p_m", p_m,c1_m,c2_m,q_m)
   	 --p_m,c1_m,c2_m,q_m = _eval(p_m,shifted),_eval(c1_m,shifted),_eval(c2_m,shifted),_eval(q_m,shifted)
   	 --p_m,c1_m,c2_m,q_m = _coord_str_to_table_num(p_m,c1_m,c2_m,q_m,shifted)
   	 for _,v in ipairs(pen_over_knots) do
   	    local found_p,found_q = false,false
   	    p_pen,q_pen,pen_data = v[1],v[2],v[3]
	    --print("draw ",p_pen,"; draw ",q_pen,";\n")
   	    --print("BEZ p_pen,q_pen,pen_data=",p_pen,q_pen,pen_data)
   	    --print("BEZ p_pen,q_pen,pen_data=",type(p_pen),type(q_pen),type(pen_data))
   	    for _,v1 in ipairs(pen_data) do 
   	       p = _eval_tonumber(v1,p_pen)
	       --print(string.format("draw (%s,%s); ",p[1],p[2]))
   	       if (math.abs(p_m[1]-p[1])<eps and math.abs(p_m[2]-p[2])<eps) then
   	       	  found_p = true 
   	       end
   	       if (math.abs(q_m[1]-p[1])<eps and math.abs(q_m[2]-p[2])<eps) then
   	       	  found_q = true 
   	       end 
   	    end
	    --print("\n%---------------------\n")
   	    if found_p==true  and found_q==true and segment_type_m ~=0 and segment_type_m ~=1 then
   	       --print("BEZ a) segment drop="..m)
   	       dropped[m] = true 
   	    end 
	    if not(dropped[m] == true) then 
	       found_p,found_q = false,false
	       for _,v1 in ipairs(pen_data) do 
		  q = _eval_tonumber(v1,q_pen)
		  --print(string.format("draw (%s,%s); ",q[1],q[2]))
		  if (math.abs(p_m[1]-q[1])<eps and math.abs(p_m[2]-q[2])<eps) then
		     found_p = true 
		  end
		  if (math.abs(q_m[1]-q[1])<eps and math.abs(q_m[2]-q[2])<eps) then
		     found_q = true 
		  end 
	       end
	       --print("\n%---------------------\n")
	       if found_p==true  and found_q==true and segment_type_m ~=0 and segment_type_m ~=1 then
		  --print("BEZ b) segment drop="..m)
		  dropped[m] = true 
	       end 
	    end
   	 end --for _,v in ipairs(pen_over_knots) do
      end
   end
   --

   
   -- We want to delete only some segments of a pen, so all pen's path are valid again
   for k,v in pairs(dropped) do if dropped[k] == true and  valid_curves_p_set[k] == true then dropped[k] =false end end 

   --
   -- small curves, again !
   --

   for i, bezier in pairs(temp_valid_curves) do
      local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
      local p_i,c1_i,c2_i,q_i,shifted_i =  _coord_str_to_table_num(p,c1,c2,q,shifted)
      if mflua.modul_vec(p_i,q_i) < eps then 
	 --print("BEZ i="..i, "is small ",mflua.modul_vec(p_i,q_i))
	 dropped[i] = true
      end
   end

   -- 
   -- segment of a pen that for sure are inside a segment (horizontal or vertical only)
   --
   --print("BEZ segment of a pen that for sure is inside a segment (horizontal or vertical only)")
   local eps_pen = mflua.threshold_pen or 4
   for m, bez_m in pairs(temp_straight_curves) do
      if not(dropped[m]) and not(valid_curves_p_set[m]) then 
	 --print("BEZ segment m="..m)
   	 local segment_type_m,p_m,c1_m,c2_m,q_m,shifted = bez_m[1],bez_m[2],bez_m[3],bez_m[4],bez_m[5],bez_m[6]
	 -- segment_type ==0,1,2 
	 -- 0 : horiz.
	 -- 1 : vert.
	 -- 2 y=mx+q
   	 --print("BEZ pen m="..m, p_m[1],p_m[2],q_m[1],q_m[2],segment_type_m)
 	 for m1, bez_m1 in pairs(temp_straight_curves) do
	    local segment_type_m1,p_m1,c1_m1,c2_m1,q_m1,shifted1 = bez_m1[1],bez_m1[2],bez_m1[3],bez_m1[4],bez_m1[5],bez_m1[6]
	    if not(dropped[m1]) and (valid_curves_p_set[m1]) and segment_type_m1 == segment_type_m then 
	       -- pen's segment is small respect of segment 
	       --print("BEZ pen m1="..m1, p_m1[1],p_m1[2],q_m1[1],q_m1[2],segment_type_m1)
	       --print("BEZ pen m1="..m1,"|m|=",mflua.modul_vec(p_m,q_m),"eps|m1|=",eps_pen*mflua.modul_vec(p_m1,q_m1),"|m1|=",mflua.modul_vec(p_m1,q_m1))
	       if mflua.modul_vec(p_m,q_m) > eps_pen*mflua.modul_vec(p_m1,q_m1) then
		  local A,B,a,b = -1,-1,-1,-1
		  if segment_type_m1 == 0 and math.abs(p_m[2]-p_m1[2])< eps then 
		     --print("BEZ m="..m,"m1="..m1,"segment_type_m1 == 0")
		     A,B = p_m[1],q_m[1]; if A>B then A,B = q_m[1],p_m[1] end 
		     a,b = p_m1[1],q_m1[1]; if a>b then a,b = q_m1[1],p_m1[1] end 
		  elseif segment_type_m1 == 1 and math.abs(p_m[1]-p_m1[1])< eps then 
		     --print("BEZ m="..m,"m1="..m1,"segment_type_m1 == 1")
		     A,B = p_m[2],q_m[2]; if A>B then A,B = q_m[2],p_m[2] end 
		     a,b = p_m1[2],q_m1[2]; if a>b then a,b = q_m1[2],p_m1[2] end 
		  end
		  --print("BEZ m="..m,"m1="..m1,"A,a,b,B=",A,a,b,B)
		  if (A<a and b<B) or  (A<a and b<=B) or  (A<=a and b<B)  then 
		     --print("BEZ m="..m,"m1="..m1,"A,a,b,B=",A,a,b,B)
		     --print("BEZ pen segment drop="..m1)
		     dropped[m1] = true 
		     valid_curves_p_set[m1] = false
		     if (A<a and b<B) then 
			-- we also drop the pen segments that are the previous and the next of a deleted pen's segment
			-- NO !! it's wrong
			 for m2, bez_m2 in pairs(temp_straight_curves) do
			    if not(dropped[m2]) and (valid_curves_p_set[m2]) then 
			       local segment_type_m2,p_m2,c1_m2,c2_m2,q_m2,shifted1 = bez_m2[1],bez_m2[2],bez_m2[3],bez_m2[4],bez_m2[5],bez_m2[6]
			       --if (mflua.modul_vec(p_m1,p_m2) <eps) or  (mflua.modul_vec(p_m1,q_m2)<eps) then dropped[m2] = true; valid_curves_p_set[m2] = false 
			       --elseif (mflua.modul_vec(q_m1,p_m2) <eps) or  (mflua.modul_vec(q_m1,q_m2)<eps) then dropped[m2] = true; valid_curves_p_set[m2] = false end
			    end
			 end
		     end
		  end
	       end
	    end
	 end 
      end
   end

  --local valid_curves = {};for k,v in pairs(temp_valid_curves) do if not(dropped[k] == true ) then valid_curves[k] = v else print("BEZ k="..k, "dropped") end  end   if true then return valid_curves end


   local valid_curves = {}
   local index = 0
   for k,v in pairs(temp_valid_curves) do 
      if not(dropped[k] == true ) then 
	 --index = index +1
	 valid_curves[k] = v 
      --else print("BEZ k="..k, "dropped")
      end
   end

   -- remove references to deleted paths
   --print("BEZ matrix_inters=",matrix_inters)
   if not(matrix_inters == nil ) then 
      for i, bezier in pairs(temp_valid_curves) do
	 local intersection  = matrix_inters[tostring(i)] or {}
	 local temp_intersection = {}
	 for _,v in ipairs( intersection) do 
	    local j  = tonumber(v[1])
	    if not(dropped[j] == true) then 
	       temp_intersection[#temp_intersection +1] = v
	       --else print("BEZ removed for path i="..i .. ' path j='..v[1])
	    end
	 end 
	 if #temp_intersection > 0 then 
	    matrix_inters[tostring(i)] = temp_intersection
	 else
	    matrix_inters[tostring(i)] = nil
	 end
      end
   end


   return valid_curves, matrix_inters
end




local function _remove_redundant_pen(valid_curves_p)
   --
   -- remove pens curves that are duplicated
   --
   print("BEZ _remove_redundant_pen")
   local temp_valid_curves_p = {}
   local set =  {}
   --for k,v in pairs(valid_curves_p) do temp_valid_curves_p[k]=v end
   for k,v in pairs(valid_curves_p) do 
      -- v := {pen[l],pen_c1,pen_c1,pen[l+1],p,coll_ind_pen}  
      local key = tostring(v[1])..tostring(v[2])..tostring(v[4])..tostring(v[5])
      local key1 = tostring(v[4])..tostring(v[2])..tostring(v[1])..tostring(v[5])
      if set[key]==nil and set[key1]==nil then 
   	 temp_valid_curves_p[k]=v
   	 set[key] = true 
   	 set[key1] = true 
      end
   end
   set = {}
   local tmp_cnt=1
   for k,v in pairs(temp_valid_curves_p) do set[k]=false end
   for k,v in pairs(temp_valid_curves_p) do 
      if set[k] == false then 
	 local pen_l,pen_c1,pen_c1,pen_l_1,p,coll_ind_pen 
	 local offset = '(0,0)'
	 pen_l,pen_c1,pen_c1,pen_l_1,p,coll_ind_pen = v[1],v[2],v[3],v[4],v[5],v[6]
	 --print("BEZ k="..k,pen_l,pen_c1,pen_c1,pen_l_1,p)
	 pen_l = _eval_tonumber(pen_l,offset)
	 pen_c1 = _eval_tonumber(pen_c1,offset)
	 pen_l_1 = _eval_tonumber(pen_l_1,offset)
	 p = _eval_tonumber(p,offset)
	 for k1,v1 in pairs(temp_valid_curves_p) do 
	    if set[k1]==false and k1~=k then 
	       local pen1_l,pen1_c1,pen1_c1,pen1_l_1,p1,coll_ind_pen1 
	       pen1_l,pen1_c1,pen1_c1,pen1_l_1,p1,coll_ind_pen1 = v1[1],v1[2],v1[3],v1[4],v1[5],v1[6]
	       --print("BEZ k1="..k1,pen1_l,pen1_c1,pen1_c1,pen1_l_1,p1)
	       pen1_l = _eval_tonumber(pen1_l,offset)
	       pen1_c1 = _eval_tonumber(pen1_c1,offset)
	       pen1_l_1 = _eval_tonumber(pen1_l_1,offset)
	       p1 = _eval_tonumber(p1,offset)
	       local eps = mflua.threshold_remove_redundant_pen or 0.02
	       if mflua.modul_vec(pen_l,pen1_l)<eps and mflua.modul_vec(pen_c1,pen1_c1)<eps 
	          and mflua.modul_vec(pen_l_1,pen1_l_1)<eps and mflua.modul_vec(p,p1)<eps then 
		  --if tmp_cnt <2 then
		     set[k1]=true
		     tmp_cnt=tmp_cnt+1
		     --print("BEZ v=",v[1],v[2],v[4],v[5])
		     --print("BEZ v1=",v1[1],v1[2],v1[4],v1[5])
		     --print("BEZ k="..k,"k1="..k1, "removed "..k1,tmp_cnt)
		  --end
		end
	     end
	  end 
      end
   end
   local res = {}
   for k,v in pairs(temp_valid_curves_p) do
      if set[k] == false then
	 --print("BEZ k="..k, "saved")
	 res[#res+1] = v
      end
   end
   --return temp_valid_curves_p
   return res
end


local function _remove_redundant_curves(valid_curves,matrix_inters,valid_curves_p_set)
   --
   -- remove Rj if it's inside Rk, Rj and Rk are not pen segments
   --
   print("BEZ  _remove_redundant_curves")
   -- remove useless paths
   valid_curves,matrix_inters =  _remove_isolate_path(valid_curves,matrix_inters)

   --if 1>0 then return valid_curves,matrix_inters end


   local temp_valid_curves_p = {}
   local dropped = {}
   local guard,guard1 = 0,0
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v;  dropped[k]=false; guard=guard+1;  end
   local eps = mflua.threshold_small_curve or 2
   local M = mflua.threshold_normal_curve or 2
   local MIN = mflua.threshold_min_dist or 0.1
   --  this is the short curve to delete
   for i, bezier in pairs(temp_valid_curves) do
      local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
      local p_i,c1_i,c2_i,q_i,shifted_i =  _coord_str_to_table_num(p,c1,c2,q,shifted)
      if mflua.modul_vec(p_i,q_i) < eps and mflua.modul_vec(p_i,c1_i)<eps and mflua.modul_vec(c2_i,q_i)<eps  and not(valid_curves_p_set[m]) then 
	 -- print("BEZ -----")
	 -- print("BEZ i="..i,
	 --       "p c1 c2 q="..p..c1..c2..q,
	 --       "∡𝛼="..math.deg(math.atan2(-p_i[2]+c1_i[2],-p_i[1]+c1_i[1])),
	 --       "∡𝛽="..math.deg(math.atan2(-c2_i[2]+q_i[2],-c2_i[1]+q_i[1])),
	 --       "|qp|="..mflua.modul_vec(p_i,q_i),"|pc1|="..mflua.modul_vec(p_i,c1_i), "|qc2|="..mflua.modul_vec(c2_i,q_i))

	 local intersection  = matrix_inters[tostring(i)] or {}
	 for _,v in ipairs( intersection) do 
	    local j,t,u = tonumber(v[1]),tonumber(v[2]),tonumber(v[3])
	    --print("BEZ i="..i, "v=",j,t,u)
	    if math.abs(t)< 0.02 or math.abs(u-1)<0.02 then
	       local bez_j = temp_valid_curves[j]
	       local pj,c1j,c2j,qj,shiftedj = bez_j[1],bez_j[2],bez_j[3],bez_j[4],bez_j[5]
	       local pj_j,c1j_j,c2j_j,qj_j,shiftedj_j =  _coord_str_to_table_num(pj,c1j,c2j,qj,shiftedj)
	       --  this is the long curve
	       if mflua.modul_vec(pj_j,qj_j) >= M then 
		  -- print("BEZ j="..j,
		  -- 	"p c1 c2 q="..pj..c1j..c2j..qj,
		  -- 	"∡𝛼="..math.deg(math.atan2(c1j_j[2]-pj_j[2],c1j_j[1]-pj_j[1])),
		  -- 	"∡𝛽="..math.deg(math.atan2(qj_j[2]-c2j_j[2],qj_j[1]-c2j_j[1])),
		  -- 	"∡𝛽1="..math.deg(math.atan2(qj_j[2]-q_i[2],qj_j[1]-q_i[1])),
		  -- 	"|qp|="..mflua.modul_vec(pj_j,qj_j),"|pc1|="..mflua.modul_vec(pj_j,c1j_j), "|qc2|="..mflua.modul_vec(c2j_j,qj_j))
		  if math.abs(math.deg(math.atan2(qj_j[2]-q_i[2],qj_j[1]-q_i[1]))-math.deg(math.atan2(-c2_i[2]+q_i[2],-c2_i[1]+q_i[1])))<1 then 
		     local cond, found = false,false
		     local table_xy={}
		     local uj=1
		     while cond == false do 
			uj=uj-0.01
			local x,y = bez(pj_j,c1j_j,c2j_j,qj_j,uj)
			--print("BEZ x,y=",x,y,q,mflua.modul_vec(q_i,{x,y}),"∡𝛽="..math.deg(math.atan2(q_i[1]-x,q_i[2]-y)))
			table_xy[#table_xy+1]={mflua.modul_vec(q_i,{x,y}),math.deg(math.atan2(q_i[1]-x,q_i[2]-y))}
			if uj<0.5 then cond = true end 
		     end
		     table.sort(table_xy,function (e1,e2) return e1[1] < e2[1] end)
		     local min,max = table_xy[1],table_xy[#table_xy]
		     --table.foreach(table_xy, function(...) print("BEZ   distance=",...) end)
		     -- a res = ((A and 1) or 0)*2 +((B and 1) or 0);
		     --
		     --
		     --print("BEZ min,MIN max=",min,MIN,max)
		     if min[1] < MIN   then 
			dropped[i] = true
			--print("BEZ i="..i.." dropped=",dropped[i])
		     end
		  end
	       end
	    end
	 end
      end
   end
   local paths_removed = {}
   for k,v in pairs(temp_valid_curves) do if dropped[k] == true then paths_removed[#paths_removed+1]=tostring(k) end end
   --print("BEZ #paths_removed="..#paths_removed)
   valid_curves,matrix_inters  = _remove_path_and_clean_up(valid_curves,matrix_inters,paths_removed)  

   --if 1>0 then return valid_curves,matrix_inters end


   print("BEZ remove redundant pending pen curves")
   local check = true 
   local check_cnt = 0
   local eps  = mflua.threshold_pending_path
   paths_removed = {}
   while check==true  do 
      check_cnt = check_cnt +1
      --print("BEZ check_cnt="..check_cnt)
      for i, bezier in pairs(valid_curves) do
	 local intersection  = matrix_inters[tostring(i)] or {} -- h
	 if #intersection <= 1 then  paths_removed[#paths_removed+1] = tostring(i) print("BEZ i="..i..' is pending:removed (⋂=1)') end 
	 if #intersection == 2  and math.abs(1-tonumber(intersection[1][2]))<eps  and math.abs(1-tonumber(intersection[2][2]))<eps then  
	    paths_removed[#paths_removed+1] = tostring(i) 
	    print("BEZ i="..i..' is pending:removed (⋂=2,t≈1)') 
	 end 
	 if #intersection == 2 and math.abs(0-tonumber(intersection[1][2]))<eps and math.abs(0-tonumber(intersection[2][2]))<eps then  
	    paths_removed[#paths_removed+1] = tostring(i) 
	    print("BEZ i="..i..' is pending:removed (⋂=2,t≈0)') 
	 end 
	 if #intersection > 2 then
	    local go_on = true 
	    for i,v in ipairs(intersection) do if math.abs(1-tonumber(intersection[i][2]))>=eps then go_on = false end end
	    if go_on == true then 
	       paths_removed[#paths_removed+1] = tostring(i) 
	       print("BEZ i="..i..' is pending:removed (⋂>2,t≈1)')  
	    end
	    go_on = true 
	    for i,v in ipairs(intersection) do if math.abs(0-tonumber(intersection[i][2]))>=eps then go_on = false end end
	    if go_on == true then 
	       paths_removed[#paths_removed+1] = tostring(i) 
	       print("BEZ i="..i..' is pending:removed (⋂>2,t≈1)')  
	    end
	 end
      end
      --
      -- hm why this ?
      --
      if check_cnt ==1  then check = false end 
      --print("BEZ #paths_removed="..#paths_removed)
      if #paths_removed > 0 then 
	 print("BEZ clean up")
	 --valid_curves,matrix_inters  = _remove_path(valid_curves,matrix_inters,paths_removed)
	 --_print_curve_intersections('1a',valid_curves,matrix_inters)
	 --valid_curves,matrix_inters =  _remove_isolate_path(valid_curves,matrix_inters)

	 valid_curves,matrix_inters = _remove_path_and_clean_up(valid_curves,matrix_inters,paths_removed)  
	 --_print_curve_intersections('1a',valid_curves,matrix_inters)
	 paths_removed = {}
      else
	 check = false
      end
   end
   --if 1>0 then return valid_curves,matrix_inters end


   paths_removed = {}
   --print("BEZ +++++++++++++++++++++++++++")
   --print("BEZ remove redundant pen curves")
   --print("BEZ +++++++++++++++++++++++++++")
   --for k,v in pairs(valid_curves_p_set) do print("BEZ set pen curves:k,v="..k, v) end	    

   dropped = {}
   temp_valid_curves = {};  for k,v in pairs(valid_curves) do 
      --print("BEZ seeing k="..k) 
      if valid_curves_p_set[k] then temp_valid_curves[k] = v; end ; dropped[k]=false;end
   local eps  = mflua.threshold_pending_path/2 or 0.0002
   for i, bezier in pairs(temp_valid_curves) do
      --print("BEZ ------------------------")
      --print("BEZ i="..i)
      local intersection  = matrix_inters[tostring(i)] or {}
      local set_not_pen = {}
      local l_set_not_pen = 0
      local bez_i = temp_valid_curves[i]
      local pj,c1j,c2j,qj,shiftedj = bez_i[1],bez_i[2],bez_i[3],bez_i[4],bez_i[5]
      local pj_i,c1j_i,c2j_i,qj_i,shiftedj_i =  _coord_str_to_table_num(pj,c1j,c2j,qj,shiftedj)
      --local cl = mflua.approx_curve_lenght(pj_i,c1j_i,c2j_i,qj_i)
      --local cl_min = mflua.modul_vec(pj_i,qj_i)
      --print("BEZ "..cl_min.."<=curve length<="..cl)
      local t_zero,u_one = true,true
      local t_one,u_zero = true,true
      for _,v in ipairs( intersection) do 
	 local j,t,u = tonumber(v[1]),tonumber(v[2]),tonumber(v[3])
	 if not(valid_curves_p_set[j]) then 
	    -- print("BEZ j="..j.." is not a pen")
	    -- print("BEZ j="..j.." t="..t,"u="..u,"1-t="..(1-t),"1-u="..(1-u))
	    -- print("BEZ j="..j.." t<eps",t<eps,"1-t<eps",1-t<eps)
	    -- print("BEZ j="..j.." 1-u<eps",1-u<eps,"u<eps",u<eps)
	    t_zero = t_zero and (t<eps)
	    u_one  = u_one  and (1-u<eps)
	    t_one = t_one and (1-t<eps)
	    u_zero = u_zero  and (u<eps)
	    set_not_pen[j] = true 
	    l_set_not_pen = l_set_not_pen +1
	 end
      end
      local check = -1
      --print("BEZ i="..i,"t_zero=",t_zero,"u_one=",u_one)
      --print("BEZ i="..i,"t_one=",t_one,"u_zero=",u_zero)
      if l_set_not_pen > 1 and not(t_zero or u_one)  and not( t_one or u_zero) then -- and cl_min< mflua.threshold_remove_redundant_curves  then 
	 check = l_set_not_pen
	 for j,v in pairs(set_not_pen) do 
	    local intersection  = matrix_inters[tostring(j)] or {}
	    local set_pen = {} 
	    set_pen[j] = true
	    for _,v in ipairs( intersection) do 
	       local jj = tonumber(v[1])
	       print("BEZ j="..j,v[1],v[2],v[3])
	       if not(valid_curves_p_set[jj]) then set_pen[jj] = true end
	    end
	    --for k,v in pairs(set_pen) do print("BEZ not-pen plus-j intersections of j="..j,k) end
	    local check_member = true
	    for k,v in pairs(set_not_pen) do 
	       if (set_pen[k] == false) or  (set_pen[k] == nil) then check_member=false ; break;end
	    end
	    if check_member == true then check = check -1 else break end 
	 end
      end
      --print("BEZ i="..i, "check="..check)
      if check == 0 then 
	 --print("BEZ i="..i, "dropped")
	 dropped[i] = true 
      end
   end
   paths_removed = {} ;for k,v in pairs(temp_valid_curves) do if dropped[k] == true then paths_removed[#paths_removed+1]=tostring(k) end end
   --valid_curves,matrix_inters  = _remove_path(valid_curves,matrix_inters,paths_removed)
   --valid_curves,matrix_inters =  _remove_isolate_path(valid_curves,matrix_inters)

   valid_curves,matrix_inters = _remove_path_and_clean_up(valid_curves,matrix_inters,paths_removed) 
   for _,_ in pairs(valid_curves) do guard1=guard1+1 end   
   --print("BEZ  _remove_redundant_curves end: guard="..guard, "guard1="..guard1)
   if guard ~= guard1 then 
      --print("BEZ  _remove_redundant_curves: another cycle") 
      valid_curves,matrix_inters =  _remove_redundant_curves(valid_curves,matrix_inters,valid_curves_p_set) 
   end
   return valid_curves,matrix_inters
end





local function _fix_pen_coord(valid_curves_p)
   --
   -- ensure that (x,y) == (x1,y1) iff ║(x,y)-(x1,y1)║ is small
   -- 
   print("BEZ _fix_pen_coord")
   local temp_valid_curves_p = {}
   local fixed =  {}
   for k,v in pairs(valid_curves_p) do temp_valid_curves_p[k]=v ; fixed[k] = false end
   for k,v in pairs(valid_curves_p) do 
      local pen_l,pen_c1,pen_c1,pen_l_1,p,coll_ind_pen 
      local offset = '(0,0)'
      pen_l,pen_c1,pen_c1,pen_l_1,p,coll_ind_pen = v[1],v[2],v[3],v[4],v[5],v[6]
      pen_l = _eval_tonumber(pen_l,offset)
      --pen_c1 = _eval_tonumber(pen_c1,offset)
      pen_l_1 = _eval_tonumber(pen_l_1,offset)
      --p = _eval_tonumber(p,offset)
      for k1,v1 in pairs(valid_curves_p) do 
	 local pen1_l,pen1_c1,pen1_c1,pen1_l_1,p1,coll_ind_pen 
	 if p==p1 and fixed[k]==false and fixed[k1]==false then 
	    pen1_l,pen1_c1,pen1_c1,pen1_l_1,p1,coll_ind_pen = v1[1],v1[2],v1[3],v1[4],v1[5],v1[6]
	    pen1_l = _eval_tonumber(pen1_l,offset)
	    --pen1_c1 = _eval_tonumber(pen1_c1,offset)
	    pen1_l_1 = _eval_tonumber(pen1_l_1,offset)
	    --p1 = _eval_tonumber(p1,offset)
	    local eps = 0.02
	    --X
	    if math.abs(pen_l[1]-pen1_l[1])<eps then
	       local m = (pen_l[1]+pen1_l[1])/2
	       pen_l[1],pen1_l[1]=m,m
	       fixed[k]=true
	       fixed[k1]=true
	    elseif math.abs(pen_l_1[1]-pen1_l_1[1])<eps then
	       local m = (pen_l_1[1]+pen1_l_1[1])/2
	       pen_l_1[1],pen1_l_1[1]=m,m
	       fixed[k]=true
	       fixed[k1]=true
	    elseif math.abs(pen_l[1]-pen1_l_1[1])<eps then
	       local m = (pen_l[1]+pen1_l_1[1])/2
	       pen_l[1],pen1_l_1[1]=m,m
	       fixed[k]=true
	       fixed[k1]=true
	    elseif math.abs(pen_l_1[1]-pen1_l[1])<eps then
	       local m = (pen_l_1[1]+pen1_l[1])/2
	       pen_l_1[1],pen1_l[1]=m,m
	       fixed[k]=true
	       fixed[k1]=true
	    end
	    --Y
	    if math.abs(pen_l[2]-pen1_l[2])<eps then
	       local m = (pen_l[2]+pen1_l[2])/2
	       pen_l[2],pen1_l[2]=m,m
	       fixed[k]=true
	       fixed[k1]=true
	    elseif math.abs(pen_l_1[2]-pen1_l_1[2])<eps then
	       local m = (pen_l_1[2]+pen1_l_1[2])/2
	       pen_l_1[2],pen1_l_1[2]=m,m
	       fixed[k]=true
	       fixed[k1]=true
	    elseif math.abs(pen_l[2]-pen1_l_1[2])<eps then
	       local m = (pen_l[2]+pen1_l_1[2])/2
	       pen_l[2],pen1_l_1[2]=m,m
	       fixed[k]=true
	       fixed[k1]=true
	    elseif math.abs(pen_l_1[2]-pen1_l[2])<eps then
	       local m = (pen_l_1[2]+pen1_l[2])/2
	       pen_l_1[2],pen1_l[2]=m,m
	       fixed[k]=true
	       fixed[k1]=true
	    end
	    pen_l = string.format('(%s,%s)',pen_l[1],pen_l[2])
	    pen_l_1 = string.format('(%s,%s)',pen_l_1[1],pen_l_1[2])
	    pen1_l = string.format('(%s,%s)',pen1_l[1],pen1_l[2])
	    pen1_l_1 = string.format('(%s,%s)',pen1_l_1[1],pen1_l_1[2])
	    --	    pen1_l,pen1_c1,pen1_c1,pen1_l_1,p1,coll_ind_pen = v1[1],v1[2],v1[3],v1[4],v1[5],v1[6]
	    v[1],v[4] = pen_l,pen_l_1
	    v1[1],v1[4] = pen1_l,pen1_l_1
	    temp_valid_curves_p[k] ={v[1],v[2],v[3],v[4],v[5],v[6]}
	    temp_valid_curves_p[k1] ={v1[1],v1[2],v1[3],v1[4],v1[5],v1[6]}
	 end
      end
   end   
   return temp_valid_curves_p
end



local function _reorder_table(valid_curves,valid_curves_p_set)
   --
   -- make a table an array starting from 1
   --
   local array = {}
   local p_set = {}
   local index = 0
   for k,v in pairs(valid_curves) do 
      index = index +1
      array[index]= v
      p_set[index] = false
      --print("BEZ k="..k,"valid_curves_p_set[k]=",valid_curves_p_set[k] )
      if valid_curves_p_set[k] == true then p_set[index] = true end
   end
   return array ,p_set
end

local function _fix_knots_II(valid_curves)
   --
   -- fix knots p & q if they are almost equals; 
   --
   print("BEZ _fix_knots_II")
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v; end
   local _set_points ={}
   local eps = mflua.threshold_fix_knots or 0.125

   for i, bezier in pairs(temp_valid_curves) do
      local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
      local p_i,c1_i,c2_i,q_i,shifted_i =  _coord_str_to_table_num(p,c1,c2,q,shifted)
      assert(bezier[5]=='(0,0)','Error on fix_knots_II: offset='..bezier[5].." not (0,0)")
      bezier[1] = "(" .. tonumber(string.format("%.3f",p_i[1])) .. "," .. tonumber(string.format("%.3f",p_i[2])) .. ")"
      bezier[2] = "(" .. tonumber(string.format("%.3f",c1_i[1])) .. "," .. tonumber(string.format("%.3f",c1_i[2])) .. ")"
      bezier[3] = "(" .. tonumber(string.format("%.3f",c2_i[1])) .. "," .. tonumber(string.format("%.3f",c2_i[2])) .. ")"
      bezier[4] = "(" .. tonumber(string.format("%.3f",q_i[1])) .. "," .. tonumber(string.format("%.3f",q_i[2])) .. ")"
      bezier[5] = "(" .. tonumber(string.format("%.3f",shifted_i[1])) .. "," .. tonumber(string.format("%.3f",shifted_i[2])) .. ")"
      _set_points[#_set_points+1]={x=tonumber(string.format("%.3f",p_i[1])),y=tonumber(string.format("%.3f",p_i[2])),type='p',index=i,done=false}
      _set_points[#_set_points+1]={x=tonumber(string.format("%.3f",q_i[1])),y=tonumber(string.format("%.3f",q_i[2])),type='q',index=i,done=false}
   end
   for j,v in ipairs(_set_points) do
      if v.done==false then
	 for jj,vv in ipairs(_set_points) do
	    if vv.done==false and jj>j then
	       if math.abs(v.x-vv.x)<eps and math.abs(v.y-vv.y)<eps then
		  --print("BEZ i="..j,"j="..jj,"(v.x,v.y)=",v.x,v.y, "(vv.x,vv.y)=",vv.x,vv.y)
		  v.done, vv.done=true,true 
		  v.x = tonumber(string.format("%.3f",(v.x+vv.x)/2))
		  vv.x = v.x
		  v.y = tonumber(string.format("%.3f",(v.y+vv.y)/2))
		  vv.y = v.y
		  --print("BEZ (v.x,v.y)=",v.x,v.y, "(vv.x,vv.y)=",vv.x,vv.y,v.type,vv.type,v.index,vv.index)
		  --print("BEZ v.index,vv.index=",v.index,vv.index)
		  
		  local bezier = temp_valid_curves[v.index]
		  if v.type=='p' then 
		     bezier[1] = "(" .. tonumber(string.format("%.3f",v.x)) .. "," .. tonumber(string.format("%.3f",v.y)) .. ")"
		  elseif v.type=='q' then
		     bezier[4] = "(" .. tonumber(string.format("%.3f",v.x)) .. "," .. tonumber(string.format("%.3f",v.y)) .. ")"
		  end
		  bezier = temp_valid_curves[vv.index]
		  if vv.type=='p' then 
		     bezier[1] = "(" .. tonumber(string.format("%.3f",vv.x)) .. "," .. tonumber(string.format("%.3f",vv.y)) .. ")"
		  elseif vv.type=='q' then
		     bezier[4] = "(" .. tonumber(string.format("%.3f",vv.x)) .. "," .. tonumber(string.format("%.3f",vv.y)) .. ")"
		  end
	       end
	    end
	 end
      end
   end
   for k,v in pairs(temp_valid_curves) do 
      --print("BEZ k="..k,v[1],v[2])
      valid_curves[k] = v   
   end   
   return valid_curves
end



local function _fix_knots(valid_curves)
   --
   -- fix knots p & q if they are almost equals; 
   -- fix  knots p & q if they have a coordinate  almost equal; 
   --
   print("BEZ _fix_knots")
   local done = {}
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v; done[k] = {p=false,q=false} end
   local eps = mflua.threshold_fix_knots or 0.125

   for i, bezier in pairs(temp_valid_curves) do
      local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
      local p_i,c1_i,c2_i,q_i,shifted_i =  _coord_str_to_table_num(p,c1,c2,q,shifted)
      bezier[1] = "(" .. tonumber(string.format("%.3f",p_i[1])) .. "," .. tonumber(string.format("%.3f",p_i[2])) .. ")"
      bezier[2] = "(" .. tonumber(string.format("%.3f",c1_i[1])) .. "," .. tonumber(string.format("%.3f",c1_i[2])) .. ")"
      bezier[3] = "(" .. tonumber(string.format("%.3f",c2_i[1])) .. "," .. tonumber(string.format("%.3f",c2_i[2])) .. ")"
      bezier[4] = "(" .. tonumber(string.format("%.3f",q_i[1])) .. "," .. tonumber(string.format("%.3f",q_i[2])) .. ")"
      bezier[5] = "(" .. tonumber(string.format("%.3f",shifted_i[1])) .. "," .. tonumber(string.format("%.3f",shifted_i[2])) .. ")"
   end

   
   for i, bezier in pairs(temp_valid_curves) do
      local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
      local p_i,c1_i,c2_i,q_i,shifted_i =  _coord_str_to_table_num(p,c1,c2,q,shifted)
      --print("BEZ --------")
      --print("BEZ i="..i,p,q)
      for j, bezier_j in pairs(temp_valid_curves) do
	 if not(i==j) then 
	    p,c1,c2,q,shifted = bezier_j[1],bezier_j[2],bezier_j[3],bezier_j[4],bezier_j[5]
	    local p_j,c1_j,c2_j,q_j,shifted_j =  _coord_str_to_table_num(p,c1,c2,q,shifted)
	    local check = -1
	    local Np_i,Np_j,Nq_i,Nq_j
	    if math.abs(p_i[1]-p_j[1])<eps and math.abs(p_i[2]-p_j[2])<eps then 
	       --print("BEZ --")
	       --print("BEZ i="..i,"j="..j,"p")
	       Np_i,Np_j = _round_points(p_i,p_j)
	       check=1
	    elseif math.abs(q_i[1]-q_j[1])<eps and math.abs(q_i[2]-q_j[2])<eps then 
	       --print("BEZ --")
	       --print("BEZ i="..i,"j="..j,"q")
	       Nq_i,Nq_j = _round_points(q_i,q_j)
	       check=2
	    elseif math.abs(p_i[1]-q_j[1])<eps and math.abs(p_i[2]-q_j[2])<eps then 
	       --print("BEZ --")
	       --print("BEZ i="..i,"j="..j,"pq")
	       Np_i,Nq_j = _round_points(p_i,q_j)
	       check=3
	    elseif math.abs(q_i[1]-p_j[1])<eps and math.abs(q_i[2]-p_j[2])<eps then 
	       --print("BEZ --")
	       --print("BEZ i="..i,"j="..j,"qp")
	       Nq_i,Np_j = _round_points(q_i,p_j)
	       check=4
	    end
	    --p = string.format("(%s,%s)",p_i[1],p_i[2])
	    --q = string.format("(%s,%s)",q_i[1],q_i[2])
	    --valid_curves[i][1] =p
	    --valid_curves[i][4] =q
	    local P,Q,x,y = 1,4,1,2
	    -- if check >0 then 
	    --    print("BEZ before, check="..check)
	    --    print("BEZ i="..i,valid_curves[i][P],valid_curves[i][Q])
	    --    print("BEZ j="..j,valid_curves[j][P],valid_curves[j][Q])
	    --    print("BEZ done[i].p=",done[i].p,"done[i].q=",done[i].q)
	    --    print("BEZ done[j].p=",done[j].p,"done[j].q=",done[j].q)
	    -- end
	    if check == 1 then 
	       if done[i].p ==true  and done[j].p==false then 
		  valid_curves[j][P] = string.format("(%s,%s)",p_i[x],p_i[y]) 
		  done[j].p=true
	       elseif done[i].p ==false  and done[j].p==true then 
		  valid_curves[i][P] = string.format("(%s,%s)",p_j[x],p_j[y]) 
		  done[i].p=true
	       elseif done[i].p ==false  and done[j].p==false then 
		  valid_curves[i][P] = string.format("(%s,%s)",Np_i[x],Np_i[y]) 
		  valid_curves[j][P] = string.format("(%s,%s)",Np_j[x],Np_j[y]) 
		  done[i].p=true; done[j].p=true
	       elseif done[i].p==true  and done[j].p==true then
		  -- pass
	       end
	    elseif check==2 then 
	       if done[i].q ==true  and done[j].q==false then 
		  valid_curves[j][Q] = string.format("(%s,%s)",q_i[x],q_i[y]) 
		  done[j].q=true
	       elseif done[i].q ==false  and done[j].q==true then 
		  valid_curves[i][Q] = string.format("(%s,%s)",q_j[x],q_j[y]) 
		  done[i].q=false
	       elseif done[i].q ==false  and done[j].q==false then 
		  valid_curves[i][Q] = string.format("(%s,%s)",Nq_i[x],Nq_i[y]) 
		  valid_curves[j][Q] = string.format("(%s,%s)",Nq_j[x],Nq_j[y]) 
		  done[i].q=false ; done[j].q=false
	       elseif done[i].q ==true  and done[j].q==true then 
		  -- pass
	       end
	    elseif check==3 then 
	       if done[i].p ==true  and done[j].q==false then 
		  valid_curves[j][Q] = string.format("(%s,%s)",p_i[x],p_i[y]) 
		  done[j].q=true
	       elseif done[i].p ==false  and done[j].q==true then 
		  valid_curves[i][P] = string.format("(%s,%s)",q_j[x],q_j[y]) 
		  done[i].p =true
	       elseif done[i].p ==false  and done[j].q==false then 
		  valid_curves[i][P] = string.format("(%s,%s)",Np_i[x],Np_i[y]) 
		  valid_curves[j][Q] = string.format("(%s,%s)",Nq_j[x],Nq_j[y]) 
		  done[i].p =true;done[j].q =true;
	       elseif done[i].p ==true  and done[j].q==true then 
		  -- pass
	       end
	    elseif check==4 then 
	       if done[i].q ==true  and done[j].p==false then 
		  valid_curves[j][P] = string.format("(%s,%s)",q_i[x],q_i[y]) 
		  done[j].q=true
		  done[i].p=true
	       elseif done[i].q ==false  and done[j].p==true then 
		  valid_curves[i][Q] = string.format("(%s,%s)",p_j[x],p_j[y]) 
		  done[i].q =true
	       elseif done[i].q ==false  and done[j].p==false then 
		  valid_curves[i][Q] = string.format("(%s,%s)",Nq_i[x],Nq_i[y]) 
		  valid_curves[j][P] = string.format("(%s,%s)",Np_j[x],Np_j[y]) 
		  done[i].q =true ; done[j].p=true 
	       elseif done[i].q ==true  and done[j].p==true then 
		  -- pass
	       end
	    end 
	    --if check >0 then 
	       --print("BEZ after")
	       --print("BEZ i="..i,valid_curves[i][P],valid_curves[i][Q])
	       --print("BEZ j="..j,valid_curves[j][P],valid_curves[j][Q])
	    --end
	 end
	 --print("BEZ i="..i,p,q)
      end
   end
   --for i, bezier in pairs(temp_valid_curves) do local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5] print("BEZ i="..i,p,q) end
   --
   temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v; done[k] = {p=false,q=false} end
   eps = mflua.threshold_fix_knots_1 or 0.0005
   local M =  mflua.threshold_fix_knots_2 or 4
   for i, bezier in pairs(temp_valid_curves) do
      local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
      local p_i,c1_i,c2_i,q_i,shifted_i =  _coord_str_to_table_num(p,c1,c2,q,shifted)
      --print("BEZ -fix x-------")
      --print("BEZ i="..i,p,q)
      for j, bezier_j in pairs(temp_valid_curves) do
	 if not(i==j) then 
	    p,c1,c2,q,shifted = bezier_j[1],bezier_j[2],bezier_j[3],bezier_j[4],bezier_j[5]
	    local p_j,c1_j,c2_j,q_j,shifted_j =  _coord_str_to_table_num(p,c1,c2,q,shifted)
	    local check = -1
	    local Np_i,Np_j,Nq_i,Nq_j
	    if math.abs(p_i[1]-p_j[1])<eps and mflua.modul_vec(p_i,p_j)<M then 
	       --print("BEZ --")
	       --print("BEZ i="..i,"j="..j,"p")
	       Np_i,Np_j = _round_points_x(p_i,p_j) -- {(p_i[1]+p_j[1])/2,p_i[2]}, {(p_i[1]+p_j[1])/2,p_j[2]}
	       --Np_i,Np_j =  {(p_i[1]+p_j[1])/2,p_i[2]}, {(p_i[1]+p_j[1])/2,p_j[2]}
	       check=-1
	    elseif math.abs(q_i[1]-q_j[1])<eps and mflua.modul_vec(q_i,q_j)<M then 
	       --print("BEZ --")
	       --print("BEZ i="..i,"j="..j,"q")
	       Nq_i,Nq_j = _round_points_x(q_i,q_j) --{(q_i[1]+q_j[1])/2,q_i[2]}, {(q_i[1]+q_j[1])/2,q_j[2]} 
	       --Nq_i,Nq_j = {(q_i[1]+q_j[1])/2,q_i[2]}, {(q_i[1]+q_j[1])/2,q_j[2]} 
	       check=-2
	    elseif math.abs(p_i[1]-q_j[1])<eps and mflua.modul_vec(p_i,q_j)<M then 
	       --print("BEZ --")
	       --print("BEZ i="..i,"j="..j,"pq")
	       Np_i,Nq_j = _round_points_x(p_i,q_j) -- {(p_i[1]+q_j[1])/2,p_i[2]}, {(p_i[1]+q_j[1])/2,q_j[2]}
	       --Np_i,Nq_j =  {(p_i[1]+q_j[1])/2,p_i[2]}, {(p_i[1]+q_j[1])/2,q_j[2]}
	       check=3
	    elseif math.abs(q_i[1]-p_j[1])<eps and mflua.modul_vec(q_i,p_j)<M then 
	       --print("BEZ --")
	       --print("BEZ i="..i,"j="..j,"qp")
	       Nq_i,Np_j = _round_points_x(q_i,p_j) -- {(q_i[1]+p_j[1])/2,q_i[2]}, {(q_i[1]+p_j[1])/2,p_j[2]}
	       --Nq_i,Np_j =  {(q_i[1]+p_j[1])/2,q_i[2]}, {(q_i[1]+p_j[1])/2,p_j[2]}
	       check=-4
	    end
	    --p = string.format("(%s,%s)",p_i[1],p_i[2])
	    --q = string.format("(%s,%s)",q_i[1],q_i[2])
	    --valid_curves[i][1] =p
	    --valid_curves[i][4] =q
	    local P,Q,x,y = 1,4,1,2
	    -- if check >0 then 
	    --    print("BEZ before, check="..check)
	    --    print("BEZ i="..i,valid_curves[i][P],valid_curves[i][Q])
	    --    print("BEZ j="..j,valid_curves[j][P],valid_curves[j][Q])
	    --    print("BEZ done[i].p=",done[i].p,"done[i].q=",done[i].q)
	    --    print("BEZ done[j].p=",done[j].p,"done[j].q=",done[j].q)
	    -- end
	    if check == 1 then 
	       if done[i].p ==true  and done[j].p==false then 
		  valid_curves[j][P] = string.format("(%s,%s)",p_i[x],p_i[y]) 
		  done[j].p=true
	       elseif done[i].p ==false  and done[j].p==true then 
		  valid_curves[i][P] = string.format("(%s,%s)",p_j[x],p_j[y]) 
		  done[i].p=true
	       elseif done[i].p ==false  and done[j].p==false then 
		  valid_curves[i][P] = string.format("(%s,%s)",Np_i[x],Np_i[y]) 
		  valid_curves[j][P] = string.format("(%s,%s)",Np_j[x],Np_j[y]) 
		  done[i].p=true; done[j].p=true
	       elseif done[i].p==true  and done[j].p==true then
		  -- pass
	       end
	    elseif check==2 then 
	       if done[i].q ==true  and done[j].q==false then 
		  valid_curves[j][Q] = string.format("(%s,%s)",q_i[x],q_i[y]) 
		  done[j].q=true
	       elseif done[i].q ==false  and done[j].q==true then 
		  valid_curves[i][Q] = string.format("(%s,%s)",q_j[x],q_j[y]) 
		  done[i].q=false
	       elseif done[i].q ==false  and done[j].q==false then 
		  valid_curves[i][Q] = string.format("(%s,%s)",Nq_i[x],Nq_i[y]) 
		  valid_curves[j][Q] = string.format("(%s,%s)",Nq_j[x],Nq_j[y]) 
		  done[i].q=false ; done[j].q=false
	       elseif done[i].q ==true  and done[j].q==true then 
		  -- pass
	       end
	    elseif check==3 then 
	       if done[i].p ==true  and done[j].q==false then 
		  valid_curves[j][Q] = string.format("(%s,%s)",p_i[x],p_i[y]) 
		  done[j].q=true
	       elseif done[i].p ==false  and done[j].q==true then 
		  valid_curves[i][P] = string.format("(%s,%s)",q_j[x],q_j[y]) 
		  done[i].p =true
	       elseif done[i].p ==false  and done[j].q==false then 
		  valid_curves[i][P] = string.format("(%s,%s)",Np_i[x],Np_i[y]) 
		  valid_curves[j][Q] = string.format("(%s,%s)",Nq_j[x],Nq_j[y]) 
		  done[i].p =true;done[j].q =true;
	       elseif done[i].p ==true  and done[j].q==true then 
		  -- pass
	       end
	    elseif check==4 then 
	       if done[i].q ==true  and done[j].p==false then 
		  valid_curves[j][P] = string.format("(%s,%s)",q_i[x],q_i[y]) 
		  done[j].q=true
		  done[i].p=true
	       elseif done[i].q ==false  and done[j].p==true then 
		  valid_curves[i][Q] = string.format("(%s,%s)",p_j[x],p_j[y]) 
		  done[i].q =true
	       elseif done[i].q ==false  and done[j].p==false then 
		  valid_curves[i][Q] = string.format("(%s,%s)",Nq_i[x],Nq_i[y]) 
		  valid_curves[j][P] = string.format("(%s,%s)",Np_j[x],Np_j[y]) 
		  done[i].q =true ; done[j].p=true 
	       elseif done[i].q ==true  and done[j].p==true then 
		  -- pass
	       end
	    end 
	    -- if check >0 then 
	    --    print("BEZ after")
	    --    print("BEZ i="..i,valid_curves[i][P],valid_curves[i][Q])
	    --    print("BEZ j="..j,valid_curves[j][P],valid_curves[j][Q])
	    -- end
	 end
	 --print("BEZ i="..i,p,q)
      end
   end

   --for i, bezier in pairs(temp_valid_curves) do local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]       print("BEZ i="..i,p,q) end
   --
   temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v; done[k] = {p=false,q=false} end
   eps = mflua.threshold_fix_knots_1 or 0.0005
   local M =  mflua.threshold_fix_knots_2 or 4
   for i, bezier in pairs(temp_valid_curves) do
      local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
      local p_i,c1_i,c2_i,q_i,shifted_i =  _coord_str_to_table_num(p,c1,c2,q,shifted)
      --print("BEZ -fix y-------")
      --print("BEZ i="..i,p,q)
      for j, bezier_j in pairs(temp_valid_curves) do
	 if not(i==j) then 
	    p,c1,c2,q,shifted = bezier_j[1],bezier_j[2],bezier_j[3],bezier_j[4],bezier_j[5]
	    local p_j,c1_j,c2_j,q_j,shifted_j =  _coord_str_to_table_num(p,c1,c2,q,shifted)
	    local check = -1
	    local Np_i,Np_j,Nq_i,Nq_j
	    if math.abs(p_i[2]-p_j[2])<eps and mflua.modul_vec(p_i,p_j)<M then 
	       --print("BEZ --")
	       --print("BEZ i="..i,"j="..j,"p")
	       Np_i,Np_j = _round_points_y(p_i,p_j)
	       check=1
	    elseif math.abs(q_i[2]-q_j[2])<eps and mflua.modul_vec(q_i,q_j)<M then 
	       --print("BEZ --")
	       --print("BEZ i="..i,"j="..j,"q")
	       Nq_i,Nq_j = _round_points_y(q_i,q_j)
	       check=2
	    elseif math.abs(p_i[2]-q_j[2])<eps and mflua.modul_vec(p_i,q_j)<M then 
	       --print("BEZ --")
	       --print("BEZ i="..i,"j="..j,"pq")
	       Np_i,Nq_j = _round_points_y(p_i,q_j)
	       check=3
	    elseif math.abs(q_i[2]-p_j[2])<eps and mflua.modul_vec(q_i,p_j)<M then 
	       --print("BEZ --")
	       --print("BEZ i="..i,"j="..j,"qp")
	       Nq_i,Np_j = _round_points_y(q_i,p_j)
	       check=4
	    end
	    --p = string.format("(%s,%s)",p_i[1],p_i[2])
	    --q = string.format("(%s,%s)",q_i[1],q_i[2])
	    --valid_curves[i][1] =p
	    --valid_curves[i][4] =q
	    local P,Q,x,y = 1,4,1,2
	    -- if check >0 then 
	    --    print("BEZ before, check="..check)
	    --    print("BEZ i="..i,valid_curves[i][P],valid_curves[i][Q])
	    --    print("BEZ j="..j,valid_curves[j][P],valid_curves[j][Q])
	    --    print("BEZ done[i].p=",done[i].p,"done[i].q=",done[i].q)
	    --    print("BEZ done[j].p=",done[j].p,"done[j].q=",done[j].q)
	    -- end
	    if check == 1 then 
	       if done[i].p ==true  and done[j].p==false then 
		  valid_curves[j][P] = string.format("(%s,%s)",p_i[x],p_i[y]) 
		  done[j].p=true
	       elseif done[i].p ==false  and done[j].p==true then 
		  valid_curves[i][P] = string.format("(%s,%s)",p_j[x],p_j[y]) 
		  done[i].p=true
	       elseif done[i].p ==false  and done[j].p==false then 
		  valid_curves[i][P] = string.format("(%s,%s)",Np_i[x],Np_i[y]) 
		  valid_curves[j][P] = string.format("(%s,%s)",Np_j[x],Np_j[y]) 
		  done[i].p=true; done[j].p=true
	       elseif done[i].p==true  and done[j].p==true then
		  -- pass
	       end
	    elseif check==2 then 
	       if done[i].q ==true  and done[j].q==false then 
		  valid_curves[j][Q] = string.format("(%s,%s)",q_i[x],q_i[y]) 
		  done[j].q=true
	       elseif done[i].q ==false  and done[j].q==true then 
		  valid_curves[i][Q] = string.format("(%s,%s)",q_j[x],q_j[y]) 
		  done[i].q=false
	       elseif done[i].q ==false  and done[j].q==false then 
		  valid_curves[i][Q] = string.format("(%s,%s)",Nq_i[x],Nq_i[y]) 
		  valid_curves[j][Q] = string.format("(%s,%s)",Nq_j[x],Nq_j[y]) 
		  done[i].q=false ; done[j].q=false
	       elseif done[i].q ==true  and done[j].q==true then 
		  -- pass
	       end
	    elseif check==3 then 
	       if done[i].p ==true  and done[j].q==false then 
		  valid_curves[j][Q] = string.format("(%s,%s)",p_i[x],p_i[y]) 
		  done[j].q=true
	       elseif done[i].p ==false  and done[j].q==true then 
		  valid_curves[i][P] = string.format("(%s,%s)",q_j[x],q_j[y]) 
		  done[i].p =true
	       elseif done[i].p ==false  and done[j].q==false then 
		  valid_curves[i][P] = string.format("(%s,%s)",Np_i[x],Np_i[y]) 
		  valid_curves[j][Q] = string.format("(%s,%s)",Nq_j[x],Nq_j[y]) 
		  done[i].p =true;done[j].q =true;
	       elseif done[i].p ==true  and done[j].q==true then 
		  -- pass
	       end
	    elseif check==4 then 
	       if done[i].q ==true  and done[j].p==false then 
		  valid_curves[j][P] = string.format("(%s,%s)",q_i[x],q_i[y]) 
		  done[j].q=true
		  done[i].p=true
	       elseif done[i].q ==false  and done[j].p==true then 
		  valid_curves[i][Q] = string.format("(%s,%s)",p_j[x],p_j[y]) 
		  done[i].q =true
	       elseif done[i].q ==false  and done[j].p==false then 
		  valid_curves[i][Q] = string.format("(%s,%s)",Nq_i[x],Nq_i[y]) 
		  valid_curves[j][P] = string.format("(%s,%s)",Np_j[x],Np_j[y]) 
		  done[i].q =true ; done[j].p=true 
	       elseif done[i].q ==true  and done[j].p==true then 
		  -- pass
	       end
	    end 
	    -- if check >0 then 
	    --    print("BEZ after")
	    --    print("BEZ i="..i,valid_curves[i][P],valid_curves[i][Q])
	    --    print("BEZ j="..j,valid_curves[j][P],valid_curves[j][Q])
	    -- end
	 end
	 --print("BEZ i="..i,p,q)
      end
   end

   --for i, bezier in pairs(temp_valid_curves) do local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]       print("BEZ i="..i,p,q) end
   return valid_curves
end 




local function _join_segments(valid_curves,valid_curves_p,valid_curves_p_set)
   --
   -- join horiz./vert. segments
   --
   print("BEZ _join_segments")
   local dropped = {}
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v;  dropped[k]=false;end
   local valid_curves = {}
   local eps = mflua.threshold_straight_line or 0.125
   for i, bezier in pairs(temp_valid_curves) do
      local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
      local p_i,c1_i,c2_i,q_i,shifted_i =  _coord_str_to_table_num(p,c1,c2,q,shifted)
      local segment_type_i = _is_a_straight_segment(p_i,c1_i,c2_i,q_i)
      --print("BEZ i=:"..i,p,c1,c2,q," segment type:"..segment_type_i) 
      for j, bezierJ in pairs(temp_valid_curves) do
	 local pJ,c1J,c2J,qJ,shiftedJ = bezierJ[1],bezierJ[2],bezierJ[3],bezierJ[4],bezierJ[5]
	 local p_j,c1_j,c2_j,q_j,shifted_j =  _coord_str_to_table_num(pJ,c1J,c2J,qJ,shiftedJ)
	 local segment_type_j = _is_a_straight_segment(p_j,c1_j,c2_j,q_j)
	 --
	 -- Only Horizontal segments ?
	 --
	 if segment_type_i == 0 and segment_type_i == segment_type_j  and dropped[j]==false and dropped[i]==false  and not(valid_curves_p_set[i]) and not(valid_curves_p_set[j]) then 
	    if q_i[1] == p_j[1]  and  q_i[2] == p_j[2] and mflua.modul_vec(p_j,q_j) < mflua.modul_vec(p_i,q_i) then 
	       --print("BEZ j=:"..j,pJ,c1J,c2J,qJ," segment type:"..segment_type_j) 
	       bezier[3] = c2J
	       bezier[4] = qJ
	       dropped[j]=true
	       --print("BEZ qp dropped j="..j)
	    end
	    if q_i[1] == q_j[1]  and  q_i[2] == q_j[2] and mflua.modul_vec(p_j,q_j) < mflua.modul_vec(p_i,q_i) then 
	       --print("BEZ j=:"..j,pJ,c1J,c2J,qJ," segment type:"..segment_type_j) 
	       bezier[3] = c2J
	       bezier[4] = pJ
	       dropped[j]=true
	       --print("BEZ qq dropped j="..j)
	    end
	    if p_i[1] == p_j[1]  and  p_i[2] == p_j[2] and mflua.modul_vec(p_j,q_j) < mflua.modul_vec(p_i,q_i) then 
	       --print("BEZ j=:"..j,pJ,c1J,c2J,qJ," segment type:"..segment_type_j) 
	       bezier[1] = qJ
	       bezier[2] = c2J
	       dropped[j]=true
	       --print("BEZ pq dropped j="..j)
	    end
	    if p_i[1] == q_j[1]  and  p_i[2] == q_j[2] and mflua.modul_vec(p_j,q_j) < mflua.modul_vec(p_i,q_i) then 
	       --print("BEZ j=:"..j,pJ,c1J,c2J,qJ," segment type:"..segment_type_j) 
	       bezier[1] = pJ
	       bezier[2] = c1J
	       dropped[j]=true
	       --print("BEZ pq dropped j="..j)
	    end
	 end
      end
   end
   for k,v in pairs(temp_valid_curves) do  if dropped[k]~=true  then  valid_curves[k] = v   end   end
   return valid_curves
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
   local mflua = mflua.mflua_exe or './mf' 
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
   os.remove('intersec.log')
   os.execute(string.format("%s %s",mflua,temp_file));
   os.remove('LOCK1')

   f_int_log = io.open('intersec.log')
   lines =  f_int_log:read("*all")
   f_int_log:close()

   local ij=string.gmatch(lines,"BEGIN i=([0-9]+),j=([0-9]+)")
   local tu=string.gmatch(lines,">> ([-0-9.]+)")
   local tab
   while true do 
      --local i,j = ij()
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
   --print("BEZ #matrix_inters="..#matrix_inters)
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
   --for i,v in ipairs(intervals) do print("BEZ i="..i, "v[1]="..v[1],"v[2]="..v[2]) end
   return intervals
end



local function _split_curve(p,c1,c2,q,offset,c)
   --
   --
   --
   --print("BEZ _split_curve")
   local p,c1,c2,q,shifted, coll_ind = p,c1,c2,q,offset,c
   local  intervals = {}
   local curves = {}
   local first_value, last_value
   local t1,t2
   local p_left,c1_left,c2_left,q_left
   local p_right,c1_right,c2_right,q_right

   --table.foreach(coll_ind,function(k,v) print("BEZ coll_ind k="..k,"v="..v) end )
   coll_ind = c
   intervals = _split_indexes(coll_ind)


   --print("BEZ #intervals="..#intervals)
   if #intervals == 0 then return curves end
   --table.foreach(intervals,function(k,v) print("BEZ intervals k=",k,"v=",v[1],v[2]) end )

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
      local P,Q
      --print("BEZ i="..i,"v[1]="..v[1],"v[2]="..v[2])
      t1 = values[v[1]]
      t2 = values[v[2]]
      --printBEZ t1="..tostring(t1).. " t2="..tostring(t2),t2/t1)
      --p_left,c1_left,c2_left,q_left =  _get_subcurve(p,c1,c2,q,t1,t2)
      P,_,_,Q =  _get_subcurve(p,c1,c2,q,t1,t2)
      --curves[#curves+1] = {p_left,c1_left,c2_left,q_left,shifted}
      --printBEZ curves["..#curves.."]=",p_left,c1_left,c2_left,q_left,shifted)
      _1,_2,_3,_4,_5,_6,_7,_8,_9 =  bez(p,c1,c2,q,t1)
      -- _1,_2,_3,_4,_5,_6,_7,_8,_9 =  bez_int(p,c1,c2,q,0+v[1])
      -- print("BEZ right ok")
      p_right,c1_right,c2_right,q_right = _6,_7,_8,_9
      _1,_2,_3,_4,_5,_6,_7,_8,_9 =  bez(p_right,c1_right,c2_right,q_right,t2-t1)
      --_1,_2,_3,_4,_5,_6,_7,_8,_9 =  bez(p,c1,c2,q,t2)

      --print("BEZ right=",string.format("p=(%s,%s) q=(%s,%s)",p_right[1],p_right[2],q_right[1],q_right[2]))
      -- _1,_2,_3,_4,_5,_6,_7,_8,_9 =  bez_int(p_right,c1_right,c2_right,q_right,0+v[2])
      -- print("BEZ left ok")
      p_left,c1_left,c2_left,q_left = _3,_4,_5,_6
      --print("BEZ left=",string.format("p=(%s,%s) q=(%s,%s)",p_left[1],p_left[2],q_left[1],q_left[2]))
      p_left = string.format("(%s,%s)",p_left[1],p_left[2])
      c1_left= string.format("(%s,%s)",c1_left[1],c1_left[2])
      c2_left = string.format("(%s,%s)",c2_left[1],c2_left[2])
      q_left =  string.format("(%s,%s)",q_left[1],q_left[2])
      --curves[#curves+1] = {p_left,c1_left,c2_left,q_left,shifted}
      --print("BEZ curves["..#curves.."]=",p_left,c1_left,c2_left,q_left,shifted)
      curves[#curves+1] = {P,c1_left,c2_left,Q,shifted}
      --print("BEZ curves["..#curves.."]=",P,c1_left,c2_left,Q,shifted)
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
   --print("BEZ open_loop")
   for i, bezier in pairs(temp_valid_curves) do
      local intersection  = matrix_inters[tostring(i)] or {}
      local drop = dropped[tostring(i)] or false 
      --print("BEZ check i=" ..i," and intersection[4]==nil", intersection[4]==nil )
      if not(intersection==nil) and not(intersection[2]==nil) and not(intersection[3]==nil)  and not(drop) then 
	 --print("BEZ i=" ..i,"3 intersections")
	 local check = {}
	 local j1 = intersection[1][1]
	 local j2 = intersection[2][1]
	 local j3 = intersection[3][1]
	 check[tostring(i)] = true
	 check[tostring(j1)] = true
	 check[tostring(j2)] = true
	 check[tostring(j3)] = true
	 --print("BEZ j1="..j1,"j2="..j2,"j3="..j3)
	 local intersection1 = matrix_inters[tostring(j1)] 
	 local intersection2 = matrix_inters[tostring(j2)] 
	 local intersection3 = matrix_inters[tostring(j3)] 

	 --print("BEZ check j3="..j3, not(intersection3==nil),  not(intersection3[2]==nil), (intersection3[3]==nil))
	 -- j1 has 2 intersections and can be remove to open the  loop

	 --print("BEZ check[tostring(i="..i..")]=",check[tostring(i)])
	 --print("BEZ check[tostring(j1="..j2..")]=",check[tostring(j1)])
	 --print("BEZ check[tostring(j2="..j2..")]=",check[tostring(j2)])
	 --print("BEZ check[tostring(j3="..j3..")]=",check[tostring(j3)])
	 --print("BEZ intersection1=",intersection1)
	 --print("BEZ intersection2=",intersection2)
	 --print("BEZ intersection3=",intersection3)


	 if not(intersection1==nil) and not(intersection1[2]==nil) and (intersection1[3]==nil) then 
	    --print("BEZ check[tostring(intersection1[1][1])] and  check[tostring(intersection1[2][1])]",check[tostring(intersection1[1][1])] and  check[tostring(intersection1[2][1])])
	    if check[tostring(intersection1[1][1])] and  check[tostring(intersection1[2][1])] then 
	       dropped[tostring(j1)] = true 
	    end
	 end
	 if not(intersection2==nil) and not(intersection2[2]==nil) and (intersection2[3]==nil) then 
	    --print("BEZ check[tostring(intersection2[1][1])] and  check[tostring(intersection2[2][1])] ",check[tostring(intersection2[1][1])] and  check[tostring(intersection2[2][1])] )
	    if check[tostring(intersection2[1][1])] and  check[tostring(intersection2[2][1])] then 
	       dropped[tostring(j2)] = true 
	    end
	 end
	 if not(intersection3==nil) and not(intersection3[2]==nil) and (intersection3[3]==nil) then 
	    --print("BEZ check[tostring(intersection3[1][1])] and  check[tostring(intersection3[2][1])] ",check[tostring(intersection3[1][1])] and  check[tostring(intersection3[2][1])] )
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
	 --print("BEZ k="..k.." cutted")
      end
   end
   --print("BEZ open loops end")
   return valid_curves,matrix_inters
end



local function _check_pen_outside_function(v,x,y)
   local xq, xr = v[2], v[3]
   local ok0 = 0
   local ok1 = 0
   local ok2 = 0
   local ok_hole = 0
   local X
   --print("BEZ _check_pen_outside_function x=".. x .. " y=" ..y.." " .. v[1])
   
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
   --print(string.format("BEZ _check_pen_outside_function ok0=%s, ok1=%s, ok2=%s", ok0,ok1,ok2))
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
   --X = x + 1 
   if not(X ==(0.0+xr[#xr][1])) and not(X ==(0.0+xr[1][1])) then 
      for j=1,#xr-1 do  if   xr[j][3]>0 and (xr[j][1]+0.0 <= X) and (X<xr[j+1][1]+0.0) then ok1 = 1;  break end     end
   end
   X = x -0.5
   --X = x -1
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
   local ok0,ok1,ok2,ok3,ok4 = 0,0,0,0,0
   local ok_hole = 0
   local X
   --print("BEZ _check_function ".. x .. " " ..y.." " .. v[1])
   
   X = x
   if not(X ==(0.0+xr[#xr][1])) and not(X ==(0.0+xr[1][1])) then 
      for j=1,#xr-1 do  if   xr[j][3]>0 and (xr[j][1]+0.0 <= X) and (X<xr[j+1][1]+0.0) then ok0 = 1;  break end     end
   end
   --X = x + 0.5 
   X = x + 1 
   if not(X ==(0.0+xr[#xr][1])) and not(X ==(0.0+xr[1][1])) then 
      for j=1,#xr-1 do  if   xr[j][3]>0 and (xr[j][1]+0.0 <= X) and (X<xr[j+1][1]+0.0) then ok1 = 1;  break end     end
   end
   --X = x -0.5
   X = x -1
   if not(X ==(0.0+xr[#xr][1])) and not(X ==(0.0+xr[1][1])) then 
      for j=1,#xr-1 do  if   xr[j][3]>0 and (xr[j][1]+0.0 <= X) and (X<xr[j+1][1]+0.0) then ok2 = 1;  break end     end
   end

   X = x + 2 
   if not(X ==(0.0+xr[#xr][1])) and not(X ==(0.0+xr[1][1])) then 
      for j=1,#xr-1 do  if   xr[j][3]>0 and (xr[j][1]+0.0 <= X) and (X<xr[j+1][1]+0.0) then ok3 = 1;  break end     end
   end
   --X = x -0.5
   X = x -2
   if not(X ==(0.0+xr[#xr][1])) and not(X ==(0.0+xr[1][1])) then 
      for j=1,#xr-1 do  if   xr[j][3]>0 and (xr[j][1]+0.0 <= X) and (X<xr[j+1][1]+0.0) then ok4 = 1;  break end     end
   end


   --print(string.format("_check_function ok0=%s, ok1=%s, ok2=%s", ok0,ok1,ok2))



   if (ok0==1) and (ok1==1) and (ok2==1) and (ok3==1) and (ok4==1) then
      return 1,ok0,ok1,ok2,ok2,ok3,ok4
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



local function _check_function_curve(v,x,y)
   local xq, xr = v[2], v[3]
   local ok0,ok1,ok2,ok3,ok4,ok5,ok6 = 0,0,0,0,0,0,0
   local ok_hole = 0
   local X
   --print("BEZ _check_function ".. x .. " " ..y.." " .. v[1])
   
   X = x
   if not(X ==(0.0+xr[#xr][1])) and not(X ==(0.0+xr[1][1])) then 
      for j=1,#xr-1 do  if   xr[j][3]>0 and (xr[j][1]+0.0 <= X) and (X<xr[j+1][1]+0.0) then ok0 = 1;  break end     end
   end
   --X = x + 0.5 
   X = x + 1 
   if not(X ==(0.0+xr[#xr][1])) and not(X ==(0.0+xr[1][1])) then 
      for j=1,#xr-1 do  if   xr[j][3]>0 and (xr[j][1]+0.0 <= X) and (X<xr[j+1][1]+0.0) then ok1 = 1;  break end     end
   end
   --X = x -0.5

   X = x -1
   if not(X ==(0.0+xr[#xr][1])) and not(X ==(0.0+xr[1][1])) then 
      for j=1,#xr-1 do  if   xr[j][3]>0 and (xr[j][1]+0.0 <= X) and (X<xr[j+1][1]+0.0) then ok2 = 1;  break end     end
   end
   --print(string.format("_check_function ok0=%s, ok1=%s, ok2=%s", ok0,ok1,ok2))

   X = x +2
   if not(X ==(0.0+xr[#xr][1])) and not(X ==(0.0+xr[1][1])) then 
      for j=1,#xr-1 do  if   xr[j][3]>0 and (xr[j][1]+0.0 <= X) and (X<xr[j+1][1]+0.0) then ok3 = 1;  break end     end
   end

   X = x -2
   if not(X ==(0.0+xr[#xr][1])) and not(X ==(0.0+xr[1][1])) then 
      for j=1,#xr-1 do  if   xr[j][3]>0 and (xr[j][1]+0.0 <= X) and (X<xr[j+1][1]+0.0) then ok4 = 1;  break end     end
   end


   X = x +3
   if not(X ==(0.0+xr[#xr][1])) and not(X ==(0.0+xr[1][1])) then 
      for j=1,#xr-1 do  if   xr[j][3]>0 and (xr[j][1]+0.0 <= X) and (X<xr[j+1][1]+0.0) then ok5 = 1;  break end     end
   end

   X = x -3
   if not(X ==(0.0+xr[#xr][1])) and not(X ==(0.0+xr[1][1])) then 
      for j=1,#xr-1 do  if   xr[j][3]>0 and (xr[j][1]+0.0 <= X) and (X<xr[j+1][1]+0.0) then ok6 = 1;  break end     end
   end



   if (ok0==1) and (ok1==1) and (ok2==1) and (ok3==1) and (ok4==1) and (ok5==1) and (ok6==1)  then
      return 1,ok0,ok1,ok2,ok2,ok3,ok4
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
	 return 0,ok0,ok1,ok2,ok3,ok4
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
   --print("BEZ _check_pen_point_outside BEGIN")

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
   --printBEZ Yfs="..Yfs,ye_map[Yfs],ye[ye_map[Yfs]],"ok="..ok)
   --write(string.format("draw (%s,%s) -- (%s,%s) withpen pencircle scaled 0.01pt withcolor blue ;\n",0,Yfs,100,Yfs)) 
   if ok == -1 and not(ye_map[Yfs]==nil) and not(ye[ye_map[Yfs]]==nil) then 
      v = ye[ye_map[Yfs]]
      ok1  = _check_pen_outside_function(v,X,Y) 
      ok = ok1
   end
   --printBEZ Yfs="..Yfs,ye_map[Yfs],ye[ye_map[Yfs]],"ok="..ok)

   --
   Yfs = tostring(Yf-1)
   --print("BEZ Yfs="..Yfs,ye_map[Yfs],ye[ye_map[Yfs]])
   --write(string.format("draw (%s,%s) -- (%s,%s) withpen pencircle scaled 0.01pt withcolor blue ;\n",0,Yfs,100,Yfs)) 
   --print(string.format("BEZ Y-math.floor(Y) <=0.5?%s,=%s",tostring(Y-math.floor(Y) <=0.5),Y-math.floor(Y)))
   if ok ~= 1 and Y-math.floor(Y) <=0.5 and  not(ye_map[Yfs]==nil) and not(ye[ye_map[Yfs]]== nil) then 
      v = ye[ye_map[Yfs]]
      ok2 = _check_pen_outside_function(v,X,Y)
      ok = ok2
   end
   --printBEZ Yfs="..Yfs,ye_map[Yfs],ye[ye_map[Yfs]],"ok="..ok)
   --
   Yfs = tostring(Yf+1)
   --print("BEZ Yfs="..Yfs,ye_map[Yfs],ye[ye_map[Yfs]])
   --f:write(string.format("draw (%s,%s) -- (%s,%s) withpen pencircle scaled 0.01pt withcolor blue ;\n",0,Yfs,100,Yfs)) 
   --print(string.format("BEZ Y-math.floor(Y) >0.5?%s,=%s",tostring(Y-math.floor(Y) >0.5),Y-math.floor(Y)))
   if ok ~= 1 and Y-math.floor(Y) >0.5 and  not(ye_map[Yfs]==nil) and not(ye[ye_map[Yfs]]== nil) then 
      v = ye[ye_map[Yfs]]
      ok3 = _check_pen_outside_function(v,X,Y)
      ok = ok3
   end
   --print("BEZ Yfs="..Yfs,ye_map[Yfs],ye[ye_map[Yfs]],"ok="..ok)
   --
   --print("BEZ _check_pen_point_outside ok="..ok,"ok1="..ok1,"ok2="..ok2,"ok3="..ok3)
   --print(string.format("BEZ x=%s,x_off=%s,y=%s,y_off=%s,X=%s,Y=%s",x,x_off,y,y_off,X,Y))

   --print("BEZ _check_pen_point_outside END")
   return ok,ok1,ok2,ok3
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
   --print("BEZ  BEGIN check_pen_point "..cnt .." *************************************")
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
      --print("BEZ OK="..ok)
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
	    --f:write(string.format("draw (%s,%s) withpen pencircle scaled 0.1pt withcolor (0,0.8,0.8) ;\n",x,y)) 
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






local function _check_point(char,p,c1,c2,q,offset,id,drawpoint)
   --must do a deep clean up !!
   --
   --
   -- 
   --print("BEZ _check_point")
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
   local draw =true
   

   if drawpoint ==false then draw = false end
   --print("BEZ draw=",draw)


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
      ok4 = -1
      ok5 = -1
      outside = 0
      out1,out2,out3,out4,out5 = 0,0,0,0,0


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
	 ok1,out1  = _check_function_curve(v,X,Y) 
	 ok = ok1
	 outside = out1
      end
      --
      Yfs = tostring(Yf-2)
      if ok >= 0 and Y-math.floor(Y) <=10.5 and  not(ye_map[Yfs]==nil) and not(ye[ye_map[Yfs]]== nil) then 
      	 --print("BEZ check Yfs-1",Yfs)
      	 v = ye[ye_map[Yfs]]
      	 ok2,out2 = _check_function_curve(v,X,Y)
      	 ok = ok + ok2
      	 outside= outside + out2
      end
      --
      Yfs = tostring(Yf-1)
      if ok >= 0 and Y-math.floor(Y) <=10.5 and  not(ye_map[Yfs]==nil) and not(ye[ye_map[Yfs]]== nil) then 
	 --print("BEZ check Yfs-1",Yfs)
	 v = ye[ye_map[Yfs]]
	 ok3,out3 = _check_function_curve(v,X,Y)
	 ok = ok + ok3
	 outside= outside + out3
      end
      --
      Yfs = tostring(Yf+1)
      if ok >= 0 and Y-math.floor(Y) >-0.5 and not(ye_map[Yfs]==nil) and not(ye[ye_map[Yfs]]==nil) then 
	 --print("BEZ check Yfs+1",Yfs)
	 v = ye[ye_map[Yfs]]
	 ok4,out4 = _check_function_curve(v,X,Y)
	 ok = ok + ok4
	 outside= outside + out4
      end
      --
      Yfs = tostring(Yf+2)
      if ok >= 0 and Y-math.floor(Y) >-0.5 and not(ye_map[Yfs]==nil) and not(ye[ye_map[Yfs]]==nil) then 
      	 --print("BEZ check Yfs+1",Yfs)
      	 v = ye[ye_map[Yfs]]
      	 ok5,out5 = _check_function_curve(v,X,Y)
      	 ok = ok + ok5
      	 outside= outside + out5
      end

      --print("BEZ OK="..ok,"index="..index ,ok1,ok2,ok3,ok4,ok5,x,y,#coll_ind)
      if ok ==5 then -- the point is internal
	 --print("BEZ the point is internal")
	 local ID = id or ''
	 nr_ok = nr_ok+1
	 if draw then f:write(string.format("draw (%s,%s) withpen pencircle scaled 0.0513pt withcolor red ;\n",x,y)) end
	 --f:write(string.format("label(\"%s %s   %s, y=%s  1=%s,2=%s,3=%s,4=%s,5=%s,    \",(%s+0.0,%s+0.0)) ;\n",index,ID,x,y,ok1,ok2,ok3,ok4,ok5,x,y)) 
	 --f:write(string.format("label(\"Y=%s y_off=%s y=%s  Yfs 1=%s,2=%s,3=%s,4=%s,5=%s,    \",(%s+5.0,%s-0.5)) ;\n",Y,y_off,y,tostring(Yf),tostring(Yf-2),tostring(Yf-1),tostring(Yf+1),tostring(Yf+2)
	--		       ,x,y)) 

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
      if ok ~= 5 then -- the point is external or on the frontier
	 --print("BEZ the point is external or on the frontier")
	 --print(string.format("\nBEZ BEGIN ok=%s,ok1=%s,ok2=%s,ok3=%s",ok,ok1,ok2,ok3))
	 --print(string.format("BEZ BEGIN outside=%s,out1=%s,out2=%s,out3=%s",outside,out1,out2,out3)) 
	 Yfs = tostring(Yf)
	 --print(string.format("BEZ x=%s,x_off=%s,y=%s,y_off=%s,X=%s,Y=%s,Yfs=%s,ye_map[Yfs]=%s",
		--	     x,x_off,y,y_off,X,Y,Yfs,ye_map[Yfs] or 'nil'))
	 v = (ye_map[Yfs]~= nil) and  ye[ye_map[Yfs]]  or nil
	 if not(v==nil) then 
	    xr = v[3]
	    ok1,out1  = _check_function_curve(v,X,Y) 
	    --for j=1,#xr-1 do  
	       --print(string.format("X=%s,x=%s,Y=%s,y=%s,Row=%s,xr[j][3]=%s,xr[j][1]=%s ,xr[j+1][1]=%s",
		--		    X,   x,   Y,   y,   v[1],  xr[j][3],   xr[j][1],    xr[j+1][1]   )) 
	    --end; 
	    --print(_check_function_curve(v,X,Y))
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
	    ok1,out2  = _check_function_curve(v,X,Y) 
	    --for j=1,#xr-1 do  
	       --print(string.format("X=%s,x=%s,Y=%s,y=%s,Row=%s,xr[j][3]=%s,xr[j][1]=%s ,xr[j+1][1]=%s",
		--		    X,   x,   Y,   y,   v[1],  xr[j][3],   xr[j][1],    xr[j+1][1]   )) 
	    --end; 
	    --print(_check_function_curve(v,X,Y))
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
	    ok1,out3  = _check_function_curve(v,X,Y) 
	    --for j=1,#xr-1 do  
	       --print(string.format("X=%s,x=%s,Y=%s,y=%s,Row=%s,xr[j][3]=%s,xr[j][1]=%s ,xr[j+1][1]=%s",
			--	    X,   x,   Y,   y,   v[1],  xr[j][3],   xr[j][1],    xr[j+1][1]   )) 
	    --end; 
	    --print(_check_function_curve(v,X,Y))
	    --print()
	 else
	    out3 = -1000
	 end
	 --print("BEZ out1+out2+out3=",out1+out2+out3)
	 if (out1+out2+out3)<=-3000 then 
	    if draw then f:write(string.format("draw (%s,%s) withpen pensquare scaled 0.02pt withcolor red ;\n",x,y)) end
	    -- f:write(string.format("label(\"%s\",(%s+0.5,%s+0.5)) ;\n",index,x,y)) 
	    if red_flag==-1 then -- first time 
	       red_flag = 1
	       coll_ind[#coll_ind+1] = index 
	       coll_ind_temp[1] = false
	       --print("BEZ (2) RED:first time :#coll_ind=" .. #coll_ind," index="..index..'RED')
	    elseif red_flag==1 then -- prev point was red
	       --print("BEZ transition 1 to 0 index=" ..  index)
	       red_flag = 1
	       coll_ind[#coll_ind+1] = index 
	       coll_ind_temp[#coll_ind_temp+1] = false
	       --print("BEZ (2) RED: prev point was red :#coll_ind=" .. #coll_ind," index="..index..'RED')
	    elseif red_flag==0 then -- first was valid point
	       --print("BEZ transition 1 to 0 index=" ..  index)
	       red_flag = 1
	       coll_ind[#coll_ind+1] = index 
	       coll_ind_temp[#coll_ind_temp+1] = false
	       --print("BEZ (2) RED: first was a valid point :#coll_ind=" .. #coll_ind," index="..index..'RED')
	    end
	 else
	    if draw then f:write(string.format("draw (%s,%s) withpen pencircle scaled 0.1pt withcolor blue ;\n",x,y)) end
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
	    --print("BEZ BLUE prev point was internal:#coll_ind="..#coll_ind,' index='..index..' BLUE')
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
	    -- we lie and say that last point is not red
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



local function _merge_segments(char,valid_curves,valid_curves_p,valid_curves_p_set)
   --
   -- join horiz./vert. segments
   --
   print("BEZ _merge_segments")
   local dropped = {}
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v;  dropped[k]=false;end
   local valid_curves = {}
   local eps = mflua.threshold_merge_segments  or 5e-5
   for i, bezier in pairs(temp_valid_curves) do
      if dropped[i]==false then 
	 local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
	 local p_i,c1_i,c2_i,q_i,shifted_i =  _coord_str_to_table_num(p,c1,c2,q,shifted)
	 local segment_type_i = _is_a_straight_segment(p_i,c1_i,c2_i,q_i)
	 --print("BEZ i="..i,p,c1,c2,q," segment type:"..segment_type_i) 
	 for j, bezierJ in pairs(temp_valid_curves) do
	    local pJ,c1J,c2J,qJ,shiftedJ = bezierJ[1],bezierJ[2],bezierJ[3],bezierJ[4],bezierJ[5]
	    local p_j,c1_j,c2_j,q_j,shifted_j =  _coord_str_to_table_num(pJ,c1J,c2J,qJ,shiftedJ)
	    local segment_type_j = _is_a_straight_segment(p_j,c1_j,c2_j,q_j)
	    -- print("BEZ j:"..j,pJ,c1J,c2J,qJ," segment type:"..segment_type_j) 
	    -- print("BEZ math.abs(p_i[2]-p_j[2]<eps:",math.abs(p_i[2]-p_j[2])<eps,"math.abs(q_i[2]-q_j[2])<eps:",math.abs(p_i[2]-p_j[2])<eps) 
	    -- print("BEZ math.abs(p_i[1]-p_j[1])<eps",math.abs(p_i[1]-p_j[1])<eps,"math.abs(q_i[1]-q_j[1])<eps:",math.abs(q_i[1]-q_j[1])<eps)
	    -- print("BEZ first cond:",segment_type_i == segment_type_j  and i~=j and dropped[j]==false and dropped[i]==false  and not(valid_curves_p_set[i]) and not(valid_curves_p_set[j]))
	    -- print("BEZ first cond:segment_type_i == segment_type_j",segment_type_i == segment_type_j)
	    -- print("BEZ first cond: i~=j",i~=j)
	    -- print("BEZ first cond:dropped[j]==false",dropped[j]==false)
	    -- print("BEZ first cond:dropped[i]==false",dropped[i]==false)
	    -- print("BEZ first cond:not(valid_curves_p_set[i])",not(valid_curves_p_set[i]))
	    -- print("BEZ first cond:not(valid_curves_p_set[j])",not(valid_curves_p_set[j]))
	    --           ⒤                 ⒥
	    --   ●-----------◼--------●-------------◼
	    --   A1x━━━━━━━━B1x━━━━━━A2x━━━━━━━━━━━B2x
	    -- 
	    if segment_type_i == segment_type_j  and i~=j and dropped[j]==false and dropped[i]==false  and not(valid_curves_p_set[i]) and not(valid_curves_p_set[j]) then 
	       if (segment_type_i==0 and  math.abs(p_i[2]-p_j[2])<eps and math.abs(q_i[2]-q_j[2])<eps) or (segment_type_i==1 and math.abs(p_i[1]-p_j[1])<eps and math.abs(q_i[1]-q_j[1])<eps) then
		  --print("BEZ ----") 
		  --print("BEZ j:"..j,pJ,c1J,c2J,qJ," segment type:"..segment_type_j) 
		  local xcoord = (segment_type_i==0 and  {{p_i[1],'pi'},{p_j[1],'pj'},{q_i[1],'qi'},{q_j[1],'qj'}}) or (segment_type_i==1 and {{p_i[2],'pi'},{p_j[2],'pj'},{q_i[2],'qi'},{q_j[2],'qj'}})
		  --print("BEZ xcoord",xcoord)
		  --print("BEZ xcoord",xcoord[1][1],xcoord[1][2],xcoord[2][1],xcoord[2][2],xcoord[3][1],xcoord[3][2],xcoord[4][1],xcoord[4][2])
		  table.sort(xcoord, function(x,y)  return x[1]<y[1] end)
		  local A1x,B1x,A2x,B2x = xcoord[1][1],xcoord[2][1],xcoord[3][1],xcoord[4][1]
		  local s = xcoord[1][2] .. '-' .. xcoord[2][2] .. '-' .. xcoord[3][2] .. '-' .. xcoord[4][2]
		  --print("BEZ A1x,B1x,A2x,B2x=",A1x,B1x,A2x,B2x)
		  --print("BEZ s="..s)
		  --print("BEZ (A1x<B1x) and (B1x<A2x) and (A2x<B2x):",(A1x<B1x) and (B1x<A2x) and (A2x<B2x) )
		  if (A1x<B1x) and (B1x<A2x) and (A2x<B2x) then
		     local P,C1,C2,Q 
		     if s=='pi-pj-qi-qj' then P, C1,C2,Q = p,c1,c2J, qJ  end
		     if s=='pi-qj-qi-pj' then P, C1,C2,Q = p,c1,c1J, pJ  end
		     if s=='qi-qj-pi-pj' then P, C1,C2,Q = q,c2,c2J, pJ  end
		     if s=='qi-pj-pi-qj' then P, C1,C2,Q = q,c2,c1J, qJ  end
		     if P~=nil then 
			--print("BEZ j="..j, "dropped",pJ,c1J,c2J,qJ)
			--print("BEZ P,C1,C2,Q=",P,C1,C2,Q)
			dropped[j] = true 
			bezier[1],bezier[2],bezier[3],bezier[4],bezier[5] = P,C1,C2,Q, shifted
			local nr_ok,values,coll_ind =  _check_point(char,P,C1,C2,Q,shifted,'',false)
			bezier[6]=coll_ind
		     else
			--print("BEZ j="..j, "P is nil! ","j="..j, pJ,c1J,c2J,qJ,"A1x,B1x,A2x,B2x=",A1x,B1x,A2x,B2x)
			--print("BEZ j="..j, pJ,c1J,c2J,qJ)
			--print("BEZ A1x,B1x,A2x,B2x=",A1x,B1x,A2x,B2x)
		     end
		  end
	       end
	    end
	 end
      end
   end
   for k,v in pairs(temp_valid_curves) do  if dropped[k]~=true  then  valid_curves[k] = v   end   end
   return valid_curves
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
   print("BEZ remove duplicate path II")
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
		  --print("BEZ i="..i,"j="..j,"ll="..ll, "children_i[ll]="..tostring(children_i[tonumber(ll)]))
		  if children_i[tonumber(ll)] == nil then 
		     remove_node = false 
		     --print("BEZ cannot remove j="..j)
		     break
		  end
	       end
	       if remove_node == true then 
                  -- hmm, we should really check if we can remove
		  -- this path. With A ccr10 it doesn't work
		  -- Perhaps _check_point could help here
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
   --printBEZ remove duplicate path II end")
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
	 --print("BEZ i="..i,"valid_curves_p_set[i]="..tostring(valid_curves_p_set[i]))
	 local intersection  = matrix_inters[tostring(i)] or {}
	 local check = false 
	 for _,inters in ipairs(intersection) do  
	    local j,t,u= tonumber(inters[1]),tonumber(inters[2]),tonumber(inters[3])
	    --print("BEZ math.abs(1-t)="..math.abs(1-t))
	    --print("BEZ mflua.threshold_small_pen_path="..mflua.threshold_small_pen_path)
	    if (math.abs(1-t) < mflua.threshold_small_pen_path) then -- or  (math.abs(t) < mflua.threshold_small_pen_path) then 
	       check = true
	    else
	       check = false
	       break
	    end
	 end -- for _,inters in ipairs(intersection) do  
	 --print("BEZ i="..i,"check="..tostring(check))
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
	 --print("BEZ k="..k.." cutted")
      end
   end
   --printBEZ remove_pending_pen_path end")
   --printBEZ ---------------------------")
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
	 --print("BEZ i="..i)
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
	 --print("BEZ count_tj="..count_tj,"count_uj="..count_uj)
	 for _,inters in ipairs(intersection) do  
	    local j,t,u= tonumber(inters[1]),inters[2],inters[3]
	    --print("BEZ #intersection="..#intersection)
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
		     -- print("BEZ removed j="..j)
		     if valid_curves_p_set[i]==false and (count_tj == 1 or count_uj == 1) then 
			temp_removed[i] =true 
			--print("BEZ removed i="..i)
		     end
		  end
	       end --_,inters_j in ipairs(intersection_j) do 
	    end -- if ((t=='0' and u=='0') or (t=='1' and u=='1')) and temp_removed[j]==false then 
	 end -- for _,inters in ipairs(intersection) do  
      end --if temp_removed[k]==false then 
   end -- for 
   local valid_curves = {}
   for k,v in pairs(temp_valid_curves) do 
      --print("BEZ k="..k, "temp_removed[k]="..tostring(temp_removed[k]))
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
	 --print("BEZ i=" ..i,"3 intersections")
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
	 --print("BEZ k="..k.." cutted")
      end
   end
   --printBEZ pen loops end")
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
	 --print("BEZ ---------")
	 --print("BEZ i="..i)
	 local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
         local check_p,check_q = -1,-1
         local p_ok1,p_ok2,p_ok3 = 1,1,1
         local q_ok1,q_ok2,q_ok3 = 1,1,1
	 local pn,qn = _eval_tonumber(p,shifted),_eval_tonumber(q,shifted)
	 --print("BEZ i="..i,"p="..p)
	 check_p,p_ok1,p_ok2,p_ok3 = _check_pen_point_outside(char,p,shifted)
	 --print("BEZ i="..i,"q="..q)
	 check_q,q_ok1,q_ok2,q_ok3 = _check_pen_point_outside(char,q,shifted)
	 --print("BEZ i="..i,"check_p="..check_p,"check_q="..check_q)
	 --print("BEZ i="..i,"#intersection="..#intersection)
	 if (check_p == 0 or check_q == 0) and #intersection <2 then 
	    dropped[tostring(i)] = true 
	 elseif (p_ok1<=0 and p_ok2>0 and p_ok3<=0 and math.abs(pn[2]-math.floor(pn[2])) >0) and check_q == 0 then 
	    dropped[tostring(i)] = true 
	 elseif (p_ok1<=0 and p_ok2<=0 and p_ok3>0 and math.abs(pn[2]-math.floor(pn[2])) >0) and check_q == 0 then 
	    dropped[tostring(i)] = true 
	 elseif (q_ok1<=0 and q_ok2>0 and q_ok3<=0 and math.abs(qn[2]-math.floor(qn[2])) >0) and check_p == 0 then 
	    dropped[tostring(i)] = true 
	 elseif (q_ok1<=0 and q_ok2<=0 and q_ok3>0 and math.abs(qn[2]-math.floor(qn[2])) >0) and check_p == 0 then 
	    dropped[tostring(i)] = true 
	 end
      end
   end
   --valid_curves = {}
   local temp_dropped = {}
   for k, _ in pairs(dropped) do temp_dropped[#temp_dropped+1] = tostring(k) end
   valid_curves,matrix_inters = _remove_path(temp_valid_curves,matrix_inters,temp_dropped)

   -- for k,v in pairs(temp_valid_curves) do 
   --    if not(dropped[tostring(k)]) then
   -- 	 local intersection  = matrix_inters[tostring(k)] or {}
   -- 	 local temp = {}
   -- 	 valid_curves[k] = v 
   -- 	 for _,v in ipairs( intersection) do 
   -- 	    if not(dropped[tostring(v[1])]) then 
   -- 	       temp[#temp+1] = {v[1],v[2],v[3]}
   -- 	    end
   -- 	 end
   -- 	 matrix_inters[tostring(k)] = temp 
   --    else
   -- 	 matrix_inters[tostring(k)] = nil
   -- 	 print("BEZ k="..k.." cutted")
   --    end
   -- end
   --printBEZ pen loops 0 end")
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
	 --print("BEZ k="..k.." cutted")
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
	 --print("BEZ ii="..ii)
	 if bez_done[ii] then print("BEZ ii="..ii,"already done") break end
	 local bezier = valid_curves[ii]
	 local p_1,c1_1,c2_1,q_1 = _coord_str_to_table(bezier[1],bezier[2],bezier[3],bezier[4])
	 for j=1, #temp_single_inters do
	    if j==i then  break end 
	    local jj = temp_single_inters[j]
	    if bez_done[jj] then 
	       --print("BEZ jj="..jj,"already done") 
	       break 
	    end
	    --print("BEZ doing jj="..jj)
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
	    --print("BEZ i="..temp_single_inters[i],"jj="..jj,"jjj="..jjj,m[jjj])
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
	 --print("BEZ i="..i, "is not a good_path")
	 local intersection  = matrix_inters[tostring(i)] or {}
	 local check_i =  {}
	 local paths_i = {}
	 for k,v in ipairs(intersection) do check_i[tonumber(v[1])] = true  end
	 local paths_i = {}
	 for k,v in ipairs(intersection) do 
	    local j,t,u = v[1],v[2],v[3]
	    paths_i[#paths_i+1] = {tonumber(i)}
	    --print("BEZ -------------")
	    --print("BEZ i="..i,"check j="..j)
	    if good_path[tonumber(j)] and temp_removed[tonumber(j)] == false  then
	       --print("BEZ j="..j,"good_path[j][begin]"..good_path[tonumber(j)]["begin"],"good_path[j][end]="..good_path[tonumber(j)]["end"])
	       local temp_t = paths_i[#paths_i] 
	       temp_t[#temp_t+1] = tonumber(j)
	       local current_i = i
	       local current_j = j
	       local cond = true 

	       while cond == true do
		  local prev_j =  good_path[tonumber(current_j)]["begin"]
		  if prev_j == current_i then prev_j =  good_path[tonumber(current_j)]["end"] end
		  --print("BEZ current_i="..current_i,"j="..current_j, "prev_j="..prev_j)
		  if tonumber(current_i) == tonumber(prev_j) then -- a pending path
		     cond = false
		     removable = true 
		     --print("BEZ found removable in j="..current_j)
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
			--print ("BEZ cond false: found prev_j="..prev_j) 
		     else
			temp_t[#temp_t+1] = tonumber(current_j)
		     end
		  end
	       end --while
	       paths_i[#paths_i] = temp_t
	       --print("BEZ #paths_i[#paths_i]="..#paths_i[#paths_i])
	       --for _,v in ipairs(paths_i[#paths_i]) do print("BEZ v="..v)end
	       if removable == true then 
		  --print("BEZ paths_i="..#paths_i,"is removable")
		  --for i=1,#paths_i[#paths_i] do print("BEZ i="..i,"v="..tonumber(paths_i[#paths_i][i])) end
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
      --print("BEZ find a removable")
      local rm = {}
      for k,v in pairs(temp_removed) do
	 if v == true then 
	    --print("BEZ removed k="..k, tostring(v))
	    rm[#rm+1] = tostring(k)
	 end
      end
      --print("BEZ #rm="..#rm,rm[1],rm[2])
      valid_curves,matrix_inters = _remove_path(valid_curves,matrix_inters,rm)
   end
   return valid_curves,matrix_inters
end


local function _remove_pending_path_I(valid_curves,matrix_inters)
   --
   -- pending paths
   --
   local temp_removed = {}
   local temp_valid_curves = {}
   print("BEZ _remove_pending_path_I")
   for i, bezier in pairs(valid_curves) do 
      local intersection  = matrix_inters[tostring(i)] or {}
      local inters1, inters2 ,t1,u1 ,t2,u2 
      if #intersection==2 then 
	 inters1, inters2 = intersection[1],intersection[2]
	 t1,u1 = inters1[2],inters1[3]
	 t2,u2 = inters2[2],inters2[3]
	 --print("BEZ tonumber(t1)="..tonumber(t1), "tonumber(t2)="..tonumber(t2),"tonumber(u1)="..tonumber(u1), "tonumber(u2)="..tonumber(u2))
      end
      --print("BEZ removed check intersections")
      --for _,v in ipairs( intersection) do print(string.format("BEZ all intersections of i=%s: j=%s ,t=%s, u=%s",i,v[1],v[2],v[3])) end 
      if (intersection==nil) or #intersection <=1 then 
	 temp_removed[tostring(i)]=true
	 --print("BEZ removed i="..i)
      elseif #intersection==2  and ((t1 =='0' and u1 == '1') and (t2 =='0' and u2 == '1')) or  ((t1 =='1' and u1 == '0') and (t2 =='1' and u2 == '0')) then -- not > 2 otherwise most of curves are deleted !
	 --print("BEZ remove path pending 2 i="..i)
	 temp_removed[tostring(i)]=true
      elseif #intersection==2  and ( ((tonumber(t1) >=0.9999) and  (tonumber(t2) >=0.9999)) or ((tonumber(u1) >=0.9999) and  (tonumber(u2) >=0.9999)) )  then -- 
	 --print("BEZ i="..i ,"is it to remove ?")
	 --print("BEZ (tonumber(t1) >=0.999)=",(tonumber(t1) >=0.999),(tonumber(t2) >=0.999),(tonumber(u1) >=0.999),(tonumber(u2) >=0.999))
	 -- we should really delete this 
	 --temp_removed[tostring(i)]=true
	 temp_valid_curves[i] = bezier 
      elseif #intersection > 1 then  --  not > 2 otherwise most of curves are deleted !
	 local check_init_0 = 0
	 local check_init_1 = 0
	 local nr_intersection = #intersection
	 for iv,v in ipairs( intersection) do
	    local t,u = v[2],v[3]
	    --print("BEZ i="..i,"iv="..iv,"v[1]="..v[1], "is removed=",temp_removed[tostring(v[1])])
	    if t=='0' or u == '1'  then check_init_0 = check_init_0 +1 end
	    if t=='1' or u=='0'    then check_init_1 = check_init_1 +1 end
	    if temp_removed[tostring(v[1])] == true then nr_intersection=nr_intersection-1 end
	 end
	 --print("BEZ ",i,check_init_0,check_init_1,check_init_0+check_init_1,#intersection)
	 -- can be t=0 and u=0
	 if nr_intersection > 2 and (check_init_0==#intersection or  check_init_1==#intersection)   then 
            -- ??? 
	    temp_removed[tostring(i)]=true
	    --print("BEZ removed pending path i="..i)
	 else
	    temp_valid_curves[i] = bezier 
	 end
      end
   end

   --for k,v in pairs(temp_removed) do print("BEZ k="..k, removed) end

   -- remove references to pending paths
   for i, bezier in pairs(temp_valid_curves) do
      local intersection  = matrix_inters[tostring(i)] or {}
      local temp_intersection = {}
      for _,v in ipairs( intersection) do 
	 local j  = tostring(v[1])
	 if not(temp_removed[j]==true) then 
	    temp_intersection[#temp_intersection +1] = v
	 else
	    print("BEZ for path i="..i .. ' removed pending path j='..v[1])
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
      --print("BEZ cnt_1="..cnt_1,"cnt="..cnt,"cnt_0="..cnt_0)
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
	 --print("BEZ i=" ..i)
	 local res,_,_ = _try_to_remove(i,valid_curves,matrix_inters)
	 --print("BEZ res=",res)
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
   	 --print("BEZ k="..k.." cutted")
      end
   end
   --printBEZ pen loops II end")
   return valid_curves,matrix_inters
end






local function _remove_overlaps(valid_curves,matrix_inters,valid_curves_p_set)
   --
   -- remove curve  overlaps 
   --
   print("BEZ remove curve overlaps ")
   local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v end
   local set_i = {}
   local dropped = {}
   local dropped_table = {}
   --
   -- redundant curve
   --
   for i, bezier in pairs(temp_valid_curves) do
      local intersection  = matrix_inters[tostring(i)] or {}
      set_i = {}
      if not(intersection[3]==nil) and (intersection[4]==nil)  and not(dropped[tostring(i)]==true) then 
	 local is 
	 local i0,i1,i2,i3 = tostring(i),intersection[1][1],intersection[2][1],intersection[3][1]
	 set_i[i0]={}; for _,v in ipairs(matrix_inters[i0]) do set_i[i0][tostring(v[1])]=true end
	 set_i[i1]={}; for _,v in ipairs(matrix_inters[i1]) do set_i[i1][tostring(v[1])]=true end
	 set_i[i2]={}; for _,v in ipairs(matrix_inters[i2]) do set_i[i2][tostring(v[1])]=true end
	 set_i[i3]={}; for _,v in ipairs(matrix_inters[i3]) do set_i[i3][tostring(v[1])]=true end
	 set_i[i0][i0],set_i[i1][i1],set_i[i2][i2],set_i[i3][i3] = true,true,true,true

	 if _is_included(set_i[i1],set_i[i0]) then 
	    print("BEZ dropped i1="..i1)
	    dropped[i1]=true
	 elseif _is_included(set_i[i2],set_i[i0]) then 
	    print("BEZ dropped i2="..i2)
	    dropped[i2]=true
	 elseif _is_included(set_i[i3],set_i[i0]) then 
	    print("BEZ dropped i3="..i3)
	    dropped[i3]=true
	 end
      end
   end
   for k,_ in pairs(dropped) do dropped_table[#dropped_table+1] = k end
   valid_curves,matrix_inters = _remove_path_and_clean_up(valid_curves,matrix_inters,dropped_table) 


   temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v end
   set_i = {}
   -- for each i with 3 or more intersections, we collect all the intersections of i
   for i, bezier in pairs(temp_valid_curves) do
      local intersection  = matrix_inters[tostring(i)] or {}
      if not(intersection==nil) and not(intersection[2]==nil) and not(intersection[3]==nil) then 
	 --print("BEZ store i="..i)
	 set_i[i] = {}
	 local cnt = 0
	 for _,m1 in pairs(intersection) do
	    local j1 = m1[1]
	    table.insert(set_i[i],tostring(j1),true)
	    cnt = cnt +1
	 end
	 table.insert(set_i[i],tostring(i),true)
	 cnt = cnt +1
	 set_i[i]['length'] = cnt
	 --table.foreach(set_i[i],function(...) print("BEZ set_i,i="..i,...) end )
      end
   end
   dropped_table = {}
   dropped = {}
   -- we try to delete all but one i1 with the same set of intersections
   for i1,inters1 in pairs(set_i) do dropped[i1] = false end 
   for i1,inters1 in pairs(set_i) do
      --for k,v in pairs(inters1) do print("BEZ i1="..i1, "k="..k,v) end
      dropped_table[i1] = {}
      --print("BEZ ----------")
      --print("BEZ i1="..i1,"dropped[i1]=",dropped[i1])
      if not(dropped[i1]) then
	 for i2,inters2 in pairs(set_i) do
	    print("BEZ i2="..i2)
	    if i1 ~= i2 and  not(dropped[i2]) and (inters1['length'] >=inters2['length']) then 
	       local check = true
	       --print("BEZ ------ i1="..i1,"i2="..i2)
	       --print("BEZ inters1['length']="..inters1['length'],"inters2['length']="..inters2['length'])
	       for k,_ in pairs(inters2) do
		  --print("BEZ k="..k, "inters1[k]=",inters1[k])
		  if (k ~= 'length') and not(inters1[k]==true) then check = false; break end
	       end
	       print("BEZ check=",check)
	       -- the two sets i1 and i2 are equal
	       if check == true then 
		  dropped[i2] = true
		  --dropped[i1] = true
		  print("BEZ dropped_table["..i1.."]="..i2)
		  table.insert(dropped_table[i1],i2) 
	       end 
	    end
	 end
      end
   end
   local dropped = {}
   for k,v in pairs(dropped_table) do
      if k~=nil then print("BEZ dropped_table="..k); table.foreach(v,function(...) print("BEZ ",...) end) end
      for k1,v1 in pairs(v) do 
	 --print("BEZ v1="..v1.." dropped",type(v1))
	 dropped[tostring(v1)] = true 
      end 
   end
   temp_valid_curves = {}
   for k,v in pairs(valid_curves) do 
      --print("BEZ k="..k, "dropped[tostring(k)]=",dropped[tostring(k)])
      if dropped[tostring(k)]==false or  dropped[tostring(k)]==nil then
   	 local intersection  = matrix_inters[tostring(k)] or {}
   	 local temp = {}
   	 temp_valid_curves[k] = v 
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
   --_print_curve_intersections('2',temp_valid_curves,matrix_inters)
 
   local valid_curves = {}
   for i, bezier in pairs(temp_valid_curves) do
      --print("BEZ --------------------------")
      --print("BEZ i="..i)
      local intersection  = matrix_inters[tostring(i)] or {}
      --for _,v in ipairs( intersection) do print(string.format("BEZ all intersections of i=%s: j=%s ,t=%s, u=%s",i,v[1],v[2],v[3])) end 
      if not(intersection==nil) and not(intersection[2]==nil) and (intersection[3]==nil) then 
	 local cnt = 0
	 local m1 = intersection[1]
	 local j1,t1,u1 = m1[1],m1[2],m1[3]
	 --print(string.format("BEZ i=%s,j1=%s,t1=%s,u1=%s",i,j1,t1,u1))
	 local m2 = intersection[2] 
	 local j2,t2,u2 = m2[1],m2[2],m2[3]
	 --print(string.format("BEZ i=%s,j2=%s,t2=%s,u2=%s",i,j2,t2,u2))
	 --if (u1 == '1') then t1 = '0' end
	 --if (u2 == '0') then t2 = '1' end
	 local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
	 local w
	 if (t2+0<t1+0) then 
	    local t; t=t2 t2=t1 t1=t 
	    local u; u=u2 u2=u1 u1=u 
	    local j; j=j2 j2=j1 j1=j 
	 end 
	 --print("BEZ t1="..t1,"t2="..t2,"u1="..u1,"u2="..u2)
	 w=string.gmatch(p,"[-0-9.]+"); p={w(),w()}
	 w=string.gmatch(c1,"[-0-9.]+"); c1={w(),w()}
	 w=string.gmatch(c2,"[-0-9.]+"); c2={w(),w()}
	 w=string.gmatch(q,"[-0-9.]+"); q={w(),w()}
	 --w=string.gmatch(shifted,"[-0-9.]+"); s={w(),w()}
	 --print("BEZ i="..i,"p="..string.format("(%s,%s)",p[1],p[2]),"q="..string.format("(%s,%s)",q[1],q[2]) )
	 _1,_2,_3,_4,_5,_6,_7,_8,_9 =  bez(p,c1,c2,q,t1)
	 local res_p,res_c1 =  _6,_7
	 _1,_2,_3,_4,_5,_6,_7,_8,_9 =  bez(p,c1,c2,q,t2)
	 local res_c2,res_q = _5,_6
	 p,c1,c2,q =res_p,res_c1,res_c2,res_q
	 p = string.format("(%s,%s)",p[1],p[2]) 
	 c1 = string.format("(%s,%s)",c1[1],c1[2])
	 c2 = string.format("(%s,%s)",c2[1],c2[2])
	 q = string.format("(%s,%s)",q[1],q[2])
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
	--print("BEZ SMALL i="..i, "p="..p[1].." "..p[2],"q="..q[1].." "..q[2],"d="..d)
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
   local threshold = mflua.threshold or 1
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
	 --print("BEZ k="..k.." cutted")
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
      --printBEZ -------------------------------------------")
      --printBEZ begin loop, -------------------------------")
      --printBEZ modified=",modified,"reverse=",reverse)
      --printBEZ next_path="..next_path)

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
      --print("BEZ i="..i,done[i])

      if not(intersections[1]==nil) and not(intersections[2]==nil) and (intersections[3]==nil) and done[i] == false  then 
	 local j1,t1,u1 = intersections[1][1], intersections[1][2], intersections[1][3]
	 local j2,t2,u2 = intersections[2][1], intersections[2][2], intersections[2][3]
	 local intersection_1,intersection_2 = intersections[1],intersections[2]
	 local temp_j,temp_t,temp_u
	 -- establish the correct order
	 --print("BEZ ----------------")
	 --print("BEZ i="..i,done[i])
	 if t1 > t2 then 
	    print("BEZ t1>t2")
	    temp_j,temp_t,temp_u = j1,t1,u1
	    j1,t1,u1 = j2,t2,u2
	    j2,t2,u2 = temp_j,temp_t,temp_u
	    intersection_1,intersection_2 = intersections[2], intersections[1]
	 end
	 --print("BEZ i="..i,"j1="..j1,"t1="..t1,"u1="..u1)
	 --print("BEZ i="..i,"j2="..j2,"t2="..t2,"u2="..u2)
	 --_print_curve_intersections('3a',valid_curves,matrix_inters,i)      
	 if math.abs(t1-u1)<0.1 and done[i] == false and reverse == false then --and math.abs(t2-u2)<0.1 then 
	   modified = true
	    done[0+j1] = true 
	    --print("BEZ  i="..i,"math.abs(t1-u1)<0.1")
	    --print(string.format("BEZ  i=%s,p=%s,c1=%s,c2=%s,q=%s, shifted=%s",i,p,c1,c2,q,tostring(shifted)))
	    --print("BEZ store for i {j1,t1,tostring(1-u1)}=",j1,t1,tostring(1-u1))
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
	    --print("BEZ j1="..j1, "jj1="..jj1,"jj2="..jj2,"i="..i,tonumber(jj1)==i)
	    --_print_curve_intersections('(pre) t1-u1<0.1',valid_curves,matrix_inters,j1)      
	    if tonumber(jj1) == i then 
	       --print("BEZ 1-tt1",1-tt2)
	       intersections[1][1], intersections[1][2], intersections[1][3] = jj1,tostring(1-tt1),tostring(uu1)
	       intersections[2][2], intersections[2][3] = tostring(1-tt2),tostring(1-uu2)
	       reverse = true 
	       next_path = jj2
	       prev_path =j1
	    elseif tonumber(jj2) == i then 
	       --print("BEZ 1-tt2",1-tt2)
	       intersections[2][1], intersections[2][2], intersections[2][3] = jj2,tostring(1-tt2),uu2
	       intersections[2][2], intersections[2][3] = tostring(1-tt1),tostring(1-uu1)
	       reverse = true 
	       next_path = jj1
	       prev_path =j1
	    end
	    --_print_curve_intersections('t1-u1<0.1',valid_curves,matrix_inters,j1)      
	    done[i]=true
	 elseif math.abs(t2-u2)<0.1 and done[i] == false and reverse == false then 
	    modified = true
	    done[0+j2] = true 
	    --print("BEZ  i="..i,"math.abs(t2-u2)<0.1")
	    print(string.format("BEZ  i=%s,p=%s,c1=%s,c2=%s,q=%s, shifted=%s",i,p,c1,c2,q,tostring(shifted)))
	    intersections_2={j2,t2,tostring(1-u2)}
	    --print("BEZ intersections_2=",j2,t2,tostring(1-u2))
	    --print("BEZ store for i {j2,t2,tostring(1-u2)} = ",j2,t2,tostring(1-u2))
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
	    --print("BEZ jj1="..jj1,"jj2="..jj2,"i="..i,tonumber(jj1)==i)
	    --_print_curve_intersections('(pre)t2-u2<0.1',valid_curves,matrix_inters,j2)      
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
	    --_print_curve_intersections('t2-u2<0.1',valid_curves,matrix_inters,j2)      
	    done[i]=true
	 elseif reverse == true and done[i]==false then 
	    -- check if we must reverse this path
	    --print("BEZ **reverse i="..i,"prev_path="..prev_path,type(prev_path))
	    --_print_curve_intersections('(pre) reverse',valid_curves,matrix_inters,i)      
	    --valid_curves[0+i] = {q,c2,c1,p,shifted}

	    local jj1,tt1,uu1 = intersections[1][1], intersections[1][2], intersections[1][3]
	    local jj2,tt2,uu2 = intersections[2][1], intersections[2][2], intersections[2][3]
	    --print("BEZ jj1,tt1,uu1=",jj1,tt1,uu1,jj1==prev_path,type(jj1))
	    --print("BEZ jj2,tt2,uu2=",jj2,tt2,uu2,jj2==prev_path,type(jj2))

	    if jj1 == tostring(prev_path) then 
	       --print("BEZ jj1==prev_path,jj1="..jj1)
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
	       --print("BEZ jj2==prev_path,jj2="..jj2)
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
	    --print("BEZ reverse=", reverse,"next_path=",next_path)
	    --_print_curve_intersections('should be',valid_curves,matrix_inters,i)      
	 end
	 done[i]=true
	 --print("BEZ i="..i,done[i])
      end --if not(intersections[1]==nil) and not(intersections[2]==nil) and (intersections[3]==nil)   then 
      --end --for i,bezier in pairs(temp_valid_curves) do
      --print("BEZ modified=",modified,"reverse=",reverse,"next_path="..next_path)
      --print("BEZ done[next_path]=",done[0+next_path])
      if done[0+next_path]==true  and reverse == true then reverse = false end
      --print("BEZ end loop, -------------------------------")
      --print("BEZ ")

      
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
      --printBEZ (1) i="..i,"type(i)="..type(i),"p="..p,"q="..q)
      local w=string.gmatch(p,"[-0-9.]+"); p={w(),w()}
      w=string.gmatch(q,"[-0-9.]+"); q={w(),w()}
      --print("BEZ i="..i, intersections[1], intersections[2], intersections[3])
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
	--print("BEZ i="..i,"marked_curve[i]['p']=",marked_curve[i]['p'])
	--print("BEZ i="..i,"marked_curve[i]['q']=",marked_curve[i]['q'])
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
   local extra = 2*mflua.threshold_extra_step or 4
   local values = math.ldexp(1,mflua.bit)+1
   for i, bezier in pairs(temp_valid_curves) do
      --print("BEZ i="..i)
      local p,c1,c2,q,offset,coll_ind = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5],bezier[6]
      --print("BEZ p,c1,c2,q,offset=",p,c1,c2,q,offset)
      --for j,v in ipairs(coll_ind) do print("BEZ coll_ind i="..i,"j="..j,"v="..v) end
      -- adjust pixels boundaries  for horizontal/vertical lines
      local _p,_c1,_c2,_q =  _coord_str_to_table(p,c1,c2,q)
      local check = false 
      --table.foreach(coll_ind,function(k,v) print("BEZ coll_ind k="..k,"v="..v) end )
      -- horizontal line
      if #coll_ind > 0 and (_p[2] == _c1[2]) and (_p[2] == _q[2] )  and (_q[2] == _c2[2]) and math.abs(_p[1]-_q[1]) <mflua.threshold_small_path_check_point then 
	 check = true 
	 -- vertical line
      elseif #coll_ind > 0 and (_p[1] == _c1[1]) and (_p[1] == _q[1] )  and (_q[1] == _c2[1]) and math.abs(_p[2]-_q[2]) <mflua.threshold_small_path_check_point then 
	 check = true 			   
      end
      --if check == true then   print("BEZ i="..i,"adjust pixels boundaries  for horizontal/vertical lines") end

      coll_ind_inf = {}
      if check==true and (coll_ind[1] < values/mflua.threshold_small_path_check_point) then 
	 -- print("BEZ i="..i,"coll_ind_inf")
	 local l = coll_ind[1]
	 for k=1,l do coll_ind_inf[k] = k end 
      end
      coll_ind_sup = {}
      if check==true and (coll_ind[#coll_ind] > values - values/mflua.threshold_small_path_check_point) then 
	 -- print("BEZ i="..i,"coll_ind_sup")
	 local l = coll_ind[#coll_ind]
	 -- print("BEZ i="..i,"l="..l)
	 -- for k=l,values do coll_ind_sup[k] = k print("BEZ i="..i,"k="..k,coll_ind_sup[k]) end 
      end
      --print("BEZ #coll_ind_sup="..#coll_ind_sup)
      if check==true then -- and (#coll_ind_inf > 0 or #coll_ind_sup > 0) then 
	 -- print("BEZ merge")
	 local coll_ind_temp = {}
	 for i,v in pairs(coll_ind_inf) do coll_ind_temp[i] = v end
	 for i,v in pairs(coll_ind) do coll_ind_temp[#coll_ind_temp+1] = v end
	 -- print("BEZ #coll_ind_sup="..#coll_ind_sup)
	 --for i,v in pairs(coll_ind_sup) do coll_ind_temp[#coll_ind_temp+1] = v print("BEZ v="..v) end
	 coll_ind = coll_ind_temp
	 --for ii,v in pairs(coll_ind) do print("BEZ i="..i,"ii="..ii,"coll_ind[ii]="..v) end 
      end
      if check==false and #coll_ind>0 then 
	 --print("BEZ i="..i,"adjust pixels boundaries  for general lines") 
	 --print("BEZ i="..i,"coll_ind[1]="..coll_ind[1]) 
	 --for ii,v in pairs(coll_ind) do print("BEZ i="..i,"ii="..ii,"coll_ind[ii]="..v) end 
	 -- we assume a single interval , but it's not true !!
	 coll_ind_inf = {}
	 if coll_ind[1] > 1  then 
	    local start =1
	    if coll_ind[1] - extra >0 then start = coll_ind[1] - extra end
	    for v=start,coll_ind[1]-1 do coll_ind_inf[#coll_ind_inf+1] = v  end
	    --for i,v in ipairs(coll_ind) do coll_ind_temp[#coll_ind_temp+1] = v end
	 else
	    local min = 1
	    local min_i = 1
	    local max,max_i = values,values 
	    local temp_coll_ind ={}
	    for ii,v in pairs(coll_ind) do 
	       --print("BEZ i="..i, ii,v)
	       if not(tonumber(ii) == tonumber(v)) then min_i, min = ii, v break end
	       temp_coll_ind[ii] = v
	    end
	    --print("BEZ i="..i,"min="..min_i,min) 
	    if min>extra and min_i < #coll_ind then 
	       for j=min-2,min do 
		  temp_coll_ind[#temp_coll_ind+1] = j
	       end
	       --for ii,v in pairs(temp_coll_ind) do print("BEZ A i="..i,"ii="..ii,"temp_coll_ind[ii]="..v) end 
	       for j=min_i+1, #coll_ind do
		  temp_coll_ind[#temp_coll_ind+1] = coll_ind[j]
	       end
	       --for ii,v in pairs(temp_coll_ind) do print("BEZ B i="..i,"ii="..ii,"temp_coll_ind[ii]="..v) end 
	       for ii,v in pairs(temp_coll_ind) do coll_ind[ii] = v end 
	    end
	    for j=#coll_ind,1,-1  do
	       --print("BEZ i="..i,j,coll_ind[j],values-coll_ind[j])
	       if coll_ind[j] == j then max_i,max= j,coll_ind[j] break end
	    end
	    --print("BEZ i="..i,"max_i,max=",max_i,max,#coll_ind)
	    if max_i < values and not(coll_ind[max_i+1] == nil) then 
	       --print("BEZ i="..i,"max_i,max=", max_i,max,coll_ind[max_i+1]-max)
	       --if coll_ind[max_i+1]-max < extra then 
		  --for k=1,coll_ind[max_i+1]-max-1 do
		     --temp_coll_ind[max_i+k] = max + k
		  --end
	          -- not really a solution....
	          temp_coll_ind[max_i+1] = max + 1
		  --for k=max_i+1,#coll_ind do 
		     --temp_coll_ind[#temp_coll_ind+1] = coll_ind[k]
		  --end
		  --else
		  --
	       --end
	       --for ii,v in pairs(temp_coll_ind) do print("BEZ C i="..i,"ii="..ii,"temp_coll_ind[ii]="..v) end 
	       for ii,v in pairs(temp_coll_ind) do coll_ind[ii] = v end 
	    end

	 end
	 coll_ind_sup = {}
	 --print("BEZ coll_ind[#coll_ind]="..coll_ind[#coll_ind],"values="..values)
	 if coll_ind[#coll_ind] < values  then 
	    -- print("BEZ coll_ind[#coll_ind] < values")
	    local _end = values 
	    if coll_ind[#coll_ind] + extra <values then _end = coll_ind[#coll_ind] + extra end
	    for v=coll_ind[#coll_ind]+1,_end  do coll_ind_sup[#coll_ind_sup+1] = v  end
	 elseif #coll_ind>extra and coll_ind[#coll_ind] == values  and (coll_ind[#coll_ind-extra]< values-extra) then
	 -- we should extend this also to coll_ind_inf and envelopes   
	    --print("BEZ coll_ind[#coll_ind] == values")
	    for v=values-extra,values do coll_ind_sup[#coll_ind_sup+1] = v  end
	    local temp_delete = {}
	    for i,v in ipairs(coll_ind_sup) do 
	       for ii, vv in pairs(coll_ind) do 
		  --print("BEZ vv="..vv, 'v='..v)
		  if vv == v then 
		     --print("BEZ vv="..vv, 'v='..v,'i='..i)
		     temp_delete[#temp_delete+1]= ii 
		  end 
	       end 
	    end
	    for i, v in ipairs(temp_delete) do coll_ind[v] = nil end
	    --table.foreach(coll_ind_sup,function(k,v) print("BEZ coll_ind_sup k="..k,"v="..v) end )
	 end
	 if #coll_ind_inf > 0 or #coll_ind_sup > 0 then 
	    local coll_ind_temp = {}
	    for i,v in ipairs(coll_ind_inf) do coll_ind_temp[i] = v end
	    for i,v in ipairs(coll_ind) do coll_ind_temp[#coll_ind_temp+1] = v end
	    for i,v in ipairs(coll_ind_sup) do coll_ind_temp[#coll_ind_temp+1] = v end
	    coll_ind = coll_ind_temp
	 end
	 --table.foreach(coll_ind,function(k,v) print("BEZ coll_ind k="..k,"v="..v) end )

	 -- --coll_ind = coll_ind_temp
	 --for j,v in ipairs(coll_ind) do print("BEZ coll_ind i="..i,"j="..j,"v="..v) end
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
      --table.foreach(coll_ind,function(k,v) print("BEZ coll_ind k="..k,"v="..v) end )
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
   local extra = 3*mflua.threshold_extra_step or 6 
   local values = math.ldexp(1,mflua.bit)+1
   for i, bezier in pairs(temp_valid_curves) do
      --printBEZ ----- i="..i)
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
      --if check == true then       print("BEZ adjust pixels boundaries  for horizontal/vertical lines") end

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
	    --print("BEZ i="..i,"found j1="..j1)
	    --print("BEZ t1="..t1,"u1="..u1)
	    local bez1 = temp_valid_curves[j1]
	    local p_1,c1_1,c2_1,q_1,shifted_1= bez1[1],bez1[2],bez1[3],bez1[4],bez1[5]
	    local bez2 = temp_valid_curves[j2]
	    local p_2,c1_2,c2_2,q_2,shifted_2= bez2[1],bez2[2],bez2[3],bez2[4],bez2[5]
	    
	    local px,py,c1x,c1y,c2x,c2y,qx,qy
	    local values={0};for i=1,L-1 do values[i+1]= math.ldexp(i,-bit) end; values[#values+1]=1
	    local min = {mflua.threshold_bug,t}
	    --print("BEZ p="..p,"q="..q)
	    --print("BEZ p_2="..p_2, "q_2="..q_2)
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
	    --print("min |p-(x,y)| = "..min[1],min[2])
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
	    --print("BEZ i="..i,"found j2="..j2)
	    --print("BEZ t2="..t2,"u2="..u2)
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
	 --print("BEZ k="..k.." cutted")
      end
   end
   for k,v in pairs(temp_temp_valid_curves) do 
      --print("BEZ k="..k,matrix_inters[tostring(k)][1][1],matrix_inters[tostring(k)][2])
      valid_curves[k] = v 
   end
   return valid_curves,matrix_inters
end


local function _find_longest_curve(char)
   --
   --
   --
   print("BEZ _find_longest_curve")
   local beziers = char['contour'] or  {}
   local offset = '(0,0)'
   local len = {}
   local coord_x = {}
   local coord_y= {}
   for i1, bezier in ipairs(beziers) do
      for i, contour in ipairs(bezier) do
	 local path_list = contour['path_list']
	 for j=1 ,#path_list do
	    local path = path_list[j]
	    local p,c1,c2,q = path['p'],path['control1'],path['control2'],path['q']
	    if not(q==nil) and not(p==nil) and not(c1==nil) and not(c2==nil) then 
	       local pn,c1n,c2n,qn = _coord_str_to_table_num(p,c1,c2,q,offset)
	       if  _is_a_straight_segment(pn,c1n,c2n,qn) >= 0 then 
		  len[#len+1] =  mflua.modul_vec(pn,qn)
	       else 
		  len[#len+1] =  mflua.approx_curve_lenght(pn,c1n,c2n,qn)
	       end
	       coord_x[#coord_x+1]=pn[1]
	       coord_x[#coord_x+1]=c1n[1]
	       coord_x[#coord_x+1]=c2n[1]
	       coord_x[#coord_x+1]=qn[1]
	       coord_y[#coord_y+1]=pn[2]
	       coord_y[#coord_y+1]=c1n[2]
	       coord_y[#coord_y+1]=c2n[2]
	       coord_y[#coord_y+1]=qn[2]
	    end
	 end
      end
   end
   for m=1, ((char['envelope'] and #char['envelope']) or 0)  do 
      local bezier_octant = char['envelope'][m]
      local first_point= ''
      local knots_list = char['knots'] or {} 
      local last_point = ''
      local knots = knots_list[m]
      for i=1, #bezier_octant do
	 local beziers = bezier_octant[i]
	 local pen = beziers['pen']
	 local offsets = beziers['offsets']
	 local path_list = beziers['path_list'] or {}
	 local offset_list = beziers['offset_list']
	 local shifted='(0,0)'
	 for j=1,#path_list do
	    path=path_list[j]
	    local p,c1,c2,q,offset = path['p'],path['control1'],path['control2'],path['q'],path['offset']  	 
	    if not(q==nil) and not(p==nil) and not(c1==nil) and not(c2==nil) then 
	       shifted='(0,0)'
	       for i,v in ipairs(offset_list) do 
		  if v[1] == (0+offset) then 
		     shifted = v[2] 
		     break 
		  end 
	       end 
	       local pn,c1n,c2n,qn,shifted = _coord_str_to_table_num(p,c1,c2,q,shifted)
	       if  _is_a_straight_segment(pn,c1n,c2n,qn) >=0 then 
		  len[#len+1] =  mflua.modul_vec(pn,qn)
	       else 
		  len[#len+1] =  mflua.approx_curve_lenght(pn,c1n,c2n,qn)
	       end
	       coord_x[#coord_x+1]=pn[1]+shifted[1]
	       coord_x[#coord_x+1]=c1n[1]+shifted[1]
	       coord_x[#coord_x+1]=c2n[1]+shifted[1]
	       coord_x[#coord_x+1]=qn[1]+shifted[1]
	       coord_y[#coord_y+1]=pn[2]+shifted[2]
	       coord_y[#coord_y+1]=c1n[2]+shifted[2]
	       coord_y[#coord_y+1]=c2n[2]+shifted[2]
	       coord_y[#coord_y+1]=qn[2]+shifted[2]
	    end
	 end
      end
   end
   table.sort(len)
   table.sort(coord_x)
   table.sort(coord_y)
   return len[1],len[#len],coord_x[1],coord_y[1],coord_x[#coord_x],coord_y[#coord_y]
end






local function _clean_up_contour(char)
   --
   --
   --
   print("BEZ _clean_up_contour")
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
	       --print("BEZ check point for ",p,c1,c2,q,offset)
	       local nr_ok,values,coll_ind =  _check_point(char,p,c1,c2,q,offset)
	       --print("BEZ i1="..i1,"i="..i, p,c1,c2,q,offset)
	       --for jj,v in ipairs(coll_ind) do print("BEZ jj="..jj,"v="..v) end
	       if (nr_ok-values) == 0 then 
		  --res = res .. "drawoptions(withcolor yellow withpen pencircle scaled 0.04pt);\n"
		  --res = res  .. string.format("draw %s -- %s -- %s --%s -- cycle;\n",p,c1,c2,q)
		  --f:write(res)
		  res = ''
		  -- -- a patch !!!
		  -- valid_curves[#valid_curves+1] ={p,c1,c2,q,offset,{1}}
		  -- -- why not this ?
		  -- --valid_curves[#valid_curves+1] ={p,c1,c2,q,offset,{values-2,values-1,values}}
	       elseif values>0 and (nr_ok/values)*100> 100 then 	  
		  -- pass
		  -- res = res  .. string.format("draw %s -- %s -- %s --%s -- cycle withcolor (1,0,1) ;\n",p,c1,c2,q)
		  --f:write(res)
		  res = ''
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
   local pen_over_knots = {}

   local valid_curves = {}
   local valid_curves_pen = {}
   bezier_octant = char['envelope'] or  {}
   char['envelope'] = bezier_octant
   --printBEZ ENV.",#char['envelope'])
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
	       res = res .. "drawoptions(withcolor yellow withpen pencircle scaled 0.2pt);\n"
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
	       nr_ok,values,coll_ind =  _check_point(char,p,c1,c2,q,shifted,tostring(i)..tostring(j))
	       if (nr_ok-values) == 0 then 
		  -- res = res .. "drawoptions(withcolor red withpen pencircle scaled 0.4pt);\n"
		  -- res = res  .. string.format("path p; p:= %s .. controls  %s and %s .. %s; draw p  shifted %s ;\n",p,c1,c2,q,shifted)
		  --res = res ..  string.format("label(\"P,e=%s,o=%s,p=%s\",(%s+%s)) ;\n",m,i,j,p,shifted) 
		  --res = res ..  string.format("label(\"Q,e=%s,o=%s,p=%s\",(%s+%s)) ;\n",m,i,j,q,shifted) 
		  -- f:write(res)
		  res = ''
	       --elseif values>0 and (nr_ok/values)*100 > 99 then 
		  -- pass 
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
	 --for i = 1,1+math.ldexp(1,mflua.bit) do coll_ind_pen[i] = i end
	 --knots_set = {} 
	 --for k=1,#knots do -- should be this but it's too much slow. and broke s of ccr5  By the way, it must be set for sym.mf .
         -- a solution is to use #knots when #knots is small
	 for idx,k in ipairs({1,math.floor(#knots/2),1+math.floor(#knots/2),#knots}) do
         -- for _,k in ipairs({1,math.floor(#knots/2)}) do
	    local key =''
	    knot = knots[k]
	    p,c1,c2,q,s = knot[1],knot[2],knot[3],knot[4],knot[5]
	    -- try to avoid useless check
	    key = p ..c1 ..c2 ..q .. table.concat(pen)
	    --print("BEZ key="..key,"knots_set[key]="..tostring(knots_set[key]))
	    if knots_set[key]~=nil  then break else  knots_set[key]=true end
	    --print("BEZ k="..k,"p,c1,c2,q,s =",p,c1,c2,q,s)
	    pen_over_knots[#pen_over_knots+1] = {p,q,pen}
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
		  f:write(string.format("%%%%%%%% check pen for p=%s\n",p))
		  res = "drawoptions(withcolor (0,0.5123,0) withpen pencircle scaled 0.1pt);\n"
		  res = res  .. string.format("path p; p:= %s .. controls  %s and %s .. %s; draw p  shifted %s ;\n",pen[l],pen_c1,pen_c1,pen[l+1],p)
		  f:write(res)
		  res = ''
		  nr_ok,values,coll_ind_pen =  _check_pen_point(char,pen[l],pen_c1,pen_c1,pen[l+1],p)
		  f:write("%%%%%%% check pen nr_ok="..nr_ok," values="..values,"\n")
		  -- fix for Q of ccr10
		  if (nr_ok-values)<(math.ceil(values/2)) and (_eval_diff_tonumber(pen[l],pen[l+1])<4) 
	             and (_curve_is_horizontal(pen[l],pen_c1,pen_c1,pen[l+1]) or _curve_is_vertical(pen[l],pen_c1,pen_c1,pen[l+1])) then
		     --print("BEZ fix pen idx="..idx, "l="..l)
		     for jj = 1 ,65 do coll_ind_pen[jj] = jj end 
		  end
		  if (nr_ok-values) ~= 0 then 
		  --if values> 0 and (nr_ok/values)*100 <99 then 
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
	       if _eval_diff_tonumber(p,q)<0.01 then nr_ok=1;nr_ok_1 =1 end
	       if nr_ok==1 and nr_ok_1==1 then 
		  --
	       else
		  f:write(string.format("%%%%%%%% check pen for q=%s\n",q))
		  res = "drawoptions(withcolor green withpen pencircle scaled 0.1pt);\n"
		  res = res  .. string.format("path p; p:= %s .. controls  %s and %s .. %s; draw p  shifted %s ;\n",pen[l],pen_c1,pen_c1,pen[l+1],q)
		  f:write(res)
		  res = ''
		  nr_ok,values,coll_ind_pen =  _check_pen_point(char,pen[l],pen_c1,pen_c1,pen[l+1],q)
		  f:write("%%%%%%% check pen nr_ok="..nr_ok," values="..values,"\n")
		  --if values> 0 and (nr_ok/values)*100 <99 then 
		  if (nr_ok-values) ~= 0 then 
		     valid_curves_pen[#valid_curves_pen+1] ={pen[l],pen_c1,pen_c1,pen[l+1],q,coll_ind_pen}
		     --print("BEZ 5) #valid_curves="..#valid_curves_pen)
		  end
	       end
	    end
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
   return valid_curves,valid_curves_pen,pen_over_knots
end

local function reverse_cycle(temp_valid_curves,cycles,i)
   --
   -- A function to reverse the i cycle to match the correct turning number
   -- 
   local cycle = cycles[i]
   local rev_cycle = {}
   for index,j in ipairs(cycle) do 
      local curve = temp_valid_curves[j]
      local p,c1,c2,q,shifted=curve[1],curve[2],curve[3],curve[4],curve[5]
      curve[1],curve[2],curve[3],curve[4],curve[5] = q,c2,c1,p,shifted 
      rev_cycle[#cycle+1-index]=j
   end
   -- We must reverse also cycle.
   cycles[i] = rev_cycle
   return cycles
end

local function _build_cycles(valid_curves,matrix_inters,turning_number)
   -- 
   -- _build_cycles
   -- 
   print("BEZ _build_cycles")
   local max_i = -1
   local temp_valid_curves={}
   local eps = mflua.threshold_join_curves or 0.046 --unused 
   local min_eps = 1e9
   local cycles_raw = {}
   local cycles,_cycles,cycle_projections={},{},{}
   local cubics_done={}
   local bit=mflua.bit  or 6 
   local t_values={0}   
   local infty=mflua.plus_infty or 1e9
   local max_curves = mflua.max_curves or 1e4
   local _set_points = {}

   max_i=-1
   for k,_ in pairs(valid_curves) do
      if tonumber(k)>max_i then
	 max_i =tonumber(k)
      end
   end
   for i=1,max_i do
      temp_valid_curves[i]=false
      cubics_done[i]=false
   end
   for k,v in pairs(valid_curves) do
      temp_valid_curves[tonumber(k)]=v
   end

   --
   -- find the smallest distance between two differents p or q 
   --
   for i,curve in ipairs(temp_valid_curves) do
      if curve then 
	 --print("BEZ i="..i)
	 local p,c1,c2,q,shifted = curve[1],curve[2],curve[3],curve[4],curve[5]
	 local p_i  =  _eval_tonumber3f(p,shifted)
	 local q_i  =  _eval_tonumber3f(q,shifted) 
	 _set_points[#_set_points+1]={x=tonumber(string.format("%.3f",p_i[1])),
				      y=tonumber(string.format("%.3f",p_i[2])),type='p',index=i,done=false}
	 _set_points[#_set_points+1]={x=tonumber(string.format("%.3f",q_i[1])),
				   y=tonumber(string.format("%.3f",q_i[2])),type='q',index=i,done=false}
      end
   end
   for j,v in ipairs(_set_points) do
      if v.done==false then
	 for jj,vv in ipairs(_set_points) do
	    if vv.done==false and jj>j then
	       local d = math.sqrt( math.abs(v.x-vv.x)^2 + math.abs(v.y-vv.y)^2)
	       if 0<d and d<min_eps then
		  min_eps = d
	       end
	    end
	 end
      end -- if v.done==false then
   end
   --print("BEZ min_eps="..min_eps)
   --eps = min_eps+0.1*min_eps

   --
   -- We first sanitize the point of 
   -- so if we have (pi,ci1,ci2,qi)-(pj,cj1,cj2,qj) with ║qi-pj║₂<𝜀 
   -- then qi=pj=(qi+pj)/2
   -- (maybe we need a better approximation here) 
   -- We still have to build the cycles, btw.
   for i,curve in ipairs(temp_valid_curves) do
      --print("BEZ i="..i)
      if not(curve==false) then 
	 cycles_raw[i]={}
	 local pi,qi=curve[1],curve[4]
	 local w=string.gmatch(pi,"[-0-9.]+"); pi={tonumber(w()),tonumber(w())}
	 w=string.gmatch(qi,"[-0-9.]+"); qi={tonumber(w()),tonumber(w())}
	 for j,curve_j in pairs(temp_valid_curves) do
	    if curve_j  and j~=i then 
	       local pj,qj=curve_j[1],curve_j[4]
	       w=string.gmatch(pj,"[-0-9.]+"); pj={tonumber(w()),tonumber(w())}
	       w=string.gmatch(qj,"[-0-9.]+"); qj={tonumber(w()),tonumber(w())}
	       --print('BEZ', i,j,mflua.modul_vec(qi,pj)<eps,mflua.modul_vec(qi,qj)<eps)
	       --print('BEZ',i,j,eps,mflua.modul_vec(qi,pj),mflua.modul_vec(qi,qj))
	       --print('BEZ',i,j,mflua.modul_vec(pi,pj)<eps,mflua.modul_vec(pi,qj)<eps)
	       --print('BEZ',i,j,eps,mflua.modul_vec(pi,pj),mflua.modul_vec(pi,qj))

	       if 0<= mflua.modul_vec(qi,pj) and  mflua.modul_vec(qi,pj) <eps then 
		  local p_m = {(qi[1]+pj[1])/2,(qi[2]+pj[2])/2}
		  --print("BEZ q"..i,"p"..j)
		  curve[4] = '('..tostring(p_m[1])..','..tostring(p_m[2])..')'
		  curve_j[1] = '('..tostring(p_m[1])..','..tostring(p_m[2])..')'
		  table.insert(cycles_raw[i],j)
	       elseif 0<= mflua.modul_vec(qi,qj) and mflua.modul_vec(qi,qj)<eps then 
		  local p_m = {(qi[1]+qj[1])/2,(qi[2]+qj[2])/2}
		  --print("BEZ q"..i,"q"..j)
		  curve[4] = '('..tostring(p_m[1])..','..tostring(p_m[2])..')'
		  curve_j[4] = '('..tostring(p_m[1])..','..tostring(p_m[2])..')'
		  table.insert(cycles_raw[i],j)
	       elseif 0<= mflua.modul_vec(pi,qj) and mflua.modul_vec(pi,qj)<eps then 
		  local p_m = {(pi[1]+qj[1])/2,(pi[2]+qj[2])/2}
		  --print("BEZ p"..i,"q"..j)
		  curve[1] = '('..tostring(p_m[1])..','..tostring(p_m[2])..')'
		  curve_j[4] = '('..tostring(p_m[1])..','..tostring(p_m[2])..')'
		  table.insert(cycles_raw[i],j)
	       elseif 0<= mflua.modul_vec(pi,pj) and mflua.modul_vec(pi,pj)<eps then 
		  local p_m = {(pi[1]+pj[1])/2,(pi[2]+pj[2])/2}
		  --print("BEZ p"..i,"p"..j)
		  curve[1] = '('..tostring(p_m[1])..','..tostring(p_m[2])..')'
		  curve_j[1] = '('..tostring(p_m[1])..','..tostring(p_m[2])..')'
		  table.insert(cycles_raw[i],j)
	       end
	    end
	 end
      end
   end
   --print('BEZ 1--------------------------')
   --for i, v in pairs(cycles_raw) do table.foreach(v,function(_,_v) print(i,_v)end) end

    --
   -- Next we need to isolate the cycles
   -- Note that we end with the set of paths of the cycle,
   -- but still lack the correct order because some paths of a cycle can can have a wrong orientation
   for i,curve in ipairs(temp_valid_curves) do
      if curve~=false and cubics_done[i]==false and (#cycles_raw[i]==2) then
	  cubics_done[i]=true
	  cycles[i] = {i}
	  local flag=true
	  local left,right = cycles_raw[i][1],cycles_raw[i][2]
	  table.insert(cycles[i],left)
	  table.insert(cycles[i],right)
	  cubics_done[left]=true
	  cubics_done[right]=true
	  local j = left 
	  local idx = 0
    	  while flag==true do
	     -- print("BEZ cycles",cycles_raw[j][1])
	     idx=idx+1
	     if idx>=max_curves then flag=false ; print("too much curves ?"); return valid_curves,matrix_inters,cycles ; end
	     left,right = cycles_raw[j][1],cycles_raw[j][2]  
	     if cubics_done[left]==true and cubics_done[right]==true then flag=false ; break end
	     if cubics_done[left]==false then 
		table.insert(cycles[i],left);cubics_done[left]=true; 
		j = left 
	     elseif cubics_done[right]==false then 
		table.insert(cycles[i],right);cubics_done[right]=true; 
		j = right
	     end
	  end --while
       end
    end
    --print('BEZ --------------------------')
    --for i,c in pairs(cycles) do print('BEZ cycle='..i) table.foreach(c,print) end

    --
    -- Now  we need to ensure that each curve of a cycle
    -- has the same orientation, so we have a proper cycle; 
    -- we will fix the orientation of the entire cycle next time
    -- We end with a table of cycles, where cycles[j]=k is the j-th cycle
    -- and k is a path of the cycle (is a representant)
    for i,cycle in pairs(cycles) do 
      --print('BEZ cycle='..i) 
      local curve_i = temp_valid_curves[i]
      local qi=curve_i[4]
      w=string.gmatch(qi,"[-0-9.]+"); qi={tonumber(w()),tonumber(w())}
      local _cycle ={}
      local _set_cycle ={}
      local _seen_cycle ={}
      table.insert(_cycle,i);_set_cycle[i] = true 
      local j = cycle[2]
      local index=2
      local max_limit = 2e4
      while #_cycle <#cycle do
	 max_limit=max_limit-1
	 if max_limit ==  0 then print("Error : max_limit reached") return valid_curves,matrix_inters, {}end
	 local curve_j = temp_valid_curves[j]
	 local pj,qj=curve_j[1],curve_j[4]
	 w=string.gmatch(pj,"[-0-9.]+"); pj={tonumber(w()),tonumber(w())}
	 w=string.gmatch(qj,"[-0-9.]+"); qj={tonumber(w()),tonumber(w())}
	 --print("BEZ #_cycle="..#_cycle.."/"..#cycle,"i="..i,"j="..j,"|qi-pj|="..mflua.modul_vec(qi,pj),"|qi-qj|="..mflua.modul_vec(qi,qj))
	 if mflua.modul_vec(qi,pj)==0 then 
	    --print("BEZ i="..i,"j="..j,"|qi-pj|="..mflua.modul_vec(qi,pj))
	    table.insert(_cycle,j);_set_cycle[j] = true; _seen_cycle ={}
	    i = j
	    curve_i = temp_valid_curves[i]
	    qi=curve_i[4]
	    w=string.gmatch(qi,"[-0-9.]+"); qi={tonumber(w()),tonumber(w())}
	    for k=2,#cycle do 
	       local jj=cycle[k] 
	       --print("BEZ jj="..jj,_set_cycle[jj])
	       if _set_cycle[jj] == nil and jj~=j then
		  j=jj 
		  break
	       end
	    end
	    --print('BEZ next j=',j)
	 elseif mflua.modul_vec(qi,qj)==0 then
	    local _pj,_c1j,_c2j,_qj=curve_j[1],curve_j[2],curve_j[3],curve_j[4]
	    curve_j[1],curve_j[2],curve_j[3],curve_j[4] = _qj,_c2j,_c1j,_pj
	    temp_valid_curves[j] = curve_j 
	    pj=_coord_str_to_num(curve_j[1])
	    --print("BEZ i="..i,"j="..j,"|qi-pj|="..mflua.modul_vec(qi,pj))
	    table.insert(_cycle,j);_set_cycle[j] = true; _seen_cycle ={}
	    i = j
	    curve_i = temp_valid_curves[i]
	    qi=curve_i[4]
	    w=string.gmatch(qi,"[-0-9.]+"); qi={tonumber(w()),tonumber(w())}
	    for k=2,#cycle do 
		local jj=cycle[k] 
		--print("BEZ jj="..jj,_set_cycle[jj])
		if _set_cycle[jj] == nil and jj~=j then
		   j=jj 
		   break
		end
	     end
	     --print('BEZ next j=',j)
	  elseif mflua.modul_vec(qi,pj)>0 and mflua.modul_vec(qi,qj)>0 then 
	    --print("BEZ 3)SKIP i="..i,"j="..j,"|qi-qj|="..mflua.modul_vec(qi,qj),"|qi-pj|="..mflua.modul_vec(qi,pj))
	     _seen_cycle[j]=true
    	     for k=2,#cycle do 
		local jj=cycle[k] 
		--print("BEZ jj="..jj,_set_cycle[jj])
		if _set_cycle[jj] == nil and _seen_cycle[jj]==nil and jj~=j then
		   j=jj 
		   break
		end
	     end
	     --print('BEZ next j=',j)
	  end
       end ---while 
       _cycles[i]=_cycle
       --table.foreach(_cycle,print) 
    end
    cycles=_cycles
    --

    -- We can sort cycles so that the representant
    -- is that one with min(px,py)
    -- but it's not necessary

    --
    -- Projection on x-axis & y-axis to find the inclusions
    --
    t_values={0}   
    for i=1,math.ldexp(1,bit)-1 do table.insert(t_values, math.ldexp(i,-bit)) end
    table.insert(t_values, 1)
    for i,cycle in pairs(cycles) do 
       --print("BEZ cycle="..i)
       local min_x,min_y,max_x,max_y=infty,infty,-infty,-infty --   1e9,1e9,-1e9,-1e9
       for _,j in ipairs(cycle) do 
	  local curve = temp_valid_curves[j]
	  local p,c1,c2,q,offset=curve[1],curve[2],curve[3],curve[4],curve[5]
	  p=_eval_tonumber(p,offset)
	  c1=_eval_tonumber(c1,offset)
	  c2=_eval_tonumber(c2,offset)
	  q=_eval_tonumber(q,offset)
	  for _,t in ipairs(t_values) do
	     local x,y =bez(p,c1,c2,q,t)
	     if x<min_x then min_x=x end
	     if y<min_y then min_y=y end
	     if x>max_x then max_x=x end
	     if y>max_y then max_y=y end
	  end
       end
       cycle_projections[i]={['x']={min_x,max_x},['y']={min_y,max_y}}
    end
    -- for i,prj in pairs(cycle_projections) do 
    --     print(i,string.format("BEZ %s ≤ x ≤ %s, %s ≤ y ≤ %s ", prj.x[1],prj.x[2],prj.y[1],prj.y[2]))
    -- end

    --
    -- ∀ cycle we build the set of ancestors
    -- so that a ⊆ b ⊆ d ⊆ root ⟺ a is inside b which is inside d which is inside root
    -- The set is unsorted
    -- Note that ⊆ it's a partial order: it's possible that 
    -- a ⊆ b ⊆ root and d ⊆ root but d is not related with a or b
    -- We end in a tree of inclusions
    local cycle_ancestors,root_children={},{}
    for i,_ in pairs(cycle_projections) do cycle_ancestors[i] = {'root'} end
    for i,prj_i in pairs(cycle_projections) do 
       for j,prj_j in pairs(cycle_projections) do 
	  if i ~=j then
	     --print("BEZ j,i=",j,i)
	     if (prj_i.x[1]<=prj_j.x[1]) and (prj_j.x[2]<=prj_i.x[2]) and (prj_i.y[1]<=prj_j.y[1]) and (prj_j.y[2]<=prj_i.y[2]) then
		--print(j..' ⊆ '..i)
		table.insert(cycle_ancestors[j],i)
		--table.foreach(cycle_ancestors[j],function(k,v) print("BEZ j",j,v) end)
		--print("BEZ ----")
	     end
	  end
       end
    end
    -- for i,parent in pairs(cycle_ancestors) do 
    --    print("BEZ ",i);table.foreach(parent,print)
    -- end
    --print("BEZ ----")

    --
    -- Sort the set of ancestors for each branch
    --
    local tree_cycle,_set_tree_cycle,_len_cycle_ancestors={},{},0
    for i,parent in pairs(cycle_ancestors) do 
      _set_tree_cycle[i] = false 
      _len_cycle_ancestors=_len_cycle_ancestors+1
      table.sort(parent, 
	 function(e1,e2)  
	   if e1=='root' then return false end; 
	   if e2=='root' then return true  end ; 
	   local prj_e1,prj_e2 = cycle_projections[e1],cycle_projections[e2]
	   if (prj_e2.x[1]<=prj_e1.x[1]) and (prj_e1.x[2]<=prj_e2.x[2]) and (prj_e2.y[1]<=prj_e1.y[1]) and (prj_e1.y[2]<=prj_i.y[2]) then -- e1 ⊆ e2
	      return true 
	   else 
	      return false 
	   end 
	end) -- end function 
    end
    -- for i,parent in pairs(cycle_ancestors) do 
    --      io.write('i='..i,'  ')
    --      table.foreach(parent,function(k,v) io.write(k..','..v,'  ') end)
    --      print()
    -- end
    --
    -- Build the tree of inclusions
    -- 'root' is implicit, so we don't insert a tree_cycle['root'] entry
    -- tree_cycle[j] are the children of root
    -- is _set_tree_cycle[i]  useless  ?
    
    for i,parent in pairs(cycle_ancestors) do 
       --print('BEZ ******** i='..i,'#parent='..#parent,parent[1],"***************")
       if  #parent==1 then -- quite common
	  -- root 
	  --   \_i
	  --print('BEZ'..i..' is a child of root')
	  if tree_cycle[i] == nil then 
	     tree_cycle[i]={tn=0,children={}}
	  end
    	  _set_tree_cycle[i]=true
       elseif #parent==2 then -- also quite common
	  -- root = parent[2]
	  --   \_parent[1]
	  --          \_i
	  --print('BEZ --',parent[1],parent[2])
	  local new_parent = tree_cycle[parent[1]]
	  --print("BEZ new_parent=",new_parent,'i='..i)
	  if new_parent == nil then 
	     new_parent={tn=0,children={}} tree_cycle[parent[1]]=new_parent 
	     new_parent.children[i]={tn=0,children={}}
	  else 
	     -- Due to the fact that this node can be already inserted 
	     -- maybe it has already its children
	     if new_parent.children[i] == nil then 
		new_parent.children[i]={tn=0,children={}}
	     end
	  end
	  _set_tree_cycle[i]=true
       elseif #parent>2 then -- 
	  --print("BEZ ==> parent="..#parent)
	  -- With #parent == 3 
	  -- root = parent[3]
	  --   \_parent[2]
	  --       \_parent[1]
	  --           \_i
	  -- The problem  is that we aren't following the descendants in linear fashion
	  -- ie i= parent[3], i+1=parent[1] so we must build before p[1] p[2]
	  --local current_parent = tree_cycle[#parent-1]
	  --print("BEZ ==>current_parent =",current_parent )
	  local prev_node = {}
	  for j=0,#parent-2 do
	     local root = parent[#parent-j]
	     --print("BEZ j="..j,"current root=",root,"#parent-2=",#parent-2)
	     if root=='root' then -- j=0 is always root
		local _leaf = parent[#parent-j-1]
		--print("BEZ _leaf=",_leaf,"tree_cycle[_leaf]=",tree_cycle[_leaf])		
		if tree_cycle[_leaf] == nil then 
		   tree_cycle[_leaf]={tn=0,children={}}
		   --_set_tree_cycle[_leaf]=true
		end
		-- j=0 is always verified so prev_node is always initialized
		prev_node = tree_cycle[_leaf]
	     else -- root ~='root'
		local _leaf = parent[#parent-j-1]
		--print("BEZ #parent-j="..#parent-j,"#parent-j-1="..#parent-j-1,'_leaf=',_leaf)
		--print("BEZ prev_node.children=",prev_node.children,'#prev_node.children='..#prev_node.children, 'prev_node.children[_leaf]=',prev_node.children[_leaf])
		-- check if current root (ie the prev_node) has _leaf as child
		if prev_node.children[_leaf]==nil then 
		   prev_node.children[_leaf] = {tn=0,me=_leaf,children={}}
		   --tree_cycle[_leaf]={tn=0,children={}}
		end
		--prev_node = tree_cycle[_leaf]
		prev_node = prev_node.children[_leaf]
	     end
	  end --for
	  --print("BEZ end for")
	  --
	  -- OK we are at the point where we must insert the node i
	  --
	  --print("BEZ prev_node.children[i]=",prev_node.children[i])
	  if prev_node.children[i]==nil then 
	     --print("BEZ prev_node.children["..i.."] = {tn=0,children={}}")
	     prev_node.children[i] = {tn=0,me=i,children={}}
	  end
	  --for k,v in pairs(tree_cycle[24].children[12].children) do 
	   --  print("BEZ 3",k,v)
	  --end       
       end

    end
    --print("BEZ end ")
    --
    -- a function to visit the nodes of the trees
    --
    local level=0
    local function recurse_visit(tree,tn)
       local l = 0
       for k,v in pairs(tree) do l=l+1 end
       --print("BEZ l="..l)
       if l==0 then return end
       for k,child in pairs(tree) do
	  level=level+1
	  --print('BEZ',level,'child',k,'child.tn=',child.tn)
	  recurse_visit(child.children,child.tn)
	  level=level-1
       end
    end
    --print("BEZ recurse_visit(tree,tn)")
    --print(recurse_visit(tree_cycle,-1))
    --
    -- A function to reverse the cycle to match the correct turning number
    -- 
    local function reverse_cycle(i)
       local cycle = cycles[i]
       local rev_cycle = {}
       --print("BEZ reverse cycle "..i)
       for index,j in ipairs(cycle) do 
	  local curve = temp_valid_curves[j]
	  local p,c1,c2,q,shifted=curve[1],curve[2],curve[3],curve[4],curve[5]
	  curve[1],curve[2],curve[3],curve[4],curve[5] = q,c2,c1,p,shifted 
	  rev_cycle[#cycle+1-index]=j
       end
       -- We must reverse also cycle.
       cycles[i] = rev_cycle
    end
    --
    -- a function to set  the turning number of the node from the parent's one
    --
    local level = 0
    local tn_calculated={}
    local function recurse_set_tn(tree,parent_tn)
       local l = 0
       level=level+1
       --print("BEZ recurse_level="..level)
       --print("BEZ recurse_set_tn,parent_tn="..parent_tn,"l="..l)
       for k,v in pairs(tree) do l=l+1 end
       print("BEZ recurse_set_tn,parent_tn="..parent_tn,"l="..l)
       if l==0 then return end
       --print("BEZ recurse_set_tn,parent_tn="..parent_tn,"l="..l)
       for k,child in pairs(tree) do
	  child.tn=-parent_tn
	  --print('BEZ recurse_set_tn, child='..k,'child.tn=',child.tn,tn_calculated[tonumber(k)])
	  if tn_calculated[tonumber(k)] ~= child.tn then 
	     reverse_cycle(k)
	  end
	  recurse_set_tn(child.children,child.tn)
       end
    end
    --
    --Write down the set of cycles
    --
    local mftn_name = mflua.turningnumber_file or 'mflua_tn'
    local mflua_exe = mflua.mflua_exe or './mf' 
    local mftn,lines
    os.remove(mftn_name..'.mf') -- to be sure
    mftn = io.open(mftn_name..'.mf','w')
    -- debug
    --os.remove("mflua_tn_debug"..'.mf') -- to be sure
    --mftn_debug = io.open("mflua_tn_debug"..".mf",'w')
    for i,cycle in pairs(cycles) do 
       local preamble = "batchmode;message \"BEGIN i="..i.."\";\n"
       local path = "path p; p:="
       for _,j in pairs(cycle) do 
	  local curve = temp_valid_curves[j]
	  local p,c1,c2,q,shifted=curve[1],curve[2],curve[3],curve[4],curve[5]
	  path = path..string.format("%s .. controls %s and %s .. %s --\n",
	     _eval(p,shifted),_eval(c1,shifted),_eval(c2,shifted),_eval(q,shifted))
       end
       path = path .."cycle;\n"
       path = path.."numeric t; t:= turningnumber p;show t;\n"
       local postamble = 'message "END i='..i..'";\n'
       mftn:write(preamble..path..postamble)
       -- 
       --debug
       --
       --[==[::::::::::::::::::::::::::::::::::::::::::::::::>
       path = ''
       for _,j in pairs(cycle) do 
	  local curve = temp_valid_curves[j]
	  local p,c1,c2,q,shifted=curve[1],curve[2],curve[3],curve[4],curve[5]
	  path = path..string.format("%s .. controls %s and %s .. %s --\n",
	     _eval(p,shifted),_eval(c1,shifted),_eval(c2,shifted),_eval(q,shifted))
	  local temp_path = 'path p; p:=' .. path .. 'cycle; %% j=' .. j..'\n'
	  temp_path = temp_path.."numeric t; t:= turningnumber p;show t;\n"
	  mftn_debug:write(temp_path)
       end
       <:::::::::::::::::::::::::::::::::::::::::::::::]==]--
    end
    mftn:write("bye.\n")
    mftn:close()
    --mftn_debug:write("bye.\n")
    --mftn_debug:close()

    --
    -- Let mflua calculates; We read the turning number
    -- from the log
    --
    mflua.lock() --io.open('LOCK1','w')
    os.remove(mftn_name..'.log') -- to be sure 
    os.execute(string.format("%s %s",mflua_exe,mftn_name..'.mf'))
    mflua.unlock() --os.remove('LOCK1')
    mftn= io.open(mftn_name..'.log')
    assert(mftn ~= nil,'Error on reading '..mftn_name..'.log')
    lines=mftn:read("*all")
    mftn:close()
    local i=string.gmatch(lines,"BEGIN i=([0-9]+)")
    local tn=string.gmatch(lines,">> ([-0-9.]+)")
    while true do 
       local _i = i() 
       local _tn= tn()
       if _i==nil then break end
       tn_calculated[tonumber(_i)]=tonumber(_tn)
       --print('BEZ i=',_i,_tn)
    end

    --
    -- We set the cycles to match the proper turning number
    --
    -- The first cycle for CFF must be
    -- anti clockwise ==1
    -- so the root is -1 (the root is the imaginary frame around the glyph)
    -- We can  reverse the things (i.e. clockwise) 
    -- if root is 1 (as for svg, for example) 
    --print("BEZ tn----")
    local parent_tn=-turning_number
    for k,child in pairs(tree_cycle) do 
       child.tn=-parent_tn
       --print('BEZ child',k,'child.tn='..child.tn,   "tn_calculated="..tn_calculated[tonumber(k)])
       if tn_calculated[tonumber(k)] ~= child.tn then 
	  --print("BEZ must reverse cycle "..k)
	  reverse_cycle(k)
       end
       recurse_set_tn(child.children,child.tn)
    end
    --
    local valid_curves = {}
    for i,bezier in ipairs(temp_valid_curves) do
       --print(i,bezier)
       if not(bezier==false) then
	  valid_curves[i] = bezier
       end
    end
    return valid_curves,matrix_inters,cycles
end

local function _get_svg_glyph(valid_curves,matrix_inters,char,cycles,tfm)
   -- Write the svg
   --
   --      print('BEZ  LUAGLOBALGET_hppp='..print_scaled(LUAGLOBALGET_hppp()))
   --    print('BEZ  LUAGLOBALGET_vppp='..print_scaled(LUAGLOBALGET_vppp()))
   --  print('BEZ  LUAGLOBALGET_designsize='..print_scaled(LUAGLOBALGET_designsize()))
   print('BEZ _get_svg_glyph')
   -- local tfm = io.open('ccr10.tfm','r')
   -- if tfm ~= nil then
   --    local c =  tfm:read('*a')
   --    tfm:close()
   --    print('BEZ c='..string.len(c))
   -- end
   local tfm = tfm
   local index = tostring( char['index'] ) -- better a string or a number
   print('BEZ index='..index)

   local design_size=tonumber ( print_scaled(LUAGLOBALGET_designsize()) ) --pt 
   local char_wd=tonumber( char['char_wd'] ) -- pt
   local char_ht=tonumber( char['char_ht'] ) -- pt
   local char_dp=tonumber( char['char_dp'] ) -- pt

   --local xheight =  0.458333 *  design_size -- must be read from tfm !!

   local x_resolution = math.floor(0.5+tonumber( print_scaled(LUAGLOBALGET_hppp()) )* 72.27)
   local y_resolution = math.floor(0.5+tonumber( print_scaled(LUAGLOBALGET_vppp()) )* 72.27)
   assert(x_resolution==y_resolution, string.format('Error on _get_svg_glyph x_res=%d and y_res=%d differ',x_resolution,y_resolution))

   local resolution = x_resolution 
   local emsize = mflua.svg.emsize -- 1000, type 1, also known as em_unit: 1000 emsize = 1em
   local em_unit  = emsize  

   local em_unit_for_pixel = (72.27/design_size) * (emsize / resolution)
   local bp_for_pt = 72/72.27
   local char_wd_emunit = (char_wd/design_size) *em_unit
   local char_ht_emunit = (char_ht/design_size) *em_unit
   local char_dp_emunit = (char_dp/design_size) *em_unit
    
   local outdir = mflua.svg.output_dir or '.'
   local fname = mflua.svg.char[index].glyph_name
   assert(fname~=nil, string.format("Error on svg file name for char index %s: it's nil",index))
   --local f = io.open(outdir..'/'.. fname..'.svg','w')
   local w = string.gmatch(fname,'uni(.+)')
   local unicode_hex = w()
   local unicode =  mflua.svg.char[index].unicode
   local unicode_range = 'U+'..unicode_hex
   local glyph_name = fname 
   local bezier = ''
   local maxx,maxy=-1e9,-1e9
   local minx,miny=1e9,1e9
   for i,cycle in pairs(cycles) do 
      local path=''
      local _i=1
      for _,j in ipairs(cycle) do 
	 local curve = valid_curves[j]
	 local p,c1,c2,q,offset=curve[1],curve[2],curve[3],curve[4],curve[5]
	 p=_eval_tonumber(p,offset)
	 c1=_eval_tonumber(c1,offset)
	 c2=_eval_tonumber(c2,offset)
	 q=_eval_tonumber(q,offset)
	 -- em_unit_for_pixel
	 p[1],p[2] = p[1]*em_unit_for_pixel,p[2]*em_unit_for_pixel
	 q[1],q[2] = q[1]*em_unit_for_pixel,q[2]*em_unit_for_pixel
	 c1[1],c1[2] = c1[1]*em_unit_for_pixel,c1[2]*em_unit_for_pixel
	 c2[1],c2[2] = c2[1]*em_unit_for_pixel,c2[2]*em_unit_for_pixel
	 if _i==1 then bezier = bezier..string.format("M%s %s ",p[1],p[2]) end
	 _i=_i+1	 
	 bezier = bezier .. string.format("C%s %s %s %s %s %s\n",c1[1],c1[2],c2[1],c2[2],q[1],q[2])
	  --print("BEZ bez="..bezier)
	 if p[1]>maxx then maxx=p[1] end
	 if c1[1]>maxx then maxx=c1[1] end
	 if c2[1]>maxx then maxx=c2[1] end
	 if q[1]>maxx then maxx=q[1] end
	 if p[2]>maxy then maxy=p[2] end
	 if c1[2]>maxy then maxy=c1[2] end
	 if c2[2]>maxy then maxy=c2[2] end
	 if q[2]>maxy then maxy=q[2] end
	 --
	 if p[1]<minx then minx=p[1] end
	 if c1[1]<minx then minx=c1[1] end
	 if c2[1]<minx then minx=c2[1] end
	 if q[1]<minx then minx=q[1] end
	 if p[2]<miny then miny=p[2] end
	 if c1[2]<miny then miny=c1[2] end
	 if c2[2]<miny then miny=c2[2] end
	 if q[2]<miny then miny=q[2] end
      end
      bezier = bezier .. 'Z\n'
   end
   --print('BEZ (x,y) (X,Y)=',minx,miny,maxx,maxy)
   --print('BEZ', svg_glyph,glyph_name,unicode,char_wd_emunit,char_ht_emunit,bezier)
   local trunk = ''
   local svg_glyph = mflua.svg.glyph
   local svg_font = mflua.svg.font
   trunk = string.format(svg_glyph,
			 glyph_name,unicode,
			 char_wd_emunit,
			 char_ht_emunit,
			 bezier,'')
   --mflua.svg.char[index].data=trunk 
   -- trunk = string.format(svg_font,
   -- 			 string.format("%2.2f",design_size*bp_for_pt),
   -- 			 emsize,
   -- 			 string.format("%2.2f",xheight*bp_for_pt),
    -- 			 trunk)
   -- f:write(trunk)
   -- f:close()
   local svg_preamble = mflua.svg.svg_preamble
   local paths = string.format('<path style="fill:#000000;stroke=none;fill-rule:nonzero" d="%s" />', bezier)
   local raw=string.format(svg_preamble,minx,miny,maxx,maxy,-maxy,paths)
   return trunk,raw
end -- _get_svg_glyph


local function _svg_kern_and_lig(chartable,t,tfm)
   --
   -- Store kerns and ligs
   -- 
   local current_chars={}
   local index
   local kern, next_char,additional_space
   local bp_for_pt = 72/72.27
   local x_resolution = math.floor(0.5+tonumber( print_scaled(LUAGLOBALGET_hppp()) )* bp_for_pt)
   local y_resolution = math.floor(0.5+tonumber( print_scaled(LUAGLOBALGET_vppp()) )* bp_for_pt)
   local design_size=tfm.font.designsize -- pt
   assert(x_resolution==y_resolution, string.format('Error on _get_svg_glyph x_res=%d and y_res=%d differ',x_resolution,y_resolution))
   local resolution = x_resolution 
   local emsize = mflua.svg.emsize -- 1000, type 1, also known as em_unit: 1000 emsize = 1em
   local em_unit  = emsize  
   local em_unit_for_pixel = (bp_for_pt/design_size) * (emsize / resolution)

   local hkern,vkern = '' ,''
   for i,_ in ipairs(t) do 
      index = t[i]
      print("BEZ index=",index)
      current_chars[index]=true
   end
   for i,_ in ipairs(t) do 
      index = t[i]
      if tfm.chars[index] and  tfm.chars[index].kern then 
	 kerntable = tfm.chars[index].kern
	 for _,k in ipairs(kerntable) do 
	    next_char,additional_space = tostring(k.next_char),tonumber(k.additional_space)
	    --
	    if additional_space~=0 then 
	       local a_name,a_unicode = mflua.svg.char[tostring(index)].glyph_name,mflua.svg.char[tostring(index)].unicode
	       local b_name,b_unicode = mflua.svg.char[next_char].glyph_name,mflua.svg.char[next_char].unicode
	       hkern = hkern .. "\n".. string.format(mflua.svg.hkern,
						     a_name,a_unicode,
						     b_name,b_unicode,
						     additional_space*design_size*em_unit_for_pixel)
	    end
	 end
      end
   end
   return hkern,vkern
end

local function _store_svg_font(tfm)
   local outdir = mflua.svg.output_dir or '.'
   local fname = mflua.svg.filename
   assert(fname~=nil, string.format("Error on svg file name for %s: it's nil",fname))
   local f = io.open(outdir..'/'.. fname..'.svg','w')
   local svg_font = mflua.svg.font
   local design_size=tonumber ( print_scaled(LUAGLOBALGET_designsize()) ) --pt 
   local emsize = mflua.svg.emsize -- 1000, type 1, also known as em_unit: 1000 emsize = 1em
   local bp_for_pt = 72/72.27
   local xheight =  tfm.font.x_height * design_size --0.458333 *  design_size -- must be read from tfm !!
   local trunk =''
   local char = mflua.svg.char
   for index=0,2^16-1 do
      if not(char[tostring(index)]==nil) then 
	 --print("BEZ char[tostring(index)].data=",index,char[tostring(index)].data)
	 trunk= trunk.. (char[tostring(index)].data or '')
      end
   end
   trunk = trunk.."\n"..mflua.svg.hkerns.."\n"..mflua.svg.vkerns
   trunk = string.format(svg_font,
			 string.format("%2.2f",design_size*bp_for_pt),
			 emsize,
			 string.format("%2.2f",xheight*bp_for_pt),
			 trunk)
   return trunk


end

local function _remove_and_join_curve(beg_curve,end_curve,remove_curve,valid_curves,matrix_inters,method) 
   --
   -- _remove_and_join_curve
   --
   -- method = 1 (beg_curve+end_curve)/2
   -- method = 2 beg_curve = end_curve
   -- method = 3 end_curve = beg_curve 
   -- otherwise (beg_curve+end_curve)/2
   --
   print("BEZ _remove_and_join_curve")
   local BEG,END,REMOVE =beg_curve,end_curve,remove_curve
   local method = (type(method)=='number' and math.floor(tonumber(method)+0.5)) or 1
   print("BEZ method="..method)

   valid_curves=_remove_path(valid_curves,matrix_inters,{tostring(REMOVE)})
   local bez_BEG = valid_curves[BEG]
   local bez_END = valid_curves[END]
   local p_BEG = bez_BEG[1] 
   local q_END = bez_END[4] 
   local p_BEG,q_END =  _eval_tonumber(p_BEG,'(0,0)'), _eval_tonumber(q_END,'(0,0)')
   if method == 1 then 
      p_BEG = { (p_BEG[1]+q_END[1])/2,(p_BEG[2]+q_END[2])/2 }
      q_END = p_BEG 
   elseif method==2 then
      p_BEG = q_END
   elseif method==3 then
      q_END = p_BEG 
   else
      p_BEG = { (p_BEG[1]+q_END[1])/2,(p_BEG[2]+q_END[2])/2 }
      q_END = p_BEG 
   end
   bez_BEG[1] = "(" .. tonumber(string.format("%.3f",p_BEG[1])) .. "," .. tonumber(string.format("%.3f",p_BEG[2]))..")"
   bez_END[4] = "(" .. tonumber(string.format("%.3f",q_END[1])) .. "," .. tonumber(string.format("%.3f",q_END[2]))..")"
   return valid_curves
end



local function _simplifyBsB(cycle,threshold_simplify_n,char_index)
   --
   -- Big--small--Big
   -- 
   print("BEZ _simplifyBsB")
   local curve_length = {}
   local mflua_exe = mflua.mflua_exe
   local threshold_simplify_n = threshold_simplify_n
   for i,v in ipairs(cycle) do
      --print("BEZ i="..i,v)
      local values = {}
      local label,p,c1,c2,q,offset = v[1],v[2],v[3],v[4],v[5],v[6]
      --print("BEZ ",label,p,c1,c2,q,offset)
      p= _eval_tonumber(p,offset)
      c1= _eval_tonumber(c1,offset)
      c2= _eval_tonumber(c2,offset)
      q= _eval_tonumber(q,offset)
      local prev_point = p
      local current_point = p
      local length = 0
      for k=1,255 do 
	 local t = k/2^8
	 --print("t="..t,prev_point,current_point)
	 local _x,_y = bez(p,c1,c2,q,t)
	 current_point ={_x,_y}
	 length= length+mflua.modul_vec(prev_point,current_point)
	 prev_point = current_point
      end
      current_point= q
      length= length+mflua.modul_vec(prev_point,current_point)
      --print("BEZ i="..i,label,length)
      curve_length[i]=length 
   end
   --  merge 3 curves i-1, i, i+1, where
   --  len(i-1)> mflua.threshold_simplify_big_small_ratio *len(i) 
   --  and 
   --  len(i+1)> mflua.threshold_simplify_big_small_ratio *len(i) 
   local accumulated_length = 0
   local target_path={}
   local temp_cycle = {};
   for i,v in ipairs(cycle) do temp_cycle[i] = v ; end
   --for i,v in ipairs(cycle) do
   for i=2,#cycle-1 do
      --local label,p,c1,c2,q,offset = v[1],v[2],v[3],v[4],v[5],v[6]
      local length1,length2,length3=curve_length[i-1],curve_length[i],curve_length[i+1]
      if length1 > mflua.threshold_simplify_big_small_ratio*length2 
         and  length3 > mflua.threshold_simplify_big_small_ratio*length2 
         and temp_cycle[i-1]~=false 
      then
	 target_path[1]=i-1
	 target_path[2]=i
	 target_path[3]=i+1
	 print("BEZ length1="..length1,"length2="..length2,"length3="..length3)
	 local ii = target_path[1] 
	 local vv = cycle[ii]
	 local label,p,c1,c2,q,offset = vv[1],vv[2],vv[3],vv[4],vv[5],vv[6]
	 local P=p;
         local label1 = label 
	 --local  s= "%"..label.."\n"..string.format("p1=%s;c1=%s;q1=%s;%%%s c2=%s\n",p,c1,q,label,c2)
	 local s = "pair p[],c[],q[];\nnumeric L; L:=3;\n"
	 s= s.."numeric Nmax,Mmax,Step; Nmax:=8;Mmax:=8;Step:=0.5;\n"
	 s= s.."numeric Limit; Limit:="..mflua.threshold_simplify_sample..";\n"
	 s= s.."%"..label.."\n"..string.format("p1=%s;c1=%s;q1=%s;%%%s ii=%s %s\n",p,c1,q,label,ii,length1)
	 for k=2,#target_path-1 do
	     ii = target_path[k] 
	     vv = cycle[ii]
	     label,p,c1,c2,q,offset = vv[1],vv[2],vv[3],vv[4],vv[5],vv[6]
	     --s = s.. string.format("p%s=%s;q%s=%s;%%%s c1=%s,c2=%s\n",k,p,k,q,label,c1,c2)
	     s = s.. string.format("p%s=%s;q%s=%s;%%%s i=%s %s\n",k,p,k,q,label,ii,length2)
	  end
	 ii = target_path[#target_path] 
	 vv = cycle[ii]
	 label,p,c1,c2,q,offset = vv[1],vv[2],vv[3],vv[4],vv[5],vv[6]
	 local Q=q;
	 --s= s.. string.format("p%s=%s;c2=%s;q%s=%s;%%%s c1=%s\n",#target_path,p,c2,#target_path,q,label,c1)
	 s= s.. string.format("p%s=%s;c2=%s;q%s=%s;%%%s ii=%s %s\n",#target_path,p,c2,#target_path,q,label,ii,length3)
	 s=s..string.format("input %s;\n",mflua.simplify_routine)
	 mflua.lock() io.open('LOCK1','w')
	 local name = string.format('%s-mflua-sim3-%s',char_index,label1)
	 local f = io.open(name..'.mf','w')
	 f:write(s)
         io.close(f)
	 os.execute(string.format("%s %s.mf",mflua_exe,name))
	 mflua.unlock() 
	 f=io.open(name ..".log",'r')
	 local lines=f:read("*a")
	 f:close()
	 f=io.open(mflua.simplify_tempdir..'/'..name ..".log",'w');f:write(lines);f:close();os.remove(name ..".log")
	 f=io.open(mflua.simplify_tempdir..'/'..name ..".mf",'w');f:write(s);f:close();os.remove(name ..".mf")
	 local w=string.gmatch(lines,"^! (.+)")
	 local err=w()
	 --print("BEZ err=",err)
	 if err ==nil then 
	    w=string.gmatch(lines,">> (%([-0-9.]+,[-0-9.]+%))")
	    local _,C1,C2,_ = w(),w(),w(),w()
	    print("BEZ ",P,C1,C2,Q)
	    local curves = {}
	    curves['p']=P
	    curves['c1']=C1
	    curves['c2']=C2
	    curves['q']=Q
	    local ii = target_path[1] 
	    temp_cycle[ii] = {'BsB_'..label1,P,C1,C2,Q,'(0,0)'}
	    for k = 2, #target_path do
	       ii = target_path[k] 
	       temp_cycle[ii] = false 
	    end
	 end
	 -- reset 
	 target_path={}
	 accumulated_length = 0
      end --if #target_path==threshold_simplify_n 
   end --for i,v in ipairs(cycle) do
   local res = {}
   for i,v in ipairs(temp_cycle) do 
      if not(v==false) then
	 res[#res+1]= v
      end
   end
   return res
end



local function _simplify(cycle,valid_curves,threshold_simplify_n,char_index)
   --
   -- Merge mflua.threshold_simplify_n curves
   --
   print("BEZ _simplify")
   local curve_length = {}
   local mflua_exe = mflua.mflua_exe
   local threshold_simplify_n = threshold_simplify_n
   print("BEZ threshold_simplify_n=",threshold_simplify_n)
   for i,_v in ipairs(cycle) do
      local v = valid_curves[_v]
      local values = {}
      --local label,p,c1,c2,q,offset = v[1],v[2],v[3],v[4],v[5],v[6]
      local label,p,c1,c2,q,offset = tostring(_v), v[1],v[2],v[3],v[4],v[5]
      --print("BEZ ",label,p,c1,c2,q,offset)
      p= _eval_tonumber(p,offset)
      c1= _eval_tonumber(c1,offset)
      c2= _eval_tonumber(c2,offset)
      q= _eval_tonumber(q,offset)
      local prev_point = p
      local current_point = p
      local length = 0
      for k=1,255 do 
	 local t = k/2^8
	 --print("t="..t,prev_point,current_point)
	 local _x,_y = bez(p,c1,c2,q,t)
	 current_point ={_x,_y}
	 length= length+mflua.modul_vec(prev_point,current_point)
	 prev_point = current_point
      end
      current_point= q
      length= length+mflua.modul_vec(prev_point,current_point)
      --print("BEZ i="..i,label,length)
      curve_length[i]=length 
   end
   --  merge
   --  threshold_simplify_n (i.e. 10) small consecutive curves
   --
   local accumulated_length = 0
   local target_path={}
   local temp_cycle = {};
   local temp_removed_curve ={}
   local temp_added_curve ={}
   for i,_v in ipairs(cycle) do temp_cycle[i] = _v ; end
   for i,v in ipairs(cycle) do
      -- local label,p,c1,c2,q,offset = v[1],v[2],v[3],v[4],v[5],v[6]
      local length=curve_length[i]
      if length<mflua.threshold_simplify_len then
	 accumulated_length = accumulated_length + length
	 target_path[#target_path+1]=i
	 --print("BEZ #target_path="..#target_path)
      end
      if #target_path==threshold_simplify_n 
           and accumulated_length<mflua.threshold_simplify_max_len 
           and math.abs(target_path[1] -target_path[#target_path])+1== threshold_simplify_n
	   and (i>1 and temp_cycle[i-1]~=false )
	then
	 print("BEZ",math.abs(target_path[1] -target_path[#target_path])) 
	 print("BEZ accumulated_length="..accumulated_length)
	 local ii = target_path[1] 
	 --print("BEZ type(cycle[ii])="..type(cycle[ii]))
	 local vv = valid_curves[cycle[ii]]
	 --local label,p,c1,c2,q,offset = vv[1],vv[2],vv[3],vv[4],vv[5],vv[6]
	 local label,p,c1,c2,q,offset = tostring(cycle[ii]),vv[1],vv[2],vv[3],vv[4],vv[5]
	 local P=p;
         local label1 = label 
	 --local  s= "%"..label.."\n"..string.format("p1=%s;c1=%s;q1=%s;%%%s c2=%s\n",p,c1,q,label,c2)
	 local s = "pair p[],c[],q[];\nnumeric L; L:="..threshold_simplify_n..";\n"
	 s= s.."numeric Nmax,Mmax,Step; Nmax:=8;Mmax:=8;Step:=0.5;\n"
	 s= s.."numeric Limit; Limit:="..mflua.threshold_simplify_sample..";\n"
	 s= s.."%"..label.."\n"..string.format("p1=%s;c1=%s;q1=%s;%%%s ii=%s\n",p,c1,q,label,ii)
	 for k=2,#target_path-1 do
	    ii = target_path[k] 
	    vv = valid_curves[cycle[ii]]
	    --label,p,c1,c2,q,offset = vv[1],vv[2],vv[3],vv[4],vv[5],vv[6]
	    label,p,c1,c2,q,offset = tostring(cycle[ii]),vv[1],vv[2],vv[3],vv[4],vv[5]
	    --s = s.. string.format("p%s=%s;q%s=%s;%%%s c1=%s,c2=%s\n",k,p,k,q,label,c1,c2)
	    s = s.. string.format("p%s=%s;q%s=%s;%%%s i=%s\n",k,p,k,q,label,ii)
	 end
	 ii = target_path[#target_path] 
	 vv = valid_curves[cycle[ii]]
	 --label,p,c1,c2,q,offset = vv[1],vv[2],vv[3],vv[4],vv[5],vv[6]
	 label,p,c1,c2,q,offset = tostring(cycle[ii]),vv[1],vv[2],vv[3],vv[4],vv[5]
	 local Q=q
	 --s= s.. string.format("p%s=%s;c2=%s;q%s=%s;%%%s c1=%s\n",#target_path,p,c2,#target_path,q,label,c1)
	 s= s.. string.format("p%s=%s;c2=%s;q%s=%s;%%%s ii=%s\n",#target_path,p,c2,#target_path,q,label,ii)
	 s=s..string.format("input %s;\n",mflua.simplify_routine)
	 mflua.lock() io.open('LOCK1','w')
	 print("BEZ ",char_index,threshold_simplify_n,label1)
	 local name = string.format('%s-mflua-sim%s-%s',char_index,threshold_simplify_n,label1 )
	 local f = io.open(name..'.mf','w')
	 f:write(s)
         io.close(f)
	 os.execute(string.format("%s %s.mf ",mflua_exe,name))
	 mflua.unlock() 
	 f=io.open(name ..".log",'r')
	 local lines=f:read("*a")
	 f:close()
	 f=io.open(mflua.simplify_tempdir..'/'..name ..".log",'w');f:write(lines);f:close();os.remove(name ..".log")
	 f=io.open(mflua.simplify_tempdir..'/'..name ..".mf",'w');f:write(s);f:close();os.remove(name ..".mf")
	 local w=string.gmatch(lines,"^! (.+)")
	 local err=w()
	 --print("BEZ err=",err)
	 if err ==nil then 
	    w=string.gmatch(lines,">> (%([-0-9.]+,[-0-9.]+%))")
	    local _,C1,C2,_ = w(),w(),w(),w()
	    print("BEZ ",P,C1,C2,Q)
	    local curves = {}
	    curves['p']=P
	    curves['c1']=C1
	    curves['c2']=C2
	    curves['q']=Q
	    local ii = target_path[1] 
	    temp_cycle[ii] = {'m_'..label1,P,C1,C2,Q,'(0,0)'}
	    temp_added_curve[tonumber(label1)]={P,C1,C2,Q,'(0,0)'}
	    for k = 2, #target_path do
	       ii = target_path[k] 
	       temp_removed_curve[#temp_removed_curve+1]=tostring(cycle[ii])
	       temp_cycle[ii] = false 
	    end
	 end
	 -- reset 
	 target_path={}
	 accumulated_length = 0
      end --if #target_path==threshold_simplify_n 
   end --for i,v in ipairs(cycle) do
   local res = {}
   for i,v in ipairs(temp_cycle) do 
      if not(v==false) then
	 res[#res+1]= v
      end
   end
   return res,temp_removed_curve,temp_added_curve
end


-- local function _simplify_cycles(valid_curves,matrix_inters, cycles,char_index)
--    local _cycles = {}
--    local temp_valid_curves = {};  for k,v in pairs(valid_curves) do temp_valid_curves[k] = v end
--    for k,cycle in pairs(cycles) do
--       print("BEZ k,cycle=",k,cycle)
--       local cycle1,removed,added = _simplify(cycle,temp_valid_curves,mflua.threshold_simplify_n,char_index )
--       temp_valid_curves=_remove_path(temp_valid_curves,matrix_inters,removed)
--       for k,v in pairs(added) do
-- 	 temp_valid_curves[k] = v
--       end
--       --local cycle2 = _simplifyBsB (cycle1,valid_curves,mflua.threshold_simplify_n,char_index )
--       local cyclen = cycle1;
--       _cycles[k]=cyclen
--    end
--    return temp_valid_curves,matrix_inters, _cycles
-- end




function end_program()
   local chartable = mflua.chartable 
   local f = mflua.print_specification.outfile1 or nil
   -- some mflua instances cannot have this file open
   if f==nil then return end
   local res = ""
   local t = {}

   local tfm = dofile('tfm.lua') 
   print("tfm run:",tfm.run("ccr10-mflua.tfm"))

   f:write("\n%%\\starttext\\setupbodyfont[tt,2pt]\\bf\\stoptext %% comment this line to make pdf\n")
   f:write("\\starttext\n\\setupbodyfont[tt,2pt]\\bf\n")
   --f:write("\\starttext\n\\setupbodyfont[tt,4pt]\\bf\n")
   for k,_ in pairs(chartable) do t[#t+1]=k end
   table.sort(t)
      -- mflua.svg.hkerns,mflua.svg.vkerns = _svg_kern_and_lig(chartable,t,tfm)
      -- trunk = _store_svg_font(tfm)
      -- local svg_f=io.open((mflua.svg.output_dir or '.') .. '/' .. (mflua.svg.filename or 'SVGOUT')..'.svg','w')
      -- svg_f:write(trunk)
      -- svg_f:close()
      -- os.exit(1)
   for i,_ in ipairs(t) do
      local valid_curves_e = {}
      local valid_curves_c = {}
      local valid_curves_p = {}
      local valid_curves_p_set= {}
      local pen_over_knots = {}
      local valid_curves = {}
      local matrix_inters = {}
      local dropped = {}
      local coll_ind= {}
      local index = t[i]
      local char= chartable[index]
      local edges = char['edges']
      local ye_map = {}
      local cycles = {}
      local svg_glyph_index = -1
      local trunk =''
      for i,v in ipairs(edges[1][1]) do ye_map[v[1]] = i  end
      char['edges_map'] = ye_map 
      f:write("\\startMPpage%%%% BEGIN EDGES\n")
      res = res .. "%% char " .. index .."\n"
      local pre_res = char['pre_res'] or ""
      res = res .. pre_res .."\n"
      local v_res = char['res'] or ""
      res = res .. v_res .."\n"
      local post_res = char['post_res'] or ""
      res = res .. post_res .."\n"
      f:write(res)
      res = ''

      --
      --
      -- 
--[==[
      _pix_x_min,_pix_y_min,_pix_x_max,_pix_y_max,_pix_bitmap = _dump_edges(char)  
      local _pix_fh=io.open('out.pbm','w')
      print("BEZ _pix_x_min,_pix_y_min,_pix_x_max,_pix_y_max=",_pix_x_min,_pix_y_min,_pix_x_max,_pix_y_max)
      _pix_fh:write("P1\n")
      _pix_fh:write("# BBOX".._pix_x_min.." ".._pix_y_min.." ".._pix_x_max.." ".._pix_y_max.."\n")
      _pix_fh:write( (_pix_x_max-_pix_x_min+1).." "..(_pix_y_max-_pix_y_min+1).."\n")
      for j=_pix_y_max,_pix_y_min,-1 do
	 local row = _pix_bitmap[j] 
	 local res = ''
	 for i=_pix_x_min,_pix_x_max do
	    res=res..tostring(row[i])
	 end
	 _pix_fh:write(res.."\n")
      end   
      _pix_fh:close()
      os.exit(1)
]==]
      --
      -- The problem is to calculate the frontier
      -- Currently the neighborhood of a point 
      -- is too strict (see for example 'Q' or 'B') 
      -- or too  wide (see for example h or u)
      --

      local lmin,lmax,x_min,y_min,x_max,y_max = _find_longest_curve(char)
      local table_max = {math.abs(x_max-x_min),math.abs(y_max-y_min),lmax}
      table.sort(table_max)
      --printBEZ lmin="..lmin,"lmax="..lmax,"x_min="..x_min,"y_min="..y_min,"x_max="..x_max,"y_max="..y_max)
      --printBEZ max = ",table_max[3])
      --_, mflua.bit = math.frexp(table_max[3])
      --print("BEZ mflua.bit = "..mflua.bit)

      -- clean contours
      valid_curves_c =  _clean_up_contour(char)
      -- clean envelopes 
      valid_curves_e,valid_curves_p,pen_over_knots = _clean_up_envelope(char)
      f:write("\n\\stopMPpage%%%% END EDGES\n")
      --f:write("\n\\stoptext\n")
      res = ''
      f:write("\\startMPpage%%%% BEGIN CURVES\n")

      -- only for TEST !!
   --    if 1>0 then
-- 	 if #valid_curves_c > 0 then valid_curves = valid_curves_c  end
-- 	 if #valid_curves_e > 0 then for i=1, #valid_curves_e do valid_curves[#valid_curves+1] = valid_curves_e[i] end end
-- 	 if #valid_curves_p > 0 then for i=1, #valid_curves_p do valid_curves[#valid_curves+1] = valid_curves_p[i]; valid_curves_p_set[#valid_curves]=true end  end
-- 	 for k,v in pairs(valid_curves) do if  valid_curves_p_set[k]==nil then valid_curves_p_set[k]=false end end
--       end
-- --[

      --
      -- Filters
      --
      if tostring(index) == '87' then 
         -- Filter for W (bug?)
         do
            bezier = valid_curves_c[25]
            p,c1,c2,q,shifted,coll_ind = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5],bezier[6]
            w=string.gmatch(p,"[-0-9.]+"); p={w(),w()}
            p[1]=p[1]+0.25
            p[2]=p[2]+1
            p = string.format("(%s,%s)",p[1],p[2])
            bezier[1] = p
            valid_curves_c[25] = bezier
         end
      end
      if tostring(index) == '119' then 
         -- Filter for w (bug?)
         do
            bezier = valid_curves_c[25]
            p,c1,c2,q,shifted,coll_ind = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5],bezier[6]
            w=string.gmatch(p,"[-0-9.]+"); p={w(),w()}
            p[1]=p[1]+0.25
            p[2]=p[2]+1.0
            p = string.format("(%s,%s)",p[1],p[2])
            bezier[1] = p
            valid_curves_c[25] = bezier
         end
      end
      if tostring(index) == '4' then 
         -- Filter for Ξ but it's a bug of _remove_redundant_segments
         do
            bezier = valid_curves_c[32]
            bezier1 = valid_curves_c[30]
            p = bezier[1]
	    q1 = bezier1[4]
	    q1 = p
            bezier[1] = p
            bezier1[4] = q1
            valid_curves_c[32] = bezier
            valid_curves_c[30] = bezier1
         end
      end
      if tostring(index) == '7' then 
         -- Filter for Υ but it's a conceptual bug 
         do
            bezier = valid_curves_c[1]
            bezier1 = valid_curves_c[27]
            p = bezier[1]
	    q1 = bezier1[4]
	    d = 0.5
            w=string.gmatch(p,"[-0-9.]+"); p={w(),w()}
            p[1]=p[1]+d
            p = string.format("(%s,%s)",p[1],p[2])
            w=string.gmatch(q1,"[-0-9.]+"); q1={w(),w()}
            q1[1]=q1[1]-d
            q1 = string.format("(%s,%s)",q1[1],q1[2])
            bezier[1] = p
            bezier1[4] = q1
            valid_curves_c[1] = bezier
            valid_curves_c[27] = bezier1
         end
      end

      --
      -- adjust boundaries
      --

      --valid_curves_c =_adjust_boundaries(valid_curves_c) 
      --valid_curves_e =_adjust_boundaries_envelope(valid_curves_e) 
      
      -- 
      -- delete redundant pens
      --
      valid_curves_p = _remove_redundant_pen(valid_curves_p)
      

      --
      -- fix coordinates of the pens so we have  continue polygonals
      --
      valid_curves_p =  _fix_pen_coord(valid_curves_p)


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

      -- START HERE WITH THE SWORD !!


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


      --valid_curves = _remove_path(valid_curves,{},{'61','111'})
      --for k,v in pairs(valid_curves_p_set) do print("BEZ set pen curves:k,v="..k, v) end
      --for k,v in pairs(valid_curves_p) do print("BEZ pen curves: k,v="..k, v) end


      --_print_curve_info('2',valid_curves,matrix_inters)

      --
      -- merge segments
      --
      --
      valid_curves = _merge_segments(char,valid_curves,valid_curves_p,valid_curves_p_set)


      --_print_curve_intersections('1',valid_curves,matrix_inters)      
      --
      -- remove redundant segments
      -- 
      valid_curves = _remove_redundant_segments(valid_curves,valid_curves_p,valid_curves_p_set,pen_over_knots)



      --
      -- make rearrange valid_curves for correct intersection
      --
      valid_curves, valid_curves_p_set = _reorder_table(valid_curves,valid_curves_p_set)



      --for k,v in pairs(valid_curves_p_set) do print("BEZ set pen curves:k,v="..k, v) end
      --
      -- re-arrange valid_curves by _split_curve
      -- 
      local temp_valid_curves = {}
      local temp_removed = {}
      local temp_valid_curves_p_set = {}
      for i=1, #valid_curves do
	 --print("BEZ i="..i,"_split_curve")
	 local bez1 = valid_curves[i]
	 local p,c1,c2,q,shifted,coll_ind = bez1[1],bez1[2],bez1[3],bez1[4],bez1[5],bez1[6] 
	 --print("BEZ i="..i, p,c1,c2,q)
	 --for ii,v in ipairs(coll_ind) do print("BEZ i="..i,"ii=" ..ii ,"v="..v) end 
	 --print("BEZ #coll_ind , 1+math.ldexp(1,mflua.bit)", #coll_ind , 1+math.ldexp(1,mflua.bit) )
	 --print("BEZ #coll_ind < 1+math.ldexp(1,mflua.bit)?", #coll_ind < 1+math.ldexp(1,mflua.bit) )
	 --print("BEZ i="..i,"valid_curves_p_set[i]=",valid_curves_p_set[i])
	 --for j,v in ipairs(coll_ind) do print("BEZ i="..i,"j="..j,"v="..v) end 
	 if #coll_ind < 1+math.ldexp(1,mflua.bit) then -- and not(valid_curves_p_set[i]) then 
	    --print(string.format("BEZ i=%s,p=%s,c1=%s,c2=%s,q=%s,shifted=%s,#coll_ind=%s,max=%s",i,p,c1,c2,q,shifted,#coll_ind,1+math.ldexp(1,mflua.bit)))
	    local tab = _split_curve(p,c1,c2,q,shifted,coll_ind)
	    --print("BEZ #tab=" ..#tab)
	    for j=1, #tab do 
	       --print("BEZ #temp_valid_curves=" ..#temp_valid_curves)
	       --print("BEZ tab[j]=" ) table.foreach(tab[j],print)
	       local bez1 = tab[1]
	       p,c1,c2,q,shifted,coll_ind = bez1[1],bez1[2],bez1[3],bez1[4],bez1[5],bez1[6] 
	       temp_valid_curves[#temp_valid_curves+1] = tab[j]
	       --print("BEZ #temp_valid_curves="..#temp_valid_curves,p,c1,c2,q)
	       if valid_curves_p_set[i]==true then temp_valid_curves_p_set[#temp_valid_curves] = true end
	    end
	 else 
	    temp_valid_curves[#temp_valid_curves+1] = {bez1[1],bez1[2],bez1[3],bez1[4],bez1[5]}
	    if valid_curves_p_set[i]==true then temp_valid_curves_p_set[#temp_valid_curves] = true end
	    --temp_valid_curves[i] = {bez1[1],bez1[2],bez1[3],bez1[4],bez1[5]}
	 end
      end
      valid_curves = temp_valid_curves
      valid_curves_p_set = temp_valid_curves_p_set
      temp_removed = {}
      for i, bezier in pairs(valid_curves) do
	 local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
	 local p_i,c1_i,c2_i,q_i,shifted_i =  _coord_str_to_table_num(p,c1,c2,q,shifted)
	 if mflua.modul_vec(p_i,q_i) < mflua.threshold_straight_line then 
	    --print("BEZ i="..i, "is small ",mflua.modul_vec(p_i,q_i))
	    temp_removed[#temp_removed+1] = tostring(i)
	 end
      end
      valid_curves = _remove_path(valid_curves,{},temp_removed)
      valid_curves, valid_curves_p_set = _reorder_table(valid_curves,valid_curves_p_set)


      --
      -- Filter
      --
      --
      if tostring(index) == '104' then 
         -- Filter for h
	 valid_curves[33] = nil
	 valid_curves[139] = nil
	 valid_curves[140] = nil
	 valid_curves[141] = nil
	 valid_curves[142] = nil
	 valid_curves[143] = nil
	 valid_curves[144] = nil
	 valid_curves[110] = nil
	 valid_curves[111] = nil
	 local bez_61 = valid_curves[61]
	 local bez_62 = valid_curves[62]
	 local p_62 = bez_62[1] 
	 local q_61 = bez_61[4] 
	 local p_62,q_61 =  _eval_tonumber(p_62,'(0,0)'), _eval_tonumber(q_61,'(0,0)')
	 p_62 = { (p_62[1]+q_61[1])/2,(p_62[2]+q_61[2])/2 }
	 q_61 = p_62 
	 bez_62[1] = "(" .. tonumber(string.format("%.3f",p_62[1])) .. "," .. tonumber(string.format("%.3f",p_62[2]))..")"
	 bez_61[4] = "(" .. tonumber(string.format("%.3f",q_61[1])) .. "," .. tonumber(string.format("%.3f",q_61[2]))..")"
      end

      if tostring(index) == '109' then 
	 -- filter for m
	 valid_curves[186] = nil
	 valid_curves[187] = nil
	 valid_curves[188] = nil
	 valid_curves[189] = nil
	 valid_curves[190] = nil
	 valid_curves[191] = nil
	 valid_curves[192] = nil
	 valid_curves[193] = nil
	 local bez_71 = valid_curves[71]
	 local bez_72 = valid_curves[72]
	 local p_72 = bez_72[1] 
	 local q_71 = bez_71[4] 
	 local p_72,q_71 =  _eval_tonumber(p_72,'(0,0)'), _eval_tonumber(q_71,'(0,0)')
	 p_72 = { (p_72[1]+q_71[1])/2,(p_72[2]+q_71[2])/2 }
	 q_71 = p_72 
	 bez_72[1] = "(" .. tonumber(string.format("%.3f",p_72[1])) .. "," .. tonumber(string.format("%.3f",p_72[2]))..")"
	 bez_71[4] = "(" .. tonumber(string.format("%.3f",q_71[1])) .. "," .. tonumber(string.format("%.3f",q_71[2]))..")"
	 valid_curves[228] = nil
	 valid_curves[229] = nil
	 valid_curves[230] = nil
	 --valid_curves[231] = NO !
	 valid_curves[232] = nil
	 valid_curves[233] = nil
	 valid_curves[234] = nil
	 valid_curves[243] = nil
	 valid_curves[244] = nil
	 valid_curves[245] = nil
	 valid_curves[246] = nil
	 valid_curves[247] = nil
	 valid_curves[248] = nil
	 valid_curves[249] = nil
	 valid_curves[250] = nil
	 valid_curves[251] = nil
	 valid_curves[252] = nil
	 valid_curves[253] = nil
	 local bez_231 = valid_curves[231]
	 local bez_132 = valid_curves[132]
	 local p_231 = bez_231[1] 
	 local q_132 = bez_132[4] 
	 local p_231,q_132 =  _eval_tonumber(p_231,'(0,0)'), _eval_tonumber(q_132,'(0,0)')
	 p_231 = { (p_231[1]+q_132[1])/2,(p_231[2]+q_132[2])/2 }
	 q_132 = p_231 
	 bez_231[1] = "(" .. tonumber(string.format("%.3f",p_231[1])) .. "," .. tonumber(string.format("%.3f",p_231[2]))..")"
	 bez_132[4] = "(" .. tonumber(string.format("%.3f",q_132[1])) .. "," .. tonumber(string.format("%.3f",q_132[2]))..")"
	 local bez_231 = valid_curves[231]
	 local bez_132 = valid_curves[132]
	 local p_231 = bez_231[1] 
	 local q_132 = bez_132[4] 
	 local p_231,q_132 =  _eval_tonumber(p_231,'(0,0)'), _eval_tonumber(q_132,'(0,0)')
	 p_231 = { (p_231[1]+q_132[1])/2,(p_231[2]+q_132[2])/2 }
	 q_132 = p_231 
	 bez_231[1] = "(" .. tonumber(string.format("%.3f",p_231[1])) .. "," .. tonumber(string.format("%.3f",p_231[2]))..")"
	 bez_132[4] = "(" .. tonumber(string.format("%.3f",q_132[1])) .. "," .. tonumber(string.format("%.3f",q_132[2]))..")"
      end

      if tostring(index) == '110' then 
	 valid_curves[109] = nil
	 valid_curves[110] = nil
	 valid_curves[124] = nil
	 valid_curves[142] = nil
	 valid_curves[143] = nil
	 valid_curves[144] = nil
	 valid_curves[146] = nil
	 valid_curves[147] = nil
	 local bez_61 = valid_curves[61]
	 local bez_60 = valid_curves[60]
	 local p_61 = bez_61[1] 
	 local q_60 = bez_60[4] 
	 local p_61,q_60 =  _eval_tonumber(p_61,'(0,0)'), _eval_tonumber(q_60,'(0,0)')
	 p_61 = { (p_61[1]+q_60[1])/2,(p_61[2]+q_60[2])/2 }
	 q_60 = p_61 
	 bez_61[1] = "(" .. tonumber(string.format("%.3f",p_61[1])) .. "," .. tonumber(string.format("%.3f",p_61[2]))..")"
	 bez_60[4] = "(" .. tonumber(string.format("%.3f",q_60[1])) .. "," .. tonumber(string.format("%.3f",q_60[2]))..")"
      end
      if tostring(index) == '56' then 
	 local bez_21 = valid_curves[21]
	 local bez_22 = valid_curves[22]
	 local p_22 = bez_22[1] 
	 local q_21 = bez_21[4] 
	 local p_22,q_21 =  _eval_tonumber(p_22,'(0,0)'), _eval_tonumber(q_21,'(0,0)')
	 p_22 = {(p_22[1]+q_21[1])/2,(p_22[2]+q_21[2])/2,}
	 q_21 = p_22
	 bez_22[1] ="(" .. tonumber(string.format("%.3f",p_22[1])) .. "," .. tonumber(string.format("%.3f",p_22[2]))..")"
	 bez_21[4] ="(" .. tonumber(string.format("%.3f",q_21[1])) .. "," .. tonumber(string.format("%.3f",q_21[2]))..")"
      end



      --
      -- sanitize knots
      -- 
      valid_curves = _fix_knots(valid_curves)

      valid_curves = _fix_knots_II(valid_curves)


      --
      -- join horiz./vert. segments
      --
      valid_curves = _join_segments(valid_curves,valid_curves_p,valid_curves_p_set)



      --
      -- calculate all intersections
      temp_valid_curves = {}
      temp_removed =  {}
      valid_curves, valid_curves_p_set = _reorder_table(valid_curves,valid_curves_p_set)
      matrix_inters = _calculate_all_intersections(valid_curves)


      local check_loop = true 
      local check_valid_curves_1,check_valid_curves


      -- _print_curve_intersections('1',valid_curves,matrix_inters)
      valid_curves, matrix_inters =  _remove_isolate_path(valid_curves,matrix_inters)




      --for k,v in pairs(valid_curves_p_set) do print("BEZ set pen curves:k,v="..k, v) end	    
      --
      -- Filter
      --
      if tostring(index) == '110' then 
	 -- Filter 
	 valid_curves = _remove_path(valid_curves,matrix_inters,{'149','77'})
      end
      if tostring(index) == '117' then 
	 -- Filter for u
	 --valid_curves = _remove_path(valid_curves,matrix_inters,{'33','112','111','158','150','110'})
	 valid_curves = _remove_path(valid_curves,matrix_inters,{'28'})
      end
      if tostring(index) == '54' then 
	 -- Filter for 6 -- a problem: pen paths and envelope intersect
	 valid_curves = _remove_path(valid_curves,matrix_inters,{'185','229','230'})
      end

      if tostring(index) == '53' then 
	 -- Filter for 5
	 --valid_curves = _remove_path(valid_curves,matrix_inters,{'155','261','4','148','147','6','285'})
	 valid_curves = _remove_path(valid_curves,matrix_inters,{'266','3','153','145','145','141','184'})
      end

      if tostring(index) == '55' then 
         -- Filter for 7 
	 valid_curves = _remove_path(valid_curves,matrix_inters,{'15','108','126'})
      end

      if tostring(index) == '26' then 
         -- Filter for ae
	 valid_curves = _remove_path(valid_curves,matrix_inters,{'311','74','97'})
      end
      if tostring(index) == '27' then 
         -- Filter for oe
	 --valid_curves = _remove_path(valid_curves,matrix_inters,{'311','74','101','76','261'})
	 valid_curves = _remove_path(valid_curves,matrix_inters,{'281','78','101'})
      end

      --
      -- remove redundant paths
      --
       valid_curves,matrix_inters = _remove_redundant_segments(valid_curves,valid_curves_p,valid_curves_p_set,pen_over_knots,matrix_inters)


       valid_curves, matrix_inters =  _remove_redundant_curves(valid_curves,matrix_inters,valid_curves_p_set)

      --
      -- remove isolate path
      -- not necessary because is integrated in _remove_redundant_curves
      -- valid_curves, matrix_inters =  _remove_isolate_path(valid_curves,matrix_inters)



      -- PROBLEMS with s the serifs of s of ccr5 !!!!!!!!!!!!!!!!!
      --  
      -- remove duplicate paths 
      valid_curves, matrix_inters =  _remove_duplicate_path_I(valid_curves,matrix_inters)
      --_print_curve_intersections('1',valid_curves,matrix_inters)      


      -- try to remove pen paths outside the edge structure
      --
      valid_curves,matrix_inters = _open_pen_loop_0(valid_curves,matrix_inters,valid_curves_p_set,char)


      --
      -- try to remove duplicate pen path 
      --
      valid_curves,matrix_inters = _remove_duplicate_pen_path(valid_curves,matrix_inters,valid_curves_p_set)
      --
      -- remove isolate path
      valid_curves, matrix_inters =  _remove_isolate_path(valid_curves,matrix_inters)


      -- _print_curve_intersections('1',valid_curves,matrix_inters)
      --_print_curve_info('2',valid_curves,matrix_inters)
      --_print_curve_intersections('1',valid_curves,matrix_inters)

      --
      -- pending paths I
      --
      check_loop_cnt = 1
      check_loop = true 
      check_valid_curves = 0 ; for _,_ in pairs(valid_curves) do check_valid_curves = check_valid_curves +1 end
      while check_loop do 
      	 valid_curves, matrix_inters =  _remove_pending_path_I(valid_curves,matrix_inters)
      	 check_valid_curves_1 = 0;for _,_ in pairs(valid_curves) do check_valid_curves_1 = check_valid_curves_1 +1 end
      	 if (check_valid_curves ~= check_valid_curves_1) then 
      	    check_valid_curves = check_valid_curves_1
      	 else check_loop = false 
      	 end
	 --if check_loop_cnt > 0 then       check_loop = false end  check_loop_cnt = check_loop_cnt + 1 
      end 

      --
      -- Filters
      --
      if tostring(index) == '74' then 
	 -- Filter for J
	 valid_curves = _remove_path(valid_curves,matrix_inters,{'132','131','184','186','188'})
      end



      --_print_curve_info('PRE open_loop',valid_curves,matrix_inters)
      
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


      --
      -- Filter 
      --
      if tostring(index) == '12' then 
         -- Filter for ﬁ ligature
	 valid_curves = _remove_path(valid_curves,matrix_inters,{'81','12'})
      end
      if tostring(index) == '14' then 
         -- Filter for ﬃ ligature
	 valid_curves = _remove_path(valid_curves,matrix_inters,{'148','21'})
      end
      if tostring(index) == '55' then 
         -- Filter for 7 
	 --valid_curves = _remove_path(valid_curves,matrix_inters,{'113'})
      end
      --
      -- Filter 
      --
      if tostring(index) == '37' then 
         -- Filter for % 
	 valid_curves = _remove_path(valid_curves,matrix_inters,{'308','344'})
      end


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
      --
      -- remove duplicate paths 
      --
      valid_curves, matrix_inters =  _remove_duplicate_path_I(valid_curves,matrix_inters)


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
      -- loops made by pen path
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



      -- -- next we need
      -- -- pending paths II 
      -- --
      check_loop_cnt = 1
      check_loop = true 
      check_valid_curves = 0 ; for _,_ in pairs(valid_curves) do check_valid_curves = check_valid_curves +1 end
      while check_loop do 
      	 valid_curves, matrix_inters =  _remove_pending_path_II(valid_curves,matrix_inters)
      	 check_valid_curves_1 = 0;for _,_ in pairs(valid_curves) do check_valid_curves_1 = check_valid_curves_1 +1 end
      	 if (check_valid_curves ~= check_valid_curves_1) then 
      	    check_valid_curves = check_valid_curves_1
      	 else check_loop = false 
      	 end
	 --if check_loop_cnt > 1 then       check_loop = false end  check_loop_cnt = check_loop_cnt + 1 
      end 



      --
      -- Filter  ?????
      --
      if tostring(index) == '100' then 
         -- Filter 
	 valid_curves = _remove_path(valid_curves,matrix_inters,{'100','101'})
      end
      if tostring(index) == '109' then 
	 -- Filter  for m
	 valid_curves = _remove_path(valid_curves,matrix_inters,{'148','126','130','152'})
      end
      if tostring(index)=='110' then 
	 -- Filter for n
	 valid_curves=_remove_path(valid_curves,matrix_inters,{'74','138','140','76'})
      end


      --
      -- remove curve  overlaps 
      --
      valid_curves,matrix_inters = _remove_overlaps(valid_curves,matrix_inters,valid_curves_p_set)


      --_print_curve_intersections('2',valid_curves,matrix_inters)
      --valid_curves = _remove_path(valid_curves,matrix_inters,{'32'})
      --_print_curve_info('2',valid_curves,matrix_inters)


      --
      -- a fix for an error found on ccr5 y 
      --
      valid_curves,matrix_inters = _fix_intersection_bug(valid_curves,matrix_inters)

      local std_mflua_threshold_join_curves = mflua.threshold_join_curves

      -- Filter for 5
      if tostring(index)=='53' then 
	 valid_curves=_remove_path(valid_curves,matrix_inters,{'192'})
	 local bez_127 = valid_curves[127]
	 local bez_128 = valid_curves[128]
	 local p_128 = bez_128[1] 
	 local q_127 = bez_127[4] 
	 local p_128,q_127 =  _eval_tonumber(p_128,'(0,0)'), _eval_tonumber(q_127,'(0,0)')
	 p_128 = { (p_128[1]+q_127[1])/2,(p_128[2]+q_127[2])/2 }
	 q_127 = p_128 
	 bez_128[1] = "(" .. tonumber(string.format("%.3f",p_128[1])) .. "," .. tonumber(string.format("%.3f",p_128[2]))..")"
	 bez_127[4] = "(" .. tonumber(string.format("%.3f",q_127[1])) .. "," .. tonumber(string.format("%.3f",q_127[2]))..")"
	 --
	 local BEG,END,REMOVE = 11,74,204
	 valid_curves=_remove_path(valid_curves,matrix_inters,{tostring(REMOVE)})
	 local bez_BEG = valid_curves[BEG]
	 local bez_END = valid_curves[END]
	 local p_BEG = bez_BEG[1] 
	 local q_END = bez_END[4] 
	 local p_BEG,q_END =  _eval_tonumber(p_BEG,'(0,0)'), _eval_tonumber(q_END,'(0,0)')
	 p_BEG = { (p_BEG[1]+q_END[1])/2,(p_BEG[2]+q_END[2])/2 }
	 q_END = p_BEG 
	 bez_BEG[1] = "(" .. tonumber(string.format("%.3f",p_BEG[1])) .. "," .. tonumber(string.format("%.3f",p_BEG[2]))..")"
	 bez_END[4] = "(" .. tonumber(string.format("%.3f",q_END[1])) .. "," .. tonumber(string.format("%.3f",q_END[2]))..")"
	 --
	 local BEG,END,REMOVE = 64,62,63
	 valid_curves=_remove_path(valid_curves,matrix_inters,{tostring(REMOVE)})
	 local bez_BEG = valid_curves[BEG]
	 local bez_END = valid_curves[END]
	 local p_BEG = bez_BEG[1] 
	 local q_END = bez_END[4] 
	 local p_BEG,q_END =  _eval_tonumber(p_BEG,'(0,0)'), _eval_tonumber(q_END,'(0,0)')
	 p_BEG = { (p_BEG[1]+q_END[1])/2,(p_BEG[2]+q_END[2])/2 }
	 q_END = p_BEG 
	 bez_BEG[1] = "(" .. tonumber(string.format("%.3f",p_BEG[1])) .. "," .. tonumber(string.format("%.3f",p_BEG[2]))..")"
	 bez_END[4] = "(" .. tonumber(string.format("%.3f",q_END[1])) .. "," .. tonumber(string.format("%.3f",q_END[2]))..")"
	 --
	 local BEG,END,REMOVE = 52,96,277
	 valid_curves=_remove_path(valid_curves,matrix_inters,{tostring(REMOVE)})
	 local bez_BEG = valid_curves[BEG]
	 local bez_END = valid_curves[END]
	 local p_BEG = bez_BEG[1] 
	 local q_END = bez_END[4] 
	 local p_BEG,q_END =  _eval_tonumber(p_BEG,'(0,0)'), _eval_tonumber(q_END,'(0,0)')
	 p_BEG = { (p_BEG[1]+q_END[1])/2,(p_BEG[2]+q_END[2])/2 }
	 q_END = p_BEG 
	 bez_BEG[1] = "(" .. tonumber(string.format("%.3f",p_BEG[1])) .. "," .. tonumber(string.format("%.3f",p_BEG[2]))..")"
	 bez_END[4] = "(" .. tonumber(string.format("%.3f",q_END[1])) .. "," .. tonumber(string.format("%.3f",q_END[2]))..")"
	 --
	 BEG,END,REMOVE = 119,82,118
	 valid_curves=_remove_and_join_curve(BEG,END,REMOVE,valid_curves,matrix_inters,2) 
      end


      -- Filter for A
      if tostring(index)=='65' then valid_curves=_remove_path(valid_curves,matrix_inters,{'26','33'})end

      -- Filter for V
      if tostring(index)=='86' then valid_curves=_remove_path(valid_curves,matrix_inters,{'19'})end

      -- Filter for W
      if tostring(index)=='87' then valid_curves=_remove_path(valid_curves,matrix_inters,{'41','48','55'})end

      -- Filter for r
      if tostring(index)=='114' then 
	 valid_curves=_remove_path(valid_curves,matrix_inters,{'50','147'})
	 local bez_60 = valid_curves[60]
	 local bez_93 = valid_curves[93]
	 local p_93 = bez_93[1] 
	 local q_60 = bez_60[4] 
	 local p_93,q_60 =  _eval_tonumber(p_93,'(0,0)'), _eval_tonumber(q_60,'(0,0)')
	 p_93 = { (p_93[1]+q_60[1])/2,(p_93[2]+q_60[2])/2 }
	 q_60 = p_93 
	 bez_93[1] = "(" .. tonumber(string.format("%.3f",p_93[1])) .. "," .. tonumber(string.format("%.3f",p_93[2]))..")"
	 bez_60[4] = "(" .. tonumber(string.format("%.3f",q_60[1])) .. "," .. tonumber(string.format("%.3f",q_60[2]))..")"
	 local bez_69 = valid_curves[69]
	 local bez_51 = valid_curves[51]
	 local p_51 = bez_51[1] 
	 local q_69 = bez_69[4] 
	 local p_51,q_69 =  _eval_tonumber(p_51,'(0,0)'), _eval_tonumber(q_69,'(0,0)')
	 p_51 = { (p_51[1]+q_69[1])/2,(p_51[2]+q_69[2])/2 }
	 q_69 = p_51 
	 bez_51[1] = "(" .. tonumber(string.format("%.3f",p_51[1])) .. "," .. tonumber(string.format("%.3f",p_51[2]))..")"
	 bez_69[4] = "(" .. tonumber(string.format("%.3f",q_69[1])) .. "," .. tonumber(string.format("%.3f",q_69[2]))..")"

      end


      -- Filter for v
      if tostring(index)=='118' then valid_curves=_remove_path(valid_curves,matrix_inters,{'20','29',})end

      -- Filter for w
      if tostring(index)=='119' then valid_curves=_remove_path(valid_curves,matrix_inters,{'39','46','53'})end

      -- Filter for y
      if tostring(index)=='121' then valid_curves=_remove_path(valid_curves,matrix_inters,{'44','36'})end
      if tostring(index)=='121' then mflua.threshold_join_curves = 0.16 end

      -- Filter for m
      if tostring(index)=='109' then valid_curves=_remove_path(valid_curves,matrix_inters,{'59','60'})end
      if tostring(index)=='109' then mflua.threshold_join_curves = 0.05 end

      -- Filter for AE
      if tostring(index)=='29' then valid_curves=_remove_path(valid_curves,matrix_inters,{'44'})end

      -- Filter for Greek Upper Lambda
      if tostring(index)=='3' then valid_curves=_remove_path(valid_curves,matrix_inters,{'23','27'})end



      -- Filter for Spanish open exclamation point ¡, only if ligs >1
      if tostring(index)=='60' then 
	 valid_curves=_remove_path(valid_curves,matrix_inters,{'145','183'})
	 local bez_147 = valid_curves[147]
	 local bez_180 = valid_curves[180]
	 local p_147 = bez_147[1] 
	 local q_180 = bez_180[4] 
	 local p_147,q_180 =  _eval_tonumber(p_147,'(0,0)'), _eval_tonumber(q_180,'(0,0)')
	 p_147 = { (p_147[1]+q_180[1])/2,(p_147[2]+q_180[2])/2 }
	 q_180 = p_147 
	 bez_147[1] = "(" .. tonumber(string.format("%.3f",p_147[1])) .. "," .. tonumber(string.format("%.3f",p_147[2]))..")"
	 bez_180[4] = "(" .. tonumber(string.format("%.3f",q_180[1])) .. "," .. tonumber(string.format("%.3f",q_180[2]))..")"
      end

      --print("BEZ DUMP char "..index)
      --_dump(valid_curves,matrix_inters,'envelope-'..tostring(index)..'.lua')



      -- Path orientation nodes of a closed single path are ordered; if traversing a path following
      -- the order of its nodes results in an anti-clockwise turn(s), the path is positively
      -- oriented, if it results in a clockwise turn(s), its orientation is negative; number of
      -- turns (signed) is called a turning number (METAFONT) or a winding number (POST-
      -- SCRIPT); the operators fill and clip make use of a winding number, the operators
      -- eofill and eoclip ignore it.
     --
      -- we build the cycles
      -- With turning number =1  we choose the orientation of MF (anti-clockwise)
      -- With turning number =-1  we choose the reverse orientation of MF (clockwise)
      -- eg.  that one used by svg
      local tn=-1
      valid_curves,matrix_inters,cycles = _build_cycles(valid_curves,matrix_inters, tn)
      -- restore default value
      mflua.threshold_join_curves = std_mflua_threshold_join_curves

      
      -- simplification 
      --valid_curves,matrix_inters,cycles =  _simplify_cycles(valid_curves,matrix_inters, cycles,tostring(index))



      --print('BEZ --------------------------')
      --for i,c in pairs(cycles) do print('BEZ cycle='..i) table.foreach(c,print) end

      if not(mflua.svg==nil) and mflua.svg.enabled==true then
	 -- store the resul into mflua.svg.char[index].data=trunk 
	 -- where index = tostring( char_code + 256*char_ext )
	 svg_glyph_index = tostring( char['index'] ) 
	 trunk,raw = _get_svg_glyph(valid_curves,matrix_inters,char,cycles,tfm)
	 mflua.svg.char[svg_glyph_index].data=trunk 
	 if mflua.svg.enabled_raw==true then 
	    print( "BEZ index="..index,(mflua.svg.output_dir or '.') .. '/' .. (mflua.svg.char[svg_glyph_index].glyph_name or 'SVGOUT')..'-raw.svg')
	    local svg_f=io.open((mflua.svg.output_dir or '.') .. '/' .. (mflua.svg.char[svg_glyph_index].glyph_name or 'SVGOUT')..'-raw.svg','w')
	    svg_f:write(raw)
	    svg_f:close()
	 end
      end



      --print("BEZ DUMP char "..index)
      --_dump(valid_curves,matrix_inters,cycles,'envelope-'..tostring(index)..'.lua')


   --[====[XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX>         


<XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX]====]--
      --
      -- DRAW THEM 
      --
      print("BEZ DRAW")
      local drawed_point =  {}
      local lp,lq
      for i,bezier in pairs(valid_curves) do
	 local p,c1,c2,q,shifted = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5]
	 --print("BEZ i="..i)
	 --print(string.format("BEZ draw p=%s,c1=%s,c2=%s,q=%s, shifted=%s",p,c1,c2,q,tostring(shifted)))
	 f:write(string.format("%%i=%s\n",i))
	 f:write(string.format("path p[]; p1:=%s .. controls %s and %s .. %s;\n",
			       _eval(p,shifted),_eval(c1,shifted),_eval(c2,shifted),_eval(q,shifted)))
	 f:write("drawoptions(withcolor (0,0,0)  withpen pencircle scaled 0.1pt);\n")
	 lp = string.format("(%s+(%s,%s))",_eval(p,shifted),1.2+math.random(1000)/500,1.2+math.random(1000)/500)
	 if drawed_point[lp] == nil then 
	    local A,B = 1+math.random(1000)/500,1+math.random(1000)/500
	    local C,D = 1+math.random(1000)/500,1+math.random(1000)/500
	    f:write(string.format("draw %s -- (%s+(%s,%s)) withcolor blue;\n",_eval(p,shifted),_eval(p,shifted),A,B))
	    f:write(string.format("draw %s -- (%s+(-%s,-%s)) withcolor green ;\n",_eval(q,shifted),_eval(q,shifted),C,D))
	    f:write(string.format("label( \"BEG %s\", (%s+(%s,%s)) );\n",i,_eval(p,shifted),0.1+A,0.1+B))
	    f:write(string.format("label( \"END %s\", (%s+(-%s,-%s)) );\n",i,_eval(q,shifted),0.1+C,0.1+D))
	    drawed_point[lp] = 1
	 else
	    drawed_point[lp] = drawed_point[lp] + 1
	    local s = drawed_point[lp]
	    local A,B = 1+math.random(1000)/500,1+math.random(1000)/500
	    local C,D = 1+math.random(1000)/500,1+math.random(1000)/500
	    lp = string.format("(%s+(1.5,1.5)+%s*(%s,%s))",_eval(p,shifted),s,A,B)
	    lq = string.format("(%s+(-1.5,-1.5)+%s*(-%s,-%s))",_eval(q,shifted),s,C,D)
	    f:write(string.format("draw %s -- %s withcolor blue;\n",_eval(p,shifted),lp))
	    f:write(string.format("draw %s -- %s withcolor green;\n",_eval(q,shifted),lq))
	    f:write(string.format("label( \"BEG %s\", %s );\n",i,lp))
	    f:write(string.format("label( \"END %s\", %s );\n",i,lq))
	 end
	 f:write("drawoptions(withcolor (0,0,0)  withpen pencircle scaled 0.02pt);ahlength:=0.2;\n")
	 f:write(string.format("draw p1;\n"))
	 --f:write("drawoptions(withcolor (0,0,1)  withpen pencircle scaled 0.02pt);ahlength :=  0.25;\n")
	 --f:write(string.format("drawarrow %s --%s ;\n",_eval(p,shifted),_eval(c1,shifted)))
	 --f:write("drawoptions(withcolor (1,0,0)  withpen pencircle scaled 0.02pt);ahlength :=  0.25;\n")
	 --f:write(string.format("drawarrow %s --%s ;\n",_eval(q,shifted),_eval(c2,shifted)))
      end
      f:write("\n\\stopMPpage%%%% END CURVES\n")
   end
   f:write("\n\\stoptext\n")
   f:close()
   if not(mflua.svg==nil) and mflua.svg.enabled==true then
      -- TODO FIX the descender
      --
      --
      mflua.svg.hkerns,mflua.svg.vkerns = _svg_kern_and_lig(chartable,t,tfm)
      trunk = _store_svg_font(tfm)
      local svg_f=io.open((mflua.svg.output_dir or '.') .. '/' .. (mflua.svg.filename or 'SVGOUT')..'.svg','w')
      svg_f:write(trunk)
      svg_f:close()
   end
   return 0
end

end_program()


