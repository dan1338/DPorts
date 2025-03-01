
PORTNAME=	node
PORTVERSION=	12.22.1
DISTVERSIONPREFIX=	v
CATEGORIES=	www
MASTER_SITES=	http://nodejs.org/dist/v${PORTVERSION}/
PKGNAMESUFFIX=	12

MAINTAINER=	bhughes@FreeBSD.org
COMMENT=	V8 JavaScript for client and server

LICENSE=	MIT
LICENSE_FILE=	${WRKSRC}/LICENSE

BROKEN_SSL=		libressl libressl-devel
BROKEN_SSL_REASON=	Node.js 12.x LTS requires OpenSSL 1.1.x or the BUNDLED_SSL option enabled
ONLY_FOR_ARCHS=		aarch64 amd64 armv6 armv7 i386 powerpc64 powerpc64le

USES=		compiler:c++11-lib gmake python:2.7,build pkgconfig \
		localbase shebangfix

OPTIONS_DEFINE=		BUNDLED_SSL DOCS NLS DTRACE
OPTIONS_DEFAULT=	DTRACE
OPTIONS_DEFAULT_FreeBSD_11=	BUNDLED_SSL
OPTIONS_DEFAULT+=	${OPTIONS_DEFAULT_${OPSYS}_${OSREL:R}}
OPTIONS_SUB=		yes

.if !exists(/usr/sbin/dtrace)
OPTIONS_EXCLUDE+=	DTRACE
.endif

OPTIONS_EXCLUDE_aarch64=	DTRACE
# dt_modtext:/usr/src/cddl/contrib/opensolaris/lib/libdtrace/common/dt_link.c(820): arm not implemented
OPTIONS_EXCLUDE_armv6=		DTRACE
OPTIONS_EXCLUDE_armv7=		DTRACE
OPTIONS_EXCLUDE_powerpc64=	DTRACE
OPTIONS_EXCLUDE_powerpc64le=	DTRACE

BUNDLED_SSL_DESC=		Use node.js's bundled OpenSSL implementation
BUNDLED_SSL_USES_OFF=		ssl
BUNDLED_SSL_CONFIGURE_OFF=	--shared-openssl --openssl-use-def-ca-store
BUNDLED_SSL_RUN_DEPENDS_OFF=	ca_root_nss>=0:security/ca_root_nss

NLS_CONFIGURE_ON=	--with-intl=system-icu
NLS_BUILD_DEPENDS=	icu>=67.1:devel/icu
NLS_LIB_DEPENDS=	libicui18n.so:devel/icu

DTRACE_CONFIGURE_ON=	--with-dtrace

HAS_CONFIGURE=	yes

CONFLICTS_INSTALL=	node10-[0-9]* node14-[0-9]* node-[0-9]*

CONFIGURE_ARGS=	--prefix=${PREFIX_RELDEST} \
		--without-npm \
		--shared-cares \
		--shared-libuv \
		--shared-nghttp2 \
		--shared-zlib

SHEBANG_FILES=	tools/specialize_node_d.py tools/genv8constants.py

PREFIX_RELDEST=	${PREFIX:S,^${DESTDIR},,}
REINPLACE_ARGS=	-i ''
MAKE_ENV+=	CC.host=${CC} CFLAGS.host="${CFLAGS}" \
		CXX.host=${CXX} CXXFLAGS.host="${CXXFLAGS}" \
		LINK.host=${CXX} LDFLAGS.host="${LDFLAGS}"

BUILD_DEPENDS+=	c-ares>=1.16.1:dns/c-ares \
		libuv>=1.40.0:devel/libuv \
		libnghttp2>=1.41.0:www/libnghttp2 \
		
LIB_DEPENDS+=	libcares.so:dns/c-ares\
		libuv.so:devel/libuv \
		libnghttp2.so:www/libnghttp2

.include <bsd.port.options.mk>

.if ${OPSYS} == FreeBSD && ${OSVERSION} < 1200085
BROKEN_SSL+=	base
.endif

.if ${ARCH} == armv6 || ${ARCH} == armv7
EXTRA_PATCHES=	${PATCHDIR}/extra-patch-tools_v8__gypfiles_v8.gyp
.elif (defined(PPC_ABI) && ${PPC_ABI} == ELFv2) || ${ARCH} == powerpc64le
EXTRA_PATCHES=	${PATCHDIR}/extra-patch-common.gypi
.endif

.if ${PORT_OPTIONS:MBUNDLED_SSL} && ${ARCH} != x86_64
CONFIGURE_ARGS+=--openssl-no-asm
.endif

post-patch:
	@${REINPLACE_CMD} -e 's|/usr/local|${LOCALBASE}|' \
		${WRKSRC}/tools/v8_gypfiles/v8.gyp

post-configure:
	# Post-process Makefile and *.mk files created by node-gyp and remove
	# all occurrences of -I${LOCALBASE}/include. C*FLAGS include this
	# before all -I../deps/* for bundled code. This can cause build
	# breakages if the dependency is installed in ${LOCALBASE}. The
	# USES+=localbase # above will ensure that we pick up includes for real
	# external dependencies.
	${FIND} ${WRKSRC}/out -type f -print0 \
		| ${XARGS} -0 ${REINPLACE_CMD} -e "s|-I${LOCALBASE}/include||g"

post-install:
	${STRIP_CMD} ${STAGEDIR}${PREFIX}/bin/node

.include <bsd.port.mk>
