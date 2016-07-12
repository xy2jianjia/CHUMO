//
//  DHShareCodeIPhone4ViewController.m
//  CHUMO
//
//  Created by xy2 on 16/6/22.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHShareCodeIPhone4ViewController.h"
#import "WXApi.h"

#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
@interface DHShareCodeIPhone4ViewController ()

@end

@implementation DHShareCodeIPhone4ViewController

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    [self configData];
}

/**
 *   配置所有属性
 */
- (void)configData{
    
    _hasOwnedLabel.text = [NSString stringWithFormat:@"福利一：%@（已赠送）",[[_infoDict objectForKey:@"b131"] length]==0?@"":[_infoDict objectForKey:@"b131"]];
    _contentTextV.text = [NSString stringWithFormat:@"独乐乐不如众乐乐！邀请好友加入触陌，在“我”页面找到“我的福利”，输入您赠送的兑换码，即可免费获得%@VIP",[[_infoDict objectForKey:@"b191"] length] == 0?@"":[_infoDict objectForKey:@"b191"]];
    _codeLabel.text = [NSString stringWithFormat:@"兑换码：%@",[[_infoDict objectForKey:@"b189"] length] == 0?@"":[_infoDict objectForKey:@"b189"]];
    
}
- (IBAction)shareAction:(id)sender {
    NSInteger tag = [(UIButton *)sender tag];
    
    NSString *code = [[_infoDict objectForKey:@"b189"] length] == 0?@"":[_infoDict objectForKey:@"b189"];
    NSString *month = [[_infoDict objectForKey:@"b191"] length] == 0?@"":[_infoDict objectForKey:@"b191"];
    NSString *price = [[_infoDict objectForKey:@"b192"] length] == 0?@"":[_infoDict objectForKey:@"b192"];
    NSString *title = @"粗大事了,单身伴侣免费带走!";
    NSString *desc = @"才1分钟,TA就在触陌被带走了";
    NSURL *url = [NSURL URLWithString: [[NSString stringWithFormat:@"%@chumoSpend/index.html?a137=%@&a126=%@&a13=%@",kServerAddressTestH5,month,price,code] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    UIImage *image = [UIImage imageNamed:@"Iconchumo.png"];
    NSData* data = UIImageJPEGRepresentation(image, 1);
    // 微信
    if (tag == 1002) {
        
        WXMediaMessage *msg = [WXMediaMessage message];
        msg.title = title;
        msg.description = desc;
        msg.thumbData = data;
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = [NSString stringWithFormat:@"%@",url];
        msg.mediaObject = webObj;
        
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.message = msg;
        req.bText = NO;
        req.scene = WXSceneSession;
        [WXApi sendReq:req];
    }else if(tag == 1000){
        
        QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:title description:desc previewImageData:data];
        SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
        
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        //        if (sent == EQQAPISENDSUCESS) {
        //            [self showHint:@"已分享"];
        //        }
    }
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
