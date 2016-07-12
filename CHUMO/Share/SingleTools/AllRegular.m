//
//  AllRegular.m
//  StrangerChat
//
//  Created by zxs on 15/12/18.
//  Copyright © 2015年 long. All rights reserved.
//

#import "AllRegular.h"

@implementation AllRegular


+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

#pragma mark  --- 记录页面
+ (void)updatehasCarWithDict:(NSString *)interger
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:interger forKey:@"interger"];
    [userDefaults synchronize];
}

+ (NSString *)getInterger
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSString *interger = [userDefaultes objectForKey:@"interger"];
//    NSLog(@"------------------------%@",interger);
    return interger;
}


@end
