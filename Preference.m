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
@interface ReederEnhancerListController: PSListController <UIActionSheetDelegate> {
@private
	NSMutableArray* _eggSpecifiers;
	BOOL _isEgg;
}
- (NSArray *)specifiers;
- (void)heartButtonLongPressed:(id)sender;
@end

@implementation ReederEnhancerListController

- (NSArray *)specifiers
{
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"ReederEnhancer" target:self] retain];
		if (_isEgg) {
			_eggSpecifiers = [NSMutableArray array];
			NSString *list = [NSString stringWithContentsOfFile:@"/etc/apt/sources.list.d/cydia.list" encoding:NSUTF8StringEncoding error:nil];
			if ([list rangeOfString:@"kindadev.com/apt"].location != NSNotFound)
				_eggSpecifiers = [[self loadSpecifiersFromPlistName:@"Egg" target: self] retain];
			else
				_eggSpecifiers = [[self loadSpecifiersFromPlistName:@"AddRepo" target: self] retain];

			[_eggSpecifiers addObjectsFromArray:_specifiers];
			_specifiers = [_eggSpecifiers mutableCopy];
		}

		if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_5_0) {
			UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
			[rightBtn setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/ReederEnhancerSettings.bundle/Heart.png"] forState:UIControlStateNormal];
			rightBtn.frame = CGRectMake(0, 0, 60, 60);
			[rightBtn addTarget:self action:@selector(heartButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
			[[self navigationItem] setRightBarButtonItem:rightBarBtn];

			UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(heartButtonLongPressed:)];
			[rightBarBtn.customView addGestureRecognizer:longPress];   
			[longPress release];
		}
	}
	return _specifiers;
}

- (void)heartButtonLongPressed:(id)sender
{
	if(_eggSpecifiers == nil) {
		_eggSpecifiers = [NSMutableArray array];
		NSString *list = [NSString stringWithContentsOfFile:@"/etc/apt/sources.list.d/cydia.list" encoding:NSUTF8StringEncoding error:nil];
		if ([list rangeOfString:@"kindadev.com/apt"].location != NSNotFound)
			_eggSpecifiers = [[self loadSpecifiersFromPlistName:@"Egg" target: self] retain];
		else
			_eggSpecifiers = [[self loadSpecifiersFromPlistName:@"AddRepo" target: self] retain];
		[self insertContiguousSpecifiers:_eggSpecifiers atIndex:0 animated:YES];
		_isEgg = YES;
	}
}

- (void)heartButtonPressed:(id)sender
{
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

- (void)openTwitter:(id)specifier
{
	NSMutableArray *items = [NSMutableArray array];
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot://"]]) [items addObject:@"Open in Tweetbot"];
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) [items addObject:@"Open in Twitter"];
	[items addObject:@"Open in Safari"];
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Follow @wa_kinchan" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];

    for (NSString *buttonTitle in items)
        [sheet addButtonWithTitle:buttonTitle];
    sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"Cancel"];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
    [sheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(int)buttonIndex
{
	NSString *option = [actionSheet buttonTitleAtIndex:buttonIndex];
	if ([option isEqualToString:@"Open in Tweetbot"])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///user_profile/wa_kinchan"]];
    else if ([option isEqualToString:@"Open in Twitter"])
    	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=wa_kinchan"]];
    else if ([option isEqualToString:@"Open in Safari"])
    	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/wa_kinchan/"]];
}

- (void)openGitHub:(id)specifier
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/wakinchan/ReederEnhancer/"]];
}

- (void)loveEmiri:(id)specifier
{
	[UIPasteboard generalPasteboard].string = @"kindadev.com/apt";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"cydia://sources/add"]];
}

@end

