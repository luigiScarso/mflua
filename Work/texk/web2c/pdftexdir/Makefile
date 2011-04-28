# Makefile for libpdf - te@dbs.uni-hannover.de
# $Id: Makefile.in 9636 2008-07-17 17:58:14Z karl $

# common.mk -- used by all Makefiles.
SHELL = /bin/sh

top_srcdir = ../../../../texk/web2c
srcdir = ../../../../texk/web2c/pdftexdir
VPATH = ../../../../texk/web2c/pdftexdir

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

ALL_CXXFLAGS = -g -O2 -DHAVE_CONFIG_H $(XXCFLAGS) \
  -I. -I$(srcdir) \
  -I$(kpathsea_dir_parent) -I$(kpathsea_srcdir_parent) \
   \
  -I$(LIBOBSDCOMPATDIR) -I$(LIBOBSDCOMPATDIR)/.. \
  -I$(LIBOBSDCOMPATSRCDIR) -I$(LIBOBSDCOMPATSRCDIR)/.. \
  -DPDF_PARSER_ONLY
CXX = g++

.SUFFIXES: .cc .o
.cc.o:
	$(CXX) $(ALL_CXXFLAGS) -c $<

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
LIBOBSDCOMPATSRCDIR=$(srcdir)/$(LIBOBSDCOMPATDIR)

XCPPFLAGS=-I.. -I$(srcdir)/.. -I../.. -I$(srcdir)/../.. -I$(LIBMD5DIR) \
  -I$(LIBMD5SRCDIR)   \
  -I$(LIBXPDFDIR) -I$(LIBXPDFDIR)/.. -I$(LIBXPDFSRCDIR) -I$(LIBXPDFSRCDIR)/.. \
  -I$(LIBOBSDCOMPATDIR) -I$(LIBOBSDCOMPATDIR)/.. -I$(LIBOBSDCOMPATSRCDIR) \
  -I$(LIBOBSDCOMPATSRCDIR)/.. -DpdfTeX

OBJS = epdf.o mapfile.o utils.o vfpacket.o pkin.o \
writefont.o writet1.o writet3.o writezip.o writeenc.o writettf.o \
writejpg.o writejbig2.o writepng.o writeimg.o pdftoepdf.o avl.o avlstuff.o subfont.o tounicode.o

all: libpdf.a

pdftosrc.o: $(srcdir)/pdftosrc.cc

libpdf.a: $(OBJS)
	rm -f $@
	$(AR) $(ARFLAGS) $@  $(OBJS)
	$(RANLIB) $@

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
	rm -f $(OBJS) ttf2afm.o pdftosrc.o
	XXCFLAGS=-MM XCFLAGS=-MM $(MAKE) -k $(OBJS) ttf2afm.o pdftosrc.o | \
	    grep -v "^$(CC)\|$(CXX)\|$(AR)\|make\" | \
	    sed 's: [^ ]*/\.\./libs/[^ ]*::g' > $(srcdir)/depend.mk

epdf.o: epdf.c ptexlib.h ../pdftexd.h ../texmfmp.h ../cpascal.h \
 ../config.h ../help.h ../texmfmem.h ../pdftexcoerce.h ptexmac.h
mapfile.o: mapfile.c ptexlib.h ../pdftexd.h ../texmfmp.h ../cpascal.h \
 ../config.h ../help.h ../texmfmem.h ../pdftexcoerce.h ptexmac.h
papersiz.o: papersiz.c ptexlib.h ../pdftexd.h ../texmfmp.h \
 ../cpascal.h ../config.h ../help.h ../texmfmem.h ../pdftexcoerce.h \
 ptexmac.h
utils.o: utils.c ptexlib.h ../pdftexd.h ../texmfmp.h ../cpascal.h \
 ../config.h ../help.h ../texmfmem.h ../pdftexcoerce.h ptexmac.h \
 ../../../libs/zlib/zlib.h ../../../libs/zlib/zconf.h \
 ../../../libs/md5/md5.h pdftexextra.h \
 ../../../libs/obsdcompat/openbsd-compat.h
vfpacket.o: vfpacket.c ptexlib.h ../pdftexd.h ../texmfmp.h \
 ../cpascal.h ../config.h ../help.h ../texmfmem.h ../pdftexcoerce.h \
 ptexmac.h
pkin.o: pkin.c ptexlib.h ../pdftexd.h ../texmfmp.h ../cpascal.h \
 ../config.h ../help.h ../texmfmem.h ../pdftexcoerce.h ptexmac.h
writefont.o: writefont.c ../../../libs/xpdf/goo/gmem.h ptexlib.h \
 ../pdftexd.h ../texmfmp.h ../cpascal.h ../config.h ../help.h \
 ../texmfmem.h ../pdftexcoerce.h ptexmac.h
writet1.o: writet1.c ptexlib.h ../pdftexd.h ../texmfmp.h ../cpascal.h \
 ../config.h ../help.h ../texmfmem.h ../pdftexcoerce.h ptexmac.h
writet3.o: writet3.c ptexlib.h ../pdftexd.h ../texmfmp.h ../cpascal.h \
 ../config.h ../help.h ../texmfmem.h ../pdftexcoerce.h ptexmac.h
writezip.o: writezip.c ptexlib.h ../pdftexd.h ../texmfmp.h \
 ../cpascal.h ../config.h ../help.h ../texmfmem.h ../pdftexcoerce.h \
 ptexmac.h ../../../libs/zlib/zlib.h ../../../libs/zlib/zconf.h
writeenc.o: writeenc.c ptexlib.h ../pdftexd.h ../texmfmp.h \
 ../cpascal.h ../config.h ../help.h ../texmfmem.h ../pdftexcoerce.h \
 ptexmac.h
writettf.o: writettf.c ptexlib.h writettf.h ../pdftexd.h ../texmfmp.h \
 ../cpascal.h ../config.h ../help.h ../texmfmem.h ../pdftexcoerce.h \
 ptexmac.h macnames.c
writejpg.o: writejpg.c ptexlib.h ../pdftexd.h ../texmfmp.h \
 ../cpascal.h ../config.h ../help.h ../texmfmem.h ../pdftexcoerce.h \
 ptexmac.h image.h
writepng.o: writepng.c ptexlib.h ../pdftexd.h ../texmfmp.h \
 ../cpascal.h ../config.h ../help.h ../texmfmem.h ../pdftexcoerce.h \
 ptexmac.h image.h
writeimg.o: writeimg.c ptexlib.h ../pdftexd.h ../texmfmp.h \
 ../cpascal.h ../config.h ../help.h ../texmfmem.h ../pdftexcoerce.h \
 ptexmac.h image.h
pdftoepdf.o: pdftoepdf.cc ../../../libs/xpdf/xpdf/Object.h \
 ../../../libs/xpdf/goo/gmem.h ../../../libs/xpdf/xpdf/Array.h \
 ../../../libs/xpdf/xpdf/Dict.h ../../../libs/xpdf/xpdf/Stream.h \
 ../../../libs/xpdf/xpdf/XRef.h ../../../libs/xpdf/xpdf/Catalog.h \
 ../../../libs/xpdf/xpdf/Page.h ../../../libs/xpdf/xpdf/GfxFont.h \
 ../../../libs/xpdf/xpdf/Error.h epdf.h
ttf2afm.o: ttf2afm.c writettf.h macnames.c
pdftosrc.o: pdftosrc.cc ../../../libs/xpdf/xpdf/Object.h \
 ../../../libs/xpdf/xpdf/Array.h ../../../libs/xpdf/xpdf/Dict.h \
 ../../../libs/xpdf/xpdf/Stream.h ../../../libs/xpdf/xpdf/XRef.h \
 ../../../libs/xpdf/xpdf/Catalog.h ../../../libs/xpdf/xpdf/Page.h \
 ../../../libs/xpdf/xpdf/PDFDoc.h ../../../libs/xpdf/xpdf/Link.h \
 ../../../libs/xpdf/xpdf/Error.h ../../../libs/xpdf/xpdf/config.h
