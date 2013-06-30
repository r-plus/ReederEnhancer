#import <UIKit/UIKit.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <Social/Social.h>

#define M_TITLE @"_TITLE_"
#define M_SOURCE @"_SOURCE_"
#define PREF_PATH @"/var/mobile/Library/Preferences/com.kindadev.reederenhancer.plist"

#ifndef kCFCoreFoundationVersionNumber_iOS_5_0
#define kCFCoreFoundationVersionNumber_iOS_5_0 675.00
#endif
#ifndef kCFCoreFoundationVersionNumber_iOS_6_0
#define kCFCoreFoundationVersionNumber_iOS_6_0 793.00
#endif

static BOOL isRefresh;
static NSString *previousSyncStatusText;
static NSString *format;
static id srcTitle;
static id title;
static id url;

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

%hook ItemsViewController
- (BOOL)hasRefreshView
{
	if (isRefresh) return NO;
	else return %orig;
}
%end

%hook RKUser
- (void)setSyncStatusText:(NSString *)text
{
	%log;
	NSLog(@"-----text = %@", text);
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
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, PostNotification, CFSTR("com.kindadev.reederenhancer.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	LoadSettings();
    [pool release];
}
