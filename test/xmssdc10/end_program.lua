print("\n······· mflua_end_program says: 'Hello world!' ·······")


local function _eval(q,offset)
   local qx,qy,xo,yo
   local w 
   w=string.gmatch(q,"[-0-9.]+"); qx,qy=w(),w()
   w=string.gmatch(offset,"[-0-9.]+"); xo,yo=w(),w()
   return string.format("(%s,%s)",qx+xo,qy+yo)
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
   local pen_over_knots = {}

   local valid_curves = {}
   local valid_curves_pen = {}
   bezier_octant = char['envelope'] or  {}
   char['envelope'] = bezier_octant
   for m=1, #char['envelope']  do ---(#char['envelope']-1) do
      bezier_octant = char['envelope'][m]
      first_point= ''
      last_point = ''
      knots = knots_list[m] or {}
      for i=1, #bezier_octant do
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
		  --valid_curves[#valid_curves+1] ={last_point,last_point,_eval(p,shifted),_eval(p,shifted),'(0,0)',res}
		  last_point = _eval(p,shifted)
		  last_point_with_offset={p,shifted}
		  res = ''
	       end
	    else -- not(q == nil)
	       if string.len(last_point) > 0 and not(last_point == _eval(p,shifted)) then 
		  -- DELETE THIS ?
		  res ='2'
		  --valid_curves[#valid_curves+1] ={last_point,last_point,_eval(p,shifted),_eval(p,shifted),'(0,0)',res}
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
	    for k=1,#knots do -- should be this but it's too much slow. and broke s of ccr5  By the way, it must be 	       set for sym.mf .
	       -- a solution is to use #knots when #knots is small
	       -- for _,k in ipairs({1,math.floor(#knots/2)}) do
	       -- for idx,k in ipairs({1,math.floor(#knots/2),1+math.floor(#knots/2),#knots}) do
	       local key =''
	       knot = knots[k]
	       p,c1,c2,q,s = knot[1],knot[2],knot[3],knot[4],knot[5]
	       -- try to avoid useless check
	       key = p ..c1 ..c2 ..q .. table.concat(pen)
	       if knots_set[key]~=nil  then break else  knots_set[key]=true end
	       res = ''
	       --shift is (0,0) 
	       pen_over_knots[#pen_over_knots+1] = {p,c1,c2,q,'(0,0)',res,pen}
	       local limit_pen = #pen
	       --pen[#pen+1] = pen[1]
	       --local key = ''
	       for l=1,limit_pen do 
		  res ='4'
		  --key=key..pen[l]
		  valid_curves_pen[#valid_curves_pen+1] ={pen[l],pen_c1,pen_c1,pen[l+1]or pen[1],p,res}
	       end
	       --print("BEZ ==>",key)
	    end -- for 
	 end  -- if#knots>0 
	 --print("BEZ the pen end")
      end -- for i=1, #bezier_octant do
      local nr_ok,values 
      if not(last_point == first_point) then 
	 res = '5'
	 valid_curves[#valid_curves+1] ={last_point,last_point,first_point,first_point,'(0,0)',res}
      end 
   end --    for m=1,#char['envelope'] 
   return valid_curves,valid_curves_pen,pen_over_knots
end

local function _get_beziers_of_pen(valid_curves_p)
   --
   --
   --
   local  valid_curves_p_bez = {}
   local pen_with_shift = {}
   local mflua_exe = mflua.mflua_exe or './mf' 
   if #valid_curves_p==0 then
      return {}   
   end
   for i,bezier in ipairs(valid_curves_p) do
      local p,c1,c2,q,shifted,res = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5],bezier[6]
      --print("BEZ i=",i,shifted)
      if pen_with_shift[shifted] == nil then 
	 pen_with_shift[shifted]=p
      else
	 pen_with_shift[shifted]=pen_with_shift[shifted]..p
      end
   end
   pen_ellipse = {}
   for k,v in pairs(pen_with_shift) do
      --print("BEZ pen_with_shift = ",k,v)
      pen_ellipse[k] = mflua.pen[v]
   end
   local _set_poly_done = {}
   for k,v in pairs(pen_ellipse) do
      local shift = k
      --print("BEZ shift=",shift)
      local major_axis__minor_axis,theta,tx__ty = v[1],v[2],v[3]
      --print("BEZ pen_ellipse = ",k,major_axis__minor_axis,theta,tx__ty)
      -- First time of  major_axis__minor_axis..theta..tx__ty
      if _set_poly_done[major_axis__minor_axis..theta..tx__ty] == nil then
	 local match=string.gmatch(major_axis__minor_axis,"[%d\.]+")
	 local major_axis, minor_axis = match(),match()
	 local mfstring = string.format(
	    "batchmode;\n"..
	    "fill fullcircle xscaled (%s) yscaled (%s) rotated (%s) shifted %s;\n"..
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
	 _set_poly_done[major_axis__minor_axis..theta..tx__ty] = curves
	 valid_curves_p_bez[shift] = {}
	 for _,vv in pairs(curves) do
	    local p,c1,c2,q,offset= vv[1],vv[2],vv[3],vv[4],vv[5]
	    valid_curves_p_bez[shift][#valid_curves_p_bez[shift]+1] = {p,c1,c2,q,offset}
	    --print("BEZ curves are",p,c1,c2,q,offset)
	 end
      else -- already seen
	 local curves =  _set_poly_done[major_axis__minor_axis..theta..tx__ty] 
	 valid_curves_p_bez[shift] = {}
	 for _,vv in pairs(curves) do
	    local p,c1,c2,q,offset= vv[1],vv[2],vv[3],vv[4],vv[5]
	    valid_curves_p_bez[shift][#valid_curves_p_bez[shift]+1] = {p,c1,c2,q,offset}
	    --print("BEZ curves are",p,c1,c2,q,offset)
	 end
      end -- if _set_poly_done[major_axis__minor_axis..theta..tx__ty] == nil then
   end
   return valid_curves_p_bez
end



local function _draw_curves(valid_curves,withdots)
   --
   --
   --
   local str = ''
   local with_dots = withdots
   if withdots == nil then with_dots=true end
   if #valid_curves>0 then
      str = "drawoptions(withcolor (0,0,0)  withpen pencircle scaled 0.1pt);\n"
      str = str .. "path p[];\n"
   else
      return str
   end
   for i,bezier in ipairs(valid_curves) do
      local p,c1,c2,q,shifted,res = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5],bezier[6]
      --print(p,c1,c2,q,shifted,res)
      --str = str .. string.format('label("%s",0.5(%s+%s));\n',res,_eval(p,shifted),_eval(q,shifted))
      --str = str .. string.format('label("%s",%s);\n',res,_eval(p,shifted))

      if c1 == nil and c2 == nil then 
	 str=str .. string.format("p%03d:=%s .. %s;\n",i,
				  _eval(p,shifted),_eval(q,shifted))
	 --str=str .. "drawoptions(withcolor (0.5,0.5,0)  withpen pencircle scaled 0.1pt);\n"
	 --str=str .. string.format("draw p1; % %s\n",res)
	 str=str .. string.format("draw p%03d;\n",i)
	 if with_dots then 
	    str=str .. string.format("drawdot%s;drawdot%s;\n", _eval(p,shifted),_eval(q,shifted))
	 end
      else
	 str=str .. string.format("p%03d:=%s .. controls %s and %s .. %s;\n",i,
				  _eval(p,shifted),_eval(c1,shifted),_eval(c2,shifted),_eval(q,shifted))
	 --str=str .. "drawoptions(withcolor (0,0,0)  withpen pencircle scaled 0.1pt);\n"
	 --str=str .. string.format("draw p1; %% %s\n",res)
	 str=str .. string.format("draw p%03d;\n",i)
	 if with_dots then 
	    str=str .. string.format("drawdot%s;drawdot%s;\n", _eval(p,shifted),_eval(q,shifted))
	 end
      end
   end
   return str
end


local function _draw_curves_of_pens(valid_curves_p_bez,withdots)  
   --
   -- 
   --
   local str = ''
   local i=0
   local with_dots = withdots
   if withdots == nil then with_dots=true end

   str = "drawoptions(withcolor (0,0,0)  withpen pencircle scaled 0.1pt);\n"
   str = str .. "path pp[];\n"
   
   for shift, curves in pairs(valid_curves_p_bez) do
      for _,curve in ipairs(curves) do
	 local p,c1,c2,q,offset = curve[1],curve[2],curve[3],curve[4],curve[5]
	 local shifted = _eval(offset,shift)
	 i=i+1
	 if c1 == nil and c2 == nil then 
	    str=str .. string.format("pp%03d:=%s .. %s;\n",i,
				     _eval(p,shifted),_eval(q,shifted))
	    str=str .. string.format("draw pp%03d;\n",i)
	    if with_dots then 
	       str=str .. string.format("drawdot%s;drawdot%s;\n", _eval(p,shifted),_eval(q,shifted))
	    end
	 else
	    str=str .. string.format("pp%03d:=%s .. controls %s and %s .. %s;\n",i,
				     _eval(p,shifted),_eval(c1,shifted),_eval(c2,shifted),_eval(q,shifted))
	    str=str .. string.format("draw pp%03d;\n",i)
	    if with_dots then 
	       str=str .. string.format("drawdot%s;drawdot%s;\n", _eval(p,shifted),_eval(q,shifted))
	    end
	 end
      end
   end
   return str
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
   f:write("\\starttext\n\\setupbodyfont[tt,5pt]\\bf\n")
   --f:write("\\starttext\n\\setupbodyfont[tt,4pt]\\bf\n")
   for k,_ in pairs(chartable) do t[#t+1]=k end
   table.sort(t)
   for i,_ in ipairs(t) do
      local valid_curves_e = {}
      local valid_curves_c = {}
      local valid_curves_p = {}
      local valid_curves_p_set= {}
      local valid_curves_p_bez = {}

      local pen_over_knots = {}
      local valid_curves = {}
      local index = t[i]
      local char= chartable[index]
      -- useful to have, but unused
      -- because edges are stored in
      -- char['pre_res'] by print_edges.lua
      local edges = char['edges']
      local ye_map = {}
      for i,v in ipairs(edges[1][1]) do ye_map[v[1]] = i  end
      char['edges_map'] = ye_map 


      -- get contours
      valid_curves_c =  _get_contours(char)
      --for i,curve in ipairs(valid_curves_c) do local p,c1,c2,q,offset,res = curve[1],curve[2],curve[3],curve[4],curve[5],curve[6] print(p,c1,c2,q,offset,res)  end

      -- get envelopes
      valid_curves_e,valid_curves_p,pen_over_knots = _get_envelopes_and_pens(char)
      --for i,curve in ipairs(valid_curves_e) do local p,c1,c2,q,offset,res = curve[1],curve[2],curve[3],curve[4],curve[5],curve[6] print(p,c1,c2,q,offset,res)  end

      --for i,curve in ipairs(valid_curves_p) do local p,c1,c2,q,offset,res = curve[1],curve[2],curve[3],curve[4],curve[5],curve[6] print(p,c1,c2,q,offset,res)  end
      valid_curves_p_bez = _get_beziers_of_pen(valid_curves_p)


      print("BEZ DRAW")
      local res_pens = _draw_curves(valid_curves_p)  

      f:write("\\startMPpage%%%% BEGIN EDGES\n")
      res = "%% char " .. index .."\n"
      local pre_res = char['pre_res'] or ""
      res = res .. pre_res .."\n"
      local v_res = char['res'] or ""
      res = res .. v_res .."\n"
      local post_res = char['post_res'] or ""
      res = res .. post_res .."\n"
      res = res .. res_pens
      f:write(res)
      f:write("\n\\stopMPpage%%%% END EDGES\n")
      --
      res = _draw_curves(valid_curves_c)  
      res = res .. _draw_curves(valid_curves_e)  
      res = res .. _draw_curves(pen_over_knots)  
      --res = res  .. res_pens
      res = res .. _draw_curves_of_pens(valid_curves_p_bez)  

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


