#import <FelloPush/KonectNotificationsAPI.h>
#import "AppDelegate.h"
#import "ContentViewController.h"
#import "MessageItem.h"
#import "MessageViewController.h"
#import "ViewController.h"

static NSString* appId = @"14419";
// 例: static NSString* appId = @"10000";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.contentViewController = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
    self.messageViewController = [[MessageViewController alloc]initWithNibName:@"MessageViewController" bundle:nil];
    self.navController = [[UINavigationController alloc]
                          initWithRootViewController:self.viewController];

    [self.window setRootViewController:self.navController];
    [self.window makeKeyAndVisible];
    
    [KonectNotificationsAPI initialize:self launchOptions:launchOptions appId:appId];
    
    // Ver.2.1.0からの追加
    [KonectNotificationsAPI scheduleLocalNotification:@"体力が全回復しました(ローカルプッシュ)" at:[NSDate dateWithTimeIntervalSinceNow:15.0f] label:@"label_sample"];

    // お知らせ管理機能を有効にするかどうかの設定
    [KonectNotificationsAPI setMessageCenterEnabled:YES];

    // お知らせの未読数をバッジに自動反映するかどうかの設定
    [KonectNotificationsAPI setAutoBadgeEnabled:YES];

    return YES;
}

- (void)application:(UIApplication*)app didFailToRegisterForRemoteNotificationsWithError:(NSError*)err
{
    NSLog(@"%@", err.localizedDescription);
}

// デバイストークンを受信した際の処理
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{    
    [KonectNotificationsAPI setupNotifications:devToken];
}

// ローカルプッシュ通知を受信した際の処理
// Ver.2.1.0からの追加
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [KonectNotificationsAPI processLocalNotifications:notification];
}

// リモートプッシュ通知を受信した際の処理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [KonectNotificationsAPI processNotifications:userInfo];
}

// SDKの初期化とプッシュ通知ユーザー登録が完了した際に呼び出されるコールバック
- (void)onReady
{
    NSLog(@"SDKの初期化とプッシュ通知ユーザー登録が完了した時に呼び出されます");
}

// 通知を受信した際に呼ばれるコールバック
- (void)onNotification:(NSString *)notificationsId message:(NSString *)message extra:(NSDictionary *)extra isRemoteNotification:(BOOL)isRemoteNotification
{
    NSLog(@"ここでプッシュ通知の情報を取得することができます");
}

// リモートプッシュ通知から起動した際に呼ばれるコールバック
- (void)onLaunchFromNotification:(NSString *)notificationsId message:(NSString *)message extra:(NSDictionary *)extra
{
    NSLog(@"ここでextraの中身にひもづいたインセンティブの付与などを行うことが出来ます");
}

// お知らせの通知から起動した際に呼ばれるコールバック
- (void)onLaunchFromMessage:(NSString*)messageId message:(NSString*)message extra:(NSDictionary*)extra
{
    // メッセージ情報を取得
    NSDictionary* datail = [KonectNotificationsAPI getMessage:messageId];
    MessageItem* messageItem = [[MessageItem alloc] initWithMessageId:messageId];
    messageItem.messageId = messageId;
    messageItem.title = datail[@"message"];
    messageItem.url = datail[@"url"];
    messageItem.extra = datail[@"extra"];
    messageItem.deliveredAt = datail[@"delivered_at"];
    messageItem.read = datail[@"read"];

    // メッセージを既読にする
    [KonectNotificationsAPI markMessagesRead:@[messageItem.messageId]];
    // ビューを一旦popする
    [self.navController popToViewController:self.viewController animated:NO];
    // 本文のビューを更新
    self.contentViewController.item = messageItem;
    // メッセージ一覧、メッセージ本文のビューを表示する
    [self.navController setViewControllers:@[self.viewController, self.messageViewController, self.contentViewController] animated: NO];
}

// お知らせ一覧がupdateMessages APIによって更新された時に呼び出されるコールバック
- (void)onUpdateMessages
{
    NSLog(@"お知らせ一覧がupdateMessagesによって更新された時に呼び出されます");
    // お知らせ一覧ページの情報を更新する
    [self.messageViewController reloadMessages];
}

@end
