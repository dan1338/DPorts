--- ./hiscore.cpp.orig	2007-06-05 00:13:40.000000000 +0200
+++ ./hiscore.cpp	2013-10-17 23:37:42.000000000 +0200
@@ -19,6 +19,7 @@
 -----------------------------------------------------------------------------*/
 #include "stdio.h"
 #include "hiscore.h"
+#include <cstdlib>
 //-----------------------------------------------------------------------------
 HiScores &hiScores()
 {
