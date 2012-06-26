--[==[
@ The |print_pen| subroutine illustrates these conventions by
reconstructing the vertices of a polygon from \MF\'s complicated --'
internal offset representation.
@<Declare subroutines for printing expressions@>=
]==]


function print_pen(p,s,nuline)
   local nothing_printed -- {:boolean has there been any action yet?}
   local k 		--1..8; {octant number}
   local h 		-- pointer; {offset list head}
   local m,n 		-- integer; {offset indices}
   local w,ww  		-- :pointer; {pointers that traverse the offset list}
   local res = ''
  -- begin print_diagnostic("Pen polygon",s,nuline);
   nothing_printed=true; -- print()
   for k=1,8 do
      local octant=octant_code[k]; h=p+octant; n=info(h); w=link(h);
      -- print("%% octant",octant_dir[octant],n,w)
      if not(odd(k)==true) then w=knil(w) end  -- {in even octants, start at $w_{n+1}$}
      for m=1, n+1 do
	 if odd(k)==true then ww=link(w)  else ww=knil(w)    end
	 -- print("%% ".. m .. "/" .. n+1 .. " w=" .. print_two_true(x_coord(w),y_coord(w),octant) .. " ww=" .. print_two_true(x_coord(ww),y_coord(ww),octant))
	 if (x_coord(ww)~=x_coord(w)) or (y_coord(ww)~=y_coord(w)) then
	    ---@<Print the unskewed and unrotated coordinates of node |ww|@>;
	    if nothing_printed then nothing_printed=false else  -- print(" .. ") 
	    end
	    -- print(print_two_true(x_coord(ww),y_coord(ww),octant))
	    res = res .. print_two_true(x_coord(ww),y_coord(ww),octant)
	 end
	 w=ww;
      end -- for m=1, n+1 do
   end -- for k=1,8 do
   if nothing_printed==true then
      w=link(p+first_octant); print(print_two(x_coord(w)+y_coord(w),y_coord(w)));
      res = res .. print_two(x_coord(w)+y_coord(w),y_coord(w))
   end;
   res = res  .. " .. cycle"; --end_diagnostic(true);
   return res 
end -- function


local function _get_pen(p)
   local nothing_printed -- {:boolean has there been any action yet?}
   local k 		--1..8; {octant number}
   local h 		-- pointer; {offset list head}
   local m,n 		-- integer; {offset indices}
   local w,ww  		-- :pointer; {pointers that traverse the offset list}
   local res = {}
   nothing_printed=true; 
   for k=1,8 do
      local octant=octant_code[k]; h=p+octant; n=info(h); w=link(h);
      if not(odd(k)==true) then w=knil(w) end  -- {in even octants, start at $w_{n+1}$}
      for m=1, n+1 do
	 if odd(k)==true then ww=link(w)  else ww=knil(w)    end
	 if (x_coord(ww)~=x_coord(w)) or (y_coord(ww)~=y_coord(w)) then
	    ---@<Print the unskewed and unrotated coordinates of node |ww|@>;
	    if nothing_printed then nothing_printed=false else  -- print(" .. ") 
	    end
	    -- print(print_two_true(x_coord(ww),y_coord(ww),octant))
	    res[#res+1] = print_two_true(x_coord(ww),y_coord(ww),octant)
	 end
	 w=ww;
      end -- for m=1, n+1 do
   end -- for k=1,8 do
   if nothing_printed==true then
      w=link(p+first_octant); 
      res[#res+1] = print_two(x_coord(w)+y_coord(w),y_coord(w))
   end;
   -- print(" .. cycle"); --end_diagnostic(true);
   return res 
end


local function _get_offset_coords(p,octant)
  local nothing_printed -- {:boolean has there been any action yet?}
  local k 		--1..8; {octant number}
  local h 		-- pointer; {offset list head}
  local m,n 		-- integer; {offset indices}
  local w,ww  		-- :pointer; {pointers that traverse the offset list}
  local res ={}  
  nothing_printed=true; --print()
  k=octant_number[octant]; 
  h=p+octant; n=info(h); w=link(h);
  if not(odd(k)==true) then w=knil(w) end  -- {in even octants, start at $w_{n+1}$}
  for m=1, n+1 do
   if odd(k)==true then ww=link(w)  else ww=knil(w)    end
   res[m] = print_two_true(x_coord(w),y_coord(w),octant)
   w=ww;
  end -- for m=1, n+1 do
  return res 
end -- function


--mflua.print_specification = {}
--mflua.print_specification.temp1 = 0
--print("\n--------------",mflua.print_specification.temp1)

--[==[
@ Given a pointer |c| to a nonempty list of cubics,
and a pointer~|h| to the header information of a pen polygon segment,
the |offset_prep| routine changes the list into cubics that are
associated with particular pen offsets. Namely, the cubic between |p|
and~|q| should be associated with the |k|th offset when |right_type(p)=k|.

List |c| is actually part of a cycle spec, so it terminates at the
first node whose |right_type| is |endpoint|. The cubics all have
monotone-nondecreasing $x(t)$ and $y(t)$.
]==]

function print_specification(c,h)
   local p,q,n,nh
   local octant
   local cur_spec
   local res,res1 = "",""
   local offsets = {}
   local cubic,cubics ={},{}
   local f   
   local first_point, first_point_offset

   local bezier,beziers ={},{}
   local offset_list = {}
   local path_list ={}
   local bezier_octant
   local pen_key = ''
   local temp1 = mflua.print_specification.temp1

   cur_spec=c
   p=cur_spec 
   --n=info(h) 
   --lh=link(h)	--{now |lh| points to $w_0$}
   octant = left_octant(p)
   offsets =  _get_offset_coords(LUAGLOBALGET_cur_pen(),octant)
   
   -- for l=1,#offsets do print("SPEC " .. offsets[l] )end

   cubics['offsets'] = offsets
   cubics['octant_number'] = octant_number[octant]

   beziers['offsets'] = offsets
   beziers['octant_number'] = octant_number[octant]
   beziers['pen'] = _get_pen(LUAGLOBALGET_cur_pen())  
   
   for i,v in ipairs(beziers['pen']) do  
     --print(  "BEZ pen=",i,v)  
     pen_key = pen_key..v
   end
   if not(mflua.pen[pen_key] == nil) then
      table.foreach(mflua.pen[pen_key],print)
   end   
   --
   --res = res .. "%% cur_pen " .. tostring(LUAGLOBALGET_cur_pen()) .."\n"
   --res = res .. string.format("%%%% current octant %s, octant number %s, offset %s\n",octant_dir[LUAGLOBALGET_octant()],octant_number[octant],print_int(n))
   --res = res .. "pair offset[];\n"
   --for i,v in ipairs(offsets) do
   --  res = res .. string.format("offset%s:=%s;\n",i-1,v)
   --end
   --res = res .. "pair OffSet; OffSet:=offset"..print_int(n) ..";\n" 
   --res = res .. "path p; p:= " .. print_two_true(x_coord(p),y_coord(p),octant) .. "\n"
   
   --cubic['p'] = print_two_true(x_coord(p),y_coord(p),octant)
   first_point = print_two_true(x_coord(p),y_coord(p),octant)
   first_point_offset = print_int(right_type(p))
   
   --
   --print(res);
   local end_loop_1 = false
   while end_loop_1 == false do
     local end_loop_2 = false
     while end_loop_2 == false do
     	q=link(p);
        if right_type(p)==endpoint then 
	   end_loop_2=true 
	else    
	   cubic['p'] = print_two_true(x_coord(p),y_coord(p),octant);
           cubic['control1'] = print_two_true(right_x(p),right_y(p),octant)
           cubic['control2'] = print_two_true(left_x(q),left_y(q),octant)
	   cubic['q'] =  print_two_true(x_coord(q),y_coord(q),octant)
	   cubic['offset'] =  print_int(right_type(p))
	   cubic['segment'] =  print_int(left_type(q)-1)
	   cubics[#cubics+1] = cubic
	   cubic = {}
	   bezier['p'] = print_two_true(x_coord(p),y_coord(p),octant);
           bezier['control1'] = print_two_true(right_x(p),right_y(p),octant)
           bezier['control2'] = print_two_true(left_x(q),left_y(q),octant)
	   bezier['q'] =  print_two_true(x_coord(q),y_coord(q),octant)
	   bezier['offset'] =  print_int(right_type(p))
	   bezier['segment'] =  print_int(left_type(q)-1)
	   beziers[#beziers+1] = bezier
	   bezier = {}
	   p=q
       end 
     end 
     -- not_found label 
     if q==cur_spec then 
       end_loop_1=true 
     else
       p=q; octant=left_octant(p); -- print("% entering octant `");
     end
     --  We don't want all the octans of the cubic
     --  only the pieces of the current octant
     end_loop_1 = not(LUAGLOBALGET_octant() == octant)
   end
   if #cubics == 0 then
     cubics['single_point'] = first_point
     cubics['single_point_offset'] = first_point_offset
   end
   -- done label: 
   -- We can now use the results
   --
   -- No curves stored
   if #beziers == 0 then
     beziers['single_point'] = first_point
     beziers['single_point_offset'] = first_point_offset
   end
   if #beziers['offsets'] == 1 then 
      offset_list[#offset_list+1] = {0,beziers['offsets'][1]}
      offset_list[#offset_list+1] = {1,beziers['offsets'][1]}
   else
      for i,v in ipairs(beziers['offsets']) do
	 if odd(beziers['octant_number']) == true then  
	    offset_list[#offset_list+1] = {(i-1),v}
	 else
	    offset_list[#offset_list+1] = {#beziers['offsets']-i+1,v}
	 end
     end
   end
   beziers['offset_list']=offset_list
   beziers['path_list'] = {}
   if #beziers == 0 then
      path_list['p'] = beziers['single_point']
      if odd(beziers['octant_number']) == true then  
	 path_list['offset'] = beziers['single_point_offset']
      else
	 path_list['offset'] = #beziers['offsets']-beziers['single_point_offset']
      end      
      beziers['path_list'][#beziers['path_list']+1] = path_list
      path_list={}
   else   
      for i,v in ipairs(beziers) do
	 bezier = v 
	 path_list['p'] = bezier['p'] 
	 path_list['control1'] = bezier['control1'] 
	 path_list['control2'] = bezier['control2'] 
	 path_list['q'] = bezier['q'] 
	 path_list['offset'] = bezier['offset']
	 beziers['path_list'][#beziers['path_list']+1] = path_list
	 path_list={}
      end
   end
   bezier_octant =mflua.do_add_to.bezier_octant 
   bezier_octant[#bezier_octant+1] = beziers

   res = ""
   res = res .. "%% cur_pen " .. tostring(LUAGLOBALGET_cur_pen()) .."\n"
   --res = res .. string.format("%%%% current octant %s, offset %s\n",octant_dir[LUAGLOBALGET_octant()],print_int(n))
   res = res .. string.format("%%%% current octant %s\n",octant_dir[LUAGLOBALGET_octant()])
   res = res .. "pair offset[];\n"
   if #cubics['offsets'] == 1 then 
      res = res .."%% Only one offset\n"
      res = res ..string.format("offset%s:=%s;\n",0,cubics['offsets'][1])
      res = res ..string.format("offset%s:=%s;\n",1,cubics['offsets'][1])
   else 
      for i,v in ipairs(cubics['offsets']) do
	 if odd(cubics['octant_number']) == true then  
            res = res .. string.format("offset%s:=%s;\n",(i-1),v)
	 else
            res = res .. string.format("offset%s:=%s;\n",#cubics['offsets']-i+1,v)
	 end
     end
   end
   res = res .. "%% cubics['octant_number'])=" .. cubics['octant_number'] .. "\n"
   res = res .. "%% #cubics=" .. #cubics .. "\n"
   if #cubics == 0 then
     res = res .. "path p; p:=" .. cubics['single_point'] .. ";\n"
     res = res .. "drawoptions(withcolor red withpen pencircle scaled 0.1pt);\n"
     temp1 = temp1 +1             
     if odd(cubics['octant_number']) == true then  
     	   res = res .. "draw p shifted offset" .. cubics['single_point_offset']  ..  ";\n"
           res = res .. string.format("pickup pencircle scaled 0.2pt;drawdot(%s) shifted offset%s withcolor 0.75white;label(\"%s\",%s+(-0.5,-0.5)) shifted offset%s;\n",
 	      	 		       	cubics['single_point'],cubics['single_point_offset'],temp1,cubics['single_point'],cubics['single_point_offset'])
     else
            res = res .. "draw p shifted offset" .. #cubics['offsets']-cubics['single_point_offset']  ..  ";\n"
            res = res .. string.format("pickup pencircle scaled 0.2pt;drawdot(%s) shifted offset%s withcolor 0.75white;label(\"%s\",%s+(-0.5,-0.5)) shifted offset%s;\n",
	       	cubics['single_point'],#cubics['offsets']-cubics['single_point_offset'],temp1,cubics['single_point'],#cubics['offsets']-cubics['single_point_offset'])
     end      
   end
   -- if #cubics == 0 then this for loop is never executed
   for i,v in ipairs(cubics) do
     cubic = v 
     res = res .. "path p; p:= " .. cubic['p'] .."\n"
     res = res .. " .. controls " .. cubic['control1'] .." and " .. cubic['control2']
     res = res .. " .. " ..  cubic['q'] .."\n ;\n"
     res = res .. 'label("'.. octant_dir[LUAGLOBALGET_octant()] ..'"' .. ",0.5[" .. cubic['p'] .. "," .. cubic['q']  .."]) shifted offset" .. cubic['offset'] .. ";\n"
     res = res .. "drawoptions(withcolor black withpen pencircle scaled 0.2pt);\n"
     res = res .. "draw p shifted offset" .. cubic['offset'] ..  ";\n"
     temp1 = temp1 +1
     res = res .. string.format("pickup pencircle scaled 0.2pt;drawdot(%s) shifted offset%s withcolor 0.75white;label(\"%s\",%s+(-0.5,-0.5)) shifted offset%s;\n",
 	      	 		       	cubic['p'],cubic['offset'],temp1,cubic['p'],cubic['offset'])
     temp1 = temp1 +1
     res = res .. string.format("pickup pencircle scaled 0.2pt;drawdot(%s) shifted offset%s withcolor 0.75white;label(\"%s\",%s+(0.5,0.5)) shifted offset%s;\n",
 	      	 		       	cubic['q'],cubic['offset'],temp1,cubic['q'],cubic['offset'])

   end
   mflua.print_specification.temp1 = temp1 
   res = res .. string.format("%%%%mflua.print_specification.temp1 = %s\n" ,mflua.print_specification.temp1)
   --print("\n%%POST START\n".. res .. "%%POST END\n")
   -- f = io.open("envelope.tex",'a')
   -- f = mflua.print_specification.outfile1
   -- f:write("\n%%POST START\n".. res .. "\n%%POST END\n")
   --f:close()
  return 0
end

function PRE_offset_prep(c,h)
  print("\nHello PRE_offset_prep")
  -- local p = c
  -- print("\nBEZ TEST".. print_int(right_type(p)))
  -- print ("BEZ TEST".. print_two(x_coord(p),y_coord(p)))
  -- print ("BEZ TEST".. print_two(right_x(p),right_y(p)))
  -- p = link(p)
  -- print ("BEZ TEST".. print_two(left_x(p),left_y(p)))
  return 0
end

function POST_offset_prep(c,h)
  print("\nHello POST_offset_prep")
  -- print("\nPOST print pen"); print_pen(LUAGLOBALGET_cur_pen(),"" , "")  
  -- print("\nPOST print specification") 
  --res = print_pen(LUAGLOBALGET_cur_pen(),"" , "")  
  --print(" PRINT PEN " .. res )
  print_specification(c,h)
  return 0
end


