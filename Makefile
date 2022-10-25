TARGET := iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Velvet2

Velvet2_FILES = src/Tweak.x
Velvet2_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
