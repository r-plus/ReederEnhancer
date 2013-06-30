THEOS_INSTALL_KILL = Reeder
THEOS_DEVICE_IP = 192.168.1.109

include theos/makefiles/common.mk

TWEAK_NAME = ReederEnhancer
ReederEnhancer_FILES = Tweak.xm
ReederEnhancer_FRAMEWORKS = UIKit
ReederEnhancer_LDFLAGS = -weak_framework Twitter -weak_framework Social

include $(THEOS_MAKE_PATH)/tweak.mk

real-clean:
	rm -rf _
	rm -rf .obj
	rm -rf obj
	rm -rf .theos
	rm -rf *.deb