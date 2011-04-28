open(TEST,"test-x.temp") || die("can't open datafile: $!");
while(<TEST>) {
    if ($_ =~ /^Y=(-?\d+),/){
	$line = $_;
	$Y = $1 ;
	chomp $line;
	$line =~ s/^Y=(-?\d+),//;
	@x = split /:/, $line;
        $dim = @x ;    
        foreach $v (@x) { 
          $v =~ s/(X\d+[ab]=)(-?\d+).*/$2/;
          print "draw($v,$Y);"
        }
        print "\n";
  }
}
close(TEST);
