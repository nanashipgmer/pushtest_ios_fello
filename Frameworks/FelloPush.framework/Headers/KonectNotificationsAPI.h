//
//  KonectSdk.h
//  mobile-platform
//
//  Created by rudo on 2013/02/05.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IKonectNotificationsCallback.h"

extern NSString* const AD_SCENE_INTERSTITIAL_DEFAULT;
extern NSString* const AD_SCENE_INTERSTITIAL_CUSTOM_PREFIX;
extern NSString* const AD_SCENE_LAUNCH;
extern NSString* const AD_SCENE_RESUME;
extern NSString* const AD_SCENE_LAUNCH_BY_REMOTEPUSH;
extern NSString* const AD_SCENE_LAUNCH_BY_LOCALPUSH;

extern NSString* const AD_CLOSE_REASON_BY_USER;
extern NSString* const AD_CLOSE_REASON_BY_DEVELOPER;
extern NSString* const AD_CLOSE_REASON_OVERTAKEN;
extern NSString* const AD_CLOSE_REASON_BY_OPEN_AD;
extern NSString* const RICHPAGE_CLOSE_REASON;

@interface KonectNotificationsAPI : NSObject

+ (void)initialize:(NSObject<IKonectNotificationsCallback>*)callback
     launchOptions:(NSDictionary*)launchOptions
             appId:(NSString*)appId;
+ (void)            initialize:(NSObject<IKonectNotificationsCallback>*)callback
                 launchOptions:(NSDictionary*)launchOptions
                         appId:(NSString*)appId
registerForRemoteNotifications:(BOOL)registerForRemoteNotifications;
+ (void)initialize:(NSObject<IKonectNotificationsCallback>*)callback
             appId:(NSString*)appId
     launchOptions:(NSDictionary*)launchOptions
        sdkOptions:(NSDictionary*)sdkOptions;
+ (void)registerForRemoteNotifications;
+ (BOOL)isRegisteredForRemoteNotifications;
+ (void)setRootView:(UIViewController*)root;
+ (void)setRootUIView:(UIView*)root;
+ (void)setupNotifications:(NSData*)devToken;
+ (void)setupNotificationsWithString:(NSString*)devToken;
+ (void)processLocalNotifications:(UILocalNotification*)notification;
+ (BOOL)processNotifications:(NSDictionary*)userInfo;
+ (UILocalNotification*)scheduleLocalNotification:(NSString*)text at:(NSDate*)dateTime label:(NSString*)label;
+ (void)cancelLocalNotification:(NSString*)label;
+ (void)setTag:(NSString*)name withStringValue:(NSString*)value;
+ (void)setTag:(NSString*)name withIntValue:(int)value;
+ (void)setTag:(NSString*)name withDateValue:(NSDate*)value;
+ (void)flushUnsentTags __attribute__ ((deprecated));
+ (NSString*)getDeviceToken;
+ (NSDictionary*)getMessage:(NSString*)messageId;
+ (NSArray*)getMessages __attribute__ ((deprecated));
+ (NSArray*)getStoredMessages;
+ (void)updateMessages;
+ (NSInteger)getUnreadMessageCount;
+ (void)markMessagesRead:(NSArray*)messageIds;
+ (void)setMessageCenterEnabled:(BOOL)enabled;
+ (void)setAutoBadgeEnabled:(BOOL)enabled;
+ (void)openLinkInBrowser:(BOOL)openLinkInBrowser;
+ (BOOL)setNotificationsEnabled:(BOOL)enabled;
+ (BOOL)isNotificationsEnabled;
+ (NSString*)JSONToString:(id)obj;

@end
