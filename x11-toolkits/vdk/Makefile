# Created by: Yukihiro Nakai <nakai@FreeBSD.org>

PORTNAME=	vdk
PORTVERSION=	2.5.1
PORTREVISION=	6
CATEGORIES=	x11-toolkits
MASTER_SITES=	SF/${PORTNAME}lib/VDK%20for%20both%20Linux%20and%20Windows%20%28this%20is%20the%20new%20version%29/VDKLIB%20%28C%2B%2B%20wrapper%20for%20GTK%2B%29

MAINTAINER=	ports@FreeBSD.org
COMMENT=	C++ wrapper for GTK+ toolkit

LICENSE=	LGPL20
LICENSE_FILE=	${WRKSRC}/COPYING

LIB_DEPENDS=	libgnuregex.so.6:devel/libgnuregex

USES=		gnome libtool pathfix pkgconfig
USE_GNOME=	gtk20
GNU_CONFIGURE=	yes
CONFIGURE_ARGS=	--enable-opt=no --enable-doc-html=no --enable-testvdk=no
USE_LDCONFIG=	yes
INSTALL_TARGET=	install-strip

CPPFLAGS+=	-I${LOCALBASE}/include
LDFLAGS+=	-lpthread -L${LOCALBASE}/lib

post-patch:
	@${REINPLACE_CMD} -e 's|CXXFLAGS="-s"|CXXFLAGS="$$CXXFLAGS"|g ; \
		 s|uname -rmpo|uname -rmp|g' ${WRKSRC}/configure
.for file in vdk-config.in vdk.pc.in
	@${REINPLACE_CMD} -e 's|-lpthread|${LDFLAGS}|g' ${WRKSRC}/${file}
.endfor

.include <bsd.port.mk>
