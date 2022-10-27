TARGET := iphone:clang:latest:15.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Velvet2

Velvet2_FILES = Velvet2RootListController.m
Velvet2_FRAMEWORKS = UIKit
Velvet2_PRIVATE_FRAMEWORKS = Preferences
Velvet2_INSTALL_PATH = /Library/PreferenceBundles
Velvet2_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
