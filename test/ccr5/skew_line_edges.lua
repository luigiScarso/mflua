print("······· mflua_skew_line_edges says: 'Hello world!' ·······")

function print_retrograde_line(x0,y0,cur_x,cur_y)
   local chartable = mflua.chartable 
   local index = (0+print_int(LUAGLOBALGET_char_code())) +  (0+print_int(LUAGLOBALGET_char_ext()))*256
   local char = chartable[index] or {}
   local tab = char['retrograde_line'] or  {}
   tab[#tab+1] = {print_two(x0,y0),print_two(cur_x,cur_y)}
   char['retrograde_line'] = tab
   -- local f
   -- f = mflua.print_specification.outfile1
   --f:write("%%Retrograde line\n")
   --f:write("drawoptions(withcolor red withpen pencircle scaled 0.2pt);\n")
   --f:write(" draw " .. print_two(x0,y0) .. " -- " .. print_two(cur_x,cur_y) .. ";\n")
   -- print("BEZ retroline " .. print_two(x0,y0) .. " -- " .. print_two(cur_x,cur_y) )
 return 0
end

