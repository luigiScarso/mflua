print("······· mflua_fill_envelope says: 'Hello world!' ·······")


function print_transition_line_from(x,y)
   print("print_transition_line_from")
   local octant = LUAGLOBALGET_octant()
   local res = ""
   res = res .. "drawoptions(withcolor (0.5,0,0) withpen pencircle scaled 0.2pt);\n"
   res = res .. "draw " .. print_two_true(x,y,octant)
   --f:write("drawoptions(withcolor red withpen pencircle scaled 0.2pt);\n")
   mflua.fill_envelope.temp_transition = res
   return 0
end 


function print_transition_line_to(x,y)
   print("print_transition_line_to")
   local octant = LUAGLOBALGET_octant()
   local f 
   local res =    mflua.fill_envelope.temp_transition or "" 
   res = res .. " -- " .. print_two_true(x,y,octant) .. ";\n"
   --f = mflua.print_specification.outfile1
   --f:write("%%Transition line\n")
   --f:write(res)
   print(res)
   mflua.fill_envelope.temp_transition = ""
   return 0
end 
