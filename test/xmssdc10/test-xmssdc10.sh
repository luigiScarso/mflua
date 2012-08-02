rm -vf envelope.tex ;
MFFILE="xmssdc10.mf"
CTX="/opt/luatex/minimals-beta-2011/tex"
source $CTX/setuptex $CTX
## clean LOCKS
rm -vf LOCK1
rm -vf LOCK_ELLIPSE
./mf "\mode=otcff;input $MFFILE" &&   context --batch envelope






