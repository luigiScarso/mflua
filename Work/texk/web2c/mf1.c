#define EXTERN extern
#include "mfd.h"

void 
#ifdef HAVE_PROTOTYPES
zpathintersection ( halfword h , halfword hh ) 
#else
zpathintersection ( h , hh ) 
  halfword h ;
  halfword hh ;
#endif
{
  /* 10 */ halfword p, pp  ;
  integer n, nn  ;
  if ( mem [h ].hhfield .b1 == 0 ) 
  {
    mem [h + 5 ].cint = mem [h + 1 ].cint ;
    mem [h + 3 ].cint = mem [h + 1 ].cint ;
    mem [h + 6 ].cint = mem [h + 2 ].cint ;
    mem [h + 4 ].cint = mem [h + 2 ].cint ;
    mem [h ].hhfield .b1 = 1 ;
  } 
  if ( mem [hh ].hhfield .b1 == 0 ) 
  {
    mem [hh + 5 ].cint = mem [hh + 1 ].cint ;
    mem [hh + 3 ].cint = mem [hh + 1 ].cint ;
    mem [hh + 6 ].cint = mem [hh + 2 ].cint ;
    mem [hh + 4 ].cint = mem [hh + 2 ].cint ;
    mem [hh ].hhfield .b1 = 1 ;
  } 
  tolstep = 0 ;
  do {
      n = -65536L ;
    p = h ;
    do {
	if ( mem [p ].hhfield .b1 != 0 ) 
      {
	nn = -65536L ;
	pp = hh ;
	do {
	    if ( mem [pp ].hhfield .b1 != 0 ) 
	  {
	    cubicintersection ( p , pp ) ;
	    if ( curt > 0 ) 
	    {
	      curt = curt + n ;
	      curtt = curtt + nn ;
	      goto lab10 ;
	    } 
	  } 
	  nn = nn + 65536L ;
	  pp = mem [pp ].hhfield .v.RH ;
	} while ( ! ( pp == hh ) ) ;
      } 
      n = n + 65536L ;
      p = mem [p ].hhfield .v.RH ;
    } while ( ! ( p == h ) ) ;
    tolstep = tolstep + 3 ;
  } while ( ! ( tolstep > 3 ) ) ;
  curt = -65536L ;
  curtt = -65536L ;
  lab10: ;
} 
void 
#ifdef HAVE_PROTOTYPES
zopenawindow ( windownumber k , scaled r0 , scaled c0 , scaled r1 , scaled c1 
, scaled x , scaled y ) 
#else
zopenawindow ( k , r0 , c0 , r1 , c1 , x , y ) 
  windownumber k ;
  scaled r0 ;
  scaled c0 ;
  scaled r1 ;
  scaled c1 ;
  scaled x ;
  scaled y ;
#endif
{
  integer m, n  ;
  if ( r0 < 0 ) 
  r0 = 0 ;
  else r0 = roundunscaled ( r0 ) ;
  r1 = roundunscaled ( r1 ) ;
  if ( r1 > screendepth ) 
  r1 = screendepth ;
  if ( r1 < r0 ) 
  if ( r0 > screendepth ) 
  r0 = r1 ;
  else r1 = r0 ;
  if ( c0 < 0 ) 
  c0 = 0 ;
  else c0 = roundunscaled ( c0 ) ;
  c1 = roundunscaled ( c1 ) ;
  if ( c1 > screenwidth ) 
  c1 = screenwidth ;
  if ( c1 < c0 ) 
  if ( c0 > screenwidth ) 
  c0 = c1 ;
  else c1 = c0 ;
  windowopen [k ]= true ;
  incr ( windowtime [k ]) ;
  leftcol [k ]= c0 ;
  rightcol [k ]= c1 ;
  toprow [k ]= r0 ;
  botrow [k ]= r1 ;
  m = roundunscaled ( x ) ;
  n = roundunscaled ( y ) - 1 ;
  mwindow [k ]= c0 - m ;
  nwindow [k ]= r0 + n ;
  {
    if ( ! screenstarted ) 
    {
      screenOK = initscreen () ;
      screenstarted = true ;
    } 
  } 
  if ( screenOK ) 
  {
    blankrectangle ( c0 , c1 , r0 , r1 ) ;
    updatescreen () ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
zdispedges ( windownumber k ) 
#else
zdispedges ( k ) 
  windownumber k ;
#endif
{
  /* 30 40 */ halfword p, q  ;
  boolean alreadythere  ;
  integer r  ;
  screencol n  ;
  integer w, ww  ;
  pixelcolor b  ;
  integer m, mm  ;
  integer d  ;
  integer madjustment  ;
  integer rightedge  ;
  screencol mincol  ;
  if ( screenOK ) 
  if ( leftcol [k ]< rightcol [k ]) 
  if ( toprow [k ]< botrow [k ]) 
  {
    alreadythere = false ;
    if ( mem [curedges + 3 ].hhfield .v.RH == k ) 
    if ( mem [curedges + 4 ].cint == windowtime [k ]) 
    alreadythere = true ;
    if ( ! alreadythere ) 
    blankrectangle ( leftcol [k ], rightcol [k ], toprow [k ], botrow [
    k ]) ;
    madjustment = mwindow [k ]- mem [curedges + 3 ].hhfield .lhfield ;
    rightedge = 8 * ( rightcol [k ]- madjustment ) ;
    mincol = leftcol [k ];
    p = mem [curedges ].hhfield .v.RH ;
    r = nwindow [k ]- ( mem [curedges + 1 ].hhfield .lhfield - 4096 ) ;
    while ( ( p != curedges ) && ( r >= toprow [k ]) ) {
	
      if ( r < botrow [k ]) 
      {
	if ( mem [p + 1 ].hhfield .lhfield > 1 ) 
	sortedges ( p ) ;
	else if ( mem [p + 1 ].hhfield .lhfield == 1 ) 
	if ( alreadythere ) 
	goto lab30 ;
	mem [p + 1 ].hhfield .lhfield = 1 ;
	n = 0 ;
	ww = 0 ;
	m = -1 ;
	w = 0 ;
	q = mem [p + 1 ].hhfield .v.RH ;
	rowtransition [0 ]= mincol ;
	while ( true ) {
	    
	  if ( q == memtop ) 
	  d = rightedge ;
	  else d = mem [q ].hhfield .lhfield ;
	  mm = ( d / 8 ) + madjustment ;
	  if ( mm != m ) 
	  {
	    if ( w <= 0 ) 
	    {
	      if ( ww > 0 ) 
	      if ( m > mincol ) 
	      {
		if ( n == 0 ) 
		if ( alreadythere ) 
		{
		  b = 0 ;
		  incr ( n ) ;
		} 
		else b = 1 ;
		else incr ( n ) ;
		rowtransition [n ]= m ;
	      } 
	    } 
	    else if ( ww <= 0 ) 
	    if ( m > mincol ) 
	    {
	      if ( n == 0 ) 
	      b = 1 ;
	      incr ( n ) ;
	      rowtransition [n ]= m ;
	    } 
	    m = mm ;
	    w = ww ;
	  } 
	  if ( d >= rightedge ) 
	  goto lab40 ;
	  ww = ww + ( d % 8 ) - 4 ;
	  q = mem [q ].hhfield .v.RH ;
	} 
	lab40: if ( alreadythere || ( ww > 0 ) ) 
	{
	  if ( n == 0 ) 
	  if ( ww > 0 ) 
	  b = 1 ;
	  else b = 0 ;
	  incr ( n ) ;
	  rowtransition [n ]= rightcol [k ];
	} 
	else if ( n == 0 ) 
	goto lab30 ;
	paintrow ( r , b , rowtransition , n ) ;
	lab30: ;
      } 
      p = mem [p ].hhfield .v.RH ;
      decr ( r ) ;
    } 
    updatescreen () ;
    incr ( windowtime [k ]) ;
    mem [curedges + 3 ].hhfield .v.RH = k ;
    mem [curedges + 4 ].cint = windowtime [k ];
  } 
} 
fraction 
#ifdef HAVE_PROTOTYPES
zmaxcoef ( halfword p ) 
#else
zmaxcoef ( p ) 
  halfword p ;
#endif
{
  register fraction Result; fraction x  ;
  x = 0 ;
  while ( mem [p ].hhfield .lhfield != 0 ) {
      
    if ( abs ( mem [p + 1 ].cint ) > x ) 
    x = abs ( mem [p + 1 ].cint ) ;
    p = mem [p ].hhfield .v.RH ;
  } 
  Result = x ;
  return Result ;
} 
halfword 
#ifdef HAVE_PROTOTYPES
zpplusq ( halfword p , halfword q , smallnumber t ) 
#else
zpplusq ( p , q , t ) 
  halfword p ;
  halfword q ;
  smallnumber t ;
#endif
{
  /* 30 */ register halfword Result; halfword pp, qq  ;
  halfword r, s  ;
  integer threshold  ;
  integer v  ;
  if ( t == 17 ) 
  threshold = 2685 ;
  else threshold = 8 ;
  r = memtop - 1 ;
  pp = mem [p ].hhfield .lhfield ;
  qq = mem [q ].hhfield .lhfield ;
  while ( true ) if ( pp == qq ) 
  if ( pp == 0 ) 
  goto lab30 ;
  else {
      
    v = mem [p + 1 ].cint + mem [q + 1 ].cint ;
    mem [p + 1 ].cint = v ;
    s = p ;
    p = mem [p ].hhfield .v.RH ;
    pp = mem [p ].hhfield .lhfield ;
    if ( abs ( v ) < threshold ) 
    freenode ( s , 2 ) ;
    else {
	
      if ( abs ( v ) >= 626349397L ) 
      if ( watchcoefs ) 
      {
	mem [qq ].hhfield .b0 = 0 ;
	fixneeded = true ;
      } 
      mem [r ].hhfield .v.RH = s ;
      r = s ;
    } 
    q = mem [q ].hhfield .v.RH ;
    qq = mem [q ].hhfield .lhfield ;
  } 
  else if ( mem [pp + 1 ].cint < mem [qq + 1 ].cint ) 
  {
    s = getnode ( 2 ) ;
    mem [s ].hhfield .lhfield = qq ;
    mem [s + 1 ].cint = mem [q + 1 ].cint ;
    q = mem [q ].hhfield .v.RH ;
    qq = mem [q ].hhfield .lhfield ;
    mem [r ].hhfield .v.RH = s ;
    r = s ;
  } 
  else {
      
    mem [r ].hhfield .v.RH = p ;
    r = p ;
    p = mem [p ].hhfield .v.RH ;
    pp = mem [p ].hhfield .lhfield ;
  } 
  lab30: mem [p + 1 ].cint = slowadd ( mem [p + 1 ].cint , mem [q + 1 ]
  .cint ) ;
  mem [r ].hhfield .v.RH = p ;
  depfinal = p ;
  Result = mem [memtop - 1 ].hhfield .v.RH ;
  return Result ;
} 
halfword 
#ifdef HAVE_PROTOTYPES
zptimesv ( halfword p , integer v , smallnumber t0 , smallnumber t1 , boolean 
visscaled ) 
#else
zptimesv ( p , v , t0 , t1 , visscaled ) 
  halfword p ;
  integer v ;
  smallnumber t0 ;
  smallnumber t1 ;
  boolean visscaled ;
#endif
{
  register halfword Result; halfword r, s  ;
  integer w  ;
  integer threshold  ;
  boolean scalingdown  ;
  if ( t0 != t1 ) 
  scalingdown = true ;
  else scalingdown = ! visscaled ;
  if ( t1 == 17 ) 
  threshold = 1342 ;
  else threshold = 4 ;
  r = memtop - 1 ;
  while ( mem [p ].hhfield .lhfield != 0 ) {
      
    if ( scalingdown ) 
    w = takefraction ( v , mem [p + 1 ].cint ) ;
    else w = takescaled ( v , mem [p + 1 ].cint ) ;
    if ( abs ( w ) <= threshold ) 
    {
      s = mem [p ].hhfield .v.RH ;
      freenode ( p , 2 ) ;
      p = s ;
    } 
    else {
	
      if ( abs ( w ) >= 626349397L ) 
      {
	fixneeded = true ;
	mem [mem [p ].hhfield .lhfield ].hhfield .b0 = 0 ;
      } 
      mem [r ].hhfield .v.RH = p ;
      r = p ;
      mem [p + 1 ].cint = w ;
      p = mem [p ].hhfield .v.RH ;
    } 
  } 
  mem [r ].hhfield .v.RH = p ;
  if ( visscaled ) 
  mem [p + 1 ].cint = takescaled ( mem [p + 1 ].cint , v ) ;
  else mem [p + 1 ].cint = takefraction ( mem [p + 1 ].cint , v ) ;
  Result = mem [memtop - 1 ].hhfield .v.RH ;
  return Result ;
} 
halfword 
#ifdef HAVE_PROTOTYPES
zpwithxbecomingq ( halfword p , halfword x , halfword q , smallnumber t ) 
#else
zpwithxbecomingq ( p , x , q , t ) 
  halfword p ;
  halfword x ;
  halfword q ;
  smallnumber t ;
#endif
{
  register halfword Result; halfword r, s  ;
  integer v  ;
  integer sx  ;
  s = p ;
  r = memtop - 1 ;
  sx = mem [x + 1 ].cint ;
  while ( mem [mem [s ].hhfield .lhfield + 1 ].cint > sx ) {
      
    r = s ;
    s = mem [s ].hhfield .v.RH ;
  } 
  if ( mem [s ].hhfield .lhfield != x ) 
  Result = p ;
  else {
      
    mem [memtop - 1 ].hhfield .v.RH = p ;
    mem [r ].hhfield .v.RH = mem [s ].hhfield .v.RH ;
    v = mem [s + 1 ].cint ;
    freenode ( s , 2 ) ;
    Result = pplusfq ( mem [memtop - 1 ].hhfield .v.RH , v , q , t , 17 ) ;
  } 
  return Result ;
} 
void 
#ifdef HAVE_PROTOTYPES
znewdep ( halfword q , halfword p ) 
#else
znewdep ( q , p ) 
  halfword q ;
  halfword p ;
#endif
{
  halfword r  ;
  mem [q + 1 ].hhfield .v.RH = p ;
  mem [q + 1 ].hhfield .lhfield = 13 ;
  r = mem [13 ].hhfield .v.RH ;
  mem [depfinal ].hhfield .v.RH = r ;
  mem [r + 1 ].hhfield .lhfield = depfinal ;
  mem [13 ].hhfield .v.RH = q ;
} 
halfword 
#ifdef HAVE_PROTOTYPES
zconstdependency ( scaled v ) 
#else
zconstdependency ( v ) 
  scaled v ;
#endif
{
  register halfword Result; depfinal = getnode ( 2 ) ;
  mem [depfinal + 1 ].cint = v ;
  mem [depfinal ].hhfield .lhfield = 0 ;
  Result = depfinal ;
  return Result ;
} 
halfword 
#ifdef HAVE_PROTOTYPES
zsingledependency ( halfword p ) 
#else
zsingledependency ( p ) 
  halfword p ;
#endif
{
  register halfword Result; halfword q  ;
  integer m  ;
  m = mem [p + 1 ].cint % 64 ;
  if ( m > 28 ) 
  Result = constdependency ( 0 ) ;
  else {
      
    q = getnode ( 2 ) ;
    mem [q + 1 ].cint = twotothe [28 - m ];
    mem [q ].hhfield .lhfield = p ;
    mem [q ].hhfield .v.RH = constdependency ( 0 ) ;
    Result = q ;
  } 
  return Result ;
} 
halfword 
#ifdef HAVE_PROTOTYPES
zcopydeplist ( halfword p ) 
#else
zcopydeplist ( p ) 
  halfword p ;
#endif
{
  /* 30 */ register halfword Result; halfword q  ;
  q = getnode ( 2 ) ;
  depfinal = q ;
  while ( true ) {
      
    mem [depfinal ].hhfield .lhfield = mem [p ].hhfield .lhfield ;
    mem [depfinal + 1 ].cint = mem [p + 1 ].cint ;
    if ( mem [depfinal ].hhfield .lhfield == 0 ) 
    goto lab30 ;
    mem [depfinal ].hhfield .v.RH = getnode ( 2 ) ;
    depfinal = mem [depfinal ].hhfield .v.RH ;
    p = mem [p ].hhfield .v.RH ;
  } 
  lab30: Result = q ;
  return Result ;
} 
void 
#ifdef HAVE_PROTOTYPES
zlineareq ( halfword p , smallnumber t ) 
#else
zlineareq ( p , t ) 
  halfword p ;
  smallnumber t ;
#endif
{
  halfword q, r, s  ;
  halfword x  ;
  integer n  ;
  integer v  ;
  halfword prevr  ;
  halfword finalnode  ;
  integer w  ;
  q = p ;
  r = mem [p ].hhfield .v.RH ;
  v = mem [q + 1 ].cint ;
  while ( mem [r ].hhfield .lhfield != 0 ) {
      
    if ( abs ( mem [r + 1 ].cint ) > abs ( v ) ) 
    {
      q = r ;
      v = mem [r + 1 ].cint ;
    } 
    r = mem [r ].hhfield .v.RH ;
  } 
  x = mem [q ].hhfield .lhfield ;
  n = mem [x + 1 ].cint % 64 ;
  s = memtop - 1 ;
  mem [s ].hhfield .v.RH = p ;
  r = p ;
  do {
      if ( r == q ) 
    {
      mem [s ].hhfield .v.RH = mem [r ].hhfield .v.RH ;
      freenode ( r , 2 ) ;
    } 
    else {
	
      w = makefraction ( mem [r + 1 ].cint , v ) ;
      if ( abs ( w ) <= 1342 ) 
      {
	mem [s ].hhfield .v.RH = mem [r ].hhfield .v.RH ;
	freenode ( r , 2 ) ;
      } 
      else {
	  
	mem [r + 1 ].cint = - (integer) w ;
	s = r ;
      } 
    } 
    r = mem [s ].hhfield .v.RH ;
  } while ( ! ( mem [r ].hhfield .lhfield == 0 ) ) ;
  if ( t == 18 ) 
  mem [r + 1 ].cint = - (integer) makescaled ( mem [r + 1 ].cint , v ) ;
  else if ( v != -268435456L ) 
  mem [r + 1 ].cint = - (integer) makefraction ( mem [r + 1 ].cint , v ) ;
  finalnode = r ;
  p = mem [memtop - 1 ].hhfield .v.RH ;
  if ( internal [2 ]> 0 ) 
  if ( interesting ( x ) ) 
  {
    begindiagnostic () ;
    printnl ( 597 ) ;
    printvariablename ( x ) ;
    w = n ;
    while ( w > 0 ) {
	
      print ( 590 ) ;
      w = w - 2 ;
    } 
    printchar ( 61 ) ;
    printdependency ( p , 17 ) ;
    enddiagnostic ( false ) ;
  } 
  prevr = 13 ;
  r = mem [13 ].hhfield .v.RH ;
  while ( r != 13 ) {
      
    s = mem [r + 1 ].hhfield .v.RH ;
    q = pwithxbecomingq ( s , x , p , mem [r ].hhfield .b0 ) ;
    if ( mem [q ].hhfield .lhfield == 0 ) 
    makeknown ( r , q ) ;
    else {
	
      mem [r + 1 ].hhfield .v.RH = q ;
      do {
	  q = mem [q ].hhfield .v.RH ;
      } while ( ! ( mem [q ].hhfield .lhfield == 0 ) ) ;
      prevr = q ;
    } 
    r = mem [prevr ].hhfield .v.RH ;
  } 
  if ( n > 0 ) 
  {
    s = memtop - 1 ;
    mem [memtop - 1 ].hhfield .v.RH = p ;
    r = p ;
    do {
	if ( n > 30 ) 
      w = 0 ;
      else w = mem [r + 1 ].cint / twotothe [n ];
      if ( ( abs ( w ) <= 1342 ) && ( mem [r ].hhfield .lhfield != 0 ) ) 
      {
	mem [s ].hhfield .v.RH = mem [r ].hhfield .v.RH ;
	freenode ( r , 2 ) ;
      } 
      else {
	  
	mem [r + 1 ].cint = w ;
	s = r ;
      } 
      r = mem [s ].hhfield .v.RH ;
    } while ( ! ( mem [s ].hhfield .lhfield == 0 ) ) ;
    p = mem [memtop - 1 ].hhfield .v.RH ;
  } 
  if ( mem [p ].hhfield .lhfield == 0 ) 
  {
    mem [x ].hhfield .b0 = 16 ;
    mem [x + 1 ].cint = mem [p + 1 ].cint ;
    if ( abs ( mem [x + 1 ].cint ) >= 268435456L ) 
    valtoobig ( mem [x + 1 ].cint ) ;
    freenode ( p , 2 ) ;
    if ( curexp == x ) 
    if ( curtype == 19 ) 
    {
      curexp = mem [x + 1 ].cint ;
      curtype = 16 ;
      freenode ( x , 2 ) ;
    } 
  } 
  else {
      
    mem [x ].hhfield .b0 = 17 ;
    depfinal = finalnode ;
    newdep ( x , p ) ;
    if ( curexp == x ) 
    if ( curtype == 19 ) 
    curtype = 17 ;
  } 
  if ( fixneeded ) 
  fixdependencies () ;
} 
halfword 
#ifdef HAVE_PROTOTYPES
znewringentry ( halfword p ) 
#else
znewringentry ( p ) 
  halfword p ;
#endif
{
  register halfword Result; halfword q  ;
  q = getnode ( 2 ) ;
  mem [q ].hhfield .b1 = 11 ;
  mem [q ].hhfield .b0 = mem [p ].hhfield .b0 ;
  if ( mem [p + 1 ].cint == 0 ) 
  mem [q + 1 ].cint = p ;
  else mem [q + 1 ].cint = mem [p + 1 ].cint ;
  mem [p + 1 ].cint = q ;
  Result = q ;
  return Result ;
} 
void 
#ifdef HAVE_PROTOTYPES
znonlineareq ( integer v , halfword p , boolean flushp ) 
#else
znonlineareq ( v , p , flushp ) 
  integer v ;
  halfword p ;
  boolean flushp ;
#endif
{
  smallnumber t  ;
  halfword q, r  ;
  t = mem [p ].hhfield .b0 - 1 ;
  q = mem [p + 1 ].cint ;
  if ( flushp ) 
  mem [p ].hhfield .b0 = 1 ;
  else p = q ;
  do {
      r = mem [q + 1 ].cint ;
    mem [q ].hhfield .b0 = t ;
    switch ( t ) 
    {case 2 : 
      mem [q + 1 ].cint = v ;
      break ;
    case 4 : 
      {
	mem [q + 1 ].cint = v ;
	{
	  if ( strref [v ]< 127 ) 
	  incr ( strref [v ]) ;
	} 
      } 
      break ;
    case 6 : 
      {
	mem [q + 1 ].cint = v ;
	incr ( mem [v ].hhfield .lhfield ) ;
      } 
      break ;
    case 9 : 
      mem [q + 1 ].cint = copypath ( v ) ;
      break ;
    case 11 : 
      mem [q + 1 ].cint = copyedges ( v ) ;
      break ;
    } 
    q = r ;
  } while ( ! ( q == p ) ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
zringmerge ( halfword p , halfword q ) 
#else
zringmerge ( p , q ) 
  halfword p ;
  halfword q ;
#endif
{
  /* 10 */ halfword r  ;
  r = mem [p + 1 ].cint ;
  while ( r != p ) {
      
    if ( r == q ) 
    {
      {
	{
	  if ( interaction == 3 ) 
	  ;
	  if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	  {
	    printnl ( 261 ) ;
	    print ( fullsourcefilenamestack [inopen ]) ;
	    print ( 58 ) ;
	    printint ( line ) ;
	    print ( 262 ) ;
	    print ( 600 ) ;
	  } 
	  else {
	      
	    printnl ( 263 ) ;
	    print ( 600 ) ;
	  } 
	} 
	{
	  helpptr = 2 ;
	  helpline [1 ]= 601 ;
	  helpline [0 ]= 602 ;
	} 
	putgeterror () ;
      } 
      goto lab10 ;
    } 
    r = mem [r + 1 ].cint ;
  } 
  r = mem [p + 1 ].cint ;
  mem [p + 1 ].cint = mem [q + 1 ].cint ;
  mem [q + 1 ].cint = r ;
  lab10: ;
} 
void 
#ifdef HAVE_PROTOTYPES
zshowcmdmod ( integer c , integer m ) 
#else
zshowcmdmod ( c , m ) 
  integer c ;
  integer m ;
#endif
{
  begindiagnostic () ;
  printnl ( 123 ) ;
  printcmdmod ( c , m ) ;
  printchar ( 125 ) ;
  enddiagnostic ( false ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
showcontext ( void ) 
#else
showcontext ( ) 
#endif
{
  /* 30 */ char oldsetting  ;
  integer i  ;
  integer l  ;
  integer m  ;
  integer n  ;
  integer p  ;
  integer q  ;
  fileptr = inputptr ;
  inputstack [fileptr ]= curinput ;
  while ( true ) {
      
    curinput = inputstack [fileptr ];
    if ( ( fileptr == inputptr ) || ( curinput .indexfield <= 15 ) || ( 
    curinput .indexfield != 19 ) || ( curinput .locfield != 0 ) ) 
    {
      tally = 0 ;
      oldsetting = selector ;
      if ( ( curinput .indexfield <= 15 ) ) 
      {
	if ( curinput .namefield <= 1 ) 
	if ( ( curinput .namefield == 0 ) && ( fileptr == 0 ) ) 
	printnl ( 604 ) ;
	else printnl ( 605 ) ;
	else if ( curinput .namefield == 2 ) 
	printnl ( 606 ) ;
	else {
	    
	  printnl ( 607 ) ;
	  printint ( line ) ;
	} 
	printchar ( 32 ) ;
	{
	  l = tally ;
	  tally = 0 ;
	  selector = 4 ;
	  trickcount = 1000000L ;
	} 
	if ( curinput .limitfield > 0 ) 
	{register integer for_end; i = curinput .startfield ;for_end = 
	curinput .limitfield - 1 ; if ( i <= for_end) do 
	  {
	    if ( i == curinput .locfield ) 
	    {
	      firstcount = tally ;
	      trickcount = tally + 1 + errorline - halferrorline ;
	      if ( trickcount < errorline ) 
	      trickcount = errorline ;
	    } 
	    print ( buffer [i ]) ;
	  } 
	while ( i++ < for_end ) ;} 
      } 
      else {
	  
	switch ( curinput .indexfield ) 
	{case 16 : 
	  printnl ( 608 ) ;
	  break ;
	case 17 : 
	  {
	    printnl ( 613 ) ;
	    p = paramstack [curinput .limitfield ];
	    if ( p != 0 ) 
	    if ( mem [p ].hhfield .v.RH == 1 ) 
	    printexp ( p , 0 ) ;
	    else showtokenlist ( p , 0 , 20 , tally ) ;
	    print ( 614 ) ;
	  } 
	  break ;
	case 18 : 
	  printnl ( 609 ) ;
	  break ;
	case 19 : 
	  if ( curinput .locfield == 0 ) 
	  printnl ( 610 ) ;
	  else printnl ( 611 ) ;
	  break ;
	case 20 : 
	  printnl ( 612 ) ;
	  break ;
	case 21 : 
	  {
	    println () ;
	    if ( curinput .namefield != 0 ) 
	    slowprint ( hash [curinput .namefield ].v.RH ) ;
	    else {
		
	      p = paramstack [curinput .limitfield ];
	      if ( p == 0 ) 
	      showtokenlist ( paramstack [curinput .limitfield + 1 ], 0 , 20 
	      , tally ) ;
	      else {
		  
		q = p ;
		while ( mem [q ].hhfield .v.RH != 0 ) q = mem [q ].hhfield 
		.v.RH ;
		mem [q ].hhfield .v.RH = paramstack [curinput .limitfield + 
		1 ];
		showtokenlist ( p , 0 , 20 , tally ) ;
		mem [q ].hhfield .v.RH = 0 ;
	      } 
	    } 
	    print ( 501 ) ;
	  } 
	  break ;
	  default: 
	  printnl ( 63 ) ;
	  break ;
	} 
	{
	  l = tally ;
	  tally = 0 ;
	  selector = 4 ;
	  trickcount = 1000000L ;
	} 
	if ( curinput .indexfield != 21 ) 
	showtokenlist ( curinput .startfield , curinput .locfield , 100000L , 
	0 ) ;
	else showmacro ( curinput .startfield , curinput .locfield , 100000L ) 
	;
      } 
      selector = oldsetting ;
      if ( trickcount == 1000000L ) 
      {
	firstcount = tally ;
	trickcount = tally + 1 + errorline - halferrorline ;
	if ( trickcount < errorline ) 
	trickcount = errorline ;
      } 
      if ( tally < trickcount ) 
      m = tally - firstcount ;
      else m = trickcount - firstcount ;
      if ( l + firstcount <= halferrorline ) 
      {
	p = 0 ;
	n = l + firstcount ;
      } 
      else {
	  
	print ( 276 ) ;
	p = l + firstcount - halferrorline + 3 ;
	n = halferrorline ;
      } 
      {register integer for_end; q = p ;for_end = firstcount - 1 ; if ( q <= 
      for_end) do 
	printchar ( trickbuf [q % errorline ]) ;
      while ( q++ < for_end ) ;} 
      println () ;
      {register integer for_end; q = 1 ;for_end = n ; if ( q <= for_end) do 
	printchar ( 32 ) ;
      while ( q++ < for_end ) ;} 
      if ( m + n <= errorline ) 
      p = firstcount + m ;
      else p = firstcount + ( errorline - n - 3 ) ;
      {register integer for_end; q = firstcount ;for_end = p - 1 ; if ( q <= 
      for_end) do 
	printchar ( trickbuf [q % errorline ]) ;
      while ( q++ < for_end ) ;} 
      if ( m + n > errorline ) 
      print ( 276 ) ;
    } 
    if ( ( curinput .indexfield <= 15 ) ) 
    if ( ( curinput .namefield > 2 ) || ( fileptr == 0 ) ) 
    goto lab30 ;
    decr ( fileptr ) ;
  } 
  lab30: curinput = inputstack [inputptr ];
} 
void 
#ifdef HAVE_PROTOTYPES
zbegintokenlist ( halfword p , quarterword t ) 
#else
zbegintokenlist ( p , t ) 
  halfword p ;
  quarterword t ;
#endif
{
  {
    if ( inputptr > maxinstack ) 
    {
      maxinstack = inputptr ;
      if ( inputptr == stacksize ) 
      overflow ( 615 , stacksize ) ;
    } 
    inputstack [inputptr ]= curinput ;
    incr ( inputptr ) ;
  } 
  curinput .startfield = p ;
  curinput .indexfield = t ;
  curinput .limitfield = paramptr ;
  curinput .locfield = p ;
} 
void 
#ifdef HAVE_PROTOTYPES
endtokenlist ( void ) 
#else
endtokenlist ( ) 
#endif
{
  /* 30 */ halfword p  ;
  if ( curinput .indexfield >= 19 ) 
  if ( curinput .indexfield <= 20 ) 
  {
    flushtokenlist ( curinput .startfield ) ;
    goto lab30 ;
  } 
  else deletemacref ( curinput .startfield ) ;
  while ( paramptr > curinput .limitfield ) {
      
    decr ( paramptr ) ;
    p = paramstack [paramptr ];
    if ( p != 0 ) 
    if ( mem [p ].hhfield .v.RH == 1 ) 
    {
      recyclevalue ( p ) ;
      freenode ( p , 2 ) ;
    } 
    else flushtokenlist ( p ) ;
  } 
  lab30: {
      
    decr ( inputptr ) ;
    curinput = inputstack [inputptr ];
  } 
  {
    if ( interrupt != 0 ) 
    pauseforinstructions () ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
zencapsulate ( halfword p ) 
#else
zencapsulate ( p ) 
  halfword p ;
#endif
{
  curexp = getnode ( 2 ) ;
  mem [curexp ].hhfield .b0 = curtype ;
  mem [curexp ].hhfield .b1 = 11 ;
  newdep ( curexp , p ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
zinstall ( halfword r , halfword q ) 
#else
zinstall ( r , q ) 
  halfword r ;
  halfword q ;
#endif
{
  halfword p  ;
  if ( mem [q ].hhfield .b0 == 16 ) 
  {
    mem [r + 1 ].cint = mem [q + 1 ].cint ;
    mem [r ].hhfield .b0 = 16 ;
  } 
  else if ( mem [q ].hhfield .b0 == 19 ) 
  {
    p = singledependency ( q ) ;
    if ( p == depfinal ) 
    {
      mem [r ].hhfield .b0 = 16 ;
      mem [r + 1 ].cint = 0 ;
      freenode ( p , 2 ) ;
    } 
    else {
	
      mem [r ].hhfield .b0 = 17 ;
      newdep ( r , p ) ;
    } 
  } 
  else {
      
    mem [r ].hhfield .b0 = mem [q ].hhfield .b0 ;
    newdep ( r , copydeplist ( mem [q + 1 ].hhfield .v.RH ) ) ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
zmakeexpcopy ( halfword p ) 
#else
zmakeexpcopy ( p ) 
  halfword p ;
#endif
{
  /* 20 */ halfword q, r, t  ;
  lab20: curtype = mem [p ].hhfield .b0 ;
  switch ( curtype ) 
  {case 1 : 
  case 2 : 
  case 16 : 
    curexp = mem [p + 1 ].cint ;
    break ;
  case 3 : 
  case 5 : 
  case 7 : 
  case 12 : 
  case 10 : 
    curexp = newringentry ( p ) ;
    break ;
  case 4 : 
    {
      curexp = mem [p + 1 ].cint ;
      {
	if ( strref [curexp ]< 127 ) 
	incr ( strref [curexp ]) ;
      } 
    } 
    break ;
  case 6 : 
    {
      curexp = mem [p + 1 ].cint ;
      incr ( mem [curexp ].hhfield .lhfield ) ;
    } 
    break ;
  case 11 : 
    curexp = copyedges ( mem [p + 1 ].cint ) ;
    break ;
  case 9 : 
  case 8 : 
    curexp = copypath ( mem [p + 1 ].cint ) ;
    break ;
  case 13 : 
  case 14 : 
    {
      if ( mem [p + 1 ].cint == 0 ) 
      initbignode ( p ) ;
      t = getnode ( 2 ) ;
      mem [t ].hhfield .b1 = 11 ;
      mem [t ].hhfield .b0 = curtype ;
      initbignode ( t ) ;
      q = mem [p + 1 ].cint + bignodesize [curtype ];
      r = mem [t + 1 ].cint + bignodesize [curtype ];
      do {
	  q = q - 2 ;
	r = r - 2 ;
	install ( r , q ) ;
      } while ( ! ( q == mem [p + 1 ].cint ) ) ;
      curexp = t ;
    } 
    break ;
  case 17 : 
  case 18 : 
    encapsulate ( copydeplist ( mem [p + 1 ].hhfield .v.RH ) ) ;
    break ;
  case 15 : 
    {
      {
	if ( serialno > 2147483583L ) 
	overflow ( 588 , serialno / 64 ) ;
	mem [p ].hhfield .b0 = 19 ;
	serialno = serialno + 64 ;
	mem [p + 1 ].cint = serialno ;
      } 
      goto lab20 ;
    } 
    break ;
  case 19 : 
    {
      q = singledependency ( p ) ;
      if ( q == depfinal ) 
      {
	curtype = 16 ;
	curexp = 0 ;
	freenode ( q , 2 ) ;
      } 
      else {
	  
	curtype = 17 ;
	encapsulate ( q ) ;
      } 
    } 
    break ;
    default: 
    confusion ( 800 ) ;
    break ;
  } 
} 
halfword 
#ifdef HAVE_PROTOTYPES
curtok ( void ) 
#else
curtok ( ) 
#endif
{
  register halfword Result; halfword p  ;
  smallnumber savetype  ;
  integer saveexp  ;
  if ( cursym == 0 ) 
  if ( curcmd == 38 ) 
  {
    savetype = curtype ;
    saveexp = curexp ;
    makeexpcopy ( curmod ) ;
    p = stashcurexp () ;
    mem [p ].hhfield .v.RH = 0 ;
    curtype = savetype ;
    curexp = saveexp ;
  } 
  else {
      
    p = getnode ( 2 ) ;
    mem [p + 1 ].cint = curmod ;
    mem [p ].hhfield .b1 = 12 ;
    if ( curcmd == 42 ) 
    mem [p ].hhfield .b0 = 16 ;
    else mem [p ].hhfield .b0 = 4 ;
  } 
  else {
      
    {
      p = avail ;
      if ( p == 0 ) 
      p = getavail () ;
      else {
	  
	avail = mem [p ].hhfield .v.RH ;
	mem [p ].hhfield .v.RH = 0 ;
	;
#ifdef STAT
	incr ( dynused ) ;
#endif /* STAT */
      } 
    } 
    mem [p ].hhfield .lhfield = cursym ;
  } 
  Result = p ;
  return Result ;
} 
void 
#ifdef HAVE_PROTOTYPES
backinput ( void ) 
#else
backinput ( ) 
#endif
{
  halfword p  ;
  p = curtok () ;
  while ( ( curinput .indexfield > 15 ) && ( curinput .locfield == 0 ) ) 
  endtokenlist () ;
  begintokenlist ( p , 19 ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
backerror ( void ) 
#else
backerror ( ) 
#endif
{
  OKtointerrupt = false ;
  backinput () ;
  OKtointerrupt = true ;
  error () ;
} 
void 
#ifdef HAVE_PROTOTYPES
inserror ( void ) 
#else
inserror ( ) 
#endif
{
  OKtointerrupt = false ;
  backinput () ;
  curinput .indexfield = 20 ;
  OKtointerrupt = true ;
  error () ;
} 
void 
#ifdef HAVE_PROTOTYPES
beginfilereading ( void ) 
#else
beginfilereading ( ) 
#endif
{
  if ( inopen == 15 ) 
  overflow ( 616 , 15 ) ;
  if ( first == bufsize ) 
  overflow ( 256 , bufsize ) ;
  incr ( inopen ) ;
  {
    if ( inputptr > maxinstack ) 
    {
      maxinstack = inputptr ;
      if ( inputptr == stacksize ) 
      overflow ( 615 , stacksize ) ;
    } 
    inputstack [inputptr ]= curinput ;
    incr ( inputptr ) ;
  } 
  curinput .indexfield = inopen ;
  linestack [curinput .indexfield ]= line ;
  curinput .startfield = first ;
  curinput .namefield = 0 ;
} 
void 
#ifdef HAVE_PROTOTYPES
endfilereading ( void ) 
#else
endfilereading ( ) 
#endif
{
  first = curinput .startfield ;
  line = linestack [curinput .indexfield ];
  if ( curinput .indexfield != inopen ) 
  confusion ( 617 ) ;
  if ( curinput .namefield > 2 ) 
  aclose ( inputfile [curinput .indexfield ]) ;
  {
    decr ( inputptr ) ;
    curinput = inputstack [inputptr ];
  } 
  decr ( inopen ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
clearforerrorprompt ( void ) 
#else
clearforerrorprompt ( ) 
#endif
{
  while ( ( curinput .indexfield <= 15 ) && ( curinput .namefield == 0 ) && 
  ( inputptr > 0 ) && ( curinput .locfield == curinput .limitfield ) ) 
  endfilereading () ;
  println () ;
} 
boolean 
#ifdef HAVE_PROTOTYPES
checkoutervalidity ( void ) 
#else
checkoutervalidity ( ) 
#endif
{
  register boolean Result; halfword p  ;
  if ( scannerstatus == 0 ) 
  Result = true ;
  else {
      
    deletionsallowed = false ;
    if ( cursym != 0 ) 
    {
      p = getavail () ;
      mem [p ].hhfield .lhfield = cursym ;
      begintokenlist ( p , 19 ) ;
    } 
    if ( scannerstatus > 1 ) 
    {
      runaway () ;
      if ( cursym == 0 ) 
      {
	if ( interaction == 3 ) 
	;
	if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	{
	  printnl ( 261 ) ;
	  print ( fullsourcefilenamestack [inopen ]) ;
	  print ( 58 ) ;
	  printint ( line ) ;
	  print ( 262 ) ;
	  print ( 623 ) ;
	} 
	else {
	    
	  printnl ( 263 ) ;
	  print ( 623 ) ;
	} 
      } 
      else {
	  
	{
	  if ( interaction == 3 ) 
	  ;
	  if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	  {
	    printnl ( 261 ) ;
	    print ( fullsourcefilenamestack [inopen ]) ;
	    print ( 58 ) ;
	    printint ( line ) ;
	    print ( 262 ) ;
	    print ( 624 ) ;
	  } 
	  else {
	      
	    printnl ( 263 ) ;
	    print ( 624 ) ;
	  } 
	} 
      } 
      print ( 625 ) ;
      {
	helpptr = 4 ;
	helpline [3 ]= 626 ;
	helpline [2 ]= 627 ;
	helpline [1 ]= 628 ;
	helpline [0 ]= 629 ;
      } 
      switch ( scannerstatus ) 
      {case 2 : 
	{
	  print ( 630 ) ;
	  helpline [3 ]= 631 ;
	  cursym = 9763 ;
	} 
	break ;
      case 3 : 
	{
	  print ( 632 ) ;
	  helpline [3 ]= 633 ;
	  if ( warninginfo == 0 ) 
	  cursym = 9767 ;
	  else {
	      
	    cursym = 9759 ;
	    eqtb [9759 ].v.RH = warninginfo ;
	  } 
	} 
	break ;
      case 4 : 
      case 5 : 
	{
	  print ( 634 ) ;
	  if ( scannerstatus == 5 ) 
	  slowprint ( hash [warninginfo ].v.RH ) ;
	  else printvariablename ( warninginfo ) ;
	  cursym = 9765 ;
	} 
	break ;
      case 6 : 
	{
	  print ( 635 ) ;
	  slowprint ( hash [warninginfo ].v.RH ) ;
	  print ( 636 ) ;
	  helpline [3 ]= 637 ;
	  cursym = 9764 ;
	} 
	break ;
      } 
      inserror () ;
    } 
    else {
	
      {
	if ( interaction == 3 ) 
	;
	if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	{
	  printnl ( 261 ) ;
	  print ( fullsourcefilenamestack [inopen ]) ;
	  print ( 58 ) ;
	  printint ( line ) ;
	  print ( 262 ) ;
	  print ( 618 ) ;
	} 
	else {
	    
	  printnl ( 263 ) ;
	  print ( 618 ) ;
	} 
      } 
      printint ( warninginfo ) ;
      {
	helpptr = 3 ;
	helpline [2 ]= 619 ;
	helpline [1 ]= 620 ;
	helpline [0 ]= 621 ;
      } 
      if ( cursym == 0 ) 
      helpline [2 ]= 622 ;
      cursym = 9766 ;
      inserror () ;
    } 
    deletionsallowed = true ;
    Result = false ;
  } 
  return Result ;
} 
void 
#ifdef HAVE_PROTOTYPES
getnext ( void ) 
#else
getnext ( ) 
#endif
{
  /* 20 10 40 25 85 86 87 30 */ integer k  ;
  ASCIIcode c  ;
  ASCIIcode cclass  ;
  integer n, f  ;
  lab20: cursym = 0 ;
  if ( ( curinput .indexfield <= 15 ) ) 
  {
    lab25: c = buffer [curinput .locfield ];
    incr ( curinput .locfield ) ;
    cclass = charclass [c ];
    switch ( cclass ) 
    {case 0 : 
      goto lab85 ;
      break ;
    case 1 : 
      {
	cclass = charclass [buffer [curinput .locfield ]];
	if ( cclass > 1 ) 
	goto lab25 ;
	else if ( cclass < 1 ) 
	{
	  n = 0 ;
	  goto lab86 ;
	} 
      } 
      break ;
    case 2 : 
      goto lab25 ;
      break ;
    case 3 : 
      {
	if ( curinput .namefield > 2 ) 
	{
	  incr ( line ) ;
	  first = curinput .startfield ;
	  if ( ! forceeof ) 
	  {
	    if ( inputln ( inputfile [curinput .indexfield ], true ) ) 
	    firmuptheline () ;
	    else forceeof = true ;
	  } 
	  if ( forceeof ) 
	  {
	    printchar ( 41 ) ;
	    decr ( openparens ) ;
	    fflush ( stdout ) ;
	    forceeof = false ;
	    endfilereading () ;
	    if ( checkoutervalidity () ) 
	    goto lab20 ;
	    else goto lab20 ;
	  } 
	  buffer [curinput .limitfield ]= 37 ;
	  first = curinput .limitfield + 1 ;
	  curinput .locfield = curinput .startfield ;
	} 
	else {
	    
	  if ( inputptr > 0 ) 
	  {
	    endfilereading () ;
	    goto lab20 ;
	  } 
	  if ( selector < 2 ) 
	  openlogfile () ;
	  if ( interaction > 1 ) 
	  {
	    if ( curinput .limitfield == curinput .startfield ) 
	    printnl ( 652 ) ;
	    println () ;
	    first = curinput .startfield ;
	    {
	      ;
	      print ( 42 ) ;
	      terminput () ;
	    } 
	    curinput .limitfield = last ;
	    buffer [curinput .limitfield ]= 37 ;
	    first = curinput .limitfield + 1 ;
	    curinput .locfield = curinput .startfield ;
	  } 
	  else fatalerror ( 653 ) ;
	} 
	{
	  if ( interrupt != 0 ) 
	  pauseforinstructions () ;
	} 
	goto lab25 ;
      } 
      break ;
    case 4 : 
      {
	if ( buffer [curinput .locfield ]== 34 ) 
	curmod = 261 ;
	else {
	    
	  k = curinput .locfield ;
	  buffer [curinput .limitfield + 1 ]= 34 ;
	  do {
	      incr ( curinput .locfield ) ;
	  } while ( ! ( buffer [curinput .locfield ]== 34 ) ) ;
	  if ( curinput .locfield > curinput .limitfield ) 
	  {
	    curinput .locfield = curinput .limitfield ;
	    {
	      if ( interaction == 3 ) 
	      ;
	      if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	      {
		printnl ( 261 ) ;
		print ( fullsourcefilenamestack [inopen ]) ;
		print ( 58 ) ;
		printint ( line ) ;
		print ( 262 ) ;
		print ( 645 ) ;
	      } 
	      else {
		  
		printnl ( 263 ) ;
		print ( 645 ) ;
	      } 
	    } 
	    {
	      helpptr = 3 ;
	      helpline [2 ]= 646 ;
	      helpline [1 ]= 647 ;
	      helpline [0 ]= 648 ;
	    } 
	    deletionsallowed = false ;
	    error () ;
	    deletionsallowed = true ;
	    goto lab20 ;
	  } 
	  if ( ( curinput .locfield == k + 1 ) && ( ( strstart [buffer [k ]
	  + 1 ]- strstart [buffer [k ]]) == 1 ) ) 
	  curmod = buffer [k ];
	  else {
	      
	    {
	      if ( poolptr + curinput .locfield - k > maxpoolptr ) 
	      {
		if ( poolptr + curinput .locfield - k > poolsize ) 
		overflow ( 257 , poolsize - initpoolptr ) ;
		maxpoolptr = poolptr + curinput .locfield - k ;
	      } 
	    } 
	    do {
		{ 
		strpool [poolptr ]= buffer [k ];
		incr ( poolptr ) ;
	      } 
	      incr ( k ) ;
	    } while ( ! ( k == curinput .locfield ) ) ;
	    curmod = makestring () ;
	  } 
	} 
	incr ( curinput .locfield ) ;
	curcmd = 39 ;
	goto lab10 ;
      } 
      break ;
    case 5 : 
    case 6 : 
    case 7 : 
    case 8 : 
      {
	k = curinput .locfield - 1 ;
	goto lab40 ;
      } 
      break ;
    case 20 : 
      {
	{
	  if ( interaction == 3 ) 
	  ;
	  if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	  {
	    printnl ( 261 ) ;
	    print ( fullsourcefilenamestack [inopen ]) ;
	    print ( 58 ) ;
	    printint ( line ) ;
	    print ( 262 ) ;
	    print ( 642 ) ;
	  } 
	  else {
	      
	    printnl ( 263 ) ;
	    print ( 642 ) ;
	  } 
	} 
	{
	  helpptr = 2 ;
	  helpline [1 ]= 643 ;
	  helpline [0 ]= 644 ;
	} 
	deletionsallowed = false ;
	error () ;
	deletionsallowed = true ;
	goto lab20 ;
      } 
      break ;
      default: 
      ;
      break ;
    } 
    k = curinput .locfield - 1 ;
    while ( charclass [buffer [curinput .locfield ]]== cclass ) incr ( 
    curinput .locfield ) ;
    goto lab40 ;
    lab85: n = c - 48 ;
    while ( charclass [buffer [curinput .locfield ]]== 0 ) {
	
      if ( n < 4096 ) 
      n = 10 * n + buffer [curinput .locfield ]- 48 ;
      incr ( curinput .locfield ) ;
    } 
    if ( buffer [curinput .locfield ]== 46 ) 
    if ( charclass [buffer [curinput .locfield + 1 ]]== 0 ) 
    goto lab30 ;
    f = 0 ;
    goto lab87 ;
    lab30: incr ( curinput .locfield ) ;
    lab86: k = 0 ;
    do {
	if ( k < 17 ) 
      {
	dig [k ]= buffer [curinput .locfield ]- 48 ;
	incr ( k ) ;
      } 
      incr ( curinput .locfield ) ;
    } while ( ! ( charclass [buffer [curinput .locfield ]]!= 0 ) ) ;
    f = rounddecimals ( k ) ;
    if ( f == 65536L ) 
    {
      incr ( n ) ;
      f = 0 ;
    } 
    lab87: if ( n < 4096 ) 
    curmod = n * 65536L + f ;
    else {
	
      {
	if ( interaction == 3 ) 
	;
	if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	{
	  printnl ( 261 ) ;
	  print ( fullsourcefilenamestack [inopen ]) ;
	  print ( 58 ) ;
	  printint ( line ) ;
	  print ( 262 ) ;
	  print ( 649 ) ;
	} 
	else {
	    
	  printnl ( 263 ) ;
	  print ( 649 ) ;
	} 
      } 
      {
	helpptr = 2 ;
	helpline [1 ]= 650 ;
	helpline [0 ]= 651 ;
      } 
      deletionsallowed = false ;
      error () ;
      deletionsallowed = true ;
      curmod = 268435455L ;
    } 
    curcmd = 42 ;
    goto lab10 ;
    lab40: cursym = idlookup ( k , curinput .locfield - k ) ;
  } 
  else if ( curinput .locfield >= himemmin ) 
  {
    cursym = mem [curinput .locfield ].hhfield .lhfield ;
    curinput .locfield = mem [curinput .locfield ].hhfield .v.RH ;
    if ( cursym >= 9770 ) 
    if ( cursym >= 9920 ) 
    {
      if ( cursym >= 10070 ) 
      cursym = cursym - 150 ;
      begintokenlist ( paramstack [curinput .limitfield + cursym - ( 9920 ) ]
      , 18 ) ;
      goto lab20 ;
    } 
    else {
	
      curcmd = 38 ;
      curmod = paramstack [curinput .limitfield + cursym - ( 9770 ) ];
      cursym = 0 ;
      goto lab10 ;
    } 
  } 
  else if ( curinput .locfield > 0 ) 
  {
    if ( mem [curinput .locfield ].hhfield .b1 == 12 ) 
    {
      curmod = mem [curinput .locfield + 1 ].cint ;
      if ( mem [curinput .locfield ].hhfield .b0 == 16 ) 
      curcmd = 42 ;
      else {
	  
	curcmd = 39 ;
	{
	  if ( strref [curmod ]< 127 ) 
	  incr ( strref [curmod ]) ;
	} 
      } 
    } 
    else {
	
      curmod = curinput .locfield ;
      curcmd = 38 ;
    } 
    curinput .locfield = mem [curinput .locfield ].hhfield .v.RH ;
    goto lab10 ;
  } 
  else {
      
    endtokenlist () ;
    goto lab20 ;
  } 
  curcmd = eqtb [cursym ].lhfield ;
  curmod = eqtb [cursym ].v.RH ;
  if ( curcmd >= 86 ) 
  if ( checkoutervalidity () ) 
  curcmd = curcmd - 86 ;
  else goto lab20 ;
  lab10: ;
} 
void 
#ifdef HAVE_PROTOTYPES
firmuptheline ( void ) 
#else
firmuptheline ( ) 
#endif
{
  integer k  ;
  curinput .limitfield = last ;
  if ( internal [31 ]> 0 ) 
  if ( interaction > 1 ) 
  {
    ;
    println () ;
    if ( curinput .startfield < curinput .limitfield ) 
    {register integer for_end; k = curinput .startfield ;for_end = curinput 
    .limitfield - 1 ; if ( k <= for_end) do 
      print ( buffer [k ]) ;
    while ( k++ < for_end ) ;} 
    first = curinput .limitfield ;
    {
      ;
      print ( 654 ) ;
      terminput () ;
    } 
    if ( last > first ) 
    {
      {register integer for_end; k = first ;for_end = last - 1 ; if ( k <= 
      for_end) do 
	buffer [k + curinput .startfield - first ]= buffer [k ];
      while ( k++ < for_end ) ;} 
      curinput .limitfield = curinput .startfield + last - first ;
    } 
  } 
} 
halfword 
#ifdef HAVE_PROTOTYPES
zscantoks ( commandcode terminator , halfword substlist , halfword tailend , 
smallnumber suffixcount ) 
#else
zscantoks ( terminator , substlist , tailend , suffixcount ) 
  commandcode terminator ;
  halfword substlist ;
  halfword tailend ;
  smallnumber suffixcount ;
#endif
{
  /* 30 40 */ register halfword Result; halfword p  ;
  halfword q  ;
  integer balance  ;
  p = memtop - 2 ;
  balance = 1 ;
  mem [memtop - 2 ].hhfield .v.RH = 0 ;
  while ( true ) {
      
    getnext () ;
    if ( cursym > 0 ) 
    {
      {
	q = substlist ;
	while ( q != 0 ) {
	    
	  if ( mem [q ].hhfield .lhfield == cursym ) 
	  {
	    cursym = mem [q + 1 ].cint ;
	    curcmd = 7 ;
	    goto lab40 ;
	  } 
	  q = mem [q ].hhfield .v.RH ;
	} 
	lab40: ;
      } 
      if ( curcmd == terminator ) 
      if ( curmod > 0 ) 
      incr ( balance ) ;
      else {
	  
	decr ( balance ) ;
	if ( balance == 0 ) 
	goto lab30 ;
      } 
      else if ( curcmd == 61 ) 
      {
	if ( curmod == 0 ) 
	getnext () ;
	else if ( curmod <= suffixcount ) 
	cursym = 9919 + curmod ;
      } 
    } 
    mem [p ].hhfield .v.RH = curtok () ;
    p = mem [p ].hhfield .v.RH ;
  } 
  lab30: mem [p ].hhfield .v.RH = tailend ;
  flushnodelist ( substlist ) ;
  Result = mem [memtop - 2 ].hhfield .v.RH ;
  return Result ;
} 
void 
#ifdef HAVE_PROTOTYPES
getsymbol ( void ) 
#else
getsymbol ( ) 
#endif
{
  /* 20 */ lab20: getnext () ;
  if ( ( cursym == 0 ) || ( cursym > 9757 ) ) 
  {
    {
      if ( interaction == 3 ) 
      ;
      if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
      {
	printnl ( 261 ) ;
	print ( fullsourcefilenamestack [inopen ]) ;
	print ( 58 ) ;
	printint ( line ) ;
	print ( 262 ) ;
	print ( 666 ) ;
      } 
      else {
	  
	printnl ( 263 ) ;
	print ( 666 ) ;
      } 
    } 
    {
      helpptr = 3 ;
      helpline [2 ]= 667 ;
      helpline [1 ]= 668 ;
      helpline [0 ]= 669 ;
    } 
    if ( cursym > 0 ) 
    helpline [2 ]= 670 ;
    else if ( curcmd == 39 ) 
    {
      if ( strref [curmod ]< 127 ) 
      if ( strref [curmod ]> 1 ) 
      decr ( strref [curmod ]) ;
      else flushstring ( curmod ) ;
    } 
    cursym = 9757 ;
    inserror () ;
    goto lab20 ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
getclearsymbol ( void ) 
#else
getclearsymbol ( ) 
#endif
{
  getsymbol () ;
  clearsymbol ( cursym , false ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
checkequals ( void ) 
#else
checkequals ( ) 
#endif
{
  if ( curcmd != 51 ) 
  if ( curcmd != 77 ) 
  {
    missingerr ( 61 ) ;
    {
      helpptr = 5 ;
      helpline [4 ]= 671 ;
      helpline [3 ]= 672 ;
      helpline [2 ]= 673 ;
      helpline [1 ]= 674 ;
      helpline [0 ]= 675 ;
    } 
    backerror () ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
makeopdef ( void ) 
#else
makeopdef ( ) 
#endif
{
  commandcode m  ;
  halfword p, q, r  ;
  m = curmod ;
  getsymbol () ;
  q = getnode ( 2 ) ;
  mem [q ].hhfield .lhfield = cursym ;
  mem [q + 1 ].cint = 9770 ;
  getclearsymbol () ;
  warninginfo = cursym ;
  getsymbol () ;
  p = getnode ( 2 ) ;
  mem [p ].hhfield .lhfield = cursym ;
  mem [p + 1 ].cint = 9771 ;
  mem [p ].hhfield .v.RH = q ;
  getnext () ;
  checkequals () ;
  scannerstatus = 5 ;
  q = getavail () ;
  mem [q ].hhfield .lhfield = 0 ;
  r = getavail () ;
  mem [q ].hhfield .v.RH = r ;
  mem [r ].hhfield .lhfield = 0 ;
  mem [r ].hhfield .v.RH = scantoks ( 16 , p , 0 , 0 ) ;
  scannerstatus = 0 ;
  eqtb [warninginfo ].lhfield = m ;
  eqtb [warninginfo ].v.RH = q ;
  getxnext () ;
} 
void 
#ifdef HAVE_PROTOTYPES
zcheckdelimiter ( halfword ldelim , halfword rdelim ) 
#else
zcheckdelimiter ( ldelim , rdelim ) 
  halfword ldelim ;
  halfword rdelim ;
#endif
{
  /* 10 */ if ( curcmd == 62 ) 
  if ( curmod == ldelim ) 
  goto lab10 ;
  if ( cursym != rdelim ) 
  {
    missingerr ( hash [rdelim ].v.RH ) ;
    {
      helpptr = 2 ;
      helpline [1 ]= 922 ;
      helpline [0 ]= 923 ;
    } 
    backerror () ;
  } 
  else {
      
    {
      if ( interaction == 3 ) 
      ;
      if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
      {
	printnl ( 261 ) ;
	print ( fullsourcefilenamestack [inopen ]) ;
	print ( 58 ) ;
	printint ( line ) ;
	print ( 262 ) ;
	print ( 924 ) ;
      } 
      else {
	  
	printnl ( 263 ) ;
	print ( 924 ) ;
      } 
    } 
    slowprint ( hash [rdelim ].v.RH ) ;
    print ( 925 ) ;
    {
      helpptr = 3 ;
      helpline [2 ]= 926 ;
      helpline [1 ]= 927 ;
      helpline [0 ]= 928 ;
    } 
    error () ;
  } 
  lab10: ;
} 
halfword 
#ifdef HAVE_PROTOTYPES
scandeclaredvariable ( void ) 
#else
scandeclaredvariable ( ) 
#endif
{
  /* 30 */ register halfword Result; halfword x  ;
  halfword h, t  ;
  halfword l  ;
  getsymbol () ;
  x = cursym ;
  if ( curcmd != 41 ) 
  clearsymbol ( x , false ) ;
  h = getavail () ;
  mem [h ].hhfield .lhfield = x ;
  t = h ;
  while ( true ) {
      
    getxnext () ;
    if ( cursym == 0 ) 
    goto lab30 ;
    if ( curcmd != 41 ) 
    if ( curcmd != 40 ) 
    if ( curcmd == 63 ) 
    {
      l = cursym ;
      getxnext () ;
      if ( curcmd != 64 ) 
      {
	backinput () ;
	cursym = l ;
	curcmd = 63 ;
	goto lab30 ;
      } 
      else cursym = 0 ;
    } 
    else goto lab30 ;
    mem [t ].hhfield .v.RH = getavail () ;
    t = mem [t ].hhfield .v.RH ;
    mem [t ].hhfield .lhfield = cursym ;
  } 
  lab30: if ( eqtb [x ].lhfield % 86 != 41 ) 
  clearsymbol ( x , false ) ;
  if ( eqtb [x ].v.RH == 0 ) 
  newroot ( x ) ;
  Result = h ;
  return Result ;
} 
void 
#ifdef HAVE_PROTOTYPES
scandef ( void ) 
#else
scandef ( ) 
#endif
{
  char m  ;
  char n  ;
  unsigned char k  ;
  char c  ;
  halfword r  ;
  halfword q  ;
  halfword p  ;
  halfword base  ;
  halfword ldelim, rdelim  ;
  m = curmod ;
  c = 0 ;
  mem [memtop - 2 ].hhfield .v.RH = 0 ;
  q = getavail () ;
  mem [q ].hhfield .lhfield = 0 ;
  r = 0 ;
  if ( m == 1 ) 
  {
    getclearsymbol () ;
    warninginfo = cursym ;
    getnext () ;
    scannerstatus = 5 ;
    n = 0 ;
    eqtb [warninginfo ].lhfield = 10 ;
    eqtb [warninginfo ].v.RH = q ;
  } 
  else {
      
    p = scandeclaredvariable () ;
    flushvariable ( eqtb [mem [p ].hhfield .lhfield ].v.RH , mem [p ]
    .hhfield .v.RH , true ) ;
    warninginfo = findvariable ( p ) ;
    flushlist ( p ) ;
    if ( warninginfo == 0 ) 
    {
      {
	if ( interaction == 3 ) 
	;
	if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	{
	  printnl ( 261 ) ;
	  print ( fullsourcefilenamestack [inopen ]) ;
	  print ( 58 ) ;
	  printint ( line ) ;
	  print ( 262 ) ;
	  print ( 682 ) ;
	} 
	else {
	    
	  printnl ( 263 ) ;
	  print ( 682 ) ;
	} 
      } 
      {
	helpptr = 2 ;
	helpline [1 ]= 683 ;
	helpline [0 ]= 684 ;
      } 
      error () ;
      warninginfo = 21 ;
    } 
    scannerstatus = 4 ;
    n = 2 ;
    if ( curcmd == 61 ) 
    if ( curmod == 3 ) 
    {
      n = 3 ;
      getnext () ;
    } 
    mem [warninginfo ].hhfield .b0 = 20 + n ;
    mem [warninginfo + 1 ].cint = q ;
  } 
  k = n ;
  if ( curcmd == 31 ) 
  do {
      ldelim = cursym ;
    rdelim = curmod ;
    getnext () ;
    if ( ( curcmd == 56 ) && ( curmod >= 9770 ) ) 
    base = curmod ;
    else {
	
      {
	if ( interaction == 3 ) 
	;
	if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	{
	  printnl ( 261 ) ;
	  print ( fullsourcefilenamestack [inopen ]) ;
	  print ( 58 ) ;
	  printint ( line ) ;
	  print ( 262 ) ;
	  print ( 685 ) ;
	} 
	else {
	    
	  printnl ( 263 ) ;
	  print ( 685 ) ;
	} 
      } 
      {
	helpptr = 1 ;
	helpline [0 ]= 686 ;
      } 
      backerror () ;
      base = 9770 ;
    } 
    do {
	mem [q ].hhfield .v.RH = getavail () ;
      q = mem [q ].hhfield .v.RH ;
      mem [q ].hhfield .lhfield = base + k ;
      getsymbol () ;
      p = getnode ( 2 ) ;
      mem [p + 1 ].cint = base + k ;
      mem [p ].hhfield .lhfield = cursym ;
      if ( k == 150 ) 
      overflow ( 687 , 150 ) ;
      incr ( k ) ;
      mem [p ].hhfield .v.RH = r ;
      r = p ;
      getnext () ;
    } while ( ! ( curcmd != 82 ) ) ;
    checkdelimiter ( ldelim , rdelim ) ;
    getnext () ;
  } while ( ! ( curcmd != 31 ) ) ;
  if ( curcmd == 56 ) 
  {
    p = getnode ( 2 ) ;
    if ( curmod < 9770 ) 
    {
      c = curmod ;
      mem [p + 1 ].cint = 9770 + k ;
    } 
    else {
	
      mem [p + 1 ].cint = curmod + k ;
      if ( curmod == 9770 ) 
      c = 4 ;
      else if ( curmod == 9920 ) 
      c = 6 ;
      else c = 7 ;
    } 
    if ( k == 150 ) 
    overflow ( 687 , 150 ) ;
    incr ( k ) ;
    getsymbol () ;
    mem [p ].hhfield .lhfield = cursym ;
    mem [p ].hhfield .v.RH = r ;
    r = p ;
    getnext () ;
    if ( c == 4 ) 
    if ( curcmd == 69 ) 
    {
      c = 5 ;
      p = getnode ( 2 ) ;
      if ( k == 150 ) 
      overflow ( 687 , 150 ) ;
      mem [p + 1 ].cint = 9770 + k ;
      getsymbol () ;
      mem [p ].hhfield .lhfield = cursym ;
      mem [p ].hhfield .v.RH = r ;
      r = p ;
      getnext () ;
    } 
  } 
  checkequals () ;
  p = getavail () ;
  mem [p ].hhfield .lhfield = c ;
  mem [q ].hhfield .v.RH = p ;
  if ( m == 1 ) 
  mem [p ].hhfield .v.RH = scantoks ( 16 , r , 0 , n ) ;
  else {
      
    q = getavail () ;
    mem [q ].hhfield .lhfield = bgloc ;
    mem [p ].hhfield .v.RH = q ;
    p = getavail () ;
    mem [p ].hhfield .lhfield = egloc ;
    mem [q ].hhfield .v.RH = scantoks ( 16 , r , p , n ) ;
  } 
  if ( warninginfo == 21 ) 
  flushtokenlist ( mem [22 ].cint ) ;
  scannerstatus = 0 ;
  getxnext () ;
} 
void 
#ifdef HAVE_PROTOTYPES
zprintmacroname ( halfword a , halfword n ) 
#else
zprintmacroname ( a , n ) 
  halfword a ;
  halfword n ;
#endif
{
  halfword p, q  ;
  if ( n != 0 ) 
  slowprint ( hash [n ].v.RH ) ;
  else {
      
    p = mem [a ].hhfield .lhfield ;
    if ( p == 0 ) 
    slowprint ( hash [mem [mem [mem [a ].hhfield .v.RH ].hhfield 
    .lhfield ].hhfield .lhfield ].v.RH ) ;
    else {
	
      q = p ;
      while ( mem [q ].hhfield .v.RH != 0 ) q = mem [q ].hhfield .v.RH ;
      mem [q ].hhfield .v.RH = mem [mem [a ].hhfield .v.RH ].hhfield 
      .lhfield ;
      showtokenlist ( p , 0 , 1000 , 0 ) ;
      mem [q ].hhfield .v.RH = 0 ;
    } 
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
zprintarg ( halfword q , integer n , halfword b ) 
#else
zprintarg ( q , n , b ) 
  halfword q ;
  integer n ;
  halfword b ;
#endif
{
  if ( mem [q ].hhfield .v.RH == 1 ) 
  printnl ( 498 ) ;
  else if ( ( b < 10070 ) && ( b != 7 ) ) 
  printnl ( 499 ) ;
  else printnl ( 500 ) ;
  printint ( n ) ;
  print ( 703 ) ;
  if ( mem [q ].hhfield .v.RH == 1 ) 
  printexp ( q , 1 ) ;
  else showtokenlist ( q , 0 , 1000 , 0 ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
zscantextarg ( halfword ldelim , halfword rdelim ) 
#else
zscantextarg ( ldelim , rdelim ) 
  halfword ldelim ;
  halfword rdelim ;
#endif
{
  /* 30 */ integer balance  ;
  halfword p  ;
  warninginfo = ldelim ;
  scannerstatus = 3 ;
  p = memtop - 2 ;
  balance = 1 ;
  mem [memtop - 2 ].hhfield .v.RH = 0 ;
  while ( true ) {
      
    getnext () ;
    if ( ldelim == 0 ) 
    {
      if ( curcmd > 82 ) 
      {
	if ( balance == 1 ) 
	goto lab30 ;
	else if ( curcmd == 84 ) 
	decr ( balance ) ;
      } 
      else if ( curcmd == 32 ) 
      incr ( balance ) ;
    } 
    else {
	
      if ( curcmd == 62 ) 
      {
	if ( curmod == ldelim ) 
	{
	  decr ( balance ) ;
	  if ( balance == 0 ) 
	  goto lab30 ;
	} 
      } 
      else if ( curcmd == 31 ) 
      if ( curmod == rdelim ) 
      incr ( balance ) ;
    } 
    mem [p ].hhfield .v.RH = curtok () ;
    p = mem [p ].hhfield .v.RH ;
  } 
  lab30: curexp = mem [memtop - 2 ].hhfield .v.RH ;
  curtype = 20 ;
  scannerstatus = 0 ;
} 
void 
#ifdef HAVE_PROTOTYPES
zmacrocall ( halfword defref , halfword arglist , halfword macroname ) 
#else
zmacrocall ( defref , arglist , macroname ) 
  halfword defref ;
  halfword arglist ;
  halfword macroname ;
#endif
{
  /* 40 */ halfword r  ;
  halfword p, q  ;
  integer n  ;
  halfword ldelim, rdelim  ;
  halfword tail  ;
  r = mem [defref ].hhfield .v.RH ;
  incr ( mem [defref ].hhfield .lhfield ) ;
  if ( arglist == 0 ) 
  n = 0 ;
  else {
      
    n = 1 ;
    tail = arglist ;
    while ( mem [tail ].hhfield .v.RH != 0 ) {
	
      incr ( n ) ;
      tail = mem [tail ].hhfield .v.RH ;
    } 
  } 
  if ( internal [9 ]> 0 ) 
  {
    begindiagnostic () ;
    println () ;
    printmacroname ( arglist , macroname ) ;
    if ( n == 3 ) 
    print ( 665 ) ;
    showmacro ( defref , 0 , 100000L ) ;
    if ( arglist != 0 ) 
    {
      n = 0 ;
      p = arglist ;
      do {
	  q = mem [p ].hhfield .lhfield ;
	printarg ( q , n , 0 ) ;
	incr ( n ) ;
	p = mem [p ].hhfield .v.RH ;
      } while ( ! ( p == 0 ) ) ;
    } 
    enddiagnostic ( false ) ;
  } 
  curcmd = 83 ;
  while ( mem [r ].hhfield .lhfield >= 9770 ) {
      
    if ( curcmd != 82 ) 
    {
      getxnext () ;
      if ( curcmd != 31 ) 
      {
	{
	  if ( interaction == 3 ) 
	  ;
	  if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	  {
	    printnl ( 261 ) ;
	    print ( fullsourcefilenamestack [inopen ]) ;
	    print ( 58 ) ;
	    printint ( line ) ;
	    print ( 262 ) ;
	    print ( 709 ) ;
	  } 
	  else {
	      
	    printnl ( 263 ) ;
	    print ( 709 ) ;
	  } 
	} 
	printmacroname ( arglist , macroname ) ;
	{
	  helpptr = 3 ;
	  helpline [2 ]= 710 ;
	  helpline [1 ]= 711 ;
	  helpline [0 ]= 712 ;
	} 
	if ( mem [r ].hhfield .lhfield >= 9920 ) 
	{
	  curexp = 0 ;
	  curtype = 20 ;
	} 
	else {
	    
	  curexp = 0 ;
	  curtype = 16 ;
	} 
	backerror () ;
	curcmd = 62 ;
	goto lab40 ;
      } 
      ldelim = cursym ;
      rdelim = curmod ;
    } 
    if ( mem [r ].hhfield .lhfield >= 10070 ) 
    scantextarg ( ldelim , rdelim ) ;
    else {
	
      getxnext () ;
      if ( mem [r ].hhfield .lhfield >= 9920 ) 
      scansuffix () ;
      else scanexpression () ;
    } 
    if ( curcmd != 82 ) 
    if ( ( curcmd != 62 ) || ( curmod != ldelim ) ) 
    if ( mem [mem [r ].hhfield .v.RH ].hhfield .lhfield >= 9770 ) 
    {
      missingerr ( 44 ) ;
      {
	helpptr = 3 ;
	helpline [2 ]= 713 ;
	helpline [1 ]= 714 ;
	helpline [0 ]= 708 ;
      } 
      backerror () ;
      curcmd = 82 ;
    } 
    else {
	
      missingerr ( hash [rdelim ].v.RH ) ;
      {
	helpptr = 2 ;
	helpline [1 ]= 715 ;
	helpline [0 ]= 708 ;
      } 
      backerror () ;
    } 
    lab40: {
	
      p = getavail () ;
      if ( curtype == 20 ) 
      mem [p ].hhfield .lhfield = curexp ;
      else mem [p ].hhfield .lhfield = stashcurexp () ;
      if ( internal [9 ]> 0 ) 
      {
	begindiagnostic () ;
	printarg ( mem [p ].hhfield .lhfield , n , mem [r ].hhfield 
	.lhfield ) ;
	enddiagnostic ( false ) ;
      } 
      if ( arglist == 0 ) 
      arglist = p ;
      else mem [tail ].hhfield .v.RH = p ;
      tail = p ;
      incr ( n ) ;
    } 
    r = mem [r ].hhfield .v.RH ;
  } 
  if ( curcmd == 82 ) 
  {
    {
      if ( interaction == 3 ) 
      ;
      if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
      {
	printnl ( 261 ) ;
	print ( fullsourcefilenamestack [inopen ]) ;
	print ( 58 ) ;
	printint ( line ) ;
	print ( 262 ) ;
	print ( 704 ) ;
      } 
      else {
	  
	printnl ( 263 ) ;
	print ( 704 ) ;
      } 
    } 
    printmacroname ( arglist , macroname ) ;
    printchar ( 59 ) ;
    printnl ( 705 ) ;
    slowprint ( hash [rdelim ].v.RH ) ;
    print ( 299 ) ;
    {
      helpptr = 3 ;
      helpline [2 ]= 706 ;
      helpline [1 ]= 707 ;
      helpline [0 ]= 708 ;
    } 
    error () ;
  } 
  if ( mem [r ].hhfield .lhfield != 0 ) 
  {
    if ( mem [r ].hhfield .lhfield < 7 ) 
    {
      getxnext () ;
      if ( mem [r ].hhfield .lhfield != 6 ) 
      if ( ( curcmd == 51 ) || ( curcmd == 77 ) ) 
      getxnext () ;
    } 
    switch ( mem [r ].hhfield .lhfield ) 
    {case 1 : 
      scanprimary () ;
      break ;
    case 2 : 
      scansecondary () ;
      break ;
    case 3 : 
      scantertiary () ;
      break ;
    case 4 : 
      scanexpression () ;
      break ;
    case 5 : 
      {
	scanexpression () ;
	p = getavail () ;
	mem [p ].hhfield .lhfield = stashcurexp () ;
	if ( internal [9 ]> 0 ) 
	{
	  begindiagnostic () ;
	  printarg ( mem [p ].hhfield .lhfield , n , 0 ) ;
	  enddiagnostic ( false ) ;
	} 
	if ( arglist == 0 ) 
	arglist = p ;
	else mem [tail ].hhfield .v.RH = p ;
	tail = p ;
	incr ( n ) ;
	if ( curcmd != 69 ) 
	{
	  missingerr ( 479 ) ;
	  print ( 716 ) ;
	  printmacroname ( arglist , macroname ) ;
	  {
	    helpptr = 1 ;
	    helpline [0 ]= 717 ;
	  } 
	  backerror () ;
	} 
	getxnext () ;
	scanprimary () ;
      } 
      break ;
    case 6 : 
      {
	if ( curcmd != 31 ) 
	ldelim = 0 ;
	else {
	    
	  ldelim = cursym ;
	  rdelim = curmod ;
	  getxnext () ;
	} 
	scansuffix () ;
	if ( ldelim != 0 ) 
	{
	  if ( ( curcmd != 62 ) || ( curmod != ldelim ) ) 
	  {
	    missingerr ( hash [rdelim ].v.RH ) ;
	    {
	      helpptr = 2 ;
	      helpline [1 ]= 715 ;
	      helpline [0 ]= 708 ;
	    } 
	    backerror () ;
	  } 
	  getxnext () ;
	} 
      } 
      break ;
    case 7 : 
      scantextarg ( 0 , 0 ) ;
      break ;
    } 
    backinput () ;
    {
      p = getavail () ;
      if ( curtype == 20 ) 
      mem [p ].hhfield .lhfield = curexp ;
      else mem [p ].hhfield .lhfield = stashcurexp () ;
      if ( internal [9 ]> 0 ) 
      {
	begindiagnostic () ;
	printarg ( mem [p ].hhfield .lhfield , n , mem [r ].hhfield 
	.lhfield ) ;
	enddiagnostic ( false ) ;
      } 
      if ( arglist == 0 ) 
      arglist = p ;
      else mem [tail ].hhfield .v.RH = p ;
      tail = p ;
      incr ( n ) ;
    } 
  } 
  r = mem [r ].hhfield .v.RH ;
  while ( ( curinput .indexfield > 15 ) && ( curinput .locfield == 0 ) ) 
  endtokenlist () ;
  if ( paramptr + n > maxparamstack ) 
  {
    maxparamstack = paramptr + n ;
    if ( maxparamstack > 150 ) 
    overflow ( 687 , 150 ) ;
  } 
  begintokenlist ( defref , 21 ) ;
  curinput .namefield = macroname ;
  curinput .locfield = r ;
  if ( n > 0 ) 
  {
    p = arglist ;
    do {
	paramstack [paramptr ]= mem [p ].hhfield .lhfield ;
      incr ( paramptr ) ;
      p = mem [p ].hhfield .v.RH ;
    } while ( ! ( p == 0 ) ) ;
    flushlist ( arglist ) ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
expand ( void ) 
#else
expand ( ) 
#endif
{
  halfword p  ;
  integer k  ;
  poolpointer j  ;
  if ( internal [7 ]> 65536L ) 
  if ( curcmd != 10 ) 
  showcmdmod ( curcmd , curmod ) ;
  switch ( curcmd ) 
  {case 1 : 
    conditional () ;
    break ;
  case 2 : 
    if ( curmod > iflimit ) 
    if ( iflimit == 1 ) 
    {
      missingerr ( 58 ) ;
      backinput () ;
      cursym = 9762 ;
      inserror () ;
    } 
    else {
	
      {
	if ( interaction == 3 ) 
	;
	if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	{
	  printnl ( 261 ) ;
	  print ( fullsourcefilenamestack [inopen ]) ;
	  print ( 58 ) ;
	  printint ( line ) ;
	  print ( 262 ) ;
	  print ( 724 ) ;
	} 
	else {
	    
	  printnl ( 263 ) ;
	  print ( 724 ) ;
	} 
      } 
      printcmdmod ( 2 , curmod ) ;
      {
	helpptr = 1 ;
	helpline [0 ]= 725 ;
      } 
      error () ;
    } 
    else {
	
      while ( curmod != 2 ) passtext () ;
      {
	p = condptr ;
	ifline = mem [p + 1 ].cint ;
	curif = mem [p ].hhfield .b1 ;
	iflimit = mem [p ].hhfield .b0 ;
	condptr = mem [p ].hhfield .v.RH ;
	freenode ( p , 2 ) ;
      } 
    } 
    break ;
  case 3 : 
    if ( curmod > 0 ) 
    forceeof = true ;
    else startinput () ;
    break ;
  case 4 : 
    if ( curmod == 0 ) 
    {
      {
	if ( interaction == 3 ) 
	;
	if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	{
	  printnl ( 261 ) ;
	  print ( fullsourcefilenamestack [inopen ]) ;
	  print ( 58 ) ;
	  printint ( line ) ;
	  print ( 262 ) ;
	  print ( 688 ) ;
	} 
	else {
	    
	  printnl ( 263 ) ;
	  print ( 688 ) ;
	} 
      } 
      {
	helpptr = 2 ;
	helpline [1 ]= 689 ;
	helpline [0 ]= 690 ;
      } 
      error () ;
    } 
    else beginiteration () ;
    break ;
  case 5 : 
    {
      while ( ( curinput .indexfield > 15 ) && ( curinput .locfield == 0 ) ) 
      endtokenlist () ;
      if ( loopptr == 0 ) 
      {
	{
	  if ( interaction == 3 ) 
	  ;
	  if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	  {
	    printnl ( 261 ) ;
	    print ( fullsourcefilenamestack [inopen ]) ;
	    print ( 58 ) ;
	    printint ( line ) ;
	    print ( 262 ) ;
	    print ( 692 ) ;
	  } 
	  else {
	      
	    printnl ( 263 ) ;
	    print ( 692 ) ;
	  } 
	} 
	{
	  helpptr = 2 ;
	  helpline [1 ]= 693 ;
	  helpline [0 ]= 694 ;
	} 
	error () ;
      } 
      else resumeiteration () ;
    } 
    break ;
  case 6 : 
    {
      getboolean () ;
      if ( internal [7 ]> 65536L ) 
      showcmdmod ( 33 , curexp ) ;
      if ( curexp == 30 ) 
      if ( loopptr == 0 ) 
      {
	{
	  if ( interaction == 3 ) 
	  ;
	  if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	  {
	    printnl ( 261 ) ;
	    print ( fullsourcefilenamestack [inopen ]) ;
	    print ( 58 ) ;
	    printint ( line ) ;
	    print ( 262 ) ;
	    print ( 695 ) ;
	  } 
	  else {
	      
	    printnl ( 263 ) ;
	    print ( 695 ) ;
	  } 
	} 
	{
	  helpptr = 1 ;
	  helpline [0 ]= 696 ;
	} 
	if ( curcmd == 83 ) 
	error () ;
	else backerror () ;
      } 
      else {
	  
	p = 0 ;
	do {
	    if ( ( curinput .indexfield <= 15 ) ) 
	  endfilereading () ;
	  else {
	      
	    if ( curinput .indexfield <= 17 ) 
	    p = curinput .startfield ;
	    endtokenlist () ;
	  } 
	} while ( ! ( p != 0 ) ) ;
	if ( p != mem [loopptr ].hhfield .lhfield ) 
	fatalerror ( 699 ) ;
	stopiteration () ;
      } 
      else if ( curcmd != 83 ) 
      {
	missingerr ( 59 ) ;
	{
	  helpptr = 2 ;
	  helpline [1 ]= 697 ;
	  helpline [0 ]= 698 ;
	} 
	backerror () ;
      } 
    } 
    break ;
  case 7 : 
    ;
    break ;
  case 9 : 
    {
      getnext () ;
      p = curtok () ;
      getnext () ;
      if ( curcmd < 11 ) 
      expand () ;
      else backinput () ;
      begintokenlist ( p , 19 ) ;
    } 
    break ;
  case 8 : 
    {
      getxnext () ;
      scanprimary () ;
      if ( curtype != 4 ) 
      {
	disperr ( 0 , 700 ) ;
	{
	  helpptr = 2 ;
	  helpline [1 ]= 701 ;
	  helpline [0 ]= 702 ;
	} 
	putgetflusherror ( 0 ) ;
      } 
      else {
	  
	backinput () ;
	if ( ( strstart [curexp + 1 ]- strstart [curexp ]) > 0 ) 
	{
	  beginfilereading () ;
	  curinput .namefield = 2 ;
	  k = first + ( strstart [curexp + 1 ]- strstart [curexp ]) ;
	  if ( k >= maxbufstack ) 
	  {
	    if ( k >= bufsize ) 
	    {
	      maxbufstack = bufsize ;
	      overflow ( 256 , bufsize ) ;
	    } 
	    maxbufstack = k + 1 ;
	  } 
	  j = strstart [curexp ];
	  curinput .limitfield = k ;
	  while ( first < curinput .limitfield ) {
	      
	    buffer [first ]= strpool [j ];
	    incr ( j ) ;
	    incr ( first ) ;
	  } 
	  buffer [curinput .limitfield ]= 37 ;
	  first = curinput .limitfield + 1 ;
	  curinput .locfield = curinput .startfield ;
	  flushcurexp ( 0 ) ;
	} 
      } 
    } 
    break ;
  case 10 : 
    macrocall ( curmod , 0 , cursym ) ;
    break ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
getxnext ( void ) 
#else
getxnext ( ) 
#endif
{
  halfword saveexp  ;
  getnext () ;
  if ( curcmd < 11 ) 
  {
    saveexp = stashcurexp () ;
    do {
	if ( curcmd == 10 ) 
      macrocall ( curmod , 0 , cursym ) ;
      else expand () ;
      getnext () ;
    } while ( ! ( curcmd >= 11 ) ) ;
    unstashcurexp ( saveexp ) ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
zstackargument ( halfword p ) 
#else
zstackargument ( p ) 
  halfword p ;
#endif
{
  if ( paramptr == maxparamstack ) 
  {
    incr ( maxparamstack ) ;
    if ( maxparamstack > 150 ) 
    overflow ( 687 , 150 ) ;
  } 
  paramstack [paramptr ]= p ;
  incr ( paramptr ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
passtext ( void ) 
#else
passtext ( ) 
#endif
{
  /* 30 */ integer l  ;
  scannerstatus = 1 ;
  l = 0 ;
  warninginfo = line ;
  while ( true ) {
      
    getnext () ;
    if ( curcmd <= 2 ) 
    if ( curcmd < 2 ) 
    incr ( l ) ;
    else {
	
      if ( l == 0 ) 
      goto lab30 ;
      if ( curmod == 2 ) 
      decr ( l ) ;
    } 
    else if ( curcmd == 39 ) 
    {
      if ( strref [curmod ]< 127 ) 
      if ( strref [curmod ]> 1 ) 
      decr ( strref [curmod ]) ;
      else flushstring ( curmod ) ;
    } 
  } 
  lab30: scannerstatus = 0 ;
} 
void 
#ifdef HAVE_PROTOTYPES
zchangeiflimit ( smallnumber l , halfword p ) 
#else
zchangeiflimit ( l , p ) 
  smallnumber l ;
  halfword p ;
#endif
{
  /* 10 */ halfword q  ;
  if ( p == condptr ) 
  iflimit = l ;
  else {
      
    q = condptr ;
    while ( true ) {
	
      if ( q == 0 ) 
      confusion ( 718 ) ;
      if ( mem [q ].hhfield .v.RH == p ) 
      {
	mem [q ].hhfield .b0 = l ;
	goto lab10 ;
      } 
      q = mem [q ].hhfield .v.RH ;
    } 
  } 
  lab10: ;
} 
void 
#ifdef HAVE_PROTOTYPES
checkcolon ( void ) 
#else
checkcolon ( ) 
#endif
{
  if ( curcmd != 81 ) 
  {
    missingerr ( 58 ) ;
    {
      helpptr = 2 ;
      helpline [1 ]= 721 ;
      helpline [0 ]= 698 ;
    } 
    backerror () ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
conditional ( void ) 
#else
conditional ( ) 
#endif
{
  /* 10 30 21 40 */ halfword savecondptr  ;
  char newiflimit  ;
  halfword p  ;
  {
    p = getnode ( 2 ) ;
    mem [p ].hhfield .v.RH = condptr ;
    mem [p ].hhfield .b0 = iflimit ;
    mem [p ].hhfield .b1 = curif ;
    mem [p + 1 ].cint = ifline ;
    condptr = p ;
    iflimit = 1 ;
    ifline = line ;
    curif = 1 ;
  } 
  savecondptr = condptr ;
  lab21: getboolean () ;
  newiflimit = 4 ;
  if ( internal [7 ]> 65536L ) 
  {
    begindiagnostic () ;
    if ( curexp == 30 ) 
    print ( 722 ) ;
    else print ( 723 ) ;
    enddiagnostic ( false ) ;
  } 
  lab40: checkcolon () ;
  if ( curexp == 30 ) 
  {
    changeiflimit ( newiflimit , savecondptr ) ;
    goto lab10 ;
  } 
  while ( true ) {
      
    passtext () ;
    if ( condptr == savecondptr ) 
    goto lab30 ;
    else if ( curmod == 2 ) 
    {
      p = condptr ;
      ifline = mem [p + 1 ].cint ;
      curif = mem [p ].hhfield .b1 ;
      iflimit = mem [p ].hhfield .b0 ;
      condptr = mem [p ].hhfield .v.RH ;
      freenode ( p , 2 ) ;
    } 
  } 
  lab30: curif = curmod ;
  ifline = line ;
  if ( curmod == 2 ) 
  {
    p = condptr ;
    ifline = mem [p + 1 ].cint ;
    curif = mem [p ].hhfield .b1 ;
    iflimit = mem [p ].hhfield .b0 ;
    condptr = mem [p ].hhfield .v.RH ;
    freenode ( p , 2 ) ;
  } 
  else if ( curmod == 4 ) 
  goto lab21 ;
  else {
      
    curexp = 30 ;
    newiflimit = 2 ;
    getxnext () ;
    goto lab40 ;
  } 
  lab10: ;
} 
void 
#ifdef HAVE_PROTOTYPES
zbadfor ( strnumber s ) 
#else
zbadfor ( s ) 
  strnumber s ;
#endif
{
  disperr ( 0 , 726 ) ;
  print ( s ) ;
  print ( 306 ) ;
  {
    helpptr = 4 ;
    helpline [3 ]= 727 ;
    helpline [2 ]= 728 ;
    helpline [1 ]= 729 ;
    helpline [0 ]= 308 ;
  } 
  putgetflusherror ( 0 ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
beginiteration ( void ) 
#else
beginiteration ( ) 
#endif
{
  /* 22 30 40 */ halfword m  ;
  halfword n  ;
  halfword p, q, s, pp  ;
  m = curmod ;
  n = cursym ;
  s = getnode ( 2 ) ;
  if ( m == 1 ) 
  {
    mem [s + 1 ].hhfield .lhfield = 1 ;
    p = 0 ;
    getxnext () ;
    goto lab40 ;
  } 
  getsymbol () ;
  p = getnode ( 2 ) ;
  mem [p ].hhfield .lhfield = cursym ;
  mem [p + 1 ].cint = m ;
  getxnext () ;
  if ( ( curcmd != 51 ) && ( curcmd != 77 ) ) 
  {
    missingerr ( 61 ) ;
    {
      helpptr = 3 ;
      helpline [2 ]= 730 ;
      helpline [1 ]= 673 ;
      helpline [0 ]= 731 ;
    } 
    backerror () ;
  } 
  mem [s + 1 ].hhfield .lhfield = 0 ;
  q = s + 1 ;
  mem [q ].hhfield .v.RH = 0 ;
  do {
      getxnext () ;
    if ( m != 9770 ) 
    scansuffix () ;
    else {
	
      if ( curcmd >= 81 ) 
      if ( curcmd <= 82 ) 
      goto lab22 ;
      scanexpression () ;
      if ( curcmd == 74 ) 
      if ( q == s + 1 ) 
      {
	if ( curtype != 16 ) 
	badfor ( 737 ) ;
	pp = getnode ( 4 ) ;
	mem [pp + 1 ].cint = curexp ;
	getxnext () ;
	scanexpression () ;
	if ( curtype != 16 ) 
	badfor ( 738 ) ;
	mem [pp + 2 ].cint = curexp ;
	if ( curcmd != 75 ) 
	{
	  missingerr ( 490 ) ;
	  {
	    helpptr = 2 ;
	    helpline [1 ]= 739 ;
	    helpline [0 ]= 740 ;
	  } 
	  backerror () ;
	} 
	getxnext () ;
	scanexpression () ;
	if ( curtype != 16 ) 
	badfor ( 741 ) ;
	mem [pp + 3 ].cint = curexp ;
	mem [s + 1 ].hhfield .lhfield = pp ;
	goto lab30 ;
      } 
      curexp = stashcurexp () ;
    } 
    mem [q ].hhfield .v.RH = getavail () ;
    q = mem [q ].hhfield .v.RH ;
    mem [q ].hhfield .lhfield = curexp ;
    curtype = 1 ;
    lab22: ;
  } while ( ! ( curcmd != 82 ) ) ;
  lab30: ;
  lab40: if ( curcmd != 81 ) 
  {
    missingerr ( 58 ) ;
    {
      helpptr = 3 ;
      helpline [2 ]= 732 ;
      helpline [1 ]= 733 ;
      helpline [0 ]= 734 ;
    } 
    backerror () ;
  } 
  q = getavail () ;
  mem [q ].hhfield .lhfield = 9758 ;
  scannerstatus = 6 ;
  warninginfo = n ;
  mem [s ].hhfield .lhfield = scantoks ( 4 , p , q , 0 ) ;
  scannerstatus = 0 ;
  mem [s ].hhfield .v.RH = loopptr ;
  loopptr = s ;
  resumeiteration () ;
} 
void 
#ifdef HAVE_PROTOTYPES
resumeiteration ( void ) 
#else
resumeiteration ( ) 
#endif
{
  /* 45 10 */ halfword p, q  ;
  p = mem [loopptr + 1 ].hhfield .lhfield ;
  if ( p > 1 ) 
  {
    curexp = mem [p + 1 ].cint ;
    if ( ( ( mem [p + 2 ].cint > 0 ) && ( curexp > mem [p + 3 ].cint ) ) 
    || ( ( mem [p + 2 ].cint < 0 ) && ( curexp < mem [p + 3 ].cint ) ) ) 
    goto lab45 ;
    curtype = 16 ;
    q = stashcurexp () ;
    mem [p + 1 ].cint = curexp + mem [p + 2 ].cint ;
  } 
  else if ( p < 1 ) 
  {
    p = mem [loopptr + 1 ].hhfield .v.RH ;
    if ( p == 0 ) 
    goto lab45 ;
    mem [loopptr + 1 ].hhfield .v.RH = mem [p ].hhfield .v.RH ;
    q = mem [p ].hhfield .lhfield ;
    {
      mem [p ].hhfield .v.RH = avail ;
      avail = p ;
	;
#ifdef STAT
      decr ( dynused ) ;
#endif /* STAT */
    } 
  } 
  else {
      
    begintokenlist ( mem [loopptr ].hhfield .lhfield , 16 ) ;
    goto lab10 ;
  } 
  begintokenlist ( mem [loopptr ].hhfield .lhfield , 17 ) ;
  stackargument ( q ) ;
  if ( internal [7 ]> 65536L ) 
  {
    begindiagnostic () ;
    printnl ( 736 ) ;
    if ( ( q != 0 ) && ( mem [q ].hhfield .v.RH == 1 ) ) 
    printexp ( q , 1 ) ;
    else showtokenlist ( q , 0 , 50 , 0 ) ;
    printchar ( 125 ) ;
    enddiagnostic ( false ) ;
  } 
  goto lab10 ;
  lab45: stopiteration () ;
  lab10: ;
} 
void 
#ifdef HAVE_PROTOTYPES
stopiteration ( void ) 
#else
stopiteration ( ) 
#endif
{
  halfword p, q  ;
  p = mem [loopptr + 1 ].hhfield .lhfield ;
  if ( p > 1 ) 
  freenode ( p , 4 ) ;
  else if ( p < 1 ) 
  {
    q = mem [loopptr + 1 ].hhfield .v.RH ;
    while ( q != 0 ) {
	
      p = mem [q ].hhfield .lhfield ;
      if ( p != 0 ) 
      if ( mem [p ].hhfield .v.RH == 1 ) 
      {
	recyclevalue ( p ) ;
	freenode ( p , 2 ) ;
      } 
      else flushtokenlist ( p ) ;
      p = q ;
      q = mem [q ].hhfield .v.RH ;
      {
	mem [p ].hhfield .v.RH = avail ;
	avail = p ;
	;
#ifdef STAT
	decr ( dynused ) ;
#endif /* STAT */
      } 
    } 
  } 
  p = loopptr ;
  loopptr = mem [p ].hhfield .v.RH ;
  flushtokenlist ( mem [p ].hhfield .lhfield ) ;
  freenode ( p , 2 ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
beginname ( void ) 
#else
beginname ( ) 
#endif
{
  areadelimiter = 0 ;
  extdelimiter = 0 ;
  quotedfilename = false ;
} 
boolean 
#ifdef HAVE_PROTOTYPES
zmorename ( ASCIIcode c ) 
#else
zmorename ( c ) 
  ASCIIcode c ;
#endif
{
  register boolean Result; if ( c == 34 ) 
  {
    quotedfilename = ! quotedfilename ;
    Result = true ;
  } 
  else if ( ( ( c == 32 ) || ( c == 9 ) ) && stopatspace && ( ! quotedfilename 
  ) ) 
  Result = false ;
  else {
      
    if ( ISDIRSEP ( c ) ) 
    {
      areadelimiter = poolptr ;
      extdelimiter = 0 ;
    } 
    else if ( c == 46 ) 
    extdelimiter = poolptr ;
    {
      if ( poolptr + 1 > maxpoolptr ) 
      {
	if ( poolptr + 1 > poolsize ) 
	overflow ( 257 , poolsize - initpoolptr ) ;
	maxpoolptr = poolptr + 1 ;
      } 
    } 
    {
      strpool [poolptr ]= c ;
      incr ( poolptr ) ;
    } 
    Result = true ;
  } 
  return Result ;
} 
void 
#ifdef HAVE_PROTOTYPES
endname ( void ) 
#else
endname ( ) 
#endif
{
  boolean mustquote  ;
  poolpointer j, s, t  ;
  if ( strptr + 3 > maxstrptr ) 
  {
    if ( strptr + 3 > maxstrings ) 
    overflow ( 258 , maxstrings - initstrptr ) ;
    maxstrptr = strptr + 3 ;
  } 
  {
    if ( poolptr + 6 > maxpoolptr ) 
    {
      if ( poolptr + 6 > poolsize ) 
      overflow ( 257 , poolsize - initpoolptr ) ;
      maxpoolptr = poolptr + 6 ;
    } 
  } 
  if ( areadelimiter != 0 ) 
  {
    mustquote = false ;
    s = strstart [strptr ];
    t = areadelimiter + 1 ;
    j = s ;
    while ( ( ! mustquote ) && ( j != t ) ) {
	
      mustquote = strpool [j ]== ' ' ;
      incr ( j ) ;
    } 
    if ( mustquote ) 
    {
      {register integer for_end; j = poolptr - 1 ;for_end = t ; if ( j >= 
      for_end) do 
	strpool [j + 2 ]= strpool [j ];
      while ( j-- > for_end ) ;} 
      strpool [t + 1 ]= 34 ;
      {register integer for_end; j = t - 1 ;for_end = s ; if ( j >= for_end) 
      do 
	strpool [j + 1 ]= strpool [j ];
      while ( j-- > for_end ) ;} 
      strpool [s ]= 34 ;
      if ( extdelimiter != 0 ) 
      extdelimiter = extdelimiter + 2 ;
      areadelimiter = areadelimiter + 2 ;
      poolptr = poolptr + 2 ;
    } 
    s = areadelimiter + 1 ;
  } 
  else {
      
    s = strstart [strptr ];
  } 
  if ( extdelimiter == 0 ) 
  t = poolptr ;
  else t = extdelimiter ;
  mustquote = false ;
  j = s ;
  while ( ( ! mustquote ) && ( j != t ) ) {
      
    mustquote = strpool [j ]== 32 ;
    incr ( j ) ;
  } 
  if ( mustquote ) 
  {
    {register integer for_end; j = poolptr - 1 ;for_end = t ; if ( j >= 
    for_end) do 
      strpool [j + 2 ]= strpool [j ];
    while ( j-- > for_end ) ;} 
    strpool [t + 1 ]= 34 ;
    {register integer for_end; j = t - 1 ;for_end = s ; if ( j >= for_end) 
    do 
      strpool [j + 1 ]= strpool [j ];
    while ( j-- > for_end ) ;} 
    strpool [s ]= 34 ;
    if ( extdelimiter != 0 ) 
    extdelimiter = extdelimiter + 2 ;
    poolptr = poolptr + 2 ;
  } 
  if ( extdelimiter != 0 ) 
  {
    s = extdelimiter ;
    t = poolptr ;
    mustquote = false ;
    j = s ;
    while ( ( ! mustquote ) && ( j != t ) ) {
	
      mustquote = strpool [j ]== ' ' ;
      incr ( j ) ;
    } 
    if ( mustquote ) 
    {
      strpool [t + 1 ]= 34 ;
      {register integer for_end; j = t - 1 ;for_end = s ; if ( j >= for_end) 
      do 
	strpool [j + 1 ]= strpool [j ];
      while ( j-- > for_end ) ;} 
      strpool [s ]= 34 ;
      poolptr = poolptr + 2 ;
    } 
  } 
  if ( areadelimiter == 0 ) 
  curarea = 261 ;
  else {
      
    curarea = strptr ;
    incr ( strptr ) ;
    strstart [strptr ]= areadelimiter + 1 ;
  } 
  if ( extdelimiter == 0 ) 
  {
    curext = 261 ;
    curname = makestring () ;
  } 
  else {
      
    curname = strptr ;
    incr ( strptr ) ;
    strstart [strptr ]= extdelimiter ;
    curext = makestring () ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
zpackfilename ( strnumber n , strnumber a , strnumber e ) 
#else
zpackfilename ( n , a , e ) 
  strnumber n ;
  strnumber a ;
  strnumber e ;
#endif
{
  integer k  ;
  ASCIIcode c  ;
  poolpointer j  ;
  k = 0 ;
  if ( nameoffile ) 
  libcfree ( nameoffile ) ;
  nameoffile = xmallocarray ( ASCIIcode , ( strstart [a + 1 ]- strstart [a 
  ]) + ( strstart [n + 1 ]- strstart [n ]) + ( strstart [e + 1 ]- 
  strstart [e ]) + 1 ) ;
  {register integer for_end; j = strstart [a ];for_end = strstart [a + 1 
  ]- 1 ; if ( j <= for_end) do 
    {
      c = strpool [j ];
      if ( ! ( c == 34 ) ) 
      {
	incr ( k ) ;
	if ( k <= maxint ) 
	nameoffile [k ]= xchr [c ];
      } 
    } 
  while ( j++ < for_end ) ;} 
  {register integer for_end; j = strstart [n ];for_end = strstart [n + 1 
  ]- 1 ; if ( j <= for_end) do 
    {
      c = strpool [j ];
      if ( ! ( c == 34 ) ) 
      {
	incr ( k ) ;
	if ( k <= maxint ) 
	nameoffile [k ]= xchr [c ];
      } 
    } 
  while ( j++ < for_end ) ;} 
  {register integer for_end; j = strstart [e ];for_end = strstart [e + 1 
  ]- 1 ; if ( j <= for_end) do 
    {
      c = strpool [j ];
      if ( ! ( c == 34 ) ) 
      {
	incr ( k ) ;
	if ( k <= maxint ) 
	nameoffile [k ]= xchr [c ];
      } 
    } 
  while ( j++ < for_end ) ;} 
  if ( k <= maxint ) 
  namelength = k ;
  else namelength = maxint ;
  nameoffile [namelength + 1 ]= 0 ;
} 
void 
#ifdef HAVE_PROTOTYPES
zpackbufferedname ( smallnumber n , integer a , integer b ) 
#else
zpackbufferedname ( n , a , b ) 
  smallnumber n ;
  integer a ;
  integer b ;
#endif
{
  integer k  ;
  ASCIIcode c  ;
  integer j  ;
  if ( n + b - a + 6 > maxint ) 
  b = a + maxint - n - 6 ;
  k = 0 ;
  if ( nameoffile ) 
  libcfree ( nameoffile ) ;
  nameoffile = xmallocarray ( ASCIIcode , n + ( b - a + 1 ) + 6 ) ;
  {register integer for_end; j = 1 ;for_end = n ; if ( j <= for_end) do 
    {
      c = xord [MFbasedefault [j ]];
      if ( ! ( c == 34 ) ) 
      {
	incr ( k ) ;
	if ( k <= maxint ) 
	nameoffile [k ]= xchr [c ];
      } 
    } 
  while ( j++ < for_end ) ;} 
  {register integer for_end; j = a ;for_end = b ; if ( j <= for_end) do 
    {
      c = buffer [j ];
      if ( ! ( c == 34 ) ) 
      {
	incr ( k ) ;
	if ( k <= maxint ) 
	nameoffile [k ]= xchr [c ];
      } 
    } 
  while ( j++ < for_end ) ;} 
  {register integer for_end; j = basedefaultlength - 4 ;for_end = 
  basedefaultlength ; if ( j <= for_end) do 
    {
      c = xord [MFbasedefault [j ]];
      if ( ! ( c == 34 ) ) 
      {
	incr ( k ) ;
	if ( k <= maxint ) 
	nameoffile [k ]= xchr [c ];
      } 
    } 
  while ( j++ < for_end ) ;} 
  if ( k <= maxint ) 
  namelength = k ;
  else namelength = maxint ;
  nameoffile [namelength + 1 ]= 0 ;
} 
strnumber 
#ifdef HAVE_PROTOTYPES
makenamestring ( void ) 
#else
makenamestring ( ) 
#endif
{
  register strnumber Result; integer k  ;
  if ( ( poolptr + namelength > poolsize ) || ( strptr == maxstrings ) ) 
  Result = 63 ;
  else {
      
    {register integer for_end; k = 1 ;for_end = namelength ; if ( k <= 
    for_end) do 
      {
	strpool [poolptr ]= xord [nameoffile [k ]];
	incr ( poolptr ) ;
      } 
    while ( k++ < for_end ) ;} 
    Result = makestring () ;
  } 
  k = 1 ;
  beginname () ;
  stopatspace = false ;
  while ( ( k <= namelength ) && ( morename ( nameoffile [k ]) ) ) incr ( k 
  ) ;
  stopatspace = true ;
  endname () ;
  return Result ;
} 
strnumber 
#ifdef HAVE_PROTOTYPES
zamakenamestring ( alphafile f ) 
#else
zamakenamestring ( f ) 
  alphafile f ;
#endif
{
  register strnumber Result; Result = makenamestring () ;
  return Result ;
} 
strnumber 
#ifdef HAVE_PROTOTYPES
zbmakenamestring ( bytefile f ) 
#else
zbmakenamestring ( f ) 
  bytefile f ;
#endif
{
  register strnumber Result; Result = makenamestring () ;
  return Result ;
} 
strnumber 
#ifdef HAVE_PROTOTYPES
zwmakenamestring ( wordfile f ) 
#else
zwmakenamestring ( f ) 
  wordfile f ;
#endif
{
  register strnumber Result; Result = makenamestring () ;
  return Result ;
} 
void 
#ifdef HAVE_PROTOTYPES
scanfilename ( void ) 
#else
scanfilename ( ) 
#endif
{
  /* 30 */ beginname () ;
  while ( ( buffer [curinput .locfield ]== 32 ) || ( buffer [curinput 
  .locfield ]== 9 ) ) incr ( curinput .locfield ) ;
  while ( true ) {
      
    if ( ( buffer [curinput .locfield ]== 59 ) || ( buffer [curinput 
    .locfield ]== 37 ) ) 
    goto lab30 ;
    if ( ! morename ( buffer [curinput .locfield ]) ) 
    goto lab30 ;
    incr ( curinput .locfield ) ;
  } 
  lab30: endname () ;
} 
void 
#ifdef HAVE_PROTOTYPES
zpackjobname ( strnumber s ) 
#else
zpackjobname ( s ) 
  strnumber s ;
#endif
{
  curarea = 261 ;
  curext = s ;
  curname = jobname ;
  packfilename ( curname , curarea , curext ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
zpromptfilename ( strnumber s , strnumber e ) 
#else
zpromptfilename ( s , e ) 
  strnumber s ;
  strnumber e ;
#endif
{
  /* 30 */ integer k  ;
  strnumber savedcurname  ;
  if ( interaction == 2 ) 
  ;
  if ( s == 743 ) 
  {
    if ( interaction == 3 ) 
    ;
    if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
    {
      printnl ( 261 ) ;
      print ( fullsourcefilenamestack [inopen ]) ;
      print ( 58 ) ;
      printint ( line ) ;
      print ( 262 ) ;
      print ( 744 ) ;
    } 
    else {
	
      printnl ( 263 ) ;
      print ( 744 ) ;
    } 
  } 
  else {
      
    if ( interaction == 3 ) 
    ;
    if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
    {
      printnl ( 261 ) ;
      print ( fullsourcefilenamestack [inopen ]) ;
      print ( 58 ) ;
      printint ( line ) ;
      print ( 262 ) ;
      print ( 745 ) ;
    } 
    else {
	
      printnl ( 263 ) ;
      print ( 745 ) ;
    } 
  } 
  printfilename ( curname , curarea , curext ) ;
  print ( 746 ) ;
  if ( e == 747 ) 
  showcontext () ;
  printnl ( 748 ) ;
  print ( s ) ;
  if ( interaction < 2 ) 
  fatalerror ( 749 ) ;
  savedcurname = curname ;
  {
    ;
    print ( 262 ) ;
    terminput () ;
  } 
  {
    beginname () ;
    k = first ;
    while ( ( ( buffer [k ]== 32 ) || ( buffer [k ]== 9 ) ) && ( k < last 
    ) ) incr ( k ) ;
    while ( true ) {
	
      if ( k == last ) 
      goto lab30 ;
      if ( ! morename ( buffer [k ]) ) 
      goto lab30 ;
      incr ( k ) ;
    } 
    lab30: endname () ;
  } 
  if ( curext == 261 ) 
  curext = e ;
  if ( ( strstart [curname + 1 ]- strstart [curname ]) == 0 ) 
  curname = savedcurname ;
  packfilename ( curname , curarea , curext ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
openlogfile ( void ) 
#else
openlogfile ( ) 
#endif
{
  char oldsetting  ;
  integer k  ;
  integer l  ;
  integer m  ;
  char * months  ;
  oldsetting = selector ;
  if ( jobname == 0 ) 
  jobname = getjobname ( 750 ) ;
  packjobname ( 751 ) ;
  recorderchangefilename ( stringcast ( nameoffile + 1 ) ) ;
  packjobname ( 752 ) ;
  while ( ! aopenout ( logfile ) ) {
      
    selector = 1 ;
    promptfilename ( 754 , 752 ) ;
  } 
  texmflogname = amakenamestring ( logfile ) ;
  selector = 2 ;
  logopened = true ;
  {
    Fputs ( logfile ,  "This is METAFONT, Version 2.718281" ) ;
    Fputs ( logfile ,  versionstring ) ;
    slowprint ( baseident ) ;
    print ( 755 ) ;
    printint ( roundunscaled ( internal [16 ]) ) ;
    printchar ( 32 ) ;
    months = " JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC" ;
    m = roundunscaled ( internal [15 ]) ;
    {register integer for_end; k = 3 * m - 2 ;for_end = 3 * m ; if ( k <= 
    for_end) do 
      putc ( months [k ],  logfile );
    while ( k++ < for_end ) ;} 
    printchar ( 32 ) ;
    printint ( roundunscaled ( internal [14 ]) ) ;
    printchar ( 32 ) ;
    m = roundunscaled ( internal [17 ]) ;
    printdd ( m / 60 ) ;
    printchar ( 58 ) ;
    printdd ( m % 60 ) ;
    if ( translatefilename ) 
    {
      putc ('\n',  logfile );
      putc ( '(' ,  logfile );
      fputs ( translatefilename , logfile ) ;
      putc ( ')' ,  logfile );
    } 
  } 
  inputstack [inputptr ]= curinput ;
  printnl ( 753 ) ;
  l = inputstack [0 ].limitfield - 1 ;
  {register integer for_end; k = 1 ;for_end = l ; if ( k <= for_end) do 
    print ( buffer [k ]) ;
  while ( k++ < for_end ) ;} 
  println () ;
  selector = oldsetting + 2 ;
} 
void 
#ifdef HAVE_PROTOTYPES
startinput ( void ) 
#else
startinput ( ) 
#endif
{
  /* 30 */ strnumber tempstr  ;
  integer k  ;
  while ( ( curinput .indexfield > 15 ) && ( curinput .locfield == 0 ) ) 
  endtokenlist () ;
  if ( ( curinput .indexfield > 15 ) ) 
  {
    {
      if ( interaction == 3 ) 
      ;
      if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
      {
	printnl ( 261 ) ;
	print ( fullsourcefilenamestack [inopen ]) ;
	print ( 58 ) ;
	printint ( line ) ;
	print ( 262 ) ;
	print ( 757 ) ;
      } 
      else {
	  
	printnl ( 263 ) ;
	print ( 757 ) ;
      } 
    } 
    {
      helpptr = 3 ;
      helpline [2 ]= 758 ;
      helpline [1 ]= 759 ;
      helpline [0 ]= 760 ;
    } 
    error () ;
  } 
  if ( ( curinput .indexfield <= 15 ) ) 
  scanfilename () ;
  else {
      
    curname = 261 ;
    curext = 261 ;
    curarea = 261 ;
  } 
  packfilename ( curname , curarea , curext ) ;
  while ( true ) {
      
    beginfilereading () ;
    if ( curext == 747 ) 
    {
      curext = 261 ;
      packfilename ( curname , curarea , curext ) ;
    } 
    if ( openinnameok ( stringcast ( nameoffile + 1 ) ) && aopenin ( inputfile 
    [curinput .indexfield ], kpsemfformat ) ) 
    goto lab30 ;
    endfilereading () ;
    promptfilename ( 743 , 747 ) ;
  } 
  lab30: curinput .namefield = amakenamestring ( inputfile [curinput 
  .indexfield ]) ;
  strref [curname ]= 127 ;
  if ( jobname == 0 ) 
  {
    jobname = getjobname ( curname ) ;
    openlogfile () ;
  } 
  if ( termoffset + ( strstart [curinput .namefield + 1 ]- strstart [
  curinput .namefield ]) > maxprintline - 2 ) 
  println () ;
  else if ( ( termoffset > 0 ) || ( fileoffset > 0 ) ) 
  printchar ( 32 ) ;
  printchar ( 40 ) ;
  incr ( openparens ) ;
  slowprint ( curinput .namefield ) ;
  fflush ( stdout ) ;
  {
    line = 1 ;
    if ( inputln ( inputfile [curinput .indexfield ], false ) ) 
    ;
    firmuptheline () ;
    buffer [curinput .limitfield ]= 37 ;
    first = curinput .limitfield + 1 ;
    curinput .locfield = curinput .startfield ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
zbadexp ( strnumber s ) 
#else
zbadexp ( s ) 
  strnumber s ;
#endif
{
  char saveflag  ;
  {
    if ( interaction == 3 ) 
    ;
    if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
    {
      printnl ( 261 ) ;
      print ( fullsourcefilenamestack [inopen ]) ;
      print ( 58 ) ;
      printint ( line ) ;
      print ( 262 ) ;
      print ( s ) ;
    } 
    else {
	
      printnl ( 263 ) ;
      print ( s ) ;
    } 
  } 
  print ( 770 ) ;
  printcmdmod ( curcmd , curmod ) ;
  printchar ( 39 ) ;
  {
    helpptr = 4 ;
    helpline [3 ]= 771 ;
    helpline [2 ]= 772 ;
    helpline [1 ]= 773 ;
    helpline [0 ]= 774 ;
  } 
  backinput () ;
  cursym = 0 ;
  curcmd = 42 ;
  curmod = 0 ;
  inserror () ;
  saveflag = varflag ;
  varflag = 0 ;
  getxnext () ;
  varflag = saveflag ;
} 
void 
#ifdef HAVE_PROTOTYPES
zstashin ( halfword p ) 
#else
zstashin ( p ) 
  halfword p ;
#endif
{
  halfword q  ;
  mem [p ].hhfield .b0 = curtype ;
  if ( curtype == 16 ) 
  mem [p + 1 ].cint = curexp ;
  else {
      
    if ( curtype == 19 ) 
    {
      q = singledependency ( curexp ) ;
      if ( q == depfinal ) 
      {
	mem [p ].hhfield .b0 = 16 ;
	mem [p + 1 ].cint = 0 ;
	freenode ( q , 2 ) ;
      } 
      else {
	  
	mem [p ].hhfield .b0 = 17 ;
	newdep ( p , q ) ;
      } 
      recyclevalue ( curexp ) ;
    } 
    else {
	
      mem [p + 1 ]= mem [curexp + 1 ];
      mem [mem [p + 1 ].hhfield .lhfield ].hhfield .v.RH = p ;
    } 
    freenode ( curexp , 2 ) ;
  } 
  curtype = 1 ;
} 
void 
#ifdef HAVE_PROTOTYPES
backexpr ( void ) 
#else
backexpr ( ) 
#endif
{
  halfword p  ;
  p = stashcurexp () ;
  mem [p ].hhfield .v.RH = 0 ;
  begintokenlist ( p , 19 ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
badsubscript ( void ) 
#else
badsubscript ( ) 
#endif
{
  disperr ( 0 , 786 ) ;
  {
    helpptr = 3 ;
    helpline [2 ]= 787 ;
    helpline [1 ]= 788 ;
    helpline [0 ]= 789 ;
  } 
  flusherror ( 0 ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
zobliterated ( halfword q ) 
#else
zobliterated ( q ) 
  halfword q ;
#endif
{
  {
    if ( interaction == 3 ) 
    ;
    if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
    {
      printnl ( 261 ) ;
      print ( fullsourcefilenamestack [inopen ]) ;
      print ( 58 ) ;
      printint ( line ) ;
      print ( 262 ) ;
      print ( 790 ) ;
    } 
    else {
	
      printnl ( 263 ) ;
      print ( 790 ) ;
    } 
  } 
  showtokenlist ( q , 0 , 1000 , 0 ) ;
  print ( 791 ) ;
  {
    helpptr = 5 ;
    helpline [4 ]= 792 ;
    helpline [3 ]= 793 ;
    helpline [2 ]= 794 ;
    helpline [1 ]= 795 ;
    helpline [0 ]= 796 ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
zbinarymac ( halfword p , halfword c , halfword n ) 
#else
zbinarymac ( p , c , n ) 
  halfword p ;
  halfword c ;
  halfword n ;
#endif
{
  halfword q, r  ;
  q = getavail () ;
  r = getavail () ;
  mem [q ].hhfield .v.RH = r ;
  mem [q ].hhfield .lhfield = p ;
  mem [r ].hhfield .lhfield = stashcurexp () ;
  macrocall ( c , q , n ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
materializepen ( void ) 
#else
materializepen ( ) 
#endif
{
  /* 50 */ scaled aminusb, aplusb, majoraxis, minoraxis  ;
  angle theta  ;
  halfword p  ;
  halfword q  ;
  q = curexp ;
  if ( mem [q ].hhfield .b0 == 0 ) 
  {
    {
      if ( interaction == 3 ) 
      ;
      if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
      {
	printnl ( 261 ) ;
	print ( fullsourcefilenamestack [inopen ]) ;
	print ( 58 ) ;
	printint ( line ) ;
	print ( 262 ) ;
	print ( 806 ) ;
      } 
      else {
	  
	printnl ( 263 ) ;
	print ( 806 ) ;
      } 
    } 
    {
      helpptr = 2 ;
      helpline [1 ]= 807 ;
      helpline [0 ]= 575 ;
    } 
    putgeterror () ;
    curexp = 3 ;
    goto lab50 ;
  } 
  else if ( mem [q ].hhfield .b0 == 4 ) 
  {
    tx = mem [q + 1 ].cint ;
    ty = mem [q + 2 ].cint ;
    txx = mem [q + 3 ].cint - tx ;
    tyx = mem [q + 4 ].cint - ty ;
    txy = mem [q + 5 ].cint - tx ;
    tyy = mem [q + 6 ].cint - ty ;
    aminusb = pythadd ( txx - tyy , tyx + txy ) ;
    aplusb = pythadd ( txx + tyy , tyx - txy ) ;
    majoraxis = halfp ( aminusb + aplusb ) ;
    minoraxis = halfp ( abs ( aplusb - aminusb ) ) ;
    if ( majoraxis == minoraxis ) 
    theta = 0 ;
    else theta = half ( narg ( txx - tyy , tyx + txy ) + narg ( txx + tyy , 
    tyx - txy ) ) ;
    freenode ( q , 7 ) ;
    q = makeellipse ( majoraxis , minoraxis , theta ) ;
    if ( ( tx != 0 ) || ( ty != 0 ) ) 
    {
      p = q ;
      do {
	  mem [p + 1 ].cint = mem [p + 1 ].cint + tx ;
	mem [p + 2 ].cint = mem [p + 2 ].cint + ty ;
	p = mem [p ].hhfield .v.RH ;
      } while ( ! ( p == q ) ) ;
    } 
  } 
  curexp = makepen ( q ) ;
  lab50: tossknotlist ( q ) ;
  curtype = 6 ;
} 
void 
#ifdef HAVE_PROTOTYPES
knownpair ( void ) 
#else
knownpair ( ) 
#endif
{
  halfword p  ;
  if ( curtype != 14 ) 
  {
    disperr ( 0 , 809 ) ;
    {
      helpptr = 5 ;
      helpline [4 ]= 810 ;
      helpline [3 ]= 811 ;
      helpline [2 ]= 812 ;
      helpline [1 ]= 813 ;
      helpline [0 ]= 814 ;
    } 
    putgetflusherror ( 0 ) ;
    curx = 0 ;
    cury = 0 ;
  } 
  else {
      
    p = mem [curexp + 1 ].cint ;
    if ( mem [p ].hhfield .b0 == 16 ) 
    curx = mem [p + 1 ].cint ;
    else {
	
      disperr ( p , 815 ) ;
      {
	helpptr = 5 ;
	helpline [4 ]= 816 ;
	helpline [3 ]= 811 ;
	helpline [2 ]= 812 ;
	helpline [1 ]= 813 ;
	helpline [0 ]= 814 ;
      } 
      putgeterror () ;
      recyclevalue ( p ) ;
      curx = 0 ;
    } 
    if ( mem [p + 2 ].hhfield .b0 == 16 ) 
    cury = mem [p + 3 ].cint ;
    else {
	
      disperr ( p + 2 , 817 ) ;
      {
	helpptr = 5 ;
	helpline [4 ]= 818 ;
	helpline [3 ]= 811 ;
	helpline [2 ]= 812 ;
	helpline [1 ]= 813 ;
	helpline [0 ]= 814 ;
      } 
      putgeterror () ;
      recyclevalue ( p + 2 ) ;
      cury = 0 ;
    } 
    flushcurexp ( 0 ) ;
  } 
} 
halfword 
#ifdef HAVE_PROTOTYPES
newknot ( void ) 
#else
newknot ( ) 
#endif
{
  register halfword Result; halfword q  ;
  q = getnode ( 7 ) ;
  mem [q ].hhfield .b0 = 0 ;
  mem [q ].hhfield .b1 = 0 ;
  mem [q ].hhfield .v.RH = q ;
  knownpair () ;
  mem [q + 1 ].cint = curx ;
  mem [q + 2 ].cint = cury ;
  Result = q ;
  return Result ;
} 
smallnumber 
#ifdef HAVE_PROTOTYPES
scandirection ( void ) 
#else
scandirection ( ) 
#endif
{
  register smallnumber Result; char t  ;
  scaled x  ;
  getxnext () ;
  if ( curcmd == 60 ) 
  {
    getxnext () ;
    scanexpression () ;
    if ( ( curtype != 16 ) || ( curexp < 0 ) ) 
    {
      disperr ( 0 , 821 ) ;
      {
	helpptr = 1 ;
	helpline [0 ]= 822 ;
      } 
      putgetflusherror ( 65536L ) ;
    } 
    t = 3 ;
  } 
  else {
      
    scanexpression () ;
    if ( curtype > 14 ) 
    {
      if ( curtype != 16 ) 
      {
	disperr ( 0 , 815 ) ;
	{
	  helpptr = 5 ;
	  helpline [4 ]= 816 ;
	  helpline [3 ]= 811 ;
	  helpline [2 ]= 812 ;
	  helpline [1 ]= 813 ;
	  helpline [0 ]= 814 ;
	} 
	putgetflusherror ( 0 ) ;
      } 
      x = curexp ;
      if ( curcmd != 82 ) 
      {
	missingerr ( 44 ) ;
	{
	  helpptr = 2 ;
	  helpline [1 ]= 823 ;
	  helpline [0 ]= 824 ;
	} 
	backerror () ;
      } 
      getxnext () ;
      scanexpression () ;
      if ( curtype != 16 ) 
      {
	disperr ( 0 , 817 ) ;
	{
	  helpptr = 5 ;
	  helpline [4 ]= 818 ;
	  helpline [3 ]= 811 ;
	  helpline [2 ]= 812 ;
	  helpline [1 ]= 813 ;
	  helpline [0 ]= 814 ;
	} 
	putgetflusherror ( 0 ) ;
      } 
      cury = curexp ;
      curx = x ;
    } 
    else knownpair () ;
    if ( ( curx == 0 ) && ( cury == 0 ) ) 
    t = 4 ;
    else {
	
      t = 2 ;
      curexp = narg ( curx , cury ) ;
    } 
  } 
  if ( curcmd != 65 ) 
  {
    missingerr ( 125 ) ;
    {
      helpptr = 3 ;
      helpline [2 ]= 819 ;
      helpline [1 ]= 820 ;
      helpline [0 ]= 698 ;
    } 
    backerror () ;
  } 
  getxnext () ;
  Result = t ;
  return Result ;
} 
void 
#ifdef HAVE_PROTOTYPES
zdonullary ( quarterword c ) 
#else
zdonullary ( c ) 
  quarterword c ;
#endif
{
  integer k  ;
  {
    if ( aritherror ) 
    cleararith () ;
  } 
  if ( internal [7 ]> 131072L ) 
  showcmdmod ( 33 , c ) ;
  switch ( c ) 
  {case 30 : 
  case 31 : 
    {
      curtype = 2 ;
      curexp = c ;
    } 
    break ;
  case 32 : 
    {
      curtype = 11 ;
      curexp = getnode ( 6 ) ;
      initedges ( curexp ) ;
    } 
    break ;
  case 33 : 
    {
      curtype = 6 ;
      curexp = 3 ;
    } 
    break ;
  case 37 : 
    {
      curtype = 16 ;
      curexp = normrand () ;
    } 
    break ;
  case 36 : 
    {
      curtype = 8 ;
      curexp = getnode ( 7 ) ;
      mem [curexp ].hhfield .b0 = 4 ;
      mem [curexp ].hhfield .b1 = 4 ;
      mem [curexp ].hhfield .v.RH = curexp ;
      mem [curexp + 1 ].cint = 0 ;
      mem [curexp + 2 ].cint = 0 ;
      mem [curexp + 3 ].cint = 65536L ;
      mem [curexp + 4 ].cint = 0 ;
      mem [curexp + 5 ].cint = 0 ;
      mem [curexp + 6 ].cint = 65536L ;
    } 
    break ;
  case 34 : 
    {
      if ( jobname == 0 ) 
      openlogfile () ;
      curtype = 4 ;
      curexp = jobname ;
    } 
    break ;
  case 35 : 
    {
      if ( interaction <= 1 ) 
      fatalerror ( 835 ) ;
      beginfilereading () ;
      curinput .namefield = 1 ;
      {
	;
	print ( 261 ) ;
	terminput () ;
      } 
      {
	if ( poolptr + last - curinput .startfield > maxpoolptr ) 
	{
	  if ( poolptr + last - curinput .startfield > poolsize ) 
	  overflow ( 257 , poolsize - initpoolptr ) ;
	  maxpoolptr = poolptr + last - curinput .startfield ;
	} 
      } 
      {register integer for_end; k = curinput .startfield ;for_end = last - 
      1 ; if ( k <= for_end) do 
	{
	  strpool [poolptr ]= buffer [k ];
	  incr ( poolptr ) ;
	} 
      while ( k++ < for_end ) ;} 
      endfilereading () ;
      curtype = 4 ;
      curexp = makestring () ;
    } 
    break ;
  } 
  {
    if ( aritherror ) 
    cleararith () ;
  } 
} 
boolean 
#ifdef HAVE_PROTOTYPES
znicepair ( integer p , quarterword t ) 
#else
znicepair ( p , t ) 
  integer p ;
  quarterword t ;
#endif
{
  /* 10 */ register boolean Result; if ( t == 14 ) 
  {
    p = mem [p + 1 ].cint ;
    if ( mem [p ].hhfield .b0 == 16 ) 
    if ( mem [p + 2 ].hhfield .b0 == 16 ) 
    {
      Result = true ;
      goto lab10 ;
    } 
  } 
  Result = false ;
  lab10: ;
  return Result ;
} 
void 
#ifdef HAVE_PROTOTYPES
zprintknownorunknowntype ( smallnumber t , integer v ) 
#else
zprintknownorunknowntype ( t , v ) 
  smallnumber t ;
  integer v ;
#endif
{
  printchar ( 40 ) ;
  if ( t < 17 ) 
  if ( t != 14 ) 
  printtype ( t ) ;
  else if ( nicepair ( v , 14 ) ) 
  print ( 336 ) ;
  else print ( 836 ) ;
  else print ( 837 ) ;
  printchar ( 41 ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
zbadunary ( quarterword c ) 
#else
zbadunary ( c ) 
  quarterword c ;
#endif
{
  disperr ( 0 , 838 ) ;
  printop ( c ) ;
  printknownorunknowntype ( curtype , curexp ) ;
  {
    helpptr = 3 ;
    helpline [2 ]= 839 ;
    helpline [1 ]= 840 ;
    helpline [0 ]= 841 ;
  } 
  putgeterror () ;
} 
void 
#ifdef HAVE_PROTOTYPES
znegatedeplist ( halfword p ) 
#else
znegatedeplist ( p ) 
  halfword p ;
#endif
{
  /* 10 */ while ( true ) {
      
    mem [p + 1 ].cint = - (integer) mem [p + 1 ].cint ;
    if ( mem [p ].hhfield .lhfield == 0 ) 
    goto lab10 ;
    p = mem [p ].hhfield .v.RH ;
  } 
  lab10: ;
} 
void 
#ifdef HAVE_PROTOTYPES
pairtopath ( void ) 
#else
pairtopath ( ) 
#endif
{
  curexp = newknot () ;
  curtype = 9 ;
} 
void 
#ifdef HAVE_PROTOTYPES
ztakepart ( quarterword c ) 
#else
ztakepart ( c ) 
  quarterword c ;
#endif
{
  halfword p  ;
  p = mem [curexp + 1 ].cint ;
  mem [18 ].cint = p ;
  mem [17 ].hhfield .b0 = curtype ;
  mem [p ].hhfield .v.RH = 17 ;
  freenode ( curexp , 2 ) ;
  makeexpcopy ( p + 2 * ( c - 53 ) ) ;
  recyclevalue ( 17 ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
zstrtonum ( quarterword c ) 
#else
zstrtonum ( c ) 
  quarterword c ;
#endif
{
  integer n  ;
  ASCIIcode m  ;
  poolpointer k  ;
  char b  ;
  boolean badchar  ;
  if ( c == 49 ) 
  if ( ( strstart [curexp + 1 ]- strstart [curexp ]) == 0 ) 
  n = -1 ;
  else n = strpool [strstart [curexp ]];
  else {
      
    if ( c == 47 ) 
    b = 8 ;
    else b = 16 ;
    n = 0 ;
    badchar = false ;
    {register integer for_end; k = strstart [curexp ];for_end = strstart [
    curexp + 1 ]- 1 ; if ( k <= for_end) do 
      {
	m = strpool [k ];
	if ( ( m >= 48 ) && ( m <= 57 ) ) 
	m = m - 48 ;
	else if ( ( m >= 65 ) && ( m <= 70 ) ) 
	m = m - 55 ;
	else if ( ( m >= 97 ) && ( m <= 102 ) ) 
	m = m - 87 ;
	else {
	    
	  badchar = true ;
	  m = 0 ;
	} 
	if ( m >= b ) 
	{
	  badchar = true ;
	  m = 0 ;
	} 
	if ( n < 32768L / b ) 
	n = n * b + m ;
	else n = 32767 ;
      } 
    while ( k++ < for_end ) ;} 
    if ( badchar ) 
    {
      disperr ( 0 , 843 ) ;
      if ( c == 47 ) 
      {
	helpptr = 1 ;
	helpline [0 ]= 844 ;
      } 
      else {
	  
	helpptr = 1 ;
	helpline [0 ]= 845 ;
      } 
      putgeterror () ;
    } 
    if ( n > 4095 ) 
    {
      {
	if ( interaction == 3 ) 
	;
	if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	{
	  printnl ( 261 ) ;
	  print ( fullsourcefilenamestack [inopen ]) ;
	  print ( 58 ) ;
	  printint ( line ) ;
	  print ( 262 ) ;
	  print ( 846 ) ;
	} 
	else {
	    
	  printnl ( 263 ) ;
	  print ( 846 ) ;
	} 
      } 
      printint ( n ) ;
      printchar ( 41 ) ;
      {
	helpptr = 1 ;
	helpline [0 ]= 847 ;
      } 
      putgeterror () ;
    } 
  } 
  flushcurexp ( n * 65536L ) ;
} 
scaled 
#ifdef HAVE_PROTOTYPES
pathlength ( void ) 
#else
pathlength ( ) 
#endif
{
  register scaled Result; scaled n  ;
  halfword p  ;
  p = curexp ;
  if ( mem [p ].hhfield .b0 == 0 ) 
  n = -65536L ;
  else n = 0 ;
  do {
      p = mem [p ].hhfield .v.RH ;
    n = n + 65536L ;
  } while ( ! ( p == curexp ) ) ;
  Result = n ;
  return Result ;
} 
void 
#ifdef HAVE_PROTOTYPES
ztestknown ( quarterword c ) 
#else
ztestknown ( c ) 
  quarterword c ;
#endif
{
  /* 30 */ char b  ;
  halfword p, q  ;
  b = 31 ;
  switch ( curtype ) 
  {case 1 : 
  case 2 : 
  case 4 : 
  case 6 : 
  case 8 : 
  case 9 : 
  case 11 : 
  case 16 : 
    b = 30 ;
    break ;
  case 13 : 
  case 14 : 
    {
      p = mem [curexp + 1 ].cint ;
      q = p + bignodesize [curtype ];
      do {
	  q = q - 2 ;
	if ( mem [q ].hhfield .b0 != 16 ) 
	goto lab30 ;
      } while ( ! ( q == p ) ) ;
      b = 30 ;
      lab30: ;
    } 
    break ;
    default: 
    ;
    break ;
  } 
  if ( c == 39 ) 
  flushcurexp ( b ) ;
  else flushcurexp ( 61 - b ) ;
  curtype = 2 ;
} 
void 
#ifdef HAVE_PROTOTYPES
zdounary ( quarterword c ) 
#else
zdounary ( c ) 
  quarterword c ;
#endif
{
  halfword p, q  ;
  integer x  ;
  {
    if ( aritherror ) 
    cleararith () ;
  } 
  if ( internal [7 ]> 131072L ) 
  {
    begindiagnostic () ;
    printnl ( 123 ) ;
    printop ( c ) ;
    printchar ( 40 ) ;
    printexp ( 0 , 0 ) ;
    print ( 842 ) ;
    enddiagnostic ( false ) ;
  } 
  switch ( c ) 
  {case 69 : 
    if ( curtype < 14 ) 
    if ( curtype != 11 ) 
    badunary ( 69 ) ;
    break ;
  case 70 : 
    switch ( curtype ) 
    {case 14 : 
    case 19 : 
      {
	q = curexp ;
	makeexpcopy ( q ) ;
	if ( curtype == 17 ) 
	negatedeplist ( mem [curexp + 1 ].hhfield .v.RH ) ;
	else if ( curtype == 14 ) 
	{
	  p = mem [curexp + 1 ].cint ;
	  if ( mem [p ].hhfield .b0 == 16 ) 
	  mem [p + 1 ].cint = - (integer) mem [p + 1 ].cint ;
	  else negatedeplist ( mem [p + 1 ].hhfield .v.RH ) ;
	  if ( mem [p + 2 ].hhfield .b0 == 16 ) 
	  mem [p + 3 ].cint = - (integer) mem [p + 3 ].cint ;
	  else negatedeplist ( mem [p + 3 ].hhfield .v.RH ) ;
	} 
	recyclevalue ( q ) ;
	freenode ( q , 2 ) ;
      } 
      break ;
    case 17 : 
    case 18 : 
      negatedeplist ( mem [curexp + 1 ].hhfield .v.RH ) ;
      break ;
    case 16 : 
      curexp = - (integer) curexp ;
      break ;
    case 11 : 
      negateedges ( curexp ) ;
      break ;
      default: 
      badunary ( 70 ) ;
      break ;
    } 
    break ;
  case 41 : 
    if ( curtype != 2 ) 
    badunary ( 41 ) ;
    else curexp = 61 - curexp ;
    break ;
  case 59 : 
  case 60 : 
  case 61 : 
  case 62 : 
  case 63 : 
  case 64 : 
  case 65 : 
  case 38 : 
  case 66 : 
    if ( curtype != 16 ) 
    badunary ( c ) ;
    else switch ( c ) 
    {case 59 : 
      curexp = squarert ( curexp ) ;
      break ;
    case 60 : 
      curexp = mexp ( curexp ) ;
      break ;
    case 61 : 
      curexp = mlog ( curexp ) ;
      break ;
    case 62 : 
    case 63 : 
      {
	nsincos ( ( curexp % 23592960L ) * 16 ) ;
	if ( c == 62 ) 
	curexp = roundfraction ( nsin ) ;
	else curexp = roundfraction ( ncos ) ;
      } 
      break ;
    case 64 : 
      curexp = floorscaled ( curexp ) ;
      break ;
    case 65 : 
      curexp = unifrand ( curexp ) ;
      break ;
    case 38 : 
      {
	if ( odd ( roundunscaled ( curexp ) ) ) 
	curexp = 30 ;
	else curexp = 31 ;
	curtype = 2 ;
      } 
      break ;
    case 66 : 
      {
	curexp = roundunscaled ( curexp ) % 256 ;
	if ( curexp < 0 ) 
	curexp = curexp + 256 ;
	if ( charexists [curexp ]) 
	curexp = 30 ;
	else curexp = 31 ;
	curtype = 2 ;
      } 
      break ;
    } 
    break ;
  case 67 : 
    if ( nicepair ( curexp , curtype ) ) 
    {
      p = mem [curexp + 1 ].cint ;
      x = narg ( mem [p + 1 ].cint , mem [p + 3 ].cint ) ;
      if ( x >= 0 ) 
      flushcurexp ( ( x + 8 ) / 16 ) ;
      else flushcurexp ( - (integer) ( ( - (integer) x + 8 ) / 16 ) ) ;
    } 
    else badunary ( 67 ) ;
    break ;
  case 53 : 
  case 54 : 
    if ( ( curtype <= 14 ) && ( curtype >= 13 ) ) 
    takepart ( c ) ;
    else badunary ( c ) ;
    break ;
  case 55 : 
  case 56 : 
  case 57 : 
  case 58 : 
    if ( curtype == 13 ) 
    takepart ( c ) ;
    else badunary ( c ) ;
    break ;
  case 50 : 
    if ( curtype != 16 ) 
    badunary ( 50 ) ;
    else {
	
      curexp = roundunscaled ( curexp ) % 256 ;
      curtype = 4 ;
      if ( curexp < 0 ) 
      curexp = curexp + 256 ;
      if ( ( strstart [curexp + 1 ]- strstart [curexp ]) != 1 ) 
      {
	{
	  if ( poolptr + 1 > maxpoolptr ) 
	  {
	    if ( poolptr + 1 > poolsize ) 
	    overflow ( 257 , poolsize - initpoolptr ) ;
	    maxpoolptr = poolptr + 1 ;
	  } 
	} 
	{
	  strpool [poolptr ]= curexp ;
	  incr ( poolptr ) ;
	} 
	curexp = makestring () ;
      } 
    } 
    break ;
  case 42 : 
    if ( curtype != 16 ) 
    badunary ( 42 ) ;
    else {
	
      oldsetting = selector ;
      selector = 5 ;
      printscaled ( curexp ) ;
      curexp = makestring () ;
      selector = oldsetting ;
      curtype = 4 ;
    } 
    break ;
  case 47 : 
  case 48 : 
  case 49 : 
    if ( curtype != 4 ) 
    badunary ( c ) ;
    else strtonum ( c ) ;
    break ;
  case 51 : 
    if ( curtype == 4 ) 
    flushcurexp ( ( strstart [curexp + 1 ]- strstart [curexp ]) * 65536L ) 
    ;
    else if ( curtype == 9 ) 
    flushcurexp ( pathlength () ) ;
    else if ( curtype == 16 ) 
    curexp = abs ( curexp ) ;
    else if ( nicepair ( curexp , curtype ) ) 
    flushcurexp ( pythadd ( mem [mem [curexp + 1 ].cint + 1 ].cint , mem [
    mem [curexp + 1 ].cint + 3 ].cint ) ) ;
    else badunary ( c ) ;
    break ;
  case 52 : 
    if ( curtype == 14 ) 
    flushcurexp ( 0 ) ;
    else if ( curtype != 9 ) 
    badunary ( 52 ) ;
    else if ( mem [curexp ].hhfield .b0 == 0 ) 
    flushcurexp ( 0 ) ;
    else {
	
      curpen = 3 ;
      curpathtype = 1 ;
      curexp = makespec ( curexp , -1879080960L , 0 ) ;
      flushcurexp ( turningnumber * 65536L ) ;
    } 
    break ;
  case 2 : 
    {
      if ( ( curtype >= 2 ) && ( curtype <= 3 ) ) 
      flushcurexp ( 30 ) ;
      else flushcurexp ( 31 ) ;
      curtype = 2 ;
    } 
    break ;
  case 4 : 
    {
      if ( ( curtype >= 4 ) && ( curtype <= 5 ) ) 
      flushcurexp ( 30 ) ;
      else flushcurexp ( 31 ) ;
      curtype = 2 ;
    } 
    break ;
  case 6 : 
    {
      if ( ( curtype >= 6 ) && ( curtype <= 8 ) ) 
      flushcurexp ( 30 ) ;
      else flushcurexp ( 31 ) ;
      curtype = 2 ;
    } 
    break ;
  case 9 : 
    {
      if ( ( curtype >= 9 ) && ( curtype <= 10 ) ) 
      flushcurexp ( 30 ) ;
      else flushcurexp ( 31 ) ;
      curtype = 2 ;
    } 
    break ;
  case 11 : 
    {
      if ( ( curtype >= 11 ) && ( curtype <= 12 ) ) 
      flushcurexp ( 30 ) ;
      else flushcurexp ( 31 ) ;
      curtype = 2 ;
    } 
    break ;
  case 13 : 
  case 14 : 
    {
      if ( curtype == c ) 
      flushcurexp ( 30 ) ;
      else flushcurexp ( 31 ) ;
      curtype = 2 ;
    } 
    break ;
  case 15 : 
    {
      if ( ( curtype >= 16 ) && ( curtype <= 19 ) ) 
      flushcurexp ( 30 ) ;
      else flushcurexp ( 31 ) ;
      curtype = 2 ;
    } 
    break ;
  case 39 : 
  case 40 : 
    testknown ( c ) ;
    break ;
  case 68 : 
    {
      if ( curtype != 9 ) 
      flushcurexp ( 31 ) ;
      else if ( mem [curexp ].hhfield .b0 != 0 ) 
      flushcurexp ( 30 ) ;
      else flushcurexp ( 31 ) ;
      curtype = 2 ;
    } 
    break ;
  case 45 : 
    {
      if ( curtype == 14 ) 
      pairtopath () ;
      if ( curtype == 9 ) 
      curtype = 8 ;
      else badunary ( 45 ) ;
    } 
    break ;
  case 44 : 
    {
      if ( curtype == 8 ) 
      materializepen () ;
      if ( curtype != 6 ) 
      badunary ( 44 ) ;
      else {
	  
	flushcurexp ( makepath ( curexp ) ) ;
	curtype = 9 ;
      } 
    } 
    break ;
  case 46 : 
    if ( curtype != 11 ) 
    badunary ( 46 ) ;
    else flushcurexp ( totalweight ( curexp ) ) ;
    break ;
  case 43 : 
    if ( curtype == 9 ) 
    {
      p = htapypoc ( curexp ) ;
      if ( mem [p ].hhfield .b1 == 0 ) 
      p = mem [p ].hhfield .v.RH ;
      tossknotlist ( curexp ) ;
      curexp = p ;
    } 
    else if ( curtype == 14 ) 
    pairtopath () ;
    else badunary ( 43 ) ;
    break ;
  } 
  {
    if ( aritherror ) 
    cleararith () ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
zbadbinary ( halfword p , quarterword c ) 
#else
zbadbinary ( p , c ) 
  halfword p ;
  quarterword c ;
#endif
{
  disperr ( p , 261 ) ;
  disperr ( 0 , 838 ) ;
  if ( c >= 94 ) 
  printop ( c ) ;
  printknownorunknowntype ( mem [p ].hhfield .b0 , p ) ;
  if ( c >= 94 ) 
  print ( 479 ) ;
  else printop ( c ) ;
  printknownorunknowntype ( curtype , curexp ) ;
  {
    helpptr = 3 ;
    helpline [2 ]= 839 ;
    helpline [1 ]= 848 ;
    helpline [0 ]= 849 ;
  } 
  putgeterror () ;
} 
halfword 
#ifdef HAVE_PROTOTYPES
ztarnished ( halfword p ) 
#else
ztarnished ( p ) 
  halfword p ;
#endif
{
  /* 10 */ register halfword Result; halfword q  ;
  halfword r  ;
  q = mem [p + 1 ].cint ;
  r = q + bignodesize [mem [p ].hhfield .b0 ];
  do {
      r = r - 2 ;
    if ( mem [r ].hhfield .b0 == 19 ) 
    {
      Result = 1 ;
      goto lab10 ;
    } 
  } while ( ! ( r == q ) ) ;
  Result = 0 ;
  lab10: ;
  return Result ;
} 
void 
#ifdef HAVE_PROTOTYPES
zdepfinish ( halfword v , halfword q , smallnumber t ) 
#else
zdepfinish ( v , q , t ) 
  halfword v ;
  halfword q ;
  smallnumber t ;
#endif
{
  halfword p  ;
  scaled vv  ;
  if ( q == 0 ) 
  p = curexp ;
  else p = q ;
  mem [p + 1 ].hhfield .v.RH = v ;
  mem [p ].hhfield .b0 = t ;
  if ( mem [v ].hhfield .lhfield == 0 ) 
  {
    vv = mem [v + 1 ].cint ;
    if ( q == 0 ) 
    flushcurexp ( vv ) ;
    else {
	
      recyclevalue ( p ) ;
      mem [q ].hhfield .b0 = 16 ;
      mem [q + 1 ].cint = vv ;
    } 
  } 
  else if ( q == 0 ) 
  curtype = t ;
  if ( fixneeded ) 
  fixdependencies () ;
} 
void 
#ifdef HAVE_PROTOTYPES
zaddorsubtract ( halfword p , halfword q , quarterword c ) 
#else
zaddorsubtract ( p , q , c ) 
  halfword p ;
  halfword q ;
  quarterword c ;
#endif
{
  /* 30 10 */ smallnumber s, t  ;
  halfword r  ;
  integer v  ;
  if ( q == 0 ) 
  {
    t = curtype ;
    if ( t < 17 ) 
    v = curexp ;
    else v = mem [curexp + 1 ].hhfield .v.RH ;
  } 
  else {
      
    t = mem [q ].hhfield .b0 ;
    if ( t < 17 ) 
    v = mem [q + 1 ].cint ;
    else v = mem [q + 1 ].hhfield .v.RH ;
  } 
  if ( t == 16 ) 
  {
    if ( c == 70 ) 
    v = - (integer) v ;
    if ( mem [p ].hhfield .b0 == 16 ) 
    {
      v = slowadd ( mem [p + 1 ].cint , v ) ;
      if ( q == 0 ) 
      curexp = v ;
      else mem [q + 1 ].cint = v ;
      goto lab10 ;
    } 
    r = mem [p + 1 ].hhfield .v.RH ;
    while ( mem [r ].hhfield .lhfield != 0 ) r = mem [r ].hhfield .v.RH ;
    mem [r + 1 ].cint = slowadd ( mem [r + 1 ].cint , v ) ;
    if ( q == 0 ) 
    {
      q = getnode ( 2 ) ;
      curexp = q ;
      curtype = mem [p ].hhfield .b0 ;
      mem [q ].hhfield .b1 = 11 ;
    } 
    mem [q + 1 ].hhfield .v.RH = mem [p + 1 ].hhfield .v.RH ;
    mem [q ].hhfield .b0 = mem [p ].hhfield .b0 ;
    mem [q + 1 ].hhfield .lhfield = mem [p + 1 ].hhfield .lhfield ;
    mem [mem [p + 1 ].hhfield .lhfield ].hhfield .v.RH = q ;
    mem [p ].hhfield .b0 = 16 ;
  } 
  else {
      
    if ( c == 70 ) 
    negatedeplist ( v ) ;
    if ( mem [p ].hhfield .b0 == 16 ) 
    {
      while ( mem [v ].hhfield .lhfield != 0 ) v = mem [v ].hhfield .v.RH 
      ;
      mem [v + 1 ].cint = slowadd ( mem [p + 1 ].cint , mem [v + 1 ]
      .cint ) ;
    } 
    else {
	
      s = mem [p ].hhfield .b0 ;
      r = mem [p + 1 ].hhfield .v.RH ;
      if ( t == 17 ) 
      {
	if ( s == 17 ) 
	if ( maxcoef ( r ) + maxcoef ( v ) < 626349397L ) 
	{
	  v = pplusq ( v , r , 17 ) ;
	  goto lab30 ;
	} 
	t = 18 ;
	v = poverv ( v , 65536L , 17 , 18 ) ;
      } 
      if ( s == 18 ) 
      v = pplusq ( v , r , 18 ) ;
      else v = pplusfq ( v , 65536L , r , 18 , 17 ) ;
      lab30: if ( q != 0 ) 
      depfinish ( v , q , t ) ;
      else {
	  
	curtype = t ;
	depfinish ( v , 0 , t ) ;
      } 
    } 
  } 
  lab10: ;
} 
void 
#ifdef HAVE_PROTOTYPES
zdepmult ( halfword p , integer v , boolean visscaled ) 
#else
zdepmult ( p , v , visscaled ) 
  halfword p ;
  integer v ;
  boolean visscaled ;
#endif
{
  /* 10 */ halfword q  ;
  smallnumber s, t  ;
  if ( p == 0 ) 
  q = curexp ;
  else if ( mem [p ].hhfield .b0 != 16 ) 
  q = p ;
  else {
      
    if ( visscaled ) 
    mem [p + 1 ].cint = takescaled ( mem [p + 1 ].cint , v ) ;
    else mem [p + 1 ].cint = takefraction ( mem [p + 1 ].cint , v ) ;
    goto lab10 ;
  } 
  t = mem [q ].hhfield .b0 ;
  q = mem [q + 1 ].hhfield .v.RH ;
  s = t ;
  if ( t == 17 ) 
  if ( visscaled ) 
  if ( abvscd ( maxcoef ( q ) , abs ( v ) , 626349396L , 65536L ) >= 0 ) 
  t = 18 ;
  q = ptimesv ( q , v , s , t , visscaled ) ;
  depfinish ( q , p , t ) ;
  lab10: ;
} 
void 
#ifdef HAVE_PROTOTYPES
zhardtimes ( halfword p ) 
#else
zhardtimes ( p ) 
  halfword p ;
#endif
{
  halfword q  ;
  halfword r  ;
  scaled u, v  ;
  if ( mem [p ].hhfield .b0 == 14 ) 
  {
    q = stashcurexp () ;
    unstashcurexp ( p ) ;
    p = q ;
  } 
  r = mem [curexp + 1 ].cint ;
  u = mem [r + 1 ].cint ;
  v = mem [r + 3 ].cint ;
  mem [r + 2 ].hhfield .b0 = mem [p ].hhfield .b0 ;
  newdep ( r + 2 , copydeplist ( mem [p + 1 ].hhfield .v.RH ) ) ;
  mem [r ].hhfield .b0 = mem [p ].hhfield .b0 ;
  mem [r + 1 ]= mem [p + 1 ];
  mem [mem [p + 1 ].hhfield .lhfield ].hhfield .v.RH = r ;
  freenode ( p , 2 ) ;
  depmult ( r , u , true ) ;
  depmult ( r + 2 , v , true ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
zdepdiv ( halfword p , scaled v ) 
#else
zdepdiv ( p , v ) 
  halfword p ;
  scaled v ;
#endif
{
  /* 10 */ halfword q  ;
  smallnumber s, t  ;
  if ( p == 0 ) 
  q = curexp ;
  else if ( mem [p ].hhfield .b0 != 16 ) 
  q = p ;
  else {
      
    mem [p + 1 ].cint = makescaled ( mem [p + 1 ].cint , v ) ;
    goto lab10 ;
  } 
  t = mem [q ].hhfield .b0 ;
  q = mem [q + 1 ].hhfield .v.RH ;
  s = t ;
  if ( t == 17 ) 
  if ( abvscd ( maxcoef ( q ) , 65536L , 626349396L , abs ( v ) ) >= 0 ) 
  t = 18 ;
  q = poverv ( q , v , s , t ) ;
  depfinish ( q , p , t ) ;
  lab10: ;
} 
void 
#ifdef HAVE_PROTOTYPES
zsetuptrans ( quarterword c ) 
#else
zsetuptrans ( c ) 
  quarterword c ;
#endif
{
  /* 30 10 */ halfword p, q, r  ;
  if ( ( c != 88 ) || ( curtype != 13 ) ) 
  {
    p = stashcurexp () ;
    curexp = idtransform () ;
    curtype = 13 ;
    q = mem [curexp + 1 ].cint ;
    switch ( c ) 
    {case 84 : 
      if ( mem [p ].hhfield .b0 == 16 ) 
      {
	nsincos ( ( mem [p + 1 ].cint % 23592960L ) * 16 ) ;
	mem [q + 5 ].cint = roundfraction ( ncos ) ;
	mem [q + 9 ].cint = roundfraction ( nsin ) ;
	mem [q + 7 ].cint = - (integer) mem [q + 9 ].cint ;
	mem [q + 11 ].cint = mem [q + 5 ].cint ;
	goto lab30 ;
      } 
      break ;
    case 85 : 
      if ( mem [p ].hhfield .b0 > 14 ) 
      {
	install ( q + 6 , p ) ;
	goto lab30 ;
      } 
      break ;
    case 86 : 
      if ( mem [p ].hhfield .b0 > 14 ) 
      {
	install ( q + 4 , p ) ;
	install ( q + 10 , p ) ;
	goto lab30 ;
      } 
      break ;
    case 87 : 
      if ( mem [p ].hhfield .b0 == 14 ) 
      {
	r = mem [p + 1 ].cint ;
	install ( q , r ) ;
	install ( q + 2 , r + 2 ) ;
	goto lab30 ;
      } 
      break ;
    case 89 : 
      if ( mem [p ].hhfield .b0 > 14 ) 
      {
	install ( q + 4 , p ) ;
	goto lab30 ;
      } 
      break ;
    case 90 : 
      if ( mem [p ].hhfield .b0 > 14 ) 
      {
	install ( q + 10 , p ) ;
	goto lab30 ;
      } 
      break ;
    case 91 : 
      if ( mem [p ].hhfield .b0 == 14 ) 
      {
	r = mem [p + 1 ].cint ;
	install ( q + 4 , r ) ;
	install ( q + 10 , r ) ;
	install ( q + 8 , r + 2 ) ;
	if ( mem [r + 2 ].hhfield .b0 == 16 ) 
	mem [r + 3 ].cint = - (integer) mem [r + 3 ].cint ;
	else negatedeplist ( mem [r + 3 ].hhfield .v.RH ) ;
	install ( q + 6 , r + 2 ) ;
	goto lab30 ;
      } 
      break ;
    case 88 : 
      ;
      break ;
    } 
    disperr ( p , 858 ) ;
    {
      helpptr = 3 ;
      helpline [2 ]= 859 ;
      helpline [1 ]= 860 ;
      helpline [0 ]= 538 ;
    } 
    putgeterror () ;
    lab30: recyclevalue ( p ) ;
    freenode ( p , 2 ) ;
  } 
  q = mem [curexp + 1 ].cint ;
  r = q + 12 ;
  do {
      r = r - 2 ;
    if ( mem [r ].hhfield .b0 != 16 ) 
    goto lab10 ;
  } while ( ! ( r == q ) ) ;
  txx = mem [q + 5 ].cint ;
  txy = mem [q + 7 ].cint ;
  tyx = mem [q + 9 ].cint ;
  tyy = mem [q + 11 ].cint ;
  tx = mem [q + 1 ].cint ;
  ty = mem [q + 3 ].cint ;
  flushcurexp ( 0 ) ;
  lab10: ;
} 
void 
#ifdef HAVE_PROTOTYPES
zsetupknowntrans ( quarterword c ) 
#else
zsetupknowntrans ( c ) 
  quarterword c ;
#endif
{
  setuptrans ( c ) ;
  if ( curtype != 16 ) 
  {
    disperr ( 0 , 861 ) ;
    {
      helpptr = 3 ;
      helpline [2 ]= 862 ;
      helpline [1 ]= 863 ;
      helpline [0 ]= 538 ;
    } 
    putgetflusherror ( 0 ) ;
    txx = 65536L ;
    txy = 0 ;
    tyx = 0 ;
    tyy = 65536L ;
    tx = 0 ;
    ty = 0 ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
ztrans ( halfword p , halfword q ) 
#else
ztrans ( p , q ) 
  halfword p ;
  halfword q ;
#endif
{
  scaled v  ;
  v = takescaled ( mem [p ].cint , txx ) + takescaled ( mem [q ].cint , 
  txy ) + tx ;
  mem [q ].cint = takescaled ( mem [p ].cint , tyx ) + takescaled ( mem [
  q ].cint , tyy ) + ty ;
  mem [p ].cint = v ;
} 
void 
#ifdef HAVE_PROTOTYPES
zpathtrans ( halfword p , quarterword c ) 
#else
zpathtrans ( p , c ) 
  halfword p ;
  quarterword c ;
#endif
{
  /* 10 */ halfword q  ;
  setupknowntrans ( c ) ;
  unstashcurexp ( p ) ;
  if ( curtype == 6 ) 
  {
    if ( mem [curexp + 9 ].cint == 0 ) 
    if ( tx == 0 ) 
    if ( ty == 0 ) 
    goto lab10 ;
    flushcurexp ( makepath ( curexp ) ) ;
    curtype = 8 ;
  } 
  q = curexp ;
  do {
      if ( mem [q ].hhfield .b0 != 0 ) 
    trans ( q + 3 , q + 4 ) ;
    trans ( q + 1 , q + 2 ) ;
    if ( mem [q ].hhfield .b1 != 0 ) 
    trans ( q + 5 , q + 6 ) ;
    q = mem [q ].hhfield .v.RH ;
  } while ( ! ( q == curexp ) ) ;
  lab10: ;
} 
void 
#ifdef HAVE_PROTOTYPES
zedgestrans ( halfword p , quarterword c ) 
#else
zedgestrans ( p , c ) 
  halfword p ;
  quarterword c ;
#endif
{
  /* 10 */ setupknowntrans ( c ) ;
  unstashcurexp ( p ) ;
  curedges = curexp ;
  if ( mem [curedges ].hhfield .v.RH == curedges ) 
  goto lab10 ;
  if ( txx == 0 ) 
  if ( tyy == 0 ) 
  if ( txy % 65536L == 0 ) 
  if ( tyx % 65536L == 0 ) 
  {
    xyswapedges () ;
    txx = txy ;
    tyy = tyx ;
    txy = 0 ;
    tyx = 0 ;
    if ( mem [curedges ].hhfield .v.RH == curedges ) 
    goto lab10 ;
  } 
  if ( txy == 0 ) 
  if ( tyx == 0 ) 
  if ( txx % 65536L == 0 ) 
  if ( tyy % 65536L == 0 ) 
  {
    if ( ( txx == 0 ) || ( tyy == 0 ) ) 
    {
      tossedges ( curedges ) ;
      curexp = getnode ( 6 ) ;
      initedges ( curexp ) ;
    } 
    else {
	
      if ( txx < 0 ) 
      {
	xreflectedges () ;
	txx = - (integer) txx ;
      } 
      if ( tyy < 0 ) 
      {
	yreflectedges () ;
	tyy = - (integer) tyy ;
      } 
      if ( txx != 65536L ) 
      xscaleedges ( txx / 65536L ) ;
      if ( tyy != 65536L ) 
      yscaleedges ( tyy / 65536L ) ;
      tx = roundunscaled ( tx ) ;
      ty = roundunscaled ( ty ) ;
      if ( ( intcast ( mem [curedges + 2 ].hhfield .lhfield ) + tx <= 0 ) || 
      ( mem [curedges + 2 ].hhfield .v.RH + tx >= 8192 ) || ( intcast ( mem 
      [curedges + 1 ].hhfield .lhfield ) + ty <= 0 ) || ( mem [curedges + 1 
      ].hhfield .v.RH + ty >= 8191 ) || ( abs ( tx ) >= 4096 ) || ( abs ( ty 
      ) >= 4096 ) ) 
      {
	{
	  if ( interaction == 3 ) 
	  ;
	  if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	  {
	    printnl ( 261 ) ;
	    print ( fullsourcefilenamestack [inopen ]) ;
	    print ( 58 ) ;
	    printint ( line ) ;
	    print ( 262 ) ;
	    print ( 867 ) ;
	  } 
	  else {
	      
	    printnl ( 263 ) ;
	    print ( 867 ) ;
	  } 
	} 
	{
	  helpptr = 3 ;
	  helpline [2 ]= 868 ;
	  helpline [1 ]= 537 ;
	  helpline [0 ]= 538 ;
	} 
	putgeterror () ;
      } 
      else {
	  
	if ( tx != 0 ) 
	{
	  if ( ! ( abs ( mem [curedges + 3 ].hhfield .lhfield - tx - 4096 ) 
	  < 4096 ) ) 
	  fixoffset () ;
	  mem [curedges + 2 ].hhfield .lhfield = mem [curedges + 2 ]
	  .hhfield .lhfield + tx ;
	  mem [curedges + 2 ].hhfield .v.RH = mem [curedges + 2 ].hhfield 
	  .v.RH + tx ;
	  mem [curedges + 3 ].hhfield .lhfield = mem [curedges + 3 ]
	  .hhfield .lhfield - tx ;
	  mem [curedges + 4 ].cint = 0 ;
	} 
	if ( ty != 0 ) 
	{
	  mem [curedges + 1 ].hhfield .lhfield = mem [curedges + 1 ]
	  .hhfield .lhfield + ty ;
	  mem [curedges + 1 ].hhfield .v.RH = mem [curedges + 1 ].hhfield 
	  .v.RH + ty ;
	  mem [curedges + 5 ].hhfield .lhfield = mem [curedges + 5 ]
	  .hhfield .lhfield + ty ;
	  mem [curedges + 4 ].cint = 0 ;
	} 
      } 
    } 
    goto lab10 ;
  } 
  {
    if ( interaction == 3 ) 
    ;
    if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
    {
      printnl ( 261 ) ;
      print ( fullsourcefilenamestack [inopen ]) ;
      print ( 58 ) ;
      printint ( line ) ;
      print ( 262 ) ;
      print ( 864 ) ;
    } 
    else {
	
      printnl ( 263 ) ;
      print ( 864 ) ;
    } 
  } 
  {
    helpptr = 3 ;
    helpline [2 ]= 865 ;
    helpline [1 ]= 866 ;
    helpline [0 ]= 538 ;
  } 
  putgeterror () ;
  lab10: ;
} 
void 
#ifdef HAVE_PROTOTYPES
zbilin1 ( halfword p , scaled t , halfword q , scaled u , scaled delta ) 
#else
zbilin1 ( p , t , q , u , delta ) 
  halfword p ;
  scaled t ;
  halfword q ;
  scaled u ;
  scaled delta ;
#endif
{
  halfword r  ;
  if ( t != 65536L ) 
  depmult ( p , t , true ) ;
  if ( u != 0 ) 
  if ( mem [q ].hhfield .b0 == 16 ) 
  delta = delta + takescaled ( mem [q + 1 ].cint , u ) ;
  else {
      
    if ( mem [p ].hhfield .b0 != 18 ) 
    {
      if ( mem [p ].hhfield .b0 == 16 ) 
      newdep ( p , constdependency ( mem [p + 1 ].cint ) ) ;
      else mem [p + 1 ].hhfield .v.RH = ptimesv ( mem [p + 1 ].hhfield 
      .v.RH , 65536L , 17 , 18 , true ) ;
      mem [p ].hhfield .b0 = 18 ;
    } 
    mem [p + 1 ].hhfield .v.RH = pplusfq ( mem [p + 1 ].hhfield .v.RH , u 
    , mem [q + 1 ].hhfield .v.RH , 18 , mem [q ].hhfield .b0 ) ;
  } 
  if ( mem [p ].hhfield .b0 == 16 ) 
  mem [p + 1 ].cint = mem [p + 1 ].cint + delta ;
  else {
      
    r = mem [p + 1 ].hhfield .v.RH ;
    while ( mem [r ].hhfield .lhfield != 0 ) r = mem [r ].hhfield .v.RH ;
    delta = mem [r + 1 ].cint + delta ;
    if ( r != mem [p + 1 ].hhfield .v.RH ) 
    mem [r + 1 ].cint = delta ;
    else {
	
      recyclevalue ( p ) ;
      mem [p ].hhfield .b0 = 16 ;
      mem [p + 1 ].cint = delta ;
    } 
  } 
  if ( fixneeded ) 
  fixdependencies () ;
} 
void 
#ifdef HAVE_PROTOTYPES
zaddmultdep ( halfword p , scaled v , halfword r ) 
#else
zaddmultdep ( p , v , r ) 
  halfword p ;
  scaled v ;
  halfword r ;
#endif
{
  if ( mem [r ].hhfield .b0 == 16 ) 
  mem [depfinal + 1 ].cint = mem [depfinal + 1 ].cint + takescaled ( mem [
  r + 1 ].cint , v ) ;
  else {
      
    mem [p + 1 ].hhfield .v.RH = pplusfq ( mem [p + 1 ].hhfield .v.RH , v 
    , mem [r + 1 ].hhfield .v.RH , 18 , mem [r ].hhfield .b0 ) ;
    if ( fixneeded ) 
    fixdependencies () ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
zbilin2 ( halfword p , halfword t , scaled v , halfword u , halfword q ) 
#else
zbilin2 ( p , t , v , u , q ) 
  halfword p ;
  halfword t ;
  scaled v ;
  halfword u ;
  halfword q ;
#endif
{
  scaled vv  ;
  vv = mem [p + 1 ].cint ;
  mem [p ].hhfield .b0 = 18 ;
  newdep ( p , constdependency ( 0 ) ) ;
  if ( vv != 0 ) 
  addmultdep ( p , vv , t ) ;
  if ( v != 0 ) 
  addmultdep ( p , v , u ) ;
  if ( q != 0 ) 
  addmultdep ( p , 65536L , q ) ;
  if ( mem [p + 1 ].hhfield .v.RH == depfinal ) 
  {
    vv = mem [depfinal + 1 ].cint ;
    recyclevalue ( p ) ;
    mem [p ].hhfield .b0 = 16 ;
    mem [p + 1 ].cint = vv ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
zbilin3 ( halfword p , scaled t , scaled v , scaled u , scaled delta ) 
#else
zbilin3 ( p , t , v , u , delta ) 
  halfword p ;
  scaled t ;
  scaled v ;
  scaled u ;
  scaled delta ;
#endif
{
  if ( t != 65536L ) 
  delta = delta + takescaled ( mem [p + 1 ].cint , t ) ;
  else delta = delta + mem [p + 1 ].cint ;
  if ( u != 0 ) 
  mem [p + 1 ].cint = delta + takescaled ( v , u ) ;
  else mem [p + 1 ].cint = delta ;
} 
void 
#ifdef HAVE_PROTOTYPES
zbigtrans ( halfword p , quarterword c ) 
#else
zbigtrans ( p , c ) 
  halfword p ;
  quarterword c ;
#endif
{
  /* 10 */ halfword q, r, pp, qq  ;
  smallnumber s  ;
  s = bignodesize [mem [p ].hhfield .b0 ];
  q = mem [p + 1 ].cint ;
  r = q + s ;
  do {
      r = r - 2 ;
    if ( mem [r ].hhfield .b0 != 16 ) 
    {
      setupknowntrans ( c ) ;
      makeexpcopy ( p ) ;
      r = mem [curexp + 1 ].cint ;
      if ( curtype == 13 ) 
      {
	bilin1 ( r + 10 , tyy , q + 6 , tyx , 0 ) ;
	bilin1 ( r + 8 , tyy , q + 4 , tyx , 0 ) ;
	bilin1 ( r + 6 , txx , q + 10 , txy , 0 ) ;
	bilin1 ( r + 4 , txx , q + 8 , txy , 0 ) ;
      } 
      bilin1 ( r + 2 , tyy , q , tyx , ty ) ;
      bilin1 ( r , txx , q + 2 , txy , tx ) ;
      goto lab10 ;
    } 
  } while ( ! ( r == q ) ) ;
  setuptrans ( c ) ;
  if ( curtype == 16 ) 
  {
    makeexpcopy ( p ) ;
    r = mem [curexp + 1 ].cint ;
    if ( curtype == 13 ) 
    {
      bilin3 ( r + 10 , tyy , mem [q + 7 ].cint , tyx , 0 ) ;
      bilin3 ( r + 8 , tyy , mem [q + 5 ].cint , tyx , 0 ) ;
      bilin3 ( r + 6 , txx , mem [q + 11 ].cint , txy , 0 ) ;
      bilin3 ( r + 4 , txx , mem [q + 9 ].cint , txy , 0 ) ;
    } 
    bilin3 ( r + 2 , tyy , mem [q + 1 ].cint , tyx , ty ) ;
    bilin3 ( r , txx , mem [q + 3 ].cint , txy , tx ) ;
  } 
  else {
      
    pp = stashcurexp () ;
    qq = mem [pp + 1 ].cint ;
    makeexpcopy ( p ) ;
    r = mem [curexp + 1 ].cint ;
    if ( curtype == 13 ) 
    {
      bilin2 ( r + 10 , qq + 10 , mem [q + 7 ].cint , qq + 8 , 0 ) ;
      bilin2 ( r + 8 , qq + 10 , mem [q + 5 ].cint , qq + 8 , 0 ) ;
      bilin2 ( r + 6 , qq + 4 , mem [q + 11 ].cint , qq + 6 , 0 ) ;
      bilin2 ( r + 4 , qq + 4 , mem [q + 9 ].cint , qq + 6 , 0 ) ;
    } 
    bilin2 ( r + 2 , qq + 10 , mem [q + 1 ].cint , qq + 8 , qq + 2 ) ;
    bilin2 ( r , qq + 4 , mem [q + 3 ].cint , qq + 6 , qq ) ;
    recyclevalue ( pp ) ;
    freenode ( pp , 2 ) ;
  } 
  lab10: ;
} 
void 
#ifdef HAVE_PROTOTYPES
zcat ( halfword p ) 
#else
zcat ( p ) 
  halfword p ;
#endif
{
  strnumber a, b  ;
  poolpointer k  ;
  a = mem [p + 1 ].cint ;
  b = curexp ;
  {
    if ( poolptr + ( strstart [a + 1 ]- strstart [a ]) + ( strstart [b + 
    1 ]- strstart [b ]) > maxpoolptr ) 
    {
      if ( poolptr + ( strstart [a + 1 ]- strstart [a ]) + ( strstart [b 
      + 1 ]- strstart [b ]) > poolsize ) 
      overflow ( 257 , poolsize - initpoolptr ) ;
      maxpoolptr = poolptr + ( strstart [a + 1 ]- strstart [a ]) + ( 
      strstart [b + 1 ]- strstart [b ]) ;
    } 
  } 
  {register integer for_end; k = strstart [a ];for_end = strstart [a + 1 
  ]- 1 ; if ( k <= for_end) do 
    {
      strpool [poolptr ]= strpool [k ];
      incr ( poolptr ) ;
    } 
  while ( k++ < for_end ) ;} 
  {register integer for_end; k = strstart [b ];for_end = strstart [b + 1 
  ]- 1 ; if ( k <= for_end) do 
    {
      strpool [poolptr ]= strpool [k ];
      incr ( poolptr ) ;
    } 
  while ( k++ < for_end ) ;} 
  curexp = makestring () ;
  {
    if ( strref [b ]< 127 ) 
    if ( strref [b ]> 1 ) 
    decr ( strref [b ]) ;
    else flushstring ( b ) ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
zchopstring ( halfword p ) 
#else
zchopstring ( p ) 
  halfword p ;
#endif
{
  integer a, b  ;
  integer l  ;
  integer k  ;
  strnumber s  ;
  boolean reversed  ;
  a = roundunscaled ( mem [p + 1 ].cint ) ;
  b = roundunscaled ( mem [p + 3 ].cint ) ;
  if ( a <= b ) 
  reversed = false ;
  else {
      
    reversed = true ;
    k = a ;
    a = b ;
    b = k ;
  } 
  s = curexp ;
  l = ( strstart [s + 1 ]- strstart [s ]) ;
  if ( a < 0 ) 
  {
    a = 0 ;
    if ( b < 0 ) 
    b = 0 ;
  } 
  if ( b > l ) 
  {
    b = l ;
    if ( a > l ) 
    a = l ;
  } 
  {
    if ( poolptr + b - a > maxpoolptr ) 
    {
      if ( poolptr + b - a > poolsize ) 
      overflow ( 257 , poolsize - initpoolptr ) ;
      maxpoolptr = poolptr + b - a ;
    } 
  } 
  if ( reversed ) 
  {register integer for_end; k = strstart [s ]+ b - 1 ;for_end = strstart 
  [s ]+ a ; if ( k >= for_end) do 
    {
      strpool [poolptr ]= strpool [k ];
      incr ( poolptr ) ;
    } 
  while ( k-- > for_end ) ;} 
  else {
      register integer for_end; k = strstart [s ]+ a ;for_end = strstart 
  [s ]+ b - 1 ; if ( k <= for_end) do 
    {
      strpool [poolptr ]= strpool [k ];
      incr ( poolptr ) ;
    } 
  while ( k++ < for_end ) ;} 
  curexp = makestring () ;
  {
    if ( strref [s ]< 127 ) 
    if ( strref [s ]> 1 ) 
    decr ( strref [s ]) ;
    else flushstring ( s ) ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
zchoppath ( halfword p ) 
#else
zchoppath ( p ) 
  halfword p ;
#endif
{
  halfword q  ;
  halfword pp, qq, rr, ss  ;
  scaled a, b, k, l  ;
  boolean reversed  ;
  l = pathlength () ;
  a = mem [p + 1 ].cint ;
  b = mem [p + 3 ].cint ;
  if ( a <= b ) 
  reversed = false ;
  else {
      
    reversed = true ;
    k = a ;
    a = b ;
    b = k ;
  } 
  if ( a < 0 ) 
  if ( mem [curexp ].hhfield .b0 == 0 ) 
  {
    a = 0 ;
    if ( b < 0 ) 
    b = 0 ;
  } 
  else do {
      a = a + l ;
    b = b + l ;
  } while ( ! ( a >= 0 ) ) ;
  if ( b > l ) 
  if ( mem [curexp ].hhfield .b0 == 0 ) 
  {
    b = l ;
    if ( a > l ) 
    a = l ;
  } 
  else while ( a >= l ) {
      
    a = a - l ;
    b = b - l ;
  } 
  q = curexp ;
  while ( a >= 65536L ) {
      
    q = mem [q ].hhfield .v.RH ;
    a = a - 65536L ;
    b = b - 65536L ;
  } 
  if ( b == a ) 
  {
    if ( a > 0 ) 
    {
      qq = mem [q ].hhfield .v.RH ;
      splitcubic ( q , a * 4096 , mem [qq + 1 ].cint , mem [qq + 2 ].cint 
      ) ;
      q = mem [q ].hhfield .v.RH ;
    } 
    pp = copyknot ( q ) ;
    qq = pp ;
  } 
  else {
      
    pp = copyknot ( q ) ;
    qq = pp ;
    do {
	q = mem [q ].hhfield .v.RH ;
      rr = qq ;
      qq = copyknot ( q ) ;
      mem [rr ].hhfield .v.RH = qq ;
      b = b - 65536L ;
    } while ( ! ( b <= 0 ) ) ;
    if ( a > 0 ) 
    {
      ss = pp ;
      pp = mem [pp ].hhfield .v.RH ;
      splitcubic ( ss , a * 4096 , mem [pp + 1 ].cint , mem [pp + 2 ].cint 
      ) ;
      pp = mem [ss ].hhfield .v.RH ;
      freenode ( ss , 7 ) ;
      if ( rr == ss ) 
      {
	b = makescaled ( b , 65536L - a ) ;
	rr = pp ;
      } 
    } 
    if ( b < 0 ) 
    {
      splitcubic ( rr , ( b + 65536L ) * 4096 , mem [qq + 1 ].cint , mem [
      qq + 2 ].cint ) ;
      freenode ( qq , 7 ) ;
      qq = mem [rr ].hhfield .v.RH ;
    } 
  } 
  mem [pp ].hhfield .b0 = 0 ;
  mem [qq ].hhfield .b1 = 0 ;
  mem [qq ].hhfield .v.RH = pp ;
  tossknotlist ( curexp ) ;
  if ( reversed ) 
  {
    curexp = mem [htapypoc ( pp ) ].hhfield .v.RH ;
    tossknotlist ( pp ) ;
  } 
  else curexp = pp ;
} 
void 
#ifdef HAVE_PROTOTYPES
zpairvalue ( scaled x , scaled y ) 
#else
zpairvalue ( x , y ) 
  scaled x ;
  scaled y ;
#endif
{
  halfword p  ;
  p = getnode ( 2 ) ;
  flushcurexp ( p ) ;
  curtype = 14 ;
  mem [p ].hhfield .b0 = 14 ;
  mem [p ].hhfield .b1 = 11 ;
  initbignode ( p ) ;
  p = mem [p + 1 ].cint ;
  mem [p ].hhfield .b0 = 16 ;
  mem [p + 1 ].cint = x ;
  mem [p + 2 ].hhfield .b0 = 16 ;
  mem [p + 3 ].cint = y ;
} 
void 
#ifdef HAVE_PROTOTYPES
zsetupoffset ( halfword p ) 
#else
zsetupoffset ( p ) 
  halfword p ;
#endif
{
  findoffset ( mem [p + 1 ].cint , mem [p + 3 ].cint , curexp ) ;
  pairvalue ( curx , cury ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
zsetupdirectiontime ( halfword p ) 
#else
zsetupdirectiontime ( p ) 
  halfword p ;
#endif
{
  flushcurexp ( finddirectiontime ( mem [p + 1 ].cint , mem [p + 3 ]
  .cint , curexp ) ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
zfindpoint ( scaled v , quarterword c ) 
#else
zfindpoint ( v , c ) 
  scaled v ;
  quarterword c ;
#endif
{
  halfword p  ;
  scaled n  ;
  halfword q  ;
  p = curexp ;
  if ( mem [p ].hhfield .b0 == 0 ) 
  n = -65536L ;
  else n = 0 ;
  do {
      p = mem [p ].hhfield .v.RH ;
    n = n + 65536L ;
  } while ( ! ( p == curexp ) ) ;
  if ( n == 0 ) 
  v = 0 ;
  else if ( v < 0 ) 
  if ( mem [p ].hhfield .b0 == 0 ) 
  v = 0 ;
  else v = n - 1 - ( ( - (integer) v - 1 ) % n ) ;
  else if ( v > n ) 
  if ( mem [p ].hhfield .b0 == 0 ) 
  v = n ;
  else v = v % n ;
  p = curexp ;
  while ( v >= 65536L ) {
      
    p = mem [p ].hhfield .v.RH ;
    v = v - 65536L ;
  } 
  if ( v != 0 ) 
  {
    q = mem [p ].hhfield .v.RH ;
    splitcubic ( p , v * 4096 , mem [q + 1 ].cint , mem [q + 2 ].cint ) ;
    p = mem [p ].hhfield .v.RH ;
  } 
  switch ( c ) 
  {case 97 : 
    pairvalue ( mem [p + 1 ].cint , mem [p + 2 ].cint ) ;
    break ;
  case 98 : 
    if ( mem [p ].hhfield .b0 == 0 ) 
    pairvalue ( mem [p + 1 ].cint , mem [p + 2 ].cint ) ;
    else pairvalue ( mem [p + 3 ].cint , mem [p + 4 ].cint ) ;
    break ;
  case 99 : 
    if ( mem [p ].hhfield .b1 == 0 ) 
    pairvalue ( mem [p + 1 ].cint , mem [p + 2 ].cint ) ;
    else pairvalue ( mem [p + 5 ].cint , mem [p + 6 ].cint ) ;
    break ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
zdobinary ( halfword p , quarterword c ) 
#else
zdobinary ( p , c ) 
  halfword p ;
  quarterword c ;
#endif
{
  /* 30 31 10 */ halfword q, r, rr  ;
  halfword oldp, oldexp  ;
  integer v  ;
  {
    if ( aritherror ) 
    cleararith () ;
  } 
  if ( internal [7 ]> 131072L ) 
  {
    begindiagnostic () ;
    printnl ( 850 ) ;
    printexp ( p , 0 ) ;
    printchar ( 41 ) ;
    printop ( c ) ;
    printchar ( 40 ) ;
    printexp ( 0 , 0 ) ;
    print ( 842 ) ;
    enddiagnostic ( false ) ;
  } 
  switch ( mem [p ].hhfield .b0 ) 
  {case 13 : 
  case 14 : 
    oldp = tarnished ( p ) ;
    break ;
  case 19 : 
    oldp = 1 ;
    break ;
    default: 
    oldp = 0 ;
    break ;
  } 
  if ( oldp != 0 ) 
  {
    q = stashcurexp () ;
    oldp = p ;
    makeexpcopy ( oldp ) ;
    p = stashcurexp () ;
    unstashcurexp ( q ) ;
  } 
  switch ( curtype ) 
  {case 13 : 
  case 14 : 
    oldexp = tarnished ( curexp ) ;
    break ;
  case 19 : 
    oldexp = 1 ;
    break ;
    default: 
    oldexp = 0 ;
    break ;
  } 
  if ( oldexp != 0 ) 
  {
    oldexp = curexp ;
    makeexpcopy ( oldexp ) ;
  } 
  switch ( c ) 
  {case 69 : 
  case 70 : 
    if ( ( curtype < 14 ) || ( mem [p ].hhfield .b0 < 14 ) ) 
    if ( ( curtype == 11 ) && ( mem [p ].hhfield .b0 == 11 ) ) 
    {
      if ( c == 70 ) 
      negateedges ( curexp ) ;
      curedges = curexp ;
      mergeedges ( mem [p + 1 ].cint ) ;
    } 
    else badbinary ( p , c ) ;
    else if ( curtype == 14 ) 
    if ( mem [p ].hhfield .b0 != 14 ) 
    badbinary ( p , c ) ;
    else {
	
      q = mem [p + 1 ].cint ;
      r = mem [curexp + 1 ].cint ;
      addorsubtract ( q , r , c ) ;
      addorsubtract ( q + 2 , r + 2 , c ) ;
    } 
    else if ( mem [p ].hhfield .b0 == 14 ) 
    badbinary ( p , c ) ;
    else addorsubtract ( p , 0 , c ) ;
    break ;
  case 77 : 
  case 78 : 
  case 79 : 
  case 80 : 
  case 81 : 
  case 82 : 
    {
      if ( ( curtype > 14 ) && ( mem [p ].hhfield .b0 > 14 ) ) 
      addorsubtract ( p , 0 , 70 ) ;
      else if ( curtype != mem [p ].hhfield .b0 ) 
      {
	badbinary ( p , c ) ;
	goto lab30 ;
      } 
      else if ( curtype == 4 ) 
      flushcurexp ( strvsstr ( mem [p + 1 ].cint , curexp ) ) ;
      else if ( ( curtype == 5 ) || ( curtype == 3 ) ) 
      {
	q = mem [curexp + 1 ].cint ;
	while ( ( q != curexp ) && ( q != p ) ) q = mem [q + 1 ].cint ;
	if ( q == p ) 
	flushcurexp ( 0 ) ;
      } 
      else if ( ( curtype == 14 ) || ( curtype == 13 ) ) 
      {
	q = mem [p + 1 ].cint ;
	r = mem [curexp + 1 ].cint ;
	rr = r + bignodesize [curtype ]- 2 ;
	while ( true ) {
	    
	  addorsubtract ( q , r , 70 ) ;
	  if ( mem [r ].hhfield .b0 != 16 ) 
	  goto lab31 ;
	  if ( mem [r + 1 ].cint != 0 ) 
	  goto lab31 ;
	  if ( r == rr ) 
	  goto lab31 ;
	  q = q + 2 ;
	  r = r + 2 ;
	} 
	lab31: takepart ( 53 + half ( r - mem [curexp + 1 ].cint ) ) ;
      } 
      else if ( curtype == 2 ) 
      flushcurexp ( curexp - mem [p + 1 ].cint ) ;
      else {
	  
	badbinary ( p , c ) ;
	goto lab30 ;
      } 
      if ( curtype != 16 ) 
      {
	if ( curtype < 16 ) 
	{
	  disperr ( p , 261 ) ;
	  {
	    helpptr = 1 ;
	    helpline [0 ]= 851 ;
	  } 
	} 
	else {
	    
	  helpptr = 2 ;
	  helpline [1 ]= 852 ;
	  helpline [0 ]= 853 ;
	} 
	disperr ( 0 , 854 ) ;
	putgetflusherror ( 31 ) ;
      } 
      else switch ( c ) 
      {case 77 : 
	if ( curexp < 0 ) 
	curexp = 30 ;
	else curexp = 31 ;
	break ;
      case 78 : 
	if ( curexp <= 0 ) 
	curexp = 30 ;
	else curexp = 31 ;
	break ;
      case 79 : 
	if ( curexp > 0 ) 
	curexp = 30 ;
	else curexp = 31 ;
	break ;
      case 80 : 
	if ( curexp >= 0 ) 
	curexp = 30 ;
	else curexp = 31 ;
	break ;
      case 81 : 
	if ( curexp == 0 ) 
	curexp = 30 ;
	else curexp = 31 ;
	break ;
      case 82 : 
	if ( curexp != 0 ) 
	curexp = 30 ;
	else curexp = 31 ;
	break ;
      } 
      curtype = 2 ;
      lab30: ;
    } 
    break ;
  case 76 : 
  case 75 : 
    if ( ( mem [p ].hhfield .b0 != 2 ) || ( curtype != 2 ) ) 
    badbinary ( p , c ) ;
    else if ( mem [p + 1 ].cint == c - 45 ) 
    curexp = mem [p + 1 ].cint ;
    break ;
  case 71 : 
    if ( ( curtype < 14 ) || ( mem [p ].hhfield .b0 < 14 ) ) 
    badbinary ( p , 71 ) ;
    else if ( ( curtype == 16 ) || ( mem [p ].hhfield .b0 == 16 ) ) 
    {
      if ( mem [p ].hhfield .b0 == 16 ) 
      {
	v = mem [p + 1 ].cint ;
	freenode ( p , 2 ) ;
      } 
      else {
	  
	v = curexp ;
	unstashcurexp ( p ) ;
      } 
      if ( curtype == 16 ) 
      curexp = takescaled ( curexp , v ) ;
      else if ( curtype == 14 ) 
      {
	p = mem [curexp + 1 ].cint ;
	depmult ( p , v , true ) ;
	depmult ( p + 2 , v , true ) ;
      } 
      else depmult ( 0 , v , true ) ;
      goto lab10 ;
    } 
    else if ( ( nicepair ( p , mem [p ].hhfield .b0 ) && ( curtype > 14 ) ) 
    || ( nicepair ( curexp , curtype ) && ( mem [p ].hhfield .b0 > 14 ) ) ) 
    {
      hardtimes ( p ) ;
      goto lab10 ;
    } 
    else badbinary ( p , 71 ) ;
    break ;
  case 72 : 
    if ( ( curtype != 16 ) || ( mem [p ].hhfield .b0 < 14 ) ) 
    badbinary ( p , 72 ) ;
    else {
	
      v = curexp ;
      unstashcurexp ( p ) ;
      if ( v == 0 ) 
      {
	disperr ( 0 , 784 ) ;
	{
	  helpptr = 2 ;
	  helpline [1 ]= 856 ;
	  helpline [0 ]= 857 ;
	} 
	putgeterror () ;
      } 
      else {
	  
	if ( curtype == 16 ) 
	curexp = makescaled ( curexp , v ) ;
	else if ( curtype == 14 ) 
	{
	  p = mem [curexp + 1 ].cint ;
	  depdiv ( p , v ) ;
	  depdiv ( p + 2 , v ) ;
	} 
	else depdiv ( 0 , v ) ;
      } 
      goto lab10 ;
    } 
    break ;
  case 73 : 
  case 74 : 
    if ( ( curtype == 16 ) && ( mem [p ].hhfield .b0 == 16 ) ) 
    if ( c == 73 ) 
    curexp = pythadd ( mem [p + 1 ].cint , curexp ) ;
    else curexp = pythsub ( mem [p + 1 ].cint , curexp ) ;
    else badbinary ( p , c ) ;
    break ;
  case 84 : 
  case 85 : 
  case 86 : 
  case 87 : 
  case 88 : 
  case 89 : 
  case 90 : 
  case 91 : 
    if ( ( mem [p ].hhfield .b0 == 9 ) || ( mem [p ].hhfield .b0 == 8 ) || 
    ( mem [p ].hhfield .b0 == 6 ) ) 
    {
      pathtrans ( p , c ) ;
      goto lab10 ;
    } 
    else if ( ( mem [p ].hhfield .b0 == 14 ) || ( mem [p ].hhfield .b0 == 
    13 ) ) 
    bigtrans ( p , c ) ;
    else if ( mem [p ].hhfield .b0 == 11 ) 
    {
      edgestrans ( p , c ) ;
      goto lab10 ;
    } 
    else badbinary ( p , c ) ;
    break ;
  case 83 : 
    if ( ( curtype == 4 ) && ( mem [p ].hhfield .b0 == 4 ) ) 
    cat ( p ) ;
    else badbinary ( p , 83 ) ;
    break ;
  case 94 : 
    if ( nicepair ( p , mem [p ].hhfield .b0 ) && ( curtype == 4 ) ) 
    chopstring ( mem [p + 1 ].cint ) ;
    else badbinary ( p , 94 ) ;
    break ;
  case 95 : 
    {
      if ( curtype == 14 ) 
      pairtopath () ;
      if ( nicepair ( p , mem [p ].hhfield .b0 ) && ( curtype == 9 ) ) 
      choppath ( mem [p + 1 ].cint ) ;
      else badbinary ( p , 95 ) ;
    } 
    break ;
  case 97 : 
  case 98 : 
  case 99 : 
    {
      if ( curtype == 14 ) 
      pairtopath () ;
      if ( ( curtype == 9 ) && ( mem [p ].hhfield .b0 == 16 ) ) 
      findpoint ( mem [p + 1 ].cint , c ) ;
      else badbinary ( p , c ) ;
    } 
    break ;
  case 100 : 
    {
      if ( curtype == 8 ) 
      materializepen () ;
      if ( ( curtype == 6 ) && nicepair ( p , mem [p ].hhfield .b0 ) ) 
      setupoffset ( mem [p + 1 ].cint ) ;
      else badbinary ( p , 100 ) ;
    } 
    break ;
  case 96 : 
    {
      if ( curtype == 14 ) 
      pairtopath () ;
      if ( ( curtype == 9 ) && nicepair ( p , mem [p ].hhfield .b0 ) ) 
      setupdirectiontime ( mem [p + 1 ].cint ) ;
      else badbinary ( p , 96 ) ;
    } 
    break ;
  case 92 : 
    {
      if ( mem [p ].hhfield .b0 == 14 ) 
      {
	q = stashcurexp () ;
	unstashcurexp ( p ) ;
	pairtopath () ;
	p = stashcurexp () ;
	unstashcurexp ( q ) ;
      } 
      if ( curtype == 14 ) 
      pairtopath () ;
      if ( ( curtype == 9 ) && ( mem [p ].hhfield .b0 == 9 ) ) 
      {
	pathintersection ( mem [p + 1 ].cint , curexp ) ;
	pairvalue ( curt , curtt ) ;
      } 
      else badbinary ( p , 92 ) ;
    } 
    break ;
  } 
  recyclevalue ( p ) ;
  freenode ( p , 2 ) ;
  lab10: {
      
    if ( aritherror ) 
    cleararith () ;
  } 
  if ( oldp != 0 ) 
  {
    recyclevalue ( oldp ) ;
    freenode ( oldp , 2 ) ;
  } 
  if ( oldexp != 0 ) 
  {
    recyclevalue ( oldexp ) ;
    freenode ( oldexp , 2 ) ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
zfracmult ( scaled n , scaled d ) 
#else
zfracmult ( n , d ) 
  scaled n ;
  scaled d ;
#endif
{
  halfword p  ;
  halfword oldexp  ;
  fraction v  ;
  if ( internal [7 ]> 131072L ) 
  {
    begindiagnostic () ;
    printnl ( 850 ) ;
    printscaled ( n ) ;
    printchar ( 47 ) ;
    printscaled ( d ) ;
    print ( 855 ) ;
    printexp ( 0 , 0 ) ;
    print ( 842 ) ;
    enddiagnostic ( false ) ;
  } 
  switch ( curtype ) 
  {case 13 : 
  case 14 : 
    oldexp = tarnished ( curexp ) ;
    break ;
  case 19 : 
    oldexp = 1 ;
    break ;
    default: 
    oldexp = 0 ;
    break ;
  } 
  if ( oldexp != 0 ) 
  {
    oldexp = curexp ;
    makeexpcopy ( oldexp ) ;
  } 
  v = makefraction ( n , d ) ;
  if ( curtype == 16 ) 
  curexp = takefraction ( curexp , v ) ;
  else if ( curtype == 14 ) 
  {
    p = mem [curexp + 1 ].cint ;
    depmult ( p , v , false ) ;
    depmult ( p + 2 , v , false ) ;
  } 
  else depmult ( 0 , v , false ) ;
  if ( oldexp != 0 ) 
  {
    recyclevalue ( oldexp ) ;
    freenode ( oldexp , 2 ) ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
gfswap ( void ) 
#else
gfswap ( ) 
#endif
{
  if ( gflimit == gfbufsize ) 
  {
    writegf ( 0 , halfbuf - 1 ) ;
    gflimit = halfbuf ;
    gfoffset = gfoffset + gfbufsize ;
    gfptr = 0 ;
  } 
  else {
      
    writegf ( halfbuf , gfbufsize - 1 ) ;
    gflimit = gfbufsize ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
zgffour ( integer x ) 
#else
zgffour ( x ) 
  integer x ;
#endif
{
  if ( x >= 0 ) 
  {
    gfbuf [gfptr ]= x / 16777216L ;
    incr ( gfptr ) ;
    if ( gfptr == gflimit ) 
    gfswap () ;
  } 
  else {
      
    x = x + 1073741824L ;
    x = x + 1073741824L ;
    {
      gfbuf [gfptr ]= ( x / 16777216L ) + 128 ;
      incr ( gfptr ) ;
      if ( gfptr == gflimit ) 
      gfswap () ;
    } 
  } 
  x = x % 16777216L ;
  {
    gfbuf [gfptr ]= x / 65536L ;
    incr ( gfptr ) ;
    if ( gfptr == gflimit ) 
    gfswap () ;
  } 
  x = x % 65536L ;
  {
    gfbuf [gfptr ]= x / 256 ;
    incr ( gfptr ) ;
    if ( gfptr == gflimit ) 
    gfswap () ;
  } 
  {
    gfbuf [gfptr ]= x % 256 ;
    incr ( gfptr ) ;
    if ( gfptr == gflimit ) 
    gfswap () ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
zgftwo ( integer x ) 
#else
zgftwo ( x ) 
  integer x ;
#endif
{
  {
    gfbuf [gfptr ]= x / 256 ;
    incr ( gfptr ) ;
    if ( gfptr == gflimit ) 
    gfswap () ;
  } 
  {
    gfbuf [gfptr ]= x % 256 ;
    incr ( gfptr ) ;
    if ( gfptr == gflimit ) 
    gfswap () ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
zgfthree ( integer x ) 
#else
zgfthree ( x ) 
  integer x ;
#endif
{
  {
    gfbuf [gfptr ]= x / 65536L ;
    incr ( gfptr ) ;
    if ( gfptr == gflimit ) 
    gfswap () ;
  } 
  {
    gfbuf [gfptr ]= ( x % 65536L ) / 256 ;
    incr ( gfptr ) ;
    if ( gfptr == gflimit ) 
    gfswap () ;
  } 
  {
    gfbuf [gfptr ]= x % 256 ;
    incr ( gfptr ) ;
    if ( gfptr == gflimit ) 
    gfswap () ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
zgfpaint ( integer d ) 
#else
zgfpaint ( d ) 
  integer d ;
#endif
{
  if ( d < 64 ) 
  {
    gfbuf [gfptr ]= 0 + d ;
    incr ( gfptr ) ;
    if ( gfptr == gflimit ) 
    gfswap () ;
  } 
  else if ( d < 256 ) 
  {
    {
      gfbuf [gfptr ]= 64 ;
      incr ( gfptr ) ;
      if ( gfptr == gflimit ) 
      gfswap () ;
    } 
    {
      gfbuf [gfptr ]= d ;
      incr ( gfptr ) ;
      if ( gfptr == gflimit ) 
      gfswap () ;
    } 
  } 
  else {
      
    {
      gfbuf [gfptr ]= 65 ;
      incr ( gfptr ) ;
      if ( gfptr == gflimit ) 
      gfswap () ;
    } 
    gftwo ( d ) ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
zgfstring ( strnumber s , strnumber t ) 
#else
zgfstring ( s , t ) 
  strnumber s ;
  strnumber t ;
#endif
{
  poolpointer k  ;
  integer l  ;
  if ( s != 0 ) 
  {
    l = ( strstart [s + 1 ]- strstart [s ]) ;
    if ( t != 0 ) 
    l = l + ( strstart [t + 1 ]- strstart [t ]) ;
    if ( l <= 255 ) 
    {
      {
	gfbuf [gfptr ]= 239 ;
	incr ( gfptr ) ;
	if ( gfptr == gflimit ) 
	gfswap () ;
      } 
      {
	gfbuf [gfptr ]= l ;
	incr ( gfptr ) ;
	if ( gfptr == gflimit ) 
	gfswap () ;
      } 
    } 
    else {
	
      {
	gfbuf [gfptr ]= 241 ;
	incr ( gfptr ) ;
	if ( gfptr == gflimit ) 
	gfswap () ;
      } 
      gfthree ( l ) ;
    } 
    {register integer for_end; k = strstart [s ];for_end = strstart [s + 
    1 ]- 1 ; if ( k <= for_end) do 
      {
	gfbuf [gfptr ]= strpool [k ];
	incr ( gfptr ) ;
	if ( gfptr == gflimit ) 
	gfswap () ;
      } 
    while ( k++ < for_end ) ;} 
  } 
  if ( t != 0 ) 
  {register integer for_end; k = strstart [t ];for_end = strstart [t + 1 
  ]- 1 ; if ( k <= for_end) do 
    {
      gfbuf [gfptr ]= strpool [k ];
      incr ( gfptr ) ;
      if ( gfptr == gflimit ) 
      gfswap () ;
    } 
  while ( k++ < for_end ) ;} 
} 
void 
#ifdef HAVE_PROTOTYPES
zgfboc ( integer minm , integer maxm , integer minn , integer maxn ) 
#else
zgfboc ( minm , maxm , minn , maxn ) 
  integer minm ;
  integer maxm ;
  integer minn ;
  integer maxn ;
#endif
{
  /* 10 */ if ( minm < gfminm ) 
  gfminm = minm ;
  if ( maxn > gfmaxn ) 
  gfmaxn = maxn ;
  if ( bocp == -1 ) 
  if ( bocc >= 0 ) 
  if ( bocc < 256 ) 
  if ( maxm - minm >= 0 ) 
  if ( maxm - minm < 256 ) 
  if ( maxm >= 0 ) 
  if ( maxm < 256 ) 
  if ( maxn - minn >= 0 ) 
  if ( maxn - minn < 256 ) 
  if ( maxn >= 0 ) 
  if ( maxn < 256 ) 
  {
    {
      gfbuf [gfptr ]= 68 ;
      incr ( gfptr ) ;
      if ( gfptr == gflimit ) 
      gfswap () ;
    } 
    {
      gfbuf [gfptr ]= bocc ;
      incr ( gfptr ) ;
      if ( gfptr == gflimit ) 
      gfswap () ;
    } 
    {
      gfbuf [gfptr ]= maxm - minm ;
      incr ( gfptr ) ;
      if ( gfptr == gflimit ) 
      gfswap () ;
    } 
    {
      gfbuf [gfptr ]= maxm ;
      incr ( gfptr ) ;
      if ( gfptr == gflimit ) 
      gfswap () ;
    } 
    {
      gfbuf [gfptr ]= maxn - minn ;
      incr ( gfptr ) ;
      if ( gfptr == gflimit ) 
      gfswap () ;
    } 
    {
      gfbuf [gfptr ]= maxn ;
      incr ( gfptr ) ;
      if ( gfptr == gflimit ) 
      gfswap () ;
    } 
    goto lab10 ;
  } 
  {
    gfbuf [gfptr ]= 67 ;
    incr ( gfptr ) ;
    if ( gfptr == gflimit ) 
    gfswap () ;
  } 
  gffour ( bocc ) ;
  gffour ( bocp ) ;
  gffour ( minm ) ;
  gffour ( maxm ) ;
  gffour ( minn ) ;
  gffour ( maxn ) ;
  lab10: ;
} 
void 
#ifdef HAVE_PROTOTYPES
initgf ( void ) 
#else
initgf ( ) 
#endif
{
  short k  ;
  integer t  ;
  gfminm = 4096 ;
  gfmaxm = -4096 ;
  gfminn = 4096 ;
  gfmaxn = -4096 ;
  {register integer for_end; k = 0 ;for_end = 255 ; if ( k <= for_end) do 
    charptr [k ]= -1 ;
  while ( k++ < for_end ) ;} 
  if ( internal [27 ]<= 0 ) 
  gfext = 1054 ;
  else {
      
    oldsetting = selector ;
    selector = 5 ;
    printchar ( 46 ) ;
    printint ( makescaled ( internal [27 ], 59429463L ) ) ;
    print ( 1055 ) ;
    gfext = makestring () ;
    selector = oldsetting ;
  } 
  {
    if ( jobname == 0 ) 
    openlogfile () ;
    packjobname ( gfext ) ;
    while ( ! bopenout ( gffile ) ) promptfilename ( 756 , gfext ) ;
    outputfilename = bmakenamestring ( gffile ) ;
  } 
  {
    gfbuf [gfptr ]= 247 ;
    incr ( gfptr ) ;
    if ( gfptr == gflimit ) 
    gfswap () ;
  } 
  {
    gfbuf [gfptr ]= 131 ;
    incr ( gfptr ) ;
    if ( gfptr == gflimit ) 
    gfswap () ;
  } 
  oldsetting = selector ;
  selector = 5 ;
  print ( 1053 ) ;
  printint ( roundunscaled ( internal [14 ]) ) ;
  printchar ( 46 ) ;
  printdd ( roundunscaled ( internal [15 ]) ) ;
  printchar ( 46 ) ;
  printdd ( roundunscaled ( internal [16 ]) ) ;
  printchar ( 58 ) ;
  t = roundunscaled ( internal [17 ]) ;
  printdd ( t / 60 ) ;
  printdd ( t % 60 ) ;
  selector = oldsetting ;
  {
    gfbuf [gfptr ]= ( poolptr - strstart [strptr ]) ;
    incr ( gfptr ) ;
    if ( gfptr == gflimit ) 
    gfswap () ;
  } 
  gfstring ( 0 , makestring () ) ;
  decr ( strptr ) ;
  poolptr = strstart [strptr ];
  gfprevptr = gfoffset + gfptr ;
} 
void 
#ifdef HAVE_PROTOTYPES
zshipout ( eightbits c ) 
#else
zshipout ( c ) 
  eightbits c ;
#endif
{
  /* 30 */ integer f  ;
  integer prevm, m, mm  ;
  integer prevn, n  ;
  halfword p, q  ;
  integer prevw, w, ww  ;
  integer d  ;
  integer delta  ;
  integer curminm  ;
  integer xoff, yoff  ;
  if ( outputfilename == 0 ) 
  initgf () ;
  f = roundunscaled ( internal [19 ]) ;
  xoff = roundunscaled ( internal [29 ]) ;
  yoff = roundunscaled ( internal [30 ]) ;
  if ( termoffset > maxprintline - 9 ) 
  println () ;
  else if ( ( termoffset > 0 ) || ( fileoffset > 0 ) ) 
  printchar ( 32 ) ;
  printchar ( 91 ) ;
  printint ( c ) ;
  if ( f != 0 ) 
  {
    printchar ( 46 ) ;
    printint ( f ) ;
  } 
  fflush ( stdout ) ;
  bocc = 256 * f + c ;
  bocp = charptr [c ];
  charptr [c ]= gfprevptr ;
  if ( internal [34 ]> 0 ) 
  {
    if ( xoff != 0 ) 
    {
      gfstring ( 437 , 0 ) ;
      {
	gfbuf [gfptr ]= 243 ;
	incr ( gfptr ) ;
	if ( gfptr == gflimit ) 
	gfswap () ;
      } 
      gffour ( xoff * 65536L ) ;
    } 
    if ( yoff != 0 ) 
    {
      gfstring ( 438 , 0 ) ;
      {
	gfbuf [gfptr ]= 243 ;
	incr ( gfptr ) ;
	if ( gfptr == gflimit ) 
	gfswap () ;
      } 
      gffour ( yoff * 65536L ) ;
    } 
  } 
  prevn = 4096 ;
  p = mem [curedges ].hhfield .lhfield ;
  n = mem [curedges + 1 ].hhfield .v.RH - 4096 ;
  while ( p != curedges ) {
      
    if ( mem [p + 1 ].hhfield .lhfield > 1 ) 
    sortedges ( p ) ;
    q = mem [p + 1 ].hhfield .v.RH ;
    w = 0 ;
    prevm = -268435456L ;
    ww = 0 ;
    prevw = 0 ;
    m = prevm ;
    do {
	if ( q == memtop ) 
      mm = 268435456L ;
      else {
	  
	d = mem [q ].hhfield .lhfield ;
	mm = d / 8 ;
	ww = ww + ( d % 8 ) - 4 ;
      } 
      if ( mm != m ) 
      {
	if ( prevw <= 0 ) 
	{
	  if ( w > 0 ) 
	  {
	    if ( prevm == -268435456L ) 
	    {
	      if ( prevn == 4096 ) 
	      {
		gfboc ( mem [curedges + 2 ].hhfield .lhfield + xoff - 4096 , 
		mem [curedges + 2 ].hhfield .v.RH + xoff - 4096 , mem [
		curedges + 1 ].hhfield .lhfield + yoff - 4096 , n + yoff ) ;
		curminm = mem [curedges + 2 ].hhfield .lhfield - 4096 + mem 
		[curedges + 3 ].hhfield .lhfield ;
	      } 
	      else if ( prevn > n + 1 ) 
	      {
		delta = prevn - n - 1 ;
		if ( delta < 256 ) 
		{
		  {
		    gfbuf [gfptr ]= 71 ;
		    incr ( gfptr ) ;
		    if ( gfptr == gflimit ) 
		    gfswap () ;
		  } 
		  {
		    gfbuf [gfptr ]= delta ;
		    incr ( gfptr ) ;
		    if ( gfptr == gflimit ) 
		    gfswap () ;
		  } 
		} 
		else {
		    
		  {
		    gfbuf [gfptr ]= 72 ;
		    incr ( gfptr ) ;
		    if ( gfptr == gflimit ) 
		    gfswap () ;
		  } 
		  gftwo ( delta ) ;
		} 
	      } 
	      else {
		  
		delta = m - curminm ;
		if ( delta > 164 ) 
		{
		  gfbuf [gfptr ]= 70 ;
		  incr ( gfptr ) ;
		  if ( gfptr == gflimit ) 
		  gfswap () ;
		} 
		else {
		    
		  {
		    gfbuf [gfptr ]= 74 + delta ;
		    incr ( gfptr ) ;
		    if ( gfptr == gflimit ) 
		    gfswap () ;
		  } 
		  goto lab30 ;
		} 
	      } 
	      gfpaint ( m - curminm ) ;
	      lab30: prevn = n ;
	    } 
	    else gfpaint ( m - prevm ) ;
	    prevm = m ;
	    prevw = w ;
	  } 
	} 
	else if ( w <= 0 ) 
	{
	  gfpaint ( m - prevm ) ;
	  prevm = m ;
	  prevw = w ;
	} 
	m = mm ;
      } 
      w = ww ;
      q = mem [q ].hhfield .v.RH ;
    } while ( ! ( mm == 268435456L ) ) ;
    if ( w != 0 ) 
    printnl ( 1057 ) ;
    if ( prevm - intcast ( mem [curedges + 3 ].hhfield .lhfield ) + xoff > 
    gfmaxm ) 
    gfmaxm = prevm - mem [curedges + 3 ].hhfield .lhfield + xoff ;
    p = mem [p ].hhfield .lhfield ;
    decr ( n ) ;
  } 
  if ( prevn == 4096 ) 
  {
    gfboc ( 0 , 0 , 0 , 0 ) ;
    if ( gfmaxm < 0 ) 
    gfmaxm = 0 ;
    if ( gfminn > 0 ) 
    gfminn = 0 ;
  } 
  else if ( prevn + yoff < gfminn ) 
  gfminn = prevn + yoff ;
  {
    gfbuf [gfptr ]= 69 ;
    incr ( gfptr ) ;
    if ( gfptr == gflimit ) 
    gfswap () ;
  } 
  gfprevptr = gfoffset + gfptr ;
  incr ( totalchars ) ;
  printchar ( 93 ) ;
  fflush ( stdout ) ;
  mfluaprintedges ( 1056 , true , xoff , yoff ) ;
  if ( internal [11 ]> 0 ) 
  printedges ( 1056 , true , xoff , yoff ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
ztryeq ( halfword l , halfword r ) 
#else
ztryeq ( l , r ) 
  halfword l ;
  halfword r ;
#endif
{
  /* 30 31 */ halfword p  ;
  char t  ;
  halfword q  ;
  halfword pp  ;
  char tt  ;
  boolean copied  ;
  t = mem [l ].hhfield .b0 ;
  if ( t == 16 ) 
  {
    t = 17 ;
    p = constdependency ( - (integer) mem [l + 1 ].cint ) ;
    q = p ;
  } 
  else if ( t == 19 ) 
  {
    t = 17 ;
    p = singledependency ( l ) ;
    mem [p + 1 ].cint = - (integer) mem [p + 1 ].cint ;
    q = depfinal ;
  } 
  else {
      
    p = mem [l + 1 ].hhfield .v.RH ;
    q = p ;
    while ( true ) {
	
      mem [q + 1 ].cint = - (integer) mem [q + 1 ].cint ;
      if ( mem [q ].hhfield .lhfield == 0 ) 
      goto lab30 ;
      q = mem [q ].hhfield .v.RH ;
    } 
    lab30: mem [mem [l + 1 ].hhfield .lhfield ].hhfield .v.RH = mem [q ]
    .hhfield .v.RH ;
    mem [mem [q ].hhfield .v.RH + 1 ].hhfield .lhfield = mem [l + 1 ]
    .hhfield .lhfield ;
    mem [l ].hhfield .b0 = 16 ;
  } 
  if ( r == 0 ) 
  if ( curtype == 16 ) 
  {
    mem [q + 1 ].cint = mem [q + 1 ].cint + curexp ;
    goto lab31 ;
  } 
  else {
      
    tt = curtype ;
    if ( tt == 19 ) 
    pp = singledependency ( curexp ) ;
    else pp = mem [curexp + 1 ].hhfield .v.RH ;
  } 
  else if ( mem [r ].hhfield .b0 == 16 ) 
  {
    mem [q + 1 ].cint = mem [q + 1 ].cint + mem [r + 1 ].cint ;
    goto lab31 ;
  } 
  else {
      
    tt = mem [r ].hhfield .b0 ;
    if ( tt == 19 ) 
    pp = singledependency ( r ) ;
    else pp = mem [r + 1 ].hhfield .v.RH ;
  } 
  if ( tt != 19 ) 
  copied = false ;
  else {
      
    copied = true ;
    tt = 17 ;
  } 
  watchcoefs = false ;
  if ( t == tt ) 
  p = pplusq ( p , pp , t ) ;
  else if ( t == 18 ) 
  p = pplusfq ( p , 65536L , pp , 18 , 17 ) ;
  else {
      
    q = p ;
    while ( mem [q ].hhfield .lhfield != 0 ) {
	
      mem [q + 1 ].cint = roundfraction ( mem [q + 1 ].cint ) ;
      q = mem [q ].hhfield .v.RH ;
    } 
    t = 18 ;
    p = pplusq ( p , pp , t ) ;
  } 
  watchcoefs = true ;
  if ( copied ) 
  flushnodelist ( pp ) ;
  lab31: ;
  if ( mem [p ].hhfield .lhfield == 0 ) 
  {
    if ( abs ( mem [p + 1 ].cint ) > 64 ) 
    {
      {
	if ( interaction == 3 ) 
	;
	if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	{
	  printnl ( 261 ) ;
	  print ( fullsourcefilenamestack [inopen ]) ;
	  print ( 58 ) ;
	  printint ( line ) ;
	  print ( 262 ) ;
	  print ( 897 ) ;
	} 
	else {
	    
	  printnl ( 263 ) ;
	  print ( 897 ) ;
	} 
      } 
      print ( 899 ) ;
      printscaled ( mem [p + 1 ].cint ) ;
      printchar ( 41 ) ;
      {
	helpptr = 2 ;
	helpline [1 ]= 898 ;
	helpline [0 ]= 896 ;
      } 
      putgeterror () ;
    } 
    else if ( r == 0 ) 
    {
      {
	if ( interaction == 3 ) 
	;
	if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	{
	  printnl ( 261 ) ;
	  print ( fullsourcefilenamestack [inopen ]) ;
	  print ( 58 ) ;
	  printint ( line ) ;
	  print ( 262 ) ;
	  print ( 600 ) ;
	} 
	else {
	    
	  printnl ( 263 ) ;
	  print ( 600 ) ;
	} 
      } 
      {
	helpptr = 2 ;
	helpline [1 ]= 601 ;
	helpline [0 ]= 602 ;
      } 
      putgeterror () ;
    } 
    freenode ( p , 2 ) ;
  } 
  else {
      
    lineareq ( p , t ) ;
    if ( r == 0 ) 
    if ( curtype != 16 ) 
    if ( mem [curexp ].hhfield .b0 == 16 ) 
    {
      pp = curexp ;
      curexp = mem [curexp + 1 ].cint ;
      curtype = 16 ;
      freenode ( pp , 2 ) ;
    } 
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
zmakeeq ( halfword lhs ) 
#else
zmakeeq ( lhs ) 
  halfword lhs ;
#endif
{
  /* 20 30 45 */ smallnumber t  ;
  integer v  ;
  halfword p, q  ;
  lab20: t = mem [lhs ].hhfield .b0 ;
  if ( t <= 14 ) 
  v = mem [lhs + 1 ].cint ;
  switch ( t ) 
  {case 2 : 
  case 4 : 
  case 6 : 
  case 9 : 
  case 11 : 
    if ( curtype == t + 1 ) 
    {
      nonlineareq ( v , curexp , false ) ;
      unstashcurexp ( curexp ) ;
      goto lab30 ;
    } 
    else if ( curtype == t ) 
    {
      if ( curtype <= 4 ) 
      {
	if ( curtype == 4 ) 
	{
	  if ( strvsstr ( v , curexp ) != 0 ) 
	  goto lab45 ;
	} 
	else if ( v != curexp ) 
	goto lab45 ;
	{
	  {
	    if ( interaction == 3 ) 
	    ;
	    if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	    {
	      printnl ( 261 ) ;
	      print ( fullsourcefilenamestack [inopen ]) ;
	      print ( 58 ) ;
	      printint ( line ) ;
	      print ( 262 ) ;
	      print ( 600 ) ;
	    } 
	    else {
		
	      printnl ( 263 ) ;
	      print ( 600 ) ;
	    } 
	  } 
	  {
	    helpptr = 2 ;
	    helpline [1 ]= 601 ;
	    helpline [0 ]= 602 ;
	  } 
	  putgeterror () ;
	} 
	goto lab30 ;
      } 
      {
	if ( interaction == 3 ) 
	;
	if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	{
	  printnl ( 261 ) ;
	  print ( fullsourcefilenamestack [inopen ]) ;
	  print ( 58 ) ;
	  printint ( line ) ;
	  print ( 262 ) ;
	  print ( 894 ) ;
	} 
	else {
	    
	  printnl ( 263 ) ;
	  print ( 894 ) ;
	} 
      } 
      {
	helpptr = 2 ;
	helpline [1 ]= 895 ;
	helpline [0 ]= 896 ;
      } 
      putgeterror () ;
      goto lab30 ;
      lab45: {
	  
	if ( interaction == 3 ) 
	;
	if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	{
	  printnl ( 261 ) ;
	  print ( fullsourcefilenamestack [inopen ]) ;
	  print ( 58 ) ;
	  printint ( line ) ;
	  print ( 262 ) ;
	  print ( 897 ) ;
	} 
	else {
	    
	  printnl ( 263 ) ;
	  print ( 897 ) ;
	} 
      } 
      {
	helpptr = 2 ;
	helpline [1 ]= 898 ;
	helpline [0 ]= 896 ;
      } 
      putgeterror () ;
      goto lab30 ;
    } 
    break ;
  case 3 : 
  case 5 : 
  case 7 : 
  case 12 : 
  case 10 : 
    if ( curtype == t - 1 ) 
    {
      nonlineareq ( curexp , lhs , true ) ;
      goto lab30 ;
    } 
    else if ( curtype == t ) 
    {
      ringmerge ( lhs , curexp ) ;
      goto lab30 ;
    } 
    else if ( curtype == 14 ) 
    if ( t == 10 ) 
    {
      pairtopath () ;
      goto lab20 ;
    } 
    break ;
  case 13 : 
  case 14 : 
    if ( curtype == t ) 
    {
      p = v + bignodesize [t ];
      q = mem [curexp + 1 ].cint + bignodesize [t ];
      do {
	  p = p - 2 ;
	q = q - 2 ;
	tryeq ( p , q ) ;
      } while ( ! ( p == v ) ) ;
      goto lab30 ;
    } 
    break ;
  case 16 : 
  case 17 : 
  case 18 : 
  case 19 : 
    if ( curtype >= 16 ) 
    {
      tryeq ( lhs , 0 ) ;
      goto lab30 ;
    } 
    break ;
  case 1 : 
    ;
    break ;
  } 
  disperr ( lhs , 261 ) ;
  disperr ( 0 , 891 ) ;
  if ( mem [lhs ].hhfield .b0 <= 14 ) 
  printtype ( mem [lhs ].hhfield .b0 ) ;
  else print ( 340 ) ;
  printchar ( 61 ) ;
  if ( curtype <= 14 ) 
  printtype ( curtype ) ;
  else print ( 340 ) ;
  printchar ( 41 ) ;
  {
    helpptr = 2 ;
    helpline [1 ]= 892 ;
    helpline [0 ]= 893 ;
  } 
  putgeterror () ;
  lab30: {
      
    if ( aritherror ) 
    cleararith () ;
  } 
  recyclevalue ( lhs ) ;
  freenode ( lhs , 2 ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
doequation ( void ) 
#else
doequation ( ) 
#endif
{
  halfword lhs  ;
  halfword p  ;
  lhs = stashcurexp () ;
  getxnext () ;
  varflag = 77 ;
  scanexpression () ;
  if ( curcmd == 51 ) 
  doequation () ;
  else if ( curcmd == 77 ) 
  doassignment () ;
  if ( internal [7 ]> 131072L ) 
  {
    begindiagnostic () ;
    printnl ( 850 ) ;
    printexp ( lhs , 0 ) ;
    print ( 886 ) ;
    printexp ( 0 , 0 ) ;
    print ( 842 ) ;
    enddiagnostic ( false ) ;
  } 
  if ( curtype == 10 ) 
  if ( mem [lhs ].hhfield .b0 == 14 ) 
  {
    p = stashcurexp () ;
    unstashcurexp ( lhs ) ;
    lhs = p ;
  } 
  makeeq ( lhs ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
doassignment ( void ) 
#else
doassignment ( ) 
#endif
{
  halfword lhs  ;
  halfword p  ;
  halfword q  ;
  if ( curtype != 20 ) 
  {
    disperr ( 0 , 883 ) ;
    {
      helpptr = 2 ;
      helpline [1 ]= 884 ;
      helpline [0 ]= 885 ;
    } 
    error () ;
    doequation () ;
  } 
  else {
      
    lhs = curexp ;
    curtype = 1 ;
    getxnext () ;
    varflag = 77 ;
    scanexpression () ;
    if ( curcmd == 51 ) 
    doequation () ;
    else if ( curcmd == 77 ) 
    doassignment () ;
    if ( internal [7 ]> 131072L ) 
    {
      begindiagnostic () ;
      printnl ( 123 ) ;
      if ( mem [lhs ].hhfield .lhfield > 9769 ) 
      slowprint ( intname [mem [lhs ].hhfield .lhfield - ( 9769 ) ]) ;
      else showtokenlist ( lhs , 0 , 1000 , 0 ) ;
      print ( 461 ) ;
      printexp ( 0 , 0 ) ;
      printchar ( 125 ) ;
      enddiagnostic ( false ) ;
    } 
    if ( mem [lhs ].hhfield .lhfield > 9769 ) 
    if ( curtype == 16 ) 
    internal [mem [lhs ].hhfield .lhfield - ( 9769 ) ]= curexp ;
    else {
	
      disperr ( 0 , 887 ) ;
      slowprint ( intname [mem [lhs ].hhfield .lhfield - ( 9769 ) ]) ;
      print ( 888 ) ;
      {
	helpptr = 2 ;
	helpline [1 ]= 889 ;
	helpline [0 ]= 890 ;
      } 
      putgeterror () ;
    } 
    else {
	
      p = findvariable ( lhs ) ;
      if ( p != 0 ) 
      {
	q = stashcurexp () ;
	curtype = undtype ( p ) ;
	recyclevalue ( p ) ;
	mem [p ].hhfield .b0 = curtype ;
	mem [p + 1 ].cint = 0 ;
	makeexpcopy ( p ) ;
	p = stashcurexp () ;
	unstashcurexp ( q ) ;
	makeeq ( p ) ;
      } 
      else {
	  
	obliterated ( lhs ) ;
	putgeterror () ;
      } 
    } 
    flushnodelist ( lhs ) ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
dotypedeclaration ( void ) 
#else
dotypedeclaration ( ) 
#endif
{
  smallnumber t  ;
  halfword p  ;
  halfword q  ;
  if ( curmod >= 13 ) 
  t = curmod ;
  else t = curmod + 1 ;
  do {
      p = scandeclaredvariable () ;
    flushvariable ( eqtb [mem [p ].hhfield .lhfield ].v.RH , mem [p ]
    .hhfield .v.RH , false ) ;
    q = findvariable ( p ) ;
    if ( q != 0 ) 
    {
      mem [q ].hhfield .b0 = t ;
      mem [q + 1 ].cint = 0 ;
    } 
    else {
	
      {
	if ( interaction == 3 ) 
	;
	if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	{
	  printnl ( 261 ) ;
	  print ( fullsourcefilenamestack [inopen ]) ;
	  print ( 58 ) ;
	  printint ( line ) ;
	  print ( 262 ) ;
	  print ( 900 ) ;
	} 
	else {
	    
	  printnl ( 263 ) ;
	  print ( 900 ) ;
	} 
      } 
      {
	helpptr = 2 ;
	helpline [1 ]= 901 ;
	helpline [0 ]= 902 ;
      } 
      putgeterror () ;
    } 
    flushlist ( p ) ;
    if ( curcmd < 82 ) 
    {
      {
	if ( interaction == 3 ) 
	;
	if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	{
	  printnl ( 261 ) ;
	  print ( fullsourcefilenamestack [inopen ]) ;
	  print ( 58 ) ;
	  printint ( line ) ;
	  print ( 262 ) ;
	  print ( 903 ) ;
	} 
	else {
	    
	  printnl ( 263 ) ;
	  print ( 903 ) ;
	} 
      } 
      {
	helpptr = 5 ;
	helpline [4 ]= 904 ;
	helpline [3 ]= 905 ;
	helpline [2 ]= 906 ;
	helpline [1 ]= 907 ;
	helpline [0 ]= 908 ;
      } 
      if ( curcmd == 42 ) 
      helpline [2 ]= 909 ;
      putgeterror () ;
      scannerstatus = 2 ;
      do {
	  getnext () ;
	if ( curcmd == 39 ) 
	{
	  if ( strref [curmod ]< 127 ) 
	  if ( strref [curmod ]> 1 ) 
	  decr ( strref [curmod ]) ;
	  else flushstring ( curmod ) ;
	} 
      } while ( ! ( curcmd >= 82 ) ) ;
      scannerstatus = 0 ;
    } 
  } while ( ! ( curcmd > 82 ) ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
dorandomseed ( void ) 
#else
dorandomseed ( ) 
#endif
{
  getxnext () ;
  if ( curcmd != 77 ) 
  {
    missingerr ( 461 ) ;
    {
      helpptr = 1 ;
      helpline [0 ]= 914 ;
    } 
    backerror () ;
  } 
  getxnext () ;
  scanexpression () ;
  if ( curtype != 16 ) 
  {
    disperr ( 0 , 915 ) ;
    {
      helpptr = 2 ;
      helpline [1 ]= 916 ;
      helpline [0 ]= 917 ;
    } 
    putgetflusherror ( 0 ) ;
  } 
  else {
      
    initrandoms ( curexp ) ;
    if ( selector >= 2 ) 
    {
      oldsetting = selector ;
      selector = 2 ;
      printnl ( 918 ) ;
      printscaled ( curexp ) ;
      printchar ( 125 ) ;
      printnl ( 261 ) ;
      selector = oldsetting ;
    } 
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
doprotection ( void ) 
#else
doprotection ( ) 
#endif
{
  char m  ;
  halfword t  ;
  m = curmod ;
  do {
      getsymbol () ;
    t = eqtb [cursym ].lhfield ;
    if ( m == 0 ) 
    {
      if ( t >= 86 ) 
      eqtb [cursym ].lhfield = t - 86 ;
    } 
    else if ( t < 86 ) 
    eqtb [cursym ].lhfield = t + 86 ;
    getxnext () ;
  } while ( ! ( curcmd != 82 ) ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
defdelims ( void ) 
#else
defdelims ( ) 
#endif
{
  halfword ldelim, rdelim  ;
  getclearsymbol () ;
  ldelim = cursym ;
  getclearsymbol () ;
  rdelim = cursym ;
  eqtb [ldelim ].lhfield = 31 ;
  eqtb [ldelim ].v.RH = rdelim ;
  eqtb [rdelim ].lhfield = 62 ;
  eqtb [rdelim ].v.RH = ldelim ;
  getxnext () ;
} 
void 
#ifdef HAVE_PROTOTYPES
dointerim ( void ) 
#else
dointerim ( ) 
#endif
{
  getxnext () ;
  if ( curcmd != 40 ) 
  {
    {
      if ( interaction == 3 ) 
      ;
      if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
      {
	printnl ( 261 ) ;
	print ( fullsourcefilenamestack [inopen ]) ;
	print ( 58 ) ;
	printint ( line ) ;
	print ( 262 ) ;
	print ( 924 ) ;
      } 
      else {
	  
	printnl ( 263 ) ;
	print ( 924 ) ;
      } 
    } 
    if ( cursym == 0 ) 
    print ( 929 ) ;
    else slowprint ( hash [cursym ].v.RH ) ;
    print ( 930 ) ;
    {
      helpptr = 1 ;
      helpline [0 ]= 931 ;
    } 
    backerror () ;
  } 
  else {
      
    saveinternal ( curmod ) ;
    backinput () ;
  } 
  dostatement () ;
} 
void 
#ifdef HAVE_PROTOTYPES
dolet ( void ) 
#else
dolet ( ) 
#endif
{
  halfword l  ;
  getsymbol () ;
  l = cursym ;
  getxnext () ;
  if ( curcmd != 51 ) 
  if ( curcmd != 77 ) 
  {
    missingerr ( 61 ) ;
    {
      helpptr = 3 ;
      helpline [2 ]= 932 ;
      helpline [1 ]= 673 ;
      helpline [0 ]= 933 ;
    } 
    backerror () ;
  } 
  getsymbol () ;
  switch ( curcmd ) 
  {case 10 : 
  case 53 : 
  case 44 : 
  case 49 : 
    incr ( mem [curmod ].hhfield .lhfield ) ;
    break ;
    default: 
    ;
    break ;
  } 
  clearsymbol ( l , false ) ;
  eqtb [l ].lhfield = curcmd ;
  if ( curcmd == 41 ) 
  eqtb [l ].v.RH = 0 ;
  else eqtb [l ].v.RH = curmod ;
  getxnext () ;
} 
void 
#ifdef HAVE_PROTOTYPES
donewinternal ( void ) 
#else
donewinternal ( ) 
#endif
{
  do {
      if ( intptr == maxinternal ) 
    overflow ( 934 , maxinternal ) ;
    getclearsymbol () ;
    incr ( intptr ) ;
    eqtb [cursym ].lhfield = 40 ;
    eqtb [cursym ].v.RH = intptr ;
    intname [intptr ]= hash [cursym ].v.RH ;
    internal [intptr ]= 0 ;
    getxnext () ;
  } while ( ! ( curcmd != 82 ) ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
doshow ( void ) 
#else
doshow ( ) 
#endif
{
  do {
      getxnext () ;
    scanexpression () ;
    printnl ( 765 ) ;
    printexp ( 0 , 2 ) ;
    flushcurexp ( 0 ) ;
  } while ( ! ( curcmd != 82 ) ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
disptoken ( void ) 
#else
disptoken ( ) 
#endif
{
  printnl ( 940 ) ;
  if ( cursym == 0 ) 
  {
    if ( curcmd == 42 ) 
    printscaled ( curmod ) ;
    else if ( curcmd == 38 ) 
    {
      gpointer = curmod ;
      printcapsule () ;
    } 
    else {
	
      printchar ( 34 ) ;
      slowprint ( curmod ) ;
      printchar ( 34 ) ;
      {
	if ( strref [curmod ]< 127 ) 
	if ( strref [curmod ]> 1 ) 
	decr ( strref [curmod ]) ;
	else flushstring ( curmod ) ;
      } 
    } 
  } 
  else {
      
    slowprint ( hash [cursym ].v.RH ) ;
    printchar ( 61 ) ;
    if ( eqtb [cursym ].lhfield >= 86 ) 
    print ( 941 ) ;
    printcmdmod ( curcmd , curmod ) ;
    if ( curcmd == 10 ) 
    {
      println () ;
      showmacro ( curmod , 0 , 100000L ) ;
    } 
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
doshowtoken ( void ) 
#else
doshowtoken ( ) 
#endif
{
  do {
      getnext () ;
    disptoken () ;
    getxnext () ;
  } while ( ! ( curcmd != 82 ) ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
doshowstats ( void ) 
#else
doshowstats ( ) 
#endif
{
  printnl ( 950 ) ;
	;
#ifdef STAT
  printint ( varused ) ;
  printchar ( 38 ) ;
  printint ( dynused ) ;
  if ( false ) 
#endif /* STAT */
  print ( 357 ) ;
  print ( 558 ) ;
  printint ( himemmin - lomemmax - 1 ) ;
  print ( 951 ) ;
  println () ;
  printnl ( 952 ) ;
  printint ( strptr - initstrptr ) ;
  printchar ( 38 ) ;
  printint ( poolptr - initpoolptr ) ;
  print ( 558 ) ;
  printint ( maxstrings - maxstrptr ) ;
  printchar ( 38 ) ;
  printint ( poolsize - maxpoolptr ) ;
  print ( 951 ) ;
  println () ;
  getxnext () ;
} 
void 
#ifdef HAVE_PROTOTYPES
zdispvar ( halfword p ) 
#else
zdispvar ( p ) 
  halfword p ;
#endif
{
  halfword q  ;
  integer n  ;
  if ( mem [p ].hhfield .b0 == 21 ) 
  {
    q = mem [p + 1 ].hhfield .lhfield ;
    do {
	dispvar ( q ) ;
      q = mem [q ].hhfield .v.RH ;
    } while ( ! ( q == 17 ) ) ;
    q = mem [p + 1 ].hhfield .v.RH ;
    while ( mem [q ].hhfield .b1 == 3 ) {
	
      dispvar ( q ) ;
      q = mem [q ].hhfield .v.RH ;
    } 
  } 
  else if ( mem [p ].hhfield .b0 >= 22 ) 
  {
    printnl ( 261 ) ;
    printvariablename ( p ) ;
    if ( mem [p ].hhfield .b0 > 22 ) 
    print ( 665 ) ;
    print ( 953 ) ;
    if ( fileoffset >= maxprintline - 20 ) 
    n = 5 ;
    else n = maxprintline - fileoffset - 15 ;
    showmacro ( mem [p + 1 ].cint , 0 , n ) ;
  } 
  else if ( mem [p ].hhfield .b0 != 0 ) 
  {
    printnl ( 261 ) ;
    printvariablename ( p ) ;
    printchar ( 61 ) ;
    printexp ( p , 0 ) ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
doshowvar ( void ) 
#else
doshowvar ( ) 
#endif
{
  /* 30 */ do {
      getnext () ;
    if ( cursym > 0 ) 
    if ( cursym <= 9769 ) 
    if ( curcmd == 41 ) 
    if ( curmod != 0 ) 
    {
      dispvar ( curmod ) ;
      goto lab30 ;
    } 
    disptoken () ;
    lab30: getxnext () ;
  } while ( ! ( curcmd != 82 ) ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
doshowdependencies ( void ) 
#else
doshowdependencies ( ) 
#endif
{
  halfword p  ;
  p = mem [13 ].hhfield .v.RH ;
  while ( p != 13 ) {
      
    if ( interesting ( p ) ) 
    {
      printnl ( 261 ) ;
      printvariablename ( p ) ;
      if ( mem [p ].hhfield .b0 == 17 ) 
      printchar ( 61 ) ;
      else print ( 768 ) ;
      printdependency ( mem [p + 1 ].hhfield .v.RH , mem [p ].hhfield .b0 
      ) ;
    } 
    p = mem [p + 1 ].hhfield .v.RH ;
    while ( mem [p ].hhfield .lhfield != 0 ) p = mem [p ].hhfield .v.RH ;
    p = mem [p ].hhfield .v.RH ;
  } 
  getxnext () ;
} 
void 
#ifdef HAVE_PROTOTYPES
doshowwhatever ( void ) 
#else
doshowwhatever ( ) 
#endif
{
  if ( interaction == 3 ) 
  ;
  switch ( curmod ) 
  {case 0 : 
    doshowtoken () ;
    break ;
  case 1 : 
    doshowstats () ;
    break ;
  case 2 : 
    doshow () ;
    break ;
  case 3 : 
    doshowvar () ;
    break ;
  case 4 : 
    doshowdependencies () ;
    break ;
  } 
  if ( internal [32 ]> 0 ) 
  {
    {
      if ( interaction == 3 ) 
      ;
      if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
      {
	printnl ( 261 ) ;
	print ( fullsourcefilenamestack [inopen ]) ;
	print ( 58 ) ;
	printint ( line ) ;
	print ( 262 ) ;
	print ( 954 ) ;
      } 
      else {
	  
	printnl ( 263 ) ;
	print ( 954 ) ;
      } 
    } 
    if ( interaction < 3 ) 
    {
      helpptr = 0 ;
      decr ( errorcount ) ;
    } 
    else {
	
      helpptr = 1 ;
      helpline [0 ]= 955 ;
    } 
    if ( curcmd == 83 ) 
    error () ;
    else putgeterror () ;
  } 
} 
boolean 
#ifdef HAVE_PROTOTYPES
scanwith ( void ) 
#else
scanwith ( ) 
#endif
{
  register boolean Result; smallnumber t  ;
  boolean result  ;
  t = curmod ;
  curtype = 1 ;
  getxnext () ;
  scanexpression () ;
  result = false ;
  if ( curtype != t ) 
  {
    disperr ( 0 , 963 ) ;
    {
      helpptr = 2 ;
      helpline [1 ]= 964 ;
      helpline [0 ]= 965 ;
    } 
    if ( t == 6 ) 
    helpline [1 ]= 966 ;
    putgetflusherror ( 0 ) ;
  } 
  else if ( curtype == 6 ) 
  result = true ;
  else {
      
    curexp = roundunscaled ( curexp ) ;
    if ( ( abs ( curexp ) < 4 ) && ( curexp != 0 ) ) 
    result = true ;
    else {
	
      {
	if ( interaction == 3 ) 
	;
	if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	{
	  printnl ( 261 ) ;
	  print ( fullsourcefilenamestack [inopen ]) ;
	  print ( 58 ) ;
	  printint ( line ) ;
	  print ( 262 ) ;
	  print ( 967 ) ;
	} 
	else {
	    
	  printnl ( 263 ) ;
	  print ( 967 ) ;
	} 
      } 
      {
	helpptr = 1 ;
	helpline [0 ]= 965 ;
      } 
      putgetflusherror ( 0 ) ;
    } 
  } 
  Result = result ;
  return Result ;
} 
void 
#ifdef HAVE_PROTOTYPES
zfindedgesvar ( halfword t ) 
#else
zfindedgesvar ( t ) 
  halfword t ;
#endif
{
  halfword p  ;
  p = findvariable ( t ) ;
  curedges = 0 ;
  if ( p == 0 ) 
  {
    obliterated ( t ) ;
    putgeterror () ;
  } 
  else if ( mem [p ].hhfield .b0 != 11 ) 
  {
    {
      if ( interaction == 3 ) 
      ;
      if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
      {
	printnl ( 261 ) ;
	print ( fullsourcefilenamestack [inopen ]) ;
	print ( 58 ) ;
	printint ( line ) ;
	print ( 262 ) ;
	print ( 790 ) ;
      } 
      else {
	  
	printnl ( 263 ) ;
	print ( 790 ) ;
      } 
    } 
    showtokenlist ( t , 0 , 1000 , 0 ) ;
    print ( 968 ) ;
    printtype ( mem [p ].hhfield .b0 ) ;
    printchar ( 41 ) ;
    {
      helpptr = 2 ;
      helpline [1 ]= 969 ;
      helpline [0 ]= 970 ;
    } 
    putgeterror () ;
  } 
  else curedges = mem [p + 1 ].cint ;
  flushnodelist ( t ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
doaddto ( void ) 
#else
doaddto ( ) 
#endif
{
  /* 30 45 */ halfword lhs, rhs  ;
  integer w  ;
  halfword p  ;
  halfword q  ;
  char addtotype  ;
  getxnext () ;
  varflag = 68 ;
  scanprimary () ;
  if ( curtype != 20 ) 
  {
    disperr ( 0 , 971 ) ;
    {
      helpptr = 4 ;
      helpline [3 ]= 972 ;
      helpline [2 ]= 973 ;
      helpline [1 ]= 974 ;
      helpline [0 ]= 970 ;
    } 
    putgetflusherror ( 0 ) ;
  } 
  else {
      
    lhs = curexp ;
    addtotype = curmod ;
    curtype = 1 ;
    getxnext () ;
    scanexpression () ;
    if ( addtotype == 2 ) 
    {
      findedgesvar ( lhs ) ;
      if ( curedges == 0 ) 
      flushcurexp ( 0 ) ;
      else if ( curtype != 11 ) 
      {
	disperr ( 0 , 975 ) ;
	{
	  helpptr = 2 ;
	  helpline [1 ]= 976 ;
	  helpline [0 ]= 970 ;
	} 
	putgetflusherror ( 0 ) ;
      } 
      else {
	  
	mergeedges ( curexp ) ;
	flushcurexp ( 0 ) ;
      } 
    } 
    else {
	
      if ( curtype == 14 ) 
      pairtopath () ;
      if ( curtype != 9 ) 
      {
	disperr ( 0 , 975 ) ;
	{
	  helpptr = 2 ;
	  helpline [1 ]= 977 ;
	  helpline [0 ]= 970 ;
	} 
	putgetflusherror ( 0 ) ;
	flushtokenlist ( lhs ) ;
      } 
      else {
	  
	rhs = curexp ;
	w = 1 ;
	curpen = 3 ;
	while ( curcmd == 66 ) if ( scanwith () ) 
	if ( curtype == 16 ) 
	w = curexp ;
	else {
	    
	  if ( mem [curpen ].hhfield .lhfield == 0 ) 
	  tosspen ( curpen ) ;
	  else decr ( mem [curpen ].hhfield .lhfield ) ;
	  curpen = curexp ;
	} 
	findedgesvar ( lhs ) ;
	if ( curedges == 0 ) 
	tossknotlist ( rhs ) ;
	else {
	    
	  lhs = 0 ;
	  curpathtype = addtotype ;
	  if ( mem [rhs ].hhfield .b0 == 0 ) 
	  if ( curpathtype == 0 ) 
	  if ( mem [rhs ].hhfield .v.RH == rhs ) 
	  {
	    mem [rhs + 5 ].cint = mem [rhs + 1 ].cint ;
	    mem [rhs + 6 ].cint = mem [rhs + 2 ].cint ;
	    mem [rhs + 3 ].cint = mem [rhs + 1 ].cint ;
	    mem [rhs + 4 ].cint = mem [rhs + 2 ].cint ;
	    mem [rhs ].hhfield .b0 = 1 ;
	    mem [rhs ].hhfield .b1 = 1 ;
	  } 
	  else {
	      
	    p = htapypoc ( rhs ) ;
	    q = mem [p ].hhfield .v.RH ;
	    mem [pathtail + 5 ].cint = mem [q + 5 ].cint ;
	    mem [pathtail + 6 ].cint = mem [q + 6 ].cint ;
	    mem [pathtail ].hhfield .b1 = mem [q ].hhfield .b1 ;
	    mem [pathtail ].hhfield .v.RH = mem [q ].hhfield .v.RH ;
	    freenode ( q , 7 ) ;
	    mem [p + 5 ].cint = mem [rhs + 5 ].cint ;
	    mem [p + 6 ].cint = mem [rhs + 6 ].cint ;
	    mem [p ].hhfield .b1 = mem [rhs ].hhfield .b1 ;
	    mem [p ].hhfield .v.RH = mem [rhs ].hhfield .v.RH ;
	    freenode ( rhs , 7 ) ;
	    rhs = p ;
	  } 
	  else {
	      
	    {
	      if ( interaction == 3 ) 
	      ;
	      if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	      {
		printnl ( 261 ) ;
		print ( fullsourcefilenamestack [inopen ]) ;
		print ( 58 ) ;
		printint ( line ) ;
		print ( 262 ) ;
		print ( 978 ) ;
	      } 
	      else {
		  
		printnl ( 263 ) ;
		print ( 978 ) ;
	      } 
	    } 
	    {
	      helpptr = 2 ;
	      helpline [1 ]= 979 ;
	      helpline [0 ]= 970 ;
	    } 
	    putgeterror () ;
	    tossknotlist ( rhs ) ;
	    goto lab45 ;
	  } 
	  else if ( curpathtype == 0 ) 
	  lhs = htapypoc ( rhs ) ;
	  curwt = w ;
	  rhs = makespec ( rhs , mem [curpen + 9 ].cint , internal [5 ]) ;
	  if ( turningnumber <= 0 ) 
	  if ( curpathtype != 0 ) 
	  if ( internal [39 ]> 0 ) 
	  if ( ( turningnumber < 0 ) && ( mem [curpen ].hhfield .v.RH == 0 ) 
	  ) 
	  curwt = - (integer) curwt ;
	  else {
	      
	    if ( turningnumber == 0 ) 
	    if ( ( internal [39 ]<= 65536L ) && ( mem [curpen ].hhfield 
	    .v.RH == 0 ) ) 
	    goto lab30 ;
	    else printstrange ( 980 ) ;
	    else printstrange ( 981 ) ;
	    {
	      helpptr = 3 ;
	      helpline [2 ]= 982 ;
	      helpline [1 ]= 983 ;
	      helpline [0 ]= 984 ;
	    } 
	    putgeterror () ;
	  } 
	  lab30: ;
	  if ( mem [curpen + 9 ].cint == 0 ) 
	  {
	    mfluaPREfillspecrhs ( rhs ) ;
	    fillspec ( rhs ) ;
	    mfluaPOSTfillspecrhs ( rhs ) ;
	  } 
	  else {
	      
	    mfluaPREfillenveloperhs ( rhs ) ;
	    fillenvelope ( rhs ) ;
	    mfluaPOSTfillenveloperhs ( rhs ) ;
	  } 
	  if ( lhs != 0 ) 
	  {
	    revturns = true ;
	    lhs = makespec ( lhs , mem [curpen + 9 ].cint , internal [5 ]) 
	    ;
	    revturns = false ;
	    if ( mem [curpen + 9 ].cint == 0 ) 
	    {
	      mfluaPREfillspeclhs ( lhs ) ;
	      fillspec ( lhs ) ;
	      mfluaPOSTfillspeclhs ( lhs ) ;
	    } 
	    else {
		
	      mfluaPREfillenvelopelhs ( lhs ) ;
	      fillenvelope ( lhs ) ;
	      mfluaPOSTfillenvelopelhs ( lhs ) ;
	    } 
	  } 
	  lab45: ;
	} 
	if ( mem [curpen ].hhfield .lhfield == 0 ) 
	tosspen ( curpen ) ;
	else decr ( mem [curpen ].hhfield .lhfield ) ;
      } 
    } 
  } 
} 
scaled 
#ifdef HAVE_PROTOTYPES
ztfmcheck ( smallnumber m ) 
#else
ztfmcheck ( m ) 
  smallnumber m ;
#endif
{
  register scaled Result; if ( abs ( internal [m ]) >= 134217728L ) 
  {
    {
      if ( interaction == 3 ) 
      ;
      if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
      {
	printnl ( 261 ) ;
	print ( fullsourcefilenamestack [inopen ]) ;
	print ( 58 ) ;
	printint ( line ) ;
	print ( 262 ) ;
	print ( 1001 ) ;
      } 
      else {
	  
	printnl ( 263 ) ;
	print ( 1001 ) ;
      } 
    } 
    print ( intname [m ]) ;
    print ( 1002 ) ;
    {
      helpptr = 1 ;
      helpline [0 ]= 1003 ;
    } 
    putgeterror () ;
    if ( internal [m ]> 0 ) 
    Result = 134217727L ;
    else Result = -134217727L ;
  } 
  else Result = internal [m ];
  return Result ;
} 
void 
#ifdef HAVE_PROTOTYPES
doshipout ( void ) 
#else
doshipout ( ) 
#endif
{
  /* 10 */ integer c  ;
  getxnext () ;
  varflag = 83 ;
  scanexpression () ;
  if ( curtype != 20 ) 
  if ( curtype == 11 ) 
  curedges = curexp ;
  else {
      
    {
      disperr ( 0 , 971 ) ;
      {
	helpptr = 4 ;
	helpline [3 ]= 972 ;
	helpline [2 ]= 973 ;
	helpline [1 ]= 974 ;
	helpline [0 ]= 970 ;
      } 
      putgetflusherror ( 0 ) ;
    } 
    goto lab10 ;
  } 
  else {
      
    findedgesvar ( curexp ) ;
    curtype = 1 ;
  } 
  if ( curedges != 0 ) 
  {
    c = roundunscaled ( internal [18 ]) % 256 ;
    if ( c < 0 ) 
    c = c + 256 ;
    if ( c < bc ) 
    bc = c ;
    if ( c > ec ) 
    ec = c ;
    charexists [c ]= true ;
    gfdx [c ]= internal [24 ];
    gfdy [c ]= internal [25 ];
    tfmwidth [c ]= tfmcheck ( 20 ) ;
    tfmheight [c ]= tfmcheck ( 21 ) ;
    tfmdepth [c ]= tfmcheck ( 22 ) ;
    tfmitalcorr [c ]= tfmcheck ( 23 ) ;
    if ( internal [34 ]>= 0 ) 
    shipout ( c ) ;
  } 
  flushcurexp ( 0 ) ;
  lab10: ;
} 
void 
#ifdef HAVE_PROTOTYPES
dodisplay ( void ) 
#else
dodisplay ( ) 
#endif
{
  /* 45 50 10 */ halfword e  ;
  getxnext () ;
  varflag = 73 ;
  scanprimary () ;
  if ( curtype != 20 ) 
  {
    disperr ( 0 , 971 ) ;
    {
      helpptr = 4 ;
      helpline [3 ]= 972 ;
      helpline [2 ]= 973 ;
      helpline [1 ]= 974 ;
      helpline [0 ]= 970 ;
    } 
    putgetflusherror ( 0 ) ;
  } 
  else {
      
    e = curexp ;
    curtype = 1 ;
    getxnext () ;
    scanexpression () ;
    if ( curtype != 16 ) 
    goto lab50 ;
    curexp = roundunscaled ( curexp ) ;
    if ( curexp < 0 ) 
    goto lab45 ;
    if ( curexp > 15 ) 
    goto lab45 ;
    if ( ! windowopen [curexp ]) 
    goto lab45 ;
    findedgesvar ( e ) ;
    if ( curedges != 0 ) 
    dispedges ( curexp ) ;
    goto lab10 ;
    lab45: curexp = curexp * 65536L ;
    lab50: disperr ( 0 , 985 ) ;
    {
      helpptr = 1 ;
      helpline [0 ]= 986 ;
    } 
    putgetflusherror ( 0 ) ;
    flushtokenlist ( e ) ;
  } 
  lab10: ;
} 
boolean 
#ifdef HAVE_PROTOTYPES
zgetpair ( commandcode c ) 
#else
zgetpair ( c ) 
  commandcode c ;
#endif
{
  register boolean Result; halfword p  ;
  boolean b  ;
  if ( curcmd != c ) 
  Result = false ;
  else {
      
    getxnext () ;
    scanexpression () ;
    if ( nicepair ( curexp , curtype ) ) 
    {
      p = mem [curexp + 1 ].cint ;
      curx = mem [p + 1 ].cint ;
      cury = mem [p + 3 ].cint ;
      b = true ;
    } 
    else b = false ;
    flushcurexp ( 0 ) ;
    Result = b ;
  } 
  return Result ;
} 
void 
#ifdef HAVE_PROTOTYPES
doopenwindow ( void ) 
#else
doopenwindow ( ) 
#endif
{
  /* 45 10 */ integer k  ;
  scaled r0, c0, r1, c1  ;
  getxnext () ;
  scanexpression () ;
  if ( curtype != 16 ) 
  goto lab45 ;
  k = roundunscaled ( curexp ) ;
  if ( k < 0 ) 
  goto lab45 ;
  if ( k > 15 ) 
  goto lab45 ;
  if ( ! getpair ( 70 ) ) 
  goto lab45 ;
  r0 = curx ;
  c0 = cury ;
  if ( ! getpair ( 71 ) ) 
  goto lab45 ;
  r1 = curx ;
  c1 = cury ;
  if ( ! getpair ( 72 ) ) 
  goto lab45 ;
  openawindow ( k , r0 , c0 , r1 , c1 , curx , cury ) ;
  goto lab10 ;
  lab45: {
      
    if ( interaction == 3 ) 
    ;
    if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
    {
      printnl ( 261 ) ;
      print ( fullsourcefilenamestack [inopen ]) ;
      print ( 58 ) ;
      printint ( line ) ;
      print ( 262 ) ;
      print ( 987 ) ;
    } 
    else {
	
      printnl ( 263 ) ;
      print ( 987 ) ;
    } 
  } 
  {
    helpptr = 2 ;
    helpline [1 ]= 988 ;
    helpline [0 ]= 989 ;
  } 
  putgeterror () ;
  lab10: ;
} 
void 
#ifdef HAVE_PROTOTYPES
docull ( void ) 
#else
docull ( ) 
#endif
{
  /* 45 10 */ halfword e  ;
  char keeping  ;
  integer w, win, wout  ;
  w = 1 ;
  getxnext () ;
  varflag = 67 ;
  scanprimary () ;
  if ( curtype != 20 ) 
  {
    disperr ( 0 , 971 ) ;
    {
      helpptr = 4 ;
      helpline [3 ]= 972 ;
      helpline [2 ]= 973 ;
      helpline [1 ]= 974 ;
      helpline [0 ]= 970 ;
    } 
    putgetflusherror ( 0 ) ;
  } 
  else {
      
    e = curexp ;
    curtype = 1 ;
    keeping = curmod ;
    if ( ! getpair ( 67 ) ) 
    goto lab45 ;
    while ( ( curcmd == 66 ) && ( curmod == 16 ) ) if ( scanwith () ) 
    w = curexp ;
    if ( curx > cury ) 
    goto lab45 ;
    if ( keeping == 0 ) 
    {
      if ( ( curx > 0 ) || ( cury < 0 ) ) 
      goto lab45 ;
      wout = w ;
      win = 0 ;
    } 
    else {
	
      if ( ( curx <= 0 ) && ( cury >= 0 ) ) 
      goto lab45 ;
      wout = 0 ;
      win = w ;
    } 
    findedgesvar ( e ) ;
    if ( curedges != 0 ) 
    culledges ( floorunscaled ( curx + 65535L ) , floorunscaled ( cury ) , 
    wout , win ) ;
    goto lab10 ;
    lab45: {
	
      if ( interaction == 3 ) 
      ;
      if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
      {
	printnl ( 261 ) ;
	print ( fullsourcefilenamestack [inopen ]) ;
	print ( 58 ) ;
	printint ( line ) ;
	print ( 262 ) ;
	print ( 990 ) ;
      } 
      else {
	  
	printnl ( 263 ) ;
	print ( 990 ) ;
      } 
    } 
    {
      helpptr = 1 ;
      helpline [0 ]= 991 ;
    } 
    putgeterror () ;
    flushtokenlist ( e ) ;
  } 
  lab10: ;
} 
void 
#ifdef HAVE_PROTOTYPES
domessage ( void ) 
#else
domessage ( ) 
#endif
{
  char m  ;
  m = curmod ;
  getxnext () ;
  scanexpression () ;
  if ( curtype != 4 ) 
  {
    disperr ( 0 , 700 ) ;
    {
      helpptr = 1 ;
      helpline [0 ]= 995 ;
    } 
    putgeterror () ;
  } 
  else switch ( m ) 
  {case 0 : 
    {
      printnl ( 261 ) ;
      slowprint ( curexp ) ;
    } 
    break ;
  case 1 : 
    {
      {
	if ( interaction == 3 ) 
	;
	if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	{
	  printnl ( 261 ) ;
	  print ( fullsourcefilenamestack [inopen ]) ;
	  print ( 58 ) ;
	  printint ( line ) ;
	  print ( 262 ) ;
	  print ( 261 ) ;
	} 
	else {
	    
	  printnl ( 263 ) ;
	  print ( 261 ) ;
	} 
      } 
      slowprint ( curexp ) ;
      if ( errhelp != 0 ) 
      useerrhelp = true ;
      else if ( longhelpseen ) 
      {
	helpptr = 1 ;
	helpline [0 ]= 996 ;
      } 
      else {
	  
	if ( interaction < 3 ) 
	longhelpseen = true ;
	{
	  helpptr = 4 ;
	  helpline [3 ]= 997 ;
	  helpline [2 ]= 998 ;
	  helpline [1 ]= 999 ;
	  helpline [0 ]= 1000 ;
	} 
      } 
      putgeterror () ;
      useerrhelp = false ;
    } 
    break ;
  case 2 : 
    {
      if ( errhelp != 0 ) 
      {
	if ( strref [errhelp ]< 127 ) 
	if ( strref [errhelp ]> 1 ) 
	decr ( strref [errhelp ]) ;
	else flushstring ( errhelp ) ;
      } 
      if ( ( strstart [curexp + 1 ]- strstart [curexp ]) == 0 ) 
      errhelp = 0 ;
      else {
	  
	errhelp = curexp ;
	{
	  if ( strref [errhelp ]< 127 ) 
	  incr ( strref [errhelp ]) ;
	} 
      } 
    } 
    break ;
  } 
  flushcurexp ( 0 ) ;
} 
eightbits 
#ifdef HAVE_PROTOTYPES
getcode ( void ) 
#else
getcode ( ) 
#endif
{
  /* 40 */ register eightbits Result; integer c  ;
  getxnext () ;
  scanexpression () ;
  if ( curtype == 16 ) 
  {
    c = roundunscaled ( curexp ) ;
    if ( c >= 0 ) 
    if ( c < 256 ) 
    goto lab40 ;
  } 
  else if ( curtype == 4 ) 
  if ( ( strstart [curexp + 1 ]- strstart [curexp ]) == 1 ) 
  {
    c = strpool [strstart [curexp ]];
    goto lab40 ;
  } 
  disperr ( 0 , 1009 ) ;
  {
    helpptr = 2 ;
    helpline [1 ]= 1010 ;
    helpline [0 ]= 1011 ;
  } 
  putgetflusherror ( 0 ) ;
  c = 0 ;
  lab40: Result = c ;
  return Result ;
} 
void 
#ifdef HAVE_PROTOTYPES
zsettag ( halfword c , smallnumber t , halfword r ) 
#else
zsettag ( c , t , r ) 
  halfword c ;
  smallnumber t ;
  halfword r ;
#endif
{
  if ( chartag [c ]== 0 ) 
  {
    chartag [c ]= t ;
    charremainder [c ]= r ;
    if ( t == 1 ) 
    {
      incr ( labelptr ) ;
      labelloc [labelptr ]= r ;
      labelchar [labelptr ]= c ;
    } 
  } 
  else {
      
    {
      if ( interaction == 3 ) 
      ;
      if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
      {
	printnl ( 261 ) ;
	print ( fullsourcefilenamestack [inopen ]) ;
	print ( 58 ) ;
	printint ( line ) ;
	print ( 262 ) ;
	print ( 1012 ) ;
      } 
      else {
	  
	printnl ( 263 ) ;
	print ( 1012 ) ;
      } 
    } 
    if ( ( c > 32 ) && ( c < 127 ) ) 
    print ( c ) ;
    else if ( c == 256 ) 
    print ( 1013 ) ;
    else {
	
      print ( 1014 ) ;
      printint ( c ) ;
    } 
    print ( 1015 ) ;
    switch ( chartag [c ]) 
    {case 1 : 
      print ( 1016 ) ;
      break ;
    case 2 : 
      print ( 1017 ) ;
      break ;
    case 3 : 
      print ( 1006 ) ;
      break ;
    } 
    {
      helpptr = 2 ;
      helpline [1 ]= 1018 ;
      helpline [0 ]= 970 ;
    } 
    putgeterror () ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
dotfmcommand ( void ) 
#else
dotfmcommand ( ) 
#endif
{
  /* 22 30 */ short c, cc  ;
  integer k  ;
  integer j  ;
  switch ( curmod ) 
  {case 0 : 
    {
      c = getcode () ;
      while ( curcmd == 81 ) {
	  
	cc = getcode () ;
	settag ( c , 2 , cc ) ;
	c = cc ;
      } 
    } 
    break ;
  case 1 : 
    {
      lkstarted = false ;
      lab22: getxnext () ;
      if ( ( curcmd == 78 ) && lkstarted ) 
      {
	c = getcode () ;
	if ( nl - skiptable [c ]> 128 ) 
	{
	  {
	    {
	      if ( interaction == 3 ) 
	      ;
	      if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	      {
		printnl ( 261 ) ;
		print ( fullsourcefilenamestack [inopen ]) ;
		print ( 58 ) ;
		printint ( line ) ;
		print ( 262 ) ;
		print ( 1035 ) ;
	      } 
	      else {
		  
		printnl ( 263 ) ;
		print ( 1035 ) ;
	      } 
	    } 
	    {
	      helpptr = 1 ;
	      helpline [0 ]= 1036 ;
	    } 
	    error () ;
	    ll = skiptable [c ];
	    do {
		lll = ligkern [ll ].b0 ;
	      ligkern [ll ].b0 = 128 ;
	      ll = ll - lll ;
	    } while ( ! ( lll == 0 ) ) ;
	  } 
	  skiptable [c ]= ligtablesize ;
	} 
	if ( skiptable [c ]== ligtablesize ) 
	ligkern [nl - 1 ].b0 = 0 ;
	else ligkern [nl - 1 ].b0 = nl - skiptable [c ]- 1 ;
	skiptable [c ]= nl - 1 ;
	goto lab30 ;
      } 
      if ( curcmd == 79 ) 
      {
	c = 256 ;
	curcmd = 81 ;
      } 
      else {
	  
	backinput () ;
	c = getcode () ;
      } 
      if ( ( curcmd == 81 ) || ( curcmd == 80 ) ) 
      {
	if ( curcmd == 81 ) 
	if ( c == 256 ) 
	bchlabel = nl ;
	else settag ( c , 1 , nl ) ;
	else if ( skiptable [c ]< ligtablesize ) 
	{
	  ll = skiptable [c ];
	  skiptable [c ]= ligtablesize ;
	  do {
	      lll = ligkern [ll ].b0 ;
	    if ( nl - ll > 128 ) 
	    {
	      {
		{
		  if ( interaction == 3 ) 
		  ;
		  if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) 
		  ) ) 
		  {
		    printnl ( 261 ) ;
		    print ( fullsourcefilenamestack [inopen ]) ;
		    print ( 58 ) ;
		    printint ( line ) ;
		    print ( 262 ) ;
		    print ( 1035 ) ;
		  } 
		  else {
		      
		    printnl ( 263 ) ;
		    print ( 1035 ) ;
		  } 
		} 
		{
		  helpptr = 1 ;
		  helpline [0 ]= 1036 ;
		} 
		error () ;
		ll = ll ;
		do {
		    lll = ligkern [ll ].b0 ;
		  ligkern [ll ].b0 = 128 ;
		  ll = ll - lll ;
		} while ( ! ( lll == 0 ) ) ;
	      } 
	      goto lab22 ;
	    } 
	    ligkern [ll ].b0 = nl - ll - 1 ;
	    ll = ll - lll ;
	  } while ( ! ( lll == 0 ) ) ;
	} 
	goto lab22 ;
      } 
      if ( curcmd == 76 ) 
      {
	ligkern [nl ].b1 = c ;
	ligkern [nl ].b0 = 0 ;
	if ( curmod < 128 ) 
	{
	  ligkern [nl ].b2 = curmod ;
	  ligkern [nl ].b3 = getcode () ;
	} 
	else {
	    
	  getxnext () ;
	  scanexpression () ;
	  if ( curtype != 16 ) 
	  {
	    disperr ( 0 , 1037 ) ;
	    {
	      helpptr = 2 ;
	      helpline [1 ]= 1038 ;
	      helpline [0 ]= 308 ;
	    } 
	    putgetflusherror ( 0 ) ;
	  } 
	  kern [nk ]= curexp ;
	  k = 0 ;
	  while ( kern [k ]!= curexp ) incr ( k ) ;
	  if ( k == nk ) 
	  {
	    if ( nk == maxkerns ) 
	    overflow ( 1034 , maxkerns ) ;
	    incr ( nk ) ;
	  } 
	  ligkern [nl ].b2 = 128 + ( k / 256 ) ;
	  ligkern [nl ].b3 = ( k % 256 ) ;
	} 
	lkstarted = true ;
      } 
      else {
	  
	{
	  if ( interaction == 3 ) 
	  ;
	  if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	  {
	    printnl ( 261 ) ;
	    print ( fullsourcefilenamestack [inopen ]) ;
	    print ( 58 ) ;
	    printint ( line ) ;
	    print ( 262 ) ;
	    print ( 1023 ) ;
	  } 
	  else {
	      
	    printnl ( 263 ) ;
	    print ( 1023 ) ;
	  } 
	} 
	{
	  helpptr = 1 ;
	  helpline [0 ]= 1024 ;
	} 
	backerror () ;
	ligkern [nl ].b1 = 0 ;
	ligkern [nl ].b2 = 0 ;
	ligkern [nl ].b3 = 0 ;
	ligkern [nl ].b0 = 129 ;
      } 
      if ( nl == ligtablesize ) 
      overflow ( 1025 , ligtablesize ) ;
      incr ( nl ) ;
      if ( curcmd == 82 ) 
      goto lab22 ;
      if ( ligkern [nl - 1 ].b0 < 128 ) 
      ligkern [nl - 1 ].b0 = 128 ;
      lab30: ;
    } 
    break ;
  case 2 : 
    {
      if ( ne == 256 ) 
      overflow ( 1006 , 256 ) ;
      c = getcode () ;
      settag ( c , 3 , ne ) ;
      if ( curcmd != 81 ) 
      {
	missingerr ( 58 ) ;
	{
	  helpptr = 1 ;
	  helpline [0 ]= 1039 ;
	} 
	backerror () ;
      } 
      exten [ne ].b0 = getcode () ;
      if ( curcmd != 82 ) 
      {
	missingerr ( 44 ) ;
	{
	  helpptr = 1 ;
	  helpline [0 ]= 1039 ;
	} 
	backerror () ;
      } 
      exten [ne ].b1 = getcode () ;
      if ( curcmd != 82 ) 
      {
	missingerr ( 44 ) ;
	{
	  helpptr = 1 ;
	  helpline [0 ]= 1039 ;
	} 
	backerror () ;
      } 
      exten [ne ].b2 = getcode () ;
      if ( curcmd != 82 ) 
      {
	missingerr ( 44 ) ;
	{
	  helpptr = 1 ;
	  helpline [0 ]= 1039 ;
	} 
	backerror () ;
      } 
      exten [ne ].b3 = getcode () ;
      incr ( ne ) ;
    } 
    break ;
  case 3 : 
  case 4 : 
    {
      c = curmod ;
      getxnext () ;
      scanexpression () ;
      if ( ( curtype != 16 ) || ( curexp < 32768L ) ) 
      {
	disperr ( 0 , 1019 ) ;
	{
	  helpptr = 2 ;
	  helpline [1 ]= 1020 ;
	  helpline [0 ]= 1021 ;
	} 
	putgeterror () ;
      } 
      else {
	  
	j = roundunscaled ( curexp ) ;
	if ( curcmd != 81 ) 
	{
	  missingerr ( 58 ) ;
	  {
	    helpptr = 1 ;
	    helpline [0 ]= 1022 ;
	  } 
	  backerror () ;
	} 
	if ( c == 3 ) 
	do {
	    if ( j > headersize ) 
	  overflow ( 1007 , headersize ) ;
	  headerbyte [j ]= getcode () ;
	  incr ( j ) ;
	} while ( ! ( curcmd != 82 ) ) ;
	else do {
	    if ( j > maxfontdimen ) 
	  overflow ( 1008 , maxfontdimen ) ;
	  while ( j > np ) {
	      
	    incr ( np ) ;
	    param [np ]= 0 ;
	  } 
	  getxnext () ;
	  scanexpression () ;
	  if ( curtype != 16 ) 
	  {
	    disperr ( 0 , 1040 ) ;
	    {
	      helpptr = 1 ;
	      helpline [0 ]= 308 ;
	    } 
	    putgetflusherror ( 0 ) ;
	  } 
	  param [j ]= curexp ;
	  incr ( j ) ;
	} while ( ! ( curcmd != 82 ) ) ;
      } 
    } 
    break ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
dospecial ( void ) 
#else
dospecial ( ) 
#endif
{
  smallnumber m  ;
  m = curmod ;
  getxnext () ;
  scanexpression () ;
  if ( internal [34 ]>= 0 ) 
  if ( curtype != m ) 
  {
    disperr ( 0 , 1060 ) ;
    {
      helpptr = 1 ;
      helpline [0 ]= 1061 ;
    } 
    putgeterror () ;
  } 
  else {
      
    if ( outputfilename == 0 ) 
    initgf () ;
    if ( m == 4 ) 
    gfstring ( curexp , 0 ) ;
    else {
	
      {
	gfbuf [gfptr ]= 243 ;
	incr ( gfptr ) ;
	if ( gfptr == gflimit ) 
	gfswap () ;
      } 
      gffour ( curexp ) ;
    } 
  } 
  flushcurexp ( 0 ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
dostatement ( void ) 
#else
dostatement ( ) 
#endif
{
  curtype = 1 ;
  getxnext () ;
  if ( curcmd > 43 ) 
  {
    if ( curcmd < 83 ) 
    {
      {
	if ( interaction == 3 ) 
	;
	if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	{
	  printnl ( 261 ) ;
	  print ( fullsourcefilenamestack [inopen ]) ;
	  print ( 58 ) ;
	  printint ( line ) ;
	  print ( 262 ) ;
	  print ( 869 ) ;
	} 
	else {
	    
	  printnl ( 263 ) ;
	  print ( 869 ) ;
	} 
      } 
      printcmdmod ( curcmd , curmod ) ;
      printchar ( 39 ) ;
      {
	helpptr = 5 ;
	helpline [4 ]= 870 ;
	helpline [3 ]= 871 ;
	helpline [2 ]= 872 ;
	helpline [1 ]= 873 ;
	helpline [0 ]= 874 ;
      } 
      backerror () ;
      getxnext () ;
    } 
  } 
  else if ( curcmd > 30 ) 
  {
    varflag = 77 ;
    scanexpression () ;
    if ( curcmd < 84 ) 
    {
      if ( curcmd == 51 ) 
      doequation () ;
      else if ( curcmd == 77 ) 
      doassignment () ;
      else if ( curtype == 4 ) 
      {
	if ( internal [1 ]> 0 ) 
	{
	  printnl ( 261 ) ;
	  slowprint ( curexp ) ;
	  fflush ( stdout ) ;
	} 
	if ( internal [34 ]> 0 ) 
	{
	  if ( outputfilename == 0 ) 
	  initgf () ;
	  gfstring ( 1062 , curexp ) ;
	} 
      } 
      else if ( curtype != 1 ) 
      {
	disperr ( 0 , 879 ) ;
	{
	  helpptr = 3 ;
	  helpline [2 ]= 880 ;
	  helpline [1 ]= 881 ;
	  helpline [0 ]= 882 ;
	} 
	putgeterror () ;
      } 
      flushcurexp ( 0 ) ;
      curtype = 1 ;
    } 
  } 
  else {
      
    if ( internal [7 ]> 0 ) 
    showcmdmod ( curcmd , curmod ) ;
    switch ( curcmd ) 
    {case 30 : 
      dotypedeclaration () ;
      break ;
    case 16 : 
      if ( curmod > 2 ) 
      makeopdef () ;
      else if ( curmod > 0 ) 
      scandef () ;
      break ;
    case 24 : 
      dorandomseed () ;
      break ;
    case 23 : 
      {
	println () ;
	interaction = curmod ;
	if ( interaction == 0 ) 
	kpsemaketexdiscarderrors = 1 ;
	else kpsemaketexdiscarderrors = 0 ;
	if ( interaction == 0 ) 
	selector = 0 ;
	else selector = 1 ;
	if ( logopened ) 
	selector = selector + 2 ;
	getxnext () ;
      } 
      break ;
    case 21 : 
      doprotection () ;
      break ;
    case 27 : 
      defdelims () ;
      break ;
    case 12 : 
      do {
	  getsymbol () ;
	savevariable ( cursym ) ;
	getxnext () ;
      } while ( ! ( curcmd != 82 ) ) ;
      break ;
    case 13 : 
      dointerim () ;
      break ;
    case 14 : 
      dolet () ;
      break ;
    case 15 : 
      donewinternal () ;
      break ;
    case 22 : 
      doshowwhatever () ;
      break ;
    case 18 : 
      doaddto () ;
      break ;
    case 17 : 
      doshipout () ;
      break ;
    case 11 : 
      dodisplay () ;
      break ;
    case 28 : 
      doopenwindow () ;
      break ;
    case 19 : 
      docull () ;
      break ;
    case 26 : 
      {
	getsymbol () ;
	startsym = cursym ;
	getxnext () ;
      } 
      break ;
    case 25 : 
      domessage () ;
      break ;
    case 20 : 
      dotfmcommand () ;
      break ;
    case 29 : 
      dospecial () ;
      break ;
    } 
    curtype = 1 ;
  } 
  if ( curcmd < 83 ) 
  {
    {
      if ( interaction == 3 ) 
      ;
      if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
      {
	printnl ( 261 ) ;
	print ( fullsourcefilenamestack [inopen ]) ;
	print ( 58 ) ;
	printint ( line ) ;
	print ( 262 ) ;
	print ( 875 ) ;
      } 
      else {
	  
	printnl ( 263 ) ;
	print ( 875 ) ;
      } 
    } 
    {
      helpptr = 6 ;
      helpline [5 ]= 876 ;
      helpline [4 ]= 877 ;
      helpline [3 ]= 878 ;
      helpline [2 ]= 872 ;
      helpline [1 ]= 873 ;
      helpline [0 ]= 874 ;
    } 
    backerror () ;
    scannerstatus = 2 ;
    do {
	getnext () ;
      if ( curcmd == 39 ) 
      {
	if ( strref [curmod ]< 127 ) 
	if ( strref [curmod ]> 1 ) 
	decr ( strref [curmod ]) ;
	else flushstring ( curmod ) ;
      } 
    } while ( ! ( curcmd > 82 ) ) ;
    scannerstatus = 0 ;
  } 
  errorcount = 0 ;
} 
void 
#ifdef HAVE_PROTOTYPES
maincontrol ( void ) 
#else
maincontrol ( ) 
#endif
{
  do {
      dostatement () ;
    if ( curcmd == 84 ) 
    {
      {
	if ( interaction == 3 ) 
	;
	if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	{
	  printnl ( 261 ) ;
	  print ( fullsourcefilenamestack [inopen ]) ;
	  print ( 58 ) ;
	  printint ( line ) ;
	  print ( 262 ) ;
	  print ( 910 ) ;
	} 
	else {
	    
	  printnl ( 263 ) ;
	  print ( 910 ) ;
	} 
      } 
      {
	helpptr = 2 ;
	helpline [1 ]= 911 ;
	helpline [0 ]= 690 ;
      } 
      flusherror ( 0 ) ;
    } 
  } while ( ! ( curcmd == 85 ) ) ;
} 
halfword 
#ifdef HAVE_PROTOTYPES
zsortin ( scaled v ) 
#else
zsortin ( v ) 
  scaled v ;
#endif
{
  /* 40 */ register halfword Result; halfword p, q, r  ;
  p = memtop - 1 ;
  while ( true ) {
      
    q = mem [p ].hhfield .v.RH ;
    if ( v <= mem [q + 1 ].cint ) 
    goto lab40 ;
    p = q ;
  } 
  lab40: if ( v < mem [q + 1 ].cint ) 
  {
    r = getnode ( 2 ) ;
    mem [r + 1 ].cint = v ;
    mem [r ].hhfield .v.RH = q ;
    mem [p ].hhfield .v.RH = r ;
  } 
  Result = mem [p ].hhfield .v.RH ;
  return Result ;
} 
integer 
#ifdef HAVE_PROTOTYPES
zmincover ( scaled d ) 
#else
zmincover ( d ) 
  scaled d ;
#endif
{
  register integer Result; halfword p  ;
  scaled l  ;
  integer m  ;
  m = 0 ;
  p = mem [memtop - 1 ].hhfield .v.RH ;
  perturbation = 2147483647L ;
  while ( p != 19 ) {
      
    incr ( m ) ;
    l = mem [p + 1 ].cint ;
    do {
	p = mem [p ].hhfield .v.RH ;
    } while ( ! ( mem [p + 1 ].cint > l + d ) ) ;
    if ( mem [p + 1 ].cint - l < perturbation ) 
    perturbation = mem [p + 1 ].cint - l ;
  } 
  Result = m ;
  return Result ;
} 
scaled 
#ifdef HAVE_PROTOTYPES
zthresholdfn ( integer m ) 
#else
zthresholdfn ( m ) 
  integer m ;
#endif
{
  register scaled Result; scaled d  ;
  excess = mincover ( 0 ) - m ;
  if ( excess <= 0 ) 
  Result = 0 ;
  else {
      
    do {
	d = perturbation ;
    } while ( ! ( mincover ( d + d ) <= m ) ) ;
    while ( mincover ( d ) > m ) d = perturbation ;
    Result = d ;
  } 
  return Result ;
} 
integer 
#ifdef HAVE_PROTOTYPES
zskimp ( integer m ) 
#else
zskimp ( m ) 
  integer m ;
#endif
{
  register integer Result; scaled d  ;
  halfword p, q, r  ;
  scaled l  ;
  scaled v  ;
  d = thresholdfn ( m ) ;
  perturbation = 0 ;
  q = memtop - 1 ;
  m = 0 ;
  p = mem [memtop - 1 ].hhfield .v.RH ;
  while ( p != 19 ) {
      
    incr ( m ) ;
    l = mem [p + 1 ].cint ;
    mem [p ].hhfield .lhfield = m ;
    if ( mem [mem [p ].hhfield .v.RH + 1 ].cint <= l + d ) 
    {
      do {
	  p = mem [p ].hhfield .v.RH ;
	mem [p ].hhfield .lhfield = m ;
	decr ( excess ) ;
	if ( excess == 0 ) 
	d = 0 ;
      } while ( ! ( mem [mem [p ].hhfield .v.RH + 1 ].cint > l + d ) ) ;
      v = l + halfp ( mem [p + 1 ].cint - l ) ;
      if ( mem [p + 1 ].cint - v > perturbation ) 
      perturbation = mem [p + 1 ].cint - v ;
      r = q ;
      do {
	  r = mem [r ].hhfield .v.RH ;
	mem [r + 1 ].cint = v ;
      } while ( ! ( r == p ) ) ;
      mem [q ].hhfield .v.RH = p ;
    } 
    q = p ;
    p = mem [p ].hhfield .v.RH ;
  } 
  Result = m ;
  return Result ;
} 
void 
#ifdef HAVE_PROTOTYPES
ztfmwarning ( smallnumber m ) 
#else
ztfmwarning ( m ) 
  smallnumber m ;
#endif
{
  printnl ( 1041 ) ;
  print ( intname [m ]) ;
  print ( 1042 ) ;
  printscaled ( perturbation ) ;
  print ( 1043 ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
fixdesignsize ( void ) 
#else
fixdesignsize ( ) 
#endif
{
  scaled d  ;
  d = internal [26 ];
  if ( ( d < 65536L ) || ( d >= 134217728L ) ) 
  {
    if ( d != 0 ) 
    printnl ( 1044 ) ;
    d = 8388608L ;
    internal [26 ]= d ;
  } 
  if ( headerbyte [5 ]< 0 ) 
  if ( headerbyte [6 ]< 0 ) 
  if ( headerbyte [7 ]< 0 ) 
  if ( headerbyte [8 ]< 0 ) 
  {
    headerbyte [5 ]= d / 1048576L ;
    headerbyte [6 ]= ( d / 4096 ) % 256 ;
    headerbyte [7 ]= ( d / 16 ) % 256 ;
    headerbyte [8 ]= ( d % 16 ) * 16 ;
  } 
  maxtfmdimen = 16 * internal [26 ]- 1 - internal [26 ]/ 2097152L ;
  if ( maxtfmdimen >= 134217728L ) 
  maxtfmdimen = 134217727L ;
} 
integer 
#ifdef HAVE_PROTOTYPES
zdimenout ( scaled x ) 
#else
zdimenout ( x ) 
  scaled x ;
#endif
{
  register integer Result; if ( abs ( x ) > maxtfmdimen ) 
  {
    incr ( tfmchanged ) ;
    if ( x > 0 ) 
    x = maxtfmdimen ;
    else x = - (integer) maxtfmdimen ;
  } 
  x = makescaled ( x * 16 , internal [26 ]) ;
  Result = x ;
  return Result ;
} 
void 
#ifdef HAVE_PROTOTYPES
fixchecksum ( void ) 
#else
fixchecksum ( ) 
#endif
{
  /* 10 */ eightbits k  ;
  eightbits lb1, lb2, lb3, b4  ;
  integer x  ;
  if ( headerbyte [1 ]< 0 ) 
  if ( headerbyte [2 ]< 0 ) 
  if ( headerbyte [3 ]< 0 ) 
  if ( headerbyte [4 ]< 0 ) 
  {
    lb1 = bc ;
    lb2 = ec ;
    lb3 = bc ;
    b4 = ec ;
    tfmchanged = 0 ;
    {register integer for_end; k = bc ;for_end = ec ; if ( k <= for_end) do 
      if ( charexists [k ]) 
      {
	x = dimenout ( mem [tfmwidth [k ]+ 1 ].cint ) + ( k + 4 ) * 
	4194304L ;
	lb1 = ( lb1 + lb1 + x ) % 255 ;
	lb2 = ( lb2 + lb2 + x ) % 253 ;
	lb3 = ( lb3 + lb3 + x ) % 251 ;
	b4 = ( b4 + b4 + x ) % 247 ;
      } 
    while ( k++ < for_end ) ;} 
    headerbyte [1 ]= lb1 ;
    headerbyte [2 ]= lb2 ;
    headerbyte [3 ]= lb3 ;
    headerbyte [4 ]= b4 ;
    goto lab10 ;
  } 
  {register integer for_end; k = 1 ;for_end = 4 ; if ( k <= for_end) do 
    if ( headerbyte [k ]< 0 ) 
    headerbyte [k ]= 0 ;
  while ( k++ < for_end ) ;} 
  lab10: ;
} 
void 
#ifdef HAVE_PROTOTYPES
ztfmqqqq ( fourquarters x ) 
#else
ztfmqqqq ( x ) 
  fourquarters x ;
#endif
{
  putbyte ( x .b0 , tfmfile ) ;
  putbyte ( x .b1 , tfmfile ) ;
  putbyte ( x .b2 , tfmfile ) ;
  putbyte ( x .b3 , tfmfile ) ;
} 
boolean 
#ifdef HAVE_PROTOTYPES
openbasefile ( void ) 
#else
openbasefile ( ) 
#endif
{
  /* 40 10 */ register boolean Result; integer j  ;
  j = curinput .locfield ;
  if ( buffer [curinput .locfield ]== 38 ) 
  {
    incr ( curinput .locfield ) ;
    j = curinput .locfield ;
    buffer [last ]= 32 ;
    while ( buffer [j ]!= 32 ) incr ( j ) ;
    packbufferedname ( 0 , curinput .locfield , j - 1 ) ;
    if ( wopenin ( basefile ) ) 
    goto lab40 ;
    Fputs ( stdout ,  "Sorry, I can't find the base `" ) ;
    fputs ( stringcast ( nameoffile + 1 ) , stdout ) ;
    Fputs ( stdout ,  "'; will try `" ) ;
    fputs ( MFbasedefault + 1 , stdout ) ;
    fprintf ( stdout , "%s\n",  "'." ) ;
    fflush ( stdout ) ;
  } 
  packbufferedname ( basedefaultlength - 5 , 1 , 0 ) ;
  if ( ! wopenin ( basefile ) ) 
  {
    ;
    Fputs ( stdout ,  "I can't find the base file `" ) ;
    fputs ( MFbasedefault + 1 , stdout ) ;
    fprintf ( stdout , "%s\n",  "'!" ) ;
    Result = false ;
    goto lab10 ;
  } 
  lab40: curinput .locfield = j ;
  Result = true ;
  lab10: ;
  return Result ;
} 
void 
#ifdef HAVE_PROTOTYPES
scanprimary ( void ) 
#else
scanprimary ( ) 
#endif
{
  /* 20 30 31 32 */ halfword p, q, r  ;
  quarterword c  ;
  char myvarflag  ;
  halfword ldelim, rdelim  ;
  integer groupline  ;
  scaled num, denom  ;
  halfword prehead, posthead, tail  ;
  smallnumber tt  ;
  halfword t  ;
  halfword macroref  ;
  myvarflag = varflag ;
  varflag = 0 ;
  lab20: {
      
    if ( aritherror ) 
    cleararith () ;
  } 
	;
#ifdef TEXMF_DEBUG
  if ( panicking ) 
  checkmem ( false ) ;
#endif /* TEXMF_DEBUG */
  if ( interrupt != 0 ) 
  if ( OKtointerrupt ) 
  {
    backinput () ;
    {
      if ( interrupt != 0 ) 
      pauseforinstructions () ;
    } 
    getxnext () ;
  } 
  switch ( curcmd ) 
  {case 31 : 
    {
      ldelim = cursym ;
      rdelim = curmod ;
      getxnext () ;
      scanexpression () ;
      if ( ( curcmd == 82 ) && ( curtype >= 16 ) ) 
      {
	p = getnode ( 2 ) ;
	mem [p ].hhfield .b0 = 14 ;
	mem [p ].hhfield .b1 = 11 ;
	initbignode ( p ) ;
	q = mem [p + 1 ].cint ;
	stashin ( q ) ;
	getxnext () ;
	scanexpression () ;
	if ( curtype < 16 ) 
	{
	  disperr ( 0 , 775 ) ;
	  {
	    helpptr = 4 ;
	    helpline [3 ]= 776 ;
	    helpline [2 ]= 777 ;
	    helpline [1 ]= 778 ;
	    helpline [0 ]= 779 ;
	  } 
	  putgetflusherror ( 0 ) ;
	} 
	stashin ( q + 2 ) ;
	checkdelimiter ( ldelim , rdelim ) ;
	curtype = 14 ;
	curexp = p ;
      } 
      else checkdelimiter ( ldelim , rdelim ) ;
    } 
    break ;
  case 32 : 
    {
      groupline = line ;
      if ( internal [7 ]> 0 ) 
      showcmdmod ( curcmd , curmod ) ;
      {
	p = getavail () ;
	mem [p ].hhfield .lhfield = 0 ;
	mem [p ].hhfield .v.RH = saveptr ;
	saveptr = p ;
      } 
      do {
	  dostatement () ;
      } while ( ! ( curcmd != 83 ) ) ;
      if ( curcmd != 84 ) 
      {
	{
	  if ( interaction == 3 ) 
	  ;
	  if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	  {
	    printnl ( 261 ) ;
	    print ( fullsourcefilenamestack [inopen ]) ;
	    print ( 58 ) ;
	    printint ( line ) ;
	    print ( 262 ) ;
	    print ( 780 ) ;
	  } 
	  else {
	      
	    printnl ( 263 ) ;
	    print ( 780 ) ;
	  } 
	} 
	printint ( groupline ) ;
	print ( 781 ) ;
	{
	  helpptr = 2 ;
	  helpline [1 ]= 782 ;
	  helpline [0 ]= 783 ;
	} 
	backerror () ;
	curcmd = 84 ;
      } 
      unsave () ;
      if ( internal [7 ]> 0 ) 
      showcmdmod ( curcmd , curmod ) ;
    } 
    break ;
  case 39 : 
    {
      curtype = 4 ;
      curexp = curmod ;
    } 
    break ;
  case 42 : 
    {
      curexp = curmod ;
      curtype = 16 ;
      getxnext () ;
      if ( curcmd != 54 ) 
      {
	num = 0 ;
	denom = 0 ;
      } 
      else {
	  
	getxnext () ;
	if ( curcmd != 42 ) 
	{
	  backinput () ;
	  curcmd = 54 ;
	  curmod = 72 ;
	  cursym = 9761 ;
	  goto lab30 ;
	} 
	num = curexp ;
	denom = curmod ;
	if ( denom == 0 ) 
	{
	  {
	    if ( interaction == 3 ) 
	    ;
	    if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	    {
	      printnl ( 261 ) ;
	      print ( fullsourcefilenamestack [inopen ]) ;
	      print ( 58 ) ;
	      printint ( line ) ;
	      print ( 262 ) ;
	      print ( 784 ) ;
	    } 
	    else {
		
	      printnl ( 263 ) ;
	      print ( 784 ) ;
	    } 
	  } 
	  {
	    helpptr = 1 ;
	    helpline [0 ]= 785 ;
	  } 
	  error () ;
	} 
	else curexp = makescaled ( num , denom ) ;
	{
	  if ( aritherror ) 
	  cleararith () ;
	} 
	getxnext () ;
      } 
      if ( curcmd >= 30 ) 
      if ( curcmd < 42 ) 
      {
	p = stashcurexp () ;
	scanprimary () ;
	if ( ( abs ( num ) >= abs ( denom ) ) || ( curtype < 14 ) ) 
	dobinary ( p , 71 ) ;
	else {
	    
	  fracmult ( num , denom ) ;
	  freenode ( p , 2 ) ;
	} 
      } 
      goto lab30 ;
    } 
    break ;
  case 33 : 
    donullary ( curmod ) ;
    break ;
  case 34 : 
  case 30 : 
  case 36 : 
  case 43 : 
    {
      c = curmod ;
      getxnext () ;
      scanprimary () ;
      dounary ( c ) ;
      goto lab30 ;
    } 
    break ;
  case 37 : 
    {
      c = curmod ;
      getxnext () ;
      scanexpression () ;
      if ( curcmd != 69 ) 
      {
	missingerr ( 479 ) ;
	print ( 716 ) ;
	printcmdmod ( 37 , c ) ;
	{
	  helpptr = 1 ;
	  helpline [0 ]= 717 ;
	} 
	backerror () ;
      } 
      p = stashcurexp () ;
      getxnext () ;
      scanprimary () ;
      dobinary ( p , c ) ;
      goto lab30 ;
    } 
    break ;
  case 35 : 
    {
      getxnext () ;
      scansuffix () ;
      oldsetting = selector ;
      selector = 5 ;
      showtokenlist ( curexp , 0 , 100000L , 0 ) ;
      flushtokenlist ( curexp ) ;
      curexp = makestring () ;
      selector = oldsetting ;
      curtype = 4 ;
      goto lab30 ;
    } 
    break ;
  case 40 : 
    {
      q = curmod ;
      if ( myvarflag == 77 ) 
      {
	getxnext () ;
	if ( curcmd == 77 ) 
	{
	  curexp = getavail () ;
	  mem [curexp ].hhfield .lhfield = q + 9769 ;
	  curtype = 20 ;
	  goto lab30 ;
	} 
	backinput () ;
      } 
      curtype = 16 ;
      curexp = internal [q ];
    } 
    break ;
  case 38 : 
    makeexpcopy ( curmod ) ;
    break ;
  case 41 : 
    {
      {
	prehead = avail ;
	if ( prehead == 0 ) 
	prehead = getavail () ;
	else {
	    
	  avail = mem [prehead ].hhfield .v.RH ;
	  mem [prehead ].hhfield .v.RH = 0 ;
	;
#ifdef STAT
	  incr ( dynused ) ;
#endif /* STAT */
	} 
      } 
      tail = prehead ;
      posthead = 0 ;
      tt = 1 ;
      while ( true ) {
	  
	t = curtok () ;
	mem [tail ].hhfield .v.RH = t ;
	if ( tt != 0 ) 
	{
	  {
	    p = mem [prehead ].hhfield .v.RH ;
	    q = mem [p ].hhfield .lhfield ;
	    tt = 0 ;
	    if ( eqtb [q ].lhfield % 86 == 41 ) 
	    {
	      q = eqtb [q ].v.RH ;
	      if ( q == 0 ) 
	      goto lab32 ;
	      while ( true ) {
		  
		p = mem [p ].hhfield .v.RH ;
		if ( p == 0 ) 
		{
		  tt = mem [q ].hhfield .b0 ;
		  goto lab32 ;
		} 
		if ( mem [q ].hhfield .b0 != 21 ) 
		goto lab32 ;
		q = mem [mem [q + 1 ].hhfield .lhfield ].hhfield .v.RH ;
		if ( p >= himemmin ) 
		{
		  do {
		      q = mem [q ].hhfield .v.RH ;
		  } while ( ! ( mem [q + 2 ].hhfield .lhfield >= mem [p ]
		  .hhfield .lhfield ) ) ;
		  if ( mem [q + 2 ].hhfield .lhfield > mem [p ].hhfield 
		  .lhfield ) 
		  goto lab32 ;
		} 
	      } 
	    } 
	    lab32: ;
	  } 
	  if ( tt >= 22 ) 
	  {
	    mem [tail ].hhfield .v.RH = 0 ;
	    if ( tt > 22 ) 
	    {
	      posthead = getavail () ;
	      tail = posthead ;
	      mem [tail ].hhfield .v.RH = t ;
	      tt = 0 ;
	      macroref = mem [q + 1 ].cint ;
	      incr ( mem [macroref ].hhfield .lhfield ) ;
	    } 
	    else {
		
	      p = getavail () ;
	      mem [prehead ].hhfield .lhfield = mem [prehead ].hhfield 
	      .v.RH ;
	      mem [prehead ].hhfield .v.RH = p ;
	      mem [p ].hhfield .lhfield = t ;
	      macrocall ( mem [q + 1 ].cint , prehead , 0 ) ;
	      getxnext () ;
	      goto lab20 ;
	    } 
	  } 
	} 
	getxnext () ;
	tail = t ;
	if ( curcmd == 63 ) 
	{
	  getxnext () ;
	  scanexpression () ;
	  if ( curcmd != 64 ) 
	  {
	    backinput () ;
	    backexpr () ;
	    curcmd = 63 ;
	    curmod = 0 ;
	    cursym = 9760 ;
	  } 
	  else {
	      
	    if ( curtype != 16 ) 
	    badsubscript () ;
	    curcmd = 42 ;
	    curmod = curexp ;
	    cursym = 0 ;
	  } 
	} 
	if ( curcmd > 42 ) 
	goto lab31 ;
	if ( curcmd < 40 ) 
	goto lab31 ;
      } 
      lab31: if ( posthead != 0 ) 
      {
	backinput () ;
	p = getavail () ;
	q = mem [posthead ].hhfield .v.RH ;
	mem [prehead ].hhfield .lhfield = mem [prehead ].hhfield .v.RH ;
	mem [prehead ].hhfield .v.RH = posthead ;
	mem [posthead ].hhfield .lhfield = q ;
	mem [posthead ].hhfield .v.RH = p ;
	mem [p ].hhfield .lhfield = mem [q ].hhfield .v.RH ;
	mem [q ].hhfield .v.RH = 0 ;
	macrocall ( macroref , prehead , 0 ) ;
	decr ( mem [macroref ].hhfield .lhfield ) ;
	getxnext () ;
	goto lab20 ;
      } 
      q = mem [prehead ].hhfield .v.RH ;
      {
	mem [prehead ].hhfield .v.RH = avail ;
	avail = prehead ;
	;
#ifdef STAT
	decr ( dynused ) ;
#endif /* STAT */
      } 
      if ( curcmd == myvarflag ) 
      {
	curtype = 20 ;
	curexp = q ;
	goto lab30 ;
      } 
      p = findvariable ( q ) ;
      if ( p != 0 ) 
      makeexpcopy ( p ) ;
      else {
	  
	obliterated ( q ) ;
	helpline [2 ]= 797 ;
	helpline [1 ]= 798 ;
	helpline [0 ]= 799 ;
	putgetflusherror ( 0 ) ;
      } 
      flushnodelist ( q ) ;
      goto lab30 ;
    } 
    break ;
    default: 
    {
      badexp ( 769 ) ;
      goto lab20 ;
    } 
    break ;
  } 
  getxnext () ;
  lab30: if ( curcmd == 63 ) 
  if ( curtype >= 16 ) 
  {
    p = stashcurexp () ;
    getxnext () ;
    scanexpression () ;
    if ( curcmd != 82 ) 
    {
      {
	backinput () ;
	backexpr () ;
	curcmd = 63 ;
	curmod = 0 ;
	cursym = 9760 ;
      } 
      unstashcurexp ( p ) ;
    } 
    else {
	
      q = stashcurexp () ;
      getxnext () ;
      scanexpression () ;
      if ( curcmd != 64 ) 
      {
	missingerr ( 93 ) ;
	{
	  helpptr = 3 ;
	  helpline [2 ]= 801 ;
	  helpline [1 ]= 802 ;
	  helpline [0 ]= 698 ;
	} 
	backerror () ;
      } 
      r = stashcurexp () ;
      makeexpcopy ( q ) ;
      dobinary ( r , 70 ) ;
      dobinary ( p , 71 ) ;
      dobinary ( q , 69 ) ;
      getxnext () ;
    } 
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
scansuffix ( void ) 
#else
scansuffix ( ) 
#endif
{
  /* 30 */ halfword h, t  ;
  halfword p  ;
  h = getavail () ;
  t = h ;
  while ( true ) {
      
    if ( curcmd == 63 ) 
    {
      getxnext () ;
      scanexpression () ;
      if ( curtype != 16 ) 
      badsubscript () ;
      if ( curcmd != 64 ) 
      {
	missingerr ( 93 ) ;
	{
	  helpptr = 3 ;
	  helpline [2 ]= 803 ;
	  helpline [1 ]= 802 ;
	  helpline [0 ]= 698 ;
	} 
	backerror () ;
      } 
      curcmd = 42 ;
      curmod = curexp ;
    } 
    if ( curcmd == 42 ) 
    p = newnumtok ( curmod ) ;
    else if ( ( curcmd == 41 ) || ( curcmd == 40 ) ) 
    {
      p = getavail () ;
      mem [p ].hhfield .lhfield = cursym ;
    } 
    else goto lab30 ;
    mem [t ].hhfield .v.RH = p ;
    t = p ;
    getxnext () ;
  } 
  lab30: curexp = mem [h ].hhfield .v.RH ;
  {
    mem [h ].hhfield .v.RH = avail ;
    avail = h ;
	;
#ifdef STAT
    decr ( dynused ) ;
#endif /* STAT */
  } 
  curtype = 20 ;
} 
void 
#ifdef HAVE_PROTOTYPES
scansecondary ( void ) 
#else
scansecondary ( ) 
#endif
{
  /* 20 22 */ halfword p  ;
  halfword c, d  ;
  halfword macname  ;
  lab20: if ( ( curcmd < 30 ) || ( curcmd > 43 ) ) 
  badexp ( 804 ) ;
  scanprimary () ;
  lab22: if ( curcmd <= 55 ) 
  if ( curcmd >= 52 ) 
  {
    p = stashcurexp () ;
    c = curmod ;
    d = curcmd ;
    if ( d == 53 ) 
    {
      macname = cursym ;
      incr ( mem [c ].hhfield .lhfield ) ;
    } 
    getxnext () ;
    scanprimary () ;
    if ( d != 53 ) 
    dobinary ( p , c ) ;
    else {
	
      backinput () ;
      binarymac ( p , c , macname ) ;
      decr ( mem [c ].hhfield .lhfield ) ;
      getxnext () ;
      goto lab20 ;
    } 
    goto lab22 ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
scantertiary ( void ) 
#else
scantertiary ( ) 
#endif
{
  /* 20 22 */ halfword p  ;
  halfword c, d  ;
  halfword macname  ;
  lab20: if ( ( curcmd < 30 ) || ( curcmd > 43 ) ) 
  badexp ( 805 ) ;
  scansecondary () ;
  if ( curtype == 8 ) 
  materializepen () ;
  lab22: if ( curcmd <= 45 ) 
  if ( curcmd >= 43 ) 
  {
    p = stashcurexp () ;
    c = curmod ;
    d = curcmd ;
    if ( d == 44 ) 
    {
      macname = cursym ;
      incr ( mem [c ].hhfield .lhfield ) ;
    } 
    getxnext () ;
    scansecondary () ;
    if ( d != 44 ) 
    dobinary ( p , c ) ;
    else {
	
      backinput () ;
      binarymac ( p , c , macname ) ;
      decr ( mem [c ].hhfield .lhfield ) ;
      getxnext () ;
      goto lab20 ;
    } 
    goto lab22 ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
scanexpression ( void ) 
#else
scanexpression ( ) 
#endif
{
  /* 20 30 22 25 26 10 */ halfword p, q, r, pp, qq  ;
  halfword c, d  ;
  char myvarflag  ;
  halfword macname  ;
  boolean cyclehit  ;
  scaled x, y  ;
  char t  ;
  myvarflag = varflag ;
  lab20: if ( ( curcmd < 30 ) || ( curcmd > 43 ) ) 
  badexp ( 808 ) ;
  scantertiary () ;
  lab22: if ( curcmd <= 51 ) 
  if ( curcmd >= 46 ) 
  if ( ( curcmd != 51 ) || ( myvarflag != 77 ) ) 
  {
    p = stashcurexp () ;
    c = curmod ;
    d = curcmd ;
    if ( d == 49 ) 
    {
      macname = cursym ;
      incr ( mem [c ].hhfield .lhfield ) ;
    } 
    if ( ( d < 48 ) || ( ( d == 48 ) && ( ( mem [p ].hhfield .b0 == 14 ) || 
    ( mem [p ].hhfield .b0 == 9 ) ) ) ) 
    {
      cyclehit = false ;
      {
	unstashcurexp ( p ) ;
	if ( curtype == 14 ) 
	p = newknot () ;
	else if ( curtype == 9 ) 
	p = curexp ;
	else goto lab10 ;
	q = p ;
	while ( mem [q ].hhfield .v.RH != p ) q = mem [q ].hhfield .v.RH ;
	if ( mem [p ].hhfield .b0 != 0 ) 
	{
	  r = copyknot ( p ) ;
	  mem [q ].hhfield .v.RH = r ;
	  q = r ;
	} 
	mem [p ].hhfield .b0 = 4 ;
	mem [q ].hhfield .b1 = 4 ;
      } 
      lab25: if ( curcmd == 46 ) 
      {
	t = scandirection () ;
	if ( t != 4 ) 
	{
	  mem [q ].hhfield .b1 = t ;
	  mem [q + 5 ].cint = curexp ;
	  if ( mem [q ].hhfield .b0 == 4 ) 
	  {
	    mem [q ].hhfield .b0 = t ;
	    mem [q + 3 ].cint = curexp ;
	  } 
	} 
      } 
      d = curcmd ;
      if ( d == 47 ) 
      {
	getxnext () ;
	if ( curcmd == 58 ) 
	{
	  getxnext () ;
	  y = curcmd ;
	  if ( curcmd == 59 ) 
	  getxnext () ;
	  scanprimary () ;
	  if ( ( curtype != 16 ) || ( curexp < 49152L ) ) 
	  {
	    disperr ( 0 , 826 ) ;
	    {
	      helpptr = 1 ;
	      helpline [0 ]= 827 ;
	    } 
	    putgetflusherror ( 65536L ) ;
	  } 
	  if ( y == 59 ) 
	  curexp = - (integer) curexp ;
	  mem [q + 6 ].cint = curexp ;
	  if ( curcmd == 52 ) 
	  {
	    getxnext () ;
	    y = curcmd ;
	    if ( curcmd == 59 ) 
	    getxnext () ;
	    scanprimary () ;
	    if ( ( curtype != 16 ) || ( curexp < 49152L ) ) 
	    {
	      disperr ( 0 , 826 ) ;
	      {
		helpptr = 1 ;
		helpline [0 ]= 827 ;
	      } 
	      putgetflusherror ( 65536L ) ;
	    } 
	    if ( y == 59 ) 
	    curexp = - (integer) curexp ;
	  } 
	  y = curexp ;
	} 
	else if ( curcmd == 57 ) 
	{
	  mem [q ].hhfield .b1 = 1 ;
	  t = 1 ;
	  getxnext () ;
	  scanprimary () ;
	  knownpair () ;
	  mem [q + 5 ].cint = curx ;
	  mem [q + 6 ].cint = cury ;
	  if ( curcmd != 52 ) 
	  {
	    x = mem [q + 5 ].cint ;
	    y = mem [q + 6 ].cint ;
	  } 
	  else {
	      
	    getxnext () ;
	    scanprimary () ;
	    knownpair () ;
	    x = curx ;
	    y = cury ;
	  } 
	} 
	else {
	    
	  mem [q + 6 ].cint = 65536L ;
	  y = 65536L ;
	  backinput () ;
	  goto lab30 ;
	} 
	if ( curcmd != 47 ) 
	{
	  missingerr ( 408 ) ;
	  {
	    helpptr = 1 ;
	    helpline [0 ]= 825 ;
	  } 
	  backerror () ;
	} 
	lab30: ;
      } 
      else if ( d != 48 ) 
      goto lab26 ;
      getxnext () ;
      if ( curcmd == 46 ) 
      {
	t = scandirection () ;
	if ( mem [q ].hhfield .b1 != 1 ) 
	x = curexp ;
	else t = 1 ;
      } 
      else if ( mem [q ].hhfield .b1 != 1 ) 
      {
	t = 4 ;
	x = 0 ;
      } 
      if ( curcmd == 36 ) 
      {
	cyclehit = true ;
	getxnext () ;
	pp = p ;
	qq = p ;
	if ( d == 48 ) 
	if ( p == q ) 
	{
	  d = 47 ;
	  mem [q + 6 ].cint = 65536L ;
	  y = 65536L ;
	} 
      } 
      else {
	  
	scantertiary () ;
	{
	  if ( curtype != 9 ) 
	  pp = newknot () ;
	  else pp = curexp ;
	  qq = pp ;
	  while ( mem [qq ].hhfield .v.RH != pp ) qq = mem [qq ].hhfield 
	  .v.RH ;
	  if ( mem [pp ].hhfield .b0 != 0 ) 
	  {
	    r = copyknot ( pp ) ;
	    mem [qq ].hhfield .v.RH = r ;
	    qq = r ;
	  } 
	  mem [pp ].hhfield .b0 = 4 ;
	  mem [qq ].hhfield .b1 = 4 ;
	} 
      } 
      {
	if ( d == 48 ) 
	if ( ( mem [q + 1 ].cint != mem [pp + 1 ].cint ) || ( mem [q + 2 
	].cint != mem [pp + 2 ].cint ) ) 
	{
	  {
	    if ( interaction == 3 ) 
	    ;
	    if ( ( filelineerrorstylep && ! ( curinput .namefield == 0 ) ) ) 
	    {
	      printnl ( 261 ) ;
	      print ( fullsourcefilenamestack [inopen ]) ;
	      print ( 58 ) ;
	      printint ( line ) ;
	      print ( 262 ) ;
	      print ( 828 ) ;
	    } 
	    else {
		
	      printnl ( 263 ) ;
	      print ( 828 ) ;
	    } 
	  } 
	  {
	    helpptr = 3 ;
	    helpline [2 ]= 829 ;
	    helpline [1 ]= 830 ;
	    helpline [0 ]= 831 ;
	  } 
	  putgeterror () ;
	  d = 47 ;
	  mem [q + 6 ].cint = 65536L ;
	  y = 65536L ;
	} 
	if ( mem [pp ].hhfield .b1 == 4 ) 
	if ( ( t == 3 ) || ( t == 2 ) ) 
	{
	  mem [pp ].hhfield .b1 = t ;
	  mem [pp + 5 ].cint = x ;
	} 
	if ( d == 48 ) 
	{
	  if ( mem [q ].hhfield .b0 == 4 ) 
	  if ( mem [q ].hhfield .b1 == 4 ) 
	  {
	    mem [q ].hhfield .b0 = 3 ;
	    mem [q + 3 ].cint = 65536L ;
	  } 
	  if ( mem [pp ].hhfield .b1 == 4 ) 
	  if ( t == 4 ) 
	  {
	    mem [pp ].hhfield .b1 = 3 ;
	    mem [pp + 5 ].cint = 65536L ;
	  } 
	  mem [q ].hhfield .b1 = mem [pp ].hhfield .b1 ;
	  mem [q ].hhfield .v.RH = mem [pp ].hhfield .v.RH ;
	  mem [q + 5 ].cint = mem [pp + 5 ].cint ;
	  mem [q + 6 ].cint = mem [pp + 6 ].cint ;
	  freenode ( pp , 7 ) ;
	  if ( qq == pp ) 
	  qq = q ;
	} 
	else {
	    
	  if ( mem [q ].hhfield .b1 == 4 ) 
	  if ( ( mem [q ].hhfield .b0 == 3 ) || ( mem [q ].hhfield .b0 == 
	  2 ) ) 
	  {
	    mem [q ].hhfield .b1 = mem [q ].hhfield .b0 ;
	    mem [q + 5 ].cint = mem [q + 3 ].cint ;
	  } 
	  mem [q ].hhfield .v.RH = pp ;
	  mem [pp + 4 ].cint = y ;
	  if ( t != 4 ) 
	  {
	    mem [pp + 3 ].cint = x ;
	    mem [pp ].hhfield .b0 = t ;
	  } 
	} 
	q = qq ;
      } 
      if ( curcmd >= 46 ) 
      if ( curcmd <= 48 ) 
      if ( ! cyclehit ) 
      goto lab25 ;
      lab26: if ( cyclehit ) 
      {
	if ( d == 48 ) 
	p = q ;
      } 
      else {
	  
	mem [p ].hhfield .b0 = 0 ;
	if ( mem [p ].hhfield .b1 == 4 ) 
	{
	  mem [p ].hhfield .b1 = 3 ;
	  mem [p + 5 ].cint = 65536L ;
	} 
	mem [q ].hhfield .b1 = 0 ;
	if ( mem [q ].hhfield .b0 == 4 ) 
	{
	  mem [q ].hhfield .b0 = 3 ;
	  mem [q + 3 ].cint = 65536L ;
	} 
	mem [q ].hhfield .v.RH = p ;
      } 
      makechoices ( p ) ;
      curtype = 9 ;
      curexp = p ;
    } 
    else {
	
      getxnext () ;
      scantertiary () ;
      if ( d != 49 ) 
      dobinary ( p , c ) ;
      else {
	  
	backinput () ;
	binarymac ( p , c , macname ) ;
	decr ( mem [c ].hhfield .lhfield ) ;
	getxnext () ;
	goto lab20 ;
      } 
    } 
    goto lab22 ;
  } 
  lab10: ;
} 
void 
#ifdef HAVE_PROTOTYPES
getboolean ( void ) 
#else
getboolean ( ) 
#endif
{
  getxnext () ;
  scanexpression () ;
  if ( curtype != 2 ) 
  {
    disperr ( 0 , 832 ) ;
    {
      helpptr = 2 ;
      helpline [1 ]= 833 ;
      helpline [0 ]= 834 ;
    } 
    putgetflusherror ( 31 ) ;
    curtype = 2 ;
  } 
} 
void 
#ifdef HAVE_PROTOTYPES
printcapsule ( void ) 
#else
printcapsule ( ) 
#endif
{
  printchar ( 40 ) ;
  printexp ( gpointer , 0 ) ;
  printchar ( 41 ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
tokenrecycle ( void ) 
#else
tokenrecycle ( ) 
#endif
{
  recyclevalue ( gpointer ) ;
} 
void 
#ifdef HAVE_PROTOTYPES
closefilesandterminate ( void ) 
#else
closefilesandterminate ( ) 
#endif
{
  integer k  ;
  integer lh  ;
  short lkoffset  ;
  halfword p  ;
  scaled x  ;
	;
#ifdef STAT
  if ( internal [12 ]> 0 ) 
  if ( logopened ) 
  {
    fprintf ( logfile , "%c\n",  ' ' ) ;
    fprintf ( logfile , "%s%s\n",  "Here is how much of METAFONT's memory" , " you used:"     ) ;
    fprintf ( logfile , "%c%ld%s",  ' ' , (long)maxstrptr - initstrptr , " string" ) ;
    if ( maxstrptr != initstrptr + 1 ) 
    putc ( 's' ,  logfile );
    fprintf ( logfile , "%s%ld\n",  " out of " , (long)maxstrings - initstrptr ) ;
    fprintf ( logfile , "%c%ld%s%ld\n",  ' ' , (long)maxpoolptr - initpoolptr ,     " string characters out of " , (long)poolsize - initpoolptr ) ;
    fprintf ( logfile , "%c%ld%s%ld\n",  ' ' , (long)lomemmax + 0 + memend - himemmin + 2 ,     " words of memory out of " , (long)memend + 1 ) ;
    fprintf ( logfile , "%c%ld%s%ld\n",  ' ' , (long)stcount , " symbolic tokens out of " , (long)9500 ) ;
    fprintf ( logfile , "%c%ld%s%ld%s%ld%s%ld%s%ld%s%ld%s%ld%s%ld%s%ld%s%ld%c\n",  ' ' , (long)maxinstack , "i," , (long)intptr , "n," ,     (long)maxroundingptr , "r," , (long)maxparamstack , "p," , (long)maxbufstack + 1 ,     "b stack positions out of " , (long)stacksize , "i," , (long)maxinternal , "n," ,     (long)maxwiggle , "r," , (long)150 , "p," , (long)bufsize , 'b' ) ;
  } 
#endif /* STAT */
  if ( ( gfprevptr > 0 ) || ( internal [33 ]> 0 ) ) 
  {
    rover = 23 ;
    mem [rover ].hhfield .v.RH = 268435455L ;
    lomemmax = himemmin - 1 ;
    if ( lomemmax - rover > 268435455L ) 
    lomemmax = 268435455L + rover ;
    mem [rover ].hhfield .lhfield = lomemmax - rover ;
    mem [rover + 1 ].hhfield .lhfield = rover ;
    mem [rover + 1 ].hhfield .v.RH = rover ;
    mem [lomemmax ].hhfield .v.RH = 0 ;
    mem [lomemmax ].hhfield .lhfield = 0 ;
    mem [memtop - 1 ].hhfield .v.RH = 19 ;
    {register integer for_end; k = bc ;for_end = ec ; if ( k <= for_end) do 
      if ( charexists [k ]) 
      tfmwidth [k ]= sortin ( tfmwidth [k ]) ;
    while ( k++ < for_end ) ;} 
    nw = skimp ( 255 ) + 1 ;
    dimenhead [1 ]= mem [memtop - 1 ].hhfield .v.RH ;
    if ( perturbation >= 4096 ) 
    tfmwarning ( 20 ) ;
    fixdesignsize () ;
    fixchecksum () ;
    if ( internal [33 ]> 0 ) 
    {
      mem [memtop - 1 ].hhfield .v.RH = 19 ;
      {register integer for_end; k = bc ;for_end = ec ; if ( k <= for_end) 
      do 
	if ( charexists [k ]) 
	if ( tfmheight [k ]== 0 ) 
	tfmheight [k ]= 15 ;
	else tfmheight [k ]= sortin ( tfmheight [k ]) ;
      while ( k++ < for_end ) ;} 
      nh = skimp ( 15 ) + 1 ;
      dimenhead [2 ]= mem [memtop - 1 ].hhfield .v.RH ;
      if ( perturbation >= 4096 ) 
      tfmwarning ( 21 ) ;
      mem [memtop - 1 ].hhfield .v.RH = 19 ;
      {register integer for_end; k = bc ;for_end = ec ; if ( k <= for_end) 
      do 
	if ( charexists [k ]) 
	if ( tfmdepth [k ]== 0 ) 
	tfmdepth [k ]= 15 ;
	else tfmdepth [k ]= sortin ( tfmdepth [k ]) ;
      while ( k++ < for_end ) ;} 
      nd = skimp ( 15 ) + 1 ;
      dimenhead [3 ]= mem [memtop - 1 ].hhfield .v.RH ;
      if ( perturbation >= 4096 ) 
      tfmwarning ( 22 ) ;
      mem [memtop - 1 ].hhfield .v.RH = 19 ;
      {register integer for_end; k = bc ;for_end = ec ; if ( k <= for_end) 
      do 
	if ( charexists [k ]) 
	if ( tfmitalcorr [k ]== 0 ) 
	tfmitalcorr [k ]= 15 ;
	else tfmitalcorr [k ]= sortin ( tfmitalcorr [k ]) ;
      while ( k++ < for_end ) ;} 
      ni = skimp ( 63 ) + 1 ;
      dimenhead [4 ]= mem [memtop - 1 ].hhfield .v.RH ;
      if ( perturbation >= 4096 ) 
      tfmwarning ( 23 ) ;
      internal [33 ]= 0 ;
      if ( jobname == 0 ) 
      openlogfile () ;
      packjobname ( 1045 ) ;
      while ( ! bopenout ( tfmfile ) ) promptfilename ( 1046 , 1045 ) ;
      metricfilename = bmakenamestring ( tfmfile ) ;
      k = headersize ;
      while ( headerbyte [k ]< 0 ) decr ( k ) ;
      lh = ( k + 3 ) / 4 ;
      if ( bc > ec ) 
      bc = 1 ;
      bchar = roundunscaled ( internal [41 ]) ;
      if ( ( bchar < 0 ) || ( bchar > 255 ) ) 
      {
	bchar = -1 ;
	lkstarted = false ;
	lkoffset = 0 ;
      } 
      else {
	  
	lkstarted = true ;
	lkoffset = 1 ;
      } 
      k = labelptr ;
      if ( labelloc [k ]+ lkoffset > 255 ) 
      {
	lkoffset = 0 ;
	lkstarted = false ;
	do {
	    charremainder [labelchar [k ]]= lkoffset ;
	  while ( labelloc [k - 1 ]== labelloc [k ]) {
	      
	    decr ( k ) ;
	    charremainder [labelchar [k ]]= lkoffset ;
	  } 
	  incr ( lkoffset ) ;
	  decr ( k ) ;
	} while ( ! ( lkoffset + labelloc [k ]< 256 ) ) ;
      } 
      if ( lkoffset > 0 ) 
      while ( k > 0 ) {
	  
	charremainder [labelchar [k ]]= charremainder [labelchar [k ]]
	+ lkoffset ;
	decr ( k ) ;
      } 
      if ( bchlabel < ligtablesize ) 
      {
	ligkern [nl ].b0 = 255 ;
	ligkern [nl ].b1 = 0 ;
	ligkern [nl ].b2 = ( ( bchlabel + lkoffset ) / 256 ) ;
	ligkern [nl ].b3 = ( ( bchlabel + lkoffset ) % 256 ) ;
	incr ( nl ) ;
      } 
      put2bytes ( tfmfile , 6 + lh + ( ec - bc + 1 ) + nw + nh + nd + ni + nl 
      + lkoffset + nk + ne + np ) ;
      put2bytes ( tfmfile , lh ) ;
      put2bytes ( tfmfile , bc ) ;
      put2bytes ( tfmfile , ec ) ;
      put2bytes ( tfmfile , nw ) ;
      put2bytes ( tfmfile , nh ) ;
      put2bytes ( tfmfile , nd ) ;
      put2bytes ( tfmfile , ni ) ;
      put2bytes ( tfmfile , nl + lkoffset ) ;
      put2bytes ( tfmfile , nk ) ;
      put2bytes ( tfmfile , ne ) ;
      put2bytes ( tfmfile , np ) ;
      {register integer for_end; k = 1 ;for_end = 4 * lh ; if ( k <= 
      for_end) do 
	{
	  if ( headerbyte [k ]< 0 ) 
	  headerbyte [k ]= 0 ;
	  putbyte ( headerbyte [k ], tfmfile ) ;
	} 
      while ( k++ < for_end ) ;} 
      {register integer for_end; k = bc ;for_end = ec ; if ( k <= for_end) 
      do 
	if ( ! charexists [k ]) 
	put4bytes ( tfmfile , 0 ) ;
	else {
	    
	  putbyte ( mem [tfmwidth [k ]].hhfield .lhfield , tfmfile ) ;
	  putbyte ( ( mem [tfmheight [k ]].hhfield .lhfield ) * 16 + mem [
	  tfmdepth [k ]].hhfield .lhfield , tfmfile ) ;
	  putbyte ( ( mem [tfmitalcorr [k ]].hhfield .lhfield ) * 4 + 
	  chartag [k ], tfmfile ) ;
	  putbyte ( charremainder [k ], tfmfile ) ;
	} 
      while ( k++ < for_end ) ;} 
      tfmchanged = 0 ;
      {register integer for_end; k = 1 ;for_end = 4 ; if ( k <= for_end) do 
	{
	  put4bytes ( tfmfile , 0 ) ;
	  p = dimenhead [k ];
	  while ( p != 19 ) {
	      
	    put4bytes ( tfmfile , dimenout ( mem [p + 1 ].cint ) ) ;
	    p = mem [p ].hhfield .v.RH ;
	  } 
	} 
      while ( k++ < for_end ) ;} 
      {register integer for_end; k = 0 ;for_end = 255 ; if ( k <= for_end) 
      do 
	if ( skiptable [k ]< ligtablesize ) 
	{
	  printnl ( 1048 ) ;
	  printint ( k ) ;
	  print ( 1049 ) ;
	  ll = skiptable [k ];
	  do {
	      lll = ligkern [ll ].b0 ;
	    ligkern [ll ].b0 = 128 ;
	    ll = ll - lll ;
	  } while ( ! ( lll == 0 ) ) ;
	} 
      while ( k++ < for_end ) ;} 
      if ( lkstarted ) 
      {
	putbyte ( 255 , tfmfile ) ;
	putbyte ( bchar , tfmfile ) ;
	put2bytes ( tfmfile , 0 ) ;
      } 
      else {
	  register integer for_end; k = 1 ;for_end = lkoffset ; if ( k <= 
      for_end) do 
	{
	  ll = labelloc [labelptr ];
	  if ( bchar < 0 ) 
	  {
	    putbyte ( 254 , tfmfile ) ;
	    putbyte ( 0 , tfmfile ) ;
	  } 
	  else {
	      
	    putbyte ( 255 , tfmfile ) ;
	    putbyte ( bchar , tfmfile ) ;
	  } 
	  put2bytes ( tfmfile , ll + lkoffset ) ;
	  do {
	      decr ( labelptr ) ;
	  } while ( ! ( labelloc [labelptr ]< ll ) ) ;
	} 
      while ( k++ < for_end ) ;} 
      {register integer for_end; k = 0 ;for_end = nl - 1 ; if ( k <= 
      for_end) do 
	tfmqqqq ( ligkern [k ]) ;
      while ( k++ < for_end ) ;} 
      {register integer for_end; k = 0 ;for_end = nk - 1 ; if ( k <= 
      for_end) do 
	put4bytes ( tfmfile , dimenout ( kern [k ]) ) ;
      while ( k++ < for_end ) ;} 
      {register integer for_end; k = 0 ;for_end = ne - 1 ; if ( k <= 
      for_end) do 
	tfmqqqq ( exten [k ]) ;
      while ( k++ < for_end ) ;} 
      {register integer for_end; k = 1 ;for_end = np ; if ( k <= for_end) do 
	if ( k == 1 ) 
	if ( abs ( param [1 ]) < 134217728L ) 
	put4bytes ( tfmfile , param [1 ]* 16 ) ;
	else {
	    
	  incr ( tfmchanged ) ;
	  if ( param [1 ]> 0 ) 
	  put4bytes ( tfmfile , 2147483647L ) ;
	  else put4bytes ( tfmfile , -2147483647L ) ;
	} 
	else put4bytes ( tfmfile , dimenout ( param [k ]) ) ;
      while ( k++ < for_end ) ;} 
      if ( tfmchanged > 0 ) 
      {
	if ( tfmchanged == 1 ) 
	printnl ( 1050 ) ;
	else {
	    
	  printnl ( 40 ) ;
	  printint ( tfmchanged ) ;
	  print ( 1051 ) ;
	} 
	print ( 1052 ) ;
      } 
	;
#ifdef STAT
      if ( internal [12 ]> 0 ) 
      {
	fprintf ( logfile , "%c\n",  ' ' ) ;
	if ( bchlabel < ligtablesize ) 
	decr ( nl ) ;
	fprintf ( logfile , "%s%ld%s%ld%s%ld%s%ld%s%ld%s%ld%s%ld%s%ld%s\n",  "(You used " , (long)nw , "w," , (long)nh , "h," , (long)nd , "d," ,         (long)ni , "i," , (long)nl , "l," , (long)nk , "k," , (long)ne , "e," , (long)np ,         "p metric file positions" ) ;
	fprintf ( logfile , "%s%s%ld%s%ld%s%ld%s\n",  "  out of " , "256w,16h,16d,64i," , (long)ligtablesize ,         "l," , (long)maxkerns , "k,256e," , (long)maxfontdimen , "p)" ) ;
      } 
#endif /* STAT */
      printnl ( 1047 ) ;
      printfilename ( 0 , metricfilename , 0 ) ;
      printchar ( 46 ) ;
      bclose ( tfmfile ) ;
    } 
    if ( gfprevptr > 0 ) 
    {
      {
	gfbuf [gfptr ]= 248 ;
	incr ( gfptr ) ;
	if ( gfptr == gflimit ) 
	gfswap () ;
      } 
      gffour ( gfprevptr ) ;
      gfprevptr = gfoffset + gfptr - 5 ;
      gffour ( internal [26 ]* 16 ) ;
      {register integer for_end; k = 1 ;for_end = 4 ; if ( k <= for_end) do 
	{
	  gfbuf [gfptr ]= headerbyte [k ];
	  incr ( gfptr ) ;
	  if ( gfptr == gflimit ) 
	  gfswap () ;
	} 
      while ( k++ < for_end ) ;} 
      gffour ( internal [27 ]) ;
      gffour ( internal [28 ]) ;
      gffour ( gfminm ) ;
      gffour ( gfmaxm ) ;
      gffour ( gfminn ) ;
      gffour ( gfmaxn ) ;
      {register integer for_end; k = 0 ;for_end = 255 ; if ( k <= for_end) 
      do 
	if ( charexists [k ]) 
	{
	  x = gfdx [k ]/ 65536L ;
	  if ( ( gfdy [k ]== 0 ) && ( x >= 0 ) && ( x < 256 ) && ( gfdx [k 
	  ]== x * 65536L ) ) 
	  {
	    {
	      gfbuf [gfptr ]= 246 ;
	      incr ( gfptr ) ;
	      if ( gfptr == gflimit ) 
	      gfswap () ;
	    } 
	    {
	      gfbuf [gfptr ]= k ;
	      incr ( gfptr ) ;
	      if ( gfptr == gflimit ) 
	      gfswap () ;
	    } 
	    {
	      gfbuf [gfptr ]= x ;
	      incr ( gfptr ) ;
	      if ( gfptr == gflimit ) 
	      gfswap () ;
	    } 
	  } 
	  else {
	      
	    {
	      gfbuf [gfptr ]= 245 ;
	      incr ( gfptr ) ;
	      if ( gfptr == gflimit ) 
	      gfswap () ;
	    } 
	    {
	      gfbuf [gfptr ]= k ;
	      incr ( gfptr ) ;
	      if ( gfptr == gflimit ) 
	      gfswap () ;
	    } 
	    gffour ( gfdx [k ]) ;
	    gffour ( gfdy [k ]) ;
	  } 
	  x = mem [tfmwidth [k ]+ 1 ].cint ;
	  if ( abs ( x ) > maxtfmdimen ) 
	  if ( x > 0 ) 
	  x = 16777215L ;
	  else x = -16777215L ;
	  else x = makescaled ( x * 16 , internal [26 ]) ;
	  gffour ( x ) ;
	  gffour ( charptr [k ]) ;
	} 
      while ( k++ < for_end ) ;} 
      {
	gfbuf [gfptr ]= 249 ;
	incr ( gfptr ) ;
	if ( gfptr == gflimit ) 
	gfswap () ;
      } 
      gffour ( gfprevptr ) ;
      {
	gfbuf [gfptr ]= 131 ;
	incr ( gfptr ) ;
	if ( gfptr == gflimit ) 
	gfswap () ;
      } 
      k = 4 + ( ( gfbufsize - gfptr ) % 4 ) ;
      while ( k > 0 ) {
	  
	{
	  gfbuf [gfptr ]= 223 ;
	  incr ( gfptr ) ;
	  if ( gfptr == gflimit ) 
	  gfswap () ;
	} 
	decr ( k ) ;
      } 
      if ( gflimit == halfbuf ) 
      writegf ( halfbuf , gfbufsize - 1 ) ;
      if ( gfptr > 0 ) 
      writegf ( 0 , gfptr - 1 ) ;
      printnl ( 1063 ) ;
      printfilename ( 0 , outputfilename , 0 ) ;
      print ( 558 ) ;
      printint ( totalchars ) ;
      if ( totalchars != 1 ) 
      print ( 1064 ) ;
      else print ( 1065 ) ;
      print ( 1066 ) ;
      printint ( gfoffset + gfptr ) ;
      print ( 1067 ) ;
      bclose ( gffile ) ;
    } 
  } 
  if ( logopened ) 
  {
    putc ('\n',  logfile );
    aclose ( logfile ) ;
    selector = selector - 2 ;
    if ( selector == 1 ) 
    {
      printnl ( 1075 ) ;
      printfilename ( 0 , texmflogname , 0 ) ;
      printchar ( 46 ) ;
    } 
  } 
  println () ;
  if ( ( editnamestart != 0 ) && ( interaction > 0 ) ) 
  calledit ( strpool , editnamestart , editnamelength , editline ) ;
  mfluaendprogram () ;
} 
#ifdef TEXMF_DEBUG
void 
#ifdef HAVE_PROTOTYPES
debughelp ( void ) 
#else
debughelp ( ) 
#endif
{
  /* 888 10 */ integer k, l, m, n  ;
  while ( true ) {
      
    ;
    printnl ( 1082 ) ;
    fflush ( stdout ) ;
    read ( stdin , m ) ;
    if ( m < 0 ) 
    goto lab10 ;
    else if ( m == 0 ) 
    {
      goto lab888 ;
      lab888: m = 0 ;
    } 
    else {
	
      read ( stdin , n ) ;
      switch ( m ) 
      {case 1 : 
	printword ( mem [n ]) ;
	break ;
      case 2 : 
	printint ( mem [n ].hhfield .lhfield ) ;
	break ;
      case 3 : 
	printint ( mem [n ].hhfield .v.RH ) ;
	break ;
      case 4 : 
	{
	  printint ( eqtb [n ].lhfield ) ;
	  printchar ( 58 ) ;
	  printint ( eqtb [n ].v.RH ) ;
	} 
	break ;
      case 5 : 
	printvariablename ( n ) ;
	break ;
      case 6 : 
	printint ( internal [n ]) ;
	break ;
      case 7 : 
	doshowdependencies () ;
	break ;
      case 9 : 
	showtokenlist ( n , 0 , 100000L , 0 ) ;
	break ;
      case 10 : 
	slowprint ( n ) ;
	break ;
      case 11 : 
	checkmem ( n > 0 ) ;
	break ;
      case 12 : 
	searchmem ( n ) ;
	break ;
      case 13 : 
	{
	  read ( stdin , l ) ;
	  printcmdmod ( n , l ) ;
	} 
	break ;
      case 14 : 
	{register integer for_end; k = 0 ;for_end = n ; if ( k <= for_end) 
	do 
	  print ( buffer [k ]) ;
	while ( k++ < for_end ) ;} 
	break ;
      case 15 : 
	panicking = ! panicking ;
	break ;
	default: 
	print ( 63 ) ;
	break ;
      } 
    } 
  } 
  lab10: ;
} 
#endif /* TEXMF_DEBUG */
