print("······· mflua fill_spec  says: 'Hello world !' ·······")



--[==[
@ Here's a routine that prints a cycle spec in symbolic form, so that it
is possible to see what subdivision has been made.  The point coordinates
are converted back from \MF's internal ``rotated'' form to the external
``true'' form. The global variable~|cur_spec| should point to a knot just
after the beginning of an octant boundary, i.e., such that
|left_type(cur_spec)=endpoint|.
]==]
function print_specification_contour(h)
   local p,q,n,nh
   local octant
   local cur_spec
   local res = ""
   local f   
   local first_point, first_point_offset
   local path_cnt
   local bezier_contour,beziers_contour ={},{}
   local offset_list = {}
   local path_list ={}
   local bezier_octant_I


   cur_spec=h
   p=cur_spec 
   octant = left_octant(p)

   beziers_contour['octant_number'] = octant_number[octant]
   
   first_point = print_two_true(x_coord(p),y_coord(p),octant)
   first_point_offset = print_int(right_type(p))
   
   local end_loop_1 = false
   while end_loop_1 == false do
     local end_loop_2 = false
     while end_loop_2 == false do
     	q=link(p);
        if right_type(p)==endpoint then 
	   end_loop_2=true 
	else    
	   bezier_contour['p'] = print_two_true(x_coord(p),y_coord(p),octant);
           bezier_contour['control1'] = print_two_true(right_x(p),right_y(p),octant)
           bezier_contour['control2'] = print_two_true(left_x(q),left_y(q),octant)
	   bezier_contour['q'] =  print_two_true(x_coord(q),y_coord(q),octant)
	   beziers_contour[#beziers_contour+1] = bezier_contour
	   bezier_contour = {}
	   p=q
       end 
     end 
     -- not_found label 
     if q==cur_spec then 
       end_loop_1=true 
     else
       p=q; octant=left_octant(p); -- print("% entering octant `");
     end
     --  We don't want all the octans of the cycle
     --  only the pieces of the current octant
     end_loop_1 = not(LUAGLOBALGET_octant() == octant)
   end
   -- done label: 
   -- We can now use the results
   -- No curves stored
   if #beziers_contour == 0 then
     beziers_contour['single_point'] = first_point
   end
   beziers_contour['path_list'] = {}
   if #beziers_contour == 0 then
      path_list['p'] = beziers_contour['single_point']
      beziers_contour['path_list'][#beziers_contour['path_list']+1] = path_list
      path_list={}
   else   
      for i,v in ipairs(beziers_contour) do
	 bezier_contour = v 
	 path_list['p'] = bezier_contour['p'] 
	 path_list['control1'] = bezier_contour['control1'] 
	 path_list['control2'] = bezier_contour['control2'] 
	 path_list['q'] = bezier_contour['q'] 
	 beziers_contour['path_list'][#beziers_contour['path_list']+1] = path_list
	 path_list={}
      end
   end
   bezier_octant_I =mflua.do_add_to.bezier_octant_I 
   bezier_octant_I[#bezier_octant_I+1] = beziers_contour
  return 0
end



function PRE_move_to_edges(p) 
  print_specification_contour(p)
  return 0
end


function POST_move_to_edges(p) 

   return 0
end