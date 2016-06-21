#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel* titleLabel;
@property (strong, nonatomic) IBOutlet UILabel* dateLabel;
@property (strong, nonatomic) IBOutlet UIView* unreadMark;
@end