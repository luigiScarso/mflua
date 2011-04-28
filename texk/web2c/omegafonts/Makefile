# omegafonts/Makefile.aux. Generated from Makefile.in by configure.
# omegafonts/Makefile.  Generated from Makefile.aux by configure.
# Makefile for omegafonts.

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
# paths.mk -- installation directories.
# $Id: paths.mk 10296 2008-08-12 23:46:59Z karl $

# Do not change prefix and exec_prefix in Makefile.in!
# configure doesn't propagate the change to the other Makefiles.
# Instead, give the -prefix/-exec-prefix options to configure.
# (See kpathsea/INSTALL for more details.) This is arguably
# a bug, but it's not likely to change soon.
prefix = /usr/local
exec_prefix = ${prefix}

# Architecture-dependent executables.
bindir = ${exec_prefix}/bin

# Architecture-independent executables.
scriptdir = $(bindir)

# Architecture-dependent files, such as lib*.a files.
libdir = ${exec_prefix}/lib

# Architecture-independent files.
datarootdir = ${prefix}/share
datadir = ${datarootdir}

# Header files.
includedir = ${prefix}/include

# GNU .info* files.
infodir = ${datarootdir}/info

# Unix man pages.
manext = 1
mandir = ${datarootdir}/man
man1dir = $(mandir)/man$(manext)
man5dir = $(mandir)/man5

# modifiable single-machine data.
localstatedir = ${prefix}/var

# read-only single-machine data (configuration).
sysconfdir = ${prefix}/etc

# executables that other programs run.
libexecdir = ${exec_prefix}/libexec


# TeX system-specific directories. Not all of the following are relevant
# for all programs, but it seems cleaner to collect everything in one place.

# The default paths are in kpathsea/texmf.cnf. Passing all the paths to
# sub-makes can make the arg list too long.  If you make
# changes below, you will have to make the corresponding changes to
# texmf.cnf yourself.

# The root of the main tree.
texmf = ${prefix}/share/texmf

# The directory used by varfonts.
vartexfonts = /var/tmp/texfonts

# Regular input files.
texinputdir = $(texmf)/tex
mfinputdir = $(texmf)/metafont
mpinputdir = $(texmf)/metapost
mftinputdir = $(texmf)/mft

# dvips's epsf.tex, rotate.tex, etc. get installed here;
# ditto for dvilj's fonts support.
dvips_plain_macrodir = $(texinputdir)/plain/dvips
dvilj_latex2e_macrodir = $(texinputdir)/latex/dvilj

# mktex.cnf, texmf.cnf, etc.
web2cdir = $(texmf)/web2c

# The top-level font directory.
fontdir = $(texmf)/fonts

# Memory dumps (.fmt/.base/.mem).
fmtdir = $(web2cdir)/tex
basedir = $(web2cdir)/metafont
memdir = $(web2cdir)/metapost

# Pool files.
texpooldir = $(web2cdir)
mfpooldir = $(texpooldir)
mppooldir = $(texpooldir)

# Where the .map files from fontname are installed.
fontnamedir = $(texmf)/fontname

# For dvips configuration files, psfonts.map, etc.
dvipsdir = $(texmf)/dvips

# For dvips .pro files, gsftopk's render.ps, etc.
psheaderdir = $(dvipsdir)

# If a font can't be found close enough to its stated size, we look for
# each of these sizes in the order given.  This colon-separated list is
# overridden by the envvar TEXSIZES, and by a program-specific variable
# (e.g., XDVISIZES), and perhaps by a config file (e.g., in dvips).
# This list must be sorted in ascending order.
default_texsizes = 600

# End of paths.mk.
# web2c/kpathsea.mk -- In subdirectories of web2c, the build directory
# for kpathsea is one more level up.  c_auto_h_dir is used by make depend.
kpathsea_parent = ../..
c_auto_h_dir = ..

prog_cflags = -I.. -I$(srcdir)/..
# End of web2c/kpathsea.mk.

LEX = flex -l
#LEXLIB = -lfl
LEX_OUTPUT_ROOT = lex.yy
YACC = bison -y

proglib = ../lib/lib.a
programs = omfonts
linked_programs = ofm2opl opl2ofm ovf2ovp ovp2ovf
scripts = 

omfonts_objects = omfonts.o y_tab.o $(LEX_OUTPUT_ROOT).o \
                  char_routines.o dimen_routines.o error_routines.o \
                  header_routines.o ligkern_routines.o list_routines.o \
                  out_routines.o param_routines.o print_routines.o \
                  font_routines.o extra_routines.o out_ofm.o \
                  parse_ofm.o
h_files = char_routines.h dimen_routines.h error_routines.h \
          font_routines.h header_routines.h ligkern_routines.h \
          list_routines.h out_routines.h param_routines.h print_routines.h \
          extra_routines.h manifests.h parser.h out_ofm.h dvi.h \
          parse_ofm.h omfonts.h

all: $(programs)
$(omfonts_objects): Makefile
omfonts: $(omfonts_objects)
	$(kpathsea_link) $(omfonts_objects) $(LEXLIB) $(LOADLIBES) 

omfonts.o: omfonts.c y_tab.h
y_tab.c y_tab.h: pl.y
	$(YACC) -d -v $(srcdir)/pl.y
	-test -f y.tab.c && mv -f y.tab.c y_tab.c
	-test -f y.tab.h && mv -f y.tab.h y_tab.h
$(LEX_OUTPUT_ROOT).o: parser.h y_tab.h
$(LEX_OUTPUT_ROOT).c: pl.l
	$(LEX) $(srcdir)/pl.l



$(programs): $(proglib) $(kpathsea)

$(omfonts_objects): $(h_files)

install: install-exec 
install-exec:: install-links

install-programs: $(programs)
	$(SHELL) $(top_srcdir)/../mkinstalldirs $(bindir) 
	for p in $(programs); do $(INSTALL_LIBTOOL_PROG) $$p $(bindir); done

install-links: install-programs
	for f in ""$(linked_programs); do \
	cd $(bindir) && (rm -f $$f; $(LN) omfonts $$f); done

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
