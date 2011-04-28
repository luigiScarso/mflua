# mpdir/Makefile.aux. Generated from Makefile.in by configure.
# mpdir/Makefile.  Generated from Makefile.aux by configure.
# Makefile for libmpost - taco@elvenkind.com, but
# mostly ripped off from Makefile.in from pdftex
# $Id $

# common.mk -- used by all Makefiles.
SHELL = /bin/sh

top_srcdir = ../../../../texk/web2c
srcdir = ../../../../texk/web2c/mpdir
VPATH = ../../../../texk/web2c/mpdir

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

ALL_CXXFLAGS = -g -O2 -DHAVE_CONFIG_H $(XXCFLAGS) -I. -I$(srcdir) -I$(kpathsea_dir_parent) -I$(kpathsea_srcdir_parent) 
CXX = g++

XCPPFLAGS=-I.. -I$(srcdir)/.. -I../.. -I$(srcdir)/../..

OBJS = mapfile.o avl.o avlstuff.o utils.o writeenc.o writet1.o writefont.o turningnumber.o

all: libmpost.a makecpool

libmpost.a: $(OBJS)
	rm -f $@
	$(AR) $(ARFLAGS) $@  $(OBJS)
	$(RANLIB) $@

makecpool: makecpool.o
	$(link_command) makecpool.o

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
	rm -f libmpost.a makecpool

depend:
	rm -f $(OBJS)
	XXCFLAGS=-MM XCFLAGS=-MM $(MAKE) -k $(OBJS) | \
	    grep -v "^$(CC)\|$(CXX)\|$(AR)\|make" | \
	    sed 's: [^ ]*/\.\./libs/[^ ]*::g' > $(srcdir)/depend.mk

