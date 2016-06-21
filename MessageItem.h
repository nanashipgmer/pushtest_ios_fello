#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MessageItem : NSObject

@property (strong, nonatomic) NSString* messageId;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* url;
@property (strong, nonatomic) NSString* extra;
@property (strong, nonatomic) NSString* deliveredAt;
@property (strong, nonatomic) NSNumber* read;

- (id)initWithMessageId:(NSString*)messageId;
- (void)injectTo:(UITableViewCell*)cell;

@end

