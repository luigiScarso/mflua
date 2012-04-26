rm -vf envelope.tex ;
MFFILE="ccr10"
CTX="/opt/luatex/minimals-beta-2011/tex"
#./mf "\tracingall; tracingedges:=2; mode=otcff;input $MFFILE" ;  
./mf "\mode=otcff;input $MFFILE" ;  
#./mf "\mode=cx;input $MFFILE" ;  
source $CTX/setuptex $CTX
context --batch envelope





