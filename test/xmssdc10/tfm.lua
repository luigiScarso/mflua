local tfm = {}
tfm.bits = 
   function(a,l) 
      local bita = {}
      local a = a
      for k=1,l do 
	 local r=math.mod(a,2)  
	 a=math.floor(a/2) 
	 bita[k]=r
      end 
      return bita
   end
tfm.bitand =
   function(a,b,l)
      local bita,bitb,bitc = tfm.bits(a,l), tfm.bits(b,l),{}
      local c= 0
      for k=1,l do 
	 bit1,bit2 = bita[k],bitb[k]
	 if (bit1==1) and (bit2==1) then 
	    bitc[k]=1
	 else
	    bitc[k]=0
	 end
	 c = c+2^(k-1)*bitc[k]
      end 
      return c,bitc
   end
tfm.bitor =
   function(a,b,l)
      local bita,bitb,bitc = tfm.bits(a,l), tfm.bits(b,l),{}
      local c= 0
      for k=1,l do 
	 bit1,bit2 = bita[k],bitb[k]
	 if (bit1==1) or (bit2==1) then 
	    bitc[k]=1
	 else
	    bitc[k]=0
	 end
	 c = c+ 2^(k-1)*bitc[k]
      end 
      return c,bitc
   end
tfm.bitnot =
   function(a,l)
      local bita,bitb = tfm.bits(a,l),{}
      local b= 0
      for k=1,l do 
	 bit1 = bita[k]
	 if (bit1==1) then 
	    bitb[k]=0
	 else
	    bitb[k]=1
	 end
	 b = b+ 2^(k-1)*bitb[k]
      end 
      return b,bitb
   end
tfm.printbits=
   function(t,l) 
      local r = ''
      local l = l or #t
      if l==0 then return '' end 
      for k=l,1,-1 do 
	 local v = t[k] or '0'
	 r=r..v
      end 
      return r
   end


      --[=[
      8. The first 24 bytes (6 words) of a TFM file contain twelve 16-bit integers that give the lengths of the
      various subsequent portions of the file. These twelve integers are, in order:
      lf = length of the entire file, in words;
      lh = length of the header data, in words;
      bc = smallest character code in the font;
      ec = largest character code in the font;
      nw  = number of words in the width table;
      nh  = number of words in the height table;
      nd  = number of words in the depth table;
      ni = number of words in the italic correction table;
      nl = number of words in the lig/kern table;
      nk  = number of words in the kern table;
      ne  = number of words in the extensible character table;
      np  = number of font parameter words.
      They are all nonnegative and less than 2^15 . We must have bc - 1<=  ec <= 255, ne<=  256, and
	 lf = 6 + lh + (ec - bc + 1) + nw + nh + nd + ni + nl + nk + ne + np .
      When two or more 8-bit bytes are combined to form an integer of 16 or more bits, the most
      significant bytes appear first in the file. This is called BigEndian order.
]=]

tfm.stop_flag = 128 
tfm.kern_flag = 128 

tfm.parameters = {}
tfm.parameters.init =
   function()
      -- 8. The first 24 bytes (6 words) of a TFM file contain twelve 16-bit integers that give the lengths of the
      -- various subsequent portions of the file. These twelve integers are, in order:
      -- lf = length of the entire file, in words;
      -- lh = length of the header data, in words;
      -- bc = smallest character code in the font;
      -- ec = largest character code in the font;
      -- nw  = number of words in the width table;
      -- nh  = number of words in the height table;
      -- nd  = number of words in the depth table;
      -- ni = number of words in the italic correction table;
      -- nl = number of words in the lig/kern table;
      -- nk  = number of words in the kern table;
      -- ne  = number of words in the extensible character table;
      -- np  = number of font parameter words.
      -- They are all nonnegative and less than 2^15 . We must have bc - 1<=  ec <= 255, ne<=  256, and
      -- 	 lf = 6 + lh + (ec - bc + 1) + nw + nh + nd + ni + nl + nk + ne + np .
      -- When two or more 8-bit bytes are combined to form an integer of 16 or more bits, the most
      -- significant bytes appear first in the file. This is called BigEndian order.
      
      if tfm.content ==nil or type(tfm.content)~= 'string' then
	 return false, 'Error on file content'
      end
      tfm.parameters.w = string.gmatch(tfm.content,"[%z%Z]")
      local w = tfm.parameters.w
      local W1,W2

      W1,W2=w(),w();if W1==nil or W2==nil then return false, 'Error on parsing content (lf)'  end
      tfm.parameters.lf = 256*string.byte(W1)+string.byte(W2) -- length of the entire file, in words;

      W1,W2=w(),w();if W1==nil or W2==nil then return false, 'Error on parsing content (lh)'  end
      tfm.parameters.lh = 256*string.byte(W1)+string.byte(W2) -- length of the header data, in words;

      W1,W2=w(),w();if W1==nil or W2==nil then return false, 'Error on parsing content (bc)'  end
      tfm.parameters.bc = 256*string.byte(W1)+string.byte(W2) -- smallest character code in the font;

      W1,W2=w(),w();if W1==nil or W2==nil then return false, 'Error on parsing content (ec)'  end
      tfm.parameters.ec = 256*string.byte(W1)+string.byte(W2) -- largest character code in the font;

      W1,W2=w(),w();if W1==nil or W2==nil then return false, 'Error on parsing content (nw)'  end
      tfm.parameters.nw = 256*string.byte(W1)+string.byte(W2) -- number of words in the width table;

      W1,W2=w(),w();if W1==nil or W2==nil then return false, 'Error on parsing content (nh)'  end
      tfm.parameters.nh = 256*string.byte(W1)+string.byte(W2) -- number of words in the height table;

      W1,W2=w(),w();if W1==nil or W2==nil then return false, 'Error on parsing content (nd)'  end
      tfm.parameters.nd = 256*string.byte(W1)+string.byte(W2) -- number of words in the depth table;

      W1,W2=w(),w();if W1==nil or W2==nil then return false, 'Error on parsing content (ni)'  end
      tfm.parameters.ni = 256*string.byte(W1)+string.byte(W2) -- number of words in the italic correction table;

      W1,W2=w(),w();if W1==nil or W2==nil then return false, 'Error on parsing content (nl)'  end
      tfm.parameters.nl = 256*string.byte(W1)+string.byte(W2) -- number of words in the lig/kern table;

      W1,W2=w(),w();if W1==nil or W2==nil then return false, 'Error on parsing content (nk)'  end
      tfm.parameters.nk = 256*string.byte(W1)+string.byte(W2) -- number of words in the kern table;

      W1,W2=w(),w();if W1==nil or W2==nil then return false, 'Error on parsing content (ne)'  end
      tfm.parameters.ne = 256*string.byte(W1)+string.byte(W2) -- number of words in the extensible character table;

      W1,W2=w(),w();if W1==nil or W2==nil then return false, 'Error on parsing content (np)'  end
      tfm.parameters.np = 256*string.byte(W1)+string.byte(W2) -- number of font parameter words.
      return 
   end

tfm.parameters.check = 
   function()
      local w  = tfm.parameters.w  
      local lf = tfm.parameters.lf
      local lh = tfm.parameters.lh
      local bc = tfm.parameters.bc
      local ec = tfm.parameters.ec
      local nw = tfm.parameters.nw
      local nh = tfm.parameters.nh
      local nd = tfm.parameters.nd
      local ni = tfm.parameters.ni
      local nl = tfm.parameters.nl
      local nk = tfm.parameters.nk
      local ne = tfm.parameters.ne
      local np = tfm.parameters.np
      local status = true 
      local status_cnt = 0
      local status_msg = 'OK'
      local function _assert(cond,msg)
	 if cond==false then
	    --print(msg) 
	    status_msg = msg
	    status_cnt = status_cnt +1
	 end
      end
      if status_cnt == 0 then _assert(lf == 6 + lh + (ec - bc + 1) + nw + nh + nd + ni + nl + nk + ne + np ,"Error on lf") end
      if status_cnt == 0 then _assert(0<=lf  and lf <2^15,"lf  out of range") end
      if status_cnt == 0 then _assert(0<=lh  and lh <2^15,"lh  out of range") end
      if status_cnt == 0 then _assert(0<=bc  and bc <2^15,"bc  out of range") end
      if status_cnt == 0 then _assert(0<=ec  and ec <2^15,"ec  out of range") end
      if status_cnt == 0 then _assert(0<=nw  and nw <2^15,"nw  out of range") end
      if status_cnt == 0 then _assert(0<=nh  and nh <2^15,"nh  out of range") end
      if status_cnt == 0 then _assert(0<=nd  and nd <2^15,"nd  out of range") end
      if status_cnt == 0 then _assert(0<=ni  and ni <2^15,"ni  out of range") end
      if status_cnt == 0 then _assert(0<=nl  and nl <2^15,"nl  out of range") end
      if status_cnt == 0 then _assert(0<=nk  and nk <2^15,"nk  out of range") end
      if status_cnt == 0 then _assert(0<=ne  and ne <2^15,"ne  out of range") end
      if status_cnt == 0 then _assert(0<=np  and np <2^15,"np  out of range") end
      if status_cnt == 0 then _assert( (bc-1)<=ec and ec<= 255, "Error on bc and ec") end
      if status_cnt == 0 then _assert(ne<= 256, "ne >256")			      end
      if status_cnt > 0 then status=false end
      return status,status_msg 
   end

   
tfm.int_to_frac = 
   function(d)
      if not (0<=d and d<2^32) then 
	 return nil, string.format("Error: %s out of range (-%s,%s-2^-20)",d,2^31,2^31) 
      else 
	 if d<=2147483647 then 
	    return d/2^20,'ok'
	 else
	    return (d-2^32)/2^20,'ok'
	 end
      end
      
   end
tfm.tag_meaning = 
   function(d)
      local t = {'vanilla character','character has a ligature/kerning program',
		 'character has a successor in a charlist','character is extensible'}
      local d = tonumber(d) or -1
      if d<0 or d>3 then return '' end
      return t[tonumber(d+1)]
   end

tfm.getface = 
   function(d)
      --If the value is less than 18, it has the following
      --interpretation as a "weight, slope, and expansion": Add 0 or 2 or 4 (for medium or bold or light) to
      --0 or 1 (for roman or italic) to 0 or 6 or 12 (for regular or condensed or extended). For example, 13 is
      --0+1+12, so it represents medium italic extended. A three-letter code (e.g., MIE) can be used for such
      --face data.
      -- d = 3⋅rce_bit⋅2^{2,1} + ri_bit + mbl_bit⋅2^{2,1}  , rce_bit,ri_bit,mbl_bit ∈ {0,1}
      -- d%2 = ri_bit := ri 
      -- d%3 - d%2 = mbl⋅2^{2,1} := mbl
      -- d - d%3 =  3⋅rce⋅2^{2,1} := rce
      if d>17 then return '' end
      local mbl,ri, rce = '*','*','*'
      local _ri = d % 2 
      if _ri==0 then ri ='R' else ri ='I' end
      local _mbl = (d%3) -(d%2) 
      if _mbl == 0 then mbl='M' end
      if _mbl == 2 then mbl='B' end
      if _mbl == 4 then mbl='E' end
      local _rce = d - (d%3) 
      if _rce == 0 then rce = 'M' end
      if _rce == 1 then rce = 'I' end
      if _rce == 12 then rce = 'E' end
      return mbl..ri..rce, {_mbl,_ri,_rce}
   end

tfm.printfloat =
   function(d,p)
      local d,p = tostring(d), tonumber(p) or 6
      local f = string.format("%%.%df",p)
      return string.format(f,d)
   end 

tfm.array = {}
tfm.array.check = 
   function()
      local width     = tfm.array.width       
      local height    = tfm.array.height      
      local depth     = tfm.array.depth       
      local italic    = tfm.array.italic      
      local status = true 
      local status_cnt = 0
      local status_msg = 'OK'
      local function _assert(cond,msg)
	 if cond==false then
	    --print(msg) 
	    status_msg = msg
	    status_cnt = status_cnt +1
	 end
      end
      _assert(width[0]==0,'Error in width[0]')
      _assert(height[0]==0,'Error in height[0]')
      _assert(depth[0]==0,'Error in depth[0]')
      _assert(italic[0]==0,'Error in italic[0]')
      if status_cnt > 0 then status=false end
      return status,status_msg 

   end

tfm.dump={} 
tfm.dump.kernprogram =
   function(d,c)
      local char_info = tfm.array.char_info
      local lig_kern  = tfm.array.lig_kern 
      local kern      = tfm.array.kern 
      local current_step = d
      local current_char = c
      local skip_byte=lig_kern[current_step][1]
      local next_char=lig_kern[current_step][2]
      local op_byte=lig_kern[current_step][3]
      local remainder=lig_kern[current_step][4]
      local _print = tfm.printdebug()
      _print("-------")
      _print("skip_byte=",skip_byte)
      _print("next_char=",next_char,'C '..string.char(next_char),'O '..string.format("%o",next_char))
      _print("op_byte=",op_byte)
      _print("remainder=",remainder,string.format("O %o",remainder))
      if op_byte <tfm.kern_flag  then -- a ligature step
	 -- op_byte= 4a+2b+c where 0<=a<=b+c and 0<=b,c<=1.
	 local a,b,c
	 c=  op_byte%2
	 b = ((op_byte-c)%4)/2
	 a = (op_byte-2*b-c)/4
	 _print("ligature step: a,b,c=",a,b,c)
	 if b==0 then 
	    _print("current char: deleted") 
	 else 
	    _print("current char: not deleted" ) 
	 end 
	 if c==0 then 
	    _print("next char: deleted") 
	 else 
	    _print("next char: not deleted ") 
	 end
	 if a==0 then 
	    _print("no next char") 
	 else 
	    -- we must pass over the next a characters
	    -- local _,_remainder,_,_,_tag,_ = char_info[current_char+a]
	    -- if _tag==1 then 
	    --    local kern_program = tfm.dump.kernprogram(_remainder,current_char+a)
	    -- end
	 end 
	 tfm.chars[current_char] = tfm.chars[current_char] or {}
	 tfm.chars[current_char].ligature =  tfm.chars[current_char].ligature or {}
	 tfm.chars[current_char].ligature[#tfm.chars[current_char].ligature+1]= 
	    {['next_char']=next_char,['a']=a,['b']=b,['c']=c}

      else -- a kern step
	 local additional_space = kern[256*(op_byte-128)+remainder]
	 _print("kern step:additional_space=",tfm.printfloat(additional_space))
	 tfm.chars[current_char] = tfm.chars[current_char] or {}
	 tfm.chars[current_char].kern =  tfm.chars[current_char].kern or {}
	 tfm.chars[current_char].kern[#tfm.chars[current_char].kern+1] = 
	    {['next_char']=next_char,['additional_space']=additional_space}
      end

      if skip_byte>=tfm.stop_flag then 
	 -- end
	 return 
      else 
	 -- take next instruction	 
	 tfm.dump.kernprogram(current_step+1+skip_byte,current_char)
      end
   end


tfm.build = {}
tfm.build.header =
   function(i,j,w)
      local _i,_j,_a = i,j,{}
      for i=_i,_j do 
	 if i<=1 or i>17 then 
	    _a[i] =2^24*string.byte(w())+2^16*string.byte(w())+2^8*string.byte(w())+string.byte(w())
	 elseif 2<=i and i<=16 then 
	    _a[i] =w()..w()..w()..w()
	 elseif i==17 then 
	    _a[i] ={string.byte(w()),string.byte(w()),string.byte(w()),string.byte(w())}
	 end
      end
      return _a
   end

tfm.build._bytearray = 
   function(i,j,w) 
      local _i,_j,_a = i,j,{}
      for i=_i,_j do 
	 _a[i] ={string.byte(w()),string.byte(w()),string.byte(w()),string.byte(w())}
      end
      return _a
   end
tfm.build.char_info = tfm.build._bytearray
tfm.build.lig_kern  = tfm.build._bytearray
tfm.build.exten     = tfm.build._bytearray

tfm.build._dimension = 
   function(i,j,w) 
      local _i,_j,_a = i,j,{}
      for i=_i,_j do 
	 _a[i] = tfm.int_to_frac(2^24*string.byte(w())+2^16*string.byte(w())+2^8*string.byte(w())+string.byte(w()))
      end
      return _a
   end
tfm.build.width  = tfm.build._dimension
tfm.build.height = tfm.build._dimension
tfm.build.depth  = tfm.build._dimension
tfm.build.italic = tfm.build._dimension
tfm.build.kern   = tfm.build._dimension
tfm.build.param  = tfm.build._dimension

tfm.build.all = 
   function()
      local w  = tfm.parameters.w  
      local lf = tfm.parameters.lf
      local lh = tfm.parameters.lh
      local bc = tfm.parameters.bc
      local ec = tfm.parameters.ec
      local nw = tfm.parameters.nw
      local nh = tfm.parameters.nh
      local nd = tfm.parameters.nd
      local ni = tfm.parameters.ni
      local nl = tfm.parameters.nl
      local nk = tfm.parameters.nk
      local ne = tfm.parameters.ne
      local np = tfm.parameters.np
      tfm.array.header    = tfm.build.header(0,lh-1,w)
      tfm.array.char_info = tfm.build.char_info(bc,ec,w)
      tfm.array.width     = tfm.build.width( 0,nw-1,w)
      tfm.array.height    = tfm.build.height(0,nh-1,w)
      tfm.array.depth     = tfm.build.depth( 0,nd-1,w)
      tfm.array.italic    = tfm.build.italic(0,ni-1,w) 
      tfm.array.lig_kern  = tfm.build.lig_kern(0,nl-1,w)
      tfm.array.kern      = tfm.build.kern(0,nk-1,w)
      tfm.array.exten     = tfm.build.exten(0,ne-1,w)
      tfm.array.param     = tfm.build.param(1,np,w)
   end

tfm.debug = 0
tfm.printdebug = 
   function()
      if tfm.debug==1 then
	 return print
      else
	 return function(...) end
      end
   end

tfm.getdata={}
tfm.getdata.char_info = 
   function(i)
      local char_info = tfm.array.char_info
      local width_index = char_info[i][1]
      local height_index_plus_depth_index = char_info[i][2]
      local italic_index_plus_tag = char_info[i][3]
      local remainder = char_info[i][4]
      local depth_index = height_index_plus_depth_index % 16
      local height_index= (height_index_plus_depth_index -depth_index)/16
      local tag = italic_index_plus_tag % 4
      local italic_index = (italic_index_plus_tag -tag)/4
      return width_index,remainder,depth_index,height_index,tag,italic_index
   end
tfm.chars = {}
tfm.font = {}

tfm.run=
   function(name)
      local name = name
      local _print = tfm.printdebug
      local header    ={}        
      local char_info ={}    
      local width     ={}    
      local height    ={}    
      local depth     ={}    
      local italic    ={}    
      local lig_kern  ={}    
      local kern      ={}    
      local exten     ={}    
      local param     ={}    
      local w   
      local lf 
      local lh 
      local bc 
      local ec 
      local nw 
      local nh 
      local nd 
      local ni 
      local nl 
      local nk 
      local ne 
      local np 

      tfm.name = name
      tfm.file = io.open(tfm.name,'rb')
      if tfm.file == nil then 
	 return false, "Error on opening file "..tostring(tfm.name) 
      end 
      tfm.content = tfm.file:read("*a")
      status,status_msg = tfm.parameters.init()
      if status== false then 
	 _print("ERROR="..tostring(status_msg))
	 return false, tostring(status_msg)
      end

      status,status_msg = tfm.parameters.check()
      if status == false then 
	 _print("ERROR="..tostring(status_msg))
	 return false, tostring(status_msg)
      end
      -- Build all arrays
      tfm.build.all() 
      header    = tfm.array.header          
      char_info = tfm.array.char_info   
      width     = tfm.array.width       
      height    = tfm.array.height      
      depth     = tfm.array.depth       
      italic    = tfm.array.italic      
      lig_kern  = tfm.array.lig_kern    
      kern      = tfm.array.kern        
      exten     = tfm.array.exten       
      param     = tfm.array.param       

      w  = tfm.parameters.w  
      lf = tfm.parameters.lf
      lh = tfm.parameters.lh
      bc = tfm.parameters.bc
      ec = tfm.parameters.ec
      nw = tfm.parameters.nw
      nh = tfm.parameters.nh
      nd = tfm.parameters.nd
      ni = tfm.parameters.ni
      nl = tfm.parameters.nl
      nk = tfm.parameters.nk
      ne = tfm.parameters.ne
      np = tfm.parameters.np

      status,status_msg = tfm.array.check()
      if status == false then 
	 _print("ERROR="..tostring(status_msg))
	 return false, tostring(status_msg)
      end
      tfm.font.checksum =header[0]
      tfm.font.designsize = tfm.int_to_frac(header[1])
      local coding_scheme 
      if header[2]~= nil then 
	 coding_scheme = '' 
	 for j=2,11 do coding_scheme=coding_scheme..tostring(header[j]) end 
	 tfm.font.coding_scheme=coding_scheme
	 _print(string.format("CODING SCHEME:%s",tfm.font.coding_scheme))
      end
      local font_identifier
      if header[12]~= nil then 
	 font_identifier = '' 
	 for j=12,16 do font_identifier=font_identifier..tostring(header[j]) end 
	 tfm.font.font_identifier=font_identifier
	 _print(string.format("FONT IDENTIFIER:%s",tfm.font.font_identifier))
      end
      local  seven_bit_safe_flag ,face
      if header[17]~= nil then
	 seven_bit_safe_flag ,face = header[17][1],header[17][4]
	 tfm.font.seven_bit_safe_flag = seven_bit_safe_flag
	 tfm.font.face = face
	 _print(string.format("SEVEN_BIT_SAFE_FLAG=%x",seven_bit_safe_flag))
	 local f,t = tfm.getface(face)
	 face = f 
	 _print(string.format("FACE=%s (mbl=%d,ri=%d,rce=%d)",face,t[1],t[2],t[3]))
      end
      local _pf = tfm.printfloat
      for current_char=bc,ec do
      --for current_char=102,102 do
	 local width_index,remainder,depth_index,height_index,tag,italic_index = tfm.getdata.char_info(current_char) 
	 tfm.chars[current_char] = tfm.chars[current_char] or {}
	 tfm.chars[current_char].width  = width[width_index]
	 tfm.chars[current_char].height = height[height_index]
	 tfm.chars[current_char].depth  = depth[depth_index]
	 tfm.chars[current_char].italic = italic[italic_index]
	 tfm.chars[current_char].tag    = tag
	 _print(i,string.format("O %o",current_char),string.char(current_char),
	       'WIDTH='.._pf(width[width_index]), 
	       'HEIGHT='.._pf(height[height_index]),
	       'DEPTH='.._pf(depth[depth_index]),
	       'ITALIC='.._pf(italic[italic_index]),
	       'TAG='..tfm.tag_meaning(tag)
	    )
	 if tag==1 then -- character has a ligature/kerning program
	    local kern_program = tfm.dump.kernprogram(remainder,current_char)
	 end
      end
      tfm.font.slant = param[1]
      _print("SLANT=".._pf(tfm.font.slant))

      tfm.font.space  = param[2]
      _print("SPACE=".._pf(tfm.font.space))

      tfm.font.space_stretch  = param[3]
      _print("SPACE_STRETCH=".._pf(tfm.font.space_stretch))

      tfm.font.space_shrink  = param[4]
      _print("SPACE_SHRINK=".._pf(tfm.font.space_shrink))

      tfm.font.x_height = param[5]
      _print("X_HEIGHT=".._pf(tfm.font.x_height))

      tfm.font.quad = param[6]
      _print("QUAD=".._pf(tfm.font.quad))

      tfm.font.extra_space = param[7]
      _print("EXTRA_SPACE=".._pf(tfm.font.extra_space))
      
      return true,'ok'

   end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
return tfm
--[==[
local status,status_msg
local name = 'test.tfm'
tfm.debug = 0
status,status_msg = tfm.run(name)
print(tfm.chars[2].width)
os.exit(0)
]==]
--[==[
tfm.name = 'test.tfm'
tfm.file = io.open(tfm.name,'rb')
if tfm.file == nil then 
   return false, "Error on opening file "..tostring(tfm.name) 
end 

tfm.content = tfm.file:read("*a")
status,status_msg = tfm.parameters.init()
if status== false then 
   print("ERROR="..tostring(status_msg))
   return false, tostring(status_msg)
end

status,status_msg = tfm.parameters.check()
if status == false then 
   print("ERROR="..tostring(status_msg))
   return false, tostring(status_msg)
end

-- Build all arrays
tfm.build.all() 


local w  = tfm.parameters.w  
local lf = tfm.parameters.lf
local lh = tfm.parameters.lh
local bc = tfm.parameters.bc
local ec = tfm.parameters.ec
local nw = tfm.parameters.nw
local nh = tfm.parameters.nh
local nd = tfm.parameters.nd
local ni = tfm.parameters.ni
local nl = tfm.parameters.nl
local nk = tfm.parameters.nk
local ne = tfm.parameters.ne
local np = tfm.parameters.np




print("length of the entire file, in words lf=",lf )
print("length of the header data, in words lh=",lh )
print("smallest character code in the font bc=",bc )
print("largest character code in the font ec=",ec )
print("number of words in the width table nw=",nw )
print("number of words in the height table nh=",nh )
print("number of words in the depth table nd=",nd )
print("number of words in the italic correction table ni=",ni )
print("number of words in the lig/kern table nl=",nl )
print("number of words in the kern table nk=",nk )
print("number of words in the extensible character table ne=",ne )
print("number of font parameter words np=",np )


local header    = tfm.array.header      
local char_info = tfm.array.char_info   
local width     = tfm.array.width       
local height    = tfm.array.height      
local depth     = tfm.array.depth       
local italic    = tfm.array.italic      
local lig_kern  = tfm.array.lig_kern    
local kern      = tfm.array.kern        
local exten     = tfm.array.exten       
local param     = tfm.array.param       


status,status_msg = tfm.array.check()
if status == false then 
   print("ERROR="..tostring(status_msg))
   return false, tostring(status_msg)
end


local garbage = w()
if garbage~=nil then 
   print("GARBAGE AT END ?")
   while garbage ~= nil do
      print(" ",garbage, string.byte(garbage))
      garbage = w()
   end
end


tfm.font.checksum =header[0]
tfm.font.designsize = tfm.int_to_frac(header[1])

print(string.format("CHECKSUM O %o",tfm.font.checksum))
print(string.format("DESIGNSIZE R %.1f",tfm.font.designsize))

local coding_scheme 
if header[2]~= nil then 
   coding_scheme = '' 
   for j=2,11 do coding_scheme=coding_scheme..tostring(header[j]) end 
   tfm.font.coding_scheme=coding_scheme
   print(string.format("CODING SCHEME:%s",tfm.font.coding_scheme))
end


local font_identifier
if header[12]~= nil then 
   font_identifier = '' 
   for j=12,16 do font_identifier=font_identifier..tostring(header[j]) end 
   tfm.font.font_identifier=font_identifier
   print(string.format("FONT IDENTIFIER:%s",tfm.font.font_identifier))
end

local  seven_bit_safe_flag ,face
if header[17]~= nil then
   seven_bit_safe_flag ,face = header[17][1],header[17][4]
   tfm.font.seven_bit_safe_flag = seven_bit_safe_flag
   tfm.font.face = face
   print(string.format("SEVEN_BIT_SAFE_FLAG=%x",seven_bit_safe_flag))
   local f,t = tfm.getface(face)
   face = f 
   print(string.format("FACE=%s (mbl=%d,ri=%d,rce=%d)",face,t[1],t[2],t[3]))
end


print('MAX INDEX FOR LIG_KERN='..tostring(nl-1))
print('MIN INDEX='..tostring(bc),'MAX INDEX='..tostring(ec))
local _pf = tfm.printfloat
--for i=bc,ec do
for current_char=102,102 do
   local width_index,remainder,depth_index,height_index,tag,italic_index = tfm.getdata.char_info(current_char) 
   tfm.chars[current_char] = tfm.chars[current_char] or {}
   tfm.chars[current_char].width  = width[width_index]
   tfm.chars[current_char].height = height[height_index]
   tfm.chars[current_char].depth  = depth[depth_index]
   tfm.chars[current_char].italic = italic[italic_index]
   tfm.chars[current_char].tag    = tag
   print(i,string.format("O %o",current_char),string.char(current_char),
	 'WIDTH='.._pf(width[width_index]), 
	 'HEIGHT='.._pf(height[height_index]),
	 'DEPTH='.._pf(depth[depth_index]),
	 'ITALIC='.._pf(italic[italic_index]),
	 'TAG='..tfm.tag_meaning(tag)
      )
   if tag==1 then -- character has a ligature/kerning program
      local kern_program = tfm.dump.kernprogram(remainder,current_char)
   end
end

tfm.font.slant = param[1]
print("SLANT=".._pf(tfm.font.slant))

tfm.font.space  = param[2]
print("SPACE=".._pf(tfm.font.space))

tfm.font.space_stretch  = param[3]
print("SPACE_STRETCH=".._pf(tfm.font.space_stretch))

tfm.font.space_shrink  = param[4]
print("SPACE_SHRINK=".._pf(tfm.font.space_shrink))

tfm.font.x_height = param[5]
print("X_HEIGHT=".._pf(tfm.font.x_height))

tfm.font.quad = param[6]
print("QUAD=".._pf(tfm.font.quad))

tfm.font.extra_space = param[7]
print("EXTRA_SPACE=".._pf(tfm.font.extra_space))

os.exit(0)
]==]
