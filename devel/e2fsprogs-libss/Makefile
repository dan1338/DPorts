# Created by: Ben Kaduk <kaduk@mit.edu>

PORTREVISION=	0
CATEGORIES=	devel
PKGNAMESUFFIX=	-libss

MAINTAINER=	kaduk-fbsd@mit.edu
COMMENT=	Command-line interface parsing library from e2fsprogs

LICENSE=	MIT
LICENSE_FILE=	${INSTALL_WRKSRC}/ss.h

OPTIONS_EXCLUDE=	DOCS EXAMPLES IPV6 NLS
CONFIGURE_ARGS=	--enable-elf-shlibs
MASTERDIR=	${.CURDIR}/../../sysutils/e2fsprogs
GNU_CONFIGURE=	yes
USE_LDCONFIG=	yes
BUILD_WRKSRC=	${WRKSRC}/lib/ss
INSTALL_WRKSRC=	${WRKSRC}/lib/ss
FILESDIR=	${.CURDIR}/files

PKGDIR=		${.CURDIR}

pre-build:
	(cd ${WRKSRC}/lib/ss && compile_et ss_err.et && \
	${REINPLACE_CMD} -f ${FILESDIR}/fix-ss_err.h.sed ss_err.h)

LIB_DEPENDS+= libcom_err.so:security/krb5
LDFLAGS+= -L${LOCALBASE}/lib

.include "${MASTERDIR}/Makefile"
