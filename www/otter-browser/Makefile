
PORTNAME=	otter-browser
DISTVERSIONPREFIX=	v
# Occasionally otter-browser is updated to intermediate commits;
# releases are rather infrequent. To update to an intermediate:
# - Make up a PORTVERSION that resembles the DISTVERSION, add a
#   .tweak number to it, comment-out DISTVERSION
# - Set a GH_TAG to the intermediate commit (below)
# - Add a comment here to indicate that the intermediate is
#   intentional
#
# PORTVERSION=	1.0.01.1
DISTVERSION=	1.0.02
CATEGORIES=	www

MAINTAINER=	kde@FreeBSD.org
COMMENT=	Browser based on Qt 5

LICENSE=	GPLv3
LICENSE_FILE=	${WRKSRC}/COPYING

LIB_DEPENDS=	libhunspell-1.7.so:textproc/hunspell

USES=		cmake compiler:c++11-lib desktop-file-utils qt:5
USE_QT=		concurrent core dbus declarative gui multimedia network printsupport \
		script sql sql-sqlite3 svg widgets xmlpatterns \
		buildtools_build qmake_build

USE_GITHUB=	yes
GH_ACCOUNT=	OtterBrowser
# GH_TAGNAME=	22de58d  # For intermediate versions only

OPTIONS_MULTI=		BACKEND
OPTIONS_MULTI_BACKEND=	QTWEBENGINE QTWEBKIT
OPTIONS_DEFAULT=	QTWEBKIT
OPTIONS_DEFAULT_x86_64=	QTWEBENGINE
OPTIONS_DEFAULT_i386=	QTWEBENGINE

QTWEBENGINE_DESC=	Build QtWebEngine backend
QTWEBKIT_DESC=		Build QtWebKit backend

QTWEBENGINE_USE=	qt=declarative,location,webchannel,webengine
QTWEBENGINE_CMAKE_BOOL=	ENABLE_QTWEBENGINE

QTWEBKIT_USE=		qt=webkit
QTWEBKIT_CMAKE_BOOL=	ENABLE_QTWEBKIT

.include <bsd.port.options.mk>

.if ${PORT_OPTIONS:MQTWEBENGINE}
DEPRECATED=	Uses EOL Python 2.7 via www/qt5-webengine
EXPIRATION_DATE=2021-06-23
.endif

.include <bsd.port.mk>
