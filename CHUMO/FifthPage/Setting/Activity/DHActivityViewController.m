//
//  DHActivityViewController.m
//  CHUMO
//
//  Created by xy2 on 16/6/21.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHActivityViewController.h"
#import "MBProgressHUD.h"
@interface DHActivityViewController ()<UIWebViewDelegate>

@end

@implementation DHActivityViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"活动相关";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-arrow"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //
    //    });
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIWebView *webv = [[UIWebView alloc]init];
        CGRect temp = [[UIScreen mainScreen ] bounds];
        temp.origin.y = 0;
        temp.size.height = ScreenHeight-0;
        webv.frame = temp;
        webv.scalesPageToFit = YES;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@activeAbout.html",kServerAddressTestH5]];
        for (UIView *aview in self.view.subviews) {
            if ([aview isKindOfClass:[MBProgressHUD class]]) {
                [aview removeFromSuperview];
            }
        }
        [self showHudInView:self.view hint:@""];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        [webv loadRequest:request];
        webv.delegate = self;
        [self.view addSubview:webv];
    });
    
}
- (void)leftAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHud];
    });
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHud];
    });
}

@end
