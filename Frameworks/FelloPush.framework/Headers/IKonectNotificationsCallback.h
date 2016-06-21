//
//  IKonectCallback.h
//  mobile-platform
//
//  Created by rudo on 2013/02/13.
//
//

#import <Foundation/Foundation.h>

@protocol IKonectNotificationsCallback<NSObject>

@optional
- (void)onReady;
- (void)onNotification:(NSString *)notificationsId message:(NSString *)message extra:(NSDictionary *)extra isRemoteNotification:(BOOL)isRemoteNotification;
- (void)onLaunchFromNotification:(NSString*)notificationsId message:(NSString*)message extra:(NSDictionary*)extra;
// Ver.3.0.0からの追加
- (void)onLaunchFromMessage:(NSString*)messageId message:(NSString*)message extra:(NSDictionary*)extra;
- (void) onUpdateMessages;

@end
