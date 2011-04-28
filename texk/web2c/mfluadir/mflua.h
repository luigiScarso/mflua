#include "lua51/lua.h"
#include "lua51/lualib.h"
#include "lua51/lauxlib.h"
#include <kpathsea/c-proto.h> 
#include <web2c/config.h> 
//#include <web2c/texmfmem.h>

/*#include "mfd.h" */

extern lua_State* Luas[];
/* You MUST NOT use because it has not arguments */
extern int mfluabeginprogram();
extern int mfluaPREstartofMF();
extern int mfluaPOSTstartofMF();
extern int mfluaPREmaincontrol();
extern int mfluaPOSTmaincontrol();
extern int mfluainitialize();
extern int mfluaPOSTfinalcleanup();
extern int mfluaendprogram();

/* You MUST use P*H macros and declare them in texmf.defines */
extern int mfluaprintpath P3H(int,int,int);
extern int mfluaprintedges P4H(int,int,int,int);

extern int mfluaPREoffsetprep P2H(int,int); 
/* extern int mfluaoffsetprep P2H(int,int); */
extern int mfluaPOSToffsetprep P2H(int,int); 

extern mfluaPREfillenveloperhs P1H(int);
extern mfluaPOSTfillenveloperhs P1H(int);
extern mfluaPREfillenvelopelhs P1H(int);
extern mfluaPOSTfillenvelopelhs P1H(int);


extern mfluaPREfillspecrhs P1H(int);
extern mfluaPOSTfillspecrhs P1H(int);
extern mfluaPREfillspeclhs P1H(int);
extern mfluaPOSTfillspeclhs P1H(int);

extern mfluaPREmakechoicesP1H(int);
extern mfluaPOSTmakechoicesP1H(int);


extern mfluaPREmovetoedges P1H(int);
extern mfluaPOSTmovetoedges P1H(int);


extern int mfluaprintretrogradeline P4H(int,int,int,int);


extern int mfluaprinttransitionlinefrom P2H(int,int);
extern int mfluaprinttransitionlineto P2H(int,int);
