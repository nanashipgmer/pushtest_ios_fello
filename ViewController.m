#import <FelloPush/KonectNotificationsAPI.h>
#import "AppDelegate.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage* badgeImage = [UIImage imageNamed:@"badge.png"];
    [self.badge setBackgroundImage:badgeImage forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)launchMessageList:(id)sender {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UIViewController* nextViewController = appDelegate.messageViewController;
    // お知らせ一覧更新リクエストを発行
    [KonectNotificationsAPI updateMessages];
    [self.navigationController pushViewController:nextViewController animated:YES];
}

@end
