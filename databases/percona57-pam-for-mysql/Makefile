# Created by: Mark Felder <feld@FreeBSD.org>

PORTNAME=	percona57
PORTREVISION?=	0
PKGNAMESUFFIX=	-pam-for-mysql

COMMENT=	PAM plugin for MySQL

LICENSE=	GPLv2+

RUN_DEPENDS=# This plugin has no run dependencies. It should work with any desired mysql client/server.

MASTERDIR=	${.CURDIR}/../percona57-server

PKGMESSAGE=	${.CURDIR}/pkg-message
PATCHDIR=	${MASTERDIR}/files
FILESDIR=	${.CURDIR}/files
DFLY_PATCHDIR=	${.CURDIR}/dragonfly
PLIST=		${.CURDIR}/pkg-plist
DESCR=		${.CURDIR}/pkg-descr

CONFLICTS_INSTALL=	percona5[0-68-9]-pam-for-mysql* \
			percona-pam-for-mysql*

CMAKE_ARGS+=	-DWITH_PAM=1

PLUGIN_ONLY=	yes

do-install:
	(cd ${WRKSRC}/plugin/percona-pam-for-mysql && ${MAKE} ${MAKE_ARGS} install)
	${INSTALL_DATA} ${FILESDIR}/pam.conf ${STAGEDIR}${PREFIX}/etc/pam.d/mysqld.sample

.include "${MASTERDIR}/Makefile"
