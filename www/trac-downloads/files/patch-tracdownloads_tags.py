
$FreeBSD: ports/www/trac-downloads/files/no-sets-module.diff,v 1.1 2011/01/12 00:47:17 brooks Exp $

--- tracdownloads/tags.py.orig
+++ tracdownloads/tags.py
@@ -1,11 +1,5 @@
 # -*- coding: utf-8 -*-
 
-# Deprecated as for Python 2.6.
-try:
-    import sets
-except:
-    pass
-
 # Trac imports.
 from trac.core import *
 from trac.resource import Resource
