include theos/makefiles/common.mk

TWEAK_NAME = ReederEnhancer
ReederEnhancer_FILES = Tweak.xm AllAroundPullView/AllAroundPullView.m
ReederEnhancer_FRAMEWORKS = UIKit QuartzCore
THEOS_INSTALL_KILL = Reeder

include $(THEOS_MAKE_PATH)/tweak.mk
