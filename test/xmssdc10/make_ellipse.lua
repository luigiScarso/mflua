print("······· make_ellipse says: 'Hello world!' ·······")

function PRE_make_ellipse(major_axis,minor_axis,theta,tx,ty,q)
 print("······· PRE_make_ellipse says: 'Hello world!' ·······")
 --print("major_axis,minor_axis,theta,tx,ty,q=",major_axis,minor_axis,theta,tx,ty,q)
 return 0
end

function POST_make_ellipse(major_axis,minor_axis,theta,tx,ty,q)
 print("······· POST_make_ellipse says: 'Hello world!' ·······")
 print("major_axis,minor_axis,theta,tx,ty,q=",
       print_two(major_axis,minor_axis),theta*(2^-20),print_two(tx,ty),print_two(x_coord(q),y_coord(q)))
 local flag=true
 local p=q
 local res = ''
 local xy
 local i = 0
 while flag do
  i=i+1
  res = res ..print_two(x_coord(p),y_coord(p))
  p=link(p)
  if p==q then flag=false end
 end 
 --print("BEZ make_ellispse res=",res)
 mflua.pen[res] = {print_two(major_axis,minor_axis),  
 		   theta*(2^-20),print_two(tx,ty)}

 return 0
end
  