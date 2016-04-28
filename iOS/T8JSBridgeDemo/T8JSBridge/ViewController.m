//
//  ViewController.m
//  T8JSBridge
//
//  Created by 琦张 on 16/4/16.
//  Copyright © 2016年 T8. All rights reserved.
//

#import "ViewController.h"
#import "JSBridge.h"
#import "JavaScriptCore/JavaScriptCore.h"

@interface ViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) JSBridge *bridge;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"T8JSBridge Demo";
    
    [self.view addSubview:self.webView];
    [self loadIndexFile];
    
    JSContext *ctx = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    ctx[@"console"][@"log"] = ^(JSValue * msg) {
        NSLog(@"JavaScript %@ log message: %@", [JSContext currentContext], msg);
    };
    
    [self.bridge registerEvent:JSBridge_JSEvent_ImageLongTap handler:^(id data, JSBResponseCallback responseCallback) {
        NSString *img = data[@"data"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Long Tap" message:img delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    [self.bridge registerEvent:JSBridge_JSEvent_ImageSingleTap handler:^(id data, JSBResponseCallback responseCallback) {
        NSString *img = data[@"data"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Single Tap" message:img delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    [self.bridge registerEvent:@"js_log" handler:^(id data, JSBResponseCallback responseCallback) {
        
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"go" style:UIBarButtonItemStylePlain target:self action:@selector(gogogo)];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gogogo
{
    [self.bridge send:@"getSharePreviewImage" data:@"111" responseCallback:^(id responseData) {
        NSString *img = responseData[@"data"];
        NSLog(@"JSBridge_NativeCall_GetPreviewImage:%@", img);
    }];
}

#pragma mark - private
-(void)loadIndexFile {
    NSURL *url = [NSURL URLWithString:@"http://36kr.com/p/5046094.html"];
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

#pragma mark - getter
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    }
    return _webView;
}

- (JSBridge *)bridge
{
    if (!_bridge) {
        _bridge = [[JSBridge alloc] initWithWebView:self.webView webViewDelegate:self bundle:nil handler:^(id data, JSBResponseCallback responseCallback) {
            //when js push an event without eventname, this will be called
        }];
    }
    return _bridge;
}

@end
