# $FreeBSD: Mk/Uses/fmake.mk 323942 2013-07-30 06:32:01Z bapt $
#
# Provide support to use the legacy FreeBSD make
#
# MAINTAINER: portmgr@FreeBSD.org
#
# Feature:		fmake
# Usage:		USES=fmake
#

.if !defined(_INCLUDE_USES_FMAKE_MK)
_INCLUDE_USES_FMAKE_MK=	yes

.if defined(fmake_ARGS)
IGNORE=	Incorrect 'USES+= fmake:${fmake_ARGS}' fmake takes no arguments
.endif

.if defined(.PARSEDIR)
FMAKE=			${LOCALBASE}/bin/fmake
BUILD_DEPENDS+=		${FMAKE}:${PORTSDIR}/devel/fmake
CONFIGURE_ENV+=		MAKE=${FMAKE}
MAKE_CMD?=		${FMAKE}
.endif
.endif
