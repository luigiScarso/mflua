{3:}program DVItoMP(dvifile,mpxfile,output);label{4:}9999,30;
{:4}const{5:}maxfonts=1000;maxfnums=3000;maxwidths=256*maxfonts;
virtualspace=1000000;linelength=79;stacksize=100;namesize=100000;
namelength=250;{:5}{109:}maxnamedcolors=100;
{:109}{119:}maxcolorstackdepth=10;{:119}type{11:}ASCIIcode=0..255;
{:11}{12:}textfile=packed file of ASCIIcode;{:12}{17:}eightbits=0..255;
bytefile=packed file of eightbits;{:17}{25:}quarterword=0..255;
{:25}{110:}namedcolorrecord=record name:cstring;value:cstring;end;
{:110}var{8:}history:0..3;{:8}{13:}mpxfile:textfile;
xchr:array[0..255]of ASCIIcode;{:13}{18:}dvifile:bytefile;
tfmfile:bytefile;vffile:bytefile;downthedrain:integer;
{:18}{20:}curname:^char;{:20}{21:}b0,b1,b2,b3:eightbits;
{:21}{23:}vfreading:boolean;
cmdbuf:packed array[0..virtualspace]of quarterword;
bufptr:0..virtualspace;{:23}{32:}fontnum:array[0..maxfnums]of integer;
internalnum:array[0..maxfnums]of integer;
localonly:array[0..maxfnums]of boolean;
fontname:array[0..maxfonts]of 0..namesize;
names:array[0..namesize]of ASCIIcode;
arealength:array[0..maxfonts]of integer;
fontscaledsize:array[0..maxfonts]of real;
fontdesignsize:array[0..maxfonts]of real;
fontchecksum:array[0..maxfonts]of integer;
fontbc:array[0..maxfonts]of integer;fontec:array[0..maxfonts]of integer;
infobase:array[0..maxfonts]of integer;
width:array[0..maxwidths]of integer;fbase:array[0..maxfonts]of integer;
ftop:array[0..maxfonts]of integer;cmdptr:array[0..maxwidths]of integer;
nf:0..maxfonts;vfptr:maxfonts..maxfnums;infoptr:0..maxwidths;
ncmds:0..virtualspace;curfbase,curftop:0..maxfnums;
{:32}{40:}dviperfix:real;{:40}{44:}inwidth:array[0..255]of integer;
tfmchecksum:integer;{:44}{67:}state:0..2;printcol:0..linelength;
{:67}{72:}h,v:integer;conv:real;mag:real;
{:72}{74:}fontused:array[0..maxfonts]of boolean;fontsused:boolean;
rulesused:boolean;strh1,strv:integer;strh2:integer;strf:integer;
strscale:real;{:74}{82:}picdp,picht,picwd:integer;
{:82}{86:}w,x,y,z:integer;
hstack,vstack,wstack,xstack,ystack,zstack:array[0..stacksize]of integer;
stksiz:integer;dviscale:real;{:86}{99:}k,p:integer;
numerator,denominator:integer;{:99}{107:}dviname,mpxname:cstring;
{:107}{111:}namedcolors:array[1..maxnamedcolors]of namedcolorrecord;
numnamedcolors:integer;{:111}{120:}colorstackdepth:integer;
colorstack:array[1..maxcolorstackdepth]of cstring;
{:120}{103:}procedure parsearguments;const noptions=2;
var longoptions:array[0..noptions]of getoptstruct;
getoptreturnval:integer;optionindex:cinttype;currentoption:0..noptions;
begin{104:}currentoption:=0;longoptions[currentoption].name:='help';
longoptions[currentoption].hasarg:=0;longoptions[currentoption].flag:=0;
longoptions[currentoption].val:=0;currentoption:=currentoption+1;
{:104}{105:}longoptions[currentoption].name:='version';
longoptions[currentoption].hasarg:=0;longoptions[currentoption].flag:=0;
longoptions[currentoption].val:=0;currentoption:=currentoption+1;
{:105}{106:}longoptions[currentoption].name:=0;
longoptions[currentoption].hasarg:=0;longoptions[currentoption].flag:=0;
longoptions[currentoption].val:=0;{:106};
repeat getoptreturnval:=getoptlongonly(argc,argv,'',longoptions,
addressof(optionindex));if getoptreturnval=-1 then begin;
end else if getoptreturnval=63 then begin usage('dvitomp');
end else if(strcmp(longoptions[optionindex].name,'help')=0)then begin
usagehelp(DVITOMPHELP,nil);
end else if(strcmp(longoptions[optionindex].name,'version')=0)then begin
printversionandexit('This is DVItoMP, Version 1.003/color',
'AT&T Bell Laboraties','John Hobby.',nil);end;until getoptreturnval=-1;
if(optind+1<>argc)and(optind+2<>argc)then begin writeln(stderr,
'dvitomp: Need one or two file arguments.');usage('dvitomp');end;
dviname:=cmdline(optind);
if optind+2<=argc then begin mpxname:=cmdline(optind+1);
end else begin mpxname:=basenamechangesuffix(dviname,'.dvi','.mpx');end;
end;{:103}{112:}procedure defnamedcolor(n,v:cstring);
begin if numnamedcolors=maxnamedcolors then begin writeln(
'DVItoMP abort: ','too many named color definitions');history:=3;
uexit(history);
end else if(numnamedcolors>0)and(strcmp(n,namedcolors[numnamedcolors].
name)<=0)then begin writeln('DVItoMP abort: ',
'named colors added out of alphabetical order');history:=3;
uexit(history);end;numnamedcolors:=numnamedcolors+1;
namedcolors[numnamedcolors].name:=n;
namedcolors[numnamedcolors].value:=v end;{:112}procedure initialize;
var i:integer;begin kpsesetprogname(argv[0]);parsearguments;
{9:}history:=0;{:9}{15:}for i:=0 to 31 do xchr[i]:='?';xchr[32]:=' ';
xchr[33]:='!';xchr[34]:='"';xchr[35]:='#';xchr[36]:='$';xchr[37]:='%';
xchr[38]:='&';xchr[39]:='''';xchr[40]:='(';xchr[41]:=')';xchr[42]:='*';
xchr[43]:='+';xchr[44]:=',';xchr[45]:='-';xchr[46]:='.';xchr[47]:='/';
xchr[48]:='0';xchr[49]:='1';xchr[50]:='2';xchr[51]:='3';xchr[52]:='4';
xchr[53]:='5';xchr[54]:='6';xchr[55]:='7';xchr[56]:='8';xchr[57]:='9';
xchr[58]:=':';xchr[59]:=';';xchr[60]:='<';xchr[61]:='=';xchr[62]:='>';
xchr[63]:='?';xchr[64]:='@';xchr[65]:='A';xchr[66]:='B';xchr[67]:='C';
xchr[68]:='D';xchr[69]:='E';xchr[70]:='F';xchr[71]:='G';xchr[72]:='H';
xchr[73]:='I';xchr[74]:='J';xchr[75]:='K';xchr[76]:='L';xchr[77]:='M';
xchr[78]:='N';xchr[79]:='O';xchr[80]:='P';xchr[81]:='Q';xchr[82]:='R';
xchr[83]:='S';xchr[84]:='T';xchr[85]:='U';xchr[86]:='V';xchr[87]:='W';
xchr[88]:='X';xchr[89]:='Y';xchr[90]:='Z';xchr[91]:='[';xchr[92]:='\';
xchr[93]:=']';xchr[94]:='^';xchr[95]:='_';xchr[96]:='`';xchr[97]:='a';
xchr[98]:='b';xchr[99]:='c';xchr[100]:='d';xchr[101]:='e';
xchr[102]:='f';xchr[103]:='g';xchr[104]:='h';xchr[105]:='i';
xchr[106]:='j';xchr[107]:='k';xchr[108]:='l';xchr[109]:='m';
xchr[110]:='n';xchr[111]:='o';xchr[112]:='p';xchr[113]:='q';
xchr[114]:='r';xchr[115]:='s';xchr[116]:='t';xchr[117]:='u';
xchr[118]:='v';xchr[119]:='w';xchr[120]:='x';xchr[121]:='y';
xchr[122]:='z';xchr[123]:='{';xchr[124]:='|';xchr[125]:='}';
xchr[126]:='~';for i:=127 to 255 do xchr[i]:='?';
{:15}{24:}vfreading:=false;bufptr:=virtualspace;{:24}{33:}nf:=0;
infoptr:=0;fontname[0]:=0;vfptr:=maxfnums;curfbase:=0;curftop:=0;
{:33}{71:}state:=2;{:71}{113:}numnamedcolors:=0;
defnamedcolor('Apricot','(1.0, 0.680006, 0.480006)');
defnamedcolor('Aquamarine','(0.180006, 1.0, 0.7)');
defnamedcolor('Bittersweet','(0.760012, 0.0100122, 0.0)');
defnamedcolor('Black','(0.0, 0.0, 0.0)');
defnamedcolor('Blue','(0.0, 0.0, 1.0)');
defnamedcolor('BlueGreen','(0.15, 1.0, 0.669994)');
defnamedcolor('BlueViolet','(0.1, 0.05, 0.960012)');
defnamedcolor('BrickRed','(0.719994, 0.0, 0.0)');
defnamedcolor('Brown','(0.4, 0.0, 0.0)');
defnamedcolor('BurntOrange','(1.0, 0.489988, 0.0)');
defnamedcolor('CadetBlue','(0.380006, 0.430006, 0.769994)');
defnamedcolor('CarnationPink','(1.0, 0.369994, 1.0)');
defnamedcolor('Cerulean','(0.0600122, 0.889988, 1.0)');
defnamedcolor('CornflowerBlue','(0.35, 0.869994, 1.0)');
defnamedcolor('Cyan','(0.0, 1.0, 1.0)');
defnamedcolor('Dandelion','(1.0, 0.710012, 0.160012)');
defnamedcolor('DarkOrchid','(0.6, 0.2, 0.8)');
defnamedcolor('Emerald','(0.0, 1.0, 0.5)');
defnamedcolor('ForestGreen','(0.0, 0.880006, 0.0)');
defnamedcolor('Fuchsia','(0.45, 0.00998169, 0.919994)');
defnamedcolor('Goldenrod','(1.0, 0.9, 0.160012)');
defnamedcolor('Gray','(0.5, 0.5, 0.5)');
defnamedcolor('Green','(0.0, 1.0, 0.0)');
defnamedcolor('GreenYellow','(0.85, 1.0, 0.310012)');
defnamedcolor('JungleGreen','(0.0100122, 1.0, 0.480006)');
defnamedcolor('Lavender','(1.0, 0.519994, 1.0)');
defnamedcolor('LimeGreen','(0.5, 1.0, 0.0)');
defnamedcolor('Magenta','(1.0, 0.0, 1.0)');
defnamedcolor('Mahogany','(0.65, 0.0, 0.0)');
defnamedcolor('Maroon','(0.680006, 0.0, 0.0)');
defnamedcolor('Melon','(1.0, 0.539988, 0.5)');
defnamedcolor('MidnightBlue','(0.0, 0.439988, 0.569994)');
defnamedcolor('Mulberry','(0.640018, 0.0800061, 0.980006)');
defnamedcolor('NavyBlue','(0.0600122, 0.460012, 1.0)');
defnamedcolor('OliveGreen','(0.0, 0.6, 0.0)');
defnamedcolor('Orange','(1.0, 0.389988, 0.130006)');
defnamedcolor('OrangeRed','(1.0, 0.0, 0.5)');
defnamedcolor('Orchid','(0.680006, 0.360012, 1.0)');
defnamedcolor('Peach','(1.0, 0.5, 0.3)');
defnamedcolor('Periwinkle','(0.430006, 0.45, 1.0)');
defnamedcolor('PineGreen','(0.0, 0.75, 0.160012)');
defnamedcolor('Plum','(0.5, 0.0, 1.0)');
defnamedcolor('ProcessBlue','(0.0399878, 1.0, 1.0)');
defnamedcolor('Purple','(0.55, 0.139988, 1.0)');
defnamedcolor('RawSienna','(0.55, 0.0, 0.0)');
defnamedcolor('Red','(1.0, 0.0, 0.0)');
defnamedcolor('RedOrange','(1.0, 0.230006, 0.130006)');
defnamedcolor('RedViolet','(0.590018, 0.0, 0.660012)');
defnamedcolor('Rhodamine','(1.0, 0.180006, 1.0)');
defnamedcolor('RoyalBlue','(0.0, 0.5, 1.0)');
defnamedcolor('RoyalPurple','(0.25, 0.1, 1.0)');
defnamedcolor('RubineRed','(1.0, 0.0, 0.869994)');
defnamedcolor('Salmon','(1.0, 0.469994, 0.619994)');
defnamedcolor('SeaGreen','(0.310012, 1.0, 0.5)');
defnamedcolor('Sepia','(0.3, 0.0, 0.0)');
defnamedcolor('SkyBlue','(0.380006, 1.0, 0.880006)');
defnamedcolor('SpringGreen','(0.739988, 1.0, 0.239988)');
defnamedcolor('Tan','(0.860012, 0.580006, 0.439988)');
defnamedcolor('TealBlue','(0.119994, 0.980006, 0.640018)');
defnamedcolor('Thistle','(0.880006, 0.410012, 1.0)');
defnamedcolor('Turquoise','(0.15, 1.0, 0.8)');
defnamedcolor('Violet','(0.210012, 0.119994, 1.0)');
defnamedcolor('VioletRed','(1.0, 0.189988, 1.0)');
defnamedcolor('White','(1.0, 1.0, 1.0)');
defnamedcolor('WildStrawberry','(1.0, 0.0399878, 0.610012)');
defnamedcolor('Yellow','(1.0, 1.0, 0.0)');
defnamedcolor('YellowGreen','(0.560012, 1.0, 0.260012)');
defnamedcolor('YellowOrange','(1.0, 0.580006, 0.0)');
{:113}{121:}colorstackdepth:=0;{:121}end;{:3}{14:}procedure openmpxfile;
begin curname:=extendfilename(mpxname,'mpx');rewrite(mpxfile,curname);
end;{:14}{19:}procedure opendvifile;
begin curname:=extendfilename(dviname,'dvi');resetbin(dvifile,curname);
end;function opentfmfile:boolean;
begin tfmfile:=kpseopenfile(curname,kpsetfmformat);free(curname);
opentfmfile:=true;end;function openvffile:boolean;var fullname:^char;
begin fullname:=kpsefindvf(curname);
if fullname then begin resetbin(vffile,fullname);free(curname);
free(fullname);openvffile:=true;end else openvffile:=false;end;
{:19}{22:}procedure readtfmword;begin read(tfmfile,b0);read(tfmfile,b1);
read(tfmfile,b2);read(tfmfile,b3);end;
{:22}{26:}function getbyte:integer;var b:eightbits;
begin{27:}if vfreading then read(vffile,b)else if bufptr=virtualspace
then read(dvifile,b)else begin b:=cmdbuf[bufptr];bufptr:=bufptr+1;
end{:27};getbyte:=b;end;function signedbyte:integer;var b:eightbits;
begin{27:}if vfreading then read(vffile,b)else if bufptr=virtualspace
then read(dvifile,b)else begin b:=cmdbuf[bufptr];bufptr:=bufptr+1;
end{:27};if b<128 then signedbyte:=b else signedbyte:=b-256;end;
function gettwobytes:integer;var a,b:eightbits;begin a:=0;b:=0;
{28:}if vfreading then begin read(vffile,a);read(vffile,b);
end else if bufptr=virtualspace then begin read(dvifile,a);
read(dvifile,b);
end else if bufptr+2>ncmds then begin writeln('DVItoMP abort: ',
'Error detected while interpreting a virtual font');history:=3;
uexit(history);end else begin a:=cmdbuf[bufptr];b:=cmdbuf[bufptr+1];
bufptr:=bufptr+2;end{:28};gettwobytes:=a*intcast(256)+b;end;
function signedpair:integer;var a,b:eightbits;begin a:=0;b:=0;
{28:}if vfreading then begin read(vffile,a);read(vffile,b);
end else if bufptr=virtualspace then begin read(dvifile,a);
read(dvifile,b);
end else if bufptr+2>ncmds then begin writeln('DVItoMP abort: ',
'Error detected while interpreting a virtual font');history:=3;
uexit(history);end else begin a:=cmdbuf[bufptr];b:=cmdbuf[bufptr+1];
bufptr:=bufptr+2;end{:28};
if a<128 then signedpair:=a*256+b else signedpair:=(a-256)*256+b;end;
function getthreebytes:integer;var a,b,c:eightbits;begin a:=0;b:=0;c:=0;
{29:}if vfreading then begin read(vffile,a);read(vffile,b);
read(vffile,c);
end else if bufptr=virtualspace then begin read(dvifile,a);
read(dvifile,b);read(dvifile,c);
end else if bufptr+3>ncmds then begin writeln('DVItoMP abort: ',
'Error detected while interpreting a virtual font');history:=3;
uexit(history);end else begin a:=cmdbuf[bufptr];b:=cmdbuf[bufptr+1];
c:=cmdbuf[bufptr+2];bufptr:=bufptr+3;end{:29};
getthreebytes:=(a*intcast(256)+b)*256+c;end;function signedtrio:integer;
var a,b,c:eightbits;begin a:=0;b:=0;c:=0;
{29:}if vfreading then begin read(vffile,a);read(vffile,b);
read(vffile,c);
end else if bufptr=virtualspace then begin read(dvifile,a);
read(dvifile,b);read(dvifile,c);
end else if bufptr+3>ncmds then begin writeln('DVItoMP abort: ',
'Error detected while interpreting a virtual font');history:=3;
uexit(history);end else begin a:=cmdbuf[bufptr];b:=cmdbuf[bufptr+1];
c:=cmdbuf[bufptr+2];bufptr:=bufptr+3;end{:29};
if a<128 then signedtrio:=(a*intcast(256)+b)*256+c else signedtrio:=((a-
intcast(256))*256+b)*256+c;end;function signedquad:integer;
var a,b,c,d:eightbits;begin a:=0;b:=0;c:=0;d:=0;
{30:}if vfreading then begin read(vffile,a);read(vffile,b);
read(vffile,c);read(vffile,d);
end else if bufptr=virtualspace then begin read(dvifile,a);
read(dvifile,b);read(dvifile,c);read(dvifile,d);
end else if bufptr+4>ncmds then begin writeln('DVItoMP abort: ',
'Error detected while interpreting a virtual font');history:=3;
uexit(history);end else begin a:=cmdbuf[bufptr];b:=cmdbuf[bufptr+1];
c:=cmdbuf[bufptr+2];d:=cmdbuf[bufptr+3];bufptr:=bufptr+4;end{:30};
if a<128 then signedquad:=((a*intcast(256)+b)*256+c)*256+d else
signedquad:=(((a-256)*intcast(256)+b)*256+c)*256+d;end;
{:26}{34:}{68:}procedure printchar(c:eightbits);var printable:boolean;
l:integer;begin printable:=(c>=32)and(c<=126)and(c<>34);
if printable then l:=1 else if c<10 then l:=5 else if c<100 then l:=6
else l:=7;
if printcol+l>linelength-2 then begin if state=1 then begin write(
mpxfile,'"');state:=0;end;writeln(mpxfile,' ');printcol:=0;end;
{69:}if state=1 then if printable then write(mpxfile,xchr[c])else begin
write(mpxfile,'"&char',c:1);printcol:=printcol+2;
end else begin if state=0 then begin write(mpxfile,'&');
printcol:=printcol+1;end;
if printable then begin write(mpxfile,'"',xchr[c]);printcol:=printcol+1;
end else write(mpxfile,'char',c:1);end;printcol:=printcol+l;
if printable then state:=1 else state:=0{:69};end;
{:68}{70:}procedure endcharstring(l:integer);
begin while state>0 do begin write(mpxfile,'"');printcol:=printcol+1;
state:=state-1;end;
if printcol+l>linelength then begin writeln(mpxfile,' ');printcol:=0;
end;state:=2;end;{:70}procedure printfont(f:integer);var k:0..namesize;
begin if(f<0)or(f>=nf)then begin writeln('DVItoMP abort: ',
'Bad DVI file: ','Undefined font','!');history:=3;uexit(history);
end else begin for k:=fontname[f]to fontname[f+1]-1 do printchar(names[k
]);end;end;{:34}{35:}procedure errprintfont(f:integer);
var k:0..namesize;
begin for k:=fontname[f]to fontname[f+1]-1 do write(xchr[names[k]]);
writeln(' ');end;{:35}{36:}{41:}function matchfont(ff:integer;
exact:boolean):integer;label 30,99;var f:0..maxfonts;ss,ll:0..namesize;
k,s:0..namesize;begin ss:=fontname[ff];ll:=fontname[ff+1]-ss;f:=0;
while f<nf do begin if f<>ff then begin{42:}if(arealength[f]<arealength[
ff])or(ll<>fontname[f+1]-fontname[f])then goto 99;s:=fontname[f];k:=ll;
while k>0 do begin k:=k-1;if names[s+k]<>names[ss+k]then goto 99;
end{:42};
if exact then begin if fabs(fontscaledsize[f]-fontscaledsize[ff])<=
0.00001 then begin if not vfreading then begin if localonly[f]then begin
fontnum[f]:=fontnum[ff];localonly[f]:=false;
end else if fontnum[f]<>fontnum[ff]then goto 99;end;goto 30;end;
end else if infobase[f]<>maxwidths then goto 30;end;99:f:=f+1;end;
30:if f<nf then begin{43:}if fabs(fontdesignsize[f]-fontdesignsize[ff])>
0.00001 then begin write('DVItoMP warning: ',
'Inconsistent design sizes given for ');errprintfont(ff);history:=2;
end else if fontchecksum[f]<>fontchecksum[ff]then begin write(
'DVItoMP warning: Checksum mismatch for ');errprintfont(ff);
if history=0 then history:=1;end{:43};end;matchfont:=f;end;
{:41}procedure definefont(e:integer);var i:integer;n:integer;k:integer;
x:integer;begin if nf=maxfonts then begin writeln('DVItoMP abort: ',
'DVItoMP capacity exceeded (max fonts=',maxfonts:1,')!');history:=3;
uexit(history);end;
{37:}if vfptr=nf then begin writeln('DVItoMP abort: ',
'DVItoMP capacity exceeded (max font numbers=',maxfnums:1,')');
history:=3;uexit(history);end;if vfreading then begin fontnum[nf]:=0;
i:=vfptr;vfptr:=vfptr-1;end else i:=nf;fontnum[i]:=e{:37};
{38:}fontchecksum[nf]:=signedquad;{39:}x:=signedquad;k:=1;
while x>8388608 do begin x:=x div 2;k:=k+k;end;
fontscaledsize[nf]:=x*k/1048576.0;
if vfreading then fontdesignsize[nf]:=signedquad*dviperfix/1048576.0
else fontdesignsize[nf]:=signedquad/1048576.0;{:39};n:=getbyte;
arealength[nf]:=n;n:=n+getbyte;
if fontname[nf]+n>namesize then begin writeln('DVItoMP abort: ',
'DVItoMP capacity exceeded (name size=',namesize:1,')!');history:=3;
uexit(history);end;fontname[nf+1]:=fontname[nf]+n;
for k:=fontname[nf]to fontname[nf+1]-1 do names[k]:=getbyte{:38};
internalnum[i]:=matchfont(nf,true);
if internalnum[i]=nf then begin infobase[nf]:=maxwidths;
localonly[nf]:=vfreading;nf:=nf+1;end;end;
{:36}{45:}procedure inTFM(f:integer);label 9997,9999;var k:integer;
lh:integer;nw:integer;wp:0..maxwidths;begin{46:}readtfmword;
lh:=b2*intcast(256)+b3;readtfmword;fontbc[f]:=b0*intcast(256)+b1;
fontec[f]:=b2*intcast(256)+b3;
if fontec[f]<fontbc[f]then fontbc[f]:=fontec[f]+1;
if infoptr+fontec[f]-fontbc[f]+1>maxwidths then begin writeln(
'DVItoMP abort: ','DVItoMP capacity exceeded (width table size=',
maxwidths:1,')!');history:=3;uexit(history);end;
wp:=infoptr+fontec[f]-fontbc[f]+1;readtfmword;nw:=b0*256+b1;
if(nw=0)or(nw>256)then goto 9997;
for k:=1 to 3+lh do begin if eof(tfmfile)then goto 9997;readtfmword;
if k=4 then begin if b0<128 then tfmchecksum:=((b0*intcast(256)+b1)*256+
b2)*256+b3 else tfmchecksum:=(((b0-256)*intcast(256)+b1)*256+b2)*256+b3;
end;end;{:46};
{47:}if wp>0 then for k:=infoptr to wp-1 do begin readtfmword;
if b0>nw then goto 9997;width[k]:=b0;end;{:47};
{48:}for k:=0 to nw-1 do begin readtfmword;if b0>127 then b0:=b0-256;
inwidth[k]:=((b0*256+b1)*256+b2)*256+b3;end{:48};
{51:}if inwidth[0]<>0 then goto 9997;infobase[f]:=infoptr-fontbc[f];
if wp>0 then for k:=infoptr to wp-1 do width[k]:=inwidth[width[k]]{:51};
fbase[f]:=0;ftop[f]:=0;infoptr:=wp;goto 9999;
9997:begin write('DVItoMP abort: ','Bad TFM file for ');errprintfont(f);
history:=3;uexit(history);end;9999:end;
{:45}{52:}{90:}function firstpar(o:eightbits):integer;begin firstpar:=0;
case o of 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,
24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,
48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,
72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,
96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,
115,116,117,118,119,120,121,122,123,124,125,126,127:firstpar:=o-0;
128,133,235,239,243:firstpar:=getbyte;
129,134,236,240,244:firstpar:=gettwobytes;
130,135,237,241,245:firstpar:=getthreebytes;
143,148,153,157,162,167:firstpar:=signedbyte;
144,149,154,158,163,168:firstpar:=signedpair;
145,150,155,159,164,169:firstpar:=signedtrio;
131,132,136,137,146,151,156,160,165,170,238,242,246:firstpar:=signedquad
;138,139,140,141,142,247,248,249,250,251,252,253,254,255:firstpar:=0;
147:firstpar:=w;152:firstpar:=x;161:firstpar:=y;166:firstpar:=z;
171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,
189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,
207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,
225,226,227,228,229,230,231,232,233,234:firstpar:=o-171;end;end;
{:90}procedure inVF(f:integer);label 9997,9999;var p:integer;
wasvfreading:boolean;c:integer;limit:integer;w:integer;
begin wasvfreading:=vfreading;vfreading:=true;{53:}p:=getbyte;
if p<>247 then goto 9997;p:=getbyte;if p<>202 then goto 9997;p:=getbyte;
while p>0 do begin p:=p-1;downthedrain:=getbyte;end;
tfmchecksum:=signedquad;downthedrain:=signedquad;{:53};
{54:}ftop[f]:=vfptr;if vfptr=nf then begin writeln('DVItoMP abort: ',
'DVItoMP capacity exceeded (max font numbers=',maxfnums:1,')');
history:=3;uexit(history);end;vfptr:=vfptr-1;infobase[f]:=infoptr;
limit:=maxwidths-infobase[f];fontbc[f]:=limit;fontec[f]:=0{:54};
p:=getbyte;while p>=243 do begin if p>246 then goto 9997;
definefont(firstpar(p));p:=getbyte;end;
while p<=242 do begin if eof(vffile)then goto 9997;
{55:}if p=242 then begin p:=signedquad;c:=signedquad;w:=signedquad;
if c<0 then goto 9997;end else begin c:=getbyte;w:=getthreebytes;end;
if c>=limit then begin writeln('DVItoMP abort: ',
'DVItoMP capacity exceeded (max widths=',maxwidths:1,')!');history:=3;
uexit(history);end;if c<fontbc[f]then fontbc[f]:=c;
if c>fontec[f]then fontec[f]:=c;width[infobase[f]+c]:=w{:55};
{56:}if ncmds+p>=virtualspace then begin writeln('DVItoMP abort: ',
'DVItoMP capacity exceeded (virtual font space=',virtualspace:1,')!');
history:=3;uexit(history);end;cmdptr[infobase[f]+c]:=ncmds;
while p>0 do begin cmdbuf[ncmds]:=getbyte;ncmds:=ncmds+1;p:=p-1;end;
cmdbuf[ncmds]:=140;ncmds:=ncmds+1{:56};p:=getbyte;end;
if p=248 then begin{57:}fbase[f]:=vfptr+1;
infoptr:=infobase[f]+fontec[f]+1{:57};goto 9999;end;
9997:begin write('DVItoMP abort: ','Bad VF file for ');errprintfont(f);
history:=3;uexit(history);end;9999:vfreading:=wasvfreading;end;
{:52}{58:}function selectfont(e:integer):integer;var f:0..maxfonts;
ff:0..maxfonts;k:integer;begin{59:}if curftop<=nf then curftop:=nf;
fontnum[curftop]:=e;k:=curfbase;
while(fontnum[k]<>e)or localonly[k]do k:=k+1;
if k=curftop then begin writeln('DVItoMP abort: ',
'Undefined font selected');history:=3;uexit(history);end;
f:=internalnum[k]{:59};
if infobase[f]=maxwidths then begin ff:=matchfont(f,false);
if ff<nf then{60:}begin fontbc[f]:=fontbc[ff];fontec[f]:=fontec[ff];
infobase[f]:=infobase[ff];fbase[f]:=fbase[ff];ftop[f]:=ftop[ff];
end{:60}else begin{63:}curname:=xmallocarray(char,fontname[f+1]-fontname
[f]);
for k:=fontname[f]to fontname[f+1]-1 do begin curname[k-fontname[f]]:=
xchr[names[k]];end;curname[fontname[f+1]-fontname[f]]:=0;{:63};
if openvffile then inVF(f)else begin{64:}{:64};
if not opentfmfile then begin write('DVItoMP abort: ',
'No TFM file found for ');errprintfont(f);history:=3;uexit(history);end;
inTFM(f);end;
{65:}begin if(fontchecksum[f]<>0)and(tfmchecksum<>0)and(fontchecksum[f]
<>tfmchecksum)then begin write('DVItoMP warning: Checksum mismatch for '
);errprintfont(f);if history=0 then history:=1;end;end{:65};end;
{76:}fontused[f]:=false;{:76};end;selectfont:=f;end;
{:58}{73:}{78:}procedure finishlastchar;var m,x,y:real;
begin if strf>=0 then begin m:=strscale*fontscaledsize[strf]*mag/
fontdesignsize[strf];x:=conv*strh1;y:=conv*(-strv);
if(fabs(x)>=4096.0)or(fabs(y)>=4096.0)or(m>=4096.0)or(m<0)then begin
begin writeln('DVItoMP warning: ','text is out of range');history:=2;
end;endcharstring(60);end else endcharstring(40);
write(mpxfile,',_n',strf:1,',');fprintreal(mpxfile,m,1,5);
write(mpxfile,',');fprintreal(mpxfile,x,1,4);write(mpxfile,',');
fprintreal(mpxfile,y,1,4);write(mpxfile,',');
{132:}if colorstackdepth>0 then begin write(mpxfile,' withcolor ');
fputs(colorstack[colorstackdepth],mpxfile);end;
{:132}writeln(mpxfile,');');strf:=-1;end;end;
{:78}procedure dosetchar(f,c:integer);
begin if(c<fontbc[f])or(c>fontec[f])then begin writeln('DVItoMP abort: '
,'attempt to typeset invalid character ',c:1);history:=3;uexit(history);
end;
if(h<>strh2)or(v<>strv)or(f<>strf)or(dviscale<>strscale)then begin if
strf>=0 then finishlastchar else if not fontsused then{75:}begin k:=0;
while(k<nf)do begin fontused[k]:=false;k:=k+1;end;fontsused:=true;
writeln(mpxfile,'string _n[];');
writeln(mpxfile,'vardef _s(expr _t,_f,_m,_x,_y)(text _c)=');
writeln(mpxfile,
'  addto _p also _t infont _f scaled _m shifted (_x,_y) _c; enddef;');
end{:75};if not fontused[f]then{77:}begin fontused[f]:=true;
write(mpxfile,'_n',f:1,'=');printcol:=6;printfont(f);endcharstring(1);
writeln(mpxfile,';');end{:77};write(mpxfile,'_s(');printcol:=3;
strscale:=dviscale;strf:=f;strv:=v;strh1:=h;end;printchar(c);
strh2:=h+{49:}floor(dviscale*fontscaledsize[f]*width[infobase[f]+c])
{:49};end;{:73}{79:}procedure dosetrule(ht,wd:integer);
var xx1,yy1,xx2,yy2,ww:real;begin if wd=1 then{81:}begin picwd:=h;
picdp:=v;picht:=ht-v;
end{:81}else if(ht>0)or(wd>0)then begin if strf>=0 then finishlastchar;
if not rulesused then begin rulesused:=true;
writeln(mpxfile,'interim linecap:=0;');
writeln(mpxfile,'vardef _r(expr _a,_w)(text _t) =');writeln(mpxfile,
'  addto _p doublepath _a withpen pencircle scaled _w _t enddef;');end;
{80:}xx1:=conv*h;yy1:=conv*(-v);if wd>ht then begin xx2:=xx1+conv*wd;
ww:=conv*ht;yy1:=yy1+0.5*ww;yy2:=yy1;end else begin yy2:=yy1+conv*ht;
ww:=conv*wd;xx1:=xx1+0.5*ww;xx2:=xx1;end{:80};
if(fabs(xx1)>=4096.0)or(fabs(yy1)>=4096.0)or(fabs(xx2)>=4096.0)or(fabs(
yy2)>=4096.0)or(ww>=4096.0)then begin writeln('DVItoMP warning: ',
'hrule or vrule is out of range');history:=2;end;write(mpxfile,'_r((');
fprintreal(mpxfile,xx1,1,4);write(mpxfile,',');
fprintreal(mpxfile,yy1,1,4);write(mpxfile,')..(');
fprintreal(mpxfile,xx2,1,4);write(mpxfile,',');
fprintreal(mpxfile,yy2,1,4);write(mpxfile,'), ');
fprintreal(mpxfile,ww,1,4);write(mpxfile,',');
{132:}if colorstackdepth>0 then begin write(mpxfile,' withcolor ');
fputs(colorstack[colorstackdepth],mpxfile);end;
{:132}writeln(mpxfile,');');end;end;{:79}{83:}procedure startpicture;
begin fontsused:=false;rulesused:=false;strf:=-1;strv:=0;strh2:=0;
strscale:=1.0;writeln(mpxfile,
'begingroup save _p,_r,_s,_n; picture _p; _p=nullpicture;');end;
procedure stoppicture;var w,h,dd:real;
begin if strf>=0 then finishlastchar;{84:}dd:=-picdp*conv;w:=conv*picwd;
h:=conv*picht;write(mpxfile,'setbounds _p to (0,');
fprintreal(mpxfile,dd,1,4);write(mpxfile,')--(');
fprintreal(mpxfile,w,1,4);write(mpxfile,',');fprintreal(mpxfile,dd,1,4);
writeln(mpxfile,')--');write(mpxfile,' (');fprintreal(mpxfile,w,1,4);
write(mpxfile,',');fprintreal(mpxfile,h,1,4);write(mpxfile,')--(0,');
fprintreal(mpxfile,h,1,4);writeln(mpxfile,')--cycle;'){:84};
writeln(mpxfile,'_p endgroup');end;
{:83}{88:}{115:}procedure doxxx(p:integer);label 9999;const bufsiz=256;
var buf:packed array[0..bufsiz]of eightbits;l,r,m,k,len:integer;
found:boolean;begin len:=0;
while(p>0)and(len<bufsiz)do begin buf[len]:=getbyte;p:=p-1;len:=len+1;
end;
{116:}if(len<=5)or(buf[0]<>99)or(buf[1]<>111)or(buf[2]<>108)or(buf[3]<>
111)or(buf[4]<>114)or(buf[5]<>32)then goto 9999;
{:116}if p>0 then begin begin writeln('DVItoMP warning: ',
'long "color" special ignored');if history<2 then history:=1;end;
goto 9999;end;
if{118:}(len=9)and(buf[6]=112)and(buf[7]=111)and(buf[8]=112){:118}then
begin{122:}finishlastchar;
if colorstackdepth>0 then begin free(colorstack[colorstackdepth]);
colorstackdepth:=colorstackdepth-1 end else begin begin writeln(
'DVItoMP warning: ','color stack underflow');
if history<2 then history:=1;end end;
{:122}end else if{117:}(len>=11)and(buf[6]=112)and(buf[7]=117)and(buf[8]
=115)and(buf[9]=104)and(buf[10]=32){:117}then begin{123:}finishlastchar;
if colorstackdepth>=maxcolorstackdepth then begin writeln(
'DVItoMP abort: ','color stack overflow');history:=3;uexit(history);end;
colorstackdepth:=colorstackdepth+1;l:=11;
while(l<len-1)and(buf[l]=32)do l:=l+1;
if{124:}(l+4<len)and(buf[l]=114)and(buf[l+1]=103)and(buf[l+2]=98)and(buf
[l+3]=32){:124}then begin{125:}l:=l+4;
while(l<len)and(buf[l]=32)do l:=l+1;
while(len>l)and(buf[len-1]=32)do len:=len-1;
colorstack[colorstackdepth]:=xmallocarray(char,len-l+3);k:=0;
{130:}colorstack[colorstackdepth][k]:=40;k:=k+1;
while l<len do if buf[l]=32 then begin colorstack[colorstackdepth][k]:=
44;while(l<len)and(buf[l]=32)do l:=l+1;k:=k+1;
end else begin colorstack[colorstackdepth][k]:=buf[l];l:=l+1;k:=k+1;end;
colorstack[colorstackdepth][k]:=41;
colorstack[colorstackdepth][k+1]:=chr(0){:130}{:125}end else if{128:}(l
+5<len)and(buf[l]=99)and(buf[l+1]=109)and(buf[l+2]=121)and(buf[l+3]=107)
and(buf[l+4]=32){:128}then begin{129:}l:=l+5;
while(l<len)and(buf[l]=32)do l:=l+1;
while(len>l)and(buf[len-1]=32)do len:=len-1;
colorstack[colorstackdepth]:=xmallocarray(char,len-l+7);
strcpy(colorstack[colorstackdepth],'cmyk');k:=4;
{130:}colorstack[colorstackdepth][k]:=40;k:=k+1;
while l<len do if buf[l]=32 then begin colorstack[colorstackdepth][k]:=
44;while(l<len)and(buf[l]=32)do l:=l+1;k:=k+1;
end else begin colorstack[colorstackdepth][k]:=buf[l];l:=l+1;k:=k+1;end;
colorstack[colorstackdepth][k]:=41;
colorstack[colorstackdepth][k+1]:=chr(0){:130}{:129}end else if{126:}(l
+5<len)and(buf[l]=103)and(buf[l+1]=114)and(buf[l+2]=97)and(buf[l+3]=121)
and(buf[l+4]=32){:126}then begin{127:}l:=l+5;
while(l<len)and(buf[l]=32)do l:=l+1;
while(len>l)and(buf[len-1]=32)do len:=len-1;
colorstack[colorstackdepth]:=xmallocarray(char,len-l+9);
strcpy(colorstack[colorstackdepth],'white*');k:=6;
{130:}colorstack[colorstackdepth][k]:=40;k:=k+1;
while l<len do if buf[l]=32 then begin colorstack[colorstackdepth][k]:=
44;while(l<len)and(buf[l]=32)do l:=l+1;k:=k+1;
end else begin colorstack[colorstackdepth][k]:=buf[l];l:=l+1;k:=k+1;end;
colorstack[colorstackdepth][k]:=41;
colorstack[colorstackdepth][k+1]:=chr(0){:130}{:127}end else begin{131:}
for k:=l to len-1 do begin buf[k-l]:=xchr[buf[k]];end;buf[len-l]:=0;
len:=len-l;l:=1;r:=numnamedcolors;found:=false;
while(l<=r)and not found do begin m:=(l+r)/2;
k:=strcmp(stringcast(buf),namedcolors[m].name);
if k=0 then begin colorstack[colorstackdepth]:=xstrdup(namedcolors[m].
value);found:=true;end else if k<0 then r:=m-1 else l:=m+1;end;
if not found then begin begin writeln('DVItoMP warning: ',
'non-hardcoded color "',stringcast(buf),'" in "color push" command');
if history<2 then history:=1;end;
colorstack[colorstackdepth]:=xstrdup(stringcast(buf));end;{:131}end;
{:123}end else begin begin writeln('DVItoMP warning: ',
'unknown "color" special ignored');if history<2 then history:=1;end;
goto 9999;end;9999:for k:=1 to p do downthedrain:=getbyte;end;
{:115}procedure dopush;
begin if stksiz=stacksize then begin writeln('DVItoMP abort: ',
'DVItoMP capacity exceeded (stack size=',stacksize:1,')');history:=3;
uexit(history);end;hstack[stksiz]:=h;vstack[stksiz]:=v;
wstack[stksiz]:=w;xstack[stksiz]:=x;ystack[stksiz]:=y;zstack[stksiz]:=z;
stksiz:=stksiz+1;end;procedure dopop;
begin if stksiz=0 then begin writeln('DVItoMP abort: ','Bad DVI file: ',
'attempt to pop empty stack','!');history:=3;uexit(history);
end else begin stksiz:=stksiz-1;h:=hstack[stksiz];v:=vstack[stksiz];
w:=wstack[stksiz];x:=xstack[stksiz];y:=ystack[stksiz];z:=zstack[stksiz];
end;end;{:88}{89:}procedure dodvicommands;forward;
procedure setvirtualchar(f,c:integer);var oldscale:real;
oldbufptr:0..virtualspace;oldfbase,oldftop:0..maxfnums;
begin if fbase[f]=0 then dosetchar(f,c)else begin oldfbase:=curfbase;
oldftop:=curftop;curfbase:=fbase[f];curftop:=ftop[f];oldscale:=dviscale;
dviscale:=dviscale*fontscaledsize[f];oldbufptr:=bufptr;
bufptr:=cmdptr[infobase[f]+c];dopush;dodvicommands;dopop;
bufptr:=oldbufptr;dviscale:=oldscale;curfbase:=oldfbase;
curftop:=oldftop;end;end;{:89}{91:}procedure dodvicommands;label 9999;
var o:eightbits;p,q:integer;curfont:integer;
begin if(curfbase<curftop)and(bufptr<virtualspace)then curfont:=
selectfont(fontnum[curftop-1])else curfont:=maxfnums+1;w:=0;x:=0;y:=0;
z:=0;while true do{93:}begin o:=getbyte;p:=firstpar(o);
if eof(dvifile)then begin writeln('DVItoMP abort: ','Bad DVI file: ',
'the DVI file ended prematurely','!');history:=3;uexit(history);end;
if o<132 then begin if curfont>maxfnums then begin if vfreading then
begin writeln('DVItoMP abort: ','no font selected for character ',p:1,
' in virtual font');history:=3;uexit(history);
end else begin writeln('DVItoMP abort: ','Bad DVI file: ',
'no font selected for character ',p:1,'!');history:=3;uexit(history);
end;end;setvirtualchar(curfont,p);
h:=h+{50:}floor(dviscale*fontscaledsize[curfont]*width[infobase[curfont]
+p]){:50};end else case o of 133,134,135,136:setvirtualchar(curfont,p);
132:begin q:=trunc(signedquad*dviscale);dosetrule(trunc(p*dviscale),q);
h:=h+q;end;137:dosetrule(trunc(p*dviscale),trunc(signedquad*dviscale));
{94:}239,240,241,242:doxxx(p);
247,248,249:begin writeln('DVItoMP abort: ','Bad DVI file: ',
'preamble or postamble within a page!','!');history:=3;uexit(history);
end;{:94}{95:}138:;139:begin writeln('DVItoMP abort: ','Bad DVI file: ',
'bop occurred before eop','!');history:=3;uexit(history);end;
140:goto 9999;141:dopush;142:dopop;
{:95}{96:}143,144,145,146:h:=h+trunc(p*dviscale);
147,148,149,150,151:begin w:=trunc(p*dviscale);h:=h+w;end;
152,153,154,155,156:begin x:=trunc(p*dviscale);h:=h+x;end;
157,158,159,160:v:=v+trunc(p*dviscale);
161,162,163,164,165:begin y:=trunc(p*dviscale);v:=v+y;end;
166,167,168,169,170:begin z:=trunc(p*dviscale);v:=v+z;end;
{:96}{97:}171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,
186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,
204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,
222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238:
curfont:=selectfont(p);243,244,245,246:definefont(p);
{:97}250,251,252,253,254,255:begin writeln('DVItoMP abort: ',
'Bad DVI file: ','undefined command ',o:1,'!');history:=3;
uexit(history);end;end;end{:93};9999:;end;{:91}{98:}begin initialize;
{100:}opendvifile;p:=getbyte;
if p<>247 then begin writeln('DVItoMP abort: ','Bad DVI file: ',
'First byte isn''t start of preamble!','!');history:=3;uexit(history);
end;p:=getbyte;if p<>2 then begin writeln('DVItoMP warning: ',
'identification in byte 1 should be ',2:1,'!');history:=2;end;
{101:}numerator:=signedquad;denominator:=signedquad;
if(numerator<=0)or(denominator<=0)then begin writeln('DVItoMP abort: ',
'Bad DVI file: ','bad scale ratio in preamble','!');history:=3;
uexit(history);end;mag:=signedquad/1000.0;
if mag<=0.0 then begin writeln('DVItoMP abort: ','Bad DVI file: ',
'magnification isn''t positive','!');history:=3;uexit(history);end;
conv:=(numerator/254000.0)*(72.0/denominator)*mag;
dviperfix:=(254000.0/numerator)*(denominator/72.27)/1048576.0;{:101};
p:=getbyte;while p>0 do begin p:=p-1;downthedrain:=getbyte;end{:100};
openmpxfile;write(mpxfile,'% Written by DVItoMP, Version 1.003/color');
writeln(mpxfile,versionstring);
begin while true do begin{102:}repeat k:=getbyte;
if(k>=243)and(k<247)then begin p:=firstpar(k);definefont(p);k:=138;end;
until k<>138;if k=248 then goto 30;
if k<>139 then begin writeln('DVItoMP abort: ','Bad DVI file: ',
'missing bop','!');history:=3;uexit(history);end;{:102};
for k:=0 to 10 do downthedrain:=signedquad;{87:}dviscale:=1.0;stksiz:=0;
h:=0;v:=0{:87};startpicture;dodvicommands;
if stksiz<>0 then begin writeln('DVItoMP abort: ','Bad DVI file: ',
'stack not empty at end of page','!');history:=3;uexit(history);end;
stoppicture;writeln(mpxfile,'mpxbreak');end;30:end;
if history<=1 then uexit(0)else uexit(history);end.{:98}
