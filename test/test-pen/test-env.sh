#rm envelope.tex ;
MFFILE="ccr5"
#MFFILE="test-pen"
./mf "\tracingall; tracingedges:=2; mode=otcff;input $MFFILE" ;  
#./mf "\tracingoutput:=1;tracingspecs:=1; tracingedges:=2; mode=otcff;input $MFFILE" ;  
#printf "\starttext\n\setupbodyfont[tt,2.8pt]\\\\bf\n\startMPpage\n"> _envelope.tex; 
#cat envelope.tex >> _envelope.tex; 
#printf  "\n\stopMPpage\n\stoptext\n">> _envelope.tex  
#mv _envelope.tex envelope.tex
source /opt/luatex/minimals-beta/tex/setuptex /opt/luatex/minimals-beta/tex
context --batch envelope

