require("fflua")

local function CHR(a,b,c,d)
-- CHR(ch1,ch2,ch3,ch4) (((ch1)<<24)|((ch2)<<16)|((ch3)<<8)|(ch4))
 local a =  tostring(a) or ''
 local b =  tostring(b) or ''
 local c =  tostring(c) or ''
 local d =  tostring(d) or ''
 local len = string.len
 local byte= string.byte
 assert(len(a)==1,"Error on input data:first char must 1 byte")
 assert(len(b)==1,"Error on input data:second char must 1 byte")
 assert(len(c)==1,"Error on input data:third  char must 1 byte")
 assert(len(d)==1,"Error on input data:fourth char must 1 byte")
 return byte(a)*2^24+byte(b)*2^16+byte(c)*2^8+byte(d)*8^0
 
end

if fflua.CHR ~= nil then fflua.CHR = CHR end


local fontfile  = "ConcreteOT.svg"

local openflags = 0
local sf = fflua.LoadSplineFont(fontfile,openflags)
--print(sf)
--print(sf.map.enc.enc_name)
lk = fflua.SFFindLookup(sf,sf.gsub_lookups.lookup_name)
--print(lk.lookup_name) 
--print(lk.lookup_type)
--print(swig_type(lk.features.featuretag),lk.features.featuretag)
--print(swig_type(lk.features.scripts),lk.features.scripts)
--print(swig_type(lk.features.scripts.script),lk.features.scripts.script)

script_tag = CHR('D','F','L','T')
lang_tag   = fflua.DEFAULT_LANG 
fflua.FListAppendScriptLang(lk.features,script_tag,lang_tag)

encmap = sf.map
fflua.SFDWrite("ConcreteOT.sfd",sf,encmap,encmap,0)

-- extern int GenerateScript(SplineFont *sf,char *filename,char *bitmaptype,
--        int fmflags,int res, char *subfontdirectory,struct sflist *sfs,
--                EncMap *map,NameList *rename_to,int layer);
--
filename = "ConcreteOT.otf"
bitmaptype = ""
fmflags = -1
res = -1
subfontdirectory = ""
sfs = nil
map = sf.map
rename_to = fflua.DefaultNameListForNewFonts()
layer = 1
fflua.GenerateScript(sf,filename,bitmaptype,
                         fmflags,res,subfontdirectory,sfs,
                         map,rename_to,layer);
--[===[>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<]===]--
