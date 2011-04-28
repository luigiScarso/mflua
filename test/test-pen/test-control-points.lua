--[=[
Path at line 11, before choices:
(4,4){curl 1}
 ..(10,20)
 ..{curl 1}(40,0)


.....Hello world from print_path!.....	527
%%Print path
drawoptions(withcolor black withpen pencircle scaled 1pt);
draw (4,4)..controls (2.64665,10.05151) and (5.00128,16.33052) ..(10,20)..controls (24.43344,30.59534) and (44.22899,17.3983) ..(40,0) .. ;

Path at line 11, after choices:
(4,4)..controls (2.64665,10.05151) and (5.00128,16.33052)
 ..(10,20)..controls (24.43344,30.59534) and (44.22899,17.3983)
 ..(40,0)
]=]

local function chose_control_point(p,q)
   --
   -- calculate the control point for  p .. q 
   -- cfr 277 metafont the program
   local w py,py,qx,qy
   w=string.gmatch(q,"[-0-9.]+"); px,py =w(),w()}
   w=string.gmatch(offset,"[-0-9.]+"); qx,qy=w(),w()
   local a_0,gamma0,b_1 = 1 ,1 ,1
   local chi_0 = a_0^2*gamma_0/b_1^2
   local C_0 = chi_0*a_0+3-b_1
   local D_0 = (3-a_0)*chi_0+b_1
   local R_0 = -D_0*psi_1

end