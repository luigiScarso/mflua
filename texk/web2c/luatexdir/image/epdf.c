/*
Copyright (c) 1996-2002 Han The Thanh, <thanh@pdftex.org>

This file is part of pdfTeX.

pdfTeX is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

pdfTeX is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with pdfTeX; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

$Id: epdf.c 1012 2008-02-14 00:00:57Z oneiros $
*/

#include "ptexlib.h"


#include <kpathsea/c-vararg.h>
#include <kpathsea/c-proto.h>
#include <string.h>

extern void epdf_check_mem(void);
extern void register_fd_entry(fd_entry *);


int is_subsetable(fm_entry * fm)
{
    assert(is_included(fm));
    return is_subsetted(fm);
}

fd_entry *epdf_create_fontdescriptor(fm_entry * fm)
{
    fd_entry *fd;
    if ((fd = lookup_fd_entry(fm->ff_name, fm->slant, fm->extend)) == NULL) {
        fm->in_use = true;
        fd = new_fd_entry();
        fd->fm = fm;
        register_fd_entry(fd);
        fd->fd_objnum = pdf_new_objnum();
        assert(fm->ps_name != NULL);
        fd->fontname = xstrdup(fm->ps_name);    /* just fallback */
        /* preset_fontmetrics (fo->fd, f); */
        fd->gl_tree = avl_create(comp_string_entry, NULL, &avl_xallocator);
        assert(fd->gl_tree != NULL);
    }
    return fd;
}

integer get_fd_objnum(fd_entry * fd)
{
    assert(fd->fd_objnum != 0);
    return fd->fd_objnum;
}

integer get_fn_objnum(fd_entry * fd)
{
    if (fd->fn_objnum == 0)
        fd->fn_objnum = pdf_new_objnum();
    return fd->fn_objnum;
}

/***********************************************************************
 * Mark glyphs used by embedded PDF file:
 * 1. build fontdescriptor, if not yet existing
 * 2. mark glyphs directly there
 *
 * Input charset from xpdf is a string of glyph names including
 * leading slashes, but without blanks between them, like: /a/b/c
***********************************************************************/

void epdf_mark_glyphs(fd_entry * fd, char *charset)
{
    char *p, *q, *s;
    char *glyph;
    void **aa;
    if (charset == NULL)
        return;
    assert(fd != NULL);
    for (s = charset + 1, q = charset + strlen(charset); s < q; s = p + 1) {
        for (p = s; *p != '\0' && *p != '/'; p++);
        *p = '\0';
        if ((char *) avl_find(fd->gl_tree, s) == NULL) {
            glyph = xstrdup(s);
            aa = avl_probe(fd->gl_tree, glyph);
            assert(aa != NULL);
        }
    }
}

void embed_whole_font(fd_entry * fd)
{
    fd->all_glyphs = true;
}

void epdf_free(void)
{
    epdf_check_mem();
}
