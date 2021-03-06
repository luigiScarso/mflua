/*  version.c: version number for libkpathsea.

    Copyright 1993, 1996, 2008 Karl Berry.
    Copyright 1997, 1999, 2005 Olaf Weber.
  
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public License
   along with this library; if not, see <http://www.gnu.org/licenses/>.  */

#include "c-auto.h"
#include <kpathsea/c-proto.h>

KPSEDLL char *kpathsea_version_string = (char *) KPSEVERSION;

/* If you are redistributing a modified version of my original
   distribution, please change this address.

   Also change the address in makempx.in, mpto.c, and newer.c in
   web2c/mpware/, and in dvilj/dvihp.

   Thanks.  --kb@cs.umb.edu  */

KPSEDLL char *kpse_bug_address = (char *) 
  "Email bug reports to tex-k@mail.tug.org.\n";
