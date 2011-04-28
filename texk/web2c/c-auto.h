/* c-auto.h.  Generated from c-auto.in by configure.  */
/* c-auto.in.  Generated from configure.in by autoheader.  */

/* c-auto.h: defines for web2c, as determined by configure.

   Copyright 1994-97, 2008 Karl Berry.
   Copyright 1997-99, 2002, 2005 Olaf Weber.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* Guard against double inclusion. */
#ifndef WEB2C_C_AUTO_H
#define WEB2C_C_AUTO_H

/* web2c: the version string. */
#define WEB2CVERSION " (Web2C 7.5.7)"

/* web2c: Define if gcc asm needs _ on external symbols. */
/* #undef ASM_NEEDS_UNDERSCORE */

/* web2c: Default editor for interactive `e' option. */
#define EDITOR "vi +%d %s"

/* metafont: Define to include EPSF pseudo-window support */
/* #undef EPSFWIN */

/* web2c: Define to enable HackyInputFileNameForCoreDump.tex. */
/* #undef FUNNY_CORE_DUMP */

/* Define if you have Carbon */
/* #undef HAVE_CARBON */

/* Define to 1 if you have the `fmax' function. */
/* #undef HAVE_FMAX */

/* Define to 1 if you have the <ft2build.h> header file. */
/* #undef HAVE_FT2BUILD_H */

/* Define to 1 if you have the `ftime' function. */
#define HAVE_FTIME 1

/* Define to 1 if you have the `gettimeofday' function. */
#define HAVE_GETTIMEOFDAY 1

/* Define to 1 if you have the <inttypes.h> header file. */
#define HAVE_INTTYPES_H 1

/* Define if you have libfontconfig */
#define HAVE_LIBFONTCONFIG 1

/* Define to 1 if you have the `freetype' library (-lfreetype). */
/* #undef HAVE_LIBFREETYPE */

/* Define to 1 if you have the `icuuc' library (-licuuc). */
/* #undef HAVE_LIBICUUC */

/* Define to 1 if you have the `m' library (-lm). */
#define HAVE_LIBM 1

/* Define to 1 if you have the `posix' library (-lposix). */
/* #undef HAVE_LIBPOSIX */

/* Define to 1 if you have the `z' library (-lz). */
/* #undef HAVE_LIBZ */

/* Define to 1 if you have the <locale.h> header file. */
#define HAVE_LOCALE_H 1

/* Define to 1 if you have the <memory.h> header file. */
#define HAVE_MEMORY_H 1

/* Define to 1 if you have the `mkstemp' function. */
#define HAVE_MKSTEMP 1

/* Define to 1 if you have the `mktemp' function. */
#define HAVE_MKTEMP 1

/* Define if you have POSIX threads libraries and header files. */
#define HAVE_PTHREAD 1

/* Define to 1 if you have the `setlocale' function. */
#define HAVE_SETLOCALE 1

/* Define to 1 if you have the <stdint.h> header file. */
#define HAVE_STDINT_H 1

/* Define to 1 if you have the <stdlib.h> header file. */
#define HAVE_STDLIB_H 1

/* Define to 1 if you have the `strerror' function. */
#define HAVE_STRERROR 1

/* Define to 1 if you have the <strings.h> header file. */
#define HAVE_STRINGS_H 1

/* Define to 1 if you have the <string.h> header file. */
#define HAVE_STRING_H 1

/* Define to 1 if you have the `strlcat' function. */
/* #undef HAVE_STRLCAT */

/* Define to 1 if you have the `strlcpy' function. */
/* #undef HAVE_STRLCPY */

/* Define to 1 if you have the <sys/stat.h> header file. */
#define HAVE_SYS_STAT_H 1

/* Define to 1 if you have the <sys/timeb.h> header file. */
#define HAVE_SYS_TIMEB_H 1

/* Define to 1 if you have the <sys/time.h> header file. */
#define HAVE_SYS_TIME_H 1

/* Define to 1 if you have the <sys/types.h> header file. */
#define HAVE_SYS_TYPES_H 1

/* Define to 1 if you have the <ubidi.h> header file. */
/* #undef HAVE_UBIDI_H */

/* Define to 1 if you have the <unistd.h> header file. */
#define HAVE_UNISTD_H 1

/* Define to 1 if you have the <zlib.h> header file. */
/* #undef HAVE_ZLIB_H */

/* metafont: Define to include HP 2627 window support */
/* #undef HP2627WIN */

/* tex: Define to enable --ipc. */
/* #undef IPC */

/* metafont: Define to include mftalk (generic server) window support */
/* #undef MFTALKWIN */

/* metafont: Define to include NeXT window support */
/* #undef NEXTWIN */

/* web2c: Define to disable architecture-independent dump files. Faster on
   LittleEndian architectures. */
/* #undef NO_DUMP_SHARE */

/* Define to the address where bug reports for this package should be sent. */
#define WEB2C_PACKAGE_BUGREPORT ""

/* Define to the full name of this package. */
#define WEB2C_PACKAGE_NAME ""

/* Define to the full name and version of this package. */
#define WEB2C_PACKAGE_STRING ""

/* Define to the one symbol short name of this package. */
#define WEB2C_PACKAGE_TARNAME ""

/* Define to the version of this package. */
#define WEB2C_PACKAGE_VERSION ""

/* Define to necessary symbol if this constant uses a non-standard name on
   your system. */
/* #undef PTHREAD_CREATE_JOINABLE */

/* metafont: Define to include Regis window support */
/* #undef REGISWIN */

/* Define as the return type of signal handlers (`int' or `void'). */
#define RETSIGTYPE void

/* The size of `long', as computed by sizeof. */
#define SIZEOF_LONG 4

/* Define to 1 if you have the ANSI C header files. */
#define STDC_HEADERS 1

/* metafont: Define to include old Suntools window support (this is not X) */
/* #undef SUNWIN */

/* metafont: Define to include Tektronix window support */
/* #undef TEKTRONIXWIN */

/* metafont: Define to include Uniterm window support */
/* #undef UNITERMWIN */

/* Define WORDS_BIGENDIAN to 1 if your processor stores words with the most
   significant byte first (like Motorola and SPARC, unlike Intel and VAX). */
#if defined __BIG_ENDIAN__
# define WORDS_BIGENDIAN 1
#elif ! defined __LITTLE_ENDIAN__
/* # undef WORDS_BIGENDIAN */
#endif

/* Define to include X11 window in Metafont. */
/* #undef X11WIN */

/* Define to 1 if the X Window System is missing or not being used. */
#define X_DISPLAY_MISSING 1

/* Define to 1 if `lex' declares `yytext' as a `char *' by default, not a
   `char[]'. */
#define YYTEXT_POINTER 1

/* Define to 1 if type `char' is unsigned and you are not using gcc.  */
#ifndef __CHAR_UNSIGNED__
/* # undef __CHAR_UNSIGNED__ */
#endif

/* Define to `__inline__' or `__inline' if that's what the C compiler
   calls it, or to nothing if 'inline' is not supported under any name.  */
#ifndef __cplusplus
/* #undef inline */
#endif

#endif /* !WEB2C_C_AUTO_H */
