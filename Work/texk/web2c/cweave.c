/*1:*/
#line 70 "../../../texk/web2c/cwebdir/cweave.w"
/*5:*/
#line 35 "../../../texk/web2c/cwebdir/common.h"

#line 99 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
#include <stdio.h> 

extern char*versionstring;
#include <kpathsea/kpathsea.h> 
#line 37 "../../../texk/web2c/cwebdir/common.h"

/*:5*//*37:*/
#line 681 "../../../texk/web2c/cwebdir/cweave.w"

#line 683 "../../../texk/web2c/cwebdir/cweave.w"
#include <stdlib.h>  

/*:37*/
#line 70 "../../../texk/web2c/cwebdir/cweave.w"

#define banner "This is CWEAVE, Version 3.64" \

#define max_bytes 1000000 \

#define max_names 10239 \

#define max_sections 10239
#define hash_size 8501
#define buf_size 1000
#define longest_name 1000
#define long_buf_size (buf_size+longest_name) 
#define line_length 80 \

#define max_refs 65535
#define max_toks 65535 \

#define max_texts 10239 \

#define max_scraps 10000
#define stack_size 400 \

#define ctangle 0
#define cweave 1 \

#define and_and 04
#define lt_lt 020
#define gt_gt 021
#define plus_plus 013
#define minus_minus 01
#define minus_gt 031
#define not_eq 032
#define lt_eq 034
#define gt_eq 035
#define eq_eq 036
#define or_or 037
#define dot_dot_dot 016
#define colon_colon 06
#define period_ast 026
#define minus_gt_ast 027 \

#define xisalpha(c) (isalpha(c) &&((eight_bits) c<0200) ) 
#define xisdigit(c) (isdigit(c) &&((eight_bits) c<0200) ) 
#define xisspace(c) (isspace(c) &&((eight_bits) c<0200) ) 
#define xislower(c) (islower(c) &&((eight_bits) c<0200) ) 
#define xisupper(c) (isupper(c) &&((eight_bits) c<0200) ) 
#define xisxdigit(c) (isxdigit(c) &&((eight_bits) c<0200) )  \

#define length(c) (c+1) ->byte_start-(c) ->byte_start
#define print_id(c) term_write((c) ->byte_start,length((c) ) ) 
#define llink link
#define rlink dummy.Rlink
#define root name_dir->rlink \

#define chunk_marker 0 \

#define spotless 0
#define harmless_message 1
#define error_message 2
#define fatal_message 3
#define mark_harmless {if(history==spotless) history= harmless_message;}
#define mark_error history= error_message
#define confusion(s) fatal("! This can't happen: ",s)  \

#define max_file_name_length 1024
#define cur_file file[include_depth]
#define cur_file_name file_name[include_depth]
#define web_file_name file_name[0]
#define cur_line line[include_depth] \

#define show_banner flags['b']
#define show_progress flags['p']
#define show_happiness flags['h'] \

#define update_terminal fflush(stdout) 
#define new_line putchar('\n') 
#define putxchar putchar
#define term_write(a,b) fflush(stdout) ,fwrite(a,sizeof(char) ,b,stdout) 
#define C_printf(c,a) fprintf(C_file,c,a) 
#define C_putc(c) putc(c,C_file)  \

#define ilk dummy.Ilk
#define normal 0
#define roman 1
#define wildcard 2
#define typewriter 3
#define abnormal(a) (a->ilk> typewriter) 
#define func_template 4
#define custom 5
#define alfop 22
#define else_like 26
#define public_like 40
#define operator_like 41
#define new_like 42
#define catch_like 43
#define for_like 45
#define do_like 46
#define if_like 47
#define delete_like 48
#define raw_ubin 49
#define const_like 50
#define raw_int 51
#define int_like 52
#define case_like 53
#define sizeof_like 54
#define struct_like 55
#define typedef_like 56
#define define_like 57
#define template_like 58 \

#define file_flag (3*cite_flag) 
#define def_flag (2*cite_flag) 
#define cite_flag 10240
#define xref equiv_or_xref \

#define append_xref(c) if(xref_ptr==xmem_end) overflow("cross-reference") ; \
else(++xref_ptr) ->num= c;
#define no_xref (flags['x']==0) 
#define make_xrefs flags['x']
#define is_tiny(p) ((p+1) ->byte_start==(p) ->byte_start+1) 
#define unindexed(a) (a<res_wd_end&&a->ilk>=custom)  \
 \

#define ignore 00
#define verbatim 02
#define begin_short_comment 03
#define begin_comment '\t'
#define underline '\n'
#define noop 0177
#define xref_roman 0203
#define xref_wildcard 0204
#define xref_typewriter 0205
#define TeX_string 0206
#define ord 0207
#define join 0210
#define thin_space 0211
#define math_break 0212
#define line_break 0213
#define big_line_break 0214
#define no_line_break 0215
#define pseudo_semi 0216
#define macro_arg_open 0220
#define macro_arg_close 0221
#define trace 0222
#define translit_code 0223
#define output_defs_code 0224
#define format_code 0225
#define definition 0226
#define begin_C 0227
#define section_name 0230
#define new_section 0231 \

#define constant 0200
#define string 0201
#define identifier 0202 \

#define isxalpha(c) ((c) =='_'||(c) =='$')  \

#define ishigh(c) ((eight_bits) (c) > 0177)  \
 \

#define left_preproc ord
#define right_preproc 0217 \

#define compress(c) if(loc++<=limit) return(c)  \

#define c_line_write(c) fflush(active_file) ,fwrite(out_buf+1,sizeof(char) ,c,active_file) 
#define tex_putc(c) putc(c,active_file) 
#define tex_new_line putc('\n',active_file) 
#define tex_printf(c) fprintf(active_file,c)  \

#define out(c) {if(out_ptr>=out_buf_end) break_out() ;*(++out_ptr) = c;} \

#define app_tok(c) {if(tok_ptr+2> tok_mem_end) overflow("token") ;*(tok_ptr++) = c;} \

#define exp 1
#define unop 2
#define binop 3
#define ubinop 4 \

#define cast 5
#define question 6
#define lbrace 7
#define rbrace 8
#define decl_head 9
#define comma 10
#define lpar 11
#define rpar 12
#define prelangle 13
#define prerangle 14
#define langle 15
#define colcol 18
#define base 19
#define decl 20
#define struct_head 21
#define stmt 23
#define function 24
#define fn_decl 25
#define semi 27
#define colon 28
#define tag 29
#define if_head 30
#define else_head 31
#define if_clause 32
#define lproc 35
#define rproc 36
#define insert 37
#define section_scrap 38
#define dead 39
#define ftemplate 59
#define new_exp 60
#define begin_arg 61
#define end_arg 62 \

#define math_rel 0206
#define big_cancel 0210
#define cancel 0211
#define indent 0212
#define outdent 0213
#define opt 0214
#define backup 0215
#define break_space 0216
#define force 0217
#define big_force 0220
#define preproc_line 0221 \

#define quoted_char 0222 \

#define end_translation 0223
#define inserted 0224
#define qualifier 0225 \

#define trans trans_plus.Trans \

#define id_flag 10240
#define res_flag 2*id_flag
#define section_flag 3*id_flag
#define tok_flag 4*id_flag
#define inner_tok_flag 5*id_flag \

#define no_math 2
#define yes_math 1
#define maybe_math 0
#define big_app2(a) big_app1(a) ;big_app1(a+1) 
#define big_app3(a) big_app2(a) ;big_app1(a+2) 
#define big_app4(a) big_app3(a) ;big_app1(a+3) 
#define app(a) *(tok_ptr++) = a
#define app1(a) *(tok_ptr++) = tok_flag+(int) ((a) ->trans-tok_start)  \

#define cat1 (pp+1) ->cat
#define cat2 (pp+2) ->cat
#define cat3 (pp+3) ->cat
#define lhs_not_simple (pp->cat!=public_like \
&&pp->cat!=semi \
&&pp->cat!=prelangle \
&&pp->cat!=prerangle \
&&pp->cat!=template_like \
&&pp->cat!=new_like \
&&pp->cat!=new_exp \
&&pp->cat!=ftemplate \
&&pp->cat!=raw_ubin \
&&pp->cat!=const_like \
&&pp->cat!=raw_int \
&&pp->cat!=operator_like)  \
 \

#define no_ident_found (token_pointer) 0
#define case_found (token_pointer) 1
#define operator_found (token_pointer) 2 \

#define force_lines flags['f']
#define freeze_text *(++text_ptr) = tok_ptr \

#define safe_tok_incr 20
#define safe_text_incr 10
#define safe_scrap_incr 10 \

#define app_scrap(c,b) { \
(++scrap_ptr) ->cat= (c) ;scrap_ptr->trans= text_ptr; \
scrap_ptr->mathness= 5*(b) ; \
freeze_text; \
} \

#define make_pb flags['e'] \

#define inner 0
#define outer 1 \

#define cur_end cur_state.end_field
#define cur_tok cur_state.tok_field
#define cur_mode cur_state.mode_field
#define init_stack stack_ptr= stack;cur_mode= outer \

#define res_word 0201
#define section_code 0200 \

#define save_position save_line= out_line;save_place= out_ptr
#define emit_space_if_needed if(save_line!=out_line||save_place!=out_ptr)  \
out_str("\\Y") ; \
space_checked= 1 \
 \

#define depth cat
#define head trans_plus.Head
#define sort_pointer scrap_pointer
#define sort_ptr scrap_ptr
#define max_sorts max_scraps \

#define infinity 255 \


#line 71 "../../../texk/web2c/cwebdir/cweave.w"

/*4:*/
#line 29 "../../../texk/web2c/cwebdir/common.h"

#line 31 "../../../texk/web2c/cwebdir/common.h"
typedef char unsigned eight_bits;
extern boolean program;
extern int phase;

/*:4*//*6:*/
#line 57 "../../../texk/web2c/cwebdir/common.h"

char section_text[longest_name+1];
char*section_text_end= section_text+longest_name;
char*id_first;
char*id_loc;

/*:6*//*7:*/
#line 72 "../../../texk/web2c/cwebdir/common.h"

extern char buffer[];
extern char*buffer_end;
extern char*loc;
extern char*limit;

/*:7*//*8:*/
#line 87 "../../../texk/web2c/cwebdir/common.h"

typedef struct name_info{
char*byte_start;
struct name_info*link;
union{
struct name_info*Rlink;

char Ilk;
}dummy;
char*equiv_or_xref;
}name_info;
typedef name_info*name_pointer;
typedef name_pointer*hash_pointer;
extern char byte_mem[];
extern char*byte_mem_end;
extern name_info name_dir[];
extern name_pointer name_dir_end;
extern name_pointer name_ptr;
extern char*byte_ptr;
extern name_pointer hash[];
extern hash_pointer hash_end;
extern hash_pointer h;
#line 112 "../../../texk/web2c/cwebdir/cweav-w2c.ch"

extern name_pointer id_lookup P3H(char*,char*,char);

extern name_pointer section_lookup P3H(char*,char*,char);
extern void print_section_name P1H(name_pointer);
extern void sprint_section_name P2H(char*,name_pointer);
#line 112 "../../../texk/web2c/cwebdir/common.h"

/*:8*//*9:*/
#line 122 "../../../texk/web2c/cwebdir/common.h"

#line 129 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
extern int history;
extern void err_print P1H(char*);
extern int wrap_up P1H(void);
extern void fatal P2H(char*,char*);
extern void overflow P1H(char*);
#line 128 "../../../texk/web2c/cwebdir/common.h"

/*:9*//*10:*/
#line 137 "../../../texk/web2c/cwebdir/common.h"

#line 147 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
extern int include_depth;
#line 139 "../../../texk/web2c/cwebdir/common.h"
extern FILE*file[];
extern FILE*change_file;
extern char C_file_name[];
extern char tex_file_name[];
extern char idx_file_name[];
extern char scn_file_name[];
extern char file_name[][max_file_name_length];

extern char change_file_name[];
#line 154 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
extern int line[];
extern int change_line;
#line 150 "../../../texk/web2c/cwebdir/common.h"
extern boolean input_has_ended;
extern boolean changing;
extern boolean web_file_open;
#line 163 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
extern void reset_input P1H(void);
extern int get_line P1H(void);
extern void check_complete P1H(void);
#line 156 "../../../texk/web2c/cwebdir/common.h"

/*:10*//*11:*/
#line 158 "../../../texk/web2c/cwebdir/common.h"

typedef unsigned short sixteen_bits;
extern sixteen_bits section_count;
extern boolean changed_section[];
extern boolean change_pending;
extern boolean print_where;

/*:11*//*12:*/
#line 170 "../../../texk/web2c/cwebdir/common.h"

extern int argc;
extern char**argv;
extern boolean flags[];

/*:12*//*13:*/
#line 182 "../../../texk/web2c/cwebdir/common.h"

extern FILE*C_file;
extern FILE*tex_file;
extern FILE*idx_file;
extern FILE*scn_file;
extern FILE*active_file;

/*:13*//*14:*/
#line 191 "../../../texk/web2c/cwebdir/common.h"

#line 173 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
extern void common_init P1H(void);
#line 144 "../../../texk/web2c/cwebdir/cweave.w"

/*:14*/
#line 72 "../../../texk/web2c/cwebdir/cweave.w"

/*17:*/
#line 232 "../../../texk/web2c/cwebdir/cweave.w"

typedef struct xref_info{
sixteen_bits num;
struct xref_info*xlink;
}xref_info;
typedef xref_info*xref_pointer;

/*:17*//*23:*/
#line 344 "../../../texk/web2c/cwebdir/cweave.w"

typedef sixteen_bits token;
typedef token*token_pointer;
typedef token_pointer*text_pointer;

/*:23*//*102:*/
#line 2087 "../../../texk/web2c/cwebdir/cweave.w"

typedef struct{
eight_bits cat;
eight_bits mathness;
union{
text_pointer Trans;
/*231:*/
#line 4403 "../../../texk/web2c/cwebdir/cweave.w"

name_pointer Head;

/*:231*/
#line 2093 "../../../texk/web2c/cwebdir/cweave.w"

}trans_plus;
}scrap;
typedef scrap*scrap_pointer;

/*:102*//*185:*/
#line 3557 "../../../texk/web2c/cwebdir/cweave.w"
typedef int mode;
typedef struct{
token_pointer end_field;
token_pointer tok_field;
boolean mode_field;
}output_state;
typedef output_state*stack_pointer;

/*:185*/
#line 73 "../../../texk/web2c/cwebdir/cweave.w"

/*16:*/
#line 207 "../../../texk/web2c/cwebdir/cweave.w"

boolean change_exists;

/*:16*//*18:*/
#line 239 "../../../texk/web2c/cwebdir/cweave.w"

xref_info xmem[max_refs];
xref_pointer xmem_end= xmem+max_refs-1;
xref_pointer xref_ptr;
sixteen_bits xref_switch,section_xref_switch;

/*:18*//*24:*/
#line 354 "../../../texk/web2c/cwebdir/cweave.w"

token tok_mem[max_toks];
token_pointer tok_mem_end= tok_mem+max_toks-1;
token_pointer tok_start[max_texts];
token_pointer tok_ptr;
text_pointer text_ptr;
text_pointer tok_start_end= tok_start+max_texts-1;
token_pointer max_tok_ptr;
text_pointer max_text_ptr;

/*:24*//*30:*/
#line 558 "../../../texk/web2c/cwebdir/cweave.w"

eight_bits ccode[256];

/*:30*//*36:*/
#line 677 "../../../texk/web2c/cwebdir/cweave.w"

name_pointer cur_section;
char cur_section_char;

/*:36*//*40:*/
#line 733 "../../../texk/web2c/cwebdir/cweave.w"

boolean preprocessing= 0;

/*:40*//*42:*/
#line 746 "../../../texk/web2c/cwebdir/cweave.w"

boolean sharp_include_line= 0;

/*:42*//*57:*/
#line 1017 "../../../texk/web2c/cwebdir/cweave.w"

eight_bits next_control;

/*:57*//*67:*/
#line 1173 "../../../texk/web2c/cwebdir/cweave.w"

name_pointer lhs,rhs;
name_pointer res_wd_end;

/*:67*//*72:*/
#line 1257 "../../../texk/web2c/cwebdir/cweave.w"

xref_pointer cur_xref;
boolean an_output;

/*:72*//*76:*/
#line 1299 "../../../texk/web2c/cwebdir/cweave.w"

char out_buf[line_length+1];
char*out_ptr;
char*out_buf_end= out_buf+line_length;
int out_line;

/*:76*//*96:*/
#line 1713 "../../../texk/web2c/cwebdir/cweave.w"

char cat_name[256][12];
eight_bits cat_index;

/*:96*//*103:*/
#line 2100 "../../../texk/web2c/cwebdir/cweave.w"

scrap scrap_info[max_scraps];
scrap_pointer scrap_info_end= scrap_info+max_scraps-1;
scrap_pointer pp;
scrap_pointer scrap_base;
scrap_pointer scrap_ptr;
scrap_pointer lo_ptr;
scrap_pointer hi_ptr;
scrap_pointer max_scr_ptr;

/*:103*//*107:*/
#line 2259 "../../../texk/web2c/cwebdir/cweave.w"

int cur_mathness,init_mathness;

/*:107*//*167:*/
#line 3092 "../../../texk/web2c/cwebdir/cweave.w"

int tracing;

/*:167*//*186:*/
#line 3570 "../../../texk/web2c/cwebdir/cweave.w"

output_state cur_state;
output_state stack[stack_size];
stack_pointer stack_ptr;
stack_pointer stack_end= stack+stack_size-1;
stack_pointer max_stack_ptr;

/*:186*//*190:*/
#line 3620 "../../../texk/web2c/cwebdir/cweave.w"

name_pointer cur_name;

/*:190*//*206:*/
#line 3977 "../../../texk/web2c/cwebdir/cweave.w"

int save_line;
char*save_place;
int sec_depth;
boolean space_checked;
boolean format_visible;
boolean doing_format= 0;
boolean group_found= 0;

/*:206*//*215:*/
#line 4160 "../../../texk/web2c/cwebdir/cweave.w"

name_pointer this_section;

/*:215*//*226:*/
#line 4344 "../../../texk/web2c/cwebdir/cweave.w"

sixteen_bits k_section;

/*:226*//*228:*/
#line 4370 "../../../texk/web2c/cwebdir/cweave.w"

name_pointer bucket[256];
name_pointer next_name;
name_pointer blink[max_names];

/*:228*//*232:*/
#line 4413 "../../../texk/web2c/cwebdir/cweave.w"

eight_bits cur_depth;
char*cur_byte;
sixteen_bits cur_val;
sort_pointer max_sort_ptr;

/*:232*//*234:*/
#line 4425 "../../../texk/web2c/cwebdir/cweave.w"

eight_bits collate[102+128];


/*:234*//*243:*/
#line 4578 "../../../texk/web2c/cwebdir/cweave.w"

xref_pointer next_xref,this_xref;


/*:243*/
#line 74 "../../../texk/web2c/cwebdir/cweave.w"

/*33:*/
#line 599 "../../../texk/web2c/cwebdir/cweave.w"

#line 235 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
void skip_limbo P1H(void);
#line 601 "../../../texk/web2c/cwebdir/cweave.w"

/*:33*//*38:*/
#line 695 "../../../texk/web2c/cwebdir/cweave.w"

#line 266 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
eight_bits get_next P1H(void);
#line 697 "../../../texk/web2c/cwebdir/cweave.w"

/*:38*//*54:*/
#line 970 "../../../texk/web2c/cwebdir/cweave.w"

#line 282 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
void skip_restricted P1H(void);
#line 972 "../../../texk/web2c/cwebdir/cweave.w"

/*:54*//*58:*/
#line 1023 "../../../texk/web2c/cwebdir/cweave.w"

#line 298 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
void phase_one P1H(void);
#line 1025 "../../../texk/web2c/cwebdir/cweave.w"

/*:58*//*61:*/
#line 1075 "../../../texk/web2c/cwebdir/cweave.w"

#line 314 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
void C_xref P1H(eight_bits);
#line 1077 "../../../texk/web2c/cwebdir/cweave.w"

/*:61*//*63:*/
#line 1103 "../../../texk/web2c/cwebdir/cweave.w"

#line 331 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
void outer_xref P1H(void);
#line 1105 "../../../texk/web2c/cwebdir/cweave.w"

/*:63*//*73:*/
#line 1265 "../../../texk/web2c/cwebdir/cweave.w"

#line 347 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
void section_check P1H(name_pointer);
#line 1267 "../../../texk/web2c/cwebdir/cweave.w"

/*:73*//*82:*/
#line 1401 "../../../texk/web2c/cwebdir/cweave.w"

#line 391 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
void break_out P1H(void);
#line 1403 "../../../texk/web2c/cwebdir/cweave.w"

/*:82*//*90:*/
#line 1547 "../../../texk/web2c/cwebdir/cweave.w"

#line 442 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
int copy_comment P2H(boolean,int);
#line 1549 "../../../texk/web2c/cwebdir/cweave.w"

/*:90*//*113:*/
#line 2494 "../../../texk/web2c/cwebdir/cweave.w"

#line 529 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
void underline_xref P1H(name_pointer);
#line 2496 "../../../texk/web2c/cwebdir/cweave.w"

/*:113*//*180:*/
#line 3420 "../../../texk/web2c/cwebdir/cweave.w"

#line 585 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
void app_cur_id P1H(boolean);
#line 3422 "../../../texk/web2c/cwebdir/cweave.w"

/*:180*//*193:*/
#line 3686 "../../../texk/web2c/cwebdir/cweave.w"

#line 651 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
void make_output P1H(void);
#line 3688 "../../../texk/web2c/cwebdir/cweave.w"

/*:193*//*204:*/
#line 3950 "../../../texk/web2c/cwebdir/cweave.w"

#line 667 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
void phase_two P1H(void);
#line 3952 "../../../texk/web2c/cwebdir/cweave.w"

/*:204*//*211:*/
#line 4073 "../../../texk/web2c/cwebdir/cweave.w"

#line 683 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
void finish_C P1H(boolean);
#line 4075 "../../../texk/web2c/cwebdir/cweave.w"

/*:211*//*220:*/
#line 4244 "../../../texk/web2c/cwebdir/cweave.w"

#line 700 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
void footnote P1H(sixteen_bits);
#line 4246 "../../../texk/web2c/cwebdir/cweave.w"

/*:220*//*224:*/
#line 4293 "../../../texk/web2c/cwebdir/cweave.w"

#line 717 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
void phase_three P1H(void);
#line 4295 "../../../texk/web2c/cwebdir/cweave.w"

/*:224*//*236:*/
#line 4473 "../../../texk/web2c/cwebdir/cweave.w"

#line 733 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
void unbucket P1H(eight_bits);
#line 4475 "../../../texk/web2c/cwebdir/cweave.w"

/*:236*//*245:*/
#line 4593 "../../../texk/web2c/cwebdir/cweave.w"

#line 750 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
void section_print P1H(name_pointer);
#line 4595 "../../../texk/web2c/cwebdir/cweave.w"

/*:245*/
#line 75 "../../../texk/web2c/cwebdir/cweave.w"


#line 88 "../../../texk/web2c/cwebdir/cweave.w"

/*:1*//*2:*/
#line 97 "../../../texk/web2c/cwebdir/cweave.w"

#line 75 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
int main P2C(int,ac,char**,av)
#line 101 "../../../texk/web2c/cwebdir/cweave.w"
{
argc= ac;argv= av;
program= cweave;
make_xrefs= force_lines= make_pb= 1;
common_init();
/*19:*/
#line 253 "../../../texk/web2c/cwebdir/cweave.w"

xref_ptr= xmem;name_dir->xref= (char*)xmem;xref_switch= 0;section_xref_switch= 0;
xmem->num= 0;

/*:19*//*25:*/
#line 364 "../../../texk/web2c/cwebdir/cweave.w"

tok_ptr= tok_mem+1;text_ptr= tok_start+1;tok_start[0]= tok_mem+1;
tok_start[1]= tok_mem+1;
max_tok_ptr= tok_mem+1;max_text_ptr= tok_start+1;

/*:25*//*31:*/
#line 561 "../../../texk/web2c/cwebdir/cweave.w"

{int c;for(c= 0;c<256;c++)ccode[c]= 0;}
ccode[' ']= ccode['\t']= ccode['\n']= ccode['\v']= ccode['\r']= ccode['\f']
= ccode['*']= new_section;
ccode['@']= '@';
ccode['=']= verbatim;
ccode['d']= ccode['D']= definition;
ccode['f']= ccode['F']= ccode['s']= ccode['S']= format_code;
ccode['c']= ccode['C']= ccode['p']= ccode['P']= begin_C;
ccode['t']= ccode['T']= TeX_string;
ccode['l']= ccode['L']= translit_code;
ccode['q']= ccode['Q']= noop;
ccode['h']= ccode['H']= output_defs_code;
ccode['&']= join;ccode['<']= ccode['(']= section_name;
ccode['!']= underline;ccode['^']= xref_roman;
ccode[':']= xref_wildcard;ccode['.']= xref_typewriter;ccode[',']= thin_space;
ccode['|']= math_break;ccode['/']= line_break;ccode['#']= big_line_break;
ccode['+']= no_line_break;ccode[';']= pseudo_semi;
ccode['[']= macro_arg_open;ccode[']']= macro_arg_close;
ccode['\'']= ord;
/*32:*/
#line 587 "../../../texk/web2c/cwebdir/cweave.w"

ccode['0']= ccode['1']= ccode['2']= trace;

/*:32*/
#line 581 "../../../texk/web2c/cwebdir/cweave.w"


/*:31*//*51:*/
#line 925 "../../../texk/web2c/cwebdir/cweave.w"
section_text[0]= ' ';

/*:51*//*79:*/
#line 1368 "../../../texk/web2c/cwebdir/cweave.w"

out_ptr= out_buf+1;out_line= 1;active_file= tex_file;
*out_ptr= 'c';tex_printf("\\input cwebma");

/*:79*//*81:*/
#line 1394 "../../../texk/web2c/cwebdir/cweave.w"

out_buf[0]= '\\';

/*:81*//*97:*/
#line 1717 "../../../texk/web2c/cwebdir/cweave.w"

for(cat_index= 0;cat_index<255;cat_index++)
strcpy(cat_name[cat_index],"UNKNOWN");

strcpy(cat_name[exp],"exp");
strcpy(cat_name[unop],"unop");
strcpy(cat_name[binop],"binop");
strcpy(cat_name[ubinop],"ubinop");
strcpy(cat_name[cast],"cast");
strcpy(cat_name[question],"?");
strcpy(cat_name[lbrace],"{");
strcpy(cat_name[rbrace],"}");
strcpy(cat_name[decl_head],"decl_head");
strcpy(cat_name[comma],",");
strcpy(cat_name[lpar],"(");
strcpy(cat_name[rpar],")");
strcpy(cat_name[prelangle],"<");
strcpy(cat_name[prerangle],">");
strcpy(cat_name[langle],"\\<");
strcpy(cat_name[colcol],"::");
strcpy(cat_name[base],"\\:");
strcpy(cat_name[decl],"decl");
strcpy(cat_name[struct_head],"struct_head");
strcpy(cat_name[alfop],"alfop");
strcpy(cat_name[stmt],"stmt");
strcpy(cat_name[function],"function");
strcpy(cat_name[fn_decl],"fn_decl");
strcpy(cat_name[else_like],"else_like");
strcpy(cat_name[semi],";");
strcpy(cat_name[colon],":");
strcpy(cat_name[tag],"tag");
strcpy(cat_name[if_head],"if_head");
strcpy(cat_name[else_head],"else_head");
strcpy(cat_name[if_clause],"if()");
strcpy(cat_name[lproc],"#{");
strcpy(cat_name[rproc],"#}");
strcpy(cat_name[insert],"insert");
strcpy(cat_name[section_scrap],"section");
strcpy(cat_name[dead],"@d");
strcpy(cat_name[public_like],"public");
strcpy(cat_name[operator_like],"operator");
strcpy(cat_name[new_like],"new");
strcpy(cat_name[catch_like],"catch");
strcpy(cat_name[for_like],"for");
strcpy(cat_name[do_like],"do");
strcpy(cat_name[if_like],"if");
strcpy(cat_name[delete_like],"delete");
strcpy(cat_name[raw_ubin],"ubinop?");
strcpy(cat_name[const_like],"const");
strcpy(cat_name[raw_int],"raw");
strcpy(cat_name[int_like],"int");
strcpy(cat_name[case_like],"case");
strcpy(cat_name[sizeof_like],"sizeof");
strcpy(cat_name[struct_like],"struct");
strcpy(cat_name[typedef_like],"typedef");
strcpy(cat_name[define_like],"define");
strcpy(cat_name[template_like],"template");
strcpy(cat_name[ftemplate],"ftemplate");
strcpy(cat_name[new_exp],"new_exp");
strcpy(cat_name[begin_arg],"@[");
strcpy(cat_name[end_arg],"@]");
strcpy(cat_name[0],"zero");

/*:97*//*104:*/
#line 2110 "../../../texk/web2c/cwebdir/cweave.w"

scrap_base= scrap_info+1;
max_scr_ptr= scrap_ptr= scrap_info;

/*:104*//*187:*/
#line 3577 "../../../texk/web2c/cwebdir/cweave.w"

max_stack_ptr= stack;

/*:187*//*233:*/
#line 4419 "../../../texk/web2c/cwebdir/cweave.w"

max_sort_ptr= scrap_info;

/*:233*//*235:*/
#line 4438 "../../../texk/web2c/cwebdir/cweave.w"

collate[0]= 0;
strcpy(collate+1," \1\2\3\4\5\6\7\10\11\12\13\14\15\16\17");

strcpy(collate+17,"\20\21\22\23\24\25\26\27\30\31\32\33\34\35\36\37");

strcpy(collate+33,"!\42#$%&'()*+,-./:;<=>?@[\\]^`{|}~_");

strcpy(collate+65,"abcdefghijklmnopqrstuvwxyz0123456789");

strcpy(collate+101,"\200\201\202\203\204\205\206\207\210\211\212\213\214\215\216\217");

strcpy(collate+117,"\220\221\222\223\224\225\226\227\230\231\232\233\234\235\236\237");

strcpy(collate+133,"\240\241\242\243\244\245\246\247\250\251\252\253\254\255\256\257");

strcpy(collate+149,"\260\261\262\263\264\265\266\267\270\271\272\273\274\275\276\277");

strcpy(collate+165,"\300\301\302\303\304\305\306\307\310\311\312\313\314\315\316\317");

strcpy(collate+181,"\320\321\322\323\324\325\326\327\330\331\332\333\334\335\336\337");

strcpy(collate+197,"\340\341\342\343\344\345\346\347\350\351\352\353\354\355\356\357");

strcpy(collate+213,"\360\361\362\363\364\365\366\367\370\371\372\373\374\375\376\377");


/*:235*/
#line 106 "../../../texk/web2c/cwebdir/cweave.w"
;
#line 81 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
if(show_banner){
printf("%s%s\n",banner,versionstring);
}
#line 108 "../../../texk/web2c/cwebdir/cweave.w"
/*27:*/
#line 404 "../../../texk/web2c/cwebdir/cweave.w"

id_lookup("and",NULL,alfop);
id_lookup("and_eq",NULL,alfop);
id_lookup("asm",NULL,sizeof_like);
id_lookup("auto",NULL,int_like);
id_lookup("bitand",NULL,alfop);
id_lookup("bitor",NULL,alfop);
id_lookup("bool",NULL,raw_int);
id_lookup("break",NULL,case_like);
id_lookup("case",NULL,case_like);
id_lookup("catch",NULL,catch_like);
id_lookup("char",NULL,raw_int);
id_lookup("class",NULL,struct_like);
id_lookup("clock_t",NULL,raw_int);
id_lookup("compl",NULL,alfop);
id_lookup("const",NULL,const_like);
id_lookup("const_cast",NULL,raw_int);
id_lookup("continue",NULL,case_like);
id_lookup("default",NULL,case_like);
id_lookup("define",NULL,define_like);
id_lookup("defined",NULL,sizeof_like);
id_lookup("delete",NULL,delete_like);
id_lookup("div_t",NULL,raw_int);
id_lookup("do",NULL,do_like);
id_lookup("double",NULL,raw_int);
id_lookup("dynamic_cast",NULL,raw_int);
id_lookup("elif",NULL,if_like);
id_lookup("else",NULL,else_like);
id_lookup("endif",NULL,if_like);
id_lookup("enum",NULL,struct_like);
id_lookup("error",NULL,if_like);
id_lookup("explicit",NULL,int_like);
id_lookup("export",NULL,int_like);
id_lookup("extern",NULL,int_like);
id_lookup("FILE",NULL,raw_int);
id_lookup("float",NULL,raw_int);
id_lookup("for",NULL,for_like);
id_lookup("fpos_t",NULL,raw_int);
id_lookup("friend",NULL,int_like);
id_lookup("goto",NULL,case_like);
id_lookup("if",NULL,if_like);
id_lookup("ifdef",NULL,if_like);
id_lookup("ifndef",NULL,if_like);
id_lookup("include",NULL,if_like);
id_lookup("inline",NULL,int_like);
id_lookup("int",NULL,raw_int);
id_lookup("jmp_buf",NULL,raw_int);
id_lookup("ldiv_t",NULL,raw_int);
id_lookup("line",NULL,if_like);
id_lookup("long",NULL,raw_int);
id_lookup("mutable",NULL,int_like);
id_lookup("namespace",NULL,struct_like);
id_lookup("new",NULL,new_like);
id_lookup("not",NULL,alfop);
id_lookup("not_eq",NULL,alfop);
id_lookup("NULL",NULL,custom);
id_lookup("offsetof",NULL,raw_int);
id_lookup("operator",NULL,operator_like);
id_lookup("or",NULL,alfop);
id_lookup("or_eq",NULL,alfop);
id_lookup("pragma",NULL,if_like);
id_lookup("private",NULL,public_like);
id_lookup("protected",NULL,public_like);
id_lookup("ptrdiff_t",NULL,raw_int);
id_lookup("public",NULL,public_like);
id_lookup("register",NULL,int_like);
id_lookup("reinterpret_cast",NULL,raw_int);
id_lookup("return",NULL,case_like);
id_lookup("short",NULL,raw_int);
id_lookup("sig_atomic_t",NULL,raw_int);
id_lookup("signed",NULL,raw_int);
id_lookup("size_t",NULL,raw_int);
id_lookup("sizeof",NULL,sizeof_like);
id_lookup("static",NULL,int_like);
id_lookup("static_cast",NULL,raw_int);
id_lookup("struct",NULL,struct_like);
id_lookup("switch",NULL,for_like);
id_lookup("template",NULL,template_like);
id_lookup("this",NULL,custom);
id_lookup("throw",NULL,case_like);
id_lookup("time_t",NULL,raw_int);
id_lookup("try",NULL,else_like);
id_lookup("typedef",NULL,typedef_like);
id_lookup("typeid",NULL,raw_int);
id_lookup("typename",NULL,struct_like);
id_lookup("undef",NULL,if_like);
id_lookup("union",NULL,struct_like);
id_lookup("unsigned",NULL,raw_int);
id_lookup("using",NULL,int_like);
id_lookup("va_dcl",NULL,decl);
id_lookup("va_list",NULL,raw_int);
id_lookup("virtual",NULL,int_like);
id_lookup("void",NULL,raw_int);
id_lookup("volatile",NULL,const_like);
id_lookup("wchar_t",NULL,raw_int);
id_lookup("while",NULL,for_like);
id_lookup("xor",NULL,alfop);
id_lookup("xor_eq",NULL,alfop);
res_wd_end= name_ptr;
id_lookup("TeX",NULL,custom);
id_lookup("make_pair",NULL,func_template);

/*:27*/
#line 108 "../../../texk/web2c/cwebdir/cweave.w"
;
phase_one();
phase_two();
phase_three();
return wrap_up();
}

/*:2*//*20:*/
#line 274 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 182 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 new_xref P1C(name_pointer,p)
#line 278 "../../../texk/web2c/cwebdir/cweave.w"
{
xref_pointer q;
sixteen_bits m,n;
if(no_xref)return;
if((unindexed(p)||is_tiny(p))&&xref_switch==0)return;
m= section_count+xref_switch;xref_switch= 0;q= (xref_pointer)p->xref;
if(q!=xmem){
n= q->num;
if(n==m||n==m+def_flag)return;
else if(m==n+def_flag){
q->num= m;return;
}
}
append_xref(m);xref_ptr->xlink= q;p->xref= (char*)xref_ptr;
}

/*:20*//*21:*/
#line 305 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 191 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 new_section_xref P1C(name_pointer,p)
#line 309 "../../../texk/web2c/cwebdir/cweave.w"
{
xref_pointer q,r;
q= (xref_pointer)p->xref;r= xmem;
if(q> xmem)
while(q->num> section_xref_switch){r= q;q= q->xlink;}
if(r->num==section_count+section_xref_switch)
return;
append_xref(section_count+section_xref_switch);
xref_ptr->xlink= q;section_xref_switch= 0;
if(r==xmem)p->xref= (char*)xref_ptr;
else r->xlink= xref_ptr;
}

/*:21*//*22:*/
#line 325 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 200 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 set_file_flag P1C(name_pointer,p)
#line 329 "../../../texk/web2c/cwebdir/cweave.w"
{
xref_pointer q;
q= (xref_pointer)p->xref;
if(q->num==file_flag)return;
append_xref(file_flag);
xref_ptr->xlink= q;
p->xref= (char*)xref_ptr;
}

/*:22*//*26:*/
#line 370 "../../../texk/web2c/cwebdir/cweave.w"

#line 212 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
int names_match P4C(name_pointer,p,char*,first,int,l,char,t)
#line 376 "../../../texk/web2c/cwebdir/cweave.w"
{
if(length(p)!=l)return 0;
if(p->ilk!=t&&!(t==normal&&abnormal(p)))return 0;
return!strncmp(first,p->byte_start,l);
}

void
#line 220 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 init_p P2C(name_pointer,p,char,t)
#line 386 "../../../texk/web2c/cwebdir/cweave.w"
{
p->ilk= t;p->xref= (char*)xmem;
}

void
#line 227 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 init_node P1C(name_pointer,p)
#line 393 "../../../texk/web2c/cwebdir/cweave.w"
{
p->xref= (char*)xmem;
}

/*:26*//*34:*/
#line 602 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 243 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 skip_limbo P1H(void){
#line 605 "../../../texk/web2c/cwebdir/cweave.w"
while(1){
if(loc> limit&&get_line()==0)return;
*(limit+1)= '@';
while(*loc!='@')loc++;
if(loc++<=limit){int c= ccode[(eight_bits)*loc++];
if(c==new_section)return;
if(c==noop)skip_restricted();
else if(c==format_code)/*70:*/
#line 1218 "../../../texk/web2c/cwebdir/cweave.w"

{
if(get_next()!=identifier)
err_print("! Missing left identifier of @s");

else{
lhs= id_lookup(id_first,id_loc,normal);
if(get_next()!=identifier)
err_print("! Missing right identifier of @s");

else{
rhs= id_lookup(id_first,id_loc,normal);
lhs->ilk= rhs->ilk;
}
}
}

/*:70*/
#line 612 "../../../texk/web2c/cwebdir/cweave.w"
;
}
}
}

/*:34*//*35:*/
#line 624 "../../../texk/web2c/cwebdir/cweave.w"

unsigned
#line 251 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 skip_TeX P1H(void)
#line 627 "../../../texk/web2c/cwebdir/cweave.w"
{
while(1){
if(loc> limit&&get_line()==0)return(new_section);
*(limit+1)= '@';
while(*loc!='@'&&*loc!='|')loc++;
if(*loc++=='|')return('|');
if(loc<=limit)return(ccode[(eight_bits)*(loc++)]);
}
}

/*:35*//*39:*/
#line 698 "../../../texk/web2c/cwebdir/cweave.w"

eight_bits
#line 274 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 get_next P1H(void)
#line 701 "../../../texk/web2c/cwebdir/cweave.w"
{eight_bits c;
while(1){
/*44:*/
#line 757 "../../../texk/web2c/cwebdir/cweave.w"

while(loc==limit-1&&preprocessing&&*loc=='\\')
if(get_line()==0)return(new_section);
if(loc>=limit&&preprocessing){
preprocessing= sharp_include_line= 0;
return(right_preproc);
}

/*:44*/
#line 703 "../../../texk/web2c/cwebdir/cweave.w"
;
if(loc> limit&&get_line()==0)return(new_section);
c= *(loc++);
if(xisdigit(c)||c=='.')/*47:*/
#line 814 "../../../texk/web2c/cwebdir/cweave.w"
{
id_first= id_loc= section_text+1;
if(*(loc-1)=='0'){
if(*loc=='x'||*loc=='X'){*id_loc++= '^';loc++;
while(xisxdigit(*loc))*id_loc++= *loc++;}
else if(xisdigit(*loc)){*id_loc++= '~';
while(xisdigit(*loc))*id_loc++= *loc++;}
else goto dec;
}
else{
if(*(loc-1)=='.'&&!xisdigit(*loc))goto mistake;
dec:*id_loc++= *(loc-1);
while(xisdigit(*loc)||*loc=='.')*id_loc++= *loc++;
if(*loc=='e'||*loc=='E'){
*id_loc++= '_';loc++;
if(*loc=='+'||*loc=='-')*id_loc++= *loc++;
while(xisdigit(*loc))*id_loc++= *loc++;
}
}
while(*loc=='u'||*loc=='U'||*loc=='l'||*loc=='L'
||*loc=='f'||*loc=='F'){
*id_loc++= '$';*id_loc++= toupper(*loc);loc++;
}
return(constant);
}

/*:47*/
#line 706 "../../../texk/web2c/cwebdir/cweave.w"

else if(c=='\''||c=='"'||(c=='L'&&(*loc=='\''||*loc=='"'))
||(c=='<'&&sharp_include_line==1))
/*48:*/
#line 845 "../../../texk/web2c/cwebdir/cweave.w"
{
char delim= c;
id_first= section_text+1;
id_loc= section_text;
if(delim=='\''&&*(loc-2)=='@'){*++id_loc= '@';*++id_loc= '@';}
*++id_loc= delim;
if(delim=='L'){
delim= *loc++;*++id_loc= delim;
}
if(delim=='<')delim= '>';
while(1){
if(loc>=limit){
if(*(limit-1)!='\\'){
err_print("! String didn't end");loc= limit;break;

}
if(get_line()==0){
err_print("! Input ended in middle of string");loc= buffer;break;

}
}
if((c= *loc++)==delim){
if(++id_loc<=section_text_end)*id_loc= c;
break;
}
if(c=='\\')if(loc>=limit)continue;
else if(++id_loc<=section_text_end){
*id_loc= '\\';c= *loc++;
}
if(++id_loc<=section_text_end)*id_loc= c;
}
if(id_loc>=section_text_end){
printf("\n! String too long: ");

term_write(section_text+1,25);
printf("...");mark_error;
}
id_loc++;
return(string);
}

/*:48*/
#line 709 "../../../texk/web2c/cwebdir/cweave.w"

else if(xisalpha(c)||isxalpha(c)||ishigh(c))
/*46:*/
#line 798 "../../../texk/web2c/cwebdir/cweave.w"
{
id_first= --loc;
while(isalpha(*++loc)||isdigit(*loc)||isxalpha(*loc)||ishigh(*loc));
id_loc= loc;return(identifier);
}

/*:46*/
#line 711 "../../../texk/web2c/cwebdir/cweave.w"

else if(c=='@')/*49:*/
#line 889 "../../../texk/web2c/cwebdir/cweave.w"
{
c= *loc++;
switch(ccode[(eight_bits)c]){
case translit_code:err_print("! Use @l in limbo only");continue;

case underline:xref_switch= def_flag;continue;
case trace:tracing= c-'0';continue;
case xref_roman:case xref_wildcard:case xref_typewriter:
case noop:case TeX_string:c= ccode[c];skip_restricted();return(c);
case section_name:
/*50:*/
#line 909 "../../../texk/web2c/cwebdir/cweave.w"
{
char*k;
cur_section_char= *(loc-1);
/*52:*/
#line 927 "../../../texk/web2c/cwebdir/cweave.w"

k= section_text;
while(1){
if(loc> limit&&get_line()==0){
err_print("! Input ended in section name");

loc= buffer+1;break;
}
c= *loc;
/*53:*/
#line 951 "../../../texk/web2c/cwebdir/cweave.w"

if(c=='@'){
c= *(loc+1);
if(c=='>'){
loc+= 2;break;
}
if(ccode[(eight_bits)c]==new_section){
err_print("! Section name didn't end");break;

}
if(c!='@'){
err_print("! Control codes are forbidden in section name");break;

}
*(++k)= '@';loc++;
}

/*:53*/
#line 936 "../../../texk/web2c/cwebdir/cweave.w"
;
loc++;if(k<section_text_end)k++;
if(xisspace(c)){
c= ' ';if(*(k-1)==' ')k--;
}
*k= c;
}
if(k>=section_text_end){
printf("\n! Section name too long: ");

term_write(section_text+1,25);
printf("...");mark_harmless;
}
if(*k==' '&&k> section_text)k--;

/*:52*/
#line 912 "../../../texk/web2c/cwebdir/cweave.w"
;
if(k-section_text> 3&&strncmp(k-2,"...",3)==0)
cur_section= section_lookup(section_text+1,k-3,1);
else cur_section= section_lookup(section_text+1,k,0);
xref_switch= 0;return(section_name);
}

/*:50*/
#line 899 "../../../texk/web2c/cwebdir/cweave.w"
;
case verbatim:/*56:*/
#line 998 "../../../texk/web2c/cwebdir/cweave.w"
{
id_first= loc++;*(limit+1)= '@';*(limit+2)= '>';
while(*loc!='@'||*(loc+1)!='>')loc++;
if(loc>=limit)err_print("! Verbatim string didn't end");

id_loc= loc;loc+= 2;
return(verbatim);
}

/*:56*/
#line 900 "../../../texk/web2c/cwebdir/cweave.w"
;
case ord:/*48:*/
#line 845 "../../../texk/web2c/cwebdir/cweave.w"
{
char delim= c;
id_first= section_text+1;
id_loc= section_text;
if(delim=='\''&&*(loc-2)=='@'){*++id_loc= '@';*++id_loc= '@';}
*++id_loc= delim;
if(delim=='L'){
delim= *loc++;*++id_loc= delim;
}
if(delim=='<')delim= '>';
while(1){
if(loc>=limit){
if(*(limit-1)!='\\'){
err_print("! String didn't end");loc= limit;break;

}
if(get_line()==0){
err_print("! Input ended in middle of string");loc= buffer;break;

}
}
if((c= *loc++)==delim){
if(++id_loc<=section_text_end)*id_loc= c;
break;
}
if(c=='\\')if(loc>=limit)continue;
else if(++id_loc<=section_text_end){
*id_loc= '\\';c= *loc++;
}
if(++id_loc<=section_text_end)*id_loc= c;
}
if(id_loc>=section_text_end){
printf("\n! String too long: ");

term_write(section_text+1,25);
printf("...");mark_error;
}
id_loc++;
return(string);
}

/*:48*/
#line 901 "../../../texk/web2c/cwebdir/cweave.w"
;
default:return(ccode[(eight_bits)c]);
}
}

/*:49*/
#line 712 "../../../texk/web2c/cwebdir/cweave.w"

else if(xisspace(c))continue;
if(c=='#'&&loc==buffer+1)/*41:*/
#line 736 "../../../texk/web2c/cwebdir/cweave.w"
{
preprocessing= 1;
/*43:*/
#line 749 "../../../texk/web2c/cwebdir/cweave.w"

while(loc<=buffer_end-7&&xisspace(*loc))loc++;
if(loc<=buffer_end-6&&strncmp(loc,"include",7)==0)sharp_include_line= 1;

/*:43*/
#line 738 "../../../texk/web2c/cwebdir/cweave.w"
;
return(left_preproc);
}

/*:41*/
#line 714 "../../../texk/web2c/cwebdir/cweave.w"
;
mistake:/*45:*/
#line 774 "../../../texk/web2c/cwebdir/cweave.w"

switch(c){
case'/':if(*loc=='*'){compress(begin_comment);}
else if(*loc=='/')compress(begin_short_comment);break;
case'+':if(*loc=='+')compress(plus_plus);break;
case'-':if(*loc=='-'){compress(minus_minus);}
else if(*loc=='>')if(*(loc+1)=='*'){loc++;compress(minus_gt_ast);}
else compress(minus_gt);break;
case'.':if(*loc=='*'){compress(period_ast);}
else if(*loc=='.'&&*(loc+1)=='.'){
loc++;compress(dot_dot_dot);
}
break;
case':':if(*loc==':')compress(colon_colon);break;
case'=':if(*loc=='=')compress(eq_eq);break;
case'>':if(*loc=='='){compress(gt_eq);}
else if(*loc=='>')compress(gt_gt);break;
case'<':if(*loc=='='){compress(lt_eq);}
else if(*loc=='<')compress(lt_lt);break;
case'&':if(*loc=='&')compress(and_and);break;
case'|':if(*loc=='|')compress(or_or);break;
case'!':if(*loc=='=')compress(not_eq);break;
}

/*:45*/
#line 715 "../../../texk/web2c/cwebdir/cweave.w"

return(c);
}
}

/*:39*//*55:*/
#line 973 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 290 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 skip_restricted P1H(void)
#line 976 "../../../texk/web2c/cwebdir/cweave.w"
{
id_first= loc;*(limit+1)= '@';
false_alarm:
while(*loc!='@')loc++;
id_loc= loc;
if(loc++> limit){
err_print("! Control text didn't end");loc= limit;

}
else{
if(*loc=='@'&&loc<=limit){loc++;goto false_alarm;}
if(*loc++!='>')
err_print("! Control codes are forbidden in control text");

}
}

/*:55*//*59:*/
#line 1026 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 306 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 phase_one P1H(void){
#line 1029 "../../../texk/web2c/cwebdir/cweave.w"
phase= 1;reset_input();section_count= 0;
skip_limbo();change_exists= 0;
while(!input_has_ended)
/*60:*/
#line 1039 "../../../texk/web2c/cwebdir/cweave.w"

{
if(++section_count==max_sections)overflow("section number");
changed_section[section_count]= changing;

if(*(loc-1)=='*'&&show_progress){
printf("*%d",section_count);
update_terminal;
}
/*65:*/
#line 1130 "../../../texk/web2c/cwebdir/cweave.w"

while(1){
switch(next_control= skip_TeX()){
case translit_code:err_print("! Use @l in limbo only");continue;

case underline:xref_switch= def_flag;continue;
case trace:tracing= *(loc-1)-'0';continue;
case'|':C_xref(section_name);break;
case xref_roman:case xref_wildcard:case xref_typewriter:
case noop:case section_name:
loc-= 2;next_control= get_next();
if(next_control>=xref_roman&&next_control<=xref_typewriter){
/*66:*/
#line 1150 "../../../texk/web2c/cwebdir/cweave.w"

{
char*src= id_first,*dst= id_first;
while(src<id_loc){
if(*src=='@')src++;
*dst++= *src++;
}
id_loc= dst;
while(dst<src)*dst++= ' ';
}

/*:66*/
#line 1142 "../../../texk/web2c/cwebdir/cweave.w"

new_xref(id_lookup(id_first,id_loc,next_control-identifier));
}
break;
}
if(next_control>=format_code)break;
}

/*:65*/
#line 1048 "../../../texk/web2c/cwebdir/cweave.w"
;
/*68:*/
#line 1179 "../../../texk/web2c/cwebdir/cweave.w"

while(next_control<=definition){
if(next_control==definition){
xref_switch= def_flag;
next_control= get_next();
}else/*69:*/
#line 1193 "../../../texk/web2c/cwebdir/cweave.w"
{
next_control= get_next();
if(next_control==identifier){
lhs= id_lookup(id_first,id_loc,normal);lhs->ilk= normal;
if(xref_switch)new_xref(lhs);
next_control= get_next();
if(next_control==identifier){
rhs= id_lookup(id_first,id_loc,normal);
lhs->ilk= rhs->ilk;
if(unindexed(lhs)){
xref_pointer q,r= NULL;
for(q= (xref_pointer)lhs->xref;q> xmem;q= q->xlink)
if(q->num<def_flag)
if(r)r->xlink= q->xlink;
else lhs->xref= (char*)q->xlink;
else r= q;
}
next_control= get_next();
}
}
}

/*:69*/
#line 1184 "../../../texk/web2c/cwebdir/cweave.w"
;
outer_xref();
}

/*:68*/
#line 1049 "../../../texk/web2c/cwebdir/cweave.w"
;
/*71:*/
#line 1238 "../../../texk/web2c/cwebdir/cweave.w"

if(next_control<=section_name){
if(next_control==begin_C)section_xref_switch= 0;
else{
section_xref_switch= def_flag;
if(cur_section_char=='('&&cur_section!=name_dir)
set_file_flag(cur_section);
}
do{
if(next_control==section_name&&cur_section!=name_dir)
new_section_xref(cur_section);
next_control= get_next();outer_xref();
}while(next_control<=section_name);
}

/*:71*/
#line 1050 "../../../texk/web2c/cwebdir/cweave.w"
;
if(changed_section[section_count])change_exists= 1;
}

/*:60*/
#line 1032 "../../../texk/web2c/cwebdir/cweave.w"
;
changed_section[section_count]= change_exists;

phase= 2;
/*75:*/
#line 1291 "../../../texk/web2c/cwebdir/cweave.w"
section_check(root)

/*:75*/
#line 1036 "../../../texk/web2c/cwebdir/cweave.w"
;
}

/*:59*//*62:*/
#line 1078 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 323 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 C_xref P1C(eight_bits,spec_ctrl)
#line 1082 "../../../texk/web2c/cwebdir/cweave.w"
{
name_pointer p;
while(next_control<format_code||next_control==spec_ctrl){
if(next_control>=identifier&&next_control<=xref_typewriter){
if(next_control> identifier)/*66:*/
#line 1150 "../../../texk/web2c/cwebdir/cweave.w"

{
char*src= id_first,*dst= id_first;
while(src<id_loc){
if(*src=='@')src++;
*dst++= *src++;
}
id_loc= dst;
while(dst<src)*dst++= ' ';
}

/*:66*/
#line 1086 "../../../texk/web2c/cwebdir/cweave.w"

p= id_lookup(id_first,id_loc,next_control-identifier);new_xref(p);
}
if(next_control==section_name){
section_xref_switch= cite_flag;
new_section_xref(cur_section);
}
next_control= get_next();
if(next_control=='|'||next_control==begin_comment||
next_control==begin_short_comment)return;
}
}

/*:62*//*64:*/
#line 1106 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 339 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 outer_xref P1H(void)
#line 1109 "../../../texk/web2c/cwebdir/cweave.w"
{
int bal;
while(next_control<format_code)
if(next_control!=begin_comment&&next_control!=begin_short_comment)
C_xref(ignore);
else{
boolean is_long_comment= (next_control==begin_comment);
bal= copy_comment(is_long_comment,1);next_control= '|';
while(bal> 0){
C_xref(section_name);
if(next_control=='|')bal= copy_comment(is_long_comment,bal);
else bal= 0;
}
}
}

/*:64*//*74:*/
#line 1268 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 356 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 section_check P1C(name_pointer,p)
#line 1272 "../../../texk/web2c/cwebdir/cweave.w"
{
if(p){
section_check(p->llink);
cur_xref= (xref_pointer)p->xref;
if(cur_xref->num==file_flag){an_output= 1;cur_xref= cur_xref->xlink;}
else an_output= 0;
if(cur_xref->num<def_flag){
printf("\n! Never defined: <");print_section_name(p);putchar('>');mark_harmless;

}
while(cur_xref->num>=cite_flag)cur_xref= cur_xref->xlink;
if(cur_xref==xmem&&!an_output){
printf("\n! Never used: <");print_section_name(p);putchar('>');mark_harmless;

}
section_check(p->rlink);
}
}

/*:74*//*77:*/
#line 1321 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 366 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 flush_buffer P3C(char*,b,boolean,per_cent,boolean,carryover)
#line 1326 "../../../texk/web2c/cwebdir/cweave.w"
{
char*j;j= b;
if(!per_cent)
while(j> out_buf&&*j==' ')j--;
c_line_write(j-out_buf);
if(per_cent)tex_putc('%');
tex_new_line;out_line++;
if(carryover)
while(j> out_buf)
if(*j--=='%'&&(j==out_buf||*j!='\\')){
*b--= '%';break;
}
if(b<out_ptr)strncpy(out_buf+1,b+1,out_ptr-b);
out_ptr-= b-out_buf;
}

/*:77*//*78:*/
#line 1350 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 374 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 finish_line P1H(void)
#line 1353 "../../../texk/web2c/cwebdir/cweave.w"
{
char*k;
if(out_ptr> out_buf)flush_buffer(out_ptr,0,0);
else{
for(k= buffer;k<=limit;k++)
if(!(xisspace(*k)))return;
flush_buffer(out_buf,0,0);
}
}

/*:78*//*80:*/
#line 1382 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 383 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 out_str P1C(char*,s)
#line 1386 "../../../texk/web2c/cwebdir/cweave.w"
{
while(*s)out(*s++);
}

/*:80*//*83:*/
#line 1404 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 399 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 break_out P1H(void)
#line 1407 "../../../texk/web2c/cwebdir/cweave.w"
{
char*k= out_ptr;
while(1){
if(k==out_buf)/*84:*/
#line 1425 "../../../texk/web2c/cwebdir/cweave.w"

{
printf("\n! Line had to be broken (output l. %d):\n",out_line);

term_write(out_buf+1,out_ptr-out_buf-1);
new_line;mark_harmless;
flush_buffer(out_ptr-1,1,1);return;
}

/*:84*/
#line 1410 "../../../texk/web2c/cwebdir/cweave.w"
;
if(*k==' '){
flush_buffer(k,0,1);return;
}
if(*(k--)=='\\'&&*k!='\\'){
flush_buffer(k,1,1);return;
}
}
}

/*:83*//*85:*/
#line 1439 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 408 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 out_section P1C(sixteen_bits,n)
#line 1443 "../../../texk/web2c/cwebdir/cweave.w"
{
char s[6];
sprintf(s,"%d",n);out_str(s);
if(changed_section[n])out_str("\\*");

}

/*:85*//*86:*/
#line 1453 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 418 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 out_name P2C(name_pointer,p,boolean,quote_xalpha)
#line 1458 "../../../texk/web2c/cwebdir/cweave.w"
{
char*k,*k_end= (p+1)->byte_start;
out('{');
for(k= p->byte_start;k<k_end;k++){
if(isxalpha(*k)&&quote_xalpha)out('\\');


out(*k);
}
out('}');
}

/*:86*//*87:*/
#line 1483 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 426 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 copy_limbo P1H(void)
#line 1486 "../../../texk/web2c/cwebdir/cweave.w"
{
char c;
while(1){
if(loc> limit&&(finish_line(),get_line()==0))return;
*(limit+1)= '@';
while(*loc!='@')out(*(loc++));
if(loc++<=limit){
c= *loc++;
if(ccode[(eight_bits)c]==new_section)break;
switch(ccode[(eight_bits)c]){
case translit_code:out_str("\\ATL");break;

case'@':out('@');break;
case noop:skip_restricted();break;
case format_code:if(get_next()==identifier)get_next();
if(loc>=limit)get_line();
break;
default:err_print("! Double @ should be used in limbo");

out('@');
}
}
}
}

/*:87*//*89:*/
#line 1518 "../../../texk/web2c/cwebdir/cweave.w"

eight_bits
#line 434 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 copy_TeX P1H(void)
#line 1521 "../../../texk/web2c/cwebdir/cweave.w"
{
char c;
while(1){
if(loc> limit&&(finish_line(),get_line()==0))return(new_section);
*(limit+1)= '@';
while((c= *(loc++))!='|'&&c!='@'){
out(c);
if(out_ptr==out_buf+1&&(xisspace(c)))out_ptr--;
}
if(c=='|')return('|');
if(loc<=limit)return(ccode[(eight_bits)*(loc++)]);
}
}

/*:89*//*91:*/
#line 1550 "../../../texk/web2c/cwebdir/cweave.w"

#line 452 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
int copy_comment P2C(boolean,is_long_comment,int,bal)
#line 1554 "../../../texk/web2c/cwebdir/cweave.w"
{
char c;
while(1){
if(loc> limit){
if(is_long_comment){
if(get_line()==0){
err_print("! Input ended in mid-comment");

loc= buffer+1;goto done;
}
}
else{
if(bal> 1)err_print("! Missing } in comment");

goto done;
}
}
c= *(loc++);
if(c=='|')return(bal);
if(is_long_comment)/*92:*/
#line 1591 "../../../texk/web2c/cwebdir/cweave.w"

if(c=='*'&&*loc=='/'){
loc++;
if(bal> 1)err_print("! Missing } in comment");

goto done;
}

/*:92*/
#line 1573 "../../../texk/web2c/cwebdir/cweave.w"
;
if(phase==2){
if(ishigh(c))app_tok(quoted_char);
app_tok(c);
}
/*93:*/
#line 1599 "../../../texk/web2c/cwebdir/cweave.w"

if(c=='@'){
if(*(loc++)!='@'){
err_print("! Illegal use of @ in comment");

loc-= 2;if(phase==2)*(tok_ptr-1)= ' ';goto done;
}
}
else if(c=='\\'&&*loc!='@')
if(phase==2)app_tok(*(loc++))else loc++;

/*:93*/
#line 1578 "../../../texk/web2c/cwebdir/cweave.w"
;
if(c=='{')bal++;
else if(c=='}'){
if(bal> 1)bal--;
else{err_print("! Extra } in comment");

if(phase==2)tok_ptr--;
}
}
}
done:/*94:*/
#line 1613 "../../../texk/web2c/cwebdir/cweave.w"

if(phase==2)while(bal--> 0)app_tok('}');
return(0);

/*:94*/
#line 1588 "../../../texk/web2c/cwebdir/cweave.w"
;
}

/*:91*//*98:*/
#line 1782 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 461 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 print_cat P1C(eight_bits,c)
#line 1786 "../../../texk/web2c/cwebdir/cweave.w"
{
printf(cat_name[c]);
}

/*:98*//*105:*/
#line 2137 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 470 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 print_text P1C(text_pointer,p)
#line 2141 "../../../texk/web2c/cwebdir/cweave.w"
{
token_pointer j;
sixteen_bits r;
if(p>=text_ptr)printf("BAD");
else for(j= *p;j<*(p+1);j++){
r= *j%id_flag;
switch(*j/id_flag){
case 1:printf("\\\\{");print_id((name_dir+r));printf("}");
break;
case 2:printf("\\&{");print_id((name_dir+r));printf("}");
break;
case 3:printf("<");print_section_name((name_dir+r));printf(">");
break;
case 4:printf("[[%d]]",r);break;
case 5:printf("|[[%d]]|",r);break;
default:/*106:*/
#line 2162 "../../../texk/web2c/cwebdir/cweave.w"

switch(r){
case math_rel:printf("\\mathrel{");break;
case big_cancel:printf("[ccancel]");break;
case cancel:printf("[cancel]");break;
case indent:printf("[indent]");break;
case outdent:printf("[outdent]");break;
case backup:printf("[backup]");break;
case opt:printf("[opt]");break;
case break_space:printf("[break]");break;
case force:printf("[force]");break;
case big_force:printf("[fforce]");break;
case preproc_line:printf("[preproc]");break;
case quoted_char:j++;printf("[%o]",(unsigned)*j);break;
case end_translation:printf("[quit]");break;
case inserted:printf("[inserted]");break;
default:putxchar(r);
}

/*:106*/
#line 2156 "../../../texk/web2c/cwebdir/cweave.w"
;
}
}
fflush(stdout);
}

/*:105*//*108:*/
#line 2262 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 479 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 app_str P1C(char*,s)
#line 2266 "../../../texk/web2c/cwebdir/cweave.w"
{
while(*s)app_tok(*(s++));
}

void
#line 486 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 big_app P1C(token,a)
#line 2273 "../../../texk/web2c/cwebdir/cweave.w"
{
if(a==' '||(a>=big_cancel&&a<=big_force)){
if(cur_mathness==maybe_math)init_mathness= no_math;
else if(cur_mathness==yes_math)app_str("{}$");
cur_mathness= no_math;
}
else{
if(cur_mathness==maybe_math)init_mathness= yes_math;
else if(cur_mathness==no_math)app_str("${}");
cur_mathness= yes_math;
}
app(a);
}

void
#line 493 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 big_app1 P1C(scrap_pointer,a)
#line 2290 "../../../texk/web2c/cwebdir/cweave.w"
{
switch(a->mathness%4){
case(no_math):
if(cur_mathness==maybe_math)init_mathness= no_math;
else if(cur_mathness==yes_math)app_str("{}$");
cur_mathness= a->mathness/4;
break;
case(yes_math):
if(cur_mathness==maybe_math)init_mathness= yes_math;
else if(cur_mathness==no_math)app_str("${}");
cur_mathness= a->mathness/4;
break;
case(maybe_math):break;
}
app(tok_flag+(int)((a)->trans-tok_start));
}

/*:108*//*110:*/
#line 2413 "../../../texk/web2c/cwebdir/cweave.w"

token_pointer
#line 502 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 find_first_ident P1C(text_pointer,p)
#line 2417 "../../../texk/web2c/cwebdir/cweave.w"
{
token_pointer q;
token_pointer j;
sixteen_bits r;
if(p>=text_ptr)confusion("find_first_ident");
for(j= *p;j<*(p+1);j++){
r= *j%id_flag;
switch(*j/id_flag){
case 2:
if(name_dir[r].ilk==case_like)return case_found;
if(name_dir[r].ilk==operator_like)return operator_found;
if(name_dir[r].ilk!=raw_int)break;
case 1:return j;
case 4:case 5:
if((q= find_first_ident(tok_start+r))!=no_ident_found)
return q;
default:;
if(*j==inserted)return no_ident_found;
else if(*j==qualifier)j++;
}
}
return no_ident_found;
}

/*:110*//*111:*/
#line 2445 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 511 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 make_reserved P1C(scrap_pointer,p)
#line 2449 "../../../texk/web2c/cwebdir/cweave.w"
{
sixteen_bits tok_value;
token_pointer tok_loc;
if((tok_loc= find_first_ident(p->trans))<=operator_found)
return;
tok_value= *tok_loc;
for(;p<=scrap_ptr;p==lo_ptr?p= hi_ptr:p++){
if(p->cat==exp){
if(**(p->trans)==tok_value){
p->cat= raw_int;
**(p->trans)= tok_value%id_flag+res_flag;
}
}
}
(name_dir+(sixteen_bits)(tok_value%id_flag))->ilk= raw_int;
*tok_loc= tok_value%id_flag+res_flag;
}

/*:111*//*112:*/
#line 2476 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 521 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 make_underlined P1C(scrap_pointer,p)
#line 2481 "../../../texk/web2c/cwebdir/cweave.w"
{
token_pointer tok_loc;
if((tok_loc= find_first_ident(p->trans))<=operator_found)
return;
xref_switch= def_flag;
underline_xref(*tok_loc%id_flag+name_dir);
}

/*:112*//*114:*/
#line 2497 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 538 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 underline_xref P1C(name_pointer,p)
#line 2501 "../../../texk/web2c/cwebdir/cweave.w"
{
xref_pointer q= (xref_pointer)p->xref;
xref_pointer r;
sixteen_bits m;
sixteen_bits n;
if(no_xref)return;
m= section_count+xref_switch;
while(q!=xmem){
n= q->num;
if(n==m)return;
else if(m==n+def_flag){
q->num= m;return;
}
else if(n>=def_flag&&n<m)break;
q= q->xlink;
}
/*115:*/
#line 2527 "../../../texk/web2c/cwebdir/cweave.w"

append_xref(0);
xref_ptr->xlink= (xref_pointer)p->xref;r= xref_ptr;
p->xref= (char*)xref_ptr;
while(r->xlink!=q){r->num= r->xlink->num;r= r->xlink;}
r->num= m;

/*:115*/
#line 2517 "../../../texk/web2c/cwebdir/cweave.w"
;
}

/*:114*//*163:*/
#line 3002 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 549 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 reduce P5C(scrap_pointer,j,short,k,eight_bits,c,short,d,short,n)
#line 3008 "../../../texk/web2c/cwebdir/cweave.w"
{
scrap_pointer i,i1;
j->cat= c;j->trans= text_ptr;
j->mathness= 4*cur_mathness+init_mathness;
freeze_text;
if(k> 1){
for(i= j+k,i1= j+1;i<=lo_ptr;i++,i1++){
i1->cat= i->cat;i1->trans= i->trans;
i1->mathness= i->mathness;
}
lo_ptr= lo_ptr-k+1;
}
pp= (pp+d<scrap_base?scrap_base:pp+d);
/*168:*/
#line 3095 "../../../texk/web2c/cwebdir/cweave.w"

{scrap_pointer k;
if(tracing==2){
printf("\n%d:",n);
for(k= scrap_base;k<=lo_ptr;k++){
if(k==pp)putxchar('*');else putxchar(' ');
if(k->mathness%4==yes_math)putchar('+');
else if(k->mathness%4==no_math)putchar('-');
print_cat(k->cat);
if(k->mathness/4==yes_math)putchar('+');
else if(k->mathness/4==no_math)putchar('-');
}
if(hi_ptr<=scrap_ptr)printf("...");
}
}

/*:168*/
#line 3021 "../../../texk/web2c/cwebdir/cweave.w"
;
pp--;
}

/*:163*//*164:*/
#line 3028 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 560 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 squash P5C(scrap_pointer,j,short,k,eight_bits,c,short,d,short,n)
#line 3034 "../../../texk/web2c/cwebdir/cweave.w"
{
scrap_pointer i;
if(k==1){
j->cat= c;pp= (pp+d<scrap_base?scrap_base:pp+d);
/*168:*/
#line 3095 "../../../texk/web2c/cwebdir/cweave.w"

{scrap_pointer k;
if(tracing==2){
printf("\n%d:",n);
for(k= scrap_base;k<=lo_ptr;k++){
if(k==pp)putxchar('*');else putxchar(' ');
if(k->mathness%4==yes_math)putchar('+');
else if(k->mathness%4==no_math)putchar('-');
print_cat(k->cat);
if(k->mathness/4==yes_math)putchar('+');
else if(k->mathness/4==no_math)putchar('-');
}
if(hi_ptr<=scrap_ptr)printf("...");
}
}

/*:168*/
#line 3038 "../../../texk/web2c/cwebdir/cweave.w"
;
pp--;
return;
}
for(i= j;i<j+k;i++)big_app1(i);
reduce(j,k,c,d,n);
}

/*:164*//*169:*/
#line 3124 "../../../texk/web2c/cwebdir/cweave.w"

text_pointer
#line 568 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 translate P1H(void)
#line 3127 "../../../texk/web2c/cwebdir/cweave.w"
{
scrap_pointer i,
j;
pp= scrap_base;lo_ptr= pp-1;hi_ptr= pp;
/*172:*/
#line 3163 "../../../texk/web2c/cwebdir/cweave.w"

if(tracing==2){
printf("\nTracing after l. %d:\n",cur_line);mark_harmless;

if(loc> buffer+50){
printf("...");
term_write(loc-51,51);
}
else term_write(buffer,loc-buffer);
}

/*:172*/
#line 3131 "../../../texk/web2c/cwebdir/cweave.w"
;
/*165:*/
#line 3059 "../../../texk/web2c/cwebdir/cweave.w"

while(1){
/*166:*/
#line 3078 "../../../texk/web2c/cwebdir/cweave.w"

if(lo_ptr<pp+3){
while(hi_ptr<=scrap_ptr&&lo_ptr!=pp+3){
(++lo_ptr)->cat= hi_ptr->cat;lo_ptr->mathness= (hi_ptr)->mathness;
lo_ptr->trans= (hi_ptr++)->trans;
}
for(i= lo_ptr+1;i<=pp+3;i++)i->cat= 0;
}

/*:166*/
#line 3061 "../../../texk/web2c/cwebdir/cweave.w"
;
if(tok_ptr+safe_tok_incr> tok_mem_end){
if(tok_ptr> max_tok_ptr)max_tok_ptr= tok_ptr;
overflow("token");
}
if(text_ptr+safe_text_incr> tok_start_end){
if(text_ptr> max_text_ptr)max_text_ptr= text_ptr;
overflow("text");
}
if(pp> lo_ptr)break;
init_mathness= cur_mathness= maybe_math;
/*109:*/
#line 2329 "../../../texk/web2c/cwebdir/cweave.w"
{
if(cat1==end_arg&&lhs_not_simple)
if(pp->cat==begin_arg)squash(pp,2,exp,-2,124);
else squash(pp,2,end_arg,-1,125);
else if(cat1==insert)squash(pp,2,pp->cat,-2,0);
else if(cat2==insert)squash(pp+1,2,(pp+1)->cat,-1,0);
else if(cat3==insert)squash(pp+2,2,(pp+2)->cat,0,0);
else
switch(pp->cat){
case exp:/*116:*/
#line 2539 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==lbrace||cat1==int_like||cat1==decl){
make_underlined(pp);big_app1(pp);big_app(indent);app(indent);
reduce(pp,1,fn_decl,0,1);
}
else if(cat1==unop)squash(pp,2,exp,-2,2);
else if((cat1==binop||cat1==ubinop)&&cat2==exp)
squash(pp,3,exp,-2,3);
else if(cat1==comma&&cat2==exp){
big_app2(pp);
app(opt);app('9');big_app1(pp+2);reduce(pp,3,exp,-2,4);
}
else if(cat1==lpar&&cat2==rpar&&cat3==colon)squash(pp+3,1,base,0,5);
else if(cat1==cast&&cat2==colon)squash(pp+2,1,base,0,5);
else if(cat1==semi)squash(pp,2,stmt,-1,6);
else if(cat1==colon){
make_underlined(pp);squash(pp,2,tag,-1,7);
}
else if(cat1==rbrace)squash(pp,1,stmt,-1,8);
else if(cat1==lpar&&cat2==rpar&&(cat3==const_like||cat3==case_like)){
big_app1(pp+2);big_app(' ');big_app1(pp+3);reduce(pp+2,2,rpar,0,9);
}
else if(cat1==cast&&(cat2==const_like||cat2==case_like)){
big_app1(pp+1);big_app(' ');big_app1(pp+2);reduce(pp+1,2,cast,0,9);
}
else if(cat1==exp||cat1==cast)squash(pp,2,exp,-2,10);

/*:116*/
#line 2338 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case lpar:/*117:*/
#line 2566 "../../../texk/web2c/cwebdir/cweave.w"

if((cat1==exp||cat1==ubinop)&&cat2==rpar)squash(pp,3,exp,-2,11);
else if(cat1==rpar){
big_app1(pp);app('\\');app(',');big_app1(pp+1);

reduce(pp,2,exp,-2,12);
}
else if((cat1==decl_head||cat1==int_like||cat1==cast)&&cat2==rpar)
squash(pp,3,cast,-2,13);
else if((cat1==decl_head||cat1==int_like||cat1==exp)&&cat2==comma){
big_app3(pp);app(opt);app('9');reduce(pp,3,lpar,-1,14);
}
else if(cat1==stmt||cat1==decl){
big_app2(pp);big_app(' ');reduce(pp,2,lpar,-1,15);
}

/*:117*/
#line 2339 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case unop:/*118:*/
#line 2582 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==exp||cat1==int_like)squash(pp,2,exp,-2,16);

/*:118*/
#line 2340 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case ubinop:/*119:*/
#line 2585 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==cast&&cat2==rpar){
big_app('{');big_app1(pp);big_app('}');big_app1(pp+1);
reduce(pp,2,cast,-2,17);
}
else if(cat1==exp||cat1==int_like){
big_app('{');big_app1(pp);big_app('}');big_app1(pp+1);
reduce(pp,2,cat1,-2,18);
}
else if(cat1==binop){
big_app(math_rel);big_app1(pp);big_app('{');big_app1(pp+1);big_app('}');
big_app('}');reduce(pp,2,binop,-1,19);
}

/*:119*/
#line 2341 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case binop:/*120:*/
#line 2599 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==binop){
big_app(math_rel);big_app('{');big_app1(pp);big_app('}');
big_app('{');big_app1(pp+1);big_app('}');
big_app('}');reduce(pp,2,binop,-1,20);
}

/*:120*/
#line 2342 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case cast:/*121:*/
#line 2606 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==lpar)squash(pp,2,lpar,-1,21);
else if(cat1==exp){
big_app1(pp);big_app(' ');big_app1(pp+1);reduce(pp,2,exp,-2,21);
}
else if(cat1==semi)squash(pp,1,exp,-2,22);

/*:121*/
#line 2343 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case sizeof_like:/*122:*/
#line 2613 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==cast)squash(pp,2,exp,-2,23);
else if(cat1==exp){
big_app1(pp);big_app(' ');big_app1(pp+1);reduce(pp,2,exp,-2,24);
}

/*:122*/
#line 2344 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case int_like:/*123:*/
#line 2619 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==int_like||cat1==struct_like){
big_app1(pp);big_app(' ');big_app1(pp+1);reduce(pp,2,cat1,-2,25);
}
else if(cat1==exp&&(cat2==raw_int||cat2==struct_like))
squash(pp,2,int_like,-2,26);
else if(cat1==exp||cat1==ubinop||cat1==colon){
big_app1(pp);big_app(' ');reduce(pp,1,decl_head,-1,27);
}
else if(cat1==semi||cat1==binop)squash(pp,1,decl_head,0,28);

/*:123*/
#line 2345 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case public_like:/*124:*/
#line 2630 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==colon)squash(pp,2,tag,-1,29);
else squash(pp,1,int_like,-2,30);

/*:124*/
#line 2346 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case colcol:/*125:*/
#line 2634 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==exp||cat1==int_like){
app(qualifier);squash(pp,2,cat1,-2,31);
}else if(cat1==colcol)squash(pp,2,colcol,-1,32);

/*:125*/
#line 2347 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case decl_head:/*126:*/
#line 2639 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==comma){
big_app2(pp);big_app(' ');reduce(pp,2,decl_head,-1,33);
}
else if(cat1==ubinop){
big_app1(pp);big_app('{');big_app1(pp+1);big_app('}');
reduce(pp,2,decl_head,-1,34);
}
else if(cat1==exp&&cat2!=lpar&&cat2!=exp&&cat2!=cast){
make_underlined(pp+1);squash(pp,2,decl_head,-1,35);
}
else if((cat1==binop||cat1==colon)&&cat2==exp&&(cat3==comma||
cat3==semi||cat3==rpar))
squash(pp,3,decl_head,-1,36);
else if(cat1==cast)squash(pp,2,decl_head,-1,37);
else if(cat1==lbrace||cat1==int_like||cat1==decl){
big_app1(pp);big_app(indent);app(indent);reduce(pp,1,fn_decl,0,38);
}
else if(cat1==semi)squash(pp,2,decl,-1,39);

/*:126*/
#line 2348 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case decl:/*127:*/
#line 2659 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==decl){
big_app1(pp);big_app(force);big_app1(pp+1);
reduce(pp,2,decl,-1,40);
}
else if(cat1==stmt||cat1==function){
big_app1(pp);big_app(big_force);
big_app1(pp+1);reduce(pp,2,cat1,-1,41);
}

/*:127*/
#line 2349 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case base:/*128:*/
#line 2669 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==int_like||cat1==exp){
if(cat2==comma){
big_app1(pp);big_app(' ');big_app2(pp+1);
app(opt);app('9');reduce(pp,3,base,0,42);
}
else if(cat2==lbrace){
big_app1(pp);big_app(' ');big_app1(pp+1);big_app(' ');big_app1(pp+2);
reduce(pp,3,lbrace,-2,43);
}
}

/*:128*/
#line 2350 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case struct_like:/*129:*/
#line 2681 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==lbrace){
big_app1(pp);big_app(' ');big_app1(pp+1);reduce(pp,2,struct_head,0,44);
}
else if(cat1==exp||cat1==int_like){
if(cat2==lbrace||cat2==semi){
make_underlined(pp+1);make_reserved(pp+1);
big_app1(pp);big_app(' ');big_app1(pp+1);
if(cat2==semi)reduce(pp,2,decl_head,0,45);
else{
big_app(' ');big_app1(pp+2);reduce(pp,3,struct_head,0,46);
}
}
else if(cat2==colon)squash(pp+2,1,base,2,47);
else if(cat2!=base){
big_app1(pp);big_app(' ');big_app1(pp+1);reduce(pp,2,int_like,-2,48);
}
}

/*:129*/
#line 2351 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case struct_head:/*130:*/
#line 2700 "../../../texk/web2c/cwebdir/cweave.w"

if((cat1==decl||cat1==stmt||cat1==function)&&cat2==rbrace){
big_app1(pp);big_app(indent);big_app(force);big_app1(pp+1);
big_app(outdent);big_app(force);big_app1(pp+2);
reduce(pp,3,int_like,-2,49);
}
else if(cat1==rbrace){
big_app1(pp);app_str("\\,");big_app1(pp+1);

reduce(pp,2,int_like,-2,50);
}

/*:130*/
#line 2352 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case fn_decl:/*131:*/
#line 2712 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==decl){
big_app1(pp);big_app(force);big_app1(pp+1);reduce(pp,2,fn_decl,0,51);
}
else if(cat1==stmt){
big_app1(pp);app(outdent);app(outdent);big_app(force);
big_app1(pp+1);reduce(pp,2,function,-1,52);
}

/*:131*/
#line 2353 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case function:/*132:*/
#line 2721 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==function||cat1==decl||cat1==stmt){
big_app1(pp);big_app(big_force);big_app1(pp+1);reduce(pp,2,cat1,-1,53);
}

/*:132*/
#line 2354 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case lbrace:/*133:*/
#line 2726 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==rbrace){
big_app1(pp);app('\\');app(',');big_app1(pp+1);

reduce(pp,2,stmt,-1,54);
}
else if((cat1==stmt||cat1==decl||cat1==function)&&cat2==rbrace){
big_app(force);big_app1(pp);big_app(indent);big_app(force);
big_app1(pp+1);big_app(force);big_app(backup);big_app1(pp+2);
big_app(outdent);big_app(force);reduce(pp,3,stmt,-1,55);
}
else if(cat1==exp){
if(cat2==rbrace)squash(pp,3,exp,-2,56);
else if(cat2==comma&&cat3==rbrace)squash(pp,4,exp,-2,56);
}

/*:133*/
#line 2355 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case if_like:/*134:*/
#line 2742 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==exp){
big_app1(pp);big_app(' ');big_app1(pp+1);reduce(pp,2,if_clause,0,57);
}

/*:134*/
#line 2356 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case else_like:/*135:*/
#line 2747 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==colon)squash(pp+1,1,base,1,58);
else if(cat1==lbrace)squash(pp,1,else_head,0,59);
else if(cat1==stmt){
big_app(force);big_app1(pp);big_app(indent);big_app(break_space);
big_app1(pp+1);big_app(outdent);big_app(force);
reduce(pp,2,stmt,-1,60);
}

/*:135*/
#line 2357 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case else_head:/*136:*/
#line 2756 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==stmt||cat1==exp){
big_app(force);big_app1(pp);big_app(break_space);app(noop);
big_app(cancel);big_app1(pp+1);big_app(force);
reduce(pp,2,stmt,-1,61);
}

/*:136*/
#line 2358 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case if_clause:/*137:*/
#line 2763 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==lbrace)squash(pp,1,if_head,0,62);
else if(cat1==stmt){
if(cat2==else_like){
big_app(force);big_app1(pp);big_app(indent);big_app(break_space);
big_app1(pp+1);big_app(outdent);big_app(force);big_app1(pp+2);
if(cat3==if_like){
big_app(' ');big_app1(pp+3);reduce(pp,4,if_like,0,63);
}else reduce(pp,3,else_like,0,64);
}
else squash(pp,1,else_like,0,65);
}

/*:137*/
#line 2359 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case if_head:/*138:*/
#line 2776 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==stmt||cat1==exp){
if(cat2==else_like){
big_app(force);big_app1(pp);big_app(break_space);app(noop);
big_app(cancel);big_app1(pp+1);big_app(force);big_app1(pp+2);
if(cat3==if_like){
big_app(' ');big_app1(pp+3);reduce(pp,4,if_like,0,66);
}else reduce(pp,3,else_like,0,67);
}
else squash(pp,1,else_head,0,68);
}

/*:138*/
#line 2360 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case do_like:/*139:*/
#line 2788 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==stmt&&cat2==else_like&&cat3==semi){
big_app1(pp);big_app(break_space);app(noop);big_app(cancel);
big_app1(pp+1);big_app(cancel);app(noop);big_app(break_space);
big_app2(pp+2);reduce(pp,4,stmt,-1,69);
}

/*:139*/
#line 2361 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case case_like:/*140:*/
#line 2795 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==semi)squash(pp,2,stmt,-1,70);
else if(cat1==colon)squash(pp,2,tag,-1,71);
else if(cat1==exp){
big_app1(pp);big_app(' ');big_app1(pp+1);reduce(pp,2,exp,-2,72);
}

/*:140*/
#line 2362 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case catch_like:/*141:*/
#line 2802 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==cast||cat1==exp){
big_app2(pp);big_app(indent);big_app(indent);reduce(pp,2,fn_decl,0,73);
}

/*:141*/
#line 2363 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case tag:/*142:*/
#line 2807 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==tag){
big_app1(pp);big_app(break_space);big_app1(pp+1);reduce(pp,2,tag,-1,74);
}
else if(cat1==stmt||cat1==decl||cat1==function){
big_app(force);big_app(backup);big_app1(pp);big_app(break_space);
big_app1(pp+1);reduce(pp,2,cat1,-1,75);
}

/*:142*/
#line 2364 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case stmt:/*143:*/
#line 2820 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==stmt||cat1==decl||cat1==function){
big_app1(pp);
if(cat1==function)big_app(big_force);
else if(cat1==decl)big_app(big_force);
else if(force_lines)big_app(force);
else big_app(break_space);
big_app1(pp+1);reduce(pp,2,cat1,-1,76);
}

/*:143*/
#line 2365 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case semi:/*144:*/
#line 2830 "../../../texk/web2c/cwebdir/cweave.w"

big_app(' ');big_app1(pp);reduce(pp,1,stmt,-1,77);

/*:144*/
#line 2366 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case lproc:/*145:*/
#line 2833 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==define_like)make_underlined(pp+2);
if(cat1==else_like||cat1==if_like||cat1==define_like)
squash(pp,2,lproc,0,78);
else if(cat1==rproc){
app(inserted);big_app2(pp);reduce(pp,2,insert,-1,79);
}else if(cat1==exp||cat1==function){
if(cat2==rproc){
app(inserted);big_app1(pp);big_app(' ');big_app2(pp+1);
reduce(pp,3,insert,-1,80);
}
else if(cat2==exp&&cat3==rproc&&cat1==exp){
app(inserted);big_app1(pp);big_app(' ');big_app1(pp+1);app_str(" \\5");

big_app2(pp+2);reduce(pp,4,insert,-1,80);
}
}

/*:145*/
#line 2367 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case section_scrap:/*146:*/
#line 2851 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==semi){
big_app2(pp);big_app(force);reduce(pp,2,stmt,-2,81);
}
else squash(pp,1,exp,-2,82);

/*:146*/
#line 2368 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case insert:/*147:*/
#line 2857 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1)
squash(pp,2,cat1,0,83);

/*:147*/
#line 2369 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case prelangle:/*148:*/
#line 2861 "../../../texk/web2c/cwebdir/cweave.w"

init_mathness= cur_mathness= yes_math;
app('<');reduce(pp,1,binop,-2,84);

/*:148*/
#line 2370 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case prerangle:/*149:*/
#line 2865 "../../../texk/web2c/cwebdir/cweave.w"

init_mathness= cur_mathness= yes_math;
app('>');reduce(pp,1,binop,-2,85);

/*:149*/
#line 2371 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case langle:/*150:*/
#line 2869 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==prerangle){
big_app1(pp);app('\\');app(',');big_app1(pp+1);

reduce(pp,2,cast,-1,86);
}
else if(cat1==decl_head||cat1==int_like||cat1==exp){
if(cat2==prerangle)squash(pp,3,cast,-1,87);
else if(cat2==comma){
big_app3(pp);app(opt);app('9');reduce(pp,3,langle,0,88);
}
}

/*:150*/
#line 2372 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case template_like:/*151:*/
#line 2882 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==exp&&cat2==prelangle)squash(pp+2,1,langle,2,89);
else if(cat1==exp||cat1==raw_int){
big_app1(pp);big_app(' ');big_app1(pp+1);reduce(pp,2,cat1,-2,90);
}else squash(pp,1,raw_int,0,91);

/*:151*/
#line 2373 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case new_like:/*152:*/
#line 2888 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==lpar&&cat2==exp&&cat3==rpar)squash(pp,4,new_like,0,92);
else if(cat1==cast){
big_app1(pp);big_app(' ');big_app1(pp+1);reduce(pp,2,exp,-2,93);
}
else if(cat1!=lpar)squash(pp,1,new_exp,0,94);

/*:152*/
#line 2374 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case new_exp:/*153:*/
#line 2895 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==int_like||cat1==const_like){
big_app1(pp);big_app(' ');big_app1(pp+1);reduce(pp,2,new_exp,0,95);
}
else if(cat1==struct_like&&(cat2==exp||cat2==int_like)){
big_app1(pp);big_app(' ');big_app1(pp+1);big_app(' ');
big_app1(pp+2);reduce(pp,3,new_exp,0,96);
}
else if(cat1==raw_ubin){
big_app1(pp);big_app('{');big_app1(pp+1);big_app('}');
reduce(pp,2,new_exp,0,97);
}
else if(cat1==lpar)squash(pp,1,exp,-2,98);
else if(cat1==exp){
big_app1(pp);big_app(' ');reduce(pp,1,exp,-2,98);
}
else if(cat1!=raw_int&&cat1!=struct_like&&cat1!=colcol)
squash(pp,1,exp,-2,99);

/*:153*/
#line 2375 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case ftemplate:/*154:*/
#line 2914 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==prelangle)squash(pp+1,1,langle,1,100);
else squash(pp,1,exp,-2,101);

/*:154*/
#line 2376 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case for_like:/*155:*/
#line 2918 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==exp){
big_app1(pp);big_app(' ');big_app1(pp+1);reduce(pp,2,else_like,-2,102);
}

/*:155*/
#line 2377 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case raw_ubin:/*156:*/
#line 2923 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==const_like){
big_app2(pp);app_str("\\ ");reduce(pp,2,raw_ubin,0,103);

}else squash(pp,1,ubinop,-2,104);

/*:156*/
#line 2378 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case const_like:/*157:*/
#line 2929 "../../../texk/web2c/cwebdir/cweave.w"

squash(pp,1,int_like,-2,105);

/*:157*/
#line 2379 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case raw_int:/*158:*/
#line 2932 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==prelangle)squash(pp+1,1,langle,1,106);
else if(cat1==colcol)squash(pp,2,colcol,-1,107);
else if(cat1==cast)squash(pp,2,raw_int,0,108);
else if(cat1==lpar)squash(pp,1,exp,-2,109);
else if(cat1!=langle)squash(pp,1,int_like,-3,110);

/*:158*/
#line 2380 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case operator_like:/*159:*/
#line 2939 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==binop||cat1==unop||cat1==ubinop){
if(cat2==binop)break;
big_app1(pp);big_app('{');big_app1(pp+1);big_app('}');
reduce(pp,2,exp,-2,111);
}
else if(cat1==new_like||cat1==delete_like){
big_app1(pp);big_app(' ');big_app1(pp+1);reduce(pp,2,exp,-2,112);
}
else if(cat1==comma)squash(pp,2,exp,-2,113);
else if(cat1!=raw_ubin)squash(pp,1,new_exp,0,114);

/*:159*/
#line 2381 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case typedef_like:/*160:*/
#line 2951 "../../../texk/web2c/cwebdir/cweave.w"

if((cat1==int_like||cat1==cast)&&(cat2==comma||cat2==semi))
squash(pp+1,1,exp,-1,115);
else if(cat1==int_like){
big_app1(pp);big_app(' ');big_app1(pp+1);reduce(pp,2,typedef_like,0,116);
}
else if(cat1==exp&&cat2!=lpar&&cat2!=exp&&cat2!=cast){
make_underlined(pp+1);make_reserved(pp+1);
big_app1(pp);big_app(' ');big_app1(pp+1);reduce(pp,2,typedef_like,0,117);
}
else if(cat1==comma){
big_app2(pp);big_app(' ');reduce(pp,2,typedef_like,0,118);
}
else if(cat1==semi)squash(pp,2,decl,-1,119);
else if(cat1==ubinop&&(cat2==ubinop||cat2==cast)){
big_app('{');big_app1(pp+1);big_app('}');big_app1(pp+2);
reduce(pp+1,2,cat2,0,120);
}

/*:160*/
#line 2382 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case delete_like:/*161:*/
#line 2970 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==lpar&&cat2==rpar){
big_app2(pp);app('\\');app(',');big_app1(pp+2);

reduce(pp,3,delete_like,0,121);
}
else if(cat1==exp){
big_app1(pp);big_app(' ');big_app1(pp+1);reduce(pp,2,exp,-2,122);
}

/*:161*/
#line 2383 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case question:/*162:*/
#line 2980 "../../../texk/web2c/cwebdir/cweave.w"

if(cat1==exp&&(cat2==colon||cat2==base)){
(pp+2)->mathness= 5*yes_math;
squash(pp,3,binop,-2,123);
}

/*:162*/
#line 2384 "../../../texk/web2c/cwebdir/cweave.w"
;break;
}
pp++;
}

/*:109*/
#line 3072 "../../../texk/web2c/cwebdir/cweave.w"
;
}

/*:165*/
#line 3132 "../../../texk/web2c/cwebdir/cweave.w"
;
/*170:*/
#line 3141 "../../../texk/web2c/cwebdir/cweave.w"
{
/*171:*/
#line 3153 "../../../texk/web2c/cwebdir/cweave.w"

if(lo_ptr> scrap_base&&tracing==1){
printf("\nIrreducible scrap sequence in section %d:",section_count);

mark_harmless;
for(j= scrap_base;j<=lo_ptr;j++){
printf(" ");print_cat(j->cat);
}
}

/*:171*/
#line 3142 "../../../texk/web2c/cwebdir/cweave.w"
;
for(j= scrap_base;j<=lo_ptr;j++){
if(j!=scrap_base)app(' ');
if(j->mathness%4==yes_math)app('$');
app1(j);
if(j->mathness/4==yes_math)app('$');
if(tok_ptr+6> tok_mem_end)overflow("token");
}
freeze_text;return(text_ptr-1);
}

/*:170*/
#line 3133 "../../../texk/web2c/cwebdir/cweave.w"
;
}

/*:169*//*173:*/
#line 3189 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 577 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 C_parse P1C(eight_bits,spec_ctrl)
#line 3193 "../../../texk/web2c/cwebdir/cweave.w"
{
int count;
while(next_control<format_code||next_control==spec_ctrl){
/*175:*/
#line 3212 "../../../texk/web2c/cwebdir/cweave.w"

/*176:*/
#line 3286 "../../../texk/web2c/cwebdir/cweave.w"

if(scrap_ptr+safe_scrap_incr> scrap_info_end||
tok_ptr+safe_tok_incr> tok_mem_end||
text_ptr+safe_text_incr> tok_start_end){
if(scrap_ptr> max_scr_ptr)max_scr_ptr= scrap_ptr;
if(tok_ptr> max_tok_ptr)max_tok_ptr= tok_ptr;
if(text_ptr> max_text_ptr)max_text_ptr= text_ptr;
overflow("scrap/token/text");
}

/*:176*/
#line 3213 "../../../texk/web2c/cwebdir/cweave.w"
;
switch(next_control){
case section_name:
app(section_flag+(int)(cur_section-name_dir));
app_scrap(section_scrap,maybe_math);
app_scrap(exp,yes_math);break;
case string:case constant:case verbatim:/*178:*/
#line 3342 "../../../texk/web2c/cwebdir/cweave.w"

count= -1;
if(next_control==constant)app_str("\\T{");

else if(next_control==string){
count= 20;app_str("\\.{");
}

else app_str("\\vb{");

while(id_first<id_loc){
if(count==0){
app_str("}\\)\\.{");count= 20;

}

if((eight_bits)(*id_first)> 0177){
app_tok(quoted_char);
app_tok((eight_bits)(*id_first++));
}
else{
switch(*id_first){
case' ':case'\\':case'#':case'%':case'$':case'^':
case'{':case'}':case'~':case'&':case'_':app('\\');break;











case'@':if(*(id_first+1)=='@')id_first++;
else err_print("! Double @ should be used in strings");

}
app_tok(*id_first++);
}
count--;
}
app('}');
app_scrap(exp,maybe_math);

/*:178*/
#line 3219 "../../../texk/web2c/cwebdir/cweave.w"
;
break;
case identifier:app_cur_id(1);break;
case TeX_string:/*179:*/
#line 3403 "../../../texk/web2c/cwebdir/cweave.w"

app_str("\\hbox{");

while(id_first<id_loc)
if((eight_bits)(*id_first)> 0177){
app_tok(quoted_char);
app_tok((eight_bits)(*id_first++));
}
else{
if(*id_first=='@')id_first++;
app_tok(*id_first++);
}
app('}');

/*:179*/
#line 3222 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case'/':case'.':
app(next_control);app_scrap(binop,yes_math);break;
case'<':app_str("\\langle");app_scrap(prelangle,yes_math);break;

case'>':app_str("\\rangle");app_scrap(prerangle,yes_math);break;

case'=':app_str("\\K");app_scrap(binop,yes_math);break;

case'|':app_str("\\OR");app_scrap(binop,yes_math);break;

case'^':app_str("\\XOR");app_scrap(binop,yes_math);break;

case'%':app_str("\\MOD");app_scrap(binop,yes_math);break;

case'!':app_str("\\R");app_scrap(unop,yes_math);break;

case'~':app_str("\\CM");app_scrap(unop,yes_math);break;

case'+':case'-':app(next_control);app_scrap(ubinop,yes_math);break;
case'*':app(next_control);app_scrap(raw_ubin,yes_math);break;
case'&':app_str("\\AND");app_scrap(raw_ubin,yes_math);break;

case'?':app_str("\\?");app_scrap(question,yes_math);break;

case'#':app_str("\\#");app_scrap(ubinop,yes_math);break;

case ignore:case xref_roman:case xref_wildcard:
case xref_typewriter:case noop:break;
case'(':case'[':app(next_control);app_scrap(lpar,maybe_math);break;
case')':case']':app(next_control);app_scrap(rpar,maybe_math);break;
case'{':app_str("\\{");app_scrap(lbrace,yes_math);break;

case'}':app_str("\\}");app_scrap(rbrace,yes_math);break;

case',':app(',');app_scrap(comma,yes_math);break;
case';':app(';');app_scrap(semi,maybe_math);break;
case':':app(':');app_scrap(colon,no_math);break;
/*177:*/
#line 3300 "../../../texk/web2c/cwebdir/cweave.w"

case not_eq:app_str("\\I");app_scrap(binop,yes_math);break;

case lt_eq:app_str("\\Z");app_scrap(binop,yes_math);break;

case gt_eq:app_str("\\G");app_scrap(binop,yes_math);break;

case eq_eq:app_str("\\E");app_scrap(binop,yes_math);break;

case and_and:app_str("\\W");app_scrap(binop,yes_math);break;

case or_or:app_str("\\V");app_scrap(binop,yes_math);break;

case plus_plus:app_str("\\PP");app_scrap(unop,yes_math);break;

case minus_minus:app_str("\\MM");app_scrap(unop,yes_math);break;

case minus_gt:app_str("\\MG");app_scrap(binop,yes_math);break;

case gt_gt:app_str("\\GG");app_scrap(binop,yes_math);break;

case lt_lt:app_str("\\LL");app_scrap(binop,yes_math);break;

case dot_dot_dot:app_str("\\,\\ldots\\,");app_scrap(raw_int,yes_math);
break;


case colon_colon:app_str("\\DC");app_scrap(colcol,maybe_math);break;

case period_ast:app_str("\\PA");app_scrap(binop,yes_math);break;

case minus_gt_ast:app_str("\\MGA");app_scrap(binop,yes_math);break;


/*:177*/
#line 3260 "../../../texk/web2c/cwebdir/cweave.w"

case thin_space:app_str("\\,");app_scrap(insert,maybe_math);break;

case math_break:app(opt);app_str("0");
app_scrap(insert,maybe_math);break;
case line_break:app(force);app_scrap(insert,no_math);break;
case left_preproc:app(force);app(preproc_line);
app_str("\\#");app_scrap(lproc,no_math);break;

case right_preproc:app(force);app_scrap(rproc,no_math);break;
case big_line_break:app(big_force);app_scrap(insert,no_math);break;
case no_line_break:app(big_cancel);app(noop);app(break_space);
app(noop);app(big_cancel);
app_scrap(insert,no_math);break;
case pseudo_semi:app_scrap(semi,maybe_math);break;
case macro_arg_open:app_scrap(begin_arg,maybe_math);break;
case macro_arg_close:app_scrap(end_arg,maybe_math);break;
case join:app_str("\\J");app_scrap(insert,no_math);break;

case output_defs_code:app(force);app_str("\\ATH");app(force);
app_scrap(insert,no_math);break;

default:app(inserted);app(next_control);
app_scrap(insert,maybe_math);break;
}

/*:175*/
#line 3196 "../../../texk/web2c/cwebdir/cweave.w"
;
next_control= get_next();
if(next_control=='|'||next_control==begin_comment||
next_control==begin_short_comment)return;
}
}

/*:173*//*181:*/
#line 3423 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 594 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 app_cur_id P1C(boolean,scrapping)
#line 3427 "../../../texk/web2c/cwebdir/cweave.w"
{
name_pointer p= id_lookup(id_first,id_loc,normal);
if(p->ilk<=custom){
app(id_flag+(int)(p-name_dir));
if(scrapping)app_scrap(p->ilk==func_template?ftemplate:exp,
p->ilk==custom?yes_math:maybe_math);

}else{
app(res_flag+(int)(p-name_dir));
if(scrapping){
if(p->ilk==alfop)app_scrap(ubinop,yes_math)
else app_scrap(p->ilk,maybe_math);
}
}
}

/*:181*//*182:*/
#line 3448 "../../../texk/web2c/cwebdir/cweave.w"

text_pointer
#line 602 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 C_translate P1H(void)
#line 3451 "../../../texk/web2c/cwebdir/cweave.w"
{
text_pointer p;
scrap_pointer save_base;
save_base= scrap_base;scrap_base= scrap_ptr+1;
C_parse(section_name);
if(next_control!='|')err_print("! Missing '|' after C text");

app_tok(cancel);app_scrap(insert,maybe_math);

p= translate();
if(scrap_ptr> max_scr_ptr)max_scr_ptr= scrap_ptr;
scrap_ptr= scrap_base-1;scrap_base= save_base;
return(p);
}

/*:182*//*183:*/
#line 3478 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 610 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 outer_parse P1H(void)
#line 3481 "../../../texk/web2c/cwebdir/cweave.w"
{
int bal;
text_pointer p,q;
while(next_control<format_code)
if(next_control!=begin_comment&&next_control!=begin_short_comment)
C_parse(ignore);
else{
boolean is_long_comment= (next_control==begin_comment);
/*176:*/
#line 3286 "../../../texk/web2c/cwebdir/cweave.w"

if(scrap_ptr+safe_scrap_incr> scrap_info_end||
tok_ptr+safe_tok_incr> tok_mem_end||
text_ptr+safe_text_incr> tok_start_end){
if(scrap_ptr> max_scr_ptr)max_scr_ptr= scrap_ptr;
if(tok_ptr> max_tok_ptr)max_tok_ptr= tok_ptr;
if(text_ptr> max_text_ptr)max_text_ptr= text_ptr;
overflow("scrap/token/text");
}

/*:176*/
#line 3489 "../../../texk/web2c/cwebdir/cweave.w"
;
app(cancel);app(inserted);
if(is_long_comment)app_str("\\C{");

else app_str("\\SHC{");

bal= copy_comment(is_long_comment,1);next_control= ignore;
while(bal> 0){
p= text_ptr;freeze_text;q= C_translate();

app(tok_flag+(int)(p-tok_start));
if(make_pb)app_str("\\PB{");

app(inner_tok_flag+(int)(q-tok_start));
if(make_pb)app_tok('}');
if(next_control=='|'){
bal= copy_comment(is_long_comment,bal);
next_control= ignore;
}
else bal= 0;
}
app(force);app_scrap(insert,no_math);

}
}

/*:183*//*188:*/
#line 3584 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 619 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 push_level P1C(text_pointer,p)
#line 3588 "../../../texk/web2c/cwebdir/cweave.w"
{
if(stack_ptr==stack_end)overflow("stack");
if(stack_ptr> stack){
stack_ptr->end_field= cur_end;
stack_ptr->tok_field= cur_tok;
stack_ptr->mode_field= cur_mode;
}
stack_ptr++;
if(stack_ptr> max_stack_ptr)max_stack_ptr= stack_ptr;
cur_tok= *p;cur_end= *(p+1);
}

/*:188*//*189:*/
#line 3604 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 627 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 pop_level P1H(void)
#line 3607 "../../../texk/web2c/cwebdir/cweave.w"
{
cur_end= (--stack_ptr)->end_field;
cur_tok= stack_ptr->tok_field;cur_mode= stack_ptr->mode_field;
}

/*:189*//*191:*/
#line 3626 "../../../texk/web2c/cwebdir/cweave.w"

eight_bits
#line 635 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 get_output P1H(void)
#line 3629 "../../../texk/web2c/cwebdir/cweave.w"
{
sixteen_bits a;
restart:while(cur_tok==cur_end)pop_level();
a= *(cur_tok++);
if(a>=0400){
cur_name= a%id_flag+name_dir;
switch(a/id_flag){
case 2:return(res_word);
case 3:return(section_code);
case 4:push_level(a%id_flag+tok_start);goto restart;

case 5:push_level(a%id_flag+tok_start);cur_mode= inner;goto restart;

default:return(identifier);
}
}
return(a);
}

/*:191*//*192:*/
#line 3663 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 643 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 output_C P1H(void)
#line 3666 "../../../texk/web2c/cwebdir/cweave.w"
{
token_pointer save_tok_ptr;
text_pointer save_text_ptr;
sixteen_bits save_next_control;
text_pointer p;
save_tok_ptr= tok_ptr;save_text_ptr= text_ptr;
save_next_control= next_control;next_control= ignore;p= C_translate();
app(inner_tok_flag+(int)(p-tok_start));
if(make_pb){
out_str("\\PB{");make_output();out('}');

}else make_output();
if(text_ptr> max_text_ptr)max_text_ptr= text_ptr;
if(tok_ptr> max_tok_ptr)max_tok_ptr= tok_ptr;
text_ptr= save_text_ptr;tok_ptr= save_tok_ptr;
next_control= save_next_control;
}

/*:192*//*194:*/
#line 3689 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 659 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 make_output P1H(void)
#line 3692 "../../../texk/web2c/cwebdir/cweave.w"
{
eight_bits a,
b;
int c;
char scratch[longest_name];
char*k,*k_limit;
char*j;
char*p;
char delim;
char*save_loc,*save_limit;
name_pointer cur_section_name;
boolean save_mode;
app(end_translation);
freeze_text;push_level(text_ptr-1);
while(1){
a= get_output();
reswitch:switch(a){
case end_translation:return;
case identifier:case res_word:/*195:*/
#line 3740 "../../../texk/web2c/cwebdir/cweave.w"

out('\\');
if(a==identifier){
if(cur_name->ilk==custom&&!doing_format){
custom_out:
for(p= cur_name->byte_start;p<(cur_name+1)->byte_start;p++)
out(*p=='_'?'x':*p=='$'?'X':*p);
break;
}else if(is_tiny(cur_name))out('|')

else{delim= '.';
for(p= cur_name->byte_start;p<(cur_name+1)->byte_start;p++)
if(xislower(*p)){
delim= '\\';break;
}
out(delim);
}


}else if(cur_name->ilk==alfop){
out('X');
goto custom_out;
}else out('&');

if(is_tiny(cur_name)){
if(isxalpha((cur_name->byte_start)[0]))
out('\\');
out((cur_name->byte_start)[0]);
}
else out_name(cur_name,1);

/*:195*/
#line 3710 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case section_code:/*199:*/
#line 3841 "../../../texk/web2c/cwebdir/cweave.w"
{
out_str("\\X");

cur_xref= (xref_pointer)cur_name->xref;
if(cur_xref->num==file_flag){an_output= 1;cur_xref= cur_xref->xlink;}
else an_output= 0;
if(cur_xref->num>=def_flag){
out_section(cur_xref->num-def_flag);
if(phase==3){
cur_xref= cur_xref->xlink;
while(cur_xref->num>=def_flag){
out_str(", ");
out_section(cur_xref->num-def_flag);
cur_xref= cur_xref->xlink;
}
}
}
else out('0');
out(':');
if(an_output)out_str("\\.{");

/*200:*/
#line 3867 "../../../texk/web2c/cwebdir/cweave.w"

sprint_section_name(scratch,cur_name);
k= scratch;
k_limit= scratch+strlen(scratch);
cur_section_name= cur_name;
while(k<k_limit){
b= *(k++);
if(b=='@')/*201:*/
#line 3902 "../../../texk/web2c/cwebdir/cweave.w"

if(*k++!='@'){
printf("\n! Illegal control code in section name: <");

print_section_name(cur_section_name);printf("> ");mark_error;
}

/*:201*/
#line 3874 "../../../texk/web2c/cwebdir/cweave.w"
;
if(an_output)
switch(b){
case' ':case'\\':case'#':case'%':case'$':case'^':
case'{':case'}':case'~':case'&':case'_':
out('\\');











default:out(b);
}
else if(b!='|')out(b)
else{
/*202:*/
#line 3915 "../../../texk/web2c/cwebdir/cweave.w"

j= limit+1;*j= '|';delim= 0;
while(1){
if(k>=k_limit){
printf("\n! C text in section name didn't end: <");

print_section_name(cur_section_name);printf("> ");mark_error;break;
}
b= *(k++);
if(b=='@'||(b=='\\'&&delim!=0))
/*203:*/
#line 3938 "../../../texk/web2c/cwebdir/cweave.w"
{
if(j> buffer+long_buf_size-4)overflow("buffer");
*(++j)= b;*(++j)= *(k++);
}

/*:203*/
#line 3925 "../../../texk/web2c/cwebdir/cweave.w"

else{
if(b=='\''||b=='"')
if(delim==0)delim= b;
else if(delim==b)delim= 0;
if(b!='|'||delim!=0){
if(j> buffer+long_buf_size-3)overflow("buffer");
*(++j)= b;
}
else break;
}
}

/*:202*/
#line 3895 "../../../texk/web2c/cwebdir/cweave.w"
;
save_loc= loc;save_limit= limit;loc= limit+2;limit= j+1;
*limit= '|';output_C();
loc= save_loc;limit= save_limit;
}
}

/*:200*/
#line 3862 "../../../texk/web2c/cwebdir/cweave.w"
;
if(an_output)out_str(" }");
out_str("\\X");
}

/*:199*/
#line 3711 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case math_rel:out_str("\\MRL{");

case noop:case inserted:break;
case cancel:case big_cancel:c= 0;b= a;
while(1){
a= get_output();
if(a==inserted)continue;
if((a<indent&&!(b==big_cancel&&a==' '))||a> big_force)break;
if(a==indent)c++;else if(a==outdent)c--;
else if(a==opt)a= get_output();
}
/*198:*/
#line 3828 "../../../texk/web2c/cwebdir/cweave.w"

for(;c> 0;c--)out_str("\\1");

for(;c<0;c++)out_str("\\2");


/*:198*/
#line 3723 "../../../texk/web2c/cwebdir/cweave.w"
;
goto reswitch;
case indent:case outdent:case opt:case backup:case break_space:
case force:case big_force:case preproc_line:/*196:*/
#line 3774 "../../../texk/web2c/cwebdir/cweave.w"

if(a<break_space||a==preproc_line){
if(cur_mode==outer){
out('\\');out(a-cancel+'0');





if(a==opt){
b= get_output();
if(b!='0'||force_lines==0)out(b)
else out_str("{-1}");
}
}else if(a==opt)b= get_output();
}
else/*197:*/
#line 3798 "../../../texk/web2c/cwebdir/cweave.w"
{
b= a;save_mode= cur_mode;c= 0;
while(1){
a= get_output();
if(a==inserted)continue;
if(a==cancel||a==big_cancel){
/*198:*/
#line 3828 "../../../texk/web2c/cwebdir/cweave.w"

for(;c> 0;c--)out_str("\\1");

for(;c<0;c++)out_str("\\2");


/*:198*/
#line 3804 "../../../texk/web2c/cwebdir/cweave.w"
;
goto reswitch;
}
if((a!=' '&&a<indent)||a==backup||a> big_force){
if(save_mode==outer){
if(out_ptr> out_buf+3&&strncmp(out_ptr-3,"\\Y\\B",4)==0)
goto reswitch;
/*198:*/
#line 3828 "../../../texk/web2c/cwebdir/cweave.w"

for(;c> 0;c--)out_str("\\1");

for(;c<0;c++)out_str("\\2");


/*:198*/
#line 3811 "../../../texk/web2c/cwebdir/cweave.w"
;
out('\\');out(b-cancel+'0');



if(a!=end_translation)finish_line();
}
else if(a!=end_translation&&cur_mode==inner)out(' ');
goto reswitch;
}
if(a==indent)c++;
else if(a==outdent)c--;
else if(a==opt)a= get_output();
else if(a> b)b= a;
}
}

/*:197*/
#line 3790 "../../../texk/web2c/cwebdir/cweave.w"


/*:196*/
#line 3727 "../../../texk/web2c/cwebdir/cweave.w"
;break;
case quoted_char:out(*(cur_tok++));
case qualifier:break;
default:out(a);
}
}
}

/*:194*//*205:*/
#line 3953 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 675 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 phase_two P1H(void){
#line 3956 "../../../texk/web2c/cwebdir/cweave.w"
reset_input();if(show_progress)printf("\nWriting the output file...");

section_count= 0;format_visible= 1;copy_limbo();
finish_line();flush_buffer(out_buf,0,0);
while(!input_has_ended)/*207:*/
#line 3986 "../../../texk/web2c/cwebdir/cweave.w"
{
section_count++;
/*208:*/
#line 4004 "../../../texk/web2c/cwebdir/cweave.w"

if(*(loc-1)!='*')out_str("\\M");

else{
while(*loc==' ')loc++;
if(*loc=='*'){
sec_depth= -1;
loc++;
}
else{
for(sec_depth= 0;xisdigit(*loc);loc++)
sec_depth= sec_depth*10+(*loc)-'0';
}
while(*loc==' ')loc++;
group_found= 1;
out_str("\\N");

{char s[32];sprintf(s,"{%d}",sec_depth+1);out_str(s);}
if(show_progress)
printf("*%d",section_count);update_terminal;
}
out_str("{");out_section(section_count);out_str("}");

/*:208*/
#line 3988 "../../../texk/web2c/cwebdir/cweave.w"
;
save_position;
/*209:*/
#line 4030 "../../../texk/web2c/cwebdir/cweave.w"
do{
next_control= copy_TeX();
switch(next_control){
case'|':init_stack;output_C();break;
case'@':out('@');break;
case TeX_string:case noop:
case xref_roman:case xref_wildcard:case xref_typewriter:
case section_name:loc-= 2;next_control= get_next();
if(next_control==TeX_string)
err_print("! TeX string should be in C text only");break;

case thin_space:case math_break:case ord:
case line_break:case big_line_break:case no_line_break:case join:
case pseudo_semi:case macro_arg_open:case macro_arg_close:
case output_defs_code:
err_print("! You can't do that in TeX text");break;

}
}while(next_control<format_code);

/*:209*/
#line 3990 "../../../texk/web2c/cwebdir/cweave.w"
;
/*210:*/
#line 4053 "../../../texk/web2c/cwebdir/cweave.w"

space_checked= 0;
while(next_control<=definition){
init_stack;
if(next_control==definition)/*213:*/
#line 4111 "../../../texk/web2c/cwebdir/cweave.w"
{
if(save_line!=out_line||save_place!=out_ptr||space_checked)app(backup);
if(!space_checked){emit_space_if_needed;save_position;}
app_str("\\D");

if((next_control= get_next())!=identifier)
err_print("! Improper macro definition");

else{
app('$');app_cur_id(0);
if(*loc=='(')
reswitch:switch(next_control= get_next()){
case'(':case',':app(next_control);goto reswitch;
case identifier:app_cur_id(0);goto reswitch;
case')':app(next_control);next_control= get_next();break;
default:err_print("! Improper macro definition");break;
}
else next_control= get_next();
app_str("$ ");app(break_space);
app_scrap(dead,no_math);
}
}

/*:213*/
#line 4057 "../../../texk/web2c/cwebdir/cweave.w"

else/*214:*/
#line 4134 "../../../texk/web2c/cwebdir/cweave.w"
{
doing_format= 1;
if(*(loc-1)=='s'||*(loc-1)=='S')format_visible= 0;
if(!space_checked){emit_space_if_needed;save_position;}
app_str("\\F");

next_control= get_next();
if(next_control==identifier){
app(id_flag+(int)(id_lookup(id_first,id_loc,normal)-name_dir));
app(' ');
app(break_space);
next_control= get_next();
if(next_control==identifier){
app(id_flag+(int)(id_lookup(id_first,id_loc,normal)-name_dir));
app_scrap(exp,maybe_math);app_scrap(semi,maybe_math);
next_control= get_next();
}
}
if(scrap_ptr!=scrap_info+2)err_print("! Improper format definition");

}

/*:214*/
#line 4058 "../../../texk/web2c/cwebdir/cweave.w"
;
outer_parse();finish_C(format_visible);format_visible= 1;
doing_format= 0;
}

/*:210*/
#line 3991 "../../../texk/web2c/cwebdir/cweave.w"
;
/*216:*/
#line 4163 "../../../texk/web2c/cwebdir/cweave.w"

this_section= name_dir;
if(next_control<=section_name){
emit_space_if_needed;init_stack;
if(next_control==begin_C)next_control= get_next();
else{
this_section= cur_section;
/*217:*/
#line 4183 "../../../texk/web2c/cwebdir/cweave.w"

do next_control= get_next();
while(next_control=='+');
if(next_control!='='&&next_control!=eq_eq)
err_print("! You need an = sign after the section name");

else next_control= get_next();
if(out_ptr> out_buf+1&&*out_ptr=='Y'&&*(out_ptr-1)=='\\')app(backup);


app(section_flag+(int)(this_section-name_dir));
cur_xref= (xref_pointer)this_section->xref;
if(cur_xref->num==file_flag)cur_xref= cur_xref->xlink;
app_str("${}");
if(cur_xref->num!=section_count+def_flag){
app_str("\\mathrel+");
this_section= name_dir;
}
app_str("\\E");

app_str("{}$");
app(force);app_scrap(dead,no_math);


/*:217*/
#line 4171 "../../../texk/web2c/cwebdir/cweave.w"
;
}
while(next_control<=section_name){
outer_parse();
/*218:*/
#line 4207 "../../../texk/web2c/cwebdir/cweave.w"

if(next_control<section_name){
err_print("! You can't do that in C text");

next_control= get_next();
}
else if(next_control==section_name){
app(section_flag+(int)(cur_section-name_dir));
app_scrap(section_scrap,maybe_math);
next_control= get_next();
}

/*:218*/
#line 4175 "../../../texk/web2c/cwebdir/cweave.w"
;
}
finish_C(1);
}

/*:216*/
#line 3992 "../../../texk/web2c/cwebdir/cweave.w"
;
/*219:*/
#line 4222 "../../../texk/web2c/cwebdir/cweave.w"

if(this_section> name_dir){
cur_xref= (xref_pointer)this_section->xref;
if(cur_xref->num==file_flag){an_output= 1;cur_xref= cur_xref->xlink;}
else an_output= 0;
if(cur_xref->num> def_flag)
cur_xref= cur_xref->xlink;
footnote(def_flag);footnote(cite_flag);footnote(0);
}

/*:219*/
#line 3993 "../../../texk/web2c/cwebdir/cweave.w"
;
/*223:*/
#line 4280 "../../../texk/web2c/cwebdir/cweave.w"

out_str("\\fi");finish_line();

flush_buffer(out_buf,0,0);

/*:223*/
#line 3994 "../../../texk/web2c/cwebdir/cweave.w"
;
}

/*:207*/
#line 3960 "../../../texk/web2c/cwebdir/cweave.w"
;
}

/*:205*//*212:*/
#line 4076 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 692 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 finish_C P1C(boolean,visible)
#line 4080 "../../../texk/web2c/cwebdir/cweave.w"
{
text_pointer p;
if(visible){
out_str("\\B");app_tok(force);app_scrap(insert,no_math);
p= translate();

app(tok_flag+(int)(p-tok_start));make_output();
if(out_ptr> out_buf+1)
if(*(out_ptr-1)=='\\')



if(*out_ptr=='6')out_ptr-= 2;
else if(*out_ptr=='7')*out_ptr= 'Y';
out_str("\\par");finish_line();
}
if(text_ptr> max_text_ptr)max_text_ptr= text_ptr;
if(tok_ptr> max_tok_ptr)max_tok_ptr= tok_ptr;
if(scrap_ptr> max_scr_ptr)max_scr_ptr= scrap_ptr;
tok_ptr= tok_mem+1;text_ptr= tok_start+1;scrap_ptr= scrap_info;

}

/*:212*//*221:*/
#line 4247 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 709 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 footnote P1C(sixteen_bits,flag)
#line 4251 "../../../texk/web2c/cwebdir/cweave.w"
{
xref_pointer q;
if(cur_xref->num<=flag)return;
finish_line();out('\\');



out(flag==0?'U':flag==cite_flag?'Q':'A');
/*222:*/
#line 4267 "../../../texk/web2c/cwebdir/cweave.w"

q= cur_xref;if(q->xlink->num> flag)out('s');
while(1){
out_section(cur_xref->num-flag);
cur_xref= cur_xref->xlink;
if(cur_xref->num<=flag)break;
if(cur_xref->xlink->num> flag)out_str(", ");
else{out_str("\\ET");

if(cur_xref!=q->xlink)out('s');
}
}

/*:222*/
#line 4259 "../../../texk/web2c/cwebdir/cweave.w"
;
out('.');
}

/*:221*//*225:*/
#line 4296 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 725 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 phase_three P1H(void){
#line 4299 "../../../texk/web2c/cwebdir/cweave.w"
if(no_xref){
finish_line();
out_str("\\end");

finish_line();
}
else{
phase= 3;if(show_progress)printf("\nWriting the index...");

finish_line();
if((idx_file= fopen(idx_file_name,"w"))==NULL)
fatal("! Cannot open index file ",idx_file_name);

if(change_exists){
/*227:*/
#line 4347 "../../../texk/web2c/cwebdir/cweave.w"
{

k_section= 0;
while(!changed_section[++k_section]);
out_str("\\ch ");

out_section(k_section);
while(k_section<section_count){
while(!changed_section[++k_section]);
out_str(", ");out_section(k_section);
}
out('.');
}

/*:227*/
#line 4313 "../../../texk/web2c/cwebdir/cweave.w"
;finish_line();finish_line();
}
out_str("\\inx");finish_line();

active_file= idx_file;
/*229:*/
#line 4378 "../../../texk/web2c/cwebdir/cweave.w"
{
int c;
for(c= 0;c<=255;c++)bucket[c]= NULL;
for(h= hash;h<=hash_end;h++){
next_name= *h;
while(next_name){
cur_name= next_name;next_name= cur_name->link;
if(cur_name->xref!=(char*)xmem){
c= (eight_bits)((cur_name->byte_start)[0]);
if(xisupper(c))c= tolower(c);
blink[cur_name-name_dir]= bucket[c];bucket[c]= cur_name;
}
}
}
}

/*:229*/
#line 4318 "../../../texk/web2c/cwebdir/cweave.w"
;
/*238:*/
#line 4494 "../../../texk/web2c/cwebdir/cweave.w"

sort_ptr= scrap_info;unbucket(1);
while(sort_ptr> scrap_info){
cur_depth= sort_ptr->depth;
if(blink[sort_ptr->head-name_dir]==0||cur_depth==infinity)
/*240:*/
#line 4519 "../../../texk/web2c/cwebdir/cweave.w"
{
cur_name= sort_ptr->head;
do{
out_str("\\I");

/*241:*/
#line 4531 "../../../texk/web2c/cwebdir/cweave.w"

switch(cur_name->ilk){
case normal:case func_template:if(is_tiny(cur_name))out_str("\\|");
else{char*j;
for(j= cur_name->byte_start;j<(cur_name+1)->byte_start;j++)
if(xislower(*j))goto lowcase;
out_str("\\.");break;
lowcase:out_str("\\\\");
}
break;



case wildcard:out_str("\\9");goto not_an_identifier;

case typewriter:out_str("\\.");

case roman:not_an_identifier:out_name(cur_name,0);goto name_done;
case custom:{char*j;out_str("$\\");
for(j= cur_name->byte_start;j<(cur_name+1)->byte_start;j++)
out(*j=='_'?'x':*j=='$'?'X':*j);
out('$');
goto name_done;
}
default:out_str("\\&");

}
out_name(cur_name,1);
name_done:

/*:241*/
#line 4524 "../../../texk/web2c/cwebdir/cweave.w"
;
/*242:*/
#line 4564 "../../../texk/web2c/cwebdir/cweave.w"

/*244:*/
#line 4582 "../../../texk/web2c/cwebdir/cweave.w"

this_xref= (xref_pointer)cur_name->xref;cur_xref= xmem;
do{
next_xref= this_xref->xlink;this_xref->xlink= cur_xref;
cur_xref= this_xref;this_xref= next_xref;
}while(this_xref!=xmem);

/*:244*/
#line 4565 "../../../texk/web2c/cwebdir/cweave.w"
;
do{
out_str(", ");cur_val= cur_xref->num;
if(cur_val<def_flag)out_section(cur_val);
else{out_str("\\[");out_section(cur_val-def_flag);out(']');}

cur_xref= cur_xref->xlink;
}while(cur_xref!=xmem);
out('.');finish_line();

/*:242*/
#line 4525 "../../../texk/web2c/cwebdir/cweave.w"
;
cur_name= blink[cur_name-name_dir];
}while(cur_name);
--sort_ptr;
}

/*:240*/
#line 4499 "../../../texk/web2c/cwebdir/cweave.w"

else/*239:*/
#line 4503 "../../../texk/web2c/cwebdir/cweave.w"
{
eight_bits c;
next_name= sort_ptr->head;
do{
cur_name= next_name;next_name= blink[cur_name-name_dir];
cur_byte= cur_name->byte_start+cur_depth;
if(cur_byte==(cur_name+1)->byte_start)c= 0;
else{
c= (eight_bits)*cur_byte;
if(xisupper(c))c= tolower(c);
}
blink[cur_name-name_dir]= bucket[c];bucket[c]= cur_name;
}while(next_name);
--sort_ptr;unbucket(cur_depth+1);
}

/*:239*/
#line 4500 "../../../texk/web2c/cwebdir/cweave.w"
;
}

/*:238*/
#line 4319 "../../../texk/web2c/cwebdir/cweave.w"
;
finish_line();fclose(active_file);
active_file= tex_file;
out_str("\\fin");finish_line();

if((scn_file= fopen(scn_file_name,"w"))==NULL)
fatal("! Cannot open section file ",scn_file_name);

active_file= scn_file;
/*247:*/
#line 4613 "../../../texk/web2c/cwebdir/cweave.w"
section_print(root)

/*:247*/
#line 4328 "../../../texk/web2c/cwebdir/cweave.w"
;
finish_line();fclose(active_file);
active_file= tex_file;
if(group_found)out_str("\\con");else out_str("\\end");


finish_line();
fclose(active_file);
}
if(show_happiness)printf("\nDone.");
check_complete();
}

/*:225*//*237:*/
#line 4476 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 742 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 unbucket P1C(eight_bits,d)
#line 4480 "../../../texk/web2c/cwebdir/cweave.w"
{
int c;

for(c= 100+128;c>=0;c--)if(bucket[collate[c]]){

if(sort_ptr>=scrap_info_end)overflow("sorting");
sort_ptr++;
if(sort_ptr> max_sort_ptr)max_sort_ptr= sort_ptr;
if(c==0)sort_ptr->depth= infinity;
else sort_ptr->depth= d;
sort_ptr->head= bucket[collate[c]];bucket[collate[c]]= NULL;
}
}

/*:237*//*246:*/
#line 4596 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 759 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 section_print P1C(name_pointer,p)
#line 4600 "../../../texk/web2c/cwebdir/cweave.w"
{
if(p){
section_print(p->llink);out_str("\\I");

tok_ptr= tok_mem+1;text_ptr= tok_start+1;scrap_ptr= scrap_info;init_stack;
app(p-name_dir+section_flag);make_output();
footnote(cite_flag);
footnote(0);
finish_line();
section_print(p->rlink);
}
}

/*:246*//*248:*/
#line 4618 "../../../texk/web2c/cwebdir/cweave.w"

void
#line 767 "../../../texk/web2c/cwebdir/cweav-w2c.ch"
 print_stats P1H(void){
#line 4621 "../../../texk/web2c/cwebdir/cweave.w"
printf("\nMemory usage statistics:\n");

printf("%ld names (out of %ld)\n",
(long)(name_ptr-name_dir),(long)max_names);
printf("%ld cross-references (out of %ld)\n",
(long)(xref_ptr-xmem),(long)max_refs);
printf("%ld bytes (out of %ld)\n",
(long)(byte_ptr-byte_mem),(long)max_bytes);
printf("Parsing:\n");
printf("%ld scraps (out of %ld)\n",
(long)(max_scr_ptr-scrap_info),(long)max_scraps);
printf("%ld texts (out of %ld)\n",
(long)(max_text_ptr-tok_start),(long)max_texts);
printf("%ld tokens (out of %ld)\n",
(long)(max_tok_ptr-tok_mem),(long)max_toks);
printf("%ld levels (out of %ld)\n",
(long)(max_stack_ptr-stack),(long)stack_size);
printf("Sorting:\n");
printf("%ld levels (out of %ld)\n",
(long)(max_sort_ptr-scrap_info),(long)max_scraps);
}

/*:248*/
