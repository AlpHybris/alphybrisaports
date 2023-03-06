#!/bin/sh

export EGL_PLATFORM=wayland
export COGL_DISABLE_MAPBUFFERRANGE=true

# Force gles on gdk
export GDK_GL=gles

# Disable webkitgtk bwrap sandbox for now
export WEBKIT_FORCE_SANDBOX=0

# Disable webkit compositing for now
export WEBKIT_DISABLE_COMPOSITING_MODE=1

export GSK_RENDERER=cairo
