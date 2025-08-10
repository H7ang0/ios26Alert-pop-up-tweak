ARCHS = arm64 arm64e
TARGET := iphone:clang:14.5:14.0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME := H7ang0Alert

H7ang0Alert_FILES := Tweak.x \
	H7ang0Alert/H7ang0AlertController.m \
	H7ang0Alert/H7ang0AlertManager.m
H7ang0Alert_CFLAGS := -fobjc-arc
H7ang0Alert_FRAMEWORKS := UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard || sbreload" 