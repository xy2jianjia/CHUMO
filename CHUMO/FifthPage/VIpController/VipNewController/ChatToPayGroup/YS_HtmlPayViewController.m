//
//  YS_HtmlPayViewController.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/4/20.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "YS_HtmlPayViewController.h"
#import "DHAlertView.h"
#import "JYPayWorking.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface YS_HtmlPayViewController ()<UIWebViewDelegate,DHAlertViewDelegate,JYPayWorkingDelegate>
@property (nonatomic,strong)UIWebView *myWebView;
@property (nonatomic,strong)JSContext *jsContext;
@property (nonatomic,strong)JYPayWorking *payWorking;
@property (nonatomic,strong)NSString *goodInfoStr;
@property (nonatomic,strong)NSString *payTeyeStr;
@end

@implementation YS_HtmlPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationController.title=@"VIP会员";
    dispatch_async(dispatch_get_main_queue(), ^{
        [self p_setupProgressHud];
    });
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.goodInfoStr=[NSString new];
    self.payTeyeStr=[NSString new];
    self.payWorking =[JYPayWorking shareJYPayWorking];
    self.payWorking.delegate=self;
    self.myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0,64, ScreenWidth, ScreenHeight-64)];
    self.myWebView.delegate=self;
    [self.view addSubview:_myWebView];
    
    [self getDataArr];
}
- (void)loadWebView{

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Pay/index.html",kServerAddressTestH5,nil]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:1];
    [self.myWebView loadRequest:request];
    
                           
}
//请求支付方式,根据支付方式生成cell
- (void)getPayMethod{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
    NSString *userId= [NSString stringWithFormat:@"%@",[dict objectForKey:@"userId"]];
    NSString *sessionId= [NSString stringWithFormat:@"%@",[dict objectForKey:@"sessionId"]];
    NSString *url = [NSString stringWithFormat:@"%@f_125_12_1.service?p2=%@&p1=%@&%@",kServerAddressTest2,userId,sessionId,appinfoStr];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
     __block YS_HtmlPayViewController *payVC=self;
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        [payVC setValue:jsonStr forKey:@"payTeyeStr"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [payVC loadWebView];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"系统参数请求失败--%@-",error);
    }];
}
//请求购买项目
- (void)getDataArr{
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *url = [NSString stringWithFormat:@"%@f_115_12_1.service?p1=%@&p2=%@&a78=%@&a13=%@&%@",kServerAddressTest2,p1,p2,_payComboType,_payMainCode,appInfo];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    __block YS_HtmlPayViewController *payVC=self;
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        [payVC setValue:jsonStr forKey:@"goodInfoStr"];
        [payVC getPayMethod];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    __block YS_HtmlPayViewController *payVC=self;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.jsContext = [self.myWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        
        NSLog(@"%@",self.payTeyeStr);
        NSLog(@"%@",self.goodInfoStr);
        //传购买项目
        self.jsContext[@"setGoodsInfo"]=^(){
            return payVC.goodInfoStr;
        };
        //传支付方式
        self.jsContext[@"setPayType"]=^(){
            return payVC.payTeyeStr;
        };
        
        //点击购买按钮
        self.jsContext[@"startToBuy"]=^(NSString *payType,NSString *GoodCode){//继续未完成的订单,付款

            if (!IS_STRING_NULL_OR_EMPTY(payType) && !IS_STRING_NULL_OR_EMPTY(GoodCode)) {
                
                payRequsestFlag payflag=(payRequsestFlagZFB|payRequsestFlagNG|payRequsestFlagWX|payRequsestFlagYL|payRequsestFlagZF|payRequsestFlagHFBZF|payRequsestFlagHFBWX|payRequsestFlagHFBYL);
                if ((payflag & [payType integerValue])) {
                    if ([payType integerValue] ==payRequsestFlagWX && ![WXApi isWXAppInstalled]) {
                        [payVC alertViewOfTitle:@"未检测到微信客户端" msg:@"请安装微信"];
                    }
                    
                    [payVC payAgainAction:[payType integerValue] GoodId:GoodCode];
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
        [self.HUD hide:YES];
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 支付
#pragma mark --- 下单
//订单支付
- (void) payAgainAction:(NSInteger)payRequsestFlag GoodId:(NSString *)GoodId {
    NSString *payNum = [NSString stringWithFormat:@"%ld",(long)payRequsestFlag];
    [self.payWorking PaydataRuquesByGoodId:GoodId payType:payNum success:^(NSDictionary *dic) {
        NSNumber *codeNum = dic[@"code"];
        if ([codeNum integerValue] == 200) {
            NSMutableDictionary *wxpayDic = [dic[@"body"] mutableCopy];
            [wxpayDic setObject:GoodId forKey:@"dh_goodId"];
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
#pragma mark 弹窗
- (void)p_setupProgressHud
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.HUD = [[MBProgressHUD alloc]initWithView: self.myWebView];
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
        
        [self.myWebView addSubview:_HUD];
        [_HUD show:YES];
    });
    
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
- (void) alertViewOfTitle:(NSString *)title msg:(NSString *)msg{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alter show];
}
#pragma mark jypayworking代理
-(void)noticePayResult:(BOOL)issuccess msg:(NSString *)msg{
    if (issuccess) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserInfosWhenUpdate" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"extractVipWhenPay" object:nil];
        [self payAction:nil];
    }else{
        NSDictionary *goodDict=[NSGetTools getSystemGoodsByType:2];
        if ([_payMainCode isEqualToString: [NSString stringWithFormat:@"%@",[goodDict objectForKey:@"b13"]]]) {//写信
            [Mynotification postNotificationName:@"pushPayNotificationWhenPayForFailure" object:@(6)];
        }else{//VIP
            [Mynotification postNotificationName:@"pushPayNotificationWhenPayForFailure" object:@(5)];
        }
        
        [self alertViewOfTitle:@"提示" msg:msg];
    }
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
