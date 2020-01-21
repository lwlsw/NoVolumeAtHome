#import <UIKit/UIKit.h>

@interface SpringBoard : UIApplication
- (BOOL)isLocked;
- (id)_accessibilityFrontMostApplication;
@end

static void NVAHVolumeHook(id self, SEL _cmd, id arg1, IMP orig) {
	SpringBoard *springboard = (id)UIApplication.sharedApplication;
	id frontmostApp = [springboard _accessibilityFrontMostApplication];
	if (frontmostApp || [springboard isLocked]) {
		((void(*)(id,SEL,id))orig)(self, _cmd, arg1);
	}
}

%hook SBVolumeHardwareButton

- (void)volumeIncreasePress:(id)arg1 {
	NVAHVolumeHook(self, _cmd, arg1, (IMP)&%orig);
}

- (void)volumeDecreasePress:(id)arg1 {
	NVAHVolumeHook(self, _cmd, arg1, (IMP)&%orig);
}

%end