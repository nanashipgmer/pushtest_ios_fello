#import <UIKit/UIKit.h>
#import "MessageItem.h"

@interface MessageViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

#pragma mark - UIViewController methods
- (void)viewDidLoad;
- (void)viewDidLayoutSubviews;

#pragma mark - MessageViewController methods
- (void)insertMessageItem:(MessageItem*)messageItem;
- (void)updateMessage:(NSString*)messageId;
- (void)updateTable;
- (void)updateVisibleCells;
- (void)reloadMessages;

#pragma mark - UITableViewDataSource methods
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end
