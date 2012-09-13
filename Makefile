include theos/makefiles/common.mk

TWEAK_NAME = PullToSyncForReeder3
PullToSyncForReeder3_FILES = Tweak.xm AllAroundPullView/AllAroundPullView.m
PullToSyncForReeder3_FRAMEWORKS = UIKit QuartzCore
THEOS_INSTALL_KILL = Reeder

include $(THEOS_MAKE_PATH)/tweak.mk
