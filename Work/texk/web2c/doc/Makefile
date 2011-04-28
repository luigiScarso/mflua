# doc/Makefile.aux. Generated from Makefile.in by configure.
# doc/Makefile.  Generated from Makefile.aux by configure.
# Makefile for Web2c documentation.

# paths.mk -- installation directories.
# $Id: paths.mk 10296 2008-08-12 23:46:59Z karl $

# Do not change prefix and exec_prefix in Makefile.in!
# configure doesn't propagate the change to the other Makefiles.
# Instead, give the -prefix/-exec-prefix options to configure.
# (See kpathsea/INSTALL for more details.) This is arguably
# a bug, but it's not likely to change soon.
prefix = /opt/luatex/metafont-2.718281/inst
exec_prefix = ${prefix}

# Architecture-dependent executables.
bindir = ${exec_prefix}/bin/i686-pc-linux-gnu

# Architecture-independent executables.
scriptdir = $(bindir)

# Architecture-dependent files, such as lib*.a files.
libdir = ${exec_prefix}/lib/i686-pc-linux-gnu

# Architecture-independent files.
datarootdir = ${prefix}/share
datadir = /opt/luatex/metafont-2.718281/inst

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
texmf = /opt/luatex/metafont-2.718281/inst/texmf

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
# common.mk -- used by all Makefiles.
SHELL = /bin/sh

top_srcdir = ../../../../texk/web2c
srcdir = ../../../../texk/web2c/doc
VPATH = ../../../../texk/web2c/doc

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
# web2c/kpathsea.mk -- In subdirectories of web2c, the build directory
# for kpathsea is one more level up.  c_auto_h_dir is used by make depend.
kpathsea_parent = ../..
c_auto_h_dir = ..

prog_cflags = -I.. -I$(srcdir)/..
# End of web2c/kpathsea.mk.
# texi.mk -- making .dvi and .info from .texi.
#M#MAKEINFO = makeinfo
#M#MAKEINFO_FLAGS = --paragraph-indent=2 -I$(srcdir)

#M#TEXI2DVI = texi2dvi
#M## To make sure that generation of the dvi files succeeds on the
#M## maintainer's system.
#M#TEXI2DVI = TEXMFCNF=$(web2cdir) texi2dvi

#M#TEXI2HTML = texi2html
#M#TEXI2HTML_FLAGS = -expandinfo -number -menu -split_chapter
# If you prefer one big .html file instead of several, remove
# -split-node or replace it by -split_chapter.

# For making normal text files out of Texinfo source.
#M#one_info = --no-headers --no-split --no-validate

#M#.SUFFIXES: .info .dvi .html .texi
#M#.texi.info:
#M#	$(MAKEINFO) $(MAKEINFO_FLAGS) $< -o $@
#M#.texi.dvi:
#M#	$(TEXI2DVI) $(TEXI2DVI_FLAGS) $<
#M#.texi.html:
#M#	$(TEXI2HTML) $(TEXI2HTML_FLAGS) $< 
# End of texi.mk.

info: web2c.info
dvi: web2c.dvi

web2c.info: install.texi ref.txi
all: web2c.info web2c.dvi

#M#INSTALL: install.texi
#M#	$(MAKEINFO) $(one_info) $(MAKEINFO_FLAGS) $< -o $@
#M#	$(SHELL) $(top_srcdir)/../add-info-toc $@
#M#doc: info INSTALL
#M#
#M#ref.txi: ref.bbl
#M#	sed -e 's/~/ /g' \
#M#	    -e 's/\\[-`'\''"c^]//g' \
#M#	    -e 's/\\emdash */---/g' \
#M#	    -e 's/metapost/MetaPost/g' \
#M#	    -e 's/\\MF/Metafont/g' \
#M#	    -e 's/\\METAFONT/METAFONT/g' \
#M#	    -e 's/\\TUB/TUGboat/g' \
#M#	    -e 's/\\LaTeX/La@TeX/g' \
#M#	    -e 's/\\AMSTEX/AMS@TeX/g' \
#M#	    -e 's/\\AmSTeX/AMS@TeX/g' \
#M#	    -e 's/\\TeX/@TeX/g' \
#M#	    -e 's/\\noopsort{[^}]*}//g' \
#M#	    -e 's/[{}\]//g' \
#M#	    -e 's/@\[/{/g' \
#M#	    -e 's/@\]/}/g' \
#M#	    -e 's/@TeX/@TeX{}/g' \
#M#	$< >$@
#M#
#M#ref.bbl: ref.aux texinfo.bst
#M#	-bibtex ref
#M#
#M#ref.aux: ref.tex
#M#	rm -f ref.bbl
#M#	tex '\nonstopmode \input ref'

Makefile: Makefile.in ../config.status
	cd .. && $(SHELL) config.status

install: install-exec install-data
install-exec:
install-data: web2c.info
	$(SHELL) $(top_srcdir)/../mkinstalldirs $(infodir)
	$(INSTALL_DATA) $(srcdir)/web2c.i* $(infodir)/
#
	$(POST_INSTALL)
	if $(SHELL) -c 'install-info --version' >/dev/null 2>&1; then \
	  install-info --info-dir=$(infodir) $(infodir)/web2c.info; \
	else true; fi

check: all

#html: texi2html -expandinfo -number -menu -split_chapter

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
