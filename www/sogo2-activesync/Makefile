# $FreeBSD$

PORTREVISION=	5
PKGNAMESUFFIX=		-activesync

MAINTAINER=		acm@FreeBSD.org

CONFLICTS=		sogo[2-4]-[0-9]* sogo[3-4]-activesync-[0-9]*

OPTIONS_SLAVE=		ACTIVESYNC
BROKEN=		clang segfaults

MASTERDIR=		${.CURDIR}/../sogo2

.include "${MASTERDIR}/Makefile"
