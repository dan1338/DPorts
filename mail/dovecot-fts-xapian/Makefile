
PORTNAME=	fts-xapian
DISTVERSION=	1.4.9
DISTVERSIONSUFFIX=	b
CATEGORIES=	mail
PKGNAMEPREFIX=	dovecot-

MAINTAINER=	otis@FreeBSD.org
COMMENT=	Dovecot FTS plugin based on Xapian

LICENSE=	LGPL21

BUILD_DEPENDS=	dovecot>=2.3.7:mail/dovecot
LIB_DEPENDS=	libicuuc.so:devel/icu \
		libxapian.so:databases/xapian-core
RUN_DEPENDS=	dovecot>=2.3.7:mail/dovecot

USES=		autoreconf compiler:c++11-lang libtool pkgconfig

USE_GITHUB=	yes
GH_ACCOUNT=	grosjo
USE_LDCONFIG=	yes

GNU_CONFIGURE=	yes

PLIST_FILES=	lib/dovecot/lib21_fts_xapian_plugin.a \
		lib/dovecot/lib21_fts_xapian_plugin.so

post-install:
	${STRIP_CMD} ${STAGEDIR}${PREFIX}/lib/dovecot/lib21_fts_xapian_plugin.so

.include <bsd.port.mk>
