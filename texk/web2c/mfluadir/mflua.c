#include "mflua.h"

/**************************************************************/
/*                                                            */
/* type definitionss                                          */
/*                                                            */
/**************************************************************/
typedef integer halfword;

typedef integer strnumber;

typedef unsigned char quarterword;

typedef integer scaled;

typedef integer angle ;

typedef char smallnumber;

typedef unsigned char eightbits;

typedef union
{
  struct
  {
#ifdef WORDS_BIGENDIAN
    halfword RH, LH;
#else
    halfword LH, RH;
#endif
  } v;

  struct
  { /* Make B0,B1 overlap the most significant bytes of LH.  */
#ifdef WORDS_BIGENDIAN
    halfword junk;
    short B0, B1;
#else /* not WORDS_BIGENDIAN */
  /* If 32-bit mem<ory words, have to do something.  */
#if defined (SMALLTeX) || defined (SMALLMF) || defined (SMALLMP)
    fixme
#else
    short B1, B0;
#endif /* big memory words */
#endif /* LittleEndian */
  } u;
} twohalves;



typedef struct
{
  struct
  {
#ifdef WORDS_BIGENDIAN
    quarterword B0, B1, B2, B3;
#else
    quarterword B3, B2, B1, B0;
#endif
  } u;
} fourquarters;



typedef union
{
#ifdef TeX
  glueratio gr;
  twohalves hh;
#else
  twohalves hhfield;
#endif
#ifdef XeTeX
  voidpointer ptr;
#endif
#ifdef WORDS_BIGENDIAN
  integer cint;
  fourquarters qqqq;
#else /* not WORDS_BIGENDIAN */
  struct
  {
    //#if defined (TeX) && !defined (SMALLTeX) || defined (MF) && !defined (SMALLMF) || defined (MP) && !defined (SMALLMP)
    halfword junk;
    //#endif /* big {TeX,MF,MP} */
    integer CINT;
  } u;

  struct
  {
#ifndef XeTeX
    //#if defined (TeX) && !defined (SMALLTeX) || defined (MF) && !defined (SMALLMF) || defined (MP) && !defined (SMALLMP)
    halfword junk;
    //#endif /* big {TeX,MF,MP} */
#endif
    fourquarters QQQQ;
  } v;
#endif /* not WORDS_BIGENDIAN */
} memoryword;


#define EXTERN extern
#define b0 u.B0
#define b1 u.B1
#define b2 u.B2
#define b3 u.B3

#define rh v.RH
#define lhfield v.LH

#ifndef WORDS_BIGENDIAN
#define cint u.CINT
#endif

#ifndef WORDS_BIGENDIAN
#define qqqq v.QQQQ
#endif



//#define printdiagnostic(s, t, nuline) zprintdiagnostic((strnumber) (s), (strnumber) (t), (boolean) (nuline))
//#define print(s) zprint((integer) (s))
//#define printarg(q, n, b) zprintarg((halfword) (q), (integer) (n), (halfword) (b)
//memoryword  *mems[]  ;
EXTERN memoryword  *mem  ;
// Lazy 
EXTERN void znsincos(int);



/**************************************************************/
/*                                                            */
/* private functions                                          */
/*                                                            */
/**************************************************************/
lua_State *Luas[];

//EXTERN memoryword *mem  ;

void priv_lua_reporterrors(lua_State *L, int status)
{
  if ( status!=0 ) {
    //Luas[0] = 0;     // Why ?
    fprintf(stderr,"\n! %s\n",lua_tostring(L, -1));
    lua_pop(L, 1); /* remove error message */
  }
}

/*                                                            */ 
/* These depend from mf0.c, so it's not a good idea           */
/*                                                            */ 
/*                                                            */ 
/*                                                            */ 

/* @d link(#) == mem[#].hh.rh {the |link| field of a memory word} */
static int priv_mfweb_link(lua_State *L)
{
  halfword p,q;
  p = (halfword) lua_tonumber(L,1);
  q = mem [p ].hhfield.v.RH ;
  lua_pushnumber(L,q);
  return 1;
}

/* @d info(#) == mem[#].hh.lh {the |info| field of a memory word} */
static int priv_mfweb_info(lua_State *L)
{
  halfword p,q;
  p = (halfword) lua_tonumber(L,1);
  q = mem [p ].hhfield.v.LH ;
  lua_pushnumber(L,q);
  return 1;
}


/* @d x_coord(#) == mem[#+1].sc {the |x| coordinate of this knot} */
static int priv_mfweb_x_coord(lua_State *L)
{
  halfword p;
  int q;
  p = (halfword) lua_tonumber(L,1);
  q = mem [p + 1 ].cint ;
  lua_pushnumber(L,q);
  return 1;
}

/* @d y_coord(#) == mem[#+2].sc {the |y| coordinate of this knot} */
static int priv_mfweb_y_coord(lua_State *L)
{
  halfword p,q;
  p = (halfword) lua_tonumber(L,1);
  q = mem [p + 2 ].cint;
  lua_pushnumber(L,q);
  return 1;
}


/* @d left_type(#) == mem[#].hh.b0 {characterizes the path entering this knot} */
static int priv_mfweb_left_type(lua_State *L)
{
  halfword p,q;
  p = (halfword) lua_tonumber(L,1);
  q = mem [p ].hhfield .b0;
  lua_pushnumber(L,q);
  return 1;
}

/* @d right_type(#) == mem[#].hh.b1 {characterizes the path leaving this knot} */
static int priv_mfweb_right_type(lua_State *L)
{
  halfword p,q;
  p = (halfword) lua_tonumber(L,1);
  q = mem [p ].hhfield .b1;
  lua_pushnumber(L,q);
  return 1;
}


/* @d left_x(#) == mem[#+3].sc {the |x| coordinate of previous control point} */
static int priv_mfweb_left_x(lua_State *L)
{
  halfword p;
  integer q ;
  p = (halfword) lua_tonumber(L,1);
  q = (integer) mem[p + 3].cint ;
  lua_pushnumber(L,q);
  return 1;
}


/* @d left_y(#) == mem[#+4].sc {the |y| coordinate of previous control point} */
static int priv_mfweb_left_y(lua_State *L)
{
  halfword p;
  integer q ;
  p = (halfword) lua_tonumber(L,1);
  q = (integer) mem[p + 4].cint ;
  lua_pushnumber(L,q);
  return 1;
}


/* @d right_x(#) == mem[#+5].sc {the |x| coordinate of next control point} */
static int priv_mfweb_right_x(lua_State *L)
{
  halfword p;
  integer q ;
  p = (halfword) lua_tonumber(L,1);
  q = (integer) mem[p + 5].cint ;
  lua_pushnumber(L,q);
  return 1;
}

/* @d right_y(#) == mem[#+6].sc {the |y| coordinate of next control point} */
static int priv_mfweb_right_y(lua_State *L)
{
  halfword p;
  integer q;
  p = (halfword) lua_tonumber(L,1);
  q = (integer) mem[p + 6].cint ;
  lua_pushnumber(L,q);
  return 1;
}

/* @ Conversely, the |n_sin_cos| routine takes an |angle| and produces the sine */
/* and cosine of that angle. The results of this routine are */
/* stored in global integer variables |n_sin| and |n_cos|. */

/* @<Glob...@>= */
/* @!n_sin,@!n_cos:fraction; {results computed by |n_sin_cos|} */

/* @ Given an integer |z| that is $2^{20}$ times an angle $\theta$ in degrees, */
/* the purpose of |n_sin_cos(z)| is to set */
/* |x=@t$r\cos\theta$@>| and |y=@t$r\sin\theta$@>| (approximately), */
/* for some rather large number~|r|. The maximum of |x| and |y| */
/* will be between $2^{28}$ and $2^{30}$, so that there will be hardly */
/* any loss of accuracy. Then |x| and~|y| are divided by~|r|. */
static int priv_mfweb_n_sin_cos(lua_State *L)
{
  angle z;
  z = (angle) lua_tonumber(L,1);
  znsincos(z);
  return 0;
}

	   
/* @ When a lot of work is being done on a particular edge structure, we plant */
/* a pointer to its main header in the global variable |cur_edges|. */
/* This saves us from having to pass this pointer as a parameter over and */
/* over again between subroutines. */

/* Similarly, |cur_wt| is a global weight that is being used by several */
/* procedures at once. */

/* @<Glob...@>= */
/* @!cur_edges:pointer; {the edge structure of current interest} */
/* @!cur_wt:integer; {the edge weight of current interest} */
EXTERN halfword curedges;
static int priv_mfweb_LUAGLOBALGET_cur_edges(lua_State *L)
{
  halfword p = curedges;
  lua_pushnumber(L,p);
  return 1;
}


/* @<Glob...@>= */
/* @!cur_type:small_number; {the type of the expression just found} */
/* @!cur_exp:integer; {the value of the expression just found} */
EXTERN integer curexp;
static int priv_mfweb_LUAGLOBALGET_cur_exp(lua_State *L)
{
  halfword p = curexp;
  lua_pushnumber(L,p);
  return 1;
}






/* @d mem_top==30000 {largest index in the |mem| array dumped by \.{INIMF}; */
/*   must be substantially larger than |mem_min| */
/*   and not greater than |mem_max|} */
EXTERN integer memtop  ;
static int priv_mfweb_LUAGLOBALGET_mem_top(lua_State *L)
{
  integer p = memtop;
  lua_pushnumber(L,p);
  return 1;
}



/* And there are two global variables that affect the rounding */
/* decisions, as we'll see later; they are called |cur_pen| and |cur_path_type|. */
/* The latter will be |double_path_code| if |make_spec| is being */
/* applied to a double path.*/
/* @!cur_pen:pointer; {an implicit input of |make_spec|, used in autorounding} */
EXTERN halfword curpen  ;
static int priv_mfweb_LUAGLOBALGET_cur_pen(lua_State *L)
{
  halfword p = curpen;
  lua_pushnumber(L,p);
  return 1;
}


/* @ The current octant code appears in a global variable. If, for example, */  
/* we have |octant=third_octant|, it means that a curve traveling in a north to */  
/* north-westerly direction has been rotated for the purposes of internal */  
/* calculations so that the |move| data travels in an east to north-easterly */  
/* direction. We want to unrotate as we update the edge structure.       */  
/*
/* @<Glob...@>=                                                          */ 
/* @!octant:first_octant..sixth_octant; {the current octant of interest} */
EXTERN char octant  ;
static int priv_mfweb_LUAGLOBALGET_octant(lua_State *L)
{
  char p = octant;
  lua_pushnumber(L,p);
  return 1;
}





/* @ \MF\ also has a bunch of internal parameters that a user might want to */
/* fuss with. Every such parameter has an identifying code number, defined here. */

/* @d tracing_titles=1 {show titles online when they appear} */
/* @d tracing_equations=2 {show each variable when it becomes known} */
/* @d tracing_capsules=3 {show capsules too} */
/* @d tracing_choices=4 {show the control points chosen for paths} */
/* @d tracing_specs=5 {show subdivision of paths into octants before digitizing} */
/* @d tracing_pens=6 {show details of pens that are made} */
/* @d tracing_commands=7 {show commands and operations before they are performed} */
/* @d tracing_restores=8 {show when a variable or internal is restored} */
/* @d tracing_macros=9 {show macros before they are expanded} */
/* @d tracing_edges=10 {show digitized edges as they are computed} */
/* @d tracing_output=11 {show digitized edges as they are output} */
/* @d tracing_stats=12 {show memory usage at end of job} */
/* @d tracing_online=13 {show long diagnostics on terminal and in the log file} */
/* @d year=14 {the current year (e.g., 1984)} */
/* @d month=15 {the current month (e.g., 3 $\equiv$ March)} */
/* @d day=16 {the current day of the month} */
/* @d time=17 {the number of minutes past midnight when this job started} */
/* @d char_code=18 {the number of the next character to be output} */
/* @d char_ext=19 {the extension code of the next character to be output} */
/* @d char_wd=20 {the width of the next character to be output} */
/* @d char_ht=21 {the height of the next character to be output} */
/* @d char_dp=22 {the depth of the next character to be output} */
/* @d char_ic=23 {the italic correction of the next character to be output} */
/* @d char_dx=24 {the device's $x$ movement for the next character, in pixels} */
/* @d char_dy=25 {the device's $y$ movement for the next character, in pixels} */
/* @d design_size=26 {the unit of measure used for |char_wd..char_ic|, in points} */
/* @d hppp=27 {the number of horizontal pixels per point} */
/* @d vppp=28 {the number of vertical pixels per point} */
/* @d x_offset=29 {horizontal displacement of shipped-out characters} */
/* @d y_offset=30 {vertical displacement of shipped-out characters} */
/* @d pausing=31 {positive to display lines on the terminal before they are read} */
/* @d showstopping=32 {positive to stop after each \&{show} command} */
/* @d fontmaking=33 {positive if font metric output is to be produced} */
/* @d proofing=34 {positive for proof mode, negative to suppress output} */
/* @d smoothing=35 {positive if moves are to be ``smoothed''} */
/* @d autorounding=36 {controls path modification to ``good'' points} */
/* @d granularity=37 {autorounding uses this pixel size} */
/* @d fillin=38 {extra darkness of diagonal lines} */
/* @d turning_check=39 {controls reorientation of clockwise paths} */
/* @d warning_check=40 {controls error message when variable value is large} */
/* @d boundary_char=41 {the right boundary character for ligatures} */
/* @d max_given_internal=41 */

#define maxinternal ( 300 ) 
#define roundunscaled(i) (((i>>15)+1)>>1)
EXTERN scaled internal[maxinternal + 1]  ;
static int priv_mfweb_LUAGLOBALGET_char_code(lua_State *L)
{
  integer char_code=18;
  integer p =  roundunscaled ( internal [char_code]) % 256 ;
  lua_pushnumber(L,p);
  return 1;
}
static int priv_mfweb_LUAGLOBALGET_char_ext(lua_State *L)
{
  integer char_ext=19;
  integer p =  roundunscaled ( internal [char_ext]) ;
  lua_pushnumber(L,p);
  return 1;
}


/* @d char_wd=20 {the width of the next character to be output} */
/* @d char_ht=21 {the height of the next character to be output} */
/* @d char_dp=22 {the depth of the next character to be output} */
/* @d char_ic=23 {the italic correction of the next character to be output} */
static int priv_mfweb_LUAGLOBALGET_char_wd(lua_State *L)
{
  integer char_wd=20;
  integer p =   internal [char_wd]  ;
  lua_pushnumber(L,p);
  return 1;
}
static int priv_mfweb_LUAGLOBALGET_char_ht(lua_State *L)
{
  integer char_ht=21;
  integer p =   internal [char_ht]  ;
  lua_pushnumber(L,p);
  return 1;
}
static int priv_mfweb_LUAGLOBALGET_char_dp(lua_State *L)
{
  integer char_dp=22;
  integer p =   internal [char_dp]  ;
  lua_pushnumber(L,p);
  return 1;
}
static int priv_mfweb_LUAGLOBALGET_char_ic(lua_State *L)
{
  integer char_ic=23;
  integer p =   internal [char_ic]  ;
  lua_pushnumber(L,p);
  return 1;
}
















/**************************************************************/
/*                                                            */
/* mflua layer                                                */
/*                                                            */
/**************************************************************/
int mfluabeginprogram()
{
  lua_State *L = luaL_newstate();
  luaL_openlibs(L);
  Luas[0] = L;
   /* execute Lua external "begin_program.lua" */
  const char* file = "begin_program.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ) {
      res = lua_pcall(L, 0, 0, 0);
    }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;
}

int mfluaendprogram()
{
  lua_State *L = Luas[0];
   /* execute Lua external "end_program.lua" */
  const char* file = "end_program.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ) {
      res = lua_pcall(L, 0, 0, 0);
    }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;
}


int mfluaPREstartofMF()
{
  lua_State *L = Luas[0];
  const char* file = "start_of_MF.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ){
      res = lua_pcall(L, 0, 0, 0);
      if (res==0){
	lua_getglobal(L, "PRE_start_of_MF");  /* function to be called */
	/* do the call (0 arguments, 1 result) */
	res = lua_pcall(L, 0, 1, 0) ;
	if (res==0) {
	  /* retrieve result */
	  int z = 0;
	  if (!lua_isnumber(L, -1)){
	    fprintf(stderr,"\n! Error:function `PRE_start_of_MF number\n",lua_tostring(L, -1));
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }else {
	    z = lua_tonumber(L, -1);
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }
	}
      }
  }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;

}


int mfluaPREmaincontrol()
{
  lua_State *L = Luas[0];
  const char* file = "main_control.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ){
      res = lua_pcall(L, 0, 0, 0);
      if (res==0){
	lua_getglobal(L, "PRE_main_control");  /* function to be called */
	/* do the call (0 arguments, 1 result) */
	res = lua_pcall(L, 0, 1, 0) ;
	if (res==0) {
	  /* retrieve result */
	  int z = 0;
	  if (!lua_isnumber(L, -1)){
	    fprintf(stderr,"\n! Error:function `PRE_main_control\n",lua_tostring(L, -1));
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }else {
	    z = lua_tonumber(L, -1);
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }
	}
      }
  }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;

}


int mfluaPOSTmaincontrol()
{
  lua_State *L = Luas[0];
  const char* file = "main_control.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ){
      res = lua_pcall(L, 0, 0, 0);
      if (res==0){
	lua_getglobal(L, "POST_main_control");  /* function to be called */
	/* do the call (0 arguments, 1 result) */
	res = lua_pcall(L, 0, 1, 0) ;
	if (res==0) {
	  /* retrieve result */
	  int z = 0;
	  if (!lua_isnumber(L, -1)){
	    fprintf(stderr,"\n! Error:function `POST_main_control\n",lua_tostring(L, -1));
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }else {
	    z = lua_tonumber(L, -1);
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }
	}
      }
  }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;

}



int mfluainitialize()
{
  /* execute Lua external "mfluaini.lua" */
  lua_State *L = Luas[0];
  /* register lua functions */
  lua_pushcfunction(L, priv_mfweb_link);lua_setglobal(L, "link");
  lua_pushcfunction(L, priv_mfweb_info);lua_setglobal(L, "info");
  lua_pushcfunction(L, priv_mfweb_x_coord);lua_setglobal(L, "x_coord");
  lua_pushcfunction(L, priv_mfweb_y_coord);lua_setglobal(L, "y_coord");
  lua_pushcfunction(L, priv_mfweb_left_type);lua_setglobal(L, "left_type");
  lua_pushcfunction(L, priv_mfweb_right_type);lua_setglobal(L, "right_type");
  lua_pushcfunction(L, priv_mfweb_left_x);lua_setglobal(L, "left_x");
  lua_pushcfunction(L, priv_mfweb_left_y);lua_setglobal(L, "left_y");
  lua_pushcfunction(L, priv_mfweb_right_x);lua_setglobal(L, "right_x");
  lua_pushcfunction(L, priv_mfweb_right_y);lua_setglobal(L, "right_y");
  lua_pushcfunction(L, priv_mfweb_n_sin_cos);lua_setglobal(L, "n_sin_cos");
  lua_pushcfunction(L, priv_mfweb_LUAGLOBALGET_cur_edges);lua_setglobal(L, "LUAGLOBALGET_cur_edges");
  lua_pushcfunction(L, priv_mfweb_LUAGLOBALGET_cur_exp);lua_setglobal(L, "LUAGLOBALGET_cur_exp");
  lua_pushcfunction(L, priv_mfweb_LUAGLOBALGET_mem_top);lua_setglobal(L, "LUAGLOBALGET_mem_top");
  lua_pushcfunction(L, priv_mfweb_LUAGLOBALGET_cur_pen);lua_setglobal(L, "LUAGLOBALGET_cur_pen");
  lua_pushcfunction(L, priv_mfweb_LUAGLOBALGET_octant);lua_setglobal(L, "LUAGLOBALGET_octant");
  lua_pushcfunction(L, priv_mfweb_LUAGLOBALGET_char_code);lua_setglobal(L, "LUAGLOBALGET_char_code");
  lua_pushcfunction(L, priv_mfweb_LUAGLOBALGET_char_ext);lua_setglobal(L, "LUAGLOBALGET_char_ext");
  lua_pushcfunction(L, priv_mfweb_LUAGLOBALGET_char_wd);lua_setglobal(L, "LUAGLOBALGET_char_wd");
  lua_pushcfunction(L, priv_mfweb_LUAGLOBALGET_char_ht);lua_setglobal(L, "LUAGLOBALGET_char_ht");
  lua_pushcfunction(L, priv_mfweb_LUAGLOBALGET_char_dp);lua_setglobal(L, "LUAGLOBALGET_char_dp");
  lua_pushcfunction(L, priv_mfweb_LUAGLOBALGET_char_ic);lua_setglobal(L, "LUAGLOBALGET_char_ic");
  //lua_pushcfunction(L, priv_mfweb_SKELETON);lua_setglobal(L, "SKELETON");
  // 
  /* execute Lua external "mfluaini.lua" */
  const char* file = "mfluaini.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ) {
      res = lua_pcall(L, 0, 0, 0);
    }
  priv_lua_reporterrors(L, res);
  return 0;
}


int mfluaPOSTfinalcleanup()
{
  lua_State *L = Luas[0];
  const char* file = "final_cleanup.lua";
  int res = luaL_loadfile(L, file);
  //if (res!=0) {fprintf(stderr,"\n! Warning: file final_cleanup not loaded\n",lua_tostring(L, -1)); return res;}
  if ( res==0 ){
      res = lua_pcall(L, 0, 0, 0);
      //if (res!=0) {fprintf(stderr,"\n! Error: final_cleanup lua_pcall fails\n",lua_tostring(L, -1)); return res;}           	
      if (res==0){
	lua_getglobal(L, "POST_final_cleanup");  /* function to be called */
	/* do the call (0 arguments, 1 result) */
	res = lua_pcall(L, 0, 1, 0) ;
        //if (res!=0) {fprintf(stderr,"\n! Error:function `POST_final_cleanup called fails\n",lua_tostring(L, -1)); return res;}
	if (res==0) {
	  /* retrieve result */
	  int z = 0;
	  if (!lua_isnumber(L, -1)){
	    fprintf(stderr,"\n! Error:function `POST_final_cleanup\n",lua_tostring(L, -1));
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }else {
	    z = lua_tonumber(L, -1);
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }
	}
      }
  }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;
}



/* Not a good way: */
/* 1) these definitions are taken from mfcoerc.h which is generated at run-time */
/* 2) too much coupling with webc2c translation of mf.web*/
/*                               */
/* #define printdiagnostic(s, t, nuline) zprintdiagnostic((strnumber) (s), (strnumber) (t), (boolean) (nuline)) */
/* #define print(s) zprint((integer) (s)) */
/* #define printarg(q, n, b) zprintarg((halfword) (q), (integer) (n), (halfword) (b) */
/* int mfluaprintpath P3C(halfword, h , strnumber, s , boolean, nuline) */
/* { */
/*   fprintf(stderr,"\n! %d \n",s); */
/*   printdiagnostic ( 517 , s , nuline ) ; */
/*   println () ; */
/*   print ( 518 ) ; */
/*   println () ; */
/*   fprintf(stderr,"\n! %s\n","*end***************"); */

/*   lua_State *L = Luas[0]; */
/*   const char* file = "print_path.lua"; */
/*   int res = luaL_loadfile(L, file); */
/*   if ( res==0 ) { */
/*       res = lua_pcall(L, 0, 0, 0); */
/*     } */
/*   // */
/*   //stackdump_g(L); */

/*   // */
/*   priv_lua_reporterrors(L, res); */
/*   return 0; */

/* } */

int mfluaprintpath P3C(halfword, h , strnumber, s , boolean, nuline)
{
  halfword p, q ;

  p = h ;
  lua_State *L = Luas[0];
  const char* file = "print_path.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ){
      res = lua_pcall(L, 0, 0, 0);
      if (res==0){
	lua_getglobal(L, "print_path");  /* function to be called */
	lua_pushnumber(L, h);   /* push 1st argument */
	lua_pushnumber(L, s);   /* push 2nd argument */
	lua_pushnumber(L, nuline);   /* push 3nd argument */
	/* do the call (3 arguments, 1 result) */
	res = lua_pcall(L, 3, 1, 0) ;
	if (res==0) {
	  /* retrieve result */
	  int z = 0;
	  if (!lua_isnumber(L, -1)){
	    fprintf(stderr,"\n! Error:function `print_path' must return a number\n",lua_tostring(L, -1));
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }else {
	    z = lua_tonumber(L, -1);
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }
	}
      }
  }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;

}

 
int mfluaprintedges P4C (strnumber,s, boolean,nuline, integer, xoff, integer, yoff)
{

  lua_State *L = Luas[0];
  const char* file = "print_edges.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ){
      res = lua_pcall(L, 0, 0, 0);
      if (res==0){
	lua_getglobal(L, "print_edges");  /* function to be called */
	lua_pushnumber(L, s);   /* push 1st argument */
	lua_pushnumber(L, nuline);   /* push 2nd argument */
	lua_pushnumber(L, xoff);   /* push 3nd argument */
	lua_pushnumber(L, yoff);   /* push 4nd argument */
	/* do the call (4 arguments, 1 result) */
	res = lua_pcall(L, 4, 1, 0) ;
	if (res==0) {
	  /* retrieve result */
	  int z = 0;
	  if (!lua_isnumber(L, -1)){
	    fprintf(stderr,"\n! Error:function `print_edges' must return a number\n",lua_tostring(L, -1));
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }else {
	    z = lua_tonumber(L, -1);
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }
	}
      }
  }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;

}


/* int mfluaoffsetprep P2C (halfword, c, halfword, h) */
/* { */

/*   lua_State *L = Luas[0]; */
/*   const char* file = "offset_prep.lua"; */
/*   int res = luaL_loadfile(L, file); */
/*   if ( res==0 ){ */
/*       res = lua_pcall(L, 0, 0, 0); */
/*       if (res==0){ */
/* 	lua_getglobal(L, "offset_prep");  /\* function to be called *\/ */
/* 	lua_pushnumber(L, c);   /\* push 1st argument *\/ */
/* 	lua_pushnumber(L, h);   /\* push 2nd argument *\/ */
/* 	/\* do the call (2 arguments, 1 result) *\/ */
/* 	res = lua_pcall(L, 2, 1, 0) ; */
/* 	if (res==0) { */
/* 	  /\* retrieve result *\/ */
/* 	  int z = 0; */
/* 	  if (!lua_isnumber(L, -1)){ */
/* 	    fprintf(stderr,"\n! Error:function `offset_prep' must return a number\n",lua_tostring(L, -1)); */
/* 	    lua_pop(L, 1);  /\* pop returned value *\/ */
/* 	    return z; */
/* 	  }else { */
/* 	    z = lua_tonumber(L, -1); */
/* 	    lua_pop(L, 1);  /\* pop returned value *\/ */
/* 	    return z; */
/* 	  } */
/* 	} */
/*       } */
/*   } */
/*   // */
/*   //stackdump_g(L); */
/*   // */
/*   priv_lua_reporterrors(L, res); */
/*   return 0; */

/* } */


/*                                     */
/* Sensor before and after offset_prep */
/*                                     */
int mfluaPREoffsetprep P2C (halfword, c, halfword, h)
{

  lua_State *L = Luas[0];
  const char* file = "offset_prep.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ){
      res = lua_pcall(L, 0, 0, 0);
      if (res==0){
	lua_getglobal(L, "PRE_offset_prep");  /* function to be called */
	lua_pushnumber(L, c);   /* push 1st argument */
	lua_pushnumber(L, h);   /* push 2nd argument */
	/* do the call (2 arguments, 1 result) */
	res = lua_pcall(L, 2, 1, 0) ;
	if (res==0) {
	  /* retrieve result */
	  int z = 0;
	  if (!lua_isnumber(L, -1)){
	    fprintf(stderr,"\n! Error:function `PRE_offset_prep' must return a number\n",lua_tostring(L, -1));
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }else {
	    z = lua_tonumber(L, -1);
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }
	}
      }
  }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;

}

int mfluaPOSToffsetprep P2C (halfword, c, halfword, h)
{

  lua_State *L = Luas[0];
  const char* file = "offset_prep.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ){
      res = lua_pcall(L, 0, 0, 0);
      if (res==0){
	lua_getglobal(L, "POST_offset_prep");  /* function to be called */
	lua_pushnumber(L, c);   /* push 1st argument */
	lua_pushnumber(L, h);   /* push 2nd argument */
	/* do the call (2 arguments, 1 result) */
	res = lua_pcall(L, 2, 1, 0) ;
	if (res==0) {
	  /* retrieve result */
	  int z = 0;
	  if (!lua_isnumber(L, -1)){
	    fprintf(stderr,"\n! Error:function `PRE_offset_prep' must return a number\n",lua_tostring(L, -1));
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }else {
	    z = lua_tonumber(L, -1);
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }
	}
      }
  }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;

}


int mfluaPREfillenveloperhs P1C (halfword, rhs)
{
  lua_State *L = Luas[0];
  const char* file = "do_add_to.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ){
      res = lua_pcall(L, 0, 0, 0);
      if (res==0){
	lua_getglobal(L, "PRE_fill_envelope_rhs");  /* function to be called */
	lua_pushnumber(L, rhs);   /* push 1st argument */
	/* do the call (1 arguments, 1 result) */
	res = lua_pcall(L, 1, 1, 0) ;
	if (res==0) {
	  /* retrieve result */
	  int z = 0;
	  if (!lua_isnumber(L, -1)){
	    fprintf(stderr,"\n! Error:function `PRE_fill_envelope_rhs' must return a number\n",lua_tostring(L, -1));
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }else {
	    z = lua_tonumber(L, -1);
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }
	}
      }
  }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;
}


int mfluaPOSTfillenveloperhs P1C (halfword, rhs)
{
  lua_State *L = Luas[0];
  const char* file = "do_add_to.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ){
      res = lua_pcall(L, 0, 0, 0);
      if (res==0){
	lua_getglobal(L, "POST_fill_envelope_rhs");  /* function to be called */
	lua_pushnumber(L, rhs);   /* push 1st argument */
	/* do the call (1 arguments, 1 result) */
	res = lua_pcall(L, 1, 1, 0) ;
	if (res==0) {
	  /* retrieve result */
	  int z = 0;
	  if (!lua_isnumber(L, -1)){
	    fprintf(stderr,"\n! Error:function `POST_fill_envelope_rhs' must return a number\n",lua_tostring(L, -1));
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }else {
	    z = lua_tonumber(L, -1);
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }
	}
      }
  }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;
}



int mfluaPREfillenvelopelhs P1C (halfword, lhs)
{
  lua_State *L = Luas[0];
  const char* file = "do_add_to.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ){
      res = lua_pcall(L, 0, 0, 0);
      if (res==0){
	lua_getglobal(L, "PRE_fill_envelope_lhs");  /* function to be called */
	lua_pushnumber(L, lhs);   /* push 1st argument */
	/* do the call (1 arguments, 1 result) */
	res = lua_pcall(L, 1, 1, 0) ;
	if (res==0) {
	  /* retrieve result */
	  int z = 0;
	  if (!lua_isnumber(L, -1)){
	    fprintf(stderr,"\n! Error:function `PRE_fill_envelope_lhs' must return a number\n",lua_tostring(L, -1));
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }else {
	    z = lua_tonumber(L, -1);
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }
	}
      }
  }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;
}


int mfluaPOSTfillenvelopelhs P1C (halfword, lhs)
{
  lua_State *L = Luas[0];
  const char* file = "do_add_to.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ){
      res = lua_pcall(L, 0, 0, 0);
      if (res==0){
	lua_getglobal(L, "POST_fill_envelope_lhs");  /* function to be called */
	lua_pushnumber(L, lhs);   /* push 1st argument */
	/* do the call (1 arguments, 1 result) */
	res = lua_pcall(L, 1, 1, 0) ;
	if (res==0) {
	  /* retrieve result */
	  int z = 0;
	  if (!lua_isnumber(L, -1)){
	    fprintf(stderr,"\n! Error:function `POST_fill_envelope_lhs' must return a number\n",lua_tostring(L, -1));
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }else {
	    z = lua_tonumber(L, -1);
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }
	}
      }
  }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;
}



int mfluaPREfillspecrhs P1C (halfword, rhs)
{
  lua_State *L = Luas[0];
  const char* file = "do_add_to.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ){
      res = lua_pcall(L, 0, 0, 0);
      if (res==0){
	lua_getglobal(L, "PRE_fill_spec_rhs");  /* function to be called */
	lua_pushnumber(L, rhs);   /* push 1st argument */
	/* do the call (1 arguments, 1 result) */
	res = lua_pcall(L, 1, 1, 0) ;
	if (res==0) {
	  /* retrieve result */
	  int z = 0;
	  if (!lua_isnumber(L, -1)){
	    fprintf(stderr,"\n! Error:function `PRE_fill_spec_rhs' must return a number\n",lua_tostring(L, -1));
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }else {
	    z = lua_tonumber(L, -1);
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }
	}
      }
  }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;
}


int mfluaPOSTfillspecrhs P1C (halfword, rhs)
{
  lua_State *L = Luas[0];
  const char* file = "do_add_to.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ){
      res = lua_pcall(L, 0, 0, 0);
      if (res==0){
	lua_getglobal(L, "POST_fill_spec_rhs");  /* function to be called */
	lua_pushnumber(L, rhs);   /* push 1st argument */
	/* do the call (1 arguments, 1 result) */
	res = lua_pcall(L, 1, 1, 0) ;
	if (res==0) {
	  /* retrieve result */
	  int z = 0;
	  if (!lua_isnumber(L, -1)){
	    fprintf(stderr,"\n! Error:function `POST_fill_spec_rhs' must return a number\n",lua_tostring(L, -1));
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }else {
	    z = lua_tonumber(L, -1);
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }
	}
      }
  }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;
}


int mfluaPREfillspeclhs P1C (halfword, lhs)
{
  lua_State *L = Luas[0];
  const char* file = "do_add_to.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ){
      res = lua_pcall(L, 0, 0, 0);
      if (res==0){
	lua_getglobal(L, "PRE_fill_spec_lhs");  /* function to be called */
	lua_pushnumber(L, lhs);   /* push 1st argument */
	/* do the call (1 arguments, 1 result) */
	res = lua_pcall(L, 1, 1, 0) ;
	if (res==0) {
	  /* retrieve result */
	  int z = 0;
	  if (!lua_isnumber(L, -1)){
	    fprintf(stderr,"\n! Error:function `PRE_fill_spec_lhs' must return a number\n",lua_tostring(L, -1));
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }else {
	    z = lua_tonumber(L, -1);
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }
	}
      }
  }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;
}


int mfluaPOSTfillspeclhs P1C (halfword, lhs)
{
  lua_State *L = Luas[0];
  const char* file = "do_add_to.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ){
      res = lua_pcall(L, 0, 0, 0);
      if (res==0){
	lua_getglobal(L, "POST_fill_spec_lhs");  /* function to be called */
	lua_pushnumber(L, lhs);   /* push 1st argument */
	/* do the call (1 arguments, 1 result) */
	res = lua_pcall(L, 1, 1, 0) ;
	if (res==0) {
	  /* retrieve result */
	  int z = 0;
	  if (!lua_isnumber(L, -1)){
	    fprintf(stderr,"\n! Error:function `POST_fill_spec_lhs' must return a number\n",lua_tostring(L, -1));
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }else {
	    z = lua_tonumber(L, -1);
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }
	}
      }
  }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;
}

int mfluaPREmovetoedges P1C (halfword, lhs)
{
  lua_State *L = Luas[0];
  const char* file = "fill_spec.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ){
      res = lua_pcall(L, 0, 0, 0);
      if (res==0){
	lua_getglobal(L, "PRE_move_to_edges");  /* function to be called */
	lua_pushnumber(L, lhs);   /* push 1st argument */
	/* do the call (1 arguments, 1 result) */
	res = lua_pcall(L, 1, 1, 0) ;
	if (res==0) {
	  /* retrieve result */
	  int z = 0;
	  if (!lua_isnumber(L, -1)){
	    fprintf(stderr,"\n! Error:function `PRE_move_to_edges' must return a number\n",lua_tostring(L, -1));
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }else {
	    z = lua_tonumber(L, -1);
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }
	}
      }
  }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;
}



int mfluaPOSTmovetoedges P1C (halfword, lhs)
{
  lua_State *L = Luas[0];
  const char* file = "fill_spec.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ){
      res = lua_pcall(L, 0, 0, 0);
      if (res==0){
	lua_getglobal(L, "POST_move_to_edges");  /* function to be called */
	lua_pushnumber(L, lhs);   /* push 1st argument */
	/* do the call (1 arguments, 1 result) */
	res = lua_pcall(L, 1, 1, 0) ;
	if (res==0) {
	  /* retrieve result */
	  int z = 0;
	  if (!lua_isnumber(L, -1)){
	    fprintf(stderr,"\n! Error:function `POST_move_to_edges' must return a number\n",lua_tostring(L, -1));
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }else {
	    z = lua_tonumber(L, -1);
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }
	}
      }
  }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;
}



int mfluaPREmakechoices P1C (halfword, p)
{
  lua_State *L = Luas[0];
  const char* file = "scan_direction.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ){
      res = lua_pcall(L, 0, 0, 0);
      if (res==0){
	lua_getglobal(L, "PRE_make_choices");  /* function to be called */
	lua_pushnumber(L, p);   /* push 1st argument */
	/* do the call (1 arguments, 1 result) */
	res = lua_pcall(L, 1, 1, 0) ;
	if (res==0) {
	  /* retrieve result */
	  int z = 0;
	  if (!lua_isnumber(L, -1)){
	    fprintf(stderr,"\n! Error:function `PRE_make_choices' must return a number\n",lua_tostring(L, -1));
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }else {
	    z = lua_tonumber(L, -1);
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }
	}
      }
  }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;
}


int mfluaPOSTmakechoices P1C (halfword, p)
{
  lua_State *L = Luas[0];
  const char* file = "scan_direction.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ){
      res = lua_pcall(L, 0, 0, 0);
      if (res==0){
	lua_getglobal(L, "POST_make_choices");  /* function to be called */
	lua_pushnumber(L, p);   /* push 1st argument */
	/* do the call (1 arguments, 1 result) */
	res = lua_pcall(L, 1, 1, 0) ;
	if (res==0) {
	  /* retrieve result */
	  int z = 0;
	  if (!lua_isnumber(L, -1)){
	    fprintf(stderr,"\n! Error:function `POST_make_choices' must return a number\n",lua_tostring(L, -1));
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }else {
	    z = lua_tonumber(L, -1);
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }
	}
      }
  }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;
}






int mfluaprintretrogradeline P4C (integer,x0, integer,y0, integer, cur_x, integer, cur_y)
{
  lua_State *L = Luas[0];
  const char* file = "skew_line_edges.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ){
      res = lua_pcall(L, 0, 0, 0);
      if (res==0){
	lua_getglobal(L, "print_retrograde_line");  /* function to be called */
	lua_pushnumber(L, x0);   /* push 1st argument */
	lua_pushnumber(L, y0);   /* push 2nd argument */
	lua_pushnumber(L, cur_x);   /* push 3nd argument */
	lua_pushnumber(L, cur_y);   /* push 4nd argument */
	/* do the call (4 arguments, 1 result) */
	res = lua_pcall(L, 4, 1, 0) ;
	if (res==0) {
	  /* retrieve result */
	  int z = 0;
	  if (!lua_isnumber(L, -1)){
	    fprintf(stderr,"\n! Error:function `print_retrograde_line\n",lua_tostring(L, -1));
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }else {
	    z = lua_tonumber(L, -1);
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }
	}
      }
  }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;

}


int mfluaprinttransitionlinefrom P2C(integer,x,integer,y)
{
  lua_State *L = Luas[0];
  const char* file = "fill_envelope.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ){
      res = lua_pcall(L, 0, 0, 0);
      if (res==0){
	lua_getglobal(L, "print_transition_line_from");  /* function to be called */
	lua_pushnumber(L, x);   /* push 1st argument */
	lua_pushnumber(L, y);   /* push 2nd argument */
	/* do the call (2 arguments, 1 result) */
	res = lua_pcall(L, 2, 1, 0) ;
	if (res==0) {
	  /* retrieve result */
	  int z = 0;
	  if (!lua_isnumber(L, -1)){
	    fprintf(stderr,"\n! Error:function `print_transition_from' must return a number\n",lua_tostring(L, -1));
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }else {
	    z = lua_tonumber(L, -1);
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }
	}
      }
  }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;
}

int mfluaprinttransitionlineto P2C(integer,x,integer,y)
{
  lua_State *L = Luas[0];
  const char* file = "fill_envelope.lua";
  int res = luaL_loadfile(L, file);
  if ( res==0 ){
      res = lua_pcall(L, 0, 0, 0);
      if (res==0){
	lua_getglobal(L, "print_transition_line_to");  /* function to be called */
	lua_pushnumber(L, x);   /* push 1st argument */
	lua_pushnumber(L, y);   /* push 2nd argument */
	/* do the call (2 arguments, 1 result) */
	res = lua_pcall(L, 2, 1, 0) ;
	if (res==0) {
	  /* retrieve result */
	  int z = 0;
	  if (!lua_isnumber(L, -1)){
	    fprintf(stderr,"\n! Error:function `print_transition_to' must return a number\n",lua_tostring(L, -1));
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }else {
	    z = lua_tonumber(L, -1);
	    lua_pop(L, 1);  /* pop returned value */
	    return z;
	  }
	}
      }
  }
  //
  //stackdump_g(L);
  //
  priv_lua_reporterrors(L, res);
  return 0;
}
