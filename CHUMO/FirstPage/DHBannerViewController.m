//
//  DHBannerViewController.m
//  CHUMO
//
//  Created by xy2 on 16/4/21.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHBannerViewController.h"
#import "MBProgressHUD.h"
@interface DHBannerViewController ()<UIWebViewDelegate>

@end

@implementation DHBannerViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-arrow"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//    });
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIWebView *webv = [[UIWebView alloc]init];
        CGRect temp = [[UIScreen mainScreen ] bounds];
        temp.origin.y = 64;
        temp.size.height = ScreenHeight-64;
        webv.frame = temp;
        webv.scalesPageToFit = YES;
        NSURL *url = [NSURL URLWithString:self.bannerItem.b183];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
