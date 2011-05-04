rm -vf envelope.tex ;
MFFILE="ccr5"
CTX="/opt/luatex/minimals-beta-2011/tex"
#./mf "\tracingall; tracingedges:=2; mode=otcff;input $MFFILE" ;  
./mf "\mode=otcff;input $MFFILE" ;  
source $CTX/setuptex $CTX
context --batch envelope

