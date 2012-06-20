rm -vf envelope.tex ;
MFFILE="pen"
CTX="/opt/luatex/minimals-beta-2011/tex"
source $CTX/setuptex $CTX
#./mf "\tracingall; tracingedges:=2; mode=otcff;input $MFFILE" ;  
./mf "\mode=otcff;input $MFFILE" &&   context --batch envelope





