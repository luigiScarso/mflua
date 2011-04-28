--print("\n······· scan_direction.lua says: 'Hello world!' ·······")

local function _print_path(h,s,nuline)
   local p,q
   local res 
   local done
   local done1
   local f
   done = false
   done1 = false 
   p = h
   res = '' 
   while not done do
      q = link(p)
      if (p==0) or (q==0) then
	 res = "???"
	 -- do something with res -- 
	 return 0
      end
      res = res .. print_two(x_coord(p),y_coord(p)); -- print("res=",res)
      if right_type(p) == endpoint then
	 if left_type(p)== open then print("{open?}") end -- {can't happen}
	 if (left_type(q) ~= endpoint) or (q ~= h) then q=null end -- {force an error}
	 done1 = true --  goto done1;
      elseif right_type(p) == explicit then 
	 -- begin "@<Print control points between |p| and |q|, then |goto done1|@>"
	 res = res .. "..controls " ..  print_two(right_x(p),right_y(p)) .. " and ";
	 if left_type(q) ~= explicit then print("??")  -- {can't happen}
	 else res = res .. print_two(left_x(q),left_y(q));
	    done1 = true -- goto done1;
	 end
	 -- end "@<Print control points between |p| and |q|, then |goto done1|@>"
      elseif right_type(p) == open then 
	 -- begin "@<Print information for a curve that begins |open|@>" 
	 if (left_type(p) ~= explicit) and (left_type(p)~=open) then
	    res = res .. "{open?}" -- {can't happen}
	 end  
	 -- end "@<Print information for a curve that begins |open|@>" 
      elseif (right_type(p) == curl) or (right_type(p) == given) then 
	 -- @ A curl of 1 is shown explicitly, so that the user sees clearly that
	 -- \MF's default curl is present.
	 -- begin @<Print information for a curve that begins |curl|...@>=
	 if left_type(p)==open then res = res .. "??" end --  {can't happen}
	 if right_type(p)==curl then
	    res = res .. "{curl ".. print_scaled(right_curl(p))
	 else  n_sin_cos(right_given(p)); res = res .."{"
	    res = res .. print_scaled(n_cos) .. "," ..  print_scaled(n_sin)
	 end
	 res = res .."}"
	 -- end @<Print information for a curve that begins |curl|...@>=
      else res = res .. "???" -- {can't happen}
      end 
      if not done1 then -- mimic label done 1
	 if left_type(q)~=explicit then res = res .. "..control?" --   {can't happen}
	 else if (right_tension(p) ~= unity) or (left_tension(q) ~= unity) then
	       -- begin "@<Print tension between |p| and |q|@>;" 
	       res = res .. "..tension "
	       if right_tension(p)<0 then res = res .. "atleast" end 
	       res = res .. print_scaled(math.abs(right_tension(p)))
	       if right_tension(p) ~= left_tension(q) then
		  res = res .. " and "
		  if left_tension(q)<0 then res = res .. "atleast" end
		  res = res .. print_scaled(math.abs(left_tension(q)))
	       end
	    end -- "@<Print tension between |p| and |q|@>;"
	 end
      end --- LABEL:  done1 
      -- begin @<Print two dots...@>=
      p = q
      res = res .. " .." 
      if left_type(p)==given then
	 n_sin_cos(left_given(p)); res = res .. "{"
	 res = res  .. print_scaled(n_cos); res = res .. ",";
	 res = res .. print_scaled(n_sin); res = res .. "}";
      else if left_type(p)==curl then
	    res = res .. "{curl "; res = res .. print_scaled(left_curl(p)) .. "}";
	 end;
      end
      -- end @<Print two dots...@>=
      -- end "@<Print information for adjacent knots |p| and |q|@>"
      if p == h then done =true end
   end
   if left_type(h) ~= endpoint then 
      res = res .. "cycle" 
   else 
      res = res
   end
   -- do something with res --
   return res 
   --res = "drawoptions(withcolor black withpen pencircle scaled 1pt);\n" .. "draw " ..  res .. " ;\n" 
   --print(res)
   -- local index = (0+print_int(LUAGLOBALGET_char_code())) +  (0+print_int(LUAGLOBALGET_char_ext()))*256
   -- local char = mflua.chartable[index] or {}
   -- char['char_wd'] = print_scaled(LUAGLOBALGET_char_wd()) 
   -- char['char_ht'] = print_scaled(LUAGLOBALGET_char_ht()) 
   -- char['char_dp'] = print_scaled(LUAGLOBALGET_char_dp()) 
   -- char['char_ic'] = print_scaled(LUAGLOBALGET_char_ic())  
   -- char['res']     =   char['res']  or "" 
   -- char['res']     =   char['res']  .. res 
   -- mflua.chartable[index] = char 
   -- return 0
end


function PRE_make_choices(p)
   --print("\n······· PRE_make_choices says: 'Hello world!' ·······")
   -- _print_path(p,"PRE make choice",false)
   return 0
end

function POST_make_choices(p)
   --print("\n······· POST_make_choices says: 'Hello world!' ·······")
   --local res = ''
   --res = _print_path(p,"POST make choice",false)
   --print(res)
   return 0
end