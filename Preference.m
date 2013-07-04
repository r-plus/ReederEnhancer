#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>

__attribute__((visibility("hidden")))
@interface ReederEnhancerListController: PSListController
- (id)specifiers;
@end

@implementation ReederEnhancerListController

- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"ReederEnhancer" target:self] retain];
	}
	return _specifiers;
}

@end
