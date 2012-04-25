mflua = {}
local char_index = '106'
local raw_curves,cycles=dofile('envelope-'..char_index..'.lua')
mflua.svg = dofile('mflua_svg_backend.lua')

mflua.mflua_exe = './mf'
mflua.simplify_routine = 'simplify.mf'
mflua.simplify_tempdir = 'simplify'

mflua.threshold_simplify_len = 6
mflua.threshold_simplify_big_small_ratio = 5
mflua.threshold_simplify_max_len = 31
mflua.threshold_simplify_n = 10
mflua.threshold_simplify_sample = 64

function mflua.lock(params) return io.open('LOCK1','w') end
function mflua.unlock(params) return os.remove('LOCK1') end


function mflua.dot(P1,P2)  return P1[1]*P2[1]+P1[2]*P2[2] end

function mflua.modul_vec(a,b) local dot = mflua.dot local P ={b[1]-a[1],b[2]-a[2]}  return math.sqrt(dot(P,P)) end


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




function mflua.lock(params) return io.open('LOCK1','w') end
function mflua.unlock(params) return os.remove('LOCK1') end


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


local function simplifyBs (cycle,threshold_simplify_n)
   --
   -- Big small 
   -- 
   print("BEZ simplify")
   local valid_curves ={}
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
   --  merge 2 curves i, i+1, where
   --  len(i)> mflua.threshold_simplify_big_small_ratio *len(i+1)
   --
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
	 local name = string.format('mflua-sim3-%s',label1)
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
	    temp_cycle[ii] = {'Bs_'..label1,P,C1,C2,Q,'(0,0)'}
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



local function simplify (cycle,threshold_simplify_n)
   print("BEZ simplify")
   local valid_curves ={}
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
   --  merge
   --  threshold_simplify_n (i.e. 10) small consecutive curves
   --
   local accumulated_length = 0
   local target_path={}
   local temp_cycle = {};
   for i,v in ipairs(cycle) do temp_cycle[i] = v ; end
   for i,v in ipairs(cycle) do
      --local label,p,c1,c2,q,offset = v[1],v[2],v[3],v[4],v[5],v[6]
      local length=curve_length[i]
      if length<mflua.threshold_simplify_len then
	 accumulated_length = accumulated_length + length
	 target_path[#target_path+1]=i
	 --print("BEZ #target_path="..#target_path)
      end
      if #target_path==threshold_simplify_n 
           and accumulated_length<mflua.threshold_simplify_max_len 
           and math.abs(target_path[1] -target_path[#target_path])+1== threshold_simplify_n
	then
	 print("BEZ",math.abs(target_path[1] -target_path[#target_path])) 
	 print("BEZ accumulated_length="..accumulated_length)
	 local ii = target_path[1] 
	 local vv = cycle[ii]
	 local label,p,c1,c2,q,offset = vv[1],vv[2],vv[3],vv[4],vv[5],vv[6]
	 local P=p;
         local label1 = label 
	 --local  s= "%"..label.."\n"..string.format("p1=%s;c1=%s;q1=%s;%%%s c2=%s\n",p,c1,q,label,c2)
	 local s = "pair p[],c[],q[];\nnumeric L; L:="..threshold_simplify_n..";\n"
	 s= s.."numeric Nmax,Mmax,Step; Nmax:=8;Mmax:=8;Step:=0.5;\n"
	 s= s.."numeric Limit; Limit:="..mflua.threshold_simplify_sample..";\n"
	 s= s.."%"..label.."\n"..string.format("p1=%s;c1=%s;q1=%s;%%%s ii=%s\n",p,c1,q,label,ii)
	 for k=2,#target_path-1 do
	    ii = target_path[k] 
	    vv = cycle[ii]
	    label,p,c1,c2,q,offset = vv[1],vv[2],vv[3],vv[4],vv[5],vv[6]
	    --s = s.. string.format("p%s=%s;q%s=%s;%%%s c1=%s,c2=%s\n",k,p,k,q,label,c1,c2)
	    s = s.. string.format("p%s=%s;q%s=%s;%%%s i=%s\n",k,p,k,q,label,ii)
	 end
	 ii = target_path[#target_path] 
	 vv = cycle[ii]
	 label,p,c1,c2,q,offset = vv[1],vv[2],vv[3],vv[4],vv[5],vv[6]
	 local Q=q
	 --s= s.. string.format("p%s=%s;c2=%s;q%s=%s;%%%s c1=%s\n",#target_path,p,c2,#target_path,q,label,c1)
	 s= s.. string.format("p%s=%s;c2=%s;q%s=%s;%%%s ii=%s\n",#target_path,p,c2,#target_path,q,label,ii)
	 s=s..string.format("input %s;\n",mflua.simplify_routine)
	 mflua.lock() io.open('LOCK1','w')
	 local name = string.format('mflua-sim10-%s',label1)
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



local f= io.open("z.tex",'w')
f:write("\\starttext\\setupbodyfont[tt,3pt]\\bf\n\\startMPpage\n")
for _,cycle in pairs(cycles) do

   local cycle1 = simplify (cycle,mflua.threshold_simplify_n)
   local cycle2 = simplifyBs (cycle1,mflua.threshold_simplify_n)
   local cyclen = cycle2;

   f:write("path p[];\n")
   f:write("drawoptions(withcolor (0,0,0)  withpen pencircle scaled 0.02pt);ahlength:=0.2;\n")
   for i,v in ipairs(cyclen) do
    local label,p,c1,c2,q,offset = v[1],v[2],v[3],v[4],v[5],v[6]
    f:write("drawoptions(withcolor (1,0,0));\n")
    f:write(string.format("pickup pencircle scaled 0.2pt;drawdot %s ; drawdot %s; \n",p,q))
    f:write("drawoptions(withcolor (0,0,0)  withpen pencircle scaled 0.02pt);ahlength:=0.5;\n")
    f:write(string.format("drawarrow %s .. controls %s and %s .. %s; %% %s\n",p,c1,c2,q,label))
    --f:write(string.format("label(\"BEG %s\", %s);\n",label,p))
    --f:write(string.format("label(\"END %s\", %s);\n",label,q))
    
 end
end
f:write("\\stopMPpage\\stoptext\n")
f:close()