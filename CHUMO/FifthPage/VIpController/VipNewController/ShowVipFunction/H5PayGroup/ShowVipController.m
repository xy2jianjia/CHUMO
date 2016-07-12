//
//  ShowVipController.m
//  StrangerChat
//
//  Created by zxs on 16/1/9.
//  Copyright © 2016年 long. All rights reserved.
//

#import "ShowVipController.h"
#import "TempHFController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JYPayWorking.h"
#import "WXPayController.h"
#import "DHAlertView.h"
@interface ShowVipController ()<UIWebViewDelegate,JYPayWorkingDelegate,DHAlertViewDelegate>

@property (nonatomic, strong)UIWebView *myWeb;
@property (nonatomic,strong)JSContext *jsCondex;
@property (nonatomic,strong)JYPayWorking *payWorking;

@property (nonatomic, strong)NSString *codePrefix;
@end

@implementation ShowVipController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor = [UIColor whiteColor];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self p_setupProgressHud];
    });
    [self layoutTempTableView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-arrow"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];
}
//通知
- (void)payAction:(NSNotification *)sender {
    NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUser"];
    NSString *userName = [[loginUser objectForKey:@"b112"] objectForKey:@"b81"];
    
    if (userName && ![userName isEqualToString:@"(null)"] && ![userName isEqualToString:@"(NULL)"] && ![userName isEqualToString:@""""]) {
        // 长度为11位，第二位不为0，为已经绑定手机
        NSString *secNumber = [userName substringWithRange:NSMakeRange(1, 1)];
        if ([userName length] == 11 && [secNumber integerValue] != 0) {
            [self alertViewOfTitle:@"温馨提示" msg:@"支付成功"];
        }else{
            
            DHAlertView *alert1 = [[DHAlertView alloc]init];
            [alert1 configAlertWithAlertTitle:@"温馨提示" alertContent:@"支付成功,为了避免您忘记自己的账号密码,请绑定手机号~"];
            [alert1.sureBtn setTitle:@"去绑定" forState:(UIControlStateNormal)];
            alert1.delegate = self;
            [self.view addSubview:alert1];
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSGetTools showAlert:@"用户信息过期，请重新登录"];
        });
    }
}
-(void)alertView:(DHAlertView *)alertView onClickBtnAtIndex:(NSInteger)index{
    if (index == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        NResetController *reset = [[NResetController alloc] init];
        reset.title = @"绑定手机号";
        reset.msgType = @"3";
        [self.navigationController pushViewController:reset animated:true];
    }
}
- (void)dealloc {
    [Mynotification removeObserver:self];
}
- (void)leftAction:(UIBarButtonItem *)sender {
    
    //    TempHFController *cg = [[TempHFController alloc] init];
    [self.navigationController popViewControllerAnimated:true];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)layoutTempTableView
{
#pragma mark --- web
    dispatch_async(dispatch_get_main_queue(), ^{
    self.myWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    [self.view addSubview: _myWeb];
    self.myWeb.delegate = self;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.showUrl] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:1];
    [self.myWeb loadRequest:request];
    });
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    dispatch_async(dispatch_get_main_queue(), ^{
    
    self.jsCondex = [self.myWeb valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak ShowVipController *VipVC=self;
    self.jsCondex[@"getUserInfo"] = ^(){  // 2  完成
        NSString *Webtitle = [VipVC.myWeb stringByEvaluatingJavaScriptFromString:@"document.title"];
        dispatch_async(dispatch_get_main_queue(), ^{
            VipVC.navigationItem.title=Webtitle;
        });
        NSString *str = [ShowVipController dictionaryToJson:VipVC.dicts];
        return str;
    };
    
    self.jsCondex[@"getUrl"] = ^(){ // 10 传域名包月
        
        return kServerAddressTest2;
    };
    
    self.jsCondex[@"getSID"] = ^(){   // 1   p1=" + sid   getSID 完成
        NSString *p1 = [NSGetTools getUserSessionId]; //sessionId
        return p1;
    };
    
    self.jsCondex[@"getUserID"] = ^(NSString *msg){ // 11  p2=" + user   getUserID 完成
        NSString *Webtitle = [VipVC.myWeb stringByEvaluatingJavaScriptFromString:@"document.title"];
        VipVC.navigationItem.title=Webtitle;
        NSNumber *p2 = [NSGetTools getUserID];//ID
        return p2;
    };
    
    self.jsCondex[@"checkCode"] = ^(){ // 4 分类特权信息  True:vip  False:非VIP  f_115_13_1.service  // 返回0 获1判断权限
        
        int numbers = [VipVC.number intValue];
        return numbers;
    };
    
    self.jsCondex[@"openWeb"] = ^(NSString *tempUrl){ // 获取URL重新加载页面 完成
        dispatch_async(dispatch_get_main_queue(), ^{
        ShowVipController *show = [[ShowVipController alloc] init];
        show.title = @"VIP专属特权";
        show.showUrl = tempUrl;
        [VipVC.navigationController pushViewController:show animated:true];
        });
    };
    
    self.jsCondex[@"sendVip"] = ^(NSString *ss){  // 5  sendVip   统计用户信息等迭代
        
        
    };
    
    self.jsCondex[@"sendMonth"] = ^(NSString *month){  // 6  sendMonth 统计用户信息等迭代
        
        NSLog(@"我要付费%@",month);
    };
    self.jsCondex[@"openVip"] = ^(NSString *JSONString,int number){  // 7 openVip  data, 1包月 2VIp 跳转支付页面
        
        NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        WXPayController *wxpay = [[WXPayController alloc] init];
        wxpay.title = @"付费界面";
        wxpay.payDic = responseJSON;
        [VipVC.navigationController pushViewController:wxpay animated:true];
        
    };

    
    self.jsCondex[@"setTitle"] = ^(NSString *msg){  // 8 setTitle 跳转页面动态标题
        NSLog(@"%@",msg);
        
    };
    
    self.jsCondex[@"decryptJson"] = ^(NSString *jsondata){ // 11 json解密
        
        NSString *jsonStr = [NSGetTools DecryptWith:jsondata];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSString *str=nil;
        if (infoDic!=nil) {
            str = [ShowVipController dictionaryToJson:infoDic];
        }
        
        return str;
    };
    
    self.jsCondex[@"setPayData"]=^(NSString *orderdata){
        NSData *JSONData = [orderdata dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        if (responseJSON!=nil) {
            VipVC.payWorking =[JYPayWorking shareJYPayWorking];
            VipVC.payWorking.delegate=VipVC;
            NSInteger payType =  [responseJSON[@"b130"] integerValue];
            NSString *prefix=responseJSON[@"b131"];
            payRequsestFlag payflag=(payRequsestFlagNG|payRequsestFlagWX|payRequsestFlagYL|payRequsestFlagZF|payRequsestFlagHFBZF|payRequsestFlagHFBWX|payRequsestFlagHFBYL);
            if ((payflag & payType)) {
                if (payType ==payRequsestFlagWX && ![WXApi isWXAppInstalled]) {
                    [VipVC alertViewOfTitle:@"未检测到微信客户端" msg:@"请安装微信"];
                }
                NSString *strs=[[NSString stringWithFormat:@"%@",prefix] substringWithRange:NSMakeRange(0, 4)];
                [VipVC setValue:strs forKey:@"codePrefix"];
                [VipVC payAgainAction:payType GoodId:prefix];
            }
        }
        
    };
    });
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.HUD hide:YES];
    });
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.showUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:1];
        [self.myWeb loadRequest:request];
    });
}
- (void)p_setupProgressHud
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.HUD = [[MBProgressHUD alloc]initWithView: self.myWeb];
        _HUD.frame = [self.view bounds];
        _HUD.minSize = CGSizeMake(100, 100);
        _HUD.mode=MBProgressHUDModeCustomView;
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.frame = CGRectMake(0, 0, 50, 50);
        
        NSURL * url = [[NSURL alloc]initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"loading.gif" ofType:nil]];
        [imageV yh_setImage:url];
        imageV.animationDuration = 1.5; //执行一次完整动画所需的时长
        imageV.animationRepeatCount = 0;  //动画重复次数
        [imageV startAnimating];
        _HUD.customView=imageV;
        [self.myWeb addSubview:_HUD];
        [_HUD show:YES];
    });
    
}
//历史订单支付
- (void) payAgainAction:(NSInteger)payRequsestFlag GoodId:(NSString *)GoodId {
    NSString *payNum = [NSString stringWithFormat:@"%ld",(long)payRequsestFlag];
    [self.payWorking PaydataRuquesByGoodId:GoodId payType:payNum success:^(NSDictionary *dic) {
        NSNumber *codeNum = dic[@"code"];
        if ([codeNum integerValue] == 200) {
            NSMutableDictionary *wxpayDic = [dic[@"body"] mutableCopy];
            [wxpayDic setObject:GoodId  forKey:@"dh_goodId"];
            [wxpayDic setObject:payNum forKey:@"dh_payType"];
            if (payRequsestFlag==payRequsestFlagZFB) {
                [MobClick event:@"zfbPay"]; // 支付宝统计事件
                [self.payWorking sendZFBPay_demo:wxpayDic];
            }else if (payRequsestFlag==payRequsestFlagWX) {
                [MobClick event:@"wxPay"]; // 微信统计事件
                [self.payWorking sendPay_demo:wxpayDic];
            }else if(payRequsestFlag==payRequsestFlagZF){
                [MobClick event:@"alPay"]; // 现在-支付宝统计事件
                [self.payWorking payByType:wxpayDic];
            }else if(payRequsestFlag==payRequsestFlagNG){
                [MobClick event:@"ngPay"]; // 内购统计事件
                [self.payWorking getProductInfo:GoodId info:wxpayDic];
            }else if(payRequsestFlag==payRequsestFlagYL){
                [MobClick event:@"ylPay"]; // 现在-银联统计事件
                [self.payWorking payByType:wxpayDic];
            }else if(payRequsestFlag==payRequsestFlagHFBZF){
                [MobClick event:@"HFBalPay"]; // 汇付宝-支付宝统计事件
                [self.payWorking payByHUIFUBAOAndPayInfo:wxpayDic];
            }else if(payRequsestFlag==payRequsestFlagHFBYL){
                [MobClick event:@"HFBylPay"]; // 汇付宝-银联统计事件
                [self.payWorking payByHUIFUBAOAndPayInfo:wxpayDic];
            }else if(payRequsestFlag==payRequsestFlagHFBWX){
                [MobClick event:@"HFBwxPay"]; // 汇付宝-微信统计事件
                [self.payWorking payByHUIFUBAOAndPayInfo:wxpayDic];
            }
        }
    }];
}
/**
 *  保存支付成功统计信息
 */
- (void)collectPaySave{
//    [HttpOperation asyncCollectPaySaveWithPayType:<#(NSInteger)#> price:<#(float)#> status:<#(NSInteger)#> goodCode:<#(NSString *)#> orderNum:<#(NSString *)#> userType:<#(NSInteger)#> queue:<#(dispatch_queue_t)#> completed:<#^(NSString *msg, NSInteger code)completed#>]
}

#pragma mark jypayworking代理

-(void)noticePayResult:(BOOL)issuccess msg:(NSString *)msg{
    if (issuccess) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserInfosWhenUpdate" object:nil];
        [self payAction:nil];
    }else{
        NSDictionary *goodDict=[NSGetTools getSystemGoodsByType:2];
        if ([_codePrefix isEqualToString: [NSString stringWithFormat:@"%@",[goodDict objectForKey:@"b13"]]]) {//写信
            [Mynotification postNotificationName:@"pushPayNotificationWhenPayForFailure" object:@(6)];
        }else{//VIP
            [Mynotification postNotificationName:@"pushPayNotificationWhenPayForFailure" object:@(5)];
        }
        [self alertViewOfTitle:@"提示" msg:msg];
    }
}
-(void)alertViewOfTitle:(NSString *)title msg:(NSString *)msg{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alter show];
}

+ (NSString *)dictionaryToJson:(NSDictionary *)dic {
    
    NSError *error = nil;
    NSData *policyData = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&error];
    if(!policyData && error){
        NSLog(@"Error creating JSON: %@", [error localizedDescription]);
        return [error localizedDescription];
    }
    NSString  *policyStr = [[NSString alloc] initWithData:policyData encoding:NSUTF8StringEncoding];
    return [policyStr stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
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
