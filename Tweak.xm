#import <UIKit/UIKit.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import "DCAtomPub/DCWSSE.h"
#import "DCAtomPub/DCHatenaClient.h"

#define M_TITLE @"_TITLE_"
#define M_SOURCE @"_SOURCE_"
#define M_URL @"_URL_"
#define PREF_PATH @"/var/mobile/Library/Preferences/com.kindadev.ReederEnhancer.plist"

#ifndef kCFCoreFoundationVersionNumber_iOS_5_0
#define kCFCoreFoundationVersionNumber_iOS_5_0 675.00
#endif
#ifndef kCFCoreFoundationVersionNumber_iOS_6_0
#define kCFCoreFoundationVersionNumber_iOS_6_0 793.00
#endif

static BOOL isRefresh;
static BOOL isAskToSend;
static BOOL isHatena;
static NSString *previousSyncStatusText;
static NSString *previousTitle;
static NSString *format;
static NSString *formatBody;
static NSString *formatSubject;
static BOOL isShare = NO;
static NSString *_title;
static NSString *_srcTitle;
static NSString *_url;

@interface RKShareObject : NSObject
+ (id)shareObjectWithItem:(id)item;
- (id)item;
- (NSString *)srcTitle;
- (NSString *)title;
- (NSString *)url;
- (NSString *)summary;
- (NSString *)content;
@end

@interface ShareButton
+ (id)buttonWithService:(id)arg1;
- (id)service;
- (id)image;
- (id)title;
@end

@interface SharePanel
- (void)close:(BOOL)arg1;
@end

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
@end

%hook ShareController
- (void)share:(id)arg1 inView:(id)arg2 above:(id)arg3 fromFrame:(struct CGRect)arg4
{
	%orig;
	id item = [%c(RKShareObject) shareObjectWithItem:[arg1 item]];
	_title = [item title];
	_srcTitle = [item srcTitle];
	_url = (NSString *)[item url];
}
%end

%hook ArticleViewController
- (void)share:(id)arg1
{
	%orig;
	isShare = YES;
}
%end

%hook SharePanel
- (void)close:(BOOL)arg1
{
	%orig;
	isShare = NO;
}
- (void)tapClose:(id)arg1
{
	%orig;
	isShare = NO;
}
%end

@interface RKServiceMessage
- (void)postHatenaWtihComment:(NSString *)comment;
- (void)postHatenaFromUrlScheme;
@end

static NSString *filedText;
static int choice;
static NSString *hatenaUsername;
static NSString *hatenaPassword;
static NSString *hatenaComment;

%hook UITextField
- (id)_text
{
	filedText = %orig;
	return filedText;
}
%end

%hook RKServiceMessage
- (void)share:(RKShareObject *)arg1
{
	if (!isHatena) return %orig;
	if (choice == 0) {
		[%c(RSAlert) presentInput:nil withTitle:@"Send to HatenaBookmark" placeholder:@"Comment [Tag]" description:nil buttonTitle:@"Send" cancelButtonTitle:@"Cancel" handler:^{
			[self postHatenaWtihComment:filedText];
		}];
	} else if (choice == 1) [self postHatenaFromUrlScheme];
}

%new(v@:@)
- (void)postHatenaWtihComment:(NSString *)comment
{
    if ([hatenaUsername isEqualToString:@""] || [hatenaPassword isEqualToString:@""])
    	return [%c(RSAlert) presentWithTitle:@"Error" message:@"Please Login HatenaBookmark! You can configure options from Setting.app." buttonTitle:@"OK" handler:^{}];
    [DCWSSE wsseString:hatenaUsername password:hatenaPassword];
    DCHatenaClient *hatenaClient = [[DCHatenaClient alloc] initWithUsername:hatenaUsername password:hatenaPassword];
	// hatenaClient.delegate = [[[DCAtomPubDelegate alloc] init] autorelease];
	comment = [NSString stringWithFormat:@"%@ %@", comment, hatenaComment];
	[hatenaClient post:_url comment:comment];

	BezelPanel *bezel = [%c(BezelPanel) bezelWithSize:55 image:[UIImage imageWithContentsOfFile:@"/Library/Application Support/ReederEnhancer/Bookmark.png"] text:@"Hatena B!"];
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	[bezel flashInView:window.rootViewController.view direction:1];
}

%new(v@:)
- (void)postHatenaFromUrlScheme
{
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"hatenabookmark://"]]) {
        NSString *url = [NSString stringWithFormat:@"hatenabookmark:/entry?title=%@&url=%@&backtitle=%@&backurl=%@", _title, _url, @"Reeder", @"reeder://"];
        NSURL *webStringURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        SharePanel *sharePanel = [[%c(SharePanel) alloc] init];
        [sharePanel close:YES];
		[[UIApplication sharedApplication] openURL:webStringURL];
    } else {
    	[%c(RSAlert) presentWithTitle:@"Error" message:@"Please install HatenaBookmark.app!" buttonTitle:@"OK" handler:^{}];
    }
}
%end

%hook ShareButton
- (id)image
{
	if (!isHatena) return %orig;
	id image_ = %orig;
	if ([previousTitle isEqualToString:@"Hatena B!"])
		image_ = [UIImage imageWithContentsOfFile:@"/Library/Application Support/ReederEnhancer/Bookmark.png"];
	return image_;
}

- (id)title
{
	if (!isHatena) return %orig;
	id title_ = %orig;
	if ([title_ isEqualToString:@"Message"])
		title_ = @"Hatena B!";
	previousTitle = title_;
	return title_;
}
%end

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
- (void)share:(RKShareObject *)arg1
{
	if (!isShare) return %orig;
	NSString *cStr = [format stringByReplacingOccurrencesOfString:M_TITLE withString:_title];
	cStr = [cStr stringByReplacingOccurrencesOfString:M_SOURCE withString:_srcTitle];

	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	id viewController = window.rootViewController;

	TWTweetComposeViewController *twitterPostVC = [[TWTweetComposeViewController alloc] init];
	[twitterPostVC setInitialText:cStr];
	[twitterPostVC addURL:[NSURL URLWithString:_url]];
	[viewController presentViewController:twitterPostVC animated:YES completion:^{
		UITextView *textView = (UITextView *)[[[UIApplication sharedApplication] keyWindow] findFirstResponder];
		textView.selectedRange = NSMakeRange(0, 0);
	}];
}
%end

%hook RKServiceFacebook
- (void)share:(RKShareObject *)arg1
{
	if (!isShare) return %orig;
	NSString *cStr = [format stringByReplacingOccurrencesOfString:M_TITLE withString:_title];
	cStr = [cStr stringByReplacingOccurrencesOfString:M_SOURCE withString:_srcTitle];

	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	id viewController = window.rootViewController;

	SLComposeViewController *facebookPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];    
	[facebookPostVC setInitialText:cStr];
	[facebookPostVC addURL:[NSURL URLWithString:_url]];
	[viewController presentViewController:facebookPostVC animated:YES completion:^{
		UITextView *textView = (UITextView *)[[[UIApplication sharedApplication] keyWindow] findFirstResponder];
		textView.selectedRange = NSMakeRange(0, 0);
    }];
}
%end

@interface RKServiceMailLink <MFMailComposeViewControllerDelegate>
@end

%hook RKServiceMailLink
- (void)share:(id)arg1
{
	if (!isShare) return %orig;
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	NSDictionary *recipients = [ud dictionaryForKey:@"ShareRKServiceMail"];
	NSString *address = [recipients objectForKey:@"EmailLink"];

	NSString *body = [formatBody stringByReplacingOccurrencesOfString:M_TITLE withString:_title];
	body = [body stringByReplacingOccurrencesOfString:M_SOURCE withString:_srcTitle];
	body = [body stringByReplacingOccurrencesOfString:M_URL withString:_url];

	NSString *subject = [formatSubject stringByReplacingOccurrencesOfString:M_TITLE withString:_title];
	subject = [subject stringByReplacingOccurrencesOfString:M_SOURCE withString:_srcTitle];
	subject = [subject stringByReplacingOccurrencesOfString:M_URL withString:_url];

	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	id viewController = window.rootViewController;

	MFMailComposeViewController *mailPostVC = [[MFMailComposeViewController alloc] init];
	mailPostVC.mailComposeDelegate = self;
	[mailPostVC setMessageBody:body isHTML:YES];
	[mailPostVC setSubject:subject];
	[mailPostVC setToRecipients:[NSArray arrayWithObjects:address, nil]];
	[viewController presentModalViewController:mailPostVC animated:YES];
	[mailPostVC release];
}
%end

@interface RSForm
@property(copy) NSString * quote;
@end

static BOOL isDeprecation;

%hook RSForm
- (NSString *)text
{
	if (!isShare || !isDeprecation) return %orig;
	NSString *cStr = [format stringByReplacingOccurrencesOfString:M_TITLE withString:_title];
	cStr = [cStr stringByReplacingOccurrencesOfString:M_SOURCE withString:_srcTitle];
	if (!self.quote || [self.quote isEqualToString:NULL]) cStr = [cStr stringByAppendingString:[NSString stringWithFormat:@" %@", _url]];
	return cStr;
}
%end

static void LoadSettings()
{
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:PREF_PATH];
	id existRefresh = [dict objectForKey:@"NoRefresh"];
	isRefresh = existRefresh ? [existRefresh boolValue] : YES;
	id existAskToSend = [dict objectForKey:@"AskToSend"];
	isAskToSend = existAskToSend ? [existAskToSend boolValue] : YES;
	id existHatena = [dict objectForKey:@"IsHatena"];
	isHatena = existHatena ? [existHatena boolValue] : NO;
	id existFormat = [dict objectForKey:@"Format"];
    format = existFormat ? [existFormat copy] : @"\"_TITLE_ | _SOURCE_\"";
	id existFormatBody = [dict objectForKey:@"FormatBody"];
    formatBody = existFormatBody ? [existFormatBody copy] : @"\"_TITLE_ | _SOURCE_\"<br />_URL_";
	id existFormatSubject = [dict objectForKey:@"FormatSubject"];
    formatSubject = existFormatSubject ? [existFormatSubject copy] : @"[RSS] _TITLE_ | _SOURCE_\"";
    id existChoice = [dict objectForKey:@"Choice"];
    choice = existChoice ? [existChoice intValue] : 0;
    id existUsername = [dict objectForKey:@"HatenaUsername"];
    hatenaUsername = existUsername ? [existUsername copy] : @"";
    id existPassword = [dict objectForKey:@"HatenaPassword"];
    hatenaPassword = existPassword ? [existPassword copy] : @"";
    id existComment = [dict objectForKey:@"DefaultComment"];
    hatenaComment = existComment ? [existComment copy] : @"";

	id existDeprecation = [dict objectForKey:@"Deprecation"];
	isDeprecation = existDeprecation ? [existDeprecation boolValue] : NO;
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
