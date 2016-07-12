//
//  NSGetTools.m
//  StrangerChat
//
//  Created by long on 15/10/12.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "NSGetTools.h"
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation NSGetTools

// UUID
+ (NSString *)getUUID
{
    NSString *strUUID = [JNKeychain loadValueForKey:@"StrangerChat"];
    
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || strUUID == nil)
        
    {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        if ([JNKeychain saveValue:strUUID forKey:@"StrangerChat"]) {
            NSLog(@"UUID修改成功");
        }else{
            NSLog(@"UUID存储失败");
        }
        
    }
    
//    NSLog(@"UUID----------------***********-----------%@",strUUID);
    
    return strUUID;
}


// 手机号验证   ^1[3|4|5|7|8][0-9]{9}$
+(BOOL)checkPhoneNum:(NSString *)textString
{
    
    NSString* number=@"^1[3|4|5|7|8][0-9]{9}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
    
}

// 验证密码
+ (BOOL)checkPassWord:(NSString *)textString
{
    NSString* number=@"^[A-Za-z0-9]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}


// 加密
+ (NSString *)EncryptionWith:(NSString *)jsonString
{
    NSString *encStr = nil;
    
    if ([jsonString isEqualToString:@""] || jsonString == nil)
    {
        encStr = nil;
    }
    else
    {
        encStr = [SecurityUtil encryptAESData:jsonString app_key:KEY];
        
        
        
    }
    
//    NSLog(@"加密后string：%@", encStr);
    return encStr;
    
}


//解密
+ (NSString *)DecryptWith:(NSString *)encString
{
    NSString *decStr = nil;
    
    if ([encString isEqualToString:@""] || encString == nil)
    {
        // 数据加载异常
        decStr = nil;
    }
    else
    {
        NSData *EncryptData = [GTMBase64 decodeString:encString]; //解密前进行GTMBase64编码
        NSString * string = [SecurityUtil decryptAESData:EncryptData app_key:KEY];
        
      
        if ([string isEqualToString:@""] | [string isEqualToString:nil]) {
            
            // 数据加载异常
            
            decStr = nil;
        }else{
            
            decStr = [string copy];
        }
    
    }
    //NSLog(@"解密后string：%@", decStr);
    return decStr;
}


// 字典格式字符串转字典
+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString
{
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    if (JSONData) {
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        return responseJSON;

    }
    return nil;
}


// 获取手机型号
+ (NSString *)getCurrentDevice
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini";
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini";
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini";
    if ([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    return platform;
}


//用来辨别设备所使用网络的运营商
+ (NSString*)checkCarrier

{
    
    NSString *ret = [[NSString alloc]init];
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    
    CTCarrier *carrier = [info subscriberCellularProvider];
    
    if (carrier == nil) {
        
        
        
        return @"未知运营商";
        
    }
    
    NSString *code = [carrier mobileNetworkCode];
    
    if ([code  isEqual: @""]) {
        
        
        
        return @"未知运营商";
        
    }
    
    if (code == nil) {
        
        
        
        return @"未知运营商";
        
    }
    
    if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"]) {
        
        ret = @"移动";
    }
    
    if ([code isEqualToString:@"01"]|| [code isEqualToString:@"06"] ) {
        ret = @"联通";
    }
    
    if ([code isEqualToString:@"03"]|| [code isEqualToString:@"05"] ) {
        ret = @"电信";;
    }
    
//    NSLog(@"---%@----%@-^^^^%@",carrier,code,ret);
    return ret;
    
}



// 网络类型
+(NSString *)getNetWorkStates
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = @"无网络";
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
//            NSLog(@"netType---->%d",netType);
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                {
                    state = @"WIFI";
                }
                    break;
                default:
                    state = @"未知类型";
                    break;
            }
        }
        
    }
    //根据状态选择
    return state;
}

// 获取app名字
+ (NSString *)getAPPName
{
    //app应用相关信息的获取
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    //    CFShow(dicInfo);
    
    NSString *strAppName = [dicInfo objectForKey:@"CFBundleDisplayName"];
//    NSLog(@"App应用名称：%@", strAppName);
    
    return strAppName;
    
}

// 获取app版本
+ (NSString *)getAppVersion
{
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *strAppVersion = [dicInfo objectForKey:@"CFBundleShortVersionString"];
//    NSLog(@"App应用版本：%@", strAppVersion);
    
    return strAppVersion;
    
}

// 获取appBuild
+ (NSString *)getAppBuild
{
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *strAppBuild = [dicInfo objectForKey:@"CFBundleVersion"];
//    NSLog(@"App应用Build版本：%@", strAppBuild);
    
    
    return strAppBuild;
}

//获取Bundle identifier
+ (NSString *)getBundleID
{
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *strBundleID  =   [dicInfo objectForKey:@"CFBundleIdentifier"];
//    [[dicInfo objectForKey:@"CFBundleIdentifier"] substringToIndex:[[dicInfo objectForKey:@"CFBundleIdentifier"] length]-1];
//    NSLog(@"App应用BundleID: %@",strBundleID);
    
    return strBundleID;
}


// 网络判断
+ (BOOL) isConnectionAvailable
{    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    if (!isExistenceNetwork) {
        
        return NO;
    }
    
    return isExistenceNetwork;
}

// 获取app的公共参数
+ (NSString *)getAppInfoString
{
    NSString *m2 = [NSGetTools getIMEI];
    NSString *m3 = [NSGetTools getUUID];// UUID
    NSString *m4 = [NSGetTools getAPPName];// 应用名字
    NSString *m5 = [[NSGetTools getAppVersion] stringByReplacingOccurrencesOfString:@"." withString:@""];// 应用版本号(纯数字)
    NSString *m6 = [NSGetTools getAppVersion];// 应用版本号
    
    
    NSString *m7 = @"2";// 系统平台
    NSString *m8 = [[UIDevice currentDevice] systemVersion];// 系统版本号
    NSString *m9 = [NSString stringWithFormat:@"%@",@""];
    
    NSString *m10 = [NSGetTools checkCarrier];// 运营商
    NSString *m11 = Channel;// 渠道号
    NSString *m12 = [NSGetTools getNetWorkStates];// 网络类型
    NSString *m13 = [NSString stringWithFormat:@"%ld",(NSInteger)CGRectGetWidth([[UIScreen mainScreen] bounds])];// 屏宽
    NSString *m14 = [NSString stringWithFormat:@"%ld",(NSInteger)ScreenHeight];// 屏高
    NSString *m15 = [NSGetTools getCurrentDevice];// 手机型号
    NSString *m16 = kAPPIDOFChuMo;// app包名
    NSString *m17 = @"Apple";// 手机厂商
    NSString *m18 = [NSGetTools getBundleID];// app包名
    
    NSString *appInfoStr = [NSString stringWithFormat:@"m2=%@&m3=%@&m4=%@&m5=%@&m7=%@&m8=%@&m10=%@&m11=%@&m12=%@&m13=%@&m14=%@&m16=%@&m17=%@&m6=%@&m9=%@&m15=%@&m18=%@",m2,m3,m4,m5,m7,m8,m10,m11,m12,m13,m14,m16,m17,m6,m9,m15,m18];
    
    return appInfoStr;
}
+ (NSString *)getIMEI{
    NSString *imei = [JNKeychain loadValueForKey:@"com.imchumo.youshon"];
    if (!imei) {
        NSString *identifierForVendor = [[[UIDevice currentDevice].identifierForVendor UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [JNKeychain saveValue:identifierForVendor forKey:@"com.imchumo.youshon"];
        return identifierForVendor;
    }else{
        return imei;
    }
}
// 获取app的公共参S数字典
+ (NSDictionary *)getAppInfoDict
{
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:p1 forKey:@"p1"];
    [dict setValue:p2 forKey:@"p2"];
    //    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    //    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    //
    //    NSString *countrycode = carrier.mobileCountryCode;
    //    NSString *carriercode =  carrier.mobileNetworkCode;
    //    NSString *isoCountryCode = carrier.isoCountryCode;
    //    NSString *m1 = [NSGetTools getIMEI];
    NSString *m2 = [NSGetTools getIMEI];
    NSString *m3 = [NSGetTools getUUID];// UUID
    NSString *m4 = [NSGetTools getAPPName];// 应用名字
    NSString *m5 = [[NSGetTools getAppVersion] stringByReplacingOccurrencesOfString:@"." withString:@""];// 应用版本号(纯数字)
    NSString *m6 = [NSGetTools getAppVersion];// 应用版本号
    
    
    NSString *m7 = @"2";// 系统平台
    NSString *m8 = [[UIDevice currentDevice] systemVersion];// 系统版本号
    NSString *m9 = [NSString stringWithFormat:@"%@",@""];
    
    NSString *m10 = [NSGetTools checkCarrier];// 运营商
    NSString *m11 = Channel;// 渠道号
    NSString *m12 = [NSGetTools getNetWorkStates];// 网络类型
    NSString *m13 = [NSString stringWithFormat:@"%ld",(NSInteger)CGRectGetWidth([[UIScreen mainScreen] bounds])];// 屏宽
    NSString *m14 = [NSString stringWithFormat:@"%ld",(NSInteger)ScreenHeight];// 屏高
    NSString *m15 = [NSGetTools getCurrentDevice];// 手机型号
    NSString *m16 = kAPPIDOFChuMo;// app包名
    NSString *m17 = @"Apple";// 手机厂商
    NSString *m18 = [NSGetTools getBundleID];// app包名
    
    
    //    [dict setObject:m1 forKey:@"m1"];
    [dict setObject:m2 forKey:@"m2"];
    [dict setObject:m3 forKey:@"m3"];
    [dict setObject:m4 forKey:@"m4"];
    [dict setObject:m5 forKey:@"m5"];
    [dict setObject:m6 forKey:@"m6"];
    [dict setObject:m7 forKey:@"m7"];
    [dict setObject:m8 forKey:@"m8"];
    [dict setObject:m9 forKey:@"m9"];
    [dict setObject:m10 forKey:@"m10"];
    [dict setObject:m11 forKey:@"m11"];
    [dict setObject:m12 forKey:@"m12"];
    [dict setObject:m13 forKey:@"m13"];
    [dict setObject:m14 forKey:@"m14"];
    [dict setObject:m15 forKey:@"m15"];
    [dict setObject:m16 forKey:@"m16"];
    [dict setObject:m17 forKey:@"m17"];
    [dict setObject:m18 forKey:@"m18"];
    
    return dict;
}



+ (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}

//弹出提示框
+ (void)showAlert:(NSString *)message
{
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}

// 晃动提示
+ (void)shotTipAnimationWith:(UIView *)view
{
    // 获取到当前的View
    CALayer *viewLayer = view.layer;
    // 获取当前View的位置
    //CGPoint position1 = viewLayer.position;
    CGPoint anchorPoint1 = viewLayer.anchorPoint;
    // 移动的两个终点位置
    //        CGPoint x = CGPointMake(position1.x + 10, position1.y );
    //        CGPoint y = CGPointMake(position1.x - 10, position1.y );
    
    CGPoint x = CGPointMake(anchorPoint1.x + 0.1,anchorPoint1.y );
    CGPoint y = CGPointMake(anchorPoint1.x - 0.1 ,anchorPoint1.y );
    
    // 设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"anchorPoint"];
    // 设置运动形式
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    // 设置开始位置
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    // 设置结束位置
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    // 设置自动反转
    // [animation setAutoreverses:YES];
    // 设置时间
    [animation setDuration:0.08];
    // 设置次数
    [animation setRepeatCount:3];
    // 添加上动画
    [viewLayer addAnimation:animation forKey:nil];

}


#pragma mark  ---是否登陆---
+ (void)updateIsLoadWithStr:(NSString *)load
{
    NSString *isLoad = [self EncryptionWith:load];
    
    //将上述数据全部存储到NSUserDefaults中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
    [userDefaults setObject:isLoad forKey:@"loaded"];
    
    //这里建议同步存储到磁盘中，但是不是必须的,最好写上
    [userDefaults synchronize];
    
}

#pragma mark ---获取登录---
+ (NSString *)getIsLoad
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取整型int类型的数据
    NSString *isLoadStr = [userDefaultes objectForKey:@"loaded"];
    
    NSString *isLoad = [self DecryptWith:isLoadStr];
    
    if (isLoad) {
        return isLoad;
    }else{
        isLoad = @"noLoad";
    }
    return isLoad;
}

#pragma mark  ---聊天注册---
+ (void)updateChatRegistWithStr:(NSString *)registr
{
   
    
    //将上述数据全部存储到NSUserDefaults中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
    [userDefaults setObject:registr forKey:@"register"];
    
    //这里建议同步存储到磁盘中，但是不是必须的,最好写上
    [userDefaults synchronize];
    
}

#pragma mark ---获取注册信息---
+ (NSString *)getIsRegister
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取整型int类型的数据
    NSString *isRegister = [userDefaultes objectForKey:@"register"];
    
   
    
    if (!isRegister || isRegister == nil || [isRegister isEqualToString:@""]) {
        isRegister = @"noRegister";
    }else{
        return isRegister;
    }
    
//    NSLog(@"------------------------%@",isRegister);
    return isRegister;
}

#pragma mark  ---聊天token---
+ (void)updateTokenWithStr:(NSString *)token
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:token forKey:@"chatToken"];
    
    [userDefaults synchronize];
    
}

#pragma mark ---获取token---
+ (NSString *)getToken
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaultes objectForKey:@"chatToken"];

    return token;
}


#pragma mark  ---聊天房间---
+ (void)updateRoomCodeWithStr:(NSString *)roomCode
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:roomCode forKey:@"roomCode"];
    
    [userDefaults synchronize];
    
}

#pragma mark ---获取房间号---
+ (NSString *)getRoomCode
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *roomCode = [userDefaultes objectForKey:@"roomCode"];
    
    return roomCode;
}


#pragma mark ---用户ID------
+ (void)upDateUserID:(NSNumber *)userID
{
    NSUserDefaults *userIDDefaultes = [NSUserDefaults standardUserDefaults];
    [userIDDefaultes setObject:userID forKey:@"SCUserID"];
    
    [userIDDefaultes synchronize];
    
//    if ([JNKeychain saveValue:userID forKey:@"SCUserID"]) {
//        NSLog(@"supervip修改成功");
//    }else{
//        NSLog(@"supervip存储失败");
//    }

}

// 获取用户ID
+ (NSNumber *)getUserID
{
    
//    NSNumber *userID = [JNKeychain loadValueForKey:@"SCUserID"];
//    
//
//    return userID;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSNumber *userID = (NSNumber *)[userDefaultes objectForKey:@"SCUserID"];
    
    return userID;
   
}


#pragma mark ---sessionIdID------
+ (void)upDateUserSessionId:(NSString *)sessionId
{
   
    if ([JNKeychain saveValue:sessionId forKey:@"SessionId"]) {
        NSLog(@"supervip修改成功");
    }else{
        NSLog(@"supervip存储失败");
    }

}

// 获取用户sessionId
+ (NSString *)getUserSessionId
{
    NSString *sessionId = [JNKeychain loadValueForKey:@"SessionId"];
    return sessionId;
}


#pragma mark ---VIP------
+ (void)upDateUserVipInfo:(NSNumber *)vipNum
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:vipNum forKey:@"b144"];
    
    [userDefaults synchronize];
}

// 获取用户VIP
+ (NSNumber *)getUserVipInfo
{

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSNumber *vipNum = [userDefaultes objectForKey:@"b144"];
    
    return vipNum;
}


#pragma mark     --------------------------------------------------
// 信息资料修改包b34
+ (void)upDateB34:(NSNumber *)num
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:num forKey:@"b34"];
    
    [userDefaults synchronize];
}

+ (NSNumber *)getB34
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSNumber *b34Num = [userDefaultes objectForKey:@"b34"];
    
    return b34Num;
}

// 头像b34
+ (void)upDateIconB34:(NSNumber *)num
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:num forKey:@"iconB34"];
    
    [userDefaults synchronize];

}

+ (NSNumber *)getIconB34
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSNumber *b34Num = [userDefaultes objectForKey:@"iconB34"];
    
    return b34Num;
}


// 头像b75
+ (void)upDateIconB75:(NSNumber *)num
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:num forKey:@"iconB75"];
    
    [userDefaults synchronize];

}

+ (NSNumber *)getIconB75
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSNumber *num = [userDefaultes objectForKey:@"iconB75"];
    
    return num;
}


// 头像b57连接
+ (void)upDateIconB57:(NSString *)iconUrl
{
   
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:iconUrl forKey:@"iconUrl"];
    
    [userDefaults synchronize];

}

+ (NSString *)getIconB57
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *iconUrl = [userDefaultes objectForKey:@"iconUrl"];
    return iconUrl;
}




#pragma mark ---账号----
+ (void)updateUserAccount:(NSString *)accountNum
{
    //将上述数据全部存储到NSUserDefaults中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
    [userDefaults setObject:accountNum forKey:@"userAccount"];
    
    //这里建议同步存储到磁盘中，但是不是必须的,最好写上
    [userDefaults synchronize];
    
}
+ (NSString *)getUserAccount
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *accountNum = [userDefaultes objectForKey:@"userAccount"];
    
//    NSLog(@"------------------------%@",accountNum);
    return accountNum;
}

#pragma mark ---密码----
+ (void)updateUserPassWord:(NSString *)passWord
{
    //将上述数据全部存储到NSUserDefaults中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
    [userDefaults setObject:passWord forKey:@"userPassword"];
    
    //这里建议同步存储到磁盘中，但是不是必须的,最好写上
    [userDefaults synchronize];
    
}
+ (NSString *)getUserPassWord
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *passWord = [userDefaultes objectForKey:@"userPassword"];
    
//    NSLog(@"------------------------%@",passWord);
    return passWord;
}


// 信息资料  ----------------------------------------------------

#pragma mark ---性别----
+ (void)updateUserSexInfoWithB69:(NSNumber *)sexNum
{
    //将上述数据全部存储到NSUserDefaults中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
    [userDefaults setObject:sexNum forKey:@"userSex"];
    
    //这里建议同步存储到磁盘中，但是不是必须的,最好写上
    [userDefaults synchronize];

}
+ (NSNumber *)getUserSexInfo
{
//    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//    NSNumber *sexNum = [userDefaultes objectForKey:@"userSex"];
//    
////    NSLog(@"------------------------%@",sexNum);
//    return sexNum;
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
    
    NSNumber *sexNum = [NSNumber numberWithInteger:[userInfo.b69 integerValue]];
    return sexNum;
}




#pragma mark  ---信息资料---
+ (void)updateUserInfoWithDict:(NSMutableDictionary *)dict
{
   
    //将上述数据全部存储到NSUserDefaults中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
    [userDefaults setObject:dict forKey:@"userInfo"];
    
    //这里建议同步存储到磁盘中，但是不是必须的,最好写上
    [userDefaults synchronize];
    
}
#pragma mark ---信息资料--
+ (NSMutableDictionary *)getUserInfoDict
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [userDefaultes objectForKey:@"userInfo"];
    
//    NSLog(@"------------------------%@",dict);
    return dict;
}



//获取本地头像
+ (UIImage *)getHeadIcon
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
//    NSLog(@"imageFile->>%@",imageFilePath);
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//
    //NSData *photoData = [NSData dataWithContentsOfFile:imageFilePath];
    return  selfPhoto;
}



+ (NSString*) replaceUnicode:(NSString*)aUnicodeString

{
    
    NSString *tempStr1 = [aUnicodeString stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                           
                                                          mutabilityOption:NSPropertyListImmutable
                           
                                                                    format:NULL
                           
                                                          errorDescription:NULL];
    
    
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    
}

// 文字高度
+ (CGFloat)calsLabelHeightWithText:(NSString *)text
{
    //size:表示允许文字所在的最大范围
    //options: 一个参数,计算高度时候用 NSStringDrawingUserLineFragmentOrigin
    //attributes:表示文字的某个属性(通常是文字大小)
    //context:上下文对象,通常写nil;
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(got(315), 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:got(16)]} context:nil];
    
    return rect.size.height+10;
    
}


#pragma mark  ---地理位置---
+ (void)updateCLLocationWithDict:(NSMutableDictionary *)dict
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"CLLocation"];
    [userDefaults synchronize];
}

+ (NSDictionary *)getCLLocationData
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"CLLocation"];
//    NSLog(@"------------------------%@",dict);
    return dict;
}

#pragma mark  ---首页眼缘b96,是否有下一页---
+ (void)updateB96WithNum:(NSNumber *)b96
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:b96 forKey:@"luckB96"];
    [userDefaults synchronize];
}

+ (NSNumber *)getLuckB96
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSNumber *b96 = [userDefaultes objectForKey:@"luckB96"];
//    NSLog(@"------------------------%@",b96);
    return b96;
}

#pragma mark  ---附近人b96,是否有下一页---
+ (void)updateNearPeopleB96WithNum:(NSNumber *)b96
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:b96 forKey:@"nearB96"];
    [userDefaults synchronize];
}

+ (NSNumber *)getNearPeopleB96
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSNumber *b96 = [userDefaultes objectForKey:@"nearB96"];
//    NSLog(@"------------------------%@",b96);
    return b96;
}

#pragma mark  ---搜索b96,是否有下一页---
+ (void)updateSearchB96WithNum:(NSNumber *)b96
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:b96 forKey:@"searchB96"];
    [userDefaults synchronize];
}

+ (NSNumber *)getSearchB96
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSNumber *b96 = [userDefaultes objectForKey:@"searchB96"];
//    NSLog(@"------------------------%@",b96);
    return b96;
}


// 搜索条件保存
+ (void)updateSearchSetWithDict:(NSDictionary *)dict
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSLog(@"---存储的字典--%@",dict);
    [userDefaults setObject:dict forKey:@"searchSet"];
    [userDefaults synchronize];
}

+ (NSDictionary *)getSearchSetDict
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"searchSet"];
    
    return dict;
}


// 搜索条件用
+ (NSNumber *)getSystemNumWithDict:(NSDictionary *)dict value:(NSString *)value
{
    int b = 0;
    NSArray *arr = [dict allValues];
    for (int a = 0; a<[arr count]; a++) {
        NSString *str = arr[a];
        if ([str isEqualToString:value]) {
            b = a;
        }
    }

    NSArray *arr2 = [dict allKeys];
    NSNumber *num2 = arr2[b];
    
    return num2;
    
}
#pragma mark ---昵称----
+ (void)updateUserNickName:(NSString *)nickName
{
    //将上述数据全部存储到NSUserDefaults中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
    [userDefaults setObject:nickName forKey:@"userNickName"];
    
    //这里建议同步存储到磁盘中，但是不是必须的,最好写上
    [userDefaults synchronize];
    
}
+ (NSString *)getUserNickName
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *accountNum = [userDefaultes objectForKey:@"userNickName"];
    
    //    NSLog(@"------------------------%@",accountNum);
    return accountNum;
}
+ (void) logOutService{
    // 清除userdefault 里所有数据
    NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults]dictionaryRepresentation];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *date = [[[DHTool shareTool] stringFromDate:[NSDate date]] substringToIndex:10];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    //明天时间
    NSString *tomorrow = [[[DHTool shareTool] stringFromDate:[[NSDate alloc] initWithTimeIntervalSinceNow:secondsPerDay]] substringWithRange:NSMakeRange(0, 10)];
    NSString *afterTomorrow = [[[DHTool shareTool] stringFromDate:[NSDate dateWithTimeIntervalSinceNow:secondsPerDay * 2]] substringWithRange:NSMakeRange(0, 10)];
    for (NSString *key in [defaultsDictionary allKeys]) {
        // 不删除发消息
        if (![[NSString stringWithFormat:@"%@-%@",date,userId] isEqualToString:key] &&![[NSString stringWithFormat:@"%@-firstRobot",date] isEqualToString:key] && ![[NSString stringWithFormat:@"%@-secondRobot",date] isEqualToString:key] &&![@"CLLocation" isEqualToString:key] &&[[NSString stringWithFormat:@"%@_%@hasSended",date,userId] isEqualToString:key] && ![[NSString stringWithFormat:@"%@_%@_%d_hasSend",date,userId,1] isEqualToString:key]&& ![[NSString stringWithFormat:@"%@_%@_%d_hasSend",date,userId,2] isEqualToString:key]&& ![[NSString stringWithFormat:@"%@_%@_%d_hasSend",date,userId,3] isEqualToString:key] &&![[NSString stringWithFormat:@"%@_%@_paysuccess",date,userId] isEqualToString:key] &&![[NSString stringWithFormat:@"%@_%@_paysuccess",tomorrow,userId] isEqualToString:key]&&![[NSString stringWithFormat:@"%@_%@_registerDate",date,userId] isEqualToString:key]&&![[NSString stringWithFormat:@"%@_%@_registerDate",tomorrow,userId] isEqualToString:key] &&![[NSString stringWithFormat:@"%@_%@_registerDate",afterTomorrow,userId] isEqualToString:key] && ![[NSString stringWithFormat:@"%@_suitRobotHasSended",userId] isEqualToString:key]) {
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        }
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//保存购买项目
+ (void)updateSystemGoodsInfo:(NSArray *)goodsInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setObject:goodsInfo forKey:@"SystemGoodsInfoArray"];

    [userDefaults synchronize];
}
+ (NSArray *)getSystemGoodsInfo{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSArray *goodArray = [userDefaultes objectForKey:@"SystemGoodsInfoArray"];
    
    return goodArray;
}
+ (NSDictionary *)getSystemGoodsByType:(NSInteger)type{
    NSArray *goodsArray = [NSGetTools getSystemGoodsInfo];
    for (NSDictionary *dict in goodsArray) {
        if ([[dict objectForKey:@"b78"] integerValue]==type) {
            return dict;
        }
    }
    return nil;
}
@end
