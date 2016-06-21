#import "ContentViewController.h"

@interface ContentViewController()

@end

@implementation ContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateView];
}

- (void)updateView
{
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.item.url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    [self.webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // リンクがクリックされた時の処理
    return YES;
}

@end