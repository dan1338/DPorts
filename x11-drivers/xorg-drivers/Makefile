
PORTNAME=	xorg-drivers
PORTVERSION=	7.7
PORTREVISION=	6
CATEGORIES=	x11-drivers

MAINTAINER=	x11@FreeBSD.org
COMMENT=	X.org drivers meta-port

VIDEODIR=	${LOCALBASE}/lib/xorg/modules/drivers
INPUTDIR=	${LOCALBASE}/lib/xorg/modules/input

USES=		metaport

INPUT_DRIVERS=		egalax \
			elographics \
			evdev \
			joystick \
			keyboard \
			mouse \
			synaptics \
			void \
			wacom

VIDEO_DRIVERS=		apm \
			ark \
			ast \
			dummy \
			glint \
			i128 \
			i740 \
			mga \
			s3 \
			scfb \
			tdfx \
			trident \
			tseng \
			vesa \
			vmware

VIDEO_DRIVERS_REMOVED=	libinput \
			mach64 \
			chips \
			cirrus \
			neomagic \
			r128 \
			rendition \
			s3virge \
			savage \
			siliconmotion \
			sis \
			voodoo

OPTIONS_DEFAULT=	KEYBOARD \
			LIBINPUT \
			MOUSE \
			SCFB

.for type in input video
. for a in ${${type:tu}_DRIVERS}
OPTIONS_DEFINE+=	${a:tu}
${a:tu}_DESC=		Install ${a} ${type} driver
. endfor
.endfor

OPTIONS_DEFINE_x86_64=	AMDGPU ATI INTEL VMMOUSE VMWARE
OPTIONS_DEFAULT_x86_64=	ATI INTEL VESA

OPTIONS_DEFINE_i386:=	${OPTIONS_DEFINE_x86_64} GEODE
OPTIONS_DEFAULT_i386:=	${OPTIONS_DEFAULT_x86_64}

OPTIONS_DEFINE_sparc64=	SUNFFB
OPTIONS_DEFAULT_sparc64=SUNFFB

AMDGPU_DESC=		Install amdgpu video driver
ATI_DESC=		Install ati (radeon) video driver 
GEODE_DESC=		Install geode video driver
INTEL_DESC=		Install intel video driver
SUNFFB_DESC=		Install sunffb video driver
VMMOUSE_DESC=		Install vmmouse input driver
VMWARE_DESC=		Install vmware video driver

# these drivers have a different module name compared to the plugin they install
QUIRKS=		keyboard:kbd

.include <bsd.port.options.mk>

# Manual add arch specific drivers so they be added to depend lines.
.if ${ARCH}==i386 || ${ARCH}==x86_64
INPUT_DRIVERS+= vmmouse
VIDEO_DRIVERS+=	amdgpu ati intel vmware
.endif

.if ${ARCH}==i386
VIDEO_DRIVERS+= geode
.endif

.if ${ARCH}==sparc64
VIDEO_DRIVERS+=	sunffb
.endif

.for type in input video
. for i in ${${type:tu}_DRIVERS}
.  if ${PORT_OPTIONS:M${i:tu}} != ""
.   if ${QUIRKS:M${i}\:*:C/.*://} != ""
RUN_DEPENDS+=	${${type:tu}DIR}/${QUIRKS:M${i}\:*:C/.*://}_drv.so:x11-drivers/xf86-${type}-${i}
.   else
RUN_DEPENDS+=	${${type:tu}DIR}/${i}_drv.so:x11-drivers/xf86-${type}-${i}
.   endif
.  endif
. endfor
.endfor

.include <bsd.port.mk>
