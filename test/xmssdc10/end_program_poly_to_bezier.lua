local function _get_contours(char)
   --
   --
   --
   print("BEZ _get_contours (end_program_poly_to_bezier)")
   local res = ''
   local beziers = char['contour'] or  {}
   local offset = '(0,0)'
   local valid_curves = {}
   local coll_ind = {}
   for i1, bezier in ipairs(beziers) do
      for i, contour in ipairs(bezier) do
	 local path_list = contour['path_list']
	 for j=1 ,#path_list do
	    local path = path_list[j]
	    local p,c1,c2,q = path['p'],path['control1'],path['control2'],path['q']
	    if not(q==nil) then 
	       res = string.format("label(\"i1=%s, i=%s\",0.5(%s+%s));\n",i1,i,q,p)
	       valid_curves[#valid_curves+1] ={p,c1,c2,q,offset,res}
	    end
	 end
      end
   end
   return valid_curves
end

--[=[ --------------------------------------- ]=]

local chartable = mflua.chartable 
local res
local t =  {}
for k,_ in pairs(chartable) do t[#t+1]=k end
table.sort(t)
local outstr = 'return {'
for i,_ in ipairs(t) do
   local valid_curves_c = {}
   local index = t[i]
   local char= chartable[index]
   valid_curves_c =  _get_contours(char)
   for i,curve in ipairs(valid_curves_c) do 
      local p,c1,c2,q,offset = curve[1],curve[2],curve[3],curve[4],curve[5]
      local str = string.format("{'%s','%s','%s','%s','%s'},",p,c1,c2,q,offset)  
      outstr = outstr .. str 
   end
end
outstr = outstr .. '}'
local f = io.open('poly_to_bezier.lua','w')
f:write(outstr)
f:close()