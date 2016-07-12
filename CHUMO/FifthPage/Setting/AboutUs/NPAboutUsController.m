//
//  NPAboutUsController.m
//  StrangerChat
//
//  Created by zxs on 15/11/27.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "NPAboutUsController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "NPServiceViewController.h"

@interface NPAboutUsController ()<UIWebViewDelegate>
@property (nonatomic,strong)JSContext *jsCondex;
@property (nonatomic, strong)UIWebView *aboutUsWeb;
@end

@implementation NPAboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    [self layoutAboutUsWebView];
    // Do any additional setup after loading the view.
}
- (void)leftAction {
    
    [self.navigationController popViewControllerAnimated:true];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark web
- (void)layoutAboutUsWebView{
    self.aboutUsWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    [self.view addSubview:_aboutUsWeb];
    self.aboutUsWeb.delegate = self;         // http://192.168.1.52:8080/vip2/js.html
    NSString *str = [NSGetTools getAppVersion];
    
//    [NSString stringWithFormat:@"http://115.236.55.163:9093/lp-h5-msc/about.html?version=%@",str,nil]
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@about.html?version=%@",kServerAddressTestH5,str,nil]]];
    [self.aboutUsWeb loadRequest:request];
}
#pragma mark web代理
-(void)webViewDidStartLoad:(UIWebView *)webView{
    self.jsCondex = [self.aboutUsWeb valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __block NPAboutUsController *aboutUsC=self;
    self.jsCondex[@"openWeb"] = ^(NSString *msg){ // 获取URL重新加载页面 完成
        //服务条款
        NPServiceViewController *temp = [[NPServiceViewController alloc] init];
        temp.urlWeb = msg;
        [aboutUsC.navigationController pushViewController:temp animated:true];
        
    };
    
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
