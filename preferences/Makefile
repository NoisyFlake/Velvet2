TARGET := iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = Preferences

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Velvet2

Velvet2_FILES = $(wildcard *.m CustomCells/*.m ../src/Velvet2PrefsManager.m ../src/UIColor+Velvet.m ../src/ColorDetection.m ../src/Velvet2Colorizer.m)
Velvet2_FRAMEWORKS = UIKit
Velvet2_PRIVATE_FRAMEWORKS = Preferences
Velvet2_INSTALL_PATH = /Library/PreferenceBundles
Velvet2_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
