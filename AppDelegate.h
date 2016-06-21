#import <FelloPush/IKonectNotificationsCallback.h>
#import <UIKit/UIKit.h>
#import "ContentViewController.h"
#import "MessageViewController.h"
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, IKonectNotificationsCallback>

@property (strong, nonatomic) UIWindow* window;
@property (strong, nonatomic) UINavigationController* navController;
@property (strong, nonatomic) ViewController* viewController;
@property (strong, nonatomic) ContentViewController* contentViewController;
@property (strong, nonatomic) MessageViewController* messageViewController;

@end