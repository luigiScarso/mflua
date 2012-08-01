rm -vf envelope.tex ;
MFFILE="xmssdc10.mf"
CTX="/opt/luatex/minimals-beta-2011/tex"
source $CTX/setuptex $CTX
./mf "\mode=otcff;input $MFFILE" &&   context --batch envelope






