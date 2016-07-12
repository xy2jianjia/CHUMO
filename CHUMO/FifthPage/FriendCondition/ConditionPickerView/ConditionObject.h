//
//  ConditionObject.h
//  StrangerChat
//
//  Created by zxs on 15/12/22.
//  Copyright © 2015年 long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConditionObject : NSObject

+ (void)updateAgeWithStr:(NSString *)age;
+ (NSString *)getAge;

+ (void)updateHeightWithStr:(NSString *)height;
+ (NSString *)getHeight;

+ (void)updateMarriageWithStr:(NSString *)marriage;
+ (NSString *)getMarriage;

+ (void)updateEducationWithStr:(NSString *)education;
+ (NSString *)getEducation;

+ (void)updateIncomeWithStr:(NSString *)income;
+ (NSString *)getIncome;

+ (void)updateProvincesWithStr:(NSString *)provinces;
+ (NSString *)getProvinces;

+ (NSDictionary *)obtainDict;  // 返回区域地址上传编号
+ (NSDictionary *)provinceDict; // 省份反编码
@end
