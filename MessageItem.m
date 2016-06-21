#import "MessageItem.h"
#import "MessageCell.h"

@interface MessageItem ()

@end

@implementation MessageItem

- (id)initWithMessageId:(NSString*)messageId
{
    if (self = [super init])
    {
        self.messageId = messageId;
    }
    return self;
}

- (void)injectTo:(UITableViewCell*)cell
{
    MessageCell* target = (MessageCell*) cell;
    
    // ルームタイトル設定
    if (self.title != nil)
    {
        target.titleLabel.text = self.title;
    }
    else
    {
        target.titleLabel.text = @"";
    }
    
    // 配信日設定
    if (self.deliveredAt != nil)
    {
        target.dateLabel.text = self.deliveredAt;
    }
    else
    {
        target.dateLabel.text = @"";
    }

    // 未読マーク設定
    if ([self.read boolValue])
    {
        target.unreadMark.hidden = YES;
    }
    else
    {
        target.unreadMark.hidden = NO;
    }
}

@end
