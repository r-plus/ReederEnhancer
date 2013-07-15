#line 1 "Tweak.xm"
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


#pragma mark -
#pragma mark Format (Twitter, Facebook)

static NSString *_title;
static NSString *_srcTitle;
static NSString *_url;
static BOOL moveToTop;
static NSString *format;
static BOOL isShare = NO;


@interface UIView (FindFirstResponder)
- (UIView *)findFirstResponder;
@end

@implementation UIView (FindFirstResponder)

- (UIView *)findFirstResponder {
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


@interface RKShareObject : NSObject
+ (id)shareObjectWithItem:(id)item;
- (id)item;
- (NSString *)srcTitle;
- (NSString *)title;
- (NSString *)url;
- (NSString *)summary;
- (NSString *)content;
@end

#include <logos/logos.h>
#include <substrate.h>
@class BezelPanel; @class ShareButton; @class ArticleViewController; @class SharePanel; @class RKServiceMessage; @class AppDelegate; @class TableViewController; @class Reachability; @class ShareController; @class RSForm; @class RSAlert; @class SubscriptionsViewController; @class RKServiceFacebook; @class RKShareObject; @class ItemsViewController; @class RKServiceTwitter; @class RKUser; @class RKServiceMailLink; @class UITextField; 
static void (*_logos_orig$_ungrouped$ShareController$share$inView$above$fromFrame$)(ShareController*, SEL, id, id, id, struct CGRect); static void _logos_method$_ungrouped$ShareController$share$inView$above$fromFrame$(ShareController*, SEL, id, id, id, struct CGRect); static void (*_logos_orig$_ungrouped$ArticleViewController$share$)(ArticleViewController*, SEL, id); static void _logos_method$_ungrouped$ArticleViewController$share$(ArticleViewController*, SEL, id); static void (*_logos_orig$_ungrouped$SharePanel$close$)(SharePanel*, SEL, BOOL); static void _logos_method$_ungrouped$SharePanel$close$(SharePanel*, SEL, BOOL); static void (*_logos_orig$_ungrouped$SharePanel$tapClose$)(SharePanel*, SEL, id); static void _logos_method$_ungrouped$SharePanel$tapClose$(SharePanel*, SEL, id); static void (*_logos_orig$_ungrouped$RKServiceTwitter$share$)(RKServiceTwitter*, SEL, RKShareObject *); static void _logos_method$_ungrouped$RKServiceTwitter$share$(RKServiceTwitter*, SEL, RKShareObject *); static void _logos_method$_ungrouped$RKServiceTwitter$handleKeyboardWillShow$(RKServiceTwitter*, SEL, NSNotification *); static void (*_logos_orig$_ungrouped$RKServiceFacebook$share$)(RKServiceFacebook*, SEL, RKShareObject *); static void _logos_method$_ungrouped$RKServiceFacebook$share$(RKServiceFacebook*, SEL, RKShareObject *); static NSString * (*_logos_orig$_ungrouped$RSForm$text)(RSForm*, SEL); static NSString * _logos_method$_ungrouped$RSForm$text(RSForm*, SEL); static void (*_logos_orig$_ungrouped$RKServiceMailLink$share$)(RKServiceMailLink*, SEL, id); static void _logos_method$_ungrouped$RKServiceMailLink$share$(RKServiceMailLink*, SEL, id); static BOOL (*_logos_orig$_ungrouped$SubscriptionsViewController$hasRefreshView)(SubscriptionsViewController*, SEL); static BOOL _logos_method$_ungrouped$SubscriptionsViewController$hasRefreshView(SubscriptionsViewController*, SEL); static BOOL (*_logos_orig$_ungrouped$TableViewController$hasRefreshView)(TableViewController*, SEL); static BOOL _logos_method$_ungrouped$TableViewController$hasRefreshView(TableViewController*, SEL); static BOOL (*_logos_orig$_ungrouped$ItemsViewController$hasRefreshView)(ItemsViewController*, SEL); static BOOL _logos_method$_ungrouped$ItemsViewController$hasRefreshView(ItemsViewController*, SEL); static void (*_logos_orig$_ungrouped$ItemsViewController$tableView$didTriggerRightSliderForCell$atIndexPath$)(ItemsViewController*, SEL, id, id, id); static void _logos_method$_ungrouped$ItemsViewController$tableView$didTriggerRightSliderForCell$atIndexPath$(ItemsViewController*, SEL, id, id, id); static void (*_logos_orig$_ungrouped$ItemsViewController$tableView$didTriggerLeftSliderForCell$atIndexPath$)(ItemsViewController*, SEL, id, id, id); static void _logos_method$_ungrouped$ItemsViewController$tableView$didTriggerLeftSliderForCell$atIndexPath$(ItemsViewController*, SEL, id, id, id); static id (*_logos_orig$_ungrouped$ItemsViewController$tableView$rightSliderIconForCell$atIndexPath$)(ItemsViewController*, SEL, id, id, id); static id _logos_method$_ungrouped$ItemsViewController$tableView$rightSliderIconForCell$atIndexPath$(ItemsViewController*, SEL, id, id, id); static id (*_logos_orig$_ungrouped$ItemsViewController$tableView$leftSliderIconForCell$atIndexPath$)(ItemsViewController*, SEL, id, id, id); static id _logos_method$_ungrouped$ItemsViewController$tableView$leftSliderIconForCell$atIndexPath$(ItemsViewController*, SEL, id, id, id); static id (*_logos_orig$_ungrouped$UITextField$_text)(UITextField*, SEL); static id _logos_method$_ungrouped$UITextField$_text(UITextField*, SEL); static void (*_logos_orig$_ungrouped$RKServiceMessage$share$)(RKServiceMessage*, SEL, RKShareObject *); static void _logos_method$_ungrouped$RKServiceMessage$share$(RKServiceMessage*, SEL, RKShareObject *); static void _logos_method$_ungrouped$RKServiceMessage$postHatenaWtihComment$(RKServiceMessage*, SEL, NSString *); static void _logos_method$_ungrouped$RKServiceMessage$postHatenaFromUrlScheme(RKServiceMessage*, SEL); static id (*_logos_orig$_ungrouped$ShareButton$image)(ShareButton*, SEL); static id _logos_method$_ungrouped$ShareButton$image(ShareButton*, SEL); static id (*_logos_orig$_ungrouped$ShareButton$title)(ShareButton*, SEL); static id _logos_method$_ungrouped$ShareButton$title(ShareButton*, SEL); static void (*_logos_orig$_ungrouped$RKUser$setSyncStatusText$)(RKUser*, SEL, NSString *); static void _logos_method$_ungrouped$RKUser$setSyncStatusText$(RKUser*, SEL, NSString *); static void _logos_method$_ungrouped$AppDelegate$application$didReceiveLocalNotification$(AppDelegate*, SEL, UIApplication *, UILocalNotification *); static void (*_logos_orig$_ungrouped$AppDelegate$applicationDidBecomeActive$)(AppDelegate*, SEL, id); static void _logos_method$_ungrouped$AppDelegate$applicationDidBecomeActive$(AppDelegate*, SEL, id); 
static __inline__ __attribute__((always_inline)) Class _logos_static_class_lookup$SharePanel(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SharePanel"); } return _klass; }static __inline__ __attribute__((always_inline)) Class _logos_static_class_lookup$BezelPanel(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("BezelPanel"); } return _klass; }static __inline__ __attribute__((always_inline)) Class _logos_static_class_lookup$Reachability(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("Reachability"); } return _klass; }static __inline__ __attribute__((always_inline)) Class _logos_static_class_lookup$RKShareObject(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("RKShareObject"); } return _klass; }static __inline__ __attribute__((always_inline)) Class _logos_static_class_lookup$RSAlert(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("RSAlert"); } return _klass; }
#line 61 "Tweak.xm"


static void _logos_method$_ungrouped$ShareController$share$inView$above$fromFrame$(ShareController* self, SEL _cmd, id arg1, id arg2, id arg3, struct CGRect arg4) {
	_logos_orig$_ungrouped$ShareController$share$inView$above$fromFrame$(self, _cmd, arg1, arg2, arg3, arg4);
	id item = [_logos_static_class_lookup$RKShareObject() shareObjectWithItem:[arg1 item]];
	_title = [item title];
	_srcTitle = [item srcTitle];
	_url = (NSString *)[item url];
}




static void _logos_method$_ungrouped$ArticleViewController$share$(ArticleViewController* self, SEL _cmd, id arg1) {
	_logos_orig$_ungrouped$ArticleViewController$share$(self, _cmd, arg1);
	isShare = YES;
}



@interface SharePanel
- (void)close:(BOOL)arg1;
@end



static void _logos_method$_ungrouped$SharePanel$close$(SharePanel* self, SEL _cmd, BOOL arg1) {
	_logos_orig$_ungrouped$SharePanel$close$(self, _cmd, arg1);
	isShare = NO;
}

static void _logos_method$_ungrouped$SharePanel$tapClose$(SharePanel* self, SEL _cmd, id arg1) {
	_logos_orig$_ungrouped$SharePanel$tapClose$(self, _cmd, arg1);
	isShare = NO;
}



@interface RKServiceTwitter
- (void)handleKeyboardWillShow:(NSNotification *)notification;
@end



static void _logos_method$_ungrouped$RKServiceTwitter$share$(RKServiceTwitter* self, SEL _cmd, RKShareObject * arg1) {
	if (!isShare) return _logos_orig$_ungrouped$RKServiceTwitter$share$(self, _cmd, arg1);
	NSString *cStr = [format stringByReplacingOccurrencesOfString:M_TITLE withString:_title];
	cStr = [cStr stringByReplacingOccurrencesOfString:M_SOURCE withString:_srcTitle];
	if (cStr.length > 140) cStr = [cStr substringWithRange:NSMakeRange(0, 140)];

	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	id viewController = window.rootViewController;

	if (moveToTop) [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

	if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_6_0) {
		SLComposeViewController *twitterPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
		[twitterPostVC setInitialText:cStr];
		[twitterPostVC addURL:[NSURL URLWithString:_url]];
		[viewController presentViewController:twitterPostVC animated:YES completion:nil];
	} else if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_5_0) {
		TWTweetComposeViewController *twitterPostVC = [[TWTweetComposeViewController alloc] init];
		[twitterPostVC setInitialText:cStr];
		[twitterPostVC addURL:[NSURL URLWithString:_url]];
		[viewController presentModalViewController:twitterPostVC animated:YES];
	}
}



static void _logos_method$_ungrouped$RKServiceTwitter$handleKeyboardWillShow$(RKServiceTwitter* self, SEL _cmd, NSNotification * notification) {
	UITextView *textView = (UITextView *)[[[UIApplication sharedApplication] keyWindow] findFirstResponder];
	[textView setSelectedRange:NSMakeRange(0, 0)];
}




static void _logos_method$_ungrouped$RKServiceFacebook$share$(RKServiceFacebook* self, SEL _cmd, RKShareObject * arg1) {
	if (!isShare) return _logos_orig$_ungrouped$RKServiceFacebook$share$(self, _cmd, arg1);
	NSString *cStr = [format stringByReplacingOccurrencesOfString:M_TITLE withString:_title];
	cStr = [cStr stringByReplacingOccurrencesOfString:M_SOURCE withString:_srcTitle];

	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	id viewController = window.rootViewController;

	SLComposeViewController *facebookPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];    
	[facebookPostVC setInitialText:cStr];
	[facebookPostVC addURL:[NSURL URLWithString:_url]];
	[viewController presentViewController:facebookPostVC animated:YES completion:nil];
}



#pragma mark Format (App.net, Buffer, etc.)

static BOOL isDeprecation;


@interface RSForm
@property(copy) NSString * quote;
@end



static NSString * _logos_method$_ungrouped$RSForm$text(RSForm* self, SEL _cmd) {
	if (!isShare || !isDeprecation) return _logos_orig$_ungrouped$RSForm$text(self, _cmd);
	NSString *cStr = [format stringByReplacingOccurrencesOfString:M_TITLE withString:_title];
	cStr = [cStr stringByReplacingOccurrencesOfString:M_SOURCE withString:_srcTitle];
	if (!self.quote || [self.quote isEqualToString:NULL]) cStr = [cStr stringByAppendingString:[NSString stringWithFormat:@" %@", _url]];
	return cStr;
}



#pragma mark Format (Mail Link)

static NSString *formatBody;
static NSString *formatSubject;
static BOOL isHTML;


@interface RKServiceMailLink <MFMailComposeViewControllerDelegate>
@end



static void _logos_method$_ungrouped$RKServiceMailLink$share$(RKServiceMailLink* self, SEL _cmd, id arg1) {
	if (!isShare) return _logos_orig$_ungrouped$RKServiceMailLink$share$(self, _cmd, arg1);
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
	[mailPostVC setMessageBody:body isHTML:isHTML];
	[mailPostVC setSubject:subject];
	[mailPostVC setToRecipients:[NSArray arrayWithObjects:address, nil]];
	[viewController presentModalViewController:mailPostVC animated:YES];
	[mailPostVC release];
}




#pragma mark -
#pragma mark Disable "Pull to Refresh"

static BOOL isRefresh;



static BOOL _logos_method$_ungrouped$SubscriptionsViewController$hasRefreshView(SubscriptionsViewController* self, SEL _cmd) {
	if (isRefresh) return NO;
	else return _logos_orig$_ungrouped$SubscriptionsViewController$hasRefreshView(self, _cmd);
}




static BOOL _logos_method$_ungrouped$TableViewController$hasRefreshView(TableViewController* self, SEL _cmd) {
	if (isRefresh) return NO;
	else return _logos_orig$_ungrouped$TableViewController$hasRefreshView(self, _cmd);
}




static BOOL _logos_method$_ungrouped$ItemsViewController$hasRefreshView(ItemsViewController* self, SEL _cmd) {
	if (isRefresh) return NO;
	else return _logos_orig$_ungrouped$ItemsViewController$hasRefreshView(self, _cmd);
}




#pragma mark -
#pragma mark Ask to send

static BOOL isAskToSend;


@interface BezelPanel
+ (id)bezelWithSize:(int)arg1 image:(id)arg2 text:(id)arg3;
- (void)flashInView:(id)arg1 direction:(int)arg2;
@end

@interface RSAlert : NSObject
+ (void)presentInput:(id)arg1 withTitle:(id)arg2 placeholder:(id)arg3 description:(id)arg4 buttonTitle:(id)arg5 cancelButtonTitle:(id)arg6 handler:(id)arg7;
+ (void)presentSheetWithTitle:(id)arg1 buttonTitle:(id)arg2 cancelButtonTitle:(id)arg3 handler:(id)arg4;
+ (void)presentWithImage:(id)arg1 buttonTitle:(id)arg2 handler:(id)arg3;
+ (void)presentWithTitle:(id)arg1 message:(id)arg2 buttonTitle:(id)arg3 handler:(id)arg4;
+ (void)presentSheetWithTitle:(id)arg1 buttonTitle:(id)arg2 handler:(id)arg3;
@end



static void _logos_method$_ungrouped$ItemsViewController$tableView$didTriggerRightSliderForCell$atIndexPath$(ItemsViewController* self, SEL _cmd, id arg1, id arg2, id arg3) {
	if (!isAskToSend) return _logos_orig$_ungrouped$ItemsViewController$tableView$didTriggerRightSliderForCell$atIndexPath$(self, _cmd, arg1, arg2, arg3);
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	NSString *action = [ud stringForKey:@"AppSlideLeftAction"];
	if ([action isEqualToString:@"NoAction"] || [action isEqualToString:@"ToggleStarred"] || [action isEqualToString:@"ToggleRead"]) return _logos_orig$_ungrouped$ItemsViewController$tableView$didTriggerRightSliderForCell$atIndexPath$(self, _cmd, arg1, arg2, arg3);
	UIImage *image = [[UIImage alloc] init];
	if ([action isEqualToString:@"Readability"]) image = [UIImage imageNamed:@"ShareRKServiceReadability"];
	else if ([action isEqualToString:@"Instapaper"]) image = [UIImage imageNamed:@"ShareRKServiceInstapaper"];
	else if ([action isEqualToString:@"Pocket"]) image = [UIImage imageNamed:@"ShareRKServiceReadItLater"];
	else if ([action isEqualToString:@"QuoteFMRead"]) { action = @"QUOTE.fm";  image = [UIImage imageNamed:@"ShareRKServiceQuoteFMRead"]; }
	[_logos_static_class_lookup$RSAlert() presentSheetWithTitle:[NSString stringWithFormat:@"Are you sure you want to send %@?", action] buttonTitle:[NSString stringWithFormat:@"Send to %@", action] cancelButtonTitle:@"Cancel" handler:^{
		_logos_orig$_ungrouped$ItemsViewController$tableView$didTriggerRightSliderForCell$atIndexPath$(self, _cmd, arg1, arg2, arg3);
		BezelPanel *bezel = [_logos_static_class_lookup$BezelPanel() bezelWithSize:55 image:image text:action];
		UIWindow *window = [UIApplication sharedApplication].keyWindow;
		[bezel flashInView:window.rootViewController.view direction:1];
	}];
}


static void _logos_method$_ungrouped$ItemsViewController$tableView$didTriggerLeftSliderForCell$atIndexPath$(ItemsViewController* self, SEL _cmd, id arg1, id arg2, id arg3) {
	if (!isAskToSend) return _logos_orig$_ungrouped$ItemsViewController$tableView$didTriggerLeftSliderForCell$atIndexPath$(self, _cmd, arg1, arg2, arg3);
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	NSString *action = [ud stringForKey:@"AppSlideRightAction"];
	if ([action isEqualToString:@"NoAction"] || [action isEqualToString:@"ToggleStarred"] || [action isEqualToString:@"ToggleRead"]) return _logos_orig$_ungrouped$ItemsViewController$tableView$didTriggerLeftSliderForCell$atIndexPath$(self, _cmd, arg1, arg2, arg3);
	UIImage *image = [[UIImage alloc] init];
	if ([action isEqualToString:@"Readability"]) image = [UIImage imageNamed:@"ShareRKServiceReadability"];
	else if ([action isEqualToString:@"Instapaper"]) image = [UIImage imageNamed:@"ShareRKServiceInstapaper"];
	else if ([action isEqualToString:@"Pocket"]) image = [UIImage imageNamed:@"ShareRKServiceReadItLater"];
	else if ([action isEqualToString:@"QuoteFMRead"]) { action = @"QUOTE.fm";  image = [UIImage imageNamed:@"ShareRKServiceQuoteFMRead"]; }
	[_logos_static_class_lookup$RSAlert() presentSheetWithTitle:[NSString stringWithFormat:@"Are you sure you want to send %@?", action] buttonTitle:[NSString stringWithFormat:@"Send to %@", action] cancelButtonTitle:@"Cancel" handler:^{
		_logos_orig$_ungrouped$ItemsViewController$tableView$didTriggerLeftSliderForCell$atIndexPath$(self, _cmd, arg1, arg2, arg3);
		BezelPanel *bezel = [_logos_static_class_lookup$BezelPanel() bezelWithSize:55 image:image text:action];
		UIWindow *window = [UIApplication sharedApplication].keyWindow;
		[bezel flashInView:window.rootViewController.view direction:1];
	}];
}


static id _logos_method$_ungrouped$ItemsViewController$tableView$rightSliderIconForCell$atIndexPath$(ItemsViewController* self, SEL _cmd, id arg1, id arg2, id arg3) {
	if (!isAskToSend) return _logos_orig$_ungrouped$ItemsViewController$tableView$rightSliderIconForCell$atIndexPath$(self, _cmd, arg1, arg2, arg3);
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	NSString *action = [ud stringForKey:@"AppSlideRightAction"];
	if ([action isEqualToString:@"NoAction"] || [action isEqualToString:@"ToggleStarred"] || [action isEqualToString:@"ToggleRead"]) return _logos_orig$_ungrouped$ItemsViewController$tableView$rightSliderIconForCell$atIndexPath$(self, _cmd, arg1, arg2, arg3);
	else return NULL;
}


static id _logos_method$_ungrouped$ItemsViewController$tableView$leftSliderIconForCell$atIndexPath$(ItemsViewController* self, SEL _cmd, id arg1, id arg2, id arg3) {
	if (!isAskToSend) return _logos_orig$_ungrouped$ItemsViewController$tableView$leftSliderIconForCell$atIndexPath$(self, _cmd, arg1, arg2, arg3);
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	NSString *action = [ud stringForKey:@"AppSlideRightAction"];
	if ([action isEqualToString:@"NoAction"] || [action isEqualToString:@"ToggleStarred"] || [action isEqualToString:@"ToggleRead"]) return _logos_orig$_ungrouped$ItemsViewController$tableView$leftSliderIconForCell$atIndexPath$(self, _cmd, arg1, arg2, arg3);
	else return NULL;
}




#pragma mark -
#pragma mark Add HatenaBookmark action

static BOOL isHatena;
static NSString *previousTitle;


@interface RKServiceMessage
- (void)postHatenaWtihComment:(NSString *)comment;
- (void)postHatenaFromUrlScheme;
- (void)handleKeyboardWillShow:(NSNotification *)notification;
@end

@interface Reachability
+ (id)reachabilityForInternetConnection;
- (int)currentReachabilityStatus;
@end

static inline void Response(NSString *res)
{
	NSLog(@"Response: %@", res);
	if ([res isEqualToString:@"401 Unauthorized"]) {
		[_logos_static_class_lookup$RSAlert() presentWithTitle:res message:@"Incorrect username or password." buttonTitle:@"OK" handler:nil];
	} else if ([res isEqualToString:@"400 Bad Request"]) {
		[_logos_static_class_lookup$RSAlert() presentWithTitle:res message:@"Please try again after a while." buttonTitle:@"OK" handler:nil];
	} else {
		BezelPanel *bezel = [_logos_static_class_lookup$BezelPanel() bezelWithSize:55 image:[UIImage imageWithContentsOfFile:@"/Library/Application Support/ReederEnhancer/Bookmark.png"] text:@"Hatena B!"];
		UIWindow *window = [UIApplication sharedApplication].keyWindow;
		[bezel flashInView:window.rootViewController.view direction:1];
	}
}


@interface AtomPubDelegate : NSObject <DCAtomPubDelegate> {}
@end

@implementation AtomPubDelegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection data:(NSData *)data {
	NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	Response(responseBody);
}
@end

static NSString *filedText;
static int choice;
static NSString *hatenaUsername;
static NSString *hatenaPassword;
static NSString *hatenaComment;

typedef enum {
	NotReachable = 0,
	ReachableViaWiFi,
	ReachableViaWWAN
} NetworkStatus;




static id _logos_method$_ungrouped$UITextField$_text(UITextField* self, SEL _cmd) {
	filedText = _logos_orig$_ungrouped$UITextField$_text(self, _cmd);
	return filedText;
}




static void _logos_method$_ungrouped$RKServiceMessage$share$(RKServiceMessage* self, SEL _cmd, RKShareObject * arg1) {
	if (!isHatena) return _logos_orig$_ungrouped$RKServiceMessage$share$(self, _cmd, arg1);
	if (choice == 0) {
		if ([hatenaUsername isEqualToString:@""] || [hatenaPassword isEqualToString:@""])
			return [_logos_static_class_lookup$RSAlert() presentWithTitle:@"Error!" message:@"Please Login HatenaBookmark! You can configure options from Setting.app." buttonTitle:@"OK" handler:nil];
		[_logos_static_class_lookup$RSAlert() presentInput:hatenaComment withTitle:@"Send to HatenaBookmark" placeholder:@"Comment [Tag]" description:nil buttonTitle:@"Send" cancelButtonTitle:@"Cancel" handler:^{
			Reachability *curReach = [_logos_static_class_lookup$Reachability() reachabilityForInternetConnection];
			NetworkStatus netStatus = (NetworkStatus)[curReach currentReachabilityStatus];
			switch (netStatus) {
				case NotReachable:
					[_logos_static_class_lookup$RSAlert() presentWithTitle:@"Error!" message:@"Reeder cannot send to HatneBookmark because it is not connected to the Internet." buttonTitle:@"OK" handler:nil];
					break;
				case ReachableViaWWAN:
				case ReachableViaWiFi:
					[self postHatenaWtihComment:filedText];
					break;
				default:
					break;
			}
		}];
	} else if (choice == 1) [self postHatenaFromUrlScheme];
}



static void _logos_method$_ungrouped$RKServiceMessage$postHatenaWtihComment$(RKServiceMessage* self, SEL _cmd, NSString * comment) {
    [DCWSSE wsseString:hatenaUsername password:hatenaPassword];
    DCHatenaClient *hatenaClient = [[DCHatenaClient alloc] initWithUsername:hatenaUsername password:hatenaPassword];
	hatenaClient.delegate = [[[AtomPubDelegate alloc] init] autorelease];
	_url = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)_url, NULL,  (CFStringRef)@"&=-#", kCFStringEncodingUTF8);
	[hatenaClient post:_url comment:comment];
}



static void _logos_method$_ungrouped$RKServiceMessage$postHatenaFromUrlScheme(RKServiceMessage* self, SEL _cmd) {
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"hatenabookmark://"]]) {
		NSString *url = [NSString stringWithFormat:@"hatenabookmark:/entry?title=%@&url=%@&backtitle=%@&backurl=%@", _title, _url, @"Reeder", @"reeder://"];
		NSURL *webStringURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		SharePanel *sharePanel = [[_logos_static_class_lookup$SharePanel() alloc] init];
		[sharePanel close:YES];
		[[UIApplication sharedApplication] openURL:webStringURL];
	} else {
		[_logos_static_class_lookup$RSAlert() presentWithTitle:@"Error!" message:@"Please install HatenaBookmark.app!" buttonTitle:@"OK" handler:^{}];
	}
}




static id _logos_method$_ungrouped$ShareButton$image(ShareButton* self, SEL _cmd) {
	if (!isHatena) return _logos_orig$_ungrouped$ShareButton$image(self, _cmd);
	id image_ = _logos_orig$_ungrouped$ShareButton$image(self, _cmd);
	if ([previousTitle isEqualToString:@"Hatena B!"])
		image_ = [UIImage imageWithContentsOfFile:@"/Library/Application Support/ReederEnhancer/Bookmark.png"];
	return image_;
}


static id _logos_method$_ungrouped$ShareButton$title(ShareButton* self, SEL _cmd) {
	if (!isHatena) return _logos_orig$_ungrouped$ShareButton$title(self, _cmd);
	id title_ = _logos_orig$_ungrouped$ShareButton$title(self, _cmd);
	if ([title_ isEqualToString:@"Message"])
		title_ = @"Hatena B!";
	previousTitle = title_;
	return title_;
}




#pragma mark -
#pragma mark Sync Notification

static NSString *previousSyncStatusText;



static void _logos_method$_ungrouped$RKUser$setSyncStatusText$(RKUser* self, SEL _cmd, NSString * text) {
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
	_logos_orig$_ungrouped$RKUser$setSyncStatusText$(self, _cmd, text);
}





static void _logos_method$_ungrouped$AppDelegate$application$didReceiveLocalNotification$(AppDelegate* self, SEL _cmd, UIApplication * application, UILocalNotification * notification) {
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
}


static void _logos_method$_ungrouped$AppDelegate$applicationDidBecomeActive$(AppDelegate* self, SEL _cmd, id arg1) {
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
	_logos_orig$_ungrouped$AppDelegate$applicationDidBecomeActive$(self, _cmd, arg1);
}



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
	formatBody = existFormatBody ? [existFormatBody copy] : @"\"_TITLE_ | _SOURCE_\"<br /><br />_URL_";
	id existFormatSubject = [dict objectForKey:@"FormatSubject"];
	formatSubject = existFormatSubject ? [existFormatSubject copy] : @"[RSS] _TITLE_ | _SOURCE_";
	id existChoice = [dict objectForKey:@"Choice"];
	choice = existChoice ? [existChoice intValue] : 0;
	id existUsername = [dict objectForKey:@"HatenaUsername"];
	hatenaUsername = existUsername ? [existUsername copy] : @"";
	id existPassword = [dict objectForKey:@"HatenaPassword"];
	hatenaPassword = existPassword ? [existPassword copy] : @"";
	id existComment = [dict objectForKey:@"DefaultComment"];
	hatenaComment = existComment ? [existComment copy] : @"[Reeder]";
	id existIsHTML = [dict objectForKey:@"IsHTML"];
	isHTML = existIsHTML ? [existIsHTML boolValue] : YES;
	id existMoveToTop = [dict objectForKey:@"CaretMoveToTop"];
	moveToTop = existMoveToTop ? [existMoveToTop boolValue] : YES;

	id existDeprecation = [dict objectForKey:@"Deprecation"];
	isDeprecation = existDeprecation ? [existDeprecation boolValue] : NO;
}

static void PostNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	LoadSettings();
}

static __attribute__((constructor)) void _logosLocalCtor_9b72e31d()
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	{Class _logos_class$_ungrouped$ShareController = objc_getClass("ShareController"); MSHookMessageEx(_logos_class$_ungrouped$ShareController, @selector(share:inView:above:fromFrame:), (IMP)&_logos_method$_ungrouped$ShareController$share$inView$above$fromFrame$, (IMP*)&_logos_orig$_ungrouped$ShareController$share$inView$above$fromFrame$);Class _logos_class$_ungrouped$ArticleViewController = objc_getClass("ArticleViewController"); MSHookMessageEx(_logos_class$_ungrouped$ArticleViewController, @selector(share:), (IMP)&_logos_method$_ungrouped$ArticleViewController$share$, (IMP*)&_logos_orig$_ungrouped$ArticleViewController$share$);Class _logos_class$_ungrouped$SharePanel = objc_getClass("SharePanel"); MSHookMessageEx(_logos_class$_ungrouped$SharePanel, @selector(close:), (IMP)&_logos_method$_ungrouped$SharePanel$close$, (IMP*)&_logos_orig$_ungrouped$SharePanel$close$);MSHookMessageEx(_logos_class$_ungrouped$SharePanel, @selector(tapClose:), (IMP)&_logos_method$_ungrouped$SharePanel$tapClose$, (IMP*)&_logos_orig$_ungrouped$SharePanel$tapClose$);Class _logos_class$_ungrouped$RKServiceTwitter = objc_getClass("RKServiceTwitter"); MSHookMessageEx(_logos_class$_ungrouped$RKServiceTwitter, @selector(share:), (IMP)&_logos_method$_ungrouped$RKServiceTwitter$share$, (IMP*)&_logos_orig$_ungrouped$RKServiceTwitter$share$);{ const char *_typeEncoding = "v@:@"; class_addMethod(_logos_class$_ungrouped$RKServiceTwitter, @selector(handleKeyboardWillShow:), (IMP)&_logos_method$_ungrouped$RKServiceTwitter$handleKeyboardWillShow$, _typeEncoding); }Class _logos_class$_ungrouped$RKServiceFacebook = objc_getClass("RKServiceFacebook"); MSHookMessageEx(_logos_class$_ungrouped$RKServiceFacebook, @selector(share:), (IMP)&_logos_method$_ungrouped$RKServiceFacebook$share$, (IMP*)&_logos_orig$_ungrouped$RKServiceFacebook$share$);Class _logos_class$_ungrouped$RSForm = objc_getClass("RSForm"); MSHookMessageEx(_logos_class$_ungrouped$RSForm, @selector(text), (IMP)&_logos_method$_ungrouped$RSForm$text, (IMP*)&_logos_orig$_ungrouped$RSForm$text);Class _logos_class$_ungrouped$RKServiceMailLink = objc_getClass("RKServiceMailLink"); MSHookMessageEx(_logos_class$_ungrouped$RKServiceMailLink, @selector(share:), (IMP)&_logos_method$_ungrouped$RKServiceMailLink$share$, (IMP*)&_logos_orig$_ungrouped$RKServiceMailLink$share$);Class _logos_class$_ungrouped$SubscriptionsViewController = objc_getClass("SubscriptionsViewController"); MSHookMessageEx(_logos_class$_ungrouped$SubscriptionsViewController, @selector(hasRefreshView), (IMP)&_logos_method$_ungrouped$SubscriptionsViewController$hasRefreshView, (IMP*)&_logos_orig$_ungrouped$SubscriptionsViewController$hasRefreshView);Class _logos_class$_ungrouped$TableViewController = objc_getClass("TableViewController"); MSHookMessageEx(_logos_class$_ungrouped$TableViewController, @selector(hasRefreshView), (IMP)&_logos_method$_ungrouped$TableViewController$hasRefreshView, (IMP*)&_logos_orig$_ungrouped$TableViewController$hasRefreshView);Class _logos_class$_ungrouped$ItemsViewController = objc_getClass("ItemsViewController"); MSHookMessageEx(_logos_class$_ungrouped$ItemsViewController, @selector(hasRefreshView), (IMP)&_logos_method$_ungrouped$ItemsViewController$hasRefreshView, (IMP*)&_logos_orig$_ungrouped$ItemsViewController$hasRefreshView);MSHookMessageEx(_logos_class$_ungrouped$ItemsViewController, @selector(tableView:didTriggerRightSliderForCell:atIndexPath:), (IMP)&_logos_method$_ungrouped$ItemsViewController$tableView$didTriggerRightSliderForCell$atIndexPath$, (IMP*)&_logos_orig$_ungrouped$ItemsViewController$tableView$didTriggerRightSliderForCell$atIndexPath$);MSHookMessageEx(_logos_class$_ungrouped$ItemsViewController, @selector(tableView:didTriggerLeftSliderForCell:atIndexPath:), (IMP)&_logos_method$_ungrouped$ItemsViewController$tableView$didTriggerLeftSliderForCell$atIndexPath$, (IMP*)&_logos_orig$_ungrouped$ItemsViewController$tableView$didTriggerLeftSliderForCell$atIndexPath$);MSHookMessageEx(_logos_class$_ungrouped$ItemsViewController, @selector(tableView:rightSliderIconForCell:atIndexPath:), (IMP)&_logos_method$_ungrouped$ItemsViewController$tableView$rightSliderIconForCell$atIndexPath$, (IMP*)&_logos_orig$_ungrouped$ItemsViewController$tableView$rightSliderIconForCell$atIndexPath$);MSHookMessageEx(_logos_class$_ungrouped$ItemsViewController, @selector(tableView:leftSliderIconForCell:atIndexPath:), (IMP)&_logos_method$_ungrouped$ItemsViewController$tableView$leftSliderIconForCell$atIndexPath$, (IMP*)&_logos_orig$_ungrouped$ItemsViewController$tableView$leftSliderIconForCell$atIndexPath$);Class _logos_class$_ungrouped$UITextField = objc_getClass("UITextField"); MSHookMessageEx(_logos_class$_ungrouped$UITextField, @selector(_text), (IMP)&_logos_method$_ungrouped$UITextField$_text, (IMP*)&_logos_orig$_ungrouped$UITextField$_text);Class _logos_class$_ungrouped$RKServiceMessage = objc_getClass("RKServiceMessage"); MSHookMessageEx(_logos_class$_ungrouped$RKServiceMessage, @selector(share:), (IMP)&_logos_method$_ungrouped$RKServiceMessage$share$, (IMP*)&_logos_orig$_ungrouped$RKServiceMessage$share$);{ const char *_typeEncoding = "v@:@"; class_addMethod(_logos_class$_ungrouped$RKServiceMessage, @selector(postHatenaWtihComment:), (IMP)&_logos_method$_ungrouped$RKServiceMessage$postHatenaWtihComment$, _typeEncoding); }{ const char *_typeEncoding = "v@:"; class_addMethod(_logos_class$_ungrouped$RKServiceMessage, @selector(postHatenaFromUrlScheme), (IMP)&_logos_method$_ungrouped$RKServiceMessage$postHatenaFromUrlScheme, _typeEncoding); }Class _logos_class$_ungrouped$ShareButton = objc_getClass("ShareButton"); MSHookMessageEx(_logos_class$_ungrouped$ShareButton, @selector(image), (IMP)&_logos_method$_ungrouped$ShareButton$image, (IMP*)&_logos_orig$_ungrouped$ShareButton$image);MSHookMessageEx(_logos_class$_ungrouped$ShareButton, @selector(title), (IMP)&_logos_method$_ungrouped$ShareButton$title, (IMP*)&_logos_orig$_ungrouped$ShareButton$title);Class _logos_class$_ungrouped$RKUser = objc_getClass("RKUser"); MSHookMessageEx(_logos_class$_ungrouped$RKUser, @selector(setSyncStatusText:), (IMP)&_logos_method$_ungrouped$RKUser$setSyncStatusText$, (IMP*)&_logos_orig$_ungrouped$RKUser$setSyncStatusText$);Class _logos_class$_ungrouped$AppDelegate = objc_getClass("AppDelegate"); { const char *_typeEncoding = "v@:@@"; class_addMethod(_logos_class$_ungrouped$AppDelegate, @selector(application:didReceiveLocalNotification:), (IMP)&_logos_method$_ungrouped$AppDelegate$application$didReceiveLocalNotification$, _typeEncoding); }MSHookMessageEx(_logos_class$_ungrouped$AppDelegate, @selector(applicationDidBecomeActive:), (IMP)&_logos_method$_ungrouped$AppDelegate$applicationDidBecomeActive$, (IMP*)&_logos_orig$_ungrouped$AppDelegate$applicationDidBecomeActive$);}
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, PostNotification, CFSTR("com.kindadev.ReederEnhancer.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	LoadSettings();
	[pool release];
}
