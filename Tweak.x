#import <UIKit/UIKit.h>

@interface SpringBoard : UIApplication
- (BOOL)isLocked;
- (id)_accessibilityFrontMostApplication;
@end

static void NVAHDispatchIfNecessary(void(^block)(void)) {
	if ([NSThread isMainThread]) block();
	else dispatch_sync(dispatch_get_main_queue(), block);
}

static BOOL NVAHShouldDisableVolumeControl(void) {
	id __block frontmostApp = nil;
	SpringBoard * __block springboard = nil;
	NVAHDispatchIfNecessary(^{
		springboard = (id)UIApplication.sharedApplication;
		frontmostApp = [springboard _accessibilityFrontMostApplication];
	});
	if (frontmostApp || [springboard isLocked]) {
		return NO;
	}
	return YES;
}

%hook SBHUDController

- (void)_presentHUD:(id)arg1 animated:(BOOL)arg2 {
	if (!NVAHShouldDisableVolumeControl()) %orig;
}

%end

%hook SBVolumeControl

- (float)volumeStepDown {
	return NVAHShouldDisableVolumeControl() ? 0.0 : %orig;
}

- (float)volumeStepUp {
	return NVAHShouldDisableVolumeControl() ? 0.0 : %orig;
}

%end