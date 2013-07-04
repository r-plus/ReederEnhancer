#import <UIKit/UIKit.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <Social/Social.h>

#define M_TITLE @"_TITLE_"
#define M_SOURCE @"_SOURCE_"
#define PREF_PATH @"/var/mobile/Library/Preferences/com.kindadev.ReederEnhancer.plist"

#ifndef kCFCoreFoundationVersionNumber_iOS_5_0
#define kCFCoreFoundationVersionNumber_iOS_5_0 675.00
#endif
#ifndef kCFCoreFoundationVersionNumber_iOS_6_0
#define kCFCoreFoundationVersionNumber_iOS_6_0 793.00
#endif

static BOOL isRefresh;
static BOOL isAskToSend;
static NSString *previousSyncStatusText;
static NSString *format;
static id srcTitle;
static id title;
static id url;

@interface RSAlert : NSObject
+ (void)presentInput:(id)arg1 withTitle:(id)arg2 placeholder:(id)arg3 description:(id)arg4 buttonTitle:(id)arg5 cancelButtonTitle:(id)arg6 handler:(id)arg7;
+ (void)presentSheetWithTitle:(id)arg1 buttonTitle:(id)arg2 cancelButtonTitle:(id)arg3 handler:(id)arg4;
+ (void)presentWithImage:(id)arg1 buttonTitle:(id)arg2 handler:(id)arg3;
+ (void)presentWithTitle:(id)arg1 message:(id)arg2 buttonTitle:(id)arg3 handler:(id)arg4;
+ (void)presentSheetWithTitle:(id)arg1 buttonTitle:(id)arg2 handler:(id)arg3;
@end

@interface BezelPanel
+ (id)bezelWithSize:(int)arg1 image:(id)arg2 text:(id)arg3;
- (void)flashInView:(id)arg1 direction:(int)arg2;
- (id)initWithSize:(int)arg1 image:(id)arg2 text:(id)arg3;
@end

@interface PullView : UIView
- (id)initWithFrame:(struct CGRect)arg1;
- (void)setScale:(float)arg1;
- (float)scale;
- (void)setTitle:(id)arg1;
- (void)setDescription:(id)arg1;
- (void)setEdgeInset:(float)arg1;
- (void)setUsesOptimizedDisplay:(BOOL)arg1;
- (void)setDescriptionImage:(id)arg1;
- (void)setResizing:(int)arg1;
@end

%hook SubscriptionsViewController
- (BOOL)hasRefreshView
{
	if (isRefresh) return NO;
	else return %orig;
}
%end

%hook TableViewController
- (BOOL)hasRefreshView
{
	if (isRefresh) return NO;
	else return %orig;
}
%end

@interface ItemsViewController : UITableViewController
@end

%hook ItemsViewController
- (void)setPullTranslation:(float)arg1
 {
 	%log;
 	%orig;
 }

- (BOOL)hasRefreshView
{
	%log;
	NSLog(@"[self.tableView.contentSize]: %@", NSStringFromCGSize([self.tableView contentSize]));
	if (isRefresh) return NO;
	else return %orig;
}

- (void)tableView:(id)arg1 didTriggerRightSliderForCell:(id)arg2 atIndexPath:(id)arg3
{
	if (!isAskToSend) return %orig;
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	NSString *action = [ud stringForKey:@"AppSlideLeftAction"];
	if ([action isEqualToString:@"NoAction"] || [action isEqualToString:@"ToggleStarred"] || [action isEqualToString:@"ToggleRead"]) return %orig;
	UIImage *image = [[UIImage alloc] init];
	if ([action isEqualToString:@"Readability"]) image = [UIImage imageNamed:@"ShareRKServiceReadability"];
	else if ([action isEqualToString:@"Instapaper"]) image = [UIImage imageNamed:@"ShareRKServiceInstapaper"];
	else if ([action isEqualToString:@"Pocket"]) image = [UIImage imageNamed:@"ShareRKServiceReadItLater"];
	else if ([action isEqualToString:@"QuoteFMRead"]) { action = @"QUOTE.fm";  image = [UIImage imageNamed:@"ShareRKServiceQuoteFMRead"]; }
	[%c(RSAlert) presentSheetWithTitle:[NSString stringWithFormat:@"Are you sure you want to send %@?", action] buttonTitle:[NSString stringWithFormat:@"Send to %@", action] cancelButtonTitle:@"Cancel" handler:^{
		%orig;
		BezelPanel *bezel = [%c(BezelPanel) bezelWithSize:55 image:image text:action];
		UIWindow *window = [UIApplication sharedApplication].keyWindow;
		[bezel flashInView:window.rootViewController.view direction:1];
	}];
}

- (void)tableView:(id)arg1 didTriggerLeftSliderForCell:(id)arg2 atIndexPath:(id)arg3
{
	if (!isAskToSend) return %orig;
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	NSString *action = [ud stringForKey:@"AppSlideRightAction"];
	if ([action isEqualToString:@"NoAction"] || [action isEqualToString:@"ToggleStarred"] || [action isEqualToString:@"ToggleRead"]) return %orig;
	UIImage *image = [[UIImage alloc] init];
	if ([action isEqualToString:@"Readability"]) image = [UIImage imageNamed:@"ShareRKServiceReadability"];
	else if ([action isEqualToString:@"Instapaper"]) image = [UIImage imageNamed:@"ShareRKServiceInstapaper"];
	else if ([action isEqualToString:@"Pocket"]) image = [UIImage imageNamed:@"ShareRKServiceReadItLater"];
	else if ([action isEqualToString:@"QuoteFMRead"]) { action = @"QUOTE.fm";  image = [UIImage imageNamed:@"ShareRKServiceQuoteFMRead"]; }
	[%c(RSAlert) presentSheetWithTitle:[NSString stringWithFormat:@"Are you sure you want to send %@?", action] buttonTitle:[NSString stringWithFormat:@"Send to %@", action] cancelButtonTitle:@"Cancel" handler:^{
		%orig;
		BezelPanel *bezel = [%c(BezelPanel) bezelWithSize:55 image:image text:action];
		UIWindow *window = [UIApplication sharedApplication].keyWindow;
		[bezel flashInView:window.rootViewController.view direction:1];
	}];
}

- (id)tableView:(id)arg1 rightSliderIconForCell:(id)arg2 atIndexPath:(id)arg3
{
	if (!isAskToSend) return %orig;
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	NSString *action = [ud stringForKey:@"AppSlideRightAction"];
	if ([action isEqualToString:@"NoAction"] || [action isEqualToString:@"ToggleStarred"] || [action isEqualToString:@"ToggleRead"]) return %orig;
	else return NULL;
}

- (id)tableView:(id)arg1 leftSliderIconForCell:(id)arg2 atIndexPath:(id)arg3
{
	if (!isAskToSend) return %orig;
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	NSString *action = [ud stringForKey:@"AppSlideRightAction"];
	if ([action isEqualToString:@"NoAction"] || [action isEqualToString:@"ToggleStarred"] || [action isEqualToString:@"ToggleRead"]) return %orig;
	else return NULL;
}
%end

%hook RKUser
- (void)setSyncStatusText:(NSString *)text
{
	if (!text && [previousSyncStatusText hasPrefix:@"Caching"]) {
		UILocalNotification *notification = [[UILocalNotification alloc] init];
		[notification setTimeZone:[NSTimeZone localTimeZone]];
		NSDate *date = [NSDate date];
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateFormat:@"Y/M/d H:m:ss Z"];
		[notification setAlertBody:[NSString stringWithFormat:@"Synced at %@", [dateFormatter stringFromDate:date]]];
		[notification setSoundName:UILocalNotificationDefaultSoundName];
		[notification setAlertAction:@"Open"];
		[[UIApplication sharedApplication] presentLocalNotificationNow:notification];
		[notification release];
	}
	previousSyncStatusText = text;
	%orig;
}
%end

%hook AppDelegate
%new(v@:@@)
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(id)arg1
{
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
	%orig;
}
%end

@interface RKShareObject : NSObject
+ (id)shareObjectWithItem:(id)item;
- (id)item;
- (id)srcTitle;
- (id)title;
- (id)url;
@end

%hook ArticleViewController
- (void)share:(id)arg
{
	%orig;
	id item = [%c(RKShareObject) shareObjectWithItem:[self item]];
	srcTitle = [item srcTitle];
	title = [item title];
	url = [item url];
}
%end

@interface UIView (FindFirstResponder)
- (UIView *)findFirstResponder;
@end

@implementation UIView (FindFirstResponder)
- (UIView *)findFirstResponder
{
    if (self.isFirstResponder)
        return self;
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        if (firstResponder != nil)
            return firstResponder;
    }
    return nil;
}
@end

%hook RKServiceTwitter
- (void)share:(id)arg1
{
	NSString *cStr = [format stringByReplacingOccurrencesOfString:M_TITLE withString:title];
	cStr = [cStr stringByReplacingOccurrencesOfString:M_SOURCE withString:srcTitle];

	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	id viewController = window.rootViewController;

	TWTweetComposeViewController *twitterPostVC = [[TWTweetComposeViewController alloc] init];
	[twitterPostVC setInitialText:cStr];
	[twitterPostVC addURL:[NSURL URLWithString:url]];
	[viewController presentViewController:twitterPostVC animated:YES completion:^{
		UITextView *textView = (UITextView *)[[[UIApplication sharedApplication] keyWindow] findFirstResponder];
		textView.selectedRange = NSMakeRange(0, 0);
	}];
}
%end

%hook RKServiceFacebook
- (void)share:(id)arg1
{
	NSString *cStr = [format stringByReplacingOccurrencesOfString:M_TITLE withString:title];
	cStr = [cStr stringByReplacingOccurrencesOfString:M_SOURCE withString:srcTitle];

	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	id viewController = window.rootViewController;

	SLComposeViewController *facebookPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];    
	[facebookPostVC setInitialText:cStr];
	[facebookPostVC addURL:[NSURL URLWithString:url]];
	[viewController presentViewController:facebookPostVC animated:YES completion:^{
		UITextView *textView = (UITextView *)[[[UIApplication sharedApplication] keyWindow] findFirstResponder];
		textView.selectedRange = NSMakeRange(0, 0);
    }];
}
%end

static void LoadSettings()
{
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:PREF_PATH];
	id existRefresh = [dict objectForKey:@"NoRefresh"];
	isRefresh = existRefresh ? [existRefresh boolValue] : YES;
	id existAskToSend = [dict objectForKey:@"AskToSend"];
	isAskToSend = existAskToSend ? [existAskToSend boolValue] : YES;
	id existFormat = [dict objectForKey:@"Format"];
    format = existFormat ? [existFormat copy] : @"\"_TITLE_ | _SOURCE_\"";
}

static void PostNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	LoadSettings();
}

%ctor
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	%init;
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, PostNotification, CFSTR("com.kindadev.ReederEnhancer.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	LoadSettings();
    [pool release];
}
