print("······· mflua_do_add_to says: 'Hello world!' ·······")

--[=[
@p procedure print_spec(@!s:str_number);
label not_found,done;
var @!p,@!q:pointer; {for list traversal}
@!octant:small_number; {the current octant code}
begin print_diagnostic("Cycle spec",s,true);
@.Cycle spec at line...@>
p:=cur_spec; octant:=left_octant(p); print_ln;
print_two_true(x_coord(cur_spec),y_coord(cur_spec));
print(" % beginning in octant `");
loop@+  begin print(octant_dir[octant]); print_char("'");
  loop@+  begin q:=link(p);
    if right_type(p)=endpoint then goto not_found;
    @<Print the cubic between |p| and |q|@>;
    p:=q;
    end;
not_found: if q=cur_spec then goto done;
  p:=q; octant:=left_octant(p); print_nl("% entering octant `");
  end;
@.entering the nth octant@>
done: print_nl(" & cycle"); end_diagnostic(true);
end;
]=]

function _print_spec(cur_spec)
 print("\n.....Hello world from _print_spec!.....")
 local p,q 
 local octant
 --local res = '' 
 local knot = {} 
 local knots = {} 
 -- local res = {}
 local endloop1 = false
 local endloop2 = false

 p=cur_spec; octant=left_octant(p); print()
 -- res = res .. print_two_true(x_coord(cur_spec),y_coord(cur_spec),octant)
 knot[#knot+1] = print_two_true(x_coord(cur_spec),y_coord(cur_spec),octant)
 while (endloop1 == false)  do
    -- print('%%' .. octant_dir[octant])
    endloop2 = false
    while (endloop2 == false)  do
       q = link(p)
       if right_type(p)==endpoint then 
	  endloop2 = true -- goto not_found;
       else
	  -- print(' @<Print the cubic between |p| and |q|@>;')
	  -- c1
	  knot[#knot+1] = print_two_true(right_x(p),right_y(p),octant)
	  -- c2
	  knot[#knot+1] = print_two_true(left_x(q),left_y(q),octant)
	  -- q
	  knot[#knot+1] = print_two_true(x_coord(q),y_coord(q),octant)
	  -- segment
	  knot[#knot+1] = print_int(left_type(q)-1)
	  knots[#knots+1] = knot
	  knot = {} 
	  -- res = res .." ..controls "
	  -- res = res .. print_two_true(right_x(p),right_y(p),octant)
	  -- res = res .." and "
	  -- res = res ..print_two_true(left_x(q),left_y(q),octant)
	  -- res = res .. "\n .."
	  -- res = res .. print_two_true(x_coord(q),y_coord(q),octant)
	  -- res = res .." % segment " ..print_int(left_type(q)-1) .. "\n";
	  p=q;
	  knot[#knot+1] = print_two_true(x_coord(p),y_coord(p),octant)
       end
    end -- endloop2
    -- not_found
    if q == cur_spec then 
       endloop1 = true 
    else
       p=q; octant=left_octant(p) --  print("% entering octant `");
    end
 end -- endloop1
 --done: 
 -- print(" & cycle") ; end_diagnostic(true);
 -- print("%BEZ TEST\ndraw "..res .. ";\n")
 -- table.foreach(knots,function (k) table.foreach(knots[k],print) end)
 return knots
end



local function _store_current_envelope()
   local bezier_octant_envelope = mflua.do_add_to.bezier_octant_envelope 
   local bezier_octant = mflua.do_add_to.bezier_octant 
   if (#bezier_octant_envelope == 0) then
      local _t = {} 
      for i,v in ipairs(bezier_octant) do _t[i] = v end
      bezier_octant_envelope[1] = _t
   else
      local _cnt=0 
      for i,v in ipairs(bezier_octant_envelope) do _cnt=_cnt+#v end
      local _t = {} 
      for i,v in ipairs(bezier_octant) do if i>_cnt then _t[#_t+1] = v end end
      bezier_octant_envelope[#bezier_octant_envelope+1] = _t
   end
   mflua.do_add_to.bezier_octant_envelope = bezier_octant_envelope 
   return 0
end


local function _postprocessing()
   local bezier_octant
   local beziers,offsets

   local path_list
   local prev_point 
   local path_cnt
   local res = "%% postprocessing envelope\n"
   local f
   local chartable = mflua.chartable 
   local index 
   local char

   index = (0+print_int(LUAGLOBALGET_char_code())) +  (0+print_int(LUAGLOBALGET_char_ext()))*256
   print("CHAR " .. index)
   print("%% postprocessing envelope "..index.. ' ' .. #chartable)
   
   res = res .. "path p[];\n"

   --  The last part of envelope added
   bezier_octant = mflua.do_add_to.bezier_octant_envelope[#mflua.do_add_to.bezier_octant_envelope] 

   path_cnt = 1
   for i,v in ipairs(bezier_octant) do
      beziers = v
      offsets = beziers['offsets']
      path_list = beziers['path_list'] 
      local offset_list = beziers['offset_list']
      for i,path in ipairs(path_list) do
	 local shifted 
         local p,c1,c2,q,offset = 
	    path['p'],path['control1'],path['control2'],path['q'],path['offset']  	 
	 for i,v in ipairs(offset_list) do 
	    if v[1] == (0+offset) then 
	       shifted = v[2] 
	       break 
	    end 
	 end 
	 if (q == nil) then
	    res = res .. string.format("p%d:=(%s) shifted %s;%% shifted 1\n",
				       path_cnt,p,shifted)
	 else
	    res = res .. string.format("p%d:=(%s .. controls %s and %s .. %s) shifted %s;%% shifted 2\n",
				       path_cnt,p,c1,c2,q,shifted)
	 end
	 path_cnt = path_cnt +1
      end	 
   end
   res = res .. "%% path_cnt=" .. path_cnt .. " char_code=" .. print_int(LUAGLOBALGET_char_code()) .. " char_ext=" .. print_int(LUAGLOBALGET_char_ext()) 
   res = res ..  " char_wd=" .. print_scaled(LUAGLOBALGET_char_wd()) 
   res = res ..  " char_ht=" .. print_scaled(LUAGLOBALGET_char_ht()) 
   res = res ..  " char_dp=" .. print_scaled(LUAGLOBALGET_char_dp()) 
   res = res ..  " char_ic=" .. print_scaled(LUAGLOBALGET_char_ic())  
   res = res ..  " \n"

   res = res .. "drawoptions(withcolor (" .. math.random().."," .. math.random()..",".. math.random()..  ") withpen pencircle scaled 0.4pt);\n"
   res = res .. "draw p1"
   for i=2,path_cnt-1 do 
      res = res .. string.format(" --  p%d",i)
   end 
   res = res .. " --cycle;\n"

   index = (0+print_int(LUAGLOBALGET_char_code())) +  (0+print_int(LUAGLOBALGET_char_ext()))*256
   char = chartable[index] or {}
   char['char_wd'] = print_scaled(LUAGLOBALGET_char_wd()) 
   char['char_ht'] = print_scaled(LUAGLOBALGET_char_ht()) 
   char['char_dp'] = print_scaled(LUAGLOBALGET_char_dp()) 
   char['char_ic'] = print_scaled(LUAGLOBALGET_char_ic())  
   char['envelope'] = char['envelope'] or {}
   char['envelope'][#char['envelope']+1] = bezier_octant
   char['res']     =   char['res']  or "" 
   char['res']     =   char['res']  .. res 
   char['index'] = index
   chartable[index] = char 

end


local function _store_current_contour()
   local bezier_octant_contour = mflua.do_add_to.bezier_octant_contour
   local bezier_octant_I = mflua.do_add_to.bezier_octant_I 
   if (#bezier_octant_contour == 0) then
      local _t = {} 
      for i,v in ipairs(bezier_octant_I) do _t[i] = v end
      bezier_octant_contour[1] = _t
   else
      local _cnt=0 
      for i,v in ipairs(bezier_octant_contour) do _cnt=_cnt+#v end
      local _t = {} 
      for i,v in ipairs(bezier_octant_I) do if i>_cnt then _t[#_t+1] = v end end
      bezier_octant_contour[#bezier_octant_contour+1] = _t
   end
   mflua.do_add_to.bezier_octant_contour = bezier_octant_contour 
   return 0
end


local function _postprocessing_contour()
   local bezier_octant_contour,contour,path_list
   local chartable = mflua.chartable 
   local index 
   local char
   local res  = ""
   index = (0+print_int(LUAGLOBALGET_char_code())) +  (0+print_int(LUAGLOBALGET_char_ext()))*256
   res = res .. "%% postprocessing contour for " .. index ..";\n"
   res = res .. "path p[];\n"
   print("CHAR " .. index)
   bezier_octant_contour = mflua.do_add_to.bezier_octant_contour[#mflua.do_add_to.bezier_octant_contour]
   
   path_cnt = 1
   for i,v in ipairs(bezier_octant_contour) do
      contour = v
      path_list = contour['path_list']
      for i,path in ipairs(path_list) do
	 local p,c1,c2,q = path['p'],path['control1'],path['control2'],path['q']
	 if (q == nil) then
	    res = res .. string.format("p%d:=(%s);\n",   path_cnt,p)
	 else
	    res = res .. string.format("p%d:=(%s .. controls %s and %s .. %s);\n",path_cnt,p,c1,c2,q)
	 end
	 path_cnt = path_cnt +1
      end	 
   end
   if path_cnt > 1 then 
      res = res .. "drawoptions(withcolor black withpen pencircle scaled 0.3pt);\n"
      res = res .. "draw  p1"
      for i=2,path_cnt-1 do 
	 res = res .. string.format(" --  p%d",i)
      end 
      res = res .. " --cycle ;\n"
   end


   index = (0+print_int(LUAGLOBALGET_char_code())) +  (0+print_int(LUAGLOBALGET_char_ext()))*256
   print("BEZ index="..index)
   char = chartable[index] or {}
   char['char_wd'] = print_scaled(LUAGLOBALGET_char_wd()) 
   char['char_ht'] = print_scaled(LUAGLOBALGET_char_ht()) 
   char['char_dp'] = print_scaled(LUAGLOBALGET_char_dp()) 
   char['char_ic'] = print_scaled(LUAGLOBALGET_char_ic())  
   char['contour'] = char['contour'] or {}
   char['contour'][#char['contour']+1] = bezier_octant_contour
   char['res']     =   char['res']  or "" 
   char['res']     =   char['res']  .. res 
   char['index'] = index
   chartable[index] = char 
  return 0
end






function PRE_fill_envelope_rhs(rhs)
   print("PRE_fill_envelope_rhs")
   local knots ,knots_list
   local index,char
   local chartable = mflua.chartable 
   knots = _print_spec(rhs)
   index = (0+print_int(LUAGLOBALGET_char_code())) +  (0+print_int(LUAGLOBALGET_char_ext()))*256
   char = chartable[index] or {}
   knots_list = char['knots'] or {}
   knots_list[#knots_list+1] = knots 
   char['knots'] = knots_list
   chartable[index] = char 
   return 0
end 

function POST_fill_envelope_rhs(rhs) 
   print("POST_fill_envelope_rhs")
   _store_current_envelope()
   _postprocessing()
   return 0
end 

function PRE_fill_envelope_lhs(lhs)
   print("PRE_fill_envelope_lhs")
   return 0
end 

function POST_fill_envelope_lhs(lhs) 
   print("POST_fill_envelope_lhs")
   _store_current_envelope()
   _postprocessing()
   return 0
end 


function PRE_fill_spec_rhs(rhs)
   print("PRE_fill_spec_rhs")
   --print_specification_contour(rhs)
   return 0
end 

function POST_fill_spec_rhs(rhs) 
   print("POST_fill_spec_rhs")
   _store_current_contour()
   _postprocessing_contour()
   return 0
end 

function PRE_fill_spec_lhs(lhs)
   print("PRE_fill_spec_lhs")
   --print_specification_contour(lhs)
   return 0
end 

function POST_fill_spec_lhs(lhs) 
   print("POST_fill_spec_lhs")
   _store_current_contour()
   _postprocessing_contour()
   return 0
end 
