# web2c/Makefile.aux. Generated from Makefile.in by configure.
# web2c/Makefile.  Generated from Makefile.aux by configure.
# Makefile for TeX-project WEB sources to C conversion programs.

# This makefile uses static rules with many targets (to be compatible to
# non-gnu make) and will not work correctly when parallelized.
# So we switch off parallel makes with gnu make.
.NOTPARALLEL:

# These get expanded from the parent directory, not this one.
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
# cross.mk -- used by Makefiles for build-host executables.

BUILDCC = $(CC)
BUILDCFLAGS = $(CFLAGS)
BUILDCPPFLAGS = $(CPPFLAGS)

ALL_BUILDCPPFLAGS = $(DEFS) -I. -I$(srcdir) -I$(kpathsea_parent) \
  -I$(kpathsea_srcdir_parent) $(prog_cflags) $(BUILDCPPFLAGS)
ALL_BUILDCFLAGS = $(ALL_BUILDCPPFLAGS) $(BUILDCFLAGS)
build_compile = $(BUILDCC) $(ALL_BUILDCFLAGS)

# Don't include $(BUILDCFLAGS), since ld -g under Linux forces
# static libraries, e.g., libc.a and libX*.a.
BUILDLDFLAGS = $(LDFLAGS)

# May as well separate linking from compiling, just in case.
BUILDCCLD = $(CCLD)
build_link_command = $(BUILDCCLD) -o $@ $(BUILDLDFLAGS) 

# End of cross.mk.
# web2c/kpathsea.mk -- In subdirectories of web2c, the build directory
# for kpathsea is one more level up.  c_auto_h_dir is used by make depend.
kpathsea_parent = ../..
c_auto_h_dir = ..

prog_cflags = -I.. -I$(srcdir)/..
# End of web2c/kpathsea.mk.

LEX = flex -l
LEXLIB = -lfl
LEX_OUTPUT_ROOT = lex.yy
YACC = bison -y

programs = web2c fixwrites splitup makecpool

web2c_objects = kps.o main.o y_tab.o $(LEX_OUTPUT_ROOT).o
all: $(programs)
web2c: $(web2c_objects)
	$(build_link_command) $(web2c_objects) $(LEXLIB)

# We use y_tab.* for the sake of MS-DOS.
main.o: main.c y_tab.h
y_tab.c y_tab.h: web2c.y
	@echo Expect one shift/reduce conflict.
	$(YACC) -d -v $(srcdir)/web2c.y
	-test -f y.tab.c && mv -f y.tab.c y_tab.c
	-test -f y.tab.h && mv -f y.tab.h y_tab.h
$(LEX_OUTPUT_ROOT).o: y_tab.h
$(LEX_OUTPUT_ROOT).c: web2c.l
	$(LEX) $(srcdir)/web2c.l

fixwrites: fixwrites.o kps.o
	$(build_link_command) fixwrites.o kps.o
splitup: splitup.o kps.o
	$(build_link_command) splitup.o kps.o
regfix: regfix.o kps.o
	$(build_link_command) regfix.o kps.o
makecpool: makecpool.o 
	$(build_link_command) makecpool.o

main.o: main.c
	$(build_compile) -c $<
kps.o: kps.c
	$(build_compile) -c $<
y_tab.o: y_tab.c
	$(build_compile) -c $<
$(LEX_OUTPUT_ROOT).o: $(LEX_OUTPUT_ROOT).c
	$(build_compile) -c $<
fixwrites.o: fixwrites.c
	$(build_compile) -c $<
splitup.o: splitup.c
	$(build_compile) -c $<
regfix.o: regfix.c
	$(build_compile) -c $<
makecpool.o: makecpool.c
	$(build_compile) -c $<

Makefile: Makefile.in ../config.status
	cd .. && $(SHELL) config.status

# tkpathsea.mk -- target for remaking kpathsea.
# $Id: tkpathsea.mk 8409 2008-05-29 20:59:08Z karl $
makeargs = $(MFLAGS) CC='$(CC)' CFLAGS='$(CFLAGS)' $(XMAKEARGS)

# This is wrong: the library doesn't depend on kpsewhich.c or
# acconfig.h.  But what to do?
$(kpathsea): $(kpathsea_srcdir)/*.c $(kpathsea_srcdir)/*.h \
	     $(top_srcdir)/../make/paths.mk
	cd $(kpathsea_dir) && $(MAKE) $(makeargs)

$(kpathsea_dir)/paths.h: $(kpathsea_srcdir)/texmf.cnf
	cd $(kpathsea_dir) && $(MAKE) $(makeargs)
# End of tkpathsea.mk.
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
	rm -f y_tab.c y_tab.h y.out* yacc.* $(LEX_OUTPUT_ROOT).c

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
fixwrites.o: fixwrites.c ../config.h $(kpathsea_srcdir)/config.h \
  $(kpathsea_dir)/c-auto.h $(kpathsea_srcdir)/c-std.h \
  $(kpathsea_srcdir)/c-unistd.h $(kpathsea_srcdir)/systypes.h \
  $(kpathsea_srcdir)/c-memstr.h \
  $(kpathsea_srcdir)/c-errno.h \
  $(kpathsea_srcdir)/c-minmax.h $(kpathsea_srcdir)/c-limits.h \
  $(kpathsea_srcdir)/c-proto.h $(kpathsea_srcdir)/debug.h \
  $(kpathsea_srcdir)/types.h $(kpathsea_srcdir)/lib.h $(kpathsea_srcdir)/progname.h \
  ../../web2c/c-auto.h $(kpathsea_srcdir)/c-vararg.h $(kpathsea_srcdir)/c-fopen.h \
  $(kpathsea_srcdir)/c-pathmx.h
kps.o: kps.c web2c.h ../config.h $(kpathsea_srcdir)/config.h \
  $(kpathsea_dir)/c-auto.h $(kpathsea_srcdir)/c-std.h \
  $(kpathsea_srcdir)/c-unistd.h $(kpathsea_srcdir)/systypes.h \
  $(kpathsea_srcdir)/c-memstr.h \
  $(kpathsea_srcdir)/c-errno.h \
  $(kpathsea_srcdir)/c-minmax.h $(kpathsea_srcdir)/c-limits.h \
  $(kpathsea_srcdir)/c-proto.h $(kpathsea_srcdir)/debug.h \
  $(kpathsea_srcdir)/types.h $(kpathsea_srcdir)/lib.h $(kpathsea_srcdir)/progname.h \
  ../../web2c/c-auto.h $(kpathsea_srcdir)/c-vararg.h $(kpathsea_srcdir)/c-fopen.h \
  $(kpathsea_srcdir)/c-ctype.h 
$(LEX_OUTPUT_ROOT).o: $(LEX_OUTPUT_ROOT).c \
  web2c.h \
  ../config.h $(kpathsea_srcdir)/config.h $(kpathsea_dir)/c-auto.h \
  $(kpathsea_srcdir)/c-std.h \
  $(kpathsea_srcdir)/c-unistd.h $(kpathsea_srcdir)/systypes.h \
  $(kpathsea_srcdir)/c-memstr.h \
  $(kpathsea_srcdir)/c-errno.h \
  $(kpathsea_srcdir)/c-minmax.h $(kpathsea_srcdir)/c-limits.h \
  $(kpathsea_srcdir)/c-proto.h $(kpathsea_srcdir)/debug.h \
  $(kpathsea_srcdir)/types.h $(kpathsea_srcdir)/lib.h $(kpathsea_srcdir)/progname.h \
  ../../web2c/c-auto.h $(kpathsea_srcdir)/c-vararg.h $(kpathsea_srcdir)/c-fopen.h \
  y_tab.h
main.o: main.c web2c.h ../config.h $(kpathsea_srcdir)/config.h \
  $(kpathsea_dir)/c-auto.h $(kpathsea_srcdir)/c-std.h \
  $(kpathsea_srcdir)/c-unistd.h $(kpathsea_srcdir)/systypes.h \
  $(kpathsea_srcdir)/c-memstr.h \
  $(kpathsea_srcdir)/c-errno.h \
  $(kpathsea_srcdir)/c-minmax.h $(kpathsea_srcdir)/c-limits.h \
  $(kpathsea_srcdir)/c-proto.h $(kpathsea_srcdir)/debug.h \
  $(kpathsea_srcdir)/types.h $(kpathsea_srcdir)/lib.h $(kpathsea_srcdir)/progname.h \
  ../../web2c/c-auto.h $(kpathsea_srcdir)/c-vararg.h $(kpathsea_srcdir)/c-fopen.h \
  y_tab.h
regfix.o: regfix.c ../config.h $(kpathsea_srcdir)/config.h \
  $(kpathsea_dir)/c-auto.h $(kpathsea_srcdir)/c-std.h \
  $(kpathsea_srcdir)/c-unistd.h $(kpathsea_srcdir)/systypes.h \
  $(kpathsea_srcdir)/c-memstr.h \
  $(kpathsea_srcdir)/c-errno.h \
  $(kpathsea_srcdir)/c-minmax.h $(kpathsea_srcdir)/c-limits.h \
  $(kpathsea_srcdir)/c-proto.h $(kpathsea_srcdir)/debug.h \
  $(kpathsea_srcdir)/types.h $(kpathsea_srcdir)/lib.h $(kpathsea_srcdir)/progname.h \
  ../../web2c/c-auto.h $(kpathsea_srcdir)/c-vararg.h $(kpathsea_srcdir)/c-fopen.h 
splitup.o: splitup.c ../config.h $(kpathsea_srcdir)/config.h \
  $(kpathsea_dir)/c-auto.h $(kpathsea_srcdir)/c-std.h \
  $(kpathsea_srcdir)/c-unistd.h $(kpathsea_srcdir)/systypes.h \
  $(kpathsea_srcdir)/c-memstr.h \
  $(kpathsea_srcdir)/c-errno.h \
  $(kpathsea_srcdir)/c-minmax.h $(kpathsea_srcdir)/c-limits.h \
  $(kpathsea_srcdir)/c-proto.h $(kpathsea_srcdir)/debug.h \
  $(kpathsea_srcdir)/types.h $(kpathsea_srcdir)/lib.h $(kpathsea_srcdir)/progname.h \
  ../../web2c/c-auto.h $(kpathsea_srcdir)/c-vararg.h $(kpathsea_srcdir)/c-fopen.h \
  $(kpathsea_srcdir)/getopt.h
y_tab.o: y_tab.c web2c.h ../config.h $(kpathsea_srcdir)/config.h \
  $(kpathsea_dir)/c-auto.h $(kpathsea_srcdir)/c-std.h \
  $(kpathsea_srcdir)/c-unistd.h $(kpathsea_srcdir)/systypes.h \
  $(kpathsea_srcdir)/c-memstr.h \
  $(kpathsea_srcdir)/c-errno.h \
  $(kpathsea_srcdir)/c-minmax.h $(kpathsea_srcdir)/c-limits.h \
  $(kpathsea_srcdir)/c-proto.h $(kpathsea_srcdir)/debug.h \
  $(kpathsea_srcdir)/types.h $(kpathsea_srcdir)/lib.h $(kpathsea_srcdir)/progname.h \
  ../../web2c/c-auto.h $(kpathsea_srcdir)/c-vararg.h $(kpathsea_srcdir)/c-fopen.h 
