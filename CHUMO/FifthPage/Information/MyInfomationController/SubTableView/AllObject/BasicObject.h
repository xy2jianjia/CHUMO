//
//  BasicObject.h
//  StrangerChat
//
//  Created by zxs on 15/12/15.
//  Copyright © 2015年 long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicObject : NSObject {

    NSInteger _codeNum;  // 编码

}
- (instancetype)initWithCodeNum:(NSInteger)num;
- (NSComparisonResult)compareUsingcodeNum:(BasicObject *)cnum;   // 排序
- (NSComparisonResult)compareUsingcodeblood:(BasicObject *)blood;   // 排序
- (NSInteger)conum;

#pragma mark --- 出生日期
+ (void)updatebornDayWithStr:(NSString *)bornDay;
+ (NSString *)getbornDay;

#pragma mark --- 居住
+ (void)updateliveWithStr:(NSString *)live;
+ (NSString *)getlive;

#pragma mark --- 星座
+ (void)updateconstellationWithStr:(NSString *)constellation;
+ (NSString *)getconstellation;

#pragma mark --- 血型
+ (void)updatebloodWithStr:(NSString *)blood;
+ (NSString *)getblood;

#pragma mark --- 身高
+ (void)updateheightWithStr:(NSString *)height;
+ (NSString *)getheight;

#pragma mark --- 体重
+ (void)updateweihtWithStr:(NSString *)weiht;
+ (NSString *)getweiht;

#pragma mark --- 学历 Education
+ (void)updateEducationWithStr:(NSString *)education;
+ (NSString *)getEducation;

#pragma mark --- 职业 Occupation
+ (void)updateOccupationWithStr:(NSString *)occupation;
+ (NSString *)getOccupation;

#pragma mark --- 月收入 income
+ (void)updateincomeWithStr:(NSString *)income;
+ (NSString *)getIncome;
@end
