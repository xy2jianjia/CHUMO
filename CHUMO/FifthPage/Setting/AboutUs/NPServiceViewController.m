//
//  NPServiceViewController.m
//  StrangerChat
//
//  Created by 朱瀦潴 on 16/1/7.
//  Copyright © 2016年 long. All rights reserved.
//

#import "NPServiceViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface NPServiceViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)JSContext *jsCondex;
@property (nonatomic, strong)UIWebView *serviceWeb;
@end

@implementation NPServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    [self layoutServiceWebView];
}
- (void)leftAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark web
- (void)layoutServiceWebView{
    self.serviceWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    [self.view addSubview:_serviceWeb];
    self.serviceWeb.delegate = self;         // http://192.168.1.52:8080/vip2/js.html
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlWeb]];
    [self.serviceWeb loadRequest:request];
}
#pragma mark web代理
//-(void)webViewDidStartLoad:(UIWebView *)webView{
//    self.jsCondex = [self.serviceWeb valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    NSString *str=[self.serviceWeb stringByEvaluatingJavaScriptFromString:@"document.title"];
//    NSLog(str);
//    self.navigationItem.title=str;
//    
//}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.jsCondex = [self.serviceWeb valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *str=[self.serviceWeb stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(str);
    self.navigationItem.title=str;
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
