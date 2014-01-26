#-*- tab-width: 4; -*-
# ex:ts=4
#
# bsd.gcc.mk - Support for smarter USE_GCC usage.
#
# Created by: Edwin Groothuis <edwin@freebsd.org>
#
# To request the use of a current version of GCC, specify USE_GCC=yes in
# your port/system configuration.  This is the preferred use of USE_GCC.
# It defines a canonical, default version of GCC.  The same version of
# GCC is also implied by USE_FORTRAN=yes.
#
# USE_GCC=any is similar, except that it also accepts the old GCC 4.2-
# based system compiler in older versions of FreeBSD.
# 
# If your port needs a specific (minimum) version of GCC, you can easily
# specify that with a USE_GCC= statement.  Unless absolutely necessary
# do so by specifying USE_GCC=X.Y+ which requests at least GCC version
# X.Y.  To request a specific version omit the trailing + sign.
#
# Use of a Fortran compiler is declared by the USE_FORTRAN knob, not
# USE_GCC.
#
# Examples:
#   USE_GCC=	yes			# port requires a current version of GCC
#							# (4.6 as of today, subject to change).
#   USE_GCC=	any			# port requires GCC 4.2 or later.
#   USE_GCC=	4.8+		# port requires GCC 4.8 or later.
#   USE_GCC=	4.8			# port requires GCC 4.8.
#
# If your port needs a Fortran compiler, please specify that with the
# USE_FORTRAN= knob.  Here is the list of options for that knob:
#
#   USE_FORTRAN=	yes		# use gfortran47 (lang/gcc-aux)
#   USE_FORTRAN=	ifort	# use the Intel compiler (lang/ifc)
#
# Due to object file incompatiblity between Fortran compilers, we strongly
# recommend to use only one of them on any system.
#
# If you are wondering what your port exactly does, use "make test-gcc"
# to see some debugging.
#
# $FreeBSD: Mk/bsd.gcc.mk 341241 2014-01-26 16:33:53Z rene $
#

GCC_Include_MAINTAINER=		gerald@FreeBSD.org

# All GCC versions supported by the ports framework.  Keep them in
# ascending order and in sync with the table below. 
GCCVERSIONS=	040200 040600 040700 040800 040900

# The first field if the OSVERSION in which it appeared in the base.
# The second field is the OSVERSION in which it disappeared from the base.
# The third field is the version as USE_GCC would use.
GCCVERSION_040200=	     0       0 4.2
GCCVERSION_040600=	     0       0 4.6
GCCVERSION_040700=	300400 9999999 4.7
GCCVERSION_040800=	     0       0 4.8
GCCVERSION_040900=	     0       0 4.9

GCC_DEFAULT_VERSION=	4.7
DFLY_DEFAULT_VERSION=	47
GCC_DEFAULT_V=	${GCC_DEFAULT_VERSION:S/.//}

# No configurable parts below this. ####################################
#

.if defined(USE_GCC) && ${USE_GCC} == yes
USE_GCC=	${GCC_DEFAULT_VERSION}
.endif

# Extract the fields from GCCVERSION_...
.for v in ${GCCVERSIONS}
. for j in ${GCCVERSION_${v}}
.  if !defined(_GCCVERSION_${v}_L)
_GCCVERSION_${v}_L=	${j}
.  elif !defined(_GCCVERSION_${v}_R)
_GCCVERSION_${v}_R=	${j}
.  elif !defined(_GCCVERSION_${v}_V)
_GCCVERSION_${v}_V=	${j}
.  endif
. endfor
.endfor

# bsd.gcc.mk can also be used for primarily requesting a Fortran compiler.
# If we are using GCC we still define whatever we'd usually do for C and
# C++ as well.

.if defined (USE_FORTRAN)

# The default case, with a current lang/gcc port.
. if ${USE_FORTRAN} == yes
BUILD_DEPENDS+= ${LOCALBASE}/gcc-aux/bin/gfortran:${PORTSDIR}/lang/gcc-aux
RUN_DEPENDS+=	${LOCALBASE}/gcc-aux/bin/gfortran:${PORTSDIR}/lang/gcc-aux
_USE_GCC:=	${GCC_DEFAULT_VERSION}  # dummy to avoid further depends
_GCC_RUNTIME:=	${LOCALBASE}/gcc-aux/lib
FC:=		${LOCALBASE}/gcc-aux/bin/gfortran
F77:=		${LOCALBASE}/gcc-aux/bin/gfortran
CC:=		${LOCALBASE}/gcc-aux/bin/gcc
CXX:=		${LOCALBASE}/gcc-aux/bin/g++
CPP:=		${LOCALBASE}/gcc-aux/bin/cpp
LDFLAGS+=	-L${LOCALBASE}/gcc-aux/lib -Wl,-rpath,${LOCALBASE}/gcc-aux/lib

# Intel Fortran compiler from lang/ifc.
. elif ${USE_FORTRAN} == ifort
BUILD_DEPENDS+=	${LOCALBASE}/intel_fc_80/bin/ifort:${PORTSDIR}/lang/ifc
RUN_DEPENDS+=	${LOCALBASE}/intel_fc_80/bin/ifort:${PORTSDIR}/lang/ifc
FC:=	${LOCALBASE}/intel_fc_80/bin/ifort
F77:=	${LOCALBASE}/intel_fc_80/bin/ifort

. else
IGNORE=	specifies unknown value "${USE_FORTRAN}" for USE_FORTRAN
. endif

CONFIGURE_ENV+=	F77="${F77}" FC="${FC}" FFLAGS="${FFLAGS}"
MAKE_ENV+=		F77="${F77}" FC="${FC}" FFLAGS="${FFLAGS}"
.endif


.if defined(USE_GCC) && !defined(FORCE_BASE_CC_FOR_TESTING)

. if empty(USE_GCC) || ${USE_GCC} == any || ${USE_GCC:tl} == "yes"

# Enable the clang-is-cc workaround.  Default to the last GCC imported
# into base.
_USE_GCC:=	${GCC_DEFAULT_VERSION}
_GCC_ORLATER:=	false

. else # ${USE_GCC} == any

# See if we can use a later version or exclusively the one specified.
_USE_GCC:=	${USE_GCC:S/+//}
.if ${USE_GCC} != ${_USE_GCC}
_GCC_ORLATER:=	true
.endif

. endif # ${USE_GCC} == any

# Initialize _GCC_FOUND${v}.  In parallel, check if USE_GCC points to a
# valid version to begin with.
# Set USE_GCC=3.4(4.2, 4.4, 4.6) all to base compiler (4.7)
.for v in ${GCCVERSIONS}
. if ${DFLYVERSION} >= ${_GCCVERSION_${v}_L} \
  && ${DFLYVERSION} <  ${_GCCVERSION_${v}_R} \
  && ${DFLY_DEFAULT_VERSION} <= ${_GCCVERSION_${v}_V:S/.//}
_GCC_FOUND${v}=	base
. elif exists(${LOCALBASE}/bin/gcc${_GCCVERSION_${v}_V:S/.//})
_GCC_FOUND${v}=	port
. endif
. if ${_USE_GCC}==${_GCCVERSION_${v}_V}
_GCCVERSION_OKAY=	true
. endif
.endfor

.if !defined(_GCCVERSION_OKAY)
IGNORE=	Unknown version of GCC specified (USE_GCC=${USE_GCC})
.endif

# If the GCC package defined in USE_GCC does not exist, but a later
# version is allowed (for example 4.7+), see if there is a later.
# First check if the base installed version is good enough, otherwise
# get the first available version.
#
.if defined(_GCC_ORLATER)
. for v in ${GCCVERSIONS}
.  if ${_USE_GCC} == ${_GCCVERSION_${v}_V}
_GCC_MIN1:=	true
.  endif
.  if defined(_GCC_MIN1) && defined(_GCC_FOUND${v}) && ${_GCC_FOUND${v}}=="base" && !defined(_GCC_FOUND)
_GCC_FOUND:=	${_GCCVERSION_${v}_V}
.  endif
. endfor
. for v in ${GCCVERSIONS}
.  if ${_USE_GCC} == ${_GCCVERSION_${v}_V}
_GCC_MIN2:=	true
.  endif
.  if defined(_GCC_MIN2) && defined(_GCC_FOUND${v}) && !defined(_GCC_FOUND)
_GCC_FOUND:=	${_GCCVERSION_${v}_V}
.  endif
. endfor

. if defined(_GCC_FOUND)
_USE_GCC:=	${_GCC_FOUND}
. elif ${_USE_GCC} < ${GCC_DEFAULT_VERSION}
_USE_GCC:=	${GCC_DEFAULT_VERSION}
. endif
.endif # defined(_GCC_ORLATER)

.endif # defined(USE_GCC)


.if defined(_USE_GCC)
# A concrete version has been selected.  Determine if the installed OS 
# features this version in the base, and if not then set proper ports
# dependencies, CC, CXX, CPP, and flags.
.for v in ${GCCVERSIONS}
. if ${_USE_GCC} == ${_GCCVERSION_${v}_V}
.  if ${DFLYVERSION} < ${_GCCVERSION_${v}_L} || ${DFLYVERSION} > ${_GCCVERSION_${v}_R}
V:=			${_GCCVERSION_${v}_V:S/.//}
_GCC_PORT_DEPENDS:=	gcc${V}
.   if ${_USE_GCC} == ${GCC_DEFAULT_VERSION}
_GCC_PORT:=		gcc
.   else
_GCC_PORT:=		gcc${V}
.   endif
CC:=			gcc${V}
CXX:=			g++${V}
CPP:=			cpp${V}
_GCC_RUNTIME:=		${LOCALBASE}/lib/gcc${V}
CFLAGS+=		-Wl,-rpath=${_GCC_RUNTIME}
CXXFLAGS+=		-Wl,-rpath=${_GCC_RUNTIME}
LDFLAGS+=		-Wl,-rpath=${_GCC_RUNTIME} -L${_GCC_RUNTIME}
.    if defined (USE_FORTRAN)
.    if ${USE_FORTRAN} == yes
FFLAGS+=		-Wl,-rpath=${_GCC_RUNTIME}
.    endif
.    endif
# The following is for the sakes of some ports which use this without
# ever telling us; to be fixed.
_GCC_BUILD_DEPENDS:=	${_GCC_PORT_DEPENDS}
.  else # Use GCC in base.
CC:=			gcc
CXX:=			g++
CPP:=			cpp
CONFIGURE_ENV+=		CCVER=gcc${DFLY_DEFAULT_VERSION}
MAKE_ENV+=		CCVER=gcc${DFLY_DEFAULT_VERSION}
.  endif # Use GCC in base.
. endif # ${_USE_GCC} == ${_GCCVERSION_${v}_V}
.endfor
.undef V

.if defined(_GCC_PORT_DEPENDS)
BUILD_DEPENDS+=	${_GCC_PORT_DEPENDS}:${PORTSDIR}/lang/${_GCC_PORT}
RUN_DEPENDS+=	${_GCC_PORT_DEPENDS}:${PORTSDIR}/lang/${_GCC_PORT}
.  if ${_USE_GCC:S/.//} > ${GCC_DEFAULT_VERSION}
# Later GCC ports already depend on binutils; make sure whatever we
# build leverages this as well.
USE_BINUTILS=	yes
.  endif
.endif
.endif # defined(_USE_GCC) && !defined(FORCE_BASE_CC_FOR_TESTING)


test-gcc:
	@echo USE_GCC=${USE_GCC}
	@echo USE_FORTRAN=${USE_FORTRAN}
.if defined(IGNORE)
	@echo "IGNORE: ${IGNORE}"
.else
.if defined(USE_GCC)
.if defined(_GCC_ORLATER)
	@echo Port can use later versions.
.else
	@echo Port cannot use later versions.
.endif
.for v in ${GCCVERSIONS}
	@echo -n "GCC version: ${_GCCVERSION_${v}_V} "
.if defined(_GCC_FOUND${v})
	@echo -n "(${_GCC_FOUND${v}}) "
.endif
	@echo "- OSVERSION from ${_GCCVERSION_${v}_L} to ${_GCCVERSION_${v}_R}"
#	@echo ${v} - ${_GCC_FOUND${v}} - ${_GCCVERSION_${v}_L} to ${_GCCVERSION_${v}_R} - ${_GCCVERSION_${v}_V}
.endfor
	@echo Using GCC version ${_USE_GCC}
.endif
	@echo CC=${CC} - CXX=${CXX} - CPP=${CPP} - CFLAGS=\"${CFLAGS}\"
	@echo F77=${F77} - FC=${FC} - FFLAGS=\"${FFLAGS}\"
	@echo LDFLAGS=\"${LDFLAGS}\"
	@echo CONFIGURE_ENV=${CONFIGURE_ENV}
	@echo MAKE_ENV=${MAKE_ENV}
	@echo "BUILD_DEPENDS=${BUILD_DEPENDS}"
	@echo "RUN_DEPENDS=${RUN_DEPENDS}"
.endif
