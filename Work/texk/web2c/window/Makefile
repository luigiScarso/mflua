# window/Makefile.aux. Generated from Makefile.in by configure.
# window/Makefile.  Generated from Makefile.aux by configure.
# Makefile for the Metafont window support library.

# common.mk -- used by all Makefiles.
SHELL = /bin/sh

top_srcdir = ../../../../texk/web2c
srcdir = ../../../../texk/web2c/window
VPATH = ../../../../texk/web2c/window

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
# library.mk -- stuff only useful for libraries.
AR = ar
ARFLAGS = rc
RANLIB = ranlib
# End of library.mk.
# web2c/kpathsea.mk -- In subdirectories of web2c, the build directory
# for kpathsea is one more level up.  c_auto_h_dir is used by make depend.
kpathsea_parent = ../..
c_auto_h_dir = ..

prog_cflags = -I.. -I$(srcdir)/..
# End of web2c/kpathsea.mk.

x_cppflags = 
library = window

# Extra library-specific compiler options.
prog_cflags = -I.. -I$(srcdir)/.. $(x_cppflags)

objects = amiga.o epsf.o hp2627.o mftalk.o next.o regis.o suntools.o tek.o \
trap.o uniterm.o win32.o x11.o 

default all: $(library).a
$(library).a: $(objects)
	rm -f $@
	$(AR) $(ARFLAGS) $@ $(objects)
	$(RANLIB) $@

# It doesn't matter much what this default is, since if anything was
# enabled configure would hopefully have found it.
x11.c:
	rm -f $@
	$(LN) $(srcdir)/x11-Xt.c $@

Makefile: Makefile.in ../config.status
	cd .. && $(SHELL) config.status

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

distclean::
	rm -f x11.c

# rdepend.mk -- rules for remaking the dependencies.  Public domain.
# $Id: rdepend.mk 4681 2007-07-28 23:16:42Z karl $
#M## 
#M## Have to use -M, not -MM, since we use <kpathsea/...> instead of
#M## "kpathsea/..." in the sources.	 But that means we have to remove the
#M## directory prefixes and all the system include files.
#M## And <kpathsea/paths.h> is generated, not part of the distribution.
#M## We also remove any ../texk/kpathsea path component, since that comes
#M## from VPATH when srcdir != builddir.
#M## 
#M## There's no need for any installer/user to ever run this, it can
#M## only cause trouble. So comment it out by default.
#M## 
#M#ifndef c_auto_h_dir
#M#c_auto_h_dir = .
#M#endif
#M#
#M#depend depend.mk:: $(c_auto_h_dir)/c-auto.h \
#M#	 $(top_srcdir)/../make/rdepend.mk 
#M#	$(CC) -M $(ALL_CPPFLAGS) \
#M#		-I$(c_auto_h_dir) \
#M#		-I$(top_srcdir)/../../libs/libgsw32 \
#M#		$(srcdir)/*.c \
#M#	  | sed -e 's,\(\.\./\)\+texk/kpathsea/,,g' \
#M#		-e 's,\(\.\./\)\+kpathsea/,$$(kpathsea_srcdir)/,g' \
#M#		-e 's,$$(kpathsea_srcdir)/c-auto.h,$$(kpathsea_dir)/c-auto.h,g' \
#M#		-e 's,$$(kpathsea_srcdir)/paths.h,$$(kpathsea_dir)/paths.h,g' \
#M#		-e 's, /[^ ]*,,g' \
#M#		-e 's, [^ ]*/\.\./libs/[^ ]*,,g' \
#M#		-e 's, \./, ,g' \
#M#		-e 's,dvi2xx.o,dvilj.o dvilj2p.o dvilj4.o dvilj4l.o,' \
#M#		-e 's,lex.yy,$$(LEX_OUTPUT_ROOT),g' \
#M#	  | $(top_srcdir)/../unbackslsh.awk \
#M#	  >depend.mk
#M## If kpathsea, we're making .lo library objects instead of .o's.
#M#	pwd | grep -v kpathsea >/dev/null \
#M#	  || (sed -e 's/\.o:/.lo:/' \
#M#		  -e 's/kpsewhich.lo:/kpsewhich.o:/' \
#M#		  -e 's/kpsestat.lo:/kpsestat.o:/' \
#M#		  -e 's/access.lo:/access.o:/' \
#M#		  -e 's/readlink.lo:/readlink.o:/' \
#M#	      <depend.mk >depend-tmp.mk; mv depend-tmp.mk depend.mk)
#M#.PHONY: depend

# Let's stick a rule for TAGS here, just in case someone wants them.
# (We don't put them in the distributions, to keep them smaller.)
TAGS: *.c *.h
	pwd | grep kpathsea >/dev/null && append=../kpathsea/TAGS; \
	  etags $$append *.[ch]

# Prevent GNU make 3.[59,63) from overflowing arg limit on system V.
.NOEXPORT:

# End of rdepend.mk.
amiga.o: amiga.c ../mfd.h ../texmfmp.h ../cpascal.h ../config.h \
  $(kpathsea_srcdir)/config.h $(kpathsea_dir)/c-auto.h $(kpathsea_srcdir)/c-std.h \
  $(kpathsea_srcdir)/c-unistd.h $(kpathsea_srcdir)/systypes.h \
  $(kpathsea_srcdir)/c-memstr.h \
  $(kpathsea_srcdir)/c-errno.h \
  $(kpathsea_srcdir)/c-minmax.h $(kpathsea_srcdir)/c-limits.h \
  $(kpathsea_srcdir)/c-proto.h $(kpathsea_srcdir)/debug.h \
  $(kpathsea_srcdir)/types.h $(kpathsea_srcdir)/lib.h $(kpathsea_srcdir)/progname.h \
  ../../web2c/c-auto.h $(kpathsea_srcdir)/c-vararg.h $(kpathsea_srcdir)/c-fopen.h \
  $(kpathsea_srcdir)/getopt.h \
  $(kpathsea_srcdir)/proginit.h $(kpathsea_srcdir)/tex-file.h ../help.h \
  $(kpathsea_srcdir)/c-pathch.h $(kpathsea_srcdir)/c-ctype.h \
  $(kpathsea_srcdir)/tex-make.h ../texmfmem.h ../mfcoerce.h
epsf.o: epsf.c ../mfd.h ../texmfmp.h ../cpascal.h ../config.h \
  $(kpathsea_srcdir)/config.h $(kpathsea_dir)/c-auto.h $(kpathsea_srcdir)/c-std.h \
  $(kpathsea_srcdir)/c-unistd.h $(kpathsea_srcdir)/systypes.h \
  $(kpathsea_srcdir)/c-memstr.h \
  $(kpathsea_srcdir)/c-errno.h \
  $(kpathsea_srcdir)/c-minmax.h $(kpathsea_srcdir)/c-limits.h \
  $(kpathsea_srcdir)/c-proto.h $(kpathsea_srcdir)/debug.h \
  $(kpathsea_srcdir)/types.h $(kpathsea_srcdir)/lib.h $(kpathsea_srcdir)/progname.h \
  ../../web2c/c-auto.h $(kpathsea_srcdir)/c-vararg.h $(kpathsea_srcdir)/c-fopen.h \
  $(kpathsea_srcdir)/getopt.h \
  $(kpathsea_srcdir)/proginit.h $(kpathsea_srcdir)/tex-file.h ../help.h \
  $(kpathsea_srcdir)/c-pathch.h $(kpathsea_srcdir)/c-ctype.h \
  $(kpathsea_srcdir)/tex-make.h ../texmfmem.h ../mfcoerce.h
hp2627.o: hp2627.c ../mfd.h ../texmfmp.h ../cpascal.h ../config.h \
  $(kpathsea_srcdir)/config.h $(kpathsea_dir)/c-auto.h $(kpathsea_srcdir)/c-std.h \
  $(kpathsea_srcdir)/c-unistd.h $(kpathsea_srcdir)/systypes.h \
  $(kpathsea_srcdir)/c-memstr.h \
  $(kpathsea_srcdir)/c-errno.h \
  $(kpathsea_srcdir)/c-minmax.h $(kpathsea_srcdir)/c-limits.h \
  $(kpathsea_srcdir)/c-proto.h $(kpathsea_srcdir)/debug.h \
  $(kpathsea_srcdir)/types.h $(kpathsea_srcdir)/lib.h $(kpathsea_srcdir)/progname.h \
  ../../web2c/c-auto.h $(kpathsea_srcdir)/c-vararg.h $(kpathsea_srcdir)/c-fopen.h \
  $(kpathsea_srcdir)/getopt.h \
  $(kpathsea_srcdir)/proginit.h $(kpathsea_srcdir)/tex-file.h ../help.h \
  $(kpathsea_srcdir)/c-pathch.h $(kpathsea_srcdir)/c-ctype.h \
  $(kpathsea_srcdir)/tex-make.h ../texmfmem.h ../mfcoerce.h
mftalk.o: mftalk.c ../mfd.h ../texmfmp.h ../cpascal.h ../config.h \
  $(kpathsea_srcdir)/config.h $(kpathsea_dir)/c-auto.h $(kpathsea_srcdir)/c-std.h \
  $(kpathsea_srcdir)/c-unistd.h $(kpathsea_srcdir)/systypes.h \
  $(kpathsea_srcdir)/c-memstr.h \
  $(kpathsea_srcdir)/c-errno.h \
  $(kpathsea_srcdir)/c-minmax.h $(kpathsea_srcdir)/c-limits.h \
  $(kpathsea_srcdir)/c-proto.h $(kpathsea_srcdir)/debug.h \
  $(kpathsea_srcdir)/types.h $(kpathsea_srcdir)/lib.h $(kpathsea_srcdir)/progname.h \
  ../../web2c/c-auto.h $(kpathsea_srcdir)/c-vararg.h $(kpathsea_srcdir)/c-fopen.h \
  $(kpathsea_srcdir)/getopt.h \
  $(kpathsea_srcdir)/proginit.h $(kpathsea_srcdir)/tex-file.h ../help.h \
  $(kpathsea_srcdir)/c-pathch.h $(kpathsea_srcdir)/c-ctype.h \
  $(kpathsea_srcdir)/tex-make.h ../texmfmem.h ../mfcoerce.h
next.o: next.c ../mfd.h ../texmfmp.h ../cpascal.h ../config.h \
  $(kpathsea_srcdir)/config.h $(kpathsea_dir)/c-auto.h $(kpathsea_srcdir)/c-std.h \
  $(kpathsea_srcdir)/c-unistd.h $(kpathsea_srcdir)/systypes.h \
  $(kpathsea_srcdir)/c-memstr.h \
  $(kpathsea_srcdir)/c-errno.h \
  $(kpathsea_srcdir)/c-minmax.h $(kpathsea_srcdir)/c-limits.h \
  $(kpathsea_srcdir)/c-proto.h $(kpathsea_srcdir)/debug.h \
  $(kpathsea_srcdir)/types.h $(kpathsea_srcdir)/lib.h $(kpathsea_srcdir)/progname.h \
  ../../web2c/c-auto.h $(kpathsea_srcdir)/c-vararg.h $(kpathsea_srcdir)/c-fopen.h \
  $(kpathsea_srcdir)/getopt.h \
  $(kpathsea_srcdir)/proginit.h $(kpathsea_srcdir)/tex-file.h ../help.h \
  $(kpathsea_srcdir)/c-pathch.h $(kpathsea_srcdir)/c-ctype.h \
  $(kpathsea_srcdir)/tex-make.h ../texmfmem.h ../mfcoerce.h
regis.o: regis.c ../mfd.h ../texmfmp.h ../cpascal.h ../config.h \
  $(kpathsea_srcdir)/config.h $(kpathsea_dir)/c-auto.h $(kpathsea_srcdir)/c-std.h \
  $(kpathsea_srcdir)/c-unistd.h $(kpathsea_srcdir)/systypes.h \
  $(kpathsea_srcdir)/c-memstr.h \
  $(kpathsea_srcdir)/c-errno.h \
  $(kpathsea_srcdir)/c-minmax.h $(kpathsea_srcdir)/c-limits.h \
  $(kpathsea_srcdir)/c-proto.h $(kpathsea_srcdir)/debug.h \
  $(kpathsea_srcdir)/types.h $(kpathsea_srcdir)/lib.h $(kpathsea_srcdir)/progname.h \
  ../../web2c/c-auto.h $(kpathsea_srcdir)/c-vararg.h $(kpathsea_srcdir)/c-fopen.h \
  $(kpathsea_srcdir)/getopt.h \
  $(kpathsea_srcdir)/proginit.h $(kpathsea_srcdir)/tex-file.h ../help.h \
  $(kpathsea_srcdir)/c-pathch.h $(kpathsea_srcdir)/c-ctype.h \
  $(kpathsea_srcdir)/tex-make.h ../texmfmem.h ../mfcoerce.h
suntools.o: suntools.c ../mfd.h ../texmfmp.h ../cpascal.h ../config.h \
  $(kpathsea_srcdir)/config.h $(kpathsea_dir)/c-auto.h $(kpathsea_srcdir)/c-std.h \
  $(kpathsea_srcdir)/c-unistd.h $(kpathsea_srcdir)/systypes.h \
  $(kpathsea_srcdir)/c-memstr.h \
  $(kpathsea_srcdir)/c-errno.h \
  $(kpathsea_srcdir)/c-minmax.h $(kpathsea_srcdir)/c-limits.h \
  $(kpathsea_srcdir)/c-proto.h $(kpathsea_srcdir)/debug.h \
  $(kpathsea_srcdir)/types.h $(kpathsea_srcdir)/lib.h $(kpathsea_srcdir)/progname.h \
  ../../web2c/c-auto.h $(kpathsea_srcdir)/c-vararg.h $(kpathsea_srcdir)/c-fopen.h \
  $(kpathsea_srcdir)/getopt.h \
  $(kpathsea_srcdir)/proginit.h $(kpathsea_srcdir)/tex-file.h ../help.h \
  $(kpathsea_srcdir)/c-pathch.h $(kpathsea_srcdir)/c-ctype.h \
  $(kpathsea_srcdir)/tex-make.h ../texmfmem.h ../mfcoerce.h
tek.o: tek.c ../mfd.h ../texmfmp.h ../cpascal.h ../config.h \
  $(kpathsea_srcdir)/config.h $(kpathsea_dir)/c-auto.h $(kpathsea_srcdir)/c-std.h \
  $(kpathsea_srcdir)/c-unistd.h $(kpathsea_srcdir)/systypes.h \
  $(kpathsea_srcdir)/c-memstr.h \
  $(kpathsea_srcdir)/c-errno.h \
  $(kpathsea_srcdir)/c-minmax.h $(kpathsea_srcdir)/c-limits.h \
  $(kpathsea_srcdir)/c-proto.h $(kpathsea_srcdir)/debug.h \
  $(kpathsea_srcdir)/types.h $(kpathsea_srcdir)/lib.h $(kpathsea_srcdir)/progname.h \
  ../../web2c/c-auto.h $(kpathsea_srcdir)/c-vararg.h $(kpathsea_srcdir)/c-fopen.h \
  $(kpathsea_srcdir)/getopt.h \
  $(kpathsea_srcdir)/proginit.h $(kpathsea_srcdir)/tex-file.h ../help.h \
  $(kpathsea_srcdir)/c-pathch.h $(kpathsea_srcdir)/c-ctype.h \
  $(kpathsea_srcdir)/tex-make.h ../texmfmem.h ../mfcoerce.h
trap.o: trap.c ../mfd.h ../texmfmp.h ../cpascal.h ../config.h \
  $(kpathsea_srcdir)/config.h $(kpathsea_dir)/c-auto.h $(kpathsea_srcdir)/c-std.h \
  $(kpathsea_srcdir)/c-unistd.h $(kpathsea_srcdir)/systypes.h \
  $(kpathsea_srcdir)/c-memstr.h \
  $(kpathsea_srcdir)/c-errno.h \
  $(kpathsea_srcdir)/c-minmax.h $(kpathsea_srcdir)/c-limits.h \
  $(kpathsea_srcdir)/c-proto.h $(kpathsea_srcdir)/debug.h \
  $(kpathsea_srcdir)/types.h $(kpathsea_srcdir)/lib.h $(kpathsea_srcdir)/progname.h \
  ../../web2c/c-auto.h $(kpathsea_srcdir)/c-vararg.h $(kpathsea_srcdir)/c-fopen.h \
  $(kpathsea_srcdir)/getopt.h \
  $(kpathsea_srcdir)/proginit.h $(kpathsea_srcdir)/tex-file.h ../help.h \
  $(kpathsea_srcdir)/c-pathch.h $(kpathsea_srcdir)/c-ctype.h \
  $(kpathsea_srcdir)/tex-make.h ../texmfmem.h ../mfcoerce.h
uniterm.o: uniterm.c ../mfd.h ../texmfmp.h ../cpascal.h ../config.h \
  $(kpathsea_srcdir)/config.h $(kpathsea_dir)/c-auto.h $(kpathsea_srcdir)/c-std.h \
  $(kpathsea_srcdir)/c-unistd.h $(kpathsea_srcdir)/systypes.h \
  $(kpathsea_srcdir)/c-memstr.h \
  $(kpathsea_srcdir)/c-errno.h \
  $(kpathsea_srcdir)/c-minmax.h $(kpathsea_srcdir)/c-limits.h \
  $(kpathsea_srcdir)/c-proto.h $(kpathsea_srcdir)/debug.h \
  $(kpathsea_srcdir)/types.h $(kpathsea_srcdir)/lib.h $(kpathsea_srcdir)/progname.h \
  ../../web2c/c-auto.h $(kpathsea_srcdir)/c-vararg.h $(kpathsea_srcdir)/c-fopen.h \
  $(kpathsea_srcdir)/getopt.h \
  $(kpathsea_srcdir)/proginit.h $(kpathsea_srcdir)/tex-file.h ../help.h \
  $(kpathsea_srcdir)/c-pathch.h $(kpathsea_srcdir)/c-ctype.h \
  $(kpathsea_srcdir)/tex-make.h ../texmfmem.h ../mfcoerce.h
win32.o: win32.c ../mfd.h ../texmfmp.h ../cpascal.h ../config.h \
  $(kpathsea_srcdir)/config.h $(kpathsea_dir)/c-auto.h $(kpathsea_srcdir)/c-std.h \
  $(kpathsea_srcdir)/c-unistd.h $(kpathsea_srcdir)/systypes.h \
  $(kpathsea_srcdir)/c-memstr.h \
  $(kpathsea_srcdir)/c-errno.h \
  $(kpathsea_srcdir)/c-minmax.h $(kpathsea_srcdir)/c-limits.h \
  $(kpathsea_srcdir)/c-proto.h $(kpathsea_srcdir)/debug.h \
  $(kpathsea_srcdir)/types.h $(kpathsea_srcdir)/lib.h $(kpathsea_srcdir)/progname.h \
  ../../web2c/c-auto.h $(kpathsea_srcdir)/c-vararg.h $(kpathsea_srcdir)/c-fopen.h \
  $(kpathsea_srcdir)/getopt.h \
  $(kpathsea_srcdir)/proginit.h $(kpathsea_srcdir)/tex-file.h ../help.h \
  $(kpathsea_srcdir)/c-pathch.h $(kpathsea_srcdir)/c-ctype.h \
  $(kpathsea_srcdir)/tex-make.h ../texmfmem.h ../mfcoerce.h
x11.o: x11.c ../mfd.h ../texmfmp.h ../cpascal.h ../config.h \
  $(kpathsea_srcdir)/config.h $(kpathsea_dir)/c-auto.h $(kpathsea_srcdir)/c-std.h \
  $(kpathsea_srcdir)/c-unistd.h $(kpathsea_srcdir)/systypes.h \
  $(kpathsea_srcdir)/c-memstr.h \
  $(kpathsea_srcdir)/c-errno.h \
  $(kpathsea_srcdir)/c-minmax.h $(kpathsea_srcdir)/c-limits.h \
  $(kpathsea_srcdir)/c-proto.h $(kpathsea_srcdir)/debug.h \
  $(kpathsea_srcdir)/types.h $(kpathsea_srcdir)/lib.h $(kpathsea_srcdir)/progname.h \
  ../../web2c/c-auto.h $(kpathsea_srcdir)/c-vararg.h $(kpathsea_srcdir)/c-fopen.h \
  $(kpathsea_srcdir)/getopt.h \
  $(kpathsea_srcdir)/proginit.h $(kpathsea_srcdir)/tex-file.h ../help.h \
  $(kpathsea_srcdir)/c-pathch.h $(kpathsea_srcdir)/c-ctype.h \
  $(kpathsea_srcdir)/tex-make.h ../texmfmem.h ../mfcoerce.h 
x11-Xlib.o: x11-Xlib.c ../mfd.h ../texmfmp.h ../cpascal.h ../config.h \
  $(kpathsea_srcdir)/config.h $(kpathsea_dir)/c-auto.h $(kpathsea_srcdir)/c-std.h \
  $(kpathsea_srcdir)/c-unistd.h $(kpathsea_srcdir)/systypes.h \
  $(kpathsea_srcdir)/c-memstr.h \
  $(kpathsea_srcdir)/c-errno.h \
  $(kpathsea_srcdir)/c-minmax.h $(kpathsea_srcdir)/c-limits.h \
  $(kpathsea_srcdir)/c-proto.h $(kpathsea_srcdir)/debug.h \
  $(kpathsea_srcdir)/types.h $(kpathsea_srcdir)/lib.h $(kpathsea_srcdir)/progname.h \
  ../../web2c/c-auto.h $(kpathsea_srcdir)/c-vararg.h $(kpathsea_srcdir)/c-fopen.h \
  $(kpathsea_srcdir)/getopt.h \
  $(kpathsea_srcdir)/proginit.h $(kpathsea_srcdir)/tex-file.h ../help.h \
  $(kpathsea_srcdir)/c-pathch.h $(kpathsea_srcdir)/c-ctype.h \
  $(kpathsea_srcdir)/tex-make.h ../texmfmem.h ../mfcoerce.h 
x11-Xt.o: x11-Xt.c ../mfd.h ../texmfmp.h ../cpascal.h ../config.h \
  $(kpathsea_srcdir)/config.h $(kpathsea_dir)/c-auto.h $(kpathsea_srcdir)/c-std.h \
  $(kpathsea_srcdir)/c-unistd.h $(kpathsea_srcdir)/systypes.h \
  $(kpathsea_srcdir)/c-memstr.h \
  $(kpathsea_srcdir)/c-errno.h \
  $(kpathsea_srcdir)/c-minmax.h $(kpathsea_srcdir)/c-limits.h \
  $(kpathsea_srcdir)/c-proto.h $(kpathsea_srcdir)/debug.h \
  $(kpathsea_srcdir)/types.h $(kpathsea_srcdir)/lib.h $(kpathsea_srcdir)/progname.h \
  ../../web2c/c-auto.h $(kpathsea_srcdir)/c-vararg.h $(kpathsea_srcdir)/c-fopen.h \
  $(kpathsea_srcdir)/getopt.h \
  $(kpathsea_srcdir)/proginit.h $(kpathsea_srcdir)/tex-file.h ../help.h \
  $(kpathsea_srcdir)/c-pathch.h $(kpathsea_srcdir)/c-ctype.h \
  $(kpathsea_srcdir)/tex-make.h ../texmfmem.h ../mfcoerce.h 
