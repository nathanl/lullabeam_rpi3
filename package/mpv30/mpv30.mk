################################################################################
#
# mpv30
#
################################################################################

MPV30_VERSION = 0.30.0
MPV30_SITE = https://github.com/mpv-player/mpv/archive
MPV30_SOURCE = v$(MPV30_VERSION).tar.gz
MPV30_DEPENDENCIES = \
	host-pkgconf ffmpeg zlib \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv)
MPV30_LICENSE = GPL-2.0+
MPV30_LICENSE_FILES = LICENSE.GPL

MPV30_NEEDS_EXTERNAL_WAF = YES

# Some of these options need testing and/or tweaks
MPV30_CONF_OPTS = \
	--prefix=/usr \
	--disable-android \
	--disable-caca \
	--disable-cocoa \
	--disable-coreaudio \
	--disable-cuda-hwaccel \
	--disable-opensles \
	--disable-rsound \
	--disable-rubberband \
	--disable-uchardet \
	--disable-vapoursynth \
	--disable-vdpau

# ALSA support requires pcm+mixer
ifeq ($(BR2_PACKAGE_ALSA_LIB_MIXER)$(BR2_PACKAGE_ALSA_LIB_PCM),yy)
MPV30_CONF_OPTS += --enable-alsa
MPV30_DEPENDENCIES += alsa-lib
else
MPV30_CONF_OPTS += --disable-alsa
endif

# GBM support is provided by mesa3d when EGL=y
ifeq ($(BR2_PACKAGE_MESA3D_OPENGL_EGL),y)
MPV30_CONF_OPTS += --enable-gbm
MPV30_DEPENDENCIES += mesa3d
else
MPV30_CONF_OPTS += --disable-gbm
endif

# jack support
# It also requires 64-bit sync intrinsics
ifeq ($(BR2_TOOLCHAIN_HAS_SYNC_8)$(BR2_PACKAGE_JACK2),yy)
MPV30_CONF_OPTS += --enable-jack
MPV30_DEPENDENCIES += jack2
else
MPV30_CONF_OPTS += --disable-jack
endif

# jpeg support
ifeq ($(BR2_PACKAGE_JPEG),y)
MPV30_CONF_OPTS += --enable-jpeg
MPV30_DEPENDENCIES += jpeg
else
MPV30_CONF_OPTS += --disable-jpeg
endif

# lcms2 support
ifeq ($(BR2_PACKAGE_LCMS2),y)
MPV30_CONF_OPTS += --enable-lcms2
MPV30_DEPENDENCIES += lcms2
else
MPV30_CONF_OPTS += --disable-lcms2
endif

# libarchive support
ifeq ($(BR2_PACKAGE_LIBARCHIVE),y)
MPV30_CONF_OPTS += --enable-libarchive
MPV30_DEPENDENCIES += libarchive
else
MPV30_CONF_OPTS += --disable-libarchive
endif

# libass subtitle support
ifeq ($(BR2_PACKAGE_LIBASS),y)
MPV30_CONF_OPTS += --enable-libass
MPV30_DEPENDENCIES += libass
else
MPV30_CONF_OPTS += --disable-libass
endif

# bluray support
ifeq ($(BR2_PACKAGE_LIBBLURAY),y)
MPV30_CONF_OPTS += --enable-libbluray
MPV30_DEPENDENCIES += libbluray
else
MPV30_CONF_OPTS += --disable-libbluray
endif

# libcdio-paranoia
ifeq ($(BR2_PACKAGE_LIBCDIO_PARANOIA),y)
MPV30_CONF_OPTS += --enable-cdda
MPV30_DEPENDENCIES += libcdio-paranoia
else
MPV30_CONF_OPTS += --disable-cdda
endif

# libdvdnav
ifeq ($(BR2_PACKAGE_LIBDVDNAV),y)
MPV30_CONF_OPTS += --enable-dvdnav
MPV30_DEPENDENCIES += libdvdnav
else
MPV30_CONF_OPTS += --disable-dvdnav
endif

# libdrm
ifeq ($(BR2_PACKAGE_LIBDRM),y)
MPV30_CONF_OPTS += --enable-drm
MPV30_DEPENDENCIES += libdrm
else
MPV30_CONF_OPTS += --disable-drm
endif

# LUA support, only for lua51/lua52/luajit
# This enables the controller (OSD) together with libass
ifeq ($(BR2_PACKAGE_LUA_5_1)$(BR2_PACKAGE_LUAJIT),y)
MPV30_CONF_OPTS += --enable-lua
MPV30_DEPENDENCIES += luainterpreter
else
MPV30_CONF_OPTS += --disable-lua
endif

# OpenGL support
ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)
MPV30_CONF_OPTS += --enable-gl
MPV30_DEPENDENCIES += libgl
else
MPV30_CONF_OPTS += --disable-gl
endif

# pulseaudio support
ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
MPV30_CONF_OPTS += --enable-pulse
MPV30_DEPENDENCIES += pulseaudio
else
MPV30_CONF_OPTS += --disable-pulse
endif

# samba support
ifeq ($(BR2_PACKAGE_SAMBA4),y)
MPV30_CONF_OPTS += --enable-libsmbclient
MPV30_DEPENDENCIES += samba4
else
MPV30_CONF_OPTS += --disable-libsmbclient
endif

# SDL support
# Sdl2 requires 64-bit sync intrinsics
ifeq ($(BR2_TOOLCHAIN_HAS_SYNC_8)$(BR2_PACKAGE_SDL2),yy)
MPV30_CONF_OPTS += --enable-sdl2
MPV30_DEPENDENCIES += sdl2
else
MPV30_CONF_OPTS += --disable-sdl2
endif

# Raspberry Pi support
ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
MPV30_CONF_OPTS += --enable-rpi --enable-gl
MPV30_DEPENDENCIES += rpi-userland
else
MPV30_CONF_OPTS += --disable-rpi
endif

# va-api support
# This requires one or more of the egl-drm, wayland, x11 backends
# For now we support wayland and x11
ifeq ($(BR2_PACKAGE_LIBVA),y)
ifneq ($(BR2_PACKAGE_WAYLAND)$(BR2_PACKAGE_XORG7),)
MPV30_CONF_OPTS += --enable-vaapi
MPV30_DEPENDENCIES += libva
else
MPV30_CONF_OPTS += --disable-vaapi
endif
else
MPV30_CONF_OPTS += --disable-vaapi
endif

# wayland support
ifeq ($(BR2_PACKAGE_WAYLAND),y)
MPV30_CONF_OPTS += --enable-wayland
MPV30_DEPENDENCIES += libxkbcommon wayland wayland-protocols
else
MPV30_CONF_OPTS += --disable-wayland
endif

# Base X11 support. Config.in ensures that if BR2_PACKAGE_XORG7 is
# enabled, xlib_libX11, xlib_libXext, xlib_libXinerama,
# xlib_libXrandr, xlib_libXScrnSaver.
ifeq ($(BR2_PACKAGE_XORG7),y)
MPV30_CONF_OPTS += --enable-x11
MPV30_DEPENDENCIES += xlib_libX11 xlib_libXext xlib_libXinerama xlib_libXrandr xlib_libXScrnSaver
# XVideo
ifeq ($(BR2_PACKAGE_XLIB_LIBXV),y)
MPV30_CONF_OPTS += --enable-xv
MPV30_DEPENDENCIES += xlib_libXv
else
MPV30_CONF_OPTS += --disable-xv
endif
else
MPV30_CONF_OPTS += --disable-x11
endif

$(eval $(waf-package))
