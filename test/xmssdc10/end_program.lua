print("\n······· mflua_end_program says: 'Hello world!' ·······")


local function _eval(q,offset)
   local qx,qy,xo,yo
   local w 
   w=string.gmatch(q,"[-0-9.]+"); qx,qy=w(),w()
   w=string.gmatch(offset,"[-0-9.]+"); xo,yo=w(),w()
   return string.format("(%s,%s)",qx+xo,qy+yo)
end

local function _eval_neg(q,offset)
   local qx,qy,xo,yo
   local w 
   w=string.gmatch(q,"[-0-9.]+"); qx,qy=w(),w()
   w=string.gmatch(offset,"[-0-9.]+"); xo,yo=w(),w()
   return string.format("(%s,%s)",qx-xo,qy-yo)
end


local function _eval_tonumber(q,offset)
   local qx,qy,xo,yo
   local w 
   w=string.gmatch(q,"[-0-9.]+"); qx,qy=w(),w()
   w=string.gmatch(offset,"[-0-9.]+"); xo,yo=w(),w()
   return {tonumber(qx+xo),tonumber(qy+yo)}
end

local function  _neighbourhood_inside(x,y,radious,func)
   local r = math.floor(radious+0.5)
   local P = func
   local res = true
   for Y=y-r,y+r do
      for X=x-r,x+r do
	 res = res and P(X,Y)
      end
   end
   return res
end

local function  _neighbourhood_outside(x,y,radious,func)
   local r = math.floor(radious+0.5)
   local P = func
   local res = false
   for Y=y-r,y+r do
      for X=x-r,x+r do
	 res = res or P(X,Y)
      end
   end
   return not(res)
end



local function _coord_table_to_str(p,c1,c2,q,shifted)
   local p,c1,c2,shifted=p,c1,c2,q,shifted
   if shifted==nil then shifted={0,0} end
   p = string.format("(%s,%s)",p[1],p[2]) 
   c1 = string.format("(%s,%s)",c1[1],c1[2])
   c2 = string.format("(%s,%s)",c2[1],c2[2])
   q = string.format("(%s,%s)",q[1],q[2])
   shifted = string.format("(%s,%s)",shifted[1],shifted[2])
   return p,c1,c2,q,shifted
end

local function _pen_normalizer(pen,offset,flag)
   -- This particular pen path 
   -- has not c1 and c2
   --
   local p,q,res
   local _t={}
   if flag==true then 
      -- adapt the pen to a p,c1,c2,q,shifted,res
      for m,curve in ipairs(pen) do
	 p,q,res = curve[1],curve[2],curve[3]
	 _t[#_t+1]={_eval(p,offset),nil,nil,_eval(q,offset),'(0,0)',res}
      end       
   else
      -- take standard bezier and return a compressed form p,q,res
      -- with a *NEGATIVE* offset
      for m,curve in ipairs(pen) do
	 p,q,res = curve[1],curve[4],curve[6]
	 _t[#_t+1]={_eval_neg(p,offset),nil,nil,_eval_neg(q,offset),res}
      end
   end
   return _t
end




local function _draw_curve_tostring(p,c1,c2,q,shifted,options)
   local opt = options
   if opt == nil then opt="drawoptions(withcolor (1,0,1)  withpen pencircle scaled 1.5pt);\n" end
   return opt..string.format("draw (%s .. controls %s and %s .. %s) shifted %s;\n",
			     p,c1,c2,q,shifted)
end




local function _decasteljau(p,c1,c2,q,t)
   local b00,b01,b02,b03 =  {},{},{},{}
   local b10,b11,b12=  {},{},{}
   local b20,b21=  {},{}
   local b30=  {}
   local t = tonumber(t)
   local T=1-t
   --
   -- de Casteljau Algorithm
   -- 
   --print(string.format("BEZ p=(%s,%s)",p[1],p[2]))
   --print(string.format("BEZ c1=(%s,%s)",c1[1],c1[2]))
   --print(string.format("BEZ c2=(%s,%s)",c2[1],c2[2]))
   --print(string.format("BEZ q=(%s,%s)",q[1],q[2]))

   b00={tonumber(p[1]),tonumber(p[2]) }
   b01={tonumber(c1[1]),tonumber(c1[2]) } 
   b02={tonumber(c2[1]),tonumber(c2[2]) } 
   b03={tonumber(q[1]),tonumber(q[2]) } 

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

local function _get_function_PXY(pixels)
   local P = pixels
   return function(X,Y)
	     if P[Y]==nil then 
		return false 
	     elseif P[Y][X]==nil then 
		return false
	     else
		return true
	     end   
	  end
end


local function pixel_map(edges)
   --
   --
   --
   if edges == nil then return nil end 
   local pixel = {}
   --print(edges[1][2],edges[1][3])
   local y = edges[1][1]
   local x_off,y_off = edges[1][2],edges[1][3]
   --print("BEZ offset=",x_off,y_off)
   for row,v in ipairs(y) do 
      pixel[tonumber(v[1])]={}
      local xq,xr=v[2],v[3]
      for j=1,#xr-1 do
	 local xb,xe = xr[j][1],xr[j+1][1]
	 local xsb,xse = xr[j][3],xr[j+1][3]
	 if xsb>0 then 
	    for x=xb,xe do
	       pixel[tonumber(v[1])-y_off][x-x_off]=true
	    end
	 end
      end
   end
   return pixel
end


local function _decasteljau_bisection(curve,array,level,time)
   --
   --
   --

   if level==32 then return array end
   level=level+1

   local p,c1,c2,q =  curve[1],curve[2],curve[3],curve[4]
   local x,y,p0,c10,c20,q0,c11,c21,q1 = _decasteljau(p,c1,c2,q,1/2)
   local p1=q0
   local d =0.0
   --print("BEZ #array="..#array,string.format("p=(%s,%s),q=(%s,%s),(x,y)=(%s,%s)",p[1],p[2],q[1],q[2],x,y))
   if math.floor(p[1]+d)==math.floor(x+d) and math.floor(p[2]+d)==math.floor(y+d) then
      --print("BEZ ===> p",x,y,level,#array)
      return array
   end
   if math.floor(q[1]+d)==math.floor(x+d) and math.floor(q[2]+d)==math.floor(y+d) then
      --print("BEZ ===> q",x,y,level,#array)
      return array
   end

   array[#array+1]={x,y,(time[1]+time[2])/2}
   --print("array["..#array.."]=",array[#array][1],array[#array][2])
   array=_decasteljau_bisection({p0,c10,c20,q0},array,level,{time[1],(time[1]+time[2])/2})
   array=_decasteljau_bisection({p1,c11,c21,q1},array,level,{(time[1]+time[2])/2,time[2]})
   return array
   --_coord_table_to_str(p,c1,c2,q,shifted)
end


local function _remove_useless_curves(curves,pixels,flag)
   --
   -- Remove the curves that are completely inside or outside 
   -- the edge structure. Note that some curves are near the frontier, 
   -- and they are not removed

   --print("BEZ _remove_useless_curves")
   local p,c1,c2,q,shifted
   local _curves = {}
   local array,additional_array
   local _t={};_t[#_t+1]=''
   -- P(X,Y)= true iff pixels[Y]~=nil and pixels[Y][X]~=nil
   local P=_get_function_PXY(pixels)
   for i,curve in ipairs(curves) do 
      array,additional_array={},{}
      
      p,c1,c2,q,shifted =curve[1],curve[2],curve[3],curve[4],curve[5]
      --print("BEZ p,c1,c2,q,shifted=",p,c1,c2,q,shifted)
      -- straight line 
      if c1==nil and c2==nil then
	 c1,c2 = p,q
      end
      --print("BEZ i",i,p,q,shifted)
      p,c1,c2,q = 
	 _eval_tonumber(p,shifted),_eval_tonumber(c1,shifted),_eval_tonumber(c2,shifted),_eval_tonumber(q,shifted)
      array[#array+1]={p[1],p[2],0}
      array = _decasteljau_bisection({p,c1,c2,q},array,0,{0,1})
      array[#array+1]={q[1],q[2],1}
      local d =0.0
      local delete_curve = false

      --very small curve
      if(math.floor(d+p[1])==math.floor(d+q[1])) and (math.floor(d+p[2])==math.floor(d+q[2]))then
	    delete_curve=true
      end

      -- sort array by time
      table.sort(array,function(e1,e2) return e1[3]<e2[3] end)

      -- curves that for sure  are inside 
      if delete_curve==false then
	 for i,v in ipairs(array) do
	    local X,Y = math.floor(d+v[1]),math.floor(d+v[2])
	    if pixels[Y-1] ~= nil and pixels[Y] ~=nil and pixels[Y+1]~=nil then
	       local cond1,cond2,cond3 = 
		  (P(X-1,Y-1) and P(X,Y-1) and P(X+1,Y-1)),
	       (P(X-1,Y) and P(X,Y) and P(X+1,Y)), 
	       (P(X-1,Y+1) and P(X,Y+1) and P(X+1,Y+1)) ;
	       if  cond1 and cond2 and cond3 then
		  -- OK 
		  delete_curve = true
	       else
		  delete_curve = false
		  break
	       end 
	    else
	       -- X Y is near the frontier (inside or outside), or on the frontier 
	       delete_curve = false
	       break 
	    end
	 end
      end
      -- curves that for sure  are outside
      if delete_curve==false then
	 local outside_counter = 0
	 for i,v in ipairs(array) do
	    local X,Y = math.floor(d+v[1]),math.floor(d+v[2])
	    --print("BEZ X,Y",X,Y)
	    -- must be simplified 
	    local cond1,cond2,cond3 =
	       (pixels[Y-1]==nil) or ((pixels[Y-1]~=nil) and (not(P(X-1,Y-1)) and not(P(X,Y-1)) and not(P(X+1,Y-1)))),
	    (pixels[Y]  ==nil) or ((pixels[Y]  ~=nil) and (not(P(X-1,Y)) and not(P(X,Y)) and not(P(X+1,Y)))),
	    (pixels[Y+1]==nil) or ((pixels[Y+1]~=nil) and (not(P(X-1,Y+1)) and not(P(X,Y+1)) and not(P(X+1,Y+1))))
	    if cond1 and cond2 and cond3 then
	       outside_counter=outside_counter+1
	    end
	 end
	 --print("BEZ,#array,outside_counter",#array,outside_counter)
	 if outside_counter == #array then
	    delete_curve = true
	 end
      end      

      -- curves from the pen that are mostly outside
      if delete_curve==false and flag=='pen' then
	 local X,Y = math.floor(d+p[1]),math.floor(d+p[2])
	 -- must be simplified 
	 local cond1,cond2,cond3 =
	    (pixels[Y-1]==nil) or ((pixels[Y-1]~=nil) and (not(P(X-1,Y-1)) and not(P(X,Y-1)) and not(P(X+1,Y-1)))),
	 (pixels[Y]  ==nil) or ((pixels[Y]  ~=nil) and (not(P(X-1,Y)) and not(P(X,Y)) and not(P(X+1,Y)))),
	 (pixels[Y+1]==nil) or ((pixels[Y+1]~=nil) and (not(P(X-1,Y+1)) and not(P(X,Y+1)) and not(P(X+1,Y+1))))
	 if cond1 and cond2 and cond3 then
	    delete_curve = true
	 end
	 if delete_curve==false then
	    X,Y = math.floor(d+q[1]),math.floor(d+q[2])
	    cond1,cond2,cond3 =
	       (pixels[Y-1]==nil) or ((pixels[Y-1]~=nil) and (not(P(X-1,Y-1)) and not(P(X,Y-1)) and not(P(X+1,Y-1)))),
	    (pixels[Y]  ==nil) or ((pixels[Y]  ~=nil) and (not(P(X-1,Y)) and not(P(X,Y)) and not(P(X+1,Y)))),
	    (pixels[Y+1]==nil) or ((pixels[Y+1]~=nil) and (not(P(X-1,Y+1)) and not(P(X,Y+1)) and not(P(X+1,Y+1))))
	    if cond1 and cond2 and cond3 then
	       delete_curve = true
	    end
	 end
      end


      -- curves from the pen that have p inside and q on the border (or viceversa)
      if delete_curve==false and flag=='pen' then
	 -- Why d=0.5 ?
	 --
	 -- TODO: not delete but replace  with an appropriate subcurve
	 --
	 local X,Y,cond1,cond2
	 d=0.5
	 X,Y = math.floor(d+p[1]),math.floor(d+p[2])
	 cond1 = _neighbourhood_inside(X,Y,1,P)
	 d=0
	 X,Y = math.floor(d+p[1]),math.floor(d+p[2])
	 cond2 = _neighbourhood_inside(X,Y,1,P)
	 if cond1 and cond2  then
	    -- OK 
	    delete_curve = true
	    --print("BEZ (p) DELETE i="..i,X,Y,p[1],p[2])
	 end
	 d=0.5
	 X,Y = math.floor(d+q[1]),math.floor(d+q[2])
	 cond1 = _neighbourhood_inside(X,Y,1,P)
	 d=0
	 X,Y = math.floor(d+q[1]),math.floor(d+q[2])
	 cond2 = _neighbourhood_inside(X,Y,1,P)
	 if cond1 and cond2  then
	    -- OK 
	    delete_curve = true
	    --print("BEZ (p) DELETE i="..i,X,Y,p[1],p[2])
	 end
      end


      if delete_curve==false and flag=='pen' then
	 -- not(P(x,y)) means P(x,y) is outside the pixels map
	 -- Why d=0.5 ?
	 d=0.5
	 local X,Y = math.floor(d+p[1]),math.floor(d+p[2])
	 if  ( not(P(X,Y-1)) ) and (not(P(X-1,Y)) and not(P(X,Y)) and not(P(X+1,Y)))    and ( not(P(X,Y+1)) ) then
	    delete_curve=true
	 end
	 X,Y = math.floor(d+q[1]),math.floor(d+q[2])
	 if  ( not(P(X,Y-1)) )	 and (not(P(X-1,Y)) and not(P(X,Y)) and not(P(X+1,Y)))   and ( not(P(X,Y+1)) ) then 
	    delete_curve=true
	 end
      end

      
      -- cut a curve to delete the part that is inside or outside 
      -- 
      if delete_curve==false  then
	 local initial,drop,keep=-1,0,1
	 local state =initial
	 d=0
	 local X,Y,time = math.floor(d+array[1][1]),math.floor(d+array[1][2]),0
	 local time_array = {}
	 --print("BEZ i="..i)
	 for i,v in ipairs(array) do
	    X,Y,time = math.floor(d+v[1]),math.floor(d+v[2]),v[3]
	    --print("BEZ X,Y,time=",X,Y,time)
	    if _neighbourhood_inside(X,Y,2,P) or _neighbourhood_outside(X,Y,2,P) then 
	       --X,Y is inside or outside, new state will be "drop"
	       --print("BEZ next is a drop ,state=", state, "#time_array"..#time_array)
	       if state == initial then 
		  state=drop
	       elseif state == drop then 
		  -- do nothing i.e. eat it
	       else --  a transition from "keep" to "drop"
		  time_array[#time_array+1]={v[1],v[2],time} -- end
		  state = drop 
	       end
	    else 
	       --print("BEZ next is a keep ,state=", state, "#time_array"..#time_array)
	       -- X,Y is on the frontier, new state will be "keep"
	       if state == initial then
		  state=keep
		  time_array[#time_array+1]={v[1],v[2],time} -- start
	       elseif state == keep then 
		  -- do nothing, stay here
	       else -- a transition from  "drop" to "keep"
		  time_array[#time_array+1]={v[1],v[2],time} -- start
		  state = keep 
	       end
	    end 
	    end -- for i,v in ipairs(array) 
	 --print("BEZ #time_array ="..#time_array)
	 if state == keep then
	    time_array[#time_array+1]={q[1],q[2],1} -- end
	 end
	 --print("BEZ #time_array ="..#time_array)
	 --print("BEZ time_array[1][3], time_array[2][3]",time_array[1][3], time_array[2][3])

	 if #time_array > 1 and not(time_array[1][3]==0 and time_array[2][3]==1) then 
	    if math.mod(#time_array,2)~=0 then
	       print("! Error on splitting a curve:found an open time interval",#time_array)
	    else
	       --print("BEZ delete_curve",time_array[1][3],time_array[2][3])
	       delete_curve = true 
	       --
	       --                               ti<=t'<=1    
	       --                 ┏━━━━━━━━━━━━━━━━━━━━━━►
	       -- p....╳╳╳╳╳╳╳╳╳╳╳▉▉▉▉▉▉▉▉▉▉╳╳╳╳╳╳╳╳╳╳...q
	       --      ●   drop   ●  keep  ●  drop   ●
	       -- 0                ti       tii           1 

	       --  0<=t'<=(tii-ti)/(1-ti)
	       -- ◄━━━━━━━━━┓
	       --  ▉▉▉▉▉▉▉▉▉▉╳╳╳╳╳╳╳╳╳╳...q
	       --  ●  keep  ●  drop   ●
	       -- 0        tii        1 
	       --local function _e(arg) return _eval(mflua.number_to_string_round5(arg),'(0,0)') end
	       --print("BEZ p,c1,c2,q=",_e(p),_e(c1),_e(c2),_e(q))
	       for i=1,#time_array,2 do
		  --print("BEZ ----")
		  local ti,tii=time_array[i][3],time_array[i+1][3]
		  local P,C1,C2,Q
		  -- right part
		  _,_,_,_,_, P,C1,C2,Q = _decasteljau(p,c1,c2,q,ti)
		  --print("BEZ P,C1,C2,Q=",_e(P),_e(C1),_e(C2),_e(Q))
		  --_,_,_P,C1,C2,Q,_,_,_ = _decasteljau(P,C1,C2,Q,(tii-ti)/(1-ti))
		  -- left part of the right part
		  _,_,_P,C1,C2,Q = _decasteljau(P,C1,C2,Q,(tii-ti)/(1-ti))
		  --print("BEZ i, ti, tii,P,C1,C2,Q=",(i+1)/2,ti,(tii-ti)/(1-ti), _e(P),_e(C1),_e(C2),_e(Q))
		  local _temp_array = {}
		  for i,v in ipairs(curve) do _temp_array[#_temp_array+1]=v end
		  _temp_array[1]=mflua.number_to_string_round5(P)
		  _temp_array[2]=mflua.number_to_string_round5(C1)
		  _temp_array[3]=mflua.number_to_string_round5(C2)
		  _temp_array[4]=mflua.number_to_string_round5(Q)
		  _temp_array[5]='(0,0)' -- shift is already included
		  additional_array[#additional_array+1]=_temp_array
	       end --for
	    end -- if math.mod(#time_array,2)~=0
	 end --#time_array > 0
      end -- if #time_array > 0 
      


      if delete_curve then
	 --print("BEZ DELETE THIS CURVE "..i)
      else
	 --print("BEZ KEEP THIS CURVE "..i)
	 _curves[#_curves+1] = curve  -- add array 
      end

      for i,additional_curve in ipairs(additional_array) do 
	 _curves[#_curves+1] = additional_curve -- add its array 
      end


      -- DEBUG######################## 
      if delete_curve==false then 
	 _t[#_t+1]='drawoptions(withcolor (0.4,0.3,1)  withpen pencircle scaled 0.08pt);ahlength :=  0.15;\n'
	 local d =0
	 for j,v in ipairs(array) do
	    local X,Y,tag = math.floor(d+v[1]),math.floor(d+v[2]),''
	    if (_neighbourhood_inside(X,Y,2,P))  then 
	       tag=i -- inside
	       _t[#_t+1]=string.format("fill (%s,%s)--(%s,%s)--(%s,%s)--(%s,%s)--cycle withcolor(0.4,0.9,0.9);\n",
				       X,Y,X+1,Y,X+1,Y+1,X,Y+1)
	    elseif  _neighbourhood_outside(X,Y,2,P) then 
	       tag=i -- outside
	       _t[#_t+1]=string.format("fill (%s,%s)--(%s,%s)--(%s,%s)--(%s,%s)--cycle withcolor(0.9,0.4,0.9);\n",
				       X,Y,X+1,Y,X+1,Y+1,X,Y+1)
	    else
	       tag=i -- frontier
	       _t[#_t+1]=string.format("fill (%s,%s)--(%s,%s)--(%s,%s)--(%s,%s)--cycle withcolor(0.9,0.9,0.9);\n",
				       X,Y,X+1,Y,X+1,Y+1,X,Y+1)
	    end
	    _t[#_t+1]=string.format("label( \"%s\", (%s,%s));\n",j,X+1/4,Y+1-1/4)
	    _t[#_t+1]=string.format("label( \"%s\", (%s,%s));\n",tag,X+3/4,Y+1/4)
	 end
	 for i,v in ipairs(array) do
	    local X,Y = math.floor(d+v[1]),math.floor(d+v[2])
	    _t[#_t+1]=string.format("draw (%s,%s) withpen pencircle scaled 0.08pt withcolor (0.4,0.3,1);\n",v[1],v[2])
	    --_t[#_t+1]=string.format("draw (%s,%s) withpen pencircle scaled 0.08pt withcolor (0.4,0.3,0);\n",X,Y)
	    --_t[#_t+1]=string.format("label( \"%s\", (%s+0.1,%s+0.1));\n",i,X,Y)
	    --_t[#_t+1]=string.format("drawarrow (%s,%s) --(%s,%s) ;\n",v[1],v[2],X,Y)
	 end
	 -- for  bit=0,100 do
	 --    t=bit/100
	 --    _t[#_t+1]=string.format("draw (%s,%s) withpen pencircle scaled 0.08pt withcolor (0.4,0.3,0.2);%% c1=(%s,%s),c2=(%s,%s),\n",
	 -- 			 p[1]*(1-t)^3+3*c1[1]*(1-t)^2*t+3*c2[1]*(1-t)*t^2+q[1]*t^3,
	 -- 			 p[2]*(1-t)^3+3*c1[2]*(1-t)^2*t+3*c2[2]*(1-t)*t^2+q[2]*t^3,
	 -- 			 c1[1],c1[2],c2[1],c2[2])
	 -- end
			      
      end
   --##########################DEBUG
   end --for i,curve in ipairs(curves) do 
   return _curves ,table.concat(_t) 
   --return table.concat(_t) 
end


local function _get_contours(char)
   --
   --
   --
   print("BEZ _get_contours")
   local res = ''
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
	       res = string.format("label(\"i1=%s, i=%s\",0.5(%s+%s));\n",i1,i,q,p)
	       valid_curves[#valid_curves+1] ={p,c1,c2,q,offset,res}
	    end
	 end
      end
   end
   return valid_curves
end


local function _get_envelopes_and_pens(char)
   --
   -- 
   --
   print("BEZ get_envelopes_and_pens")
   local res = ''
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
   local knots_set_1 = {}
   local pen_over_knots = {}

   local valid_curves = {}
   local valid_curves_pen = {}
   local valid_curves_pen_by_offset ={}

   bezier_octant = char['envelope'] or  {}
   char['envelope'] = bezier_octant
   for m=1, #char['envelope']  do ---(#char['envelope']-1) do
      bezier_octant = char['envelope'][m]
      first_point= ''
      last_point = ''
      knots = knots_list[m] or {}
      for i=1, #bezier_octant  do
	 beziers = bezier_octant[i]
	 -- maybe pen ∈ {envelope} ?
	 pen = beziers['pen']
	 offsets = beziers['offsets'] -- ?
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
	       -- it's a... ?
	       if string.len(last_point) > 0 and not(last_point == _eval(p,shifted)) then 
		  -- DELETE THIS ?
		  res = '1'
		  valid_curves[#valid_curves+1] ={last_point,last_point,_eval(p,shifted),_eval(p,shifted),'(0,0)',res}
		  last_point = _eval(p,shifted)
		  last_point_with_offset={p,shifted}
		  res = ''
	       end
	    else -- not(q == nil)
	       if string.len(last_point) > 0 and not(last_point == _eval(p,shifted)) then 
		  -- DELETE THIS ?
		  res ='2'
		  valid_curves[#valid_curves+1] ={last_point,last_point,_eval(p,shifted),_eval(p,shifted),'(0,0)',res}
		  last_point = _eval(q,shifted)
		  last_point_with_offset={q,shifted}
	       end
	       last_point = _eval(q,shifted)
	       last_point_with_offset={q,shifted}
	       res='3'
	       valid_curves[#valid_curves+1] ={p,c1,c2,q,shifted,res}
	    end -- if (q==nil=
	 end -- for j=1,#path_list do
	 --
	 -- check pen
	 --
	 local coll_ind_pen = {}
	 --knots_set = {} 
         if #knots>0 then 
	    --print("BEZ #knots="..#knots)
	    for k=1,#knots do 
	       local key =''
	       local key_1 =''
	       local go_on = true
	       local _pen = table.concat(pen)
	       knot = knots[k]
	       p,c1,c2,q,s = knot[1],knot[2],knot[3],knot[4],knot[5]
	       -- try to avoid useless check
	       key = p ..c1 ..c2 ..q ..':'.._pen
	       --print("BEZ key=",k,key)
	       if knots_set[key]~=nil  then 
		  --print("BEZ break")
		  go_on=false
		  --break 
	       else  
		  knots_set[key]=true 
		  go_on=true
	       end
	       io.flush()
	       if go_on == true then
		  res = ''
		  --shift is (0,0) 
		  pen_over_knots[#pen_over_knots+1] = {p,c1,c2,q,'(0,0)',res,pen}
		  local limit_pen = #pen
		  --pen[#pen+1] = pen[1]
		  --local key = ''
		  local pen_c1=nil
		  local _t={}
		  key_1 = p.._pen
		  if knots_set_1[key_1]==nil  then 
		     knots_set_1[key_1]=true
		     for l=1,limit_pen do 
			res ='4'
			--key=key..pen[l]
			valid_curves_pen[#valid_curves_pen+1] ={pen[l],pen_c1,pen_c1,pen[l+1]or pen[1],p,res}
			_t[#_t+1]={pen[l],pen[l+1]or pen[1],res}
		     end
		     if valid_curves_pen_by_offset[p]==nil then 
			valid_curves_pen_by_offset[p]={_t}
		     else
			table.insert(valid_curves_pen_by_offset[p],_t)
		     end
		  end -- knots_set_1[key_1]==nil
	       end -- go_on==true
	    end -- for 
	 end  -- if#knots>0 
	 --print("BEZ the pen end")
      end -- for i=1, #bezier_octant do
      local nr_ok,values 
      if not(last_point == first_point) then 
	 -- DELETE THIS ?
	 res = '5'
	 --valid_curves[#valid_curves+1] ={last_point,last_point,first_point,first_point,'(0,0)',res}
      end 
   end --    for m=1,#char['envelope'] 
   --print("BEZ return")
   return valid_curves,valid_curves_pen,pen_over_knots,valid_curves_pen_by_offset
end --_get_envelopes_and_pens 

local function _get_beziers_of_pen(pen_over_knots)
   --
   --
   -- 	       
   print("BEZ _get_beziers_of_pen")
   local valid_curves_p_bez = {}
   local pen_ellipse = {}
   local mflua_exe = mflua.mflua_exe or './mf' 
   for i,v in ipairs(pen_over_knots) do
      --v = {p,c1,c2,q,'(0,0)',res,pen}
      local shifted, pen = v[1],v[7]
      local delta_offset = '(0,0)'
      --
      -- Uh ... why ?
      -- 
      if #pen==40 then  delta_offset ='(-0.5,-0.5)' end
      local key = table.concat(pen)
      --print("BEZ pen=",key,table.concat(mflua.pen[key]),#pen,shifted)
      if mflua.pen[key] ~= nil then
	 pen_ellipse[shifted] = {mflua.pen[key],delta_offset}
      end
   end
   for k,v in pairs(pen_ellipse) do
      local shift = k
      --print("BEZ shift=",k,shift,mflua.round0(shift))
      local major_axis__minor_axis,theta,tx__ty = v[1][1],v[1][2],v[1][3]
      local delta_offset =  v[2]
      --print("BEZ pen_ellipse = ",k,major_axis__minor_axis,theta,tx__ty)
      -- First time of  major_axis__minor_axis..theta..tx__ty
      if mflua.set_poly_done[major_axis__minor_axis..theta..tx__ty] == nil then
	 local match=string.gmatch(major_axis__minor_axis,"[%d\.]+")
	 local major_axis, minor_axis = match(),match()
	 local mfstring = string.format(
	    "batchmode;\n"..
	       "fill fullcircle xscaled (%s) yscaled (%s)  rotated (%s) shifted %s;\n"..
	       "shipit;\n"..   
	       "bye.\n",   
	    major_axis, minor_axis,theta,tx__ty)
	 mflua.lock("LOCK_ELLIPSE")
	 local file_name = "poly_to_bezier.mf"
	 local temp_file = io.open(file_name,'w')
	 temp_file:write(mfstring)
	 temp_file:close()
	 os.execute(string.format("%s %s",mflua_exe,file_name));
	 --print("BEZ unlock LOCK_ELLIPSE")
	 mflua.unlock("LOCK_ELLIPSE")
	 local curves = dofile('poly_to_bezier.lua')
	 mflua.set_poly_done[major_axis__minor_axis..theta..tx__ty] = curves
	 valid_curves_p_bez[shift] = {}
	 for _,vv in pairs(curves) do
	    local p,c1,c2,q,offset= vv[1],vv[2],vv[3],vv[4],vv[5]
	    offset = _eval(offset,delta_offset)
	    offset = _eval(offset,shift)
	    valid_curves_p_bez[shift][#valid_curves_p_bez[shift]+1] = {p,c1,c2,q,offset}
	    --print("BEZ curves are",p,c1,c2,q,offset,shift)
	 end
      else -- already seen
	 local curves =  mflua.set_poly_done[major_axis__minor_axis..theta..tx__ty] 
	 valid_curves_p_bez[shift] = {}
	 for _,vv in pairs(curves) do
	    local p,c1,c2,q,offset= vv[1],vv[2],vv[3],vv[4],vv[5]
	    offset = _eval(offset,delta_offset)
	    offset = _eval(offset,shift)
	    valid_curves_p_bez[shift][#valid_curves_p_bez[shift]+1] = {p,c1,c2,q,offset}
	    --print("BEZ curves are",p,c1,c2,q,offset,shift)
	 end
      end -- if _set_poly_done[major_axis__minor_axis..theta..tx__ty] == nil then
   end
   return valid_curves_p_bez
end

local function _remove_envelope_curves_in_pen(valid_curves_e,valid_curves_p_by_offset)
   local curves_e ={}
   local _t={}
   local p_e,c1_e,c2_e,q_e,shifted_e,res_e
   local p,c1,c2,q,shifted,res

   --for k,v in pairs(valid_curves_e) do curves_e[k]=v end
   
   for i, curve_e in pairs(valid_curves_e) do
      _t[i]=true
      p_e,c1_e,c2_e,q_e,shifted_e,res_e = curve_e[1],curve_e[2],curve_e[3],curve_e[4],curve_e[5],curve_e[6]
      local P_e,Q_e = _eval(p_e,shifted_e),_eval(q_e,shifted_e)
      for offset,array_of_pens in pairs(valid_curves_p_by_offset) do
	 --
	 -- We can have more pens for an offset
	 --
	 for l,pen in ipairs(array_of_pens) do
	    local _tt= {}
	    for m,curve in ipairs(pen) do
	       p,q,res = curve[1],curve[2],curve[3]
	       local P,Q = _eval(p,offset),_eval(q,offset)
	       _tt[P]= true;_tt[Q]=true
	    end       
	    --if ((P==p_e)and (Q==q_e)) or ((Q==p_e)and (Q==q_e)) then
	    if _tt[P_e] and _tt[Q_e] then
	     --print("drawoptions(withcolor (1,0,1)  withpen pencircle scaled 1pt);")
	     --print(string.format("draw (%s .. controls %s and %s .. %s) shifted %s;",p_e,c1_e,c2_e,q_e,shifted_e))
	       _t[i]=false
	    end
	    --print("BEZ ---")
	 end
      end
   end
   for i, curve_e in pairs(valid_curves_e) do
      if _t[i] == true then
	 curves_e[#curves_e+1]=curve_e
      end
   end
   return curves_e
end



local function _draw_curves(valid_curves,withdots,withoptions,withlabels)
   --
   --
   --
   local _t={}
   local with_dots = withdots
   local with_options = withoptions
   local with_labels = withlabels

   if withdots == nil then with_dots=true end
   if withoptions ==nil then  
      with_options = "drawoptions(withcolor (0,0,0)  withpen pencircle scaled 0.1pt);ahlength :=  0.15;"
   end

   if #valid_curves>0 then
      _t[#_t+1]=with_options.."\n"
      _t[#_t+1]="path p;\n"
      _t[#_t+1]="path q;\n"
   else
      return ''
   end
   for i,bezier in ipairs(valid_curves) do
      local p,c1,c2,q,shifted,res = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5],bezier[6]
      if with_labels == true then
	 _t[#_t+1]=string.format("label (\"%s\") (0.5(%s+%s)+%s+(0.5,0));\n", i,p,q,shifted)
      end
      if with_dots then 
	 _t[#_t+1]=string.format("draw %s withpen pencircle scaled 0.2pt shifted %s;%% p\n", p,shifted)
	 _t[#_t+1]=string.format("draw %s withpen pencircle scaled 0.2pt shifted %s;%% q\n", q,shifted)
      end
      if c1 == nil and c2 == nil then 
	 _t[#_t+1]=string.format("p:=%s -- %s;%% %03d\n",p,q,i)
	 _t[#_t+1]=string.format("q:= subpath(0,0.5) of p;%% %03d\n",i)
	 _t[#_t+1]=string.format("drawarrow  q shifted %s;%% %03d\n",shifted,i)
	 _t[#_t+1]=string.format("draw p shifted %s;%% %03d\n",shifted,i)

      else
	 _t[#_t+1]=string.format("p:=%s .. controls %s and %s .. %s;%% %03d\n", p,c1,c2,q,i)
	 _t[#_t+1]=string.format("q:= subpath(0,0.5) of p;%% %03d\n",i)
	 _t[#_t+1]=string.format("drawarrow  q shifted %s;%% %03d\n",shifted,i)
	 _t[#_t+1]=string.format("draw  p shifted %s;%% %03d\n",shifted,i)
      end
   end
   return table.concat(_t) 
end


local function _draw_curves_of_pens(valid_curves_p_bez,withdots,withoptions)  
   --
   -- 
   --
   local _t ={}
   local str = ''
   local i=0
   local with_dots = withdots
   local with_options = withoptions
   if withdots == nil then with_dots=true end
   if withoptions ==nil then  
      with_options = "drawoptions(withcolor (1,0,0)  withpen pencircle scaled 0.1pt);"
   end
   _t[#_t+1]= with_options.."\n"
   _t[#_t+1]= "path pp;\n"
   
   for shift, curves in pairs(valid_curves_p_bez) do
      _t[#_t+1]="%% SHIFT="..shift.."\n"
      for _,curve in ipairs(curves) do
	 local p,c1,c2,q,offset = curve[1],curve[2],curve[3],curve[4],curve[5]
	 local shifted = offset  -- _eval(offset,shift) no more
	 if with_dots then 
	    _t[#_t+1]=string.format("draw %s withpen pencircle scaled 0.2pt shifted %s; ", p,shifted)
	    _t[#_t+1]=string.format("draw %s withpen pencircle scaled 0.2pt shifted %s; ", q,shifted)
	 end
	 i=i+1
	 if c1 == nil and c2 == nil then 
	    _t[#_t+1]= string.format("pp:=%s .. %s;%% %03d\n",i,p,q)
	    _t[#_t+1]= string.format("draw pp shifted %s;%% %03d\n",shifted,i)
	 else
	    _t[#_t+1]= string.format("pp:=%s .. controls %s and %s .. %s;%% %03d\n",p,c1,c2,q,i)
	    _t[#_t+1]= string.format("draw pp shifted %s;%% %03d\n",shifted ,i)
	 end
      end
   end
   return table.concat(_t)
end

local function _draw_pixels(pixels)
   local res = ''
   res = res .. "drawoptions(withcolor (0.6,0.6,0.6) withpen pencircle scaled 0.01pt);\n" 
   local _t={}
   for y,v in pairs(pixels) do
      --print("BEZ row=",row)
      for x,_ in pairs(v) do
	 --print("BEZ x=",x)
	 --res=res..string.format('drawdot(%s+0.5,%s+0.5);\n',x,y)
	 if pixels[y+1]~=nil then 
	    if pixels[y][x+1]~=nil and pixels[y+1][x]~=nil and pixels[y+1][x+1]~=nil then
	       _t[#_t+1]=string.format("draw (%s,%s) -- (%s,%s) -- (%s,%s+1) -- (%s,%s+1) --cycle;\n",
		  x,y, x+1,y, x+1,y+1, x,y+1)
	    end
	 end
      end
   end
   return res..table.concat(_t)
end



local function _save_as(format,outdir,filename,res)
   if format =='metapost' then
      local f = io.open(outdir..'/'..filename,'w')
      local preamble=''
      local content = "beginfig(1);\n"..res.."\n".."\nendfig;\nend."
      f:write(content)
      f:close()
   end
end


function end_program()
   if mflua.checklock('LOCK_ELLIPSE') then
      dofile("end_program_poly_to_bezier.lua")
      print("BEZ finished end_program_poly_to_bezier")
      return 
   end

   local chartable = mflua.chartable 
   -- mflua.checklock('LOCK1') ?
   local f = mflua.print_specification.outfile1 or nil
   -- some mflua instances cannot have this file open
   if f==nil then return end


   local res = ""
   local t = {}
   local tfm;
   --local tfm = dofile('tfm.lua') 
   --print("tfm run:",tfm.run("pen.tfm"))

   f:write("\n%%\\starttext\\setupbodyfont[tt,2pt]\\bf\\stoptext %% comment this line to make an empty pdf \n")
   f:write("\\starttext\n\\setupbodyfont[tt,2pt]\\bf\n")
   --f:write("\\starttext\n\\setupbodyfont[tt,4pt]\\bf\n")
   for k,_ in pairs(chartable) do t[#t+1]=k end
   table.sort(t)
   for i,_ in ipairs(t) do
      local valid_curves_e = {}
      local valid_curves_c = {}
      local valid_curves_p = {}
      local valid_curves_p_by_offset= {}
      local valid_curves_p_bez = {}
      local pixels ={}

      local pen_over_knots = {}
      local valid_curves = {}
      local index = t[i]
      local char= chartable[index]
      local edges = char['edges']
      local temp_res = ''

      --local ye_map = {}
      --for i,v in ipairs(edges[1][1]) do ye_map[v[1]] = i  end
      --char['edges_map'] = ye_map 

      pixels=pixel_map(edges)
      if pixels == nil then print("! No pixels available: end") return end 

      -- get contours
      valid_curves_c =  _get_contours(char)
      --for i,curve in ipairs(valid_curves_c) do local p,c1,c2,q,offset,res = curve[1],curve[2],curve[3],curve[4],curve[5],curve[6] print(p,c1,c2,q,offset,res)  end

      -- get envelopes and the polygonal versions of the pens
      valid_curves_e,valid_curves_p,pen_over_knots,valid_curves_p_by_offset = _get_envelopes_and_pens(char)

      
      -- get a bezier version of the pens
      valid_curves_p_bez = _get_beziers_of_pen(pen_over_knots)

      valid_curves_e = 
	 _remove_envelope_curves_in_pen(valid_curves_e,valid_curves_p_by_offset)
      

      local _temp_res =''

      valid_curves_e,_temp_res = 
	 _remove_useless_curves(valid_curves_e,pixels)
       temp_res = temp_res .. _temp_res      

--[==[━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━►
◄━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━--]==]

      valid_curves_c,_temp_res = 
	 --_remove_useless_curves({valid_curves_c[2]},pixels)
	 _remove_useless_curves(valid_curves_c,pixels)
       temp_res = temp_res .. _temp_res


       valid_curves_p,_temp_res = 
	  _remove_useless_curves(valid_curves_p,pixels)

       --temp_res = temp_res .. _temp_res


      local valid_curves_p_bez_t = {}
      -- local _ty={}
      -- for k, _ in pairs(valid_curves_p_bez) do _ty[#_ty+1]=k end 
      -- local tu=3 -- 3,10
      -- for k,curves in pairs({[_ty[tu]]=valid_curves_p_bez[_ty[tu]]}) do
      for k,curves in pairs(valid_curves_p_bez) do
	 local _c,_r
	 _c,_r = _remove_useless_curves(curves,pixels,'pen')
	 if #_c>0 then valid_curves_p_bez_t[k] = _c ; temp_res = temp_res.._r end
      end
      valid_curves_p_bez = valid_curves_p_bez_t



      local valid_curves_p_by_offset_t = {}
      for offset,array_of_pens in pairs(valid_curves_p_by_offset) do
	 --
	 -- We can have more pens for an offset
	 --
	 local _tt={}
	 for l,pen in ipairs(array_of_pens) do
	    local curves=_pen_normalizer(pen,offset,true)
	    local _c = _remove_useless_curves(curves,pixels,'pen')
	    if #_c>0 then _tt[#_tt+1]= _pen_normalizer(_c,offset,false) end
	 end
	 if #_tt>0 then valid_curves_p_by_offset_t[offset]= _tt end
      end
      valid_curves_p_by_offset = valid_curves_p_by_offset_t 

      print("BEZ DRAW")
      -- Not necessary any more ################## 
      -- local res_pens = _draw_curves(valid_curves_p,true,
      -- "drawoptions(withcolor (0,1,1)  withpen pencircle scaled 0.01pt);")    

      
      -- f:write("\\startMPpage%%%% BEGIN EDGES\n")
      -- res = "%% char " .. index .."\n"
      -- local pre_res = char['pre_res'] or ""
      -- res = res .. pre_res .."\n"
      -- local v_res = char['res'] or ""
      -- res = res .. v_res .."\n"
      -- local post_res = char['post_res'] or ""
      -- res = res .. post_res .."\n"
      -- res = res .. res_pens
      -- f:write(res)
      -- f:write("\n\\stopMPpage%%%% END EDGES\n")
      --##############################
      res = ''

      --res = res .. temp_res
      
      -- Pixels WARNING it's huge at 7200dpi !!
      --res = res .. _draw_pixels(pixels)
      
      -- Contours 
      res = res .. _draw_curves(valid_curves_c,true,"drawoptions(withcolor (0,0,0)  withpen pencircle scaled 0.01pt);")    

      -- Envelopes
      res = res .. _draw_curves(valid_curves_e,true,"drawoptions(withcolor (0,0,1)  withpen pencircle scaled 0.08pt);;ahlength := 1;",true)      

      -- Support of pens
      --res = res .. _draw_curves(pen_over_knots,true,"drawoptions(withcolor (0.5,0.2,0)  withpen pencircle scaled 0.1pt);")  

      -- Polygonal version of pens
      --local res_pens = _draw_curves(valid_curves_p,true,"drawoptions(withcolor (0,0.5,0.5)  withpen pencircle scaled 0.05pt);")    
      --res = res .. res_pens

      
      -- Pens
      res = res .. _draw_curves_of_pens(valid_curves_p_bez,true,"drawoptions(withcolor (1,0,0)  withpen pencircle scaled 0.01pt);")  


      f:write("\\startMPpage%%%% BEGIN CURVES\n")
      f:write(res)
      f:write("\\stopMPpage%%%% END CURVES\n")


      --
      print("BEZ export in mp/"..string.format("char_%03d.mp",index))
      res = _draw_curves(valid_curves_c,false)  
      res = res .. _draw_curves(valid_curves_e,false)  
      res = res  .._draw_curves(valid_curves_p,false)  
      res = res .. _draw_curves_of_pens(valid_curves_p_bez,false)  
      _save_as('metapost','mp',string.format("char_%03d.mp",index),res) ;
   end
   f:write("\n\\stoptext\n")
   f:close()
end

end_program()


