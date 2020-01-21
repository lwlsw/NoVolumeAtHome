INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NoVolumeAtHome

NoVolumeAtHome_FILES = Tweak.x
NoVolumeAtHome_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
