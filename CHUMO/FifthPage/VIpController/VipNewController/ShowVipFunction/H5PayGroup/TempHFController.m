//
//  TempHFController.m
//  StrangerChat
//
//  Created by zxs on 16/1/7.
//  Copyright © 2016年 long. All rights reserved.
//

#import "TempHFController.h"
#import <JavaScriptCore/JavaScriptCore.h>
//#import "PayViewController.h"
#import "ShowVipController.h"
#import "HFVipViewController.h"
#import "WXPayController.h"
#import "RefreshController.h"
#import "JYPayWorking.h"
#import "DHAlertView.h"
@interface TempHFController ()<UIWebViewDelegate,JYPayWorkingDelegate,DHAlertViewDelegate> {
    NSString *number;
    
}

@property (nonatomic,strong)JSContext *jsCondex;
@property (nonatomic, strong)UIWebView *myWeb;
@property (nonatomic,strong)JYPayWorking *payWorking;
@property (nonatomic,strong)NSString *codePrefix;
@property (nonatomic,assign) BOOL isnetWroking;
@end

@implementation TempHFController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self p_setupProgressHud];
    });
    [self privilege];
    
    if (_dicts!=nil) {
        [self layoutTempTableView];
        
    }else{
        _dicts =[NSMutableDictionary dictionary];
        [self Userinformation];

        
    }
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-arrow"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];
    [Mynotification addObserver:self selector:@selector(payAction:) name:@"payAction" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(havingNetworking:) name:@"AFNetworkReachabilityStatusYes" object:nil];
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
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ----请求数据
#pragma mark ----- 完成
- (void)Userinformation {  // 用户信息 （完成）
    
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *url = [NSString stringWithFormat:@"%@f_108_13_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            NSDictionary *dict2 = infoDic[@"body"];
            for (NSString *key in dict2) {
#pragma mark -----  b112大部分的内容
                if ([key isEqualToString:@"b112"]) {
                    NSDictionary *Valuedic = [dict2 objectForKey:key];
                    
                    for (NSString *userinfo in Valuedic) {
                        
                        [self addWithKeyStr:userinfo EqualStr:@"b34"  userValuedic:Valuedic contentKey:@"id"];
                        [self addWithKeyStr:userinfo EqualStr:@"b37"  userValuedic:Valuedic contentKey:@"kidney"];
                        [self addWithKeyStr:userinfo EqualStr:@"b88"  userValuedic:Valuedic contentKey:@"weight"];
                        [self addWithKeyStr:userinfo EqualStr:@"b24"  userValuedic:Valuedic contentKey:@"favorite"];
                        [self addWithKeyStr:userinfo EqualStr:@"b39"  userValuedic:Valuedic contentKey:@"liveTogether"];
                        [self addWithKeyStr:userinfo EqualStr:@"b45"  userValuedic:Valuedic contentKey:@"loveType"];
                        [self addWithKeyStr:userinfo EqualStr:@"b47"  userValuedic:Valuedic contentKey:@"marrySex"];
                        [self addWithKeyStr:userinfo EqualStr:@"b46"  userValuedic:Valuedic contentKey:@"marriageStatus"];
                        [self addWithKeyStr:userinfo EqualStr:@"b19"  userValuedic:Valuedic contentKey:@"educationLevel"];
                        [self addWithKeyStr:userinfo EqualStr:@"b9"   userValuedic:Valuedic contentKey:@"city"];
                        [self addWithKeyStr:userinfo EqualStr:@"b67"  userValuedic:Valuedic contentKey:@"province"];
                        [self addWithKeyStr:userinfo EqualStr:@"b1"   userValuedic:Valuedic contentKey:@"age"];
                        [self addWithKeyStr:userinfo EqualStr:@"b69"  userValuedic:Valuedic contentKey:@"sex"];
                        [self addWithKeyStr:userinfo EqualStr:@"b74"  userValuedic:Valuedic contentKey:@"star"];
                        [self addWithKeyStr:userinfo EqualStr:@"b30"  userValuedic:Valuedic contentKey:@"hasChild"];
                        [self addWithKeyStr:userinfo EqualStr:@"b31"  userValuedic:Valuedic contentKey:@"hasLoveOther"];
                        [self addWithKeyStr:userinfo EqualStr:@"b32"  userValuedic:Valuedic contentKey:@"hasRoom"];
                        [self addWithKeyStr:userinfo EqualStr:@"b29"  userValuedic:Valuedic contentKey:@"hasCar"];
                        [self addWithKeyStr:userinfo EqualStr:@"b52"  userValuedic:Valuedic contentKey:@"nickName"];
                        [self addWithKeyStr:userinfo EqualStr:@"b86"  userValuedic:Valuedic contentKey:@"wageMax"];
                        [self addWithKeyStr:userinfo EqualStr:@"b87"  userValuedic:Valuedic contentKey:@"wageMin"];
                        [self addWithKeyStr:userinfo EqualStr:@"b4"   userValuedic:Valuedic contentKey:@"birthday"];
                        [self addWithKeyStr:userinfo EqualStr:@"b80"  userValuedic:Valuedic contentKey:@"userId"];
                        [self addWithKeyStr:userinfo EqualStr:@"b62"  userValuedic:Valuedic contentKey:@"profession"];
                        [self addWithKeyStr:userinfo EqualStr:@"b5"   userValuedic:Valuedic contentKey:@"blood"];
                        [self addWithKeyStr:userinfo EqualStr:@"b17"  userValuedic:Valuedic contentKey:@"describe"];
                        [self addWithKeyStr:userinfo EqualStr:@"b33"  userValuedic:Valuedic contentKey:@"height"];
                        [self addWithKeyStr:userinfo EqualStr:@"b8"   userValuedic:Valuedic contentKey:@"charmPart"];
                        [self addWithKeyStr:userinfo EqualStr:@"b44"  userValuedic:Valuedic contentKey:@"loginTime"];
                        [self addWithKeyStr:userinfo EqualStr:@"b57"  userValuedic:Valuedic contentKey:@"photoUrl"];
                        [self addWithKeyStr:userinfo EqualStr:@"b142" userValuedic:Valuedic contentKey:@"photoStatus"];
                        [self addWithKeyStr:userinfo EqualStr:@"b118" userValuedic:Valuedic contentKey:@"d1Status"];
                        [self addWithKeyStr:userinfo EqualStr:@"b75"  userValuedic:Valuedic contentKey:@"status"];
                        [self addWithKeyStr:userinfo EqualStr:@"b152" userValuedic:Valuedic contentKey:@"systemName"];
                        [self addWithKeyStr:userinfo EqualStr:@"b144" userValuedic:Valuedic contentKey:@"vip"];
                        [self addWithKeyStr:userinfo EqualStr:@"b143" userValuedic:Valuedic contentKey:@"userType"];
                    }
                }
            }
            [self layoutTempTableView];
        }else if([infoDic[@"code"] integerValue] == 500){
            if (self.isnetWroking) {
                RefreshController *refre = [[RefreshController alloc] init];
                [self presentViewController:refre animated:YES completion:nil];
            }else{
                [self showHint:@"没有网络,还怎么浪~~"];
            }
//            RefreshController *refre = [[RefreshController alloc] init];
//            [self presentViewController:refre animated:YES completion:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"系统参数请求失败--%@-",error);
        //        RefreshController *refre = [[RefreshController alloc] init];
        //        [self presentViewController:refre animated:YES completion:nil];
    }];
}


/**
 *  Description
 *
 *  @param keystr       原来请求的b112里面的key 如b11 b2等
 *  @param equalStr     找到对应的b1 b3 b4等数
 *  @param userValuedic 根据key 取到的value
 *  @param contentKey   需要给h5的key
 */
- (void)addWithKeyStr:(NSString *)keystr EqualStr:(NSString *)equalStr userValuedic:(NSDictionary *)userValuedic contentKey:(NSString *)contentKey{
    
    if ([keystr isEqualToString:equalStr]) {
        NSString *userinfoValue = [userValuedic objectForKey:keystr];
        NSString *birthday = contentKey;
        [_dicts setValue:userinfoValue forKey:birthday];
        
    }
}
#pragma mark --- return true false

- (void)privilege {  // 完成
    
    
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *url = [NSString stringWithFormat:@"%@f_115_13_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            number = infoDic[@"body"];
        }else if([infoDic[@"code"] integerValue] == 500){
            if (self.isnetWroking) {
                RefreshController *refre = [[RefreshController alloc] init];
                [self presentViewController:refre animated:YES completion:nil];
            }else{
                [self showHint:@"没有网络,还怎么浪~~"];
            }
//            RefreshController *refre = [[RefreshController alloc] init];
//            [self presentViewController:refre animated:YES completion:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"系统参数请求失败--%@-",error);
        //        RefreshController *refre = [[RefreshController alloc] init];
        //        [self presentViewController:refre animated:YES completion:nil];
    }];
    
}


- (void)layoutTempTableView
{
#pragma mark --- web
    dispatch_async(dispatch_get_main_queue(), ^{
        self.myWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
        [self.view addSubview: _myWeb];
        self.myWeb.delegate = self;
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlWeb] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:1];
        [self.myWeb loadRequest:request];
    });
    
}
#pragma mark --- web代理
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    self.jsCondex = [self.myWeb valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
    __block TempHFController *THFVC=self;
    self.jsCondex[@"getUserInfo"] = ^(){  // 2  完成
        NSString *Webtitle = [THFVC.myWeb stringByEvaluatingJavaScriptFromString:@"document.title"];
        THFVC.navigationItem.title=Webtitle;
        NSString *str = [TempHFController dictionaryToJson:_dicts];
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
        NSString *Webtitle = [THFVC.myWeb stringByEvaluatingJavaScriptFromString:@"document.title"];
        dispatch_async(dispatch_get_main_queue(), ^{
            THFVC.navigationItem.title=Webtitle;
        });
        NSNumber *p2 = [NSGetTools getUserID];//ID
        return p2;
    };
    
    self.jsCondex[@"checkCode"] = ^(){ // 4 分类特权信息  True:vip  False:非VIP  f_115_13_1.service  // 返回0 获1判断权限
        
        int numbers = [number intValue];
        return numbers;
    };
    
    self.jsCondex[@"openWeb"] = ^(NSString *tempUrl){ // 获取URL重新加载页面 完成
        dispatch_async(dispatch_get_main_queue(), ^{
        ShowVipController *show = [[ShowVipController alloc] init];
        //        show.title = @"VIP专属特权";
        show.showUrl = tempUrl;
        show.dicts=THFVC.dicts;
        show.number=number;
        [THFVC.navigationController pushViewController:show animated:true];
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
        dispatch_async(dispatch_get_main_queue(), ^{
        WXPayController *wxpay = [[WXPayController alloc] init];
        wxpay.title = @"付费界面";
        wxpay.payDic = responseJSON;
        [THFVC.navigationController pushViewController:wxpay animated:true];
        });
    };
    
    self.jsCondex[@"setTitle"] = ^(NSString *msg){  // 8 setTitle 跳转页面动态标题
        NSLog(@"%@",msg);
        
    };
    
    self.jsCondex[@"decryptJson"] = ^(NSString *jsondata){ // 11 json解密
        
        NSString *jsonStr = [NSGetTools DecryptWith:jsondata];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSString *str=nil;
        if (infoDic!=nil) {
            str = [TempHFController dictionaryToJson:infoDic];
        }
        
        return str;
    };
    
    self.jsCondex[@"setPayData"]=^(NSString *orderdata){//继续未完成的订单,付款
        NSData *JSONData = [orderdata dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        if (responseJSON!=nil) {
            THFVC.payWorking =[JYPayWorking shareJYPayWorking];
            THFVC.payWorking.delegate=THFVC;
            NSInteger payType =  [responseJSON[@"b130"] integerValue];
            NSString *prefix=responseJSON[@"b131"];
            payRequsestFlag payflag=(payRequsestFlagNG|payRequsestFlagWX|payRequsestFlagYL|payRequsestFlagZF|payRequsestFlagHFBZF|payRequsestFlagHFBWX|payRequsestFlagHFBYL);
            if ((payflag & payType)) {
                if (payType ==payRequsestFlagWX && ![WXApi isWXAppInstalled]) {
                    [THFVC alertViewOfTitle:@"未检测到微信客户端" msg:@"请安装微信"];
                }
                NSString *strs=[[NSString stringWithFormat:@"%@",prefix] substringWithRange:NSMakeRange(0, 4)];
                [THFVC setValue:strs forKey:@"codePrefix"];
                [THFVC payAgainAction:payType GoodId:prefix];
            }
            
        }
             
        
    };
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.HUD hide:YES];
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
//订单支付
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) alertViewOfTitle:(NSString *)title msg:(NSString *)msg{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alter show];
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
#pragma mark 实时检测网络
-(void)havingNetworking:(NSNotification *)isNetWorking{
    NSString *sender = isNetWorking.object;
    self.isnetWroking=[sender boolValue];
    
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
