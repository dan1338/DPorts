# Created by: Bruce M Simpson <bms@FreeBSD.org>

PORTNAME=	libpcap
PORTVERSION=	1.10.0
CATEGORIES=	net
MASTER_SITES=	http://www.tcpdump.org/release/

MAINTAINER=	garga@FreeBSD.org
COMMENT=	Ubiquitous network traffic capture library

LICENSE=	BSD3CLAUSE

BUILD_DEPENDS=	${LOCALBASE}/bin/flex:textproc/flex

USES=		bison gmake

GNU_CONFIGURE=	yes
USE_LDCONFIG=	yes
CONFIGURE_ARGS+=--enable-dbus=no \
		--with-pcap=bpf
CONFIGURE_ENV+=	LEX=${LOCALBASE}/bin/flex
CFLAGS_x86_64=	-fPIC
CFLAGS_sparc64=	-fPIC
PLIST_SUB+=	PORTVERSION=${PORTVERSION}

OPTIONS_DEFINE=	IPV6

IPV6_CONFIGURE_ENABLE=	ipv6

.include <bsd.port.mk>
