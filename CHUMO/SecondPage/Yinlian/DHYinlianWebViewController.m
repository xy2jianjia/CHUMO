//
//  DHYinlianWebViewController.m
//  CHUMO
//
//  Created by xy2 on 16/7/8.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHYinlianWebViewController.h"

@interface DHYinlianWebViewController ()<UIWebViewDelegate>

@end

@implementation DHYinlianWebViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webV = [[UIWebView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"https://testmobile.payeco.com/ppi/h5/plugin/itf.do?tradeId=h5Init&Version=2.0.0&MerchantId=302020000058&MerchOrderId=201607081732101081860033483&Amount=1.0&TradeTime=20160708173210&OrderId=302016070800125986&VerifyTime=7C8A954E6D6EA4C08108BD5E0A3388CF955A332F51623FF7EC8814D4560872EF7BB707ACECF98F7470C6997BF06935BE&Sign=GnjCCXsLaALW6a2nGHfLL0q8BBv2WBk8rfD28rl82zhWMCpTO0yQhLy/XrcGcor043RB9hF6fGTl53nhl6SolrRZ46sNOVIz2VmdDJOLLFldkyQXrW07fvxXhLGWpLGLk/KJFxjYnwnuOAmIm5AzayNcIEs0Nj+jYZmSV18HAN4="]];
    [webV loadRequest:request ];
    webV.delegate = self;
    webV.scalesPageToFit = YES;
    [self.view addSubview:webV];
}
//几个代理方法

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    NSLog(@"webViewDidStartLoad");
    
}

- (void)webViewDidFinishLoad:(UIWebView *)web{
    
    NSLog(@"webViewDidFinishLoad");
    
}

-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error{
    
    NSLog(@"DidFailLoadWithError");
    
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
