#import <UIKit/UIKit.h>
#import "MessageItem.h"

@interface ContentViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView* webView;

@property (strong, atomic) MessageItem* item;

- (void)updateView;

@end
