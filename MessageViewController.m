#import <FelloPush/KonectNotificationsAPI.h>
#import "AppDelegate.h"
#import "ContentViewController.h"
#import "MessageViewController.h"
#import "MessageItem.h"
#import "MessageCell.h"

@interface MessageViewController()

@property NSMutableArray* messageArray;
@property NSMutableDictionary* messageDictionary;

@end

@implementation MessageViewController

#pragma mark - UIViewController methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadMessages];
}

- (void)reloadMessages
{
    NSArray* data = [KonectNotificationsAPI getStoredMessages];

    self.messageArray = [@[] mutableCopy];
    self.messageDictionary = [@{} mutableCopy];

    // 日付フォーマッタ
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    // メッセージを読み込み
    for (NSDictionary* message in data)
    {
        NSString* messageId = message[@"message_id"];
        MessageItem* messageItem = [self.messageDictionary objectForKey:messageId];
        if (messageItem == nil)
        {
            messageItem = [[MessageItem alloc] initWithMessageId:messageId];
            // メッセージのID
            messageItem.messageId = messageId;
            // メッセージのタイトル
            messageItem.title = message[@"title"];
            // 本文のURL
            messageItem.url = message[@"url"];
            // メッセージ配信時に付与したデータ
            messageItem.extra = message[@"extra"];
            // メッセージ配信日
            messageItem.deliveredAt = [formatter stringFromDate:message[@"delivered_at"]];
            // メッセージが既読かどうか
            messageItem.read = message[@"read"];
            [self insertMessageItem:messageItem];
        }
    }
    
    // メッセージを日付順にソート
    [self.messageArray sortUsingComparator:^(MessageItem* obj1, MessageItem* obj2) {
        return [obj2.deliveredAt compare:obj1.deliveredAt];
    }];
    
    [self.tableView reloadData];
    self.tableView.hidden = NO;
    [self updateTable];

    // アプリ内未読数バッジを更新
    NSInteger unreadCount = [KonectNotificationsAPI getUnreadMessageCount];
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (unreadCount > 0)
    {
        appDelegate.viewController.badge.hidden = NO;
        NSString* badgeCount = [[NSString alloc] initWithFormat:@"%d", unreadCount];
        [appDelegate.viewController.badge setTitle:badgeCount forState:UIControlStateNormal];
    }
    else
    {
        appDelegate.viewController.badge.hidden = YES;
    }
}

- (void)viewDidLayoutSubviews
{
    // 表示をリフレッシュ
    [self updateVisibleCells];
}

- (void)insertMessageItem:(MessageItem*)messageItem
{
    if ([self.messageDictionary objectForKey:messageItem.messageId] != nil)
    {
        NSAssert([self.messageDictionary objectForKey:messageItem.messageId] == nil, @"message already exists");
    }
    [self.messageArray addObject:messageItem];
    NSAssert(messageItem.messageId != nil, @"message_id mustn't be nil");
    [self.messageDictionary setObject:messageItem forKey:messageItem.messageId];
}

- (void)updateMessage:(NSString*)messageId
{
    MessageItem* messageItem = [self.messageDictionary objectForKey:messageId];

    // itemを新規作成
    if (messageItem == nil)
    {
        messageItem = [[MessageItem alloc] initWithMessageId:messageId];
        [self insertMessageItem:messageItem];
        // 日付でソート
        [self.messageArray sortUsingComparator:^(MessageItem* obj1, MessageItem* obj2) {
            return [obj2.deliveredAt compare:obj1.deliveredAt];
        }];
    }

    // 表示を更新
    [self updateTable];
}

- (void)updateTable
{
    [self.tableView reloadData];
}

- (void)updateVisibleCells
{
    NSArray* visibleCells = [NSArray arrayWithArray:[self.tableView visibleCells]];
    for ( UITableViewCell *cell in visibleCells )
    {
        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
        NSInteger index = indexPath.row;
        if ( index >= 0 && index < self.messageArray.count )
        {
            MessageItem* item = [self.messageArray objectAtIndex:index];
            [item injectTo:cell];
        }
    }
}

#pragma mark - UITableViewDataSource methods
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = @"MessageCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ( cell == nil )
    {
        UIViewController* controller = [UIViewController alloc];
        controller = [controller initWithNibName:cellIdentifier bundle:nil];
        cell = (UITableViewCell*)controller.view;
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messageArray count];
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 選択された行の情報を取得
    // messageItem.extraにメッセージ配信時に付与したjsonデータが入っているので
    // ここでデータ内にある値が入っていれば特定の処理を行う、などが可能
    MessageItem* messageItem = [self.messageArray objectAtIndex:indexPath.row];
    NSLog(@"extra: %@", messageItem.extra);
    
    // メッセージを既読にする
    [KonectNotificationsAPI markMessagesRead:@[messageItem.messageId]];
    // 未読数を取得
    NSLog(@"unread_count: %li", (long)[KonectNotificationsAPI getUnreadMessageCount]);
    // お知らせ一覧更新リクエストを発行
    [KonectNotificationsAPI updateMessages];

    // メッセージ本文のビューを表示する
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.contentViewController.item = messageItem;
    
    [self.navigationController pushViewController:appDelegate.contentViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row >= 0 && indexPath.row < self.messageArray.count )
    {
        // セルにデータを流し込む
        MessageItem* item = [self.messageArray objectAtIndex:indexPath.row];
        [item injectTo:cell];
    }
}

@end
