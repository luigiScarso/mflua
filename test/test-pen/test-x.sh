echo '\starttext'> test-x.tex
echo '\startMPpage' >> test-x.tex
echo 'drawoptions(withpen pencircle scaled 0.25pt);' >> test-x.tex
./mf -ini mf.ini
## mode=laserwriter %300 dpi
## mode=luxo
## mode=cheapo
## mode=proof
## mode=otcff %4000 dpi
## mode=bitgraph %118 dpi
#MODE="mode=laserwriter"
MODE="mode=otcff"
MFINPUT="test-6"
MAG=1 #"100.375"
./mf "\tracingedges:=1;tracingoutput:=1 ;tracingspecs:=1; tracingpens:=1;tracingequations:=1;$MODE;mag=$MAG;input $MFINPUT; "|grep %%%|perl -pe 's{^%%%\s*}{}' >> test-x.tex



perl -n -e 'if(/^row/){s/row (.?\d+): \| ([-]?\d+[+-] [-]?\d+[+-])? ?([-]?\d+[+-] [-]?\d+[+-])? ?([-]?\d+[+-] [-]?\d+[+-])? ?([-]?\d+[+-] [-]?\d+[+-])? ?([-]?\d+[+-] [-]?\d+[+-])?(.*)/Y=$1,X1=$2,X2=$3,X3=$4,X4=$5,X5=$6,/;print} ' "$MFINPUT.log"  | perl -p -e 's/(X\d+=,)//g; s/((X\d)=(-?\d+[+-]) (-?\d+[+-])),/$2a=$3:$2b=$4:/g' | perl -p -e 's/\D:/:/g' > test-x.temp

cat >test-x.pl <<EOF
open(TEST,"test-x.temp") || die("can't open datafile: \$!");
while(<TEST>) {
    if (\$_ =~ /^Y=(-?\d+),/){
	\$line = \$_;
	\$Y = \$1 ;
	chomp \$line;
	\$line =~ s/^Y=(-?\d+),//;
	@x = split /:/, \$line;
        \$dim = @x ;    
        foreach \$v (@x) { 
          \$v =~ s/(X\d+[ab]=)(-?\d+).*/\$2/;
          print "draw(\$v,\$Y);"
        }
        print "\n";
  }
}
close(TEST);
EOF

echo 'drawoptions(withpen pencircle scaled 1pt withcolor red);' >> test-x.tex
perl test-x.pl >> test-x.tex

echo 'drawoptions(withpen pensquare scaled 0.1pt withcolor 0.7white);' >> test-x.tex
./mf "\tracingedges:=1;tracingoutput:=1 ;tracingspecs:=1; tracingpens:=1;tracingequations:=1;$MODE;mag=$MAG;input $MFINPUT; "|grep %%mflua >> test-x.tex
 
echo '\stopMPpage' >> test-x.tex
echo '\stoptext' >> test-x.tex
#mtxrun texutil --purgeall
source /opt/luatex/minimals-beta/tex/setuptex /opt/luatex/minimals-beta/tex 
context test-x