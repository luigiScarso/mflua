# Makefile for luatex.
# $Id: Makefile.in 7433 2008-04-15 23:20:46Z karl $

# common.mk -- used by all Makefiles.
SHELL = /bin/sh

top_srcdir = ..
srcdir = .


CC = gcc
CFLAGS = -g -O2 $(XCFLAGS)
CPPFLAGS =  $(XCPPFLAGS)
DEFS = -DHAVE_CONFIG_H $(XDEFS)
LDFLAGS =  $(XLDFLAGS)

# Kpathsea needs this for compiling, programs need it for linking.
LIBTOOL = $(SHELL) $(kpathsea_parent)/libtool

# You can change [X]CPPFLAGS, [X]CFLAGS, or [X]DEFS, but
# please don't change ALL_CPPFLAGS or ALL_CFLAGS.
# prog_cflags is set by subdirectories of web2c.
ALL_CPPFLAGS = $(DEFS) -I. -I$(srcdir) -I$(kpathsea_parent) \
  -I$(kpathsea_srcdir_parent) $(prog_cflags) $(CPPFLAGS)
ALL_CFLAGS = $(ALL_CPPFLAGS) $(CFLAGS)
ALL_CXXFLAGS = $(ALL_CPPFLAGS) $(CXXFLAGS)
compile = $(CC) $(ALL_CFLAGS)

.SUFFIXES:
.SUFFIXES: .c .o .lo # in case the suffix list has been cleared, e.g., by web2c
.c.o:
	$(compile) -c $< -o $@

# Installation.
INSTALL = /usr/bin/install -c
INSTALL_PROGRAM = ${INSTALL}
INSTALL_SCRIPT = ${INSTALL}
INSTALL_DATA = ${INSTALL} -m 644
INSTALL_LIBTOOL_LIBS = $(LIBTOOL) --mode=install $(INSTALL_DATA)
INSTALL_LIBTOOL_PROG = $(LIBTOOL) --mode=install $(INSTALL_PROGRAM)

# Creating (symbolic) links.
LN = ln -s

# Removing files.
RM = rm -f

# Uninstall.
UNINSTALL = $(RM)
UNINSTALL_PROGRAM = $(RM)
UNINSTALL_SCRIPT = $(RM)
UNINSTALL_DATA = $(RM)
UNINSTALL_LIBTOOL_LIBS = $(LIBTOOL) --mode=uninstall $(RM)
UNINSTALL_LIBTOOL_PROG = $(LIBTOOL) --mode=uninstall $(RM)

# We use these for many things.
kpathsea_parent = ..
kpathsea_dir = $(kpathsea_parent)/kpathsea
kpathsea_srcdir_parent = $(top_srcdir)/..
kpathsea_srcdir = $(kpathsea_srcdir_parent)/kpathsea
kpathsea = $(kpathsea_dir)/libkpathsea.la

#M#ifeq ($(CC), gcc)
#M#XDEFS = -Wpointer-arith $(warn_more)
#M#CFLAGS = -g $(XCFLAGS)
#M#endif
# End of common.mk.
# programs.mk -- used by Makefiles for executables only.

# Don't include $(CFLAGS), since ld -g under Linux forces
# static libraries, e.g., libc.a and libX*.a.
LDFLAGS =  $(XLDFLAGS)

# proglib is for web2c; 
# XLOADLIBES is for the installer.
LIBS = -lm 
LOADLIBES = $(proglib) $(kpathsea) $(LIBS) $(XLOADLIBES)

# May as well separate linking from compiling, just in case.
CCLD = $(CC)
link_command = $(CCLD) -o $@ $(LDFLAGS) 

# When we link with Kpathsea, have to take account that it might be a
# shared library, etc.
kpathsea_link = $(LIBTOOL) --mode=link $(link_command)
# End of programs.mk.
# library.mk -- stuff only useful for libraries.
AR = ar
ARFLAGS = rc
RANLIB = ranlib
# End of library.mk.

kpathsea_srcdir_parent = $(srcdir)/../..
kpathsea_dir_parent = ../..

ALL_CXXFLAGS = -g -O2 -DHAVE_CONFIG_H $(XXCFLAGS) -I. -I$(srcdir) -I$(kpathsea_dir_parent) -I$(kpathsea_srcdir_parent) -I$(LIBXPDFDIR) -I$(LIBXPDFDIR)/xpdf -I$(LIBXPDFDIR)/goo -I$(LIBXPDFDIR)/fofi -I$(LIBXPDFSRCDIR) -I$(LIBXPDFSRCDIR)/xpdf -I$(LIBXPDFSRCDIR)/goo -I$(LIBXPDFSRCDIR)/fofi -I$(LIBOBSDCOMPATDIR) -I$(LIBOBSDCOMPATDIR)/.. -I$(LIBOBSDCOMPATFSRCDIR) -I$(LIBOBSDCOMPATFSRCDIR)/.. -I$(LIBPNGSRCDIR) -I$(ZLIBSRCDIR)
CXX = g++

CTANGLE = ../ctangle

.SUFFIXES: .cc .o
.cc.o:
	$(CXX) $(ALL_CXXFLAGS) -c $< -o $@

# XCFLAGS=-Wstrict-prototypes -Wmissing-prototypes 

LIBPNGDIR=../../../libs/libpng
LIBPNGSRCDIR=$(srcdir)/$(LIBPNGDIR)

ZLIBDIR=../../../libs/zlib
ZLIBSRCDIR=$(srcdir)/$(ZLIBDIR)

LIBXPDFDIR=../../../libs/xpdf
LIBXPDFSRCDIR=$(srcdir)/$(LIBXPDFDIR)

LIBMD5DIR=../../../libs/md5
LIBMD5SRCDIR=$(srcdir)/$(LIBMD5DIR)

LIBOBSDCOMPATDIR=../../../libs/obsdcompat
LIBOBSDCOMPATFSRCDIR=$(srcdir)/$(LIBOBSDCOMPATDIR)

XCPPFLAGS=-I.. -I$(srcdir)/.. -I../.. -I$(srcdir)/../.. -I$(LIBMD5DIR) \
  -I$(LIBMD5SRCDIR) -I$(LIBPNGDIR) -I$(LIBPNGSRCDIR) -I$(ZLIBDIR) -I$(ZLIBSRCDIR) \
  -I$(LIBXPDFDIR) -I$(LIBXPDFDIR)/.. -I$(LIBXPDFSRCDIR) -I$(LIBXPDFSRCDIR)/.. \
  -I$(LIBOBSDCOMPATDIR) -I$(LIBOBSDCOMPATDIR)/.. -I$(LIBOBSDCOMPATFSRCDIR) \
  -I$(LIBOBSDCOMPATFSRCDIR)/.. -DpdfTeX


OBJS = \
avl.o \
avlstuff.o \
font/mapfile.o \
font/pkin.o \
font/subfont.o \
font/tounicode.o \
font/vfpacket.o \
font/writeenc.o \
font/writefont.o \
font/writet1.o \
font/writet3.o \
font/writettf.o \
font/writetype0.o \
font/writetype2.o \
font/writecff.o \
font/tt_glyf.o \
font/tt_table.o \
font/sfnt.o \
font/texfont.o \
font/tfmofm.o \
font/vfovf.o \
font/luafont.o \
font/dofont.o \
image/epdf.o \
image/pdftoepdf.o \
image/writeimg.o \
image/writejbig2.o \
image/writejpg.o \
image/writepng.o \
lua/loslibext.o \
lua/lcallbacklib.o \
lua/lkpselib.o \
lua/llualib.o \
lua/lnodelib.o \
lua/lpdflib.o \
lua/lstatslib.o \
lua/ltexiolib.o \
lua/ltexlib.o \
lua/ltokenlib.o \
lua/lfontlib.o \
lua/texluac.o \
lua/luainit.o \
lua/luastuff.o \
lua/luatex.o \
lua/luatoken.o \
lua/luanode.o \
lua/llanglib.o \
lua/limglib.o \
lua/mp.o \
lua/psout.o \
lua/lmplib.o \
lang/hnjalloc.o \
lang/hyphen.o \
lang/texlang.o \
tex/linebreak.o \
tex/postlinebreak.o \
tex/texnodes.o \
tex/textoken.o \
tex/texpdf.o \
managed-sa.o \
mathcodes.o \
textcodes.o \
utils.o \
writezip.o

all: libpdf.a $(makecpool)

libpdf.a: lua/mp.c lua/psout.c $(OBJS)
	rm -f $@
	$(AR) $(ARFLAGS) $@  $(OBJS)
	$(RANLIB) $@

lua/mp.c: lua/mp.w
	$(CTANGLE) $(srcdir)/lua/mp.w - lua/mp.c

lua/psout.c: lua/psout.w
	$(CTANGLE) $(srcdir)/lua/psout.w - lua/psout.c

# clean.mk -- cleaning.
mostlyclean::
	rm -f *.o

clean:: mostlyclean
	-$(LIBTOOL) --mode=clean rm -f $(program) $(programs)
	rm -f $(library).a squeeze *.bad *.dvi *.lj

distclean:: extraclean clean
	rm -f Makefile Makefile.aux
	rm -f config.status config.log config.cache c-auto.h libtool
	rm -rf conftest*
	rm -f stamp-auto stamp-tangle stamp-ctangle
	rm -rf .libs

# Although we can remake configure and c-auto.in, we don't remove
# them, since many people may lack Autoconf.  Use configclean for that.
maintainer-clean:: distclean
	rm -f *.info*

extraclean::
	rm -f *.aux *.bak *.bbl *.blg *.dvi *.log *.pl *.tfm *.vf *.vpl
	rm -f *.*pk *.*gf *.mpx *.i *.s *~ *.orig  *.rej *\#*
	rm -f CONTENTS.tex a.out core mfput.* texput.* mpout.*

configclean:
	rm -f configure c-auto.in c-auto.h stamp-*
# End of clean.mk.

clean::
	rm -f libpdf.a ttf2afm pdftosrc

depend:
	rm -f $(OBJS) $(srcdir)/depend.mk
	for a in $(OBJS);  do 	                                       \
		env XXCFLAGS="-MM -MT \$$@" XCFLAGS="-MM -MT \$$@" $(MAKE) -k $$a;                 \
		touch $$a;                                                 \
		grep -a -v "^$(CC)\|$(CXX)\|$(AR)\|make\|klibtool" $$a |   \
		sed 's: [^ ]*/\.\./libs/[^ ]*::g' >> $(srcdir)/depend.mk;  \
	done;                                                          \
	rm -f $(OBJS)

lua/mp.o: lua/mp.c mplib.h mpmp.h mppsout.h
lua/psout.o: lua/psout.c avl.h mplib.h mpmp.h mppsout.h
lua/lmplib.o: lua/lmplib.c mplib.h mpmp.h mppsout.h
