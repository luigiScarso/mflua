print("······· make_ellipse says: 'Hello world!' ·······")

function PRE_make_ellipse(major_axis,minor_axis,theta,tx,ty,q)
 print("······· PRE_make_ellipse says: 'Hello world!' ·······")
 --print("major_axis,minor_axis,theta,tx,ty,q=",major_axis,minor_axis,theta,tx,ty,q)
 return 0
end

function POST_make_ellipse(major_axis,minor_axis,theta,tx,ty,q)
 print("······· POST_make_ellipse says: 'Hello world!' ·······")
 print("major_axis,minor_axis,theta,tx,ty,q=",
       print_two(major_axis,minor_axis),theta*(2^-20),print_two(tx,ty),q)
 local flag=true
 local p=q
 local res = ''
 local xy
 while flag do
  p=link(p)
  res = res ..print_two(x_coord(p),y_coord(p))
  if p==q then flag=false end
 end 
 print(res)
 mflua.pen[res] = {print_two(major_axis,minor_axis),  
 		   theta*(2^-20),print_two(tx,ty)}

 return 0
end
  