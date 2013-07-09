ARCHS = armv7
THEOS_INSTALL_KILL = Reeder
THEOS_DEVICE_IP = 192.168.1.105

include theos/makefiles/common.mk

TWEAK_NAME = ReederEnhancer
ReederEnhancer_FILES = Tweak.xm DCAtomPub/Base64EncDec.m DCAtomPub/CocoaCryptoHashing.m DCAtomPub/DCAtomPubClient.m DCAtomPub/DCHatenaClient.m DCAtomPub/DCWSSE.m DCAtomPub/DCWSSEURLRequest.m
ReederEnhancer_FRAMEWORKS = UIKit MessageUI
ReederEnhancer_LDFLAGS = -weak_framework Twitter -weak_framework Social

include $(THEOS_MAKE_PATH)/tweak.mk

BUNDLE_NAME = ReederEnhancerSettings
ReederEnhancerSettings_FILES = Preference.m
ReederEnhancerSettings_INSTALL_PATH = /Library/PreferenceBundles
ReederEnhancerSettings_FRAMEWORKS = UIKit
ReederEnhancerSettings_PRIVATE_FRAMEWORKS = Preferences
ReederEnhancerSettings_LDFLAGS = -weak_framework Twitter -weak_framework Social

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ReederEnhancer.plist$(ECHO_END)

real-clean:
	rm -rf _
	rm -rf .obj
	rm -rf obj
	rm -rf .theos
	rm -rf *.deb