//
//  DHAppInfoManager.m
//  DHBaseFrameWork
//
//  Created by xy2 on 16/3/23.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHAppInfoManager.h"
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <UIKit/UIKit.h>
#include <sys/sysctl.h>
@implementation DHAppInfoManager


+ (NSDictionary *)asyncGetAppInfo{
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [dicInfo objectForKey:@"CFBundleDisplayName"];
    NSString *appVersion = [dicInfo objectForKey:@"CFBundleShortVersionString"];;// 应用版本号
    NSString *iPhoneOSVersion = [[UIDevice currentDevice] systemVersion];// 系统版本号
    NSString *operators = [DHAppInfoManager checkCarrier]; // 运营商
    NSString *iPhoneModel = [DHAppInfoManager getCurrentDevice];// 手机型号
    NSString *iPhoneNetWorkType = [DHAppInfoManager getNetWorkStates];// 网络类型
    NSString *bundleId = [dicInfo objectForKey:@"CFBundleIdentifier"];// app包名
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:appName forKey:@"appName"];
    [dict setObject:appVersion forKey:@"appVersion"];
    [dict setObject:iPhoneOSVersion forKey:@"iPhoneVersion"];
    [dict setObject:operators forKey:@"operators"];
    [dict setObject:iPhoneModel forKey:@"iPhoneModel"];
    [dict setObject:iPhoneNetWorkType forKey:@"iPhoneNetWorkType"];
    [dict setObject:bundleId forKey:@"bundleId"];
    return dict;
}
//用来辨别设备所使用网络的运营商
+ (NSString*)checkCarrier{
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
@end
