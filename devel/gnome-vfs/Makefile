# Created by: Ade Lovett <ade@FreeBSD.org>

PORTNAME=	gnome-vfs
PORTVERSION=	2.24.4
PORTREVISION?=	12
CATEGORIES=	devel gnome
MASTER_SITES=	GNOME
DIST_SUBDIR=	gnome2

MAINTAINER=	gnome@FreeBSD.org
COMMENT=	GNOME Virtual File System

LICENSE=	LGPL20 LGPL20+  # dbus-utils.c is LGPL20 only
LICENSE_COMB=	multi
LICENSE_FILE_LGPL20=	${WRKSRC}/COPYING.LIB
LICENSE_FILE_LGPL20+ =	${WRKSRC}/COPYING.LIB

USES=		tar:bzip2

RUN_DEPENDS=	update-mime-database:misc/shared-mime-info
LIB_DEPENDS=	libdbus-glib-1.so:devel/dbus-glib \
		libdbus-1.so:devel/dbus

USES+=		gettext gmake gnome libtool:keepla pathfix pkgconfig ssl
USE_GNOME=	gconf2 gnomemimedata intlhack referencehack
INSTALL_TARGET=	install-strip
USE_LDCONFIG=	yes
GNU_CONFIGURE=	yes
CONFIGURE_ARGS=	--enable-openssl \
		--disable-gnutls \
		--disable-howl \
		--disable-hal \
		ac_cv_header_sys_inotify_h=no
CPPFLAGS+=	-I${LOCALBASE}/include
LDFLAGS+=	-L${LOCALBASE}/lib

PKGINSTALL=	${WRKDIR}/pkg-install
PKGDEINSTALL=	${WRKDIR}/pkg-deinstall

GCONF_SCHEMAS=	desktop_default_applications.schemas \
		desktop_gnome_url_handlers.schemas system_dns_sd.schemas \
		system_http_proxy.schemas system_smb.schemas

OPTIONS_DEFINE=	SAMBA MDNS
OPTIONS_DEFAULT=SAMBA MDNS
SAMBA_DESC=	Enable SMB volume support
MDNS_DESC=	Enable Bonjour/Rendezvous support

.include <bsd.port.options.mk>

.if exists(${LOCALBASE}/lib/libfam.so) || !defined(WITHOUT_FAM)
USES+=		fam
.endif

.if ${PORT_OPTIONS:MSAMBA}
CONFIGURE_ARGS+=--with-samba-includes=${SAMBAINCLUDES} --with-samba-libs=${SAMBALIBS}
USES+=		samba:lib
PLIST_SUB+=	SAMBA=""
.else
PLIST_SUB+=	SAMBA="@comment "
CONFIGURE_ARGS+=--disable-samba
.endif

.if ${PORT_OPTIONS:MMDNS}
LIB_DEPENDS+=	libavahi-client.so:net/avahi-app
.else
CONFIGURE_ARGS+=--disable-avahi
.endif

post-patch:
	@${REINPLACE_CMD} -e 's|/usr/local|${LOCALBASE}|g' \
		${WRKSRC}/libgnomevfs/Makefile.in
	@${REINPLACE_CMD} -e 's|/usr/local|${LOCALBASE}|g ; \
		s|%%LOCALBASE%%|${LOCALBASE}|g' \
		${WRKSRC}/libgnomevfs/xdgmime.c \
		${WRKSRC}/libgnomevfs/gnome-vfs-hal-mounts.c
	@${REINPLACE_CMD} -e 's|-lacl||g ; \
		s|inotify_support=yes|inotify_support=no|g' \
			${WRKSRC}/configure
	@${REINPLACE_CMD} -e 's|-DG_DISABLE_DEPRECATED||g' \
		${WRKSRC}/*/Makefile.in
	@${SED} -e 's|%%LOCALBASE%%|${LOCALBASE}|g' \
		< ${MASTERDIR}/pkg-install.in > ${PKGINSTALL}
	@${SED} -e 's|%%LOCALBASE%%|${LOCALBASE}|g' \
		< ${MASTERDIR}/pkg-deinstall.in > ${PKGDEINSTALL}

pre-configure:
.if defined(WITHOUT_KERBEROS)
	@${ECHO_CMD} "${PKGNAME}: KERBEROS is required."
	@${FALSE}
.endif

.include <bsd.port.mk>
