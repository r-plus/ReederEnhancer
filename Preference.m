#import <UIKit/UIKit.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <Social/Social.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

#ifndef kCFCoreFoundationVersionNumber_iOS_5_0
#define kCFCoreFoundationVersionNumber_iOS_5_0 675.00
#endif
#ifndef kCFCoreFoundationVersionNumber_iOS_6_0
#define kCFCoreFoundationVersionNumber_iOS_6_0 793.00
#endif

__attribute__((visibility("hidden")))
@interface ReederEnhancerListController: PSListController
- (id)specifiers;
@end

@implementation ReederEnhancerListController

- (id)specifiers {
	if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_5_0) {
		UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[rightBtn setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/ReederEnhancerSettings.bundle/Heart.png"] forState:UIControlStateNormal];
		rightBtn.frame = CGRectMake(0, 0, 60, 60);
		[rightBtn addTarget:self action:@selector(herrtButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
		[[self navigationItem] setRightBarButtonItem:rightBarBtn];
	}

	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"ReederEnhancer" target:self] retain];
	}
	return _specifiers;
}

- (void)herrtButtonPressed:(id)sender {
	if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_6_0) {
		SLComposeViewController *twitterPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
		[twitterPostVC setInitialText:@"I love Reeder with #ReederEnhancer from @wa_kinchan!"];
		[[self parentController] presentViewController:twitterPostVC animated:YES completion:nil];
	} else if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_5_0) {
		TWTweetComposeViewController *twitterPostVC = [[TWTweetComposeViewController alloc] init];
		[twitterPostVC setInitialText:@"I love Reeder with #ReederEnhancer from @wa_kinchan!"];
		[[self parentController] presentModalViewController:twitterPostVC animated:YES];
	}
}

@end
