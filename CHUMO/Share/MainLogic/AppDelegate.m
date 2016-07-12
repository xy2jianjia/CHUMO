//
//  AppDelegate.m
//  StrangerChat
//
//  Created by long on 15/10/2.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MainViewController.h"
#import "DHLoginViewController.h"
#import "AccountController.h"
//#import "IpaynowPluginApi.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import "DHUserInfoModel.h"
//#import <HeePay/HeePay.h>
#import <AlipaySDK/AlipaySDK.h>
#import <Foundation/Foundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

/**
 *  保存统计信息,激活 --by大海 2016年06月28日15:35:48
 */
- (void)collectSaveWithStatus:(NSInteger )status{
    [HttpOperation asyncCollectSaveWithUserType:status queue:dispatch_get_main_queue() completed:^(NSString *msg, NSInteger code) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"保存激活统计" message:msg delegate:nil cancelButtonTitle:[NSString stringWithFormat:@"%ld",code] otherButtonTitles:nil, nil];
//            [alert show];
        });
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasOpened"];
    }];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:@"loginStateChange"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChangeAndLogin:) name:@"loginStateChangeAndLogin"object:nil];
    [[NIMSDK sharedSDK] registerWithAppID:live_im_appkey cerName:live_im_cer];
//    [Mynotification addObserver:self selector:@selector(loginZhuJinAcction:) name:@"loginZhuJinAcction" object:nil];
    [self loginZhuJinAcction:nil];
    
    // 延迟启动画面
    [NSThread sleepForTimeInterval:3.0];
    [self.window makeKeyAndVisible];
    
    #warning mark 上线时解开
//    // 友盟
    // 友盟
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick updateOnlineConfig];
    // reportPolicy:BATCH 启动时发送策略包
    // channelId:推广渠道为nil时默认@"App Store"
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:Channel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
    TencentOAuth *tencentOAuth=[[TencentOAuth alloc]initWithAppId:@"1104937933"andDelegate:self];
    
    [WXApi registerApp:@"wx1b389c3a19f8062b"];
    
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             categories:nil]];
        
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        //这里还是原来的代码
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    // 保存统计信息（激活）
    BOOL hasOpened = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasOpened"];
    if (!hasOpened) {
        [self collectSaveWithStatus:1];
        
    }
    
    
    return YES;
}
- (void)onlineConfigCallBack:(NSNotification *)note {
    
//    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

#pragma mark ----重写微信 openURL（return是微信的方法） 和 handleOpenURL方法
////9.0后弃用 Xcode7.2 不能用了
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    
    return [WXApi handleOpenURL:url delegate:self]||[TencentOAuth HandleOpenURL:url];
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    
    return  [WXApi handleOpenURL:url delegate:self]||[TencentOAuth HandleOpenURL:url];
    

}
//9.0新加的
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
              }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            
        }];
    }
    return [WXApi handleOpenURL:url delegate:self]||[TencentOAuth HandleOpenURL:url];
}

#pragma mark  ----微信代理方法 实现和微信终端交互请求与回应
- (void)onReq:(BaseReq *)req {
   
    
}

- (void)onResp:(BaseResp *)resp {
    
    
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    if (nil!=[userDefaults objectForKey:@"WXissendReq"] && [userDefaults objectForKey:@"WXissendReq"]) {
        [userDefaults removeObjectForKey:@"WXissendReq"];//账号
        [userDefaults synchronize];
        // wxpay
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        NSString *strTitle;
        
        if([resp isKindOfClass:[SendMessageToWXResp class]])
        {
            strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        }
        if([resp isKindOfClass:[PayResp class]]){
            //支付返回结果，实际支付结果需要去微信服务器端查询
            strTitle = [NSString stringWithFormat:@"支付结果"];
            
            switch (resp.errCode) {
                case WXSuccess:{
                    strMsg = @"支付结果：成功！";
                    
                    NSDictionary *tempDcit = [[NSUserDefaults standardUserDefaults] objectForKey:@"wxPay_goodsInfos"];
                    [self saveCollectPayWithGoodsInfo:tempDcit];
                    NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                    [Mynotification postNotificationName:@"payAction" object:nil];
                    [Mynotification postNotificationName:@"getUserInfosWhenUpdate" object:nil];
                    [Mynotification postNotificationName:@"extractVipWhenPay" object:nil];
                }
                    break;
                    
                default:
                    strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                    NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                    break;
            }
        }
    }else{
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode == 0) { // 用户同意
            NSLog(@"errCode = %d", aresp.errCode);
            NSLog(@"code = %@", aresp.code);
            
            // 获取access_token
            //      格式：https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
            NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", APP_ID, APP_SECRET, aresp.code];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL *zoneUrl = [NSURL URLWithString:url];
                NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
                NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (data) {
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        _openid = [dic objectForKey:@"openid"]; // 初始化
                        _access_token = [dic objectForKey:@"access_token"];
                        //                    NSLog(@"openid = %@", _openid);
                        //                    NSLog(@"access = %@", [dic objectForKey:@"access_token"]);
                        NSLog(@"dic = %@", dic);
                        [self getUserInfo]; // 获取用户信息
                        //                    [self requestopenid:_openid access_token:_access_token wxStr:@"1"];
                        if (nil!=[userDefaults objectForKey:@"WXisSendBinding"] && [userDefaults objectForKey:@"WXisSendBinding"]) {
                            [userDefaults removeObjectForKey:@"WXisSendBinding"];//账号
                            [userDefaults synchronize];
                            
                        }else{
                            if (_access_token && 0 != [_access_token length])
                            {
                                //  记录登录用户的OpenID、Token以及过期时间
                                NSLog(@"登陆返回");
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"WXBoundCancleAction" object:@"NO"];
                                //第三方登陆
                                AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
                                manger.responseSerializer = [AFHTTPResponseSerializer serializer];
                                manger.requestSerializer = [AFHTTPRequestSerializer serializer];
                                manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
                                NSString *appinfoStr = [NSGetTools getAppInfoString];
                                
                                NSString *url = [NSString stringWithFormat:@"%@f_132_10_1.service?a162=%@&a167=%@&a169=%@&%@",kServerAddressTest4,@"1",_openid,_access_token,appinfoStr];
                                url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                                [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    NSData *datas = responseObject;
                                    NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
                                    NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
                                    NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
                                    NSNumber *codeNum=infoDic[@"code"];
                                    if ([codeNum integerValue]==200) {
                                        if ([infoDic[@"body"][@"b168"] integerValue]==0) {
                                            //去注册绑定
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXBoundAction" object:infoDic[@"body"]];
                                        }else{
                                            //登陆
                                            
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXLoginAction" object:infoDic[@"body"]];
                                        }
                                        
                                    }
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"请求失败");
                                }];
                                
                                
                            }
                            else
                            {
                                NSLog(@"登录不成功 没有获取accesstoken");
                                
                            }
                        }
                        
                        
                    }
                });
            });
        } else if (aresp.errCode == -2) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXBoundCancleAction" object:@"YES"];
            NSLog(@"用户取消登录");
        } else if (aresp.errCode == -4) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXBoundCancleAction" object:@"YES"];
            NSLog(@"用户拒绝登录");
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXBoundCancleAction" object:@"YES"];
            NSLog(@"errCode = %d", aresp.errCode);
            NSLog(@"code = %@", aresp.code);
        }
    }
    
    
    
}
/**
 *  保存支付日期，用于判断机器人机制 --bydh 2016年06月14日15:41:43
 */
- (void)saveCollectPayWithGoodsInfo:(NSDictionary *)goodsInfo{
    //    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    //    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSString *today = [[fmt stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(0, 10)];
    //    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    //    //    [[NSUserDefaults standardUserDefaults] setObject:today forKey:[NSString stringWithFormat:@"%@_%@_paysuccess",today,userId]];
    //    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_%@_paysuccess",today,userId]];
    //    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    //    //明天时间
    //    NSString *tomorrow = [[fmt stringFromDate:[[NSDate alloc] initWithTimeIntervalSinceNow:secondsPerDay]] substringWithRange:NSMakeRange(0, 10)];
    //    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_%@_paysuccess",tomorrow,userId]];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [[fmt stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(0, 10)];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    //
    BOOL istodayReg = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@_%@_registerDate",date,userId]];
    NSInteger newer = 2;
    if (istodayReg) {
        newer = 1;
    }else{
        newer = 2;
    }
    NSInteger payType = [[goodsInfo objectForKey:@"dh_payType"] integerValue];
    float price = price = [[goodsInfo objectForKey:@"realFeel"] floatValue];;
    NSString *orderNum = [goodsInfo objectForKey:@"outTradeNo"];
    NSString *goodId = [goodsInfo objectForKey:@"dh_goodId"];
    
    [HttpOperation asyncCollectPaySaveWithPayType:payType price:price status:1 goodCode:goodId orderNum:orderNum userType:newer queue:dispatch_get_main_queue() completed:^(NSString *msg, NSInteger code) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"wxPay_goodsInfos"];
        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"保存微信支付成功统计" message:msg delegate:nil cancelButtonTitle:[NSString stringWithFormat:@"%ld",code] otherButtonTitles:nil, nil];
//            [alert show];
        });
    }];
    
    
}

/**
 *  保存支付日期，用于判断机器人机制 --bydh 2016年06月14日15:41:43
 */
- (void)savePayForChat{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *today = [[fmt stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(0, 10)];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    //    [[NSUserDefaults standardUserDefaults] setObject:today forKey:[NSString stringWithFormat:@"%@_%@_paysuccess",today,userId]];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_%@_paysuccess",today,userId]];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    //明天时间
    NSString *tomorrow = [[fmt stringFromDate:[[NSDate alloc] initWithTimeIntervalSinceNow:secondsPerDay]] substringWithRange:NSMakeRange(0, 10)];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_%@_paysuccess",tomorrow,userId]];
}
- (void)requestopenid:(NSString *)openid access_token:(NSString *)access_token wxStr:(NSString *)wxStr{ // @"http://127.0.0.1:8088/Lp-author-msc/f_122_10_1.service"   http://115.236.55.163:9093/lp-author-msc//f_122_10_1.service
    AFHTTPRequestOperationManager *headins_manger = [AFHTTPRequestOperationManager manager];
    headins_manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *loopurlPath = [NSString stringWithFormat:@"http://115.236.55.163:9093/lp-author-msc/f_132_10_1.service?a167=%@&a169=%@&a162=%@",openid,access_token,wxStr];
    [headins_manger GET:loopurlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
         NSLog(@"所有的---------》%@",infoDic);
        
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
           
            NSLog(@"isbinding = %@", [infoDic objectForKey:@"b168"]); // 是否绑定 0未绑定 1绑定
            NSLog(@"userId = %@", [infoDic objectForKey:@"b163"]);
            NSLog(@"headimgurl = %@", [infoDic objectForKey:@"b166"]);
            NSLog(@"nickName = %@", [infoDic objectForKey:@"b164"]);
            NSLog(@"openid = %@", [infoDic objectForKey:@"B167"]); // 唯一标识
            NSLog(@"sex = %@", [infoDic objectForKey:@"b165"]);
            NSLog(@"type = %@", [infoDic objectForKey:@"b162"]); // 用户类别 1微信 2QQ
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

// 获取用户信息
- (void)getUserInfo {
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", self.access_token, self.openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"openid = %@", [dic objectForKey:@"openid"]);
                NSLog(@"nickname = %@", [dic objectForKey:@"nickname"]);
                NSLog(@"sex = %@", [dic objectForKey:@"sex"]);
                NSLog(@"country = %@", [dic objectForKey:@"country"]);
                NSLog(@"province = %@", [dic objectForKey:@"province"]);
                NSLog(@"city = %@", [dic objectForKey:@"city"]);
                NSLog(@"headimgurl = %@", [dic objectForKey:@"headimgurl"]);
                NSLog(@"unionid = %@", [dic objectForKey:@"unionid"]);
                NSLog(@"privilege = %@", [dic objectForKey:@"privilege"]);
                
                
                
                AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appdelegate.headimgurl = [dic objectForKey:@"headimgurl"]; // 传递头像地址
                appdelegate.nickname = [dic objectForKey:@"nickname"]; // 传递昵称
                //                NSLog(@"appdelegate.headimgurl == %@", appdelegate.headimgurl); // 测试
                //                NSLog(@"appdelegate.nickname == %@", appdelegate.nickname);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Note" object:nil]; // 发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NoteBindWXAction" object:dic]; // 发送通知
            }
        });
    });
}
- (void)loginZhuJinAcction:(NSNotification *)notification{
    [self loadMainControllers];
    if (nil==[[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"]) {
        [self loginStateChange:nil];
    }else{
        [NSGetTools updateIsLoadWithStr:@"isLoad"];
        ViewController *vc = [[ViewController alloc]init];
        self.window.rootViewController = vc;
    }
    
}
//登陆状态改变
-(void)loginStateChange:(NSNotification *)notification
{
    NSString *isFirstLoaded = notification.object;
    if ([isFirstLoaded isEqualToString:@"YES"]) {
        AccountController *account = [[AccountController alloc] init];
        account.isFromReg = YES;
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:account];
        account.navigationItem.title = @"账号安全";
        account.navigationItem.hidesBackButton=YES;
        nc.navigationBar.barTintColor = [UIColor colorWithRed:0.576 green:0.302 blue:0.902 alpha:1.000];
        self.window.rootViewController = nc;
    }else{
        UINavigationController *nav = nil;
        BOOL isLoad = NO;
        NSString *isLoaded = [NSGetTools getIsLoad];
        if ([isLoaded isEqualToString:@"isLoad"]) {
            isLoad = YES;
        }else if ([isLoaded isEqualToString:@"noLoad"]){
            isLoad = NO;
        }else{
            isLoad = NO;
        }
        if (isLoad) {
            [self loadMainControllers];
            ViewController *vc = [[ViewController alloc]init];
            self.window.rootViewController = vc;
        }else{
            MainViewController *mainVC = [MainViewController new];
            nav = [[UINavigationController alloc] initWithRootViewController:mainVC];
            self.window.rootViewController = nav;
           
        }
    }
}
- (void)loginStateChangeAndLogin:(NSNotification *)notification{
    DHLoginViewController *loginVC = [DHLoginViewController new];
    loginVC.whoVC = @"login";
    loginVC.isthird=YES;
    self.window.rootViewController=loginVC;
}
- (void)loadMainControllers{
    
}
//- (void)registerNotification{
//    [Mynotification addObserver:self selector:@selector(getLocalNotification:) name:@"getLocalNotification" object:nil];
//}
//- (void)getLocalNotification:(NSNotification *)notifi{
//    [self localNotification:notifi.object];
//}
//-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
//    NSLog(@"%@",notificationSettings);
//}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"hhh" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//    });
    //获取本地推送数组
    
//    NSArray *localArr = [application scheduledLocalNotifications];
//    if (localArr.count > 2) {
//        //取消所有的本地通知
//        [application cancelLocalNotification:[localArr lastObject]];
//    }
    
    
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSInteger badgeValue = [DHMessageDao getBadgeValueWithTargetId:nil currentUserId:userId];
    application.applicationIconBadgeNumber = badgeValue;
    if (badgeValue) {
        [Mynotification postNotificationName:@"loadBadgeValue" object:nil];
    }
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    //将device token转换为字符串
    NSString *deviceTokenStr = [NSString stringWithFormat:@"%@",deviceToken];
    
    
    //modify the token, remove the  "<, >"
    NSLog(@"    deviceTokenStr  lentgh:  %ld  ->%@", [deviceTokenStr length], [[deviceTokenStr substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)]);
    deviceTokenStr = [[[deviceTokenStr substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"deviceTokenStr = %@",deviceTokenStr);
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
/**
 *  App进入后台
 *
 *  @param application
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
    
}
/**
 *  App将要从后台返回
 *
 *  @param application
 */
- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"WXBoundCancleAction" object:nil];
    // 直接打开app时，图标上的数字清零
    application.applicationIconBadgeNumber = 0;
//    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
//    [HeepaySDKManager heepaySDKWillEnterForeground];
    
}
- (void)resignLocalNotificationWithApplication:(UIApplication *)application{
    //获取本地推送数组
    
    NSArray *localArr = [application scheduledLocalNotifications];
    
    //取消所有的本地通知
    [application cancelAllLocalNotifications];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // 连接通信服务器
    [self resignLocalNotificationWithApplication:(UIApplication *)application];
}
/**
 *  申请处理时间
 *
 *  @param application
 */
- (void)applicationWillTerminate:(UIApplication *)application {
//    [[EaseMob sharedInstance] applicationWillTerminate:application];
}
-(void)dealloc{
    [Mynotification removeObserver:self];
}
@end
