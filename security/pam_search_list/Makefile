# Created by: Victor Popov

PORTNAME=	pam_search_list
PORTVERSION=	0.1
PORTREVISION=	1
CATEGORIES=	security
MASTER_SITES=	SF/${PORTNAME:S/_/-/g}
DISTNAME=	${PORTNAME:S/_/-/g}-${PORTVERSION}

MAINTAINER=	v.a.popov@gmail.com
COMMENT=	PAM module to search arbitrary file for user

USES=		tar:xz uidfix

PLIST_FILES=	lib/libpam_search_list.a \
		lib/pam_search_list.so \
		lib/pam_search_list.so.0 \
		man/man8/pam_search_list.8.gz

MAKE_ARGS+=	SHLIB=pam_search_list

.include <bsd.port.mk>
