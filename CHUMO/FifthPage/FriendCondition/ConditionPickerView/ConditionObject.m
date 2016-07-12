//
//  ConditionObject.m
//  StrangerChat
//
//  Created by zxs on 15/12/22.
//  Copyright © 2015年 long. All rights reserved.
//

#import "ConditionObject.h"
#import "ConditionModel.h"
#import "EncodingPro.h"
@implementation ConditionObject


#pragma mark  --- 年龄
+ (void)updateAgeWithStr:(NSString *)age
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:age forKey:@"conditionAge"];
    [userDefaults synchronize];
}
+ (NSString *)getAge
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *ageStr = [userDefaultes objectForKey:@"conditionAge"];
    return ageStr;
}

#pragma mark  --- 身高
+ (void)updateHeightWithStr:(NSString *)height
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:height forKey:@"conditionHeight"];
    [userDefaults synchronize];
}
+ (NSString *)getHeight
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *heightStr = [userDefaultes objectForKey:@"conditionHeight"];
    return heightStr;
}

#pragma mark  --- 婚姻
+ (void)updateMarriageWithStr:(NSString *)marriage
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:marriage forKey:@"conditionMarriage"];
    [userDefaults synchronize];
}
+ (NSString *)getMarriage
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *marriageStr = [userDefaultes objectForKey:@"conditionMarriage"];
    return marriageStr;
}

#pragma mark  --- 学历
+ (void)updateEducationWithStr:(NSString *)education
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:education forKey:@"conditionEducation"];
    [userDefaults synchronize];
}
+ (NSString *)getEducation
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *educationStr = [userDefaultes objectForKey:@"conditionEducation"];
    return educationStr;
}

#pragma mark  --- 收入
+ (void)updateIncomeWithStr:(NSString *)income
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:income forKey:@"conditionIncome"];
    [userDefaults synchronize];
}
+ (NSString *)getIncome
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *incomeStr = [userDefaultes objectForKey:@"conditionIncome"];
    return incomeStr;
}


#pragma mark  --- 地区
+ (void)updateProvincesWithStr:(NSString *)provinces
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:provinces forKey:@"conditionProvinces"];
    [userDefaults synchronize];
}
+ (NSString *)getProvinces
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *provincesStr = [userDefaultes objectForKey:@"conditionProvinces"];
    return provincesStr;
}

/**
 *  @return 返回市区的字典 上传数据
 */
+ (NSDictionary *)obtainDict {
    
    NSMutableDictionary *marketDicm = [NSMutableDictionary dictionary];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cityCode.plist" ofType:nil];
    NSDictionary *cityPlist = [NSDictionary dictionaryWithContentsOfFile:filePath];
    for (NSString *key in cityPlist) {
        NSDictionary *valueDic = [cityPlist objectForKey:key];
        ConditionModel *code = [[ConditionModel alloc] init];
        code.name = valueDic[@"city_name"];
        code.num = valueDic[@"city_code"];
        [marketDicm setValue:code.num forKey:code.name];
    }
    NSDictionary *markdic = [NSDictionary dictionaryWithDictionary:marketDicm];
    return markdic;
}

// Province
+ (NSDictionary *)provinceDict {
    
    NSMutableDictionary *marketDicm = [NSMutableDictionary dictionary];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"provinceCode.plist" ofType:nil];
    NSDictionary *cityPlist = [NSDictionary dictionaryWithContentsOfFile:filePath];
    for (NSString *key in cityPlist) {
        NSDictionary *valueDic = [cityPlist objectForKey:key];
        EncodingPro *code = [[EncodingPro alloc] init];
        code.province = valueDic[@"province_name"];
        code.numberOfPro = valueDic[@"provence_code"];
        [marketDicm setValue:code.numberOfPro forKey:code.province];
    }
    NSDictionary *markdic = [NSDictionary dictionaryWithDictionary:marketDicm];
    return markdic;
}


@end
