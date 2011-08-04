print("······· mfluaini says: 'Hello world from BachoTeK!' ·······")

--[==[
These are already loaded:
function:	link
function:	info
function:	x_coord
function:	y_coord
function:	left_type
function:	right_type
function:	left_x
function:	left_y
function:	right_x
function:	right_y
function:	LUAGLOBALGET_cur_edges -- get cur_edges
function:	LUAGLOBALGET_memtop -- get memtop
function:	LUAGLOBALGET_cur_pen -- get cur_pen
function:	LUAGLOBALGET_octant -- get octant

]==]


min_quarterword=0		--{smallest allowable value in a |quarterword|}
max_quarterword=255 		--{largest allowable value in a |quarterword|}
min_halfword=0 	    		--{smallest allowable value in a |halfword|}
max_halfword=65535  		--{largest allowable value in a |halfword|}



mem_min = 0                     -- {smallest index in the |mem| array, must not be less than |min_halfword|}

quarter_unit = 2^14  		-- {$2^{14}$, represents 0.250000}
half_unit = 2^15   		-- {$2^{15}$, represents 0.50000}
three_quarter_unit = 3*(2^14) 	-- {$3\cdot2^{14}$, represents 0.75000}
unity = 2^16 			-- {$2^{16}$, represents 1.00000}
two = 2^17 			-- {$2^{17}$, represents 2.00000}
three = 2^16+2^16  		-- {$2^{17}+2^{16}$, represents 3.00000}

--[==[
@ Given integers |x| and |y|, not both zero, the |n_arg| function
returns the |angle| whose tangent points in the direction $(x,y)$.
This subroutine first determines the correct octant, then solves the
problem for |0<=y<=x|, then converts the result appropriately to
return an answer in the range |-one_eighty_deg<=@t$\theta$@><=one_eighty_deg|.
(The answer is |+one_eighty_deg| if |y=0| and |x<0|, but an answer of
|-one_eighty_deg| is possible if, for example, |y=-1| and $x=-2^{30}$.)

The octants are represented in a ``Gray code,'' since that turns out
to be computationally simplest.
]==]

negate_x=1
negate_y=2
switch_x_and_y=4
first_octant=1
second_octant=first_octant+switch_x_and_y
third_octant=first_octant+switch_x_and_y+negate_x
fourth_octant=first_octant+negate_x
fifth_octant=first_octant+negate_x+negate_y
sixth_octant=first_octant+switch_x_and_y+negate_x+negate_y
seventh_octant=first_octant+switch_x_and_y+negate_y
eighth_octant=first_octant+negate_y

octant_dir = {}
octant_dir[first_octant]="ENE-1"
octant_dir[second_octant]="NNE-2"
octant_dir[third_octant]="NNW-3"
octant_dir[fourth_octant]="WNW-4"
octant_dir[fifth_octant]="WSW-5"
octant_dir[sixth_octant]="SSW-6"
octant_dir[seventh_octant]="SSE-7"
octant_dir[eighth_octant]="ESE-8"

--[==[
@ Finally we come to the last steps of |make_spec|, when boundary nodes
are inserted between cubics that move in different octants. The main
complication remaining arises from consecutive cubics whose octants
are not adjacent; we should insert more than one octant boundary
at such sharp turns, so that the envelope-forming routine will work.

For this purpose, conversion tables between numeric and Gray codes for
octants are desirable.

@<Glob...@>=
@!octant_number:array[first_octant..sixth_octant] of 1..8;
@!octant_code:array[1..8] of first_octant..sixth_octant;
]==]

octant_code = {}
octant_code[1]=first_octant;
octant_code[2]=second_octant;
octant_code[3]=third_octant;
octant_code[4]=fourth_octant;
octant_code[5]=fifth_octant;
octant_code[6]=sixth_octant;
octant_code[7]=seventh_octant;
octant_code[8]=eighth_octant;

octant_number = {}
for k=1, 8 do octant_number[octant_code[k]]=k; end



--[==[
It is convenient to define a \.{WEB} macro |t_of_the_way| such that
|t_of_the_way(a)(b)| expands to |a-(a-b)*t|, i.e., to |t[a,b]|.

@d t_of_the_way_end(#)==#,t@=)@>
@d t_of_the_way(#)==#-take_fraction@=(@>#-t_of_the_way_end
]==]
-- TO implement !!
-- function t_of_the_way(a,b,t)
--  return take_fraction(a-b,t)
-- end 






endpoint = 0 			-- {|left_type| at path beginning and |right_type| at path end} 
knot_node_size = 7 		-- {number of words in a knot node} */

left_curl=left_x 		-- {curl information when entering this knot}
left_given=left_x 		-- {given direction when entering this knot}
left_tension=left_y 		-- {tension information when entering this knot}
right_curl=right_x 		-- {curl information when leaving this knot}
right_given=right_x 		-- {given direction when leaving this knot}
right_tension=right_y 		-- {tension information when leaving this knot}
explicit =1 			-- {|left_type| or |right_type| when control points are known}
given = 2 			-- {|left_type| or |right_type| when a direction is given}
curl = 3 			-- {|left_type| or |right_type| when a curl is desired}
open = 4 			-- {|left_type| or |right_type| when \MF\ should choose the direction}

right_octant=right_x 		-- {the octant code before a transition}
left_octant=left_x 		-- {the octant after a transition}
right_transition=right_y 	-- {the type of transition}
left_transition=left_y 		-- {ditto, either |axis| or |diagonal|}
axis=0 				-- {a transition across the $x'$- or $y'$-axis}
diagonal=1 			-- {a transition where $y'=\pm x'$}



mem_top = LUAGLOBALGET_mem_top()

sentinel= mem_top 		--{end of sorted lists}

null = mem_min			--  {the null pointer}

knil=info			-- {inverse of the |link| field, in a doubly linked list}

zero_w=4
void=null+1



zero_field=4096 		-- {amount added to coordinates to make them positive}

--[==[
@d incr(#) == #:=#+1 {increase a variable by unity}
]==]
function incr(p)
return p+1
end

--[==[
decr(#) == #:=#-1 {decrease a variable by unity}
]==]
function decr(p)
 return p-1
end 

--[==[
double(#) == #:=#+# {multiply a variable by two}
]==]
function double(p)
 return 2*p
end

--[==[
@ An array of digits in the range |0..9| is printed by |print_the_digs|.

@<Basic print...@>=
procedure print_the_digs(@!k:eight_bits);
  {prints |dig[k-1]|$\,\ldots\,$|dig[0]|}
begin while k>0 do
  begin decr(k); print_char("0"+dig[k]);
  end;
end;
]==]
function  print_the_digs(k,dig) 
  local res = ''
  while k > 0 do
   k=k-1
   res= res .. dig[k+1]
  end 
  return res 
end


--[==[
@<Basic print...@>=
procedure print_int(@!n:integer); {prints an integer in decimal form}
var k:0..23; {index to current digit; we assume that $|n|<10^{23}$}
@!m:integer; {used to negate |n| in possibly dangerous cases}
begin k:=0;
if n<0 then
  begin print_char("-");
  if n>-100000000 then negate(n)
  else  begin m:=-1-n; n:=m div 10; m:=(m mod 10)+1; k:=1;
    if m<10 then dig[0]:=m
    else  begin dig[0]:=0; incr(n);
      end;
    end;
  end;
repeat dig[k]:=n mod 10; n:=n div 10; incr(k);
until n=0;
print_the_digs(k);
end;
]==]
function print_int(n) -- {prints an integer in decimal form}
 local  k  -- 0..23; {index to current digit; we assume that $|n|<10^{23}$}
 local m  --  {used to negate |n| in possibly dangerous cases}
 local dig = {}
 local done
 local res
 local sign=''
 k=0
 if n<0 then
  --begin print_char("-");
  sign='-'
  if n>-100000000 
   then 
    n=-n 
   else
    m=-1-n; n=math.floor(m/10) ; m=math.mod(m,10)+1; k=1;  
    if m<10 
     then 
      dig[0+1]=m  
     else
      dig[0+1]=0; n=n+1
    end
   end
 end
 done=false
 while not done do
  dig[k+1]=math.mod(n,10); n=math.floor(n/10); k=k+1;
  if n==0 then done=true end 
 end 
 res = print_the_digs(k,dig)
 return sign .. res 
end 


--[==[
@<Basic printing...@>=
procedure print_scaled(@!s:scaled); {prints scaled real, rounded to five
  digits}
var @!delta:scaled; {amount of allowable inaccuracy}
begin if s<0 then
  begin print_char("-"); negate(s); {print the sign, if negative}
  end;
print_int(s div unity); {print the integer part}
s:=10*(s mod unity)+5;
if s<>5 then
  begin delta:=10; print_char(".");
  repeat if delta>unity then
    s:=s+@'100000-(delta div 2); {round the final digit}
  print_char("0"+(s div unity)); s:=10*(s mod unity); delta:=delta*10;
  until s<=delta;
  end;
end;
]==]
function  print_scaled(s)
 local delta
 local res = ''
 local done
 if s== nil then print("\nWarning from print_scale in mfluaini:s is nil"); return res end
 if s<0 then 
  res = '-'
  s=-s
 end
 res = res .. print_int(math.floor(s/unity)) -- {print the integer part}
 s=10*(math.mod(s,unity))+5
 if s ~= 5   then
  delta=10; res = res .. '.'
  done = false
  while not done do 
   if delta>unity then
     s=s+half_unit-(math.floor(delta/2))  -- {round the final digit}
   end 
   res = res .. math.floor(s/unity); s=10*math.mod(s,unity); delta=delta*10;
   if  s<=delta then done = true end
  end;
 end 
 return res
end



--[==[
@<Basic printing...@>=
procedure print_two(@!x,@!y:scaled); {prints `|(x,y)|'}
begin print_char("("); print_scaled(x); print_char(","); print_scaled(y);
print_char(")");
end;
]==]
function print_two(x,y) -- {prints `|(x,y)|'}
 local res 
 -- debug 
 -- print("print_two(x,y)",x,y)
 res = '(' .. print_scaled(x) .. ',' .. print_scaled(y) .. ')'
 return res
end

--[==[
procedure unskew(@!x,@!y:scaled;@!octant:small_number);
begin case octant of
first_octant: set_two(x+y)(y);
second_octant: set_two(y)(x+y);
third_octant: set_two(-y)(x+y);
fourth_octant: set_two(-x-y)(y);
fifth_octant: set_two(-x-y)(-y);
sixth_octant: set_two(-y)(-x-y);
seventh_octant: set_two(y)(-x-y);
eighth_octant: set_two(x+y)(-y);
end; {there are no other cases}
end;
]==]

function unskew ( x , y , octant ) 
  local curx,cury
  if octant == 1 then
      curx = x + y ;
      cury = y ;
  elseif octant == 5 then
      curx = y ;
      cury = x + y ;
  elseif octant == 6 then
      curx = -y ;
      cury = x + y ;
  elseif octant == 2 then
      curx = -x - y ;
      cury = y ;
  elseif octant == 4 then
      curx = -x - y ;
      cury = -y ;
  elseif octant == 8 then
      curx = -y ;
      cury = -x - y ;
  elseif octant == 7 then
      curx = y ;
      cury = -x - y ;
  elseif octant == 3 then
      curx = x + y ;
      cury = -y ;
   end
  return curx,cury 
end

--[==[
print_two_true(#)==unskew(#,octant); print_two(cur_x,cur_y)
--]==]
function print_two_true(x,y,octant)
 local cur_x,cur_y ,res
 cur_x,cur_y = unskew ( x , y , octant )
 res = print_two(cur_x,cur_y)
 return res
end



--[==[
n_max(#)==link(#+1) {maximum row number present, plus |zero_field|}
]==]
function n_max(p)
 return link(p+1)
end 

--[==[
sorted_loc(#)==#+1 {where the |sorted| link field resides}
]==]
function sorted_loc(p)
 return p+1 
end

--[==[
@d sorted(#)==link(sorted_loc(#)) {beginning of the list of sorted edge weights}
]==]
function sorted(p)
 return link(sorted_loc(p))
end

--[==[
@d unsorted(#)==info(#+1) {beginning of the list of unsorted edge weights}
]==]
function unsorted(p)
 return info(p+1)
end

--[==[
@d ho(#)==#-min_halfword
  {to take a sixteen-bit item from a halfword}
See mf.ch 
ho(#) == #
]==]
function ho(p) 
 return p
end

--[==[
@d m_offset(#)==info(#+3) {translation of $m$ data in edge-weight nodes}
]==]
function m_offset(p)
 return info(p+3)
end


--[==[
@ @<Declare the procedure called |print_weight|@>=
procedure print_weight(@!q:pointer;@!x_off:integer);
var @!w,@!m:integer; {unpacked weight and coordinate}
@!d:integer; {temporary data register}
begin d:=ho(info(q)); w:=d mod 8; m:=(d div 8)-m_offset(cur_edges);
if file_offset>max_print_line-9 then print_nl(" ")
else print_char(" ");
print_int(m+x_off);
while w>zero_w do
  begin print_char("+"); decr(w);
  end;
while w<zero_w do
  begin print_char("-"); incr(w);
  end;
end;
]==]
function print_weight(q,x_off)
 local w,m	-- {unpacked weight and coordinate}
 local d   	--{temporary data register}
 local cur_edges = LUAGLOBALGET_cur_edges()
 local res = '' 
 local temp
 d=ho(info(q)); w=math.mod(d,8); m=math.floor(d/8)-m_offset(cur_edges);
 res = tostring(print_int(m+x_off))
 while w>zero_w do
    --print(tostring(print_int(m+x_off)) .. " w=" .. w.. " " .. zero_w .. " " .. (w-zero_w))    
    res = res .. "+" ; w=decr(w); 
 end
 while w<zero_w do
    --print(tostring(print_int(m+x_off)) .. " w=" .. w.. " " .. zero_w .. " " .. (w-zero_w))    
    res = res .. "-" ; w=incr(w)
 end
 --print("res=" .. res .. "w=" .. math.mod(d,8)-zero_w) 
 return res, math.mod(d,8)-zero_w,tostring(print_int(m+x_off))
end


--[==[ Others utilities functions  ]==]

function odd(n) return  math.mod(n,2) == 1  end

--[==[
General global array.
Use with care !
]==]

mflua = {}
mflua.bit = 7 -- should be 4 
mflua.pi = 2*math.atan2(1,0)
mflua.print_specification = {}
mflua.print_specification.temp1 = 0
mflua.print_specification.p  = ""
mflua.print_specification.q  = ""
mflua.threshold_path_removed = 4  -- how many path we can safely remove 
mflua.threshold_extra_step = 2  -- add values/mflua.threshold_extra_step time values 
mflua.threshold_small_path_check_point = 3  -- check  3 pixels for horiz/vert. paths 
mflua.threshold_small_pen_path = 0.001         -- _fix_wrong_pending_path
mflua.threshold_fix = 1         -- _fix_wrong_pending_path
mflua.threshold = 1             -- _remove_small_path
mflua.threshold_degree = 2      -- _remove_small_path
mflua.threshold_degree_1 = 90   -- _remove_small_path
mflua.threshold_degree_2 = 270  -- _remove_small_path

mflua.threshold_small_curve = 2 -- _remove_reduntant_curves
mflua.threshold_normal_curve = 4 -- _remove_reduntant_curves
mflua.threshold_min_dist = 0.5 -- _remove_reduntant_curves
mflua.threshold_pending_path = 0.002 -- _remove_reduntant_curves


mflua.threshold_pen = 5  -- _remove_redundant_segments


mflua.threshold_bug = 4  -- _fix_intersection_bug
mflua.threshold_min_bug = 0.03  -- _fix_intersection_bug
mflua.threshold_equal_path=0.03  -- _remove_duplicate_pen_path
mflua.threshold_straight_line = 0.125             -- _is_a_straight_line
mflua.threshold_fix_knots = 0.125 -- _fix_knots
mflua.threshold_fix_knots_1 = 0.0005 -- _fix_knots
mflua.threshold_fix_knots_2 = 0.4 -- _fix_knots

mflua.threshold_remove_redundant_pen = 0.02 --remove_redundant_pen 
mflua.threshold_remove_redundant_curves = 3 --_remove_redundant_curves

mflua.threshold_merge_segments =  5e-5 -- _merge_segments


-- to permit multiple instances of mflua
if io.open('LOCK1')==nil then 
   mflua.print_specification.filename  = "envelope.tex"
   mflua.print_specification.outfile1  = io.open(mflua.print_specification.filename,'w')
end


mflua.fill_envelope = {}
mflua.fill_envelope.temp_transition = ""
mflua.do_add_to ={}
mflua.do_add_to.bezier_octant ={}
mflua.do_add_to.bezier_octant_envelope ={}
--
mflua.do_add_to.bezier_octant_I ={} 
mflua.do_add_to.bezier_octant_contour ={} 

mflua.chartable  ={}

function mflua.dot(P1,P2)  return P1[1]*P2[1]+P1[2]*P2[2] end
function mflua.angle(p,q) 
   local dot = mflua.dot  
   if math.abs(1 - dot(p,q)/(math.sqrt(dot(p,p))*math.sqrt(dot(q,q)))) <0.0001 then 
      return 0 
   else 
      return math.acos(dot(p,q)/(math.sqrt(dot(p,p))*math.sqrt(dot(q,q))))
   end 
end
-- function mflua.vec(a,w,b1) if b1 == nil then b=w else b = b1 end ; return {b[1]-a[1],b[2]-a[2]} end
-- mflua.vec(a,b) == mflua.vec(a,'->',b)
function mflua.round(p) local w=string.gmatch(p,"[-0-9.]+");local p p={w(),w()};return string.format("(%6.5f,%6.5f)",tostring(p[1]),tostring(p[2]) )end
function mflua.round5(p) local w=string.gmatch(p,"[-0-9.]+");local p p={w(),w()};return string.format("(%6.5f,%6.5f)",tostring(p[1]),tostring(p[2]) )end
function mflua.round2(p) local w=string.gmatch(p,"[-0-9.]+");local p p={w(),w()};return string.format("(%6.2f,%6.2f)",tostring(p[1]),tostring(p[2]) )end
function mflua.round1(p) local w=string.gmatch(p,"[-0-9.]+");local p p={w(),w()};return string.format("(%6.1f,%6.1f)",tostring(p[1]),tostring(p[2]) )end
function mflua.round0(p) local w=string.gmatch(p,"[-0-9.]+");local p p={w(),w()};return string.format("(%6.0f,%6.0f)",tostring(p[1]),tostring(p[2]) )end

function mflua.round5_table(p) return {tonumber(string.format("%6.5f",tostring(p[1]))),tonumber(string.format("%6.5f",tostring(p[2])))} end


function mflua.vec(a,b) return {b[1]-a[1],b[2]-a[2]} end
function mflua.modul_vec(a,b) local dot = mflua.dot local P ={b[1]-a[1],b[2]-a[2]}  return math.sqrt(dot(P,P)) end

function mflua.approx_curve_lenght(p,c1,c2,q) return  mflua.modul_vec(p,c1) + mflua.modul_vec(c1,c2) + mflua.modul_vec(c2,q) + mflua.modul_vec(p,q) end




--[==[
 font=fontforge.font()
> font.fullname  ="A font"
> font.fontname  ="AFont"
> font.familyname="A Font"
>
> A=font.createChar("A")
> A.importOutlines("A.svg")
> A.removeOverlap()
> A.simplify()
>
> font.save()
]==]




