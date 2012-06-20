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
	       -- it's a... ?
	       if string.len(last_point) > 0 and not(last_point == _eval(p,shifted)) then 
		  res = '1'
		  valid_curves[#valid_curves+1] ={last_point,last_point,_eval(p,shifted),_eval(p,shifted),'(0,0)',res}
		  last_point = _eval(p,shifted)
		  last_point_with_offset={p,shifted}
		  res = ''
	       end
	    else -- not(q == nil)
	       if string.len(last_point) > 0 and not(last_point == _eval(p,shifted)) then 
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
	 --for k=1,#knots do -- should be this but it's too much slow. and broke s of ccr5  By the way, it must be set for sym.mf .
         -- a solution is to use #knots when #knots is small
         if #knots>0 then 
	  -- for _,k in ipairs({1,math.floor(#knots/2)}) do
	  for idx,k in ipairs({1,math.floor(#knots/2),1+math.floor(#knots/2),#knots}) do
	    local key =''
	    knot = knots[k]
	    p,c1,c2,q,s = knot[1],knot[2],knot[3],knot[4],knot[5]
	    -- try to avoid useless check
	    key = p ..c1 ..c2 ..q .. table.concat(pen)
	    if knots_set[key]~=nil  then break else  knots_set[key]=true end
	    res = ''
	    pen_over_knots[#pen_over_knots+1] = {p,q,pen,res}
	    local limit_pen = #pen
	    pen[#pen+1] = pen[1]
	    for l=1,limit_pen do 
	       res ='4'
	       valid_curves_pen[#valid_curves_pen+1] ={pen[l],pen_c1,pen_c1,pen[l+1],p,res}
	    end
	 end -- for idx,k in ipairs({1,math.floor(#knots/2),1+math.floor(#knots/2),#knots}) do
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



local function _draw_curves(valid_curves)
   --
   --
   --
   local str = ''
   for i,bezier in ipairs(valid_curves) do
      local p,c1,c2,q,shifted,res = bezier[1],bezier[2],bezier[3],bezier[4],bezier[5],bezier[6]
      --print(p,c1,c2,q,shifted,res)
      if c1 == nil and c2 == nil then 
	 str=str .. string.format("path p[]; p1:=%s .. %s;\n",
				  _eval(p,shifted),_eval(q,shifted))
	 str=str .. "drawoptions(withcolor (0.5,0.5,0)  withpen pencircle scaled 0.1pt);\n"
	 str=str .. string.format("draw p1; %% %s\n",res)
      else
	 str=str .. string.format("path p[]; p1:=%s .. controls %s and %s .. %s;\n",
				  _eval(p,shifted),_eval(c1,shifted),_eval(c2,shifted),_eval(q,shifted))
	 str=str .. "drawoptions(withcolor (0,0,0)  withpen pencircle scaled 0.1pt);\n"
	 str=str .. string.format("draw p1; %% %s\n",res)
      end
   end
   return str
end


function end_program()
   local chartable = mflua.chartable 
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
      local valid_curves_p_set= {}
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

      print("BEZ DRAW")
      local res_pens = _draw_curves(valid_curves_p)  

      f:write("\\startMPpage%%%% BEGIN EDGES\n")
      res = res .. "%% char " .. index .."\n"
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
      res = res  .. res_pens
      f:write("\\startMPpage%%%% BEGIN CURVES\n")
      f:write(res)
      f:write("\\stopMPpage%%%% END CURVES\n")
      f:write("\\stoptext\n")
   end
   f:write("\n\\stoptext\n")
   f:close()
end

end_program()


