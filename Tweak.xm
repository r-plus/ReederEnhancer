#import "AllAroundPullView/AllAroundPullView.h"
#define PREF_PATH @"/var/mobile/Library/Preferences/jp.r-plus.pulltosyncforreeder3.plist"

@interface RootViewController : UINavigationController
@end
@interface UsersViewController : UITableViewController
-(void)syncAll:(id)arg1;
@end
@interface RKStream : NSObject
@property (nonatomic, assign) BOOL listed;
@property (nonatomic, assign) BOOL isFolder;
@end
@interface SubscriptionsViewController : UITableViewController
@property (nonatomic,retain) RKStream* folder;
- (void)sync:(id)arg;
@end
@interface ItemsViewController : UITableViewController
-(void)markAllAsRead:(id)arg1;
@end
@interface UIView(Fake)
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) float threshold;
@property (nonatomic, assign) AllAroundPullViewPosition position;
- (void)hideAllAroundPullViewIfNeed:(BOOL)arg;
@end

static AllAroundPullView *rootPull = nil;

static BOOL rootPullViewTopIsEnabled;
static BOOL folderPullViewTopIsEnabled;
static BOOL itemPullViewTopIsEnabled;
static BOOL itemPullViewBottomIsEnabled;

static int folderPullViewTopAction;
static int itemPullViewTopAction;
static int itemPullViewBottomAction;

static float rootPullViewTopThreshold;
static float folderPullViewTopThreshold;
static float itemPullViewTopThreshold;;
static float itemPullViewBottomThreshold;;

static void recursiveSearchAndHide(UIView *v) {
  if ([v isMemberOfClass:[AllAroundPullView class]]) {
    if ([v.superview.delegate isMemberOfClass:%c(SubscriptionsViewController)]) {
      if ([[v.superview.delegate folder] isFolder]) {
        // folder top
        v.threshold = folderPullViewTopThreshold;
        [v hideAllAroundPullViewIfNeed:folderPullViewTopIsEnabled ? NO : YES];
      } else {
        // root top
        v.threshold = rootPullViewTopThreshold;
        [v hideAllAroundPullViewIfNeed:rootPullViewTopIsEnabled ? NO : YES];
      }
    }
    if ([v.superview.delegate isMemberOfClass:%c(ItemsViewController)]) {
      // item
      if (v.position == AllAroundPullViewPositionTop) {
        // top
        v.threshold = itemPullViewTopThreshold;
        [v hideAllAroundPullViewIfNeed:itemPullViewTopIsEnabled ? NO : YES];
      } else {
        // bottom
        v.threshold = itemPullViewBottomThreshold;
        [v hideAllAroundPullViewIfNeed:itemPullViewBottomIsEnabled ? NO : YES];
      }
    }
  }

  for (UIView *sv in v.subviews)
    recursiveSearchAndHide(sv);
}

static inline void UpdatePullPropertys() {
  NSArray *windows = [[UIApplication sharedApplication] windows];
  if (windows)
    for (UIWindow *w in windows)
      recursiveSearchAndHide(w);
}

static void UpdateRootPull() {
  rootPull.threshold = rootPullViewTopThreshold;
  [rootPull hideAllAroundPullViewIfNeed:rootPullViewTopIsEnabled ? NO : YES];
}

static inline void DoAction(id self, int actionNumber, UIView *view) {
  NSTimeInterval delay = 0.0f;
  switch (actionNumber) {
    // sync
    case 0:
      if ([self isMemberOfClass:%c(SubscriptionsViewController)])
        [(SubscriptionsViewController *)self sync:nil];
      else {
        RootViewController *rvc = (RootViewController *)[self parentViewController];
        UsersViewController *uvc = MSHookIvar<UsersViewController *>(rvc, "__usersViewController");
        [uvc syncAll:nil];
      }
      delay = 1.0f;
      break;
    // markAllAsRead
    case 1:
      [(ItemsViewController *)self markAllAsRead:nil];
      break;
    // pop
    case 2:
      [[self navigationController] popViewControllerAnimated:YES];
      break;
  }
  [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:delay];
}

%hook SubscriptionsViewController// : FetchedTableViewController : TableViewController : UITableViewController
- (void)viewDidAppear:(BOOL)animate
{
  %orig;
  // Purpose: dynamic property change compatible when moved to Root->Folder->Item->Folder
  //          When moved Item to Folder view, viewDidLoad isnt call.
  if (self.folder.isFolder) {
    for (UIView *v in self.tableView.subviews) {
      if ([v isMemberOfClass:[AllAroundPullView class]]) {
        v.threshold = folderPullViewTopThreshold;
        [v hideAllAroundPullViewIfNeed:folderPullViewTopIsEnabled ? NO : YES];
      }
    }
  }
}
- (void)viewDidLoad
{
  %orig;
  if (self.folder.isFolder) {
    if (folderPullViewTopIsEnabled) {
      AllAroundPullView *pull = [[AllAroundPullView alloc] initWithScrollView:self.tableView position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
        DoAction(self, folderPullViewTopAction, view);
      }];
      [self.tableView addSubview:pull];
      [pull release];
    }
  } else {
    rootPull = [[AllAroundPullView alloc] initWithScrollView:self.tableView position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
      [self sync:nil];
      [view performSelector:@selector(finishedLoading) withObject:nil afterDelay:1.0f];
    }];
    [self.tableView addSubview:rootPull];
    [rootPull hideAllAroundPullViewIfNeed:rootPullViewTopIsEnabled ? NO : YES];
  }
}

// NSConcreteNotification {name = RKServiceConnectorDidSyncNotification; object = <RKServiceGoogleReader: >}]
// Probably this method called when synced articles without images.
/*- (void)didSync:(id)sync*/
/*{*/
/*  %log;*/
/*  %orig;*/
/*}*/
%end
%hook ItemsViewController
- (void)viewDidLoad
{
  %orig;

  if (itemPullViewTopIsEnabled) {
    AllAroundPullView *pull = [[AllAroundPullView alloc] initWithScrollView:self.tableView position:AllAroundPullViewPositionTop action:^(AllAroundPullView *view){
      DoAction(self, itemPullViewTopAction, view);
    }];
    [self.tableView addSubview:pull];
    [pull release];
  }
  if (itemPullViewBottomIsEnabled) {
    AllAroundPullView *pull = [[AllAroundPullView alloc] initWithScrollView:self.tableView position:AllAroundPullViewPositionBottom action:^(AllAroundPullView *view){
      DoAction(self, itemPullViewBottomAction, view);
    }];
    [self.tableView addSubview:pull];
    [pull release];
  }
}
%end

/*%hook UsersViewController*/
/*-(void)didSync:(id)sync*/
/*{*/
/*  %log;*/
/*  %orig;*/
/*}*/
/*%end*/
/*%hook RKServiceConnector*/
/*-(void)syncDidSucceed*/
/*{*/
/*  %log;*/
/*  %orig;*/
/*}*/
/*-(void)__syncCache*/
/*{*/
/*  %log;*/
/*  %orig;*/
/*}*/
/*-(void)syncCache*/
/*{*/
/*  %log;*/
/*  %orig;*/
/*}*/
/*%end*/
/*%hook RKUser*/
/*- (void)setSyncStatusText:(NSString *)text*/
/*{*/
/*  %log;*/
/*  NSLog(@"-----text = %@", text);*/

/*  if ([text hasPrefix:@"Caching Images"]) {*/
/*    UILocalNotification *notification = [[UILocalNotification alloc] init];*/
/*    [notification setTimeZone:[NSTimeZone localTimeZone]];*/
/*    NSDate *date = [NSDate date];*/
/*    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];*/
/*    [dateFormatter setDateFormat:@"Y/M/d H:m:ss Z"];*/
/*    [notification setAlertBody:[NSString stringWithFormat:@"Synced at %@", [dateFormatter stringFromDate:date]]];*/
/*    [notification setSoundName:UILocalNotificationDefaultSoundName];*/
/*    [notification setAlertAction:@"Open"];*/
/*    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];*/
/*    [notification release];*/
/*  }*/

/*  %orig;*/
/*}*/
/*- (void)setLastSyncDate:(double)date*/
/*{*/
/*  %log;*/
/*  %orig;*/
/*}*/
/*%end*/
/*%hook RKServiceTwitter*/
@interface RKShareObject : NSObject
+ (id)shareObjectWithItem:(id)item;
- (id)item;
- (NSString *)srcTitle;
@end
@interface UITextView(Private)
- (void)setSelectionToStart;
@end
static NSString *srcTitle = nil;
static BOOL tweetFormatterIsEnabled;
%hook ArticleViewController
- (void)share:(id)arg
{
  %orig;
  srcTitle = [[%c(RKShareObject) shareObjectWithItem:[self item]] srcTitle];
}
%end
%hook TWTweetComposeViewController
- (BOOL)setInitialText:(NSString *)text
{
  if (tweetFormatterIsEnabled)
    return %orig([NSString stringWithFormat:@"%@ - %@", text, srcTitle]);
  else
    return %orig;
}
- (void)viewDidAppear:(BOOL)arg1
{
  %orig;
  if (tweetFormatterIsEnabled) {
    UITextView *tv = MSHookIvar<UITextView *>(self, "_textView");
    [tv setSelectionToStart];
  }
}
%end

static void LoadSettings()
{	
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:PREF_PATH];
  id existTweetFormatterIsEnabled = [dict objectForKey:@"TweetFormatterIsEnabled"];
  tweetFormatterIsEnabled = existTweetFormatterIsEnabled ? [existTweetFormatterIsEnabled boolValue] : YES;

  id existRootPullViewTopIsEnabled = [dict objectForKey:@"RootPullViewTopIsEnabled"];
  rootPullViewTopIsEnabled = existRootPullViewTopIsEnabled ? [existRootPullViewTopIsEnabled boolValue] : YES;
  id existFolderPullViewTopIsEnabled = [dict objectForKey:@"FolderPullViewTopIsEnabled"];
  folderPullViewTopIsEnabled = existFolderPullViewTopIsEnabled ? [existFolderPullViewTopIsEnabled boolValue] : YES;
  id existItemPullViewTopIsEnabled = [dict objectForKey:@"ItemPullViewTopIsEnabled"];
  itemPullViewTopIsEnabled = existItemPullViewTopIsEnabled ? [existItemPullViewTopIsEnabled boolValue] : YES;
  id existItemPullViewBottomIsEnabled = [dict objectForKey:@"ItemPullViewBottomIsEnabled"];
  itemPullViewBottomIsEnabled = existItemPullViewBottomIsEnabled ? [existItemPullViewBottomIsEnabled boolValue] : YES;

  id existFolderPullViewTopAction = [dict objectForKey:@"FolderPullViewTopAction"];
  folderPullViewTopAction = existFolderPullViewTopAction ? [existFolderPullViewTopAction intValue] : 0; // sync
  id existItemPullViewTopAction = [dict objectForKey:@"ItemPullViewTopAction"];
  itemPullViewTopAction = existItemPullViewTopAction ? [existItemPullViewTopAction intValue] : 2; // pop
  id existItemPullViewBottomAction = [dict objectForKey:@"ItemPullViewBottomAction"];
  itemPullViewBottomAction = existItemPullViewBottomAction ? [existItemPullViewBottomAction intValue] : 1; // markAllAsRead then poptoroot
  
  id existRootPullViewTopThreshold = [dict objectForKey:@"RootPullViewTopThreshold"];
  rootPullViewTopThreshold = existRootPullViewTopThreshold ? [existRootPullViewTopThreshold floatValue] : 60.0f;
  id existFolderPullViewTopThreshold = [dict objectForKey:@"FolderPullViewTopThreshold"];
  folderPullViewTopThreshold = existFolderPullViewTopThreshold ? [existFolderPullViewTopThreshold floatValue] : 60.0f;
  id existItemPullViewTopThreshold = [dict objectForKey:@"ItemPullViewTopThreshold"];
  itemPullViewTopThreshold = existItemPullViewTopThreshold ? [existItemPullViewTopThreshold floatValue] : 60.0f;
  id existItemPullViewBottomThreshold = [dict objectForKey:@"ItemPullViewBottomThreshold"];
  itemPullViewBottomThreshold = existItemPullViewBottomThreshold ? [existItemPullViewBottomThreshold floatValue] : 60.0f;

  UpdateRootPull();
  UpdatePullPropertys();
}

static void PostNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  LoadSettings();
}

%ctor {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, PostNotification, CFSTR("jp.r-plus.PullToSyncForReeder3.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	LoadSettings();
	[pool release];
}
