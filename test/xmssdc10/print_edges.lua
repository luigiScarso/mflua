--[==[
@ The |print_edges| subroutine gives a symbolic rendition of an edge
structure, for use in `\&{show}\' commands. A rather terse output
format has been chosen since edge structures can grow quite large.

@<Declare subroutines for printing expressions@>=
@t\4@>@<Declare the procedure called |print_weight|@>@;@/
procedure print_edges(@!s:str_number;@!nuline:boolean;@!x_off,@!y_off:integer);
var @!p,@!q,@!r:pointer; {for list traversal}
@!n:integer; {row number}
begin
mflua_printedges(s,nuline,x_off,y_off);
print_diagnostic("Edge structure",s,nuline);
p:=knil(cur_edges); n:=n_max(cur_edges)-zero_field;
while p<>cur_edges do
  begin q:=unsorted(p); r:=sorted(p);
  if(q>void)or(r<>sentinel) then
    begin print_nl("row "); print_int(n+y_off); print_char(":");
    while q>void do
      begin print_weight(q,x_off); q:=link(q);
      end;
    print(" |");
    while r<>sentinel do
      begin print_weight(r,x_off); r:=link(r);
      end;
    end;
  p:=knil(p); decr(n);
  end;
end_diagnostic(true);
end;
]==]
function print_edges(s,nuline,x_off,y_off)
   print("\n.....Hello world from print_edges!.....")
   local p,q,r  --  for list traversal
   local n=0      --  row number
   local cur_edges = LUAGLOBALGET_cur_edges()
   local res =''
   local y =  {} 
   local xr = {}  
   local xq = {} 
   local f, start_row, end_row ,start_row_1, end_row_1 
   local edge
   local w,w_integer,row_weight,xoff
   

   local chartable = mflua.chartable 
   local index 
   local char
   

   p = knil(cur_edges)
   n = n_max(cur_edges)-zero_field
   while p ~=  cur_edges do
      xq = {}; xr = {}
      q=unsorted(p); r=sorted(p)
      if(q>void)or(r~=sentinel) then
	 res = "mflua row " .. print_int(n+y_off) ..":"  
	 while (q>void)  do
	    w, w_integer,xoff = print_weight(q,x_off)
	    xq[#xq+1] = {xoff,w_integer}
	    res = res .. w; q=link(q);
	 end
	 res = res .. " |"
	 while r~=sentinel do
	    w,w_integer,xoff = print_weight(r,x_off) 
	    xr[#xr+1]= {xoff,w_integer}
	    res = res .. w .. ' '; r=link(r)
	 end
	 y[#y+1] = {print_int(n+y_off),xq,xr}
      end
      -- print(res)
      p=knil(p);n=decr(n);
   end 
   -- 
   -- local management of y, xq, xr 
   --
   --f = mflua.print_specification.outfile1
   index = (0+print_int(LUAGLOBALGET_char_code())) +  (0+print_int(LUAGLOBALGET_char_ext()))*256
   char = chartable[index] or {}
   print("#xq=".. #xq)
   for i,v in ipairs(y) do 
      xq,xr = v[2],v[3]
      -- for j=1, #xq, 2 do end ??
      row_weight=0
      for j=1, #xr, 1 do 
	 local xb = xr[j][1]
	 local xwb = xr[j][2]
	 row_weight=row_weight+xwb
	 xr[j][3]=row_weight
	 --print(v[1],xr[j][1],xr[j][2],xr[j][3])
      end
   end
  char['edges'] =   char['edges'] or {}
  char['edges'][#char['edges']+1] = {y,x_off,y_off}

   char['pre_res']     =   char['pre_res']  or "" 
   for i,v in ipairs(y) do 
      xq,xr = v[2],v[3]
      -- for j=1, #xq, 2 do end ??
      row_weight=0
      char['pre_res']     =   char['pre_res']  .. "%% print edges " .. v[1] .. "\n"
      for j=1, #xr-1, 1 do 
	 local xb,xe = xr[j][1],xr[j+1][1]
	 local xsb,xse = xr[j][3],xr[j+1][3]
	 res = ""
	 if xsb>0 then
	    local color = {'0.7white','0.5white','0.4white'}
	    local col = color[xsb] or 'black'
	    res = res .. "drawoptions(withcolor " .. col .. " withpen pencircle scaled 0.1pt);\n" 
	    edge = string.format("fill (%s,%s) -- (%s,%s) -- (%s,%s+1) --  (%s,%s+1) --  cycle  shifted (-(%s),-(%s));\n",
	       xb,v[1],xe,v[1],xe,v[1],xb,v[1],x_off,y_off)
	    res = res .. edge 
	    --
	    res = res .. "drawoptions(withcolor black withpen pencircle scaled 0.1pt);\n" 
	    edge = string.format("draw (%s,%s) -- (%s,%s) -- (%s,%s+1) --  (%s,%s+1) --  cycle  shifted (-(%s),-(%s));\n",
	       xb,v[1],xe,v[1],xe,v[1],xb,v[1],x_off,y_off)
	    res = res .. edge 
	 end
	 -- print(v[1],xr[j][1],xr[j][2],xr[j][3])
	 char['pre_res']     =   char['pre_res']  .. res
      end
   end
   print(".....Goodbye from print_edges!.....\n")
   return 0
end
