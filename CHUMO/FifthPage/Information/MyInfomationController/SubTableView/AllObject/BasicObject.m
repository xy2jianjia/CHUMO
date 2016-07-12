//
//  BasicObject.m
//  StrangerChat
//
//  Created by zxs on 15/12/15.
//  Copyright © 2015年 long. All rights reserved.
//

#import "BasicObject.h"

@implementation BasicObject

- (instancetype)initWithCodeNum:(NSInteger)num {

    if (self = [super init]) {
        _codeNum = num;
    }
    return self;
}

- (NSString *)description {

    return [NSString stringWithFormat:@"%ld",_codeNum];
}
- (NSComparisonResult)compareUsingcodeNum:(BasicObject *)cnum {
    
    if (_codeNum < [cnum conum]) { //返回1
        return NSOrderedDescending;
    }else if(_codeNum == [cnum conum]){ //返回0
        return NSOrderedSame;
    }else{        //返回-1
        return NSOrderedAscending;
    }
}

- (NSComparisonResult)compareUsingcodeblood:(BasicObject *)blood {

    if (_codeNum > [blood conum]) { //返回1
        return NSOrderedDescending;
    }else if(_codeNum == [blood conum]){ //返回0
        return NSOrderedSame;
    }else{        //返回-1
        return NSOrderedAscending;
    }
}


- (NSInteger)conum {
    
    return _codeNum;
}


#pragma mark  ---出生日期---
+ (void)updatebornDayWithStr:(NSString *)bornDay
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:bornDay forKey:@"bornDay"];
    [userDefaults synchronize];
}

#pragma mark ---出生日期---
+ (NSString *)getbornDay
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *bornDayStr = [userDefaultes objectForKey:@"bornDay"];
    return bornDayStr;
}

#pragma mark --- 居住
+ (void)updateliveWithStr:(NSString *)live {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:live forKey:@"live"];
    [userDefaults synchronize];
}
+ (NSString *)getlive {
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *liveStr = [userDefaultes objectForKey:@"live"];
    return liveStr;
}

#pragma mark --- 星座
+ (void)updateconstellationWithStr:(NSString *)constellation {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:constellation forKey:@"constellation"];
    [userDefaults synchronize];
    
}
+ (NSString *)getconstellation {
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *constellationStr = [userDefaultes objectForKey:@"constellation"];
    return constellationStr;
}

#pragma mark --- 血型
+ (void)updatebloodWithStr:(NSString *)blood {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:blood forKey:@"bloods"];
    [userDefaults synchronize];
    
}
+ (NSString *)getblood {
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *bloodStr = [userDefaultes objectForKey:@"bloods"];
    return bloodStr;
}

#pragma mark --- 身高
+ (void)updateheightWithStr:(NSString *)height {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:height forKey:@"height"];
    [userDefaults synchronize];
}
+ (NSString *)getheight {
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *heightStr = [userDefaultes objectForKey:@"height"];
    return heightStr;
}

#pragma mark --- 体重
+ (void)updateweihtWithStr:(NSString *)weiht {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:weiht forKey:@"weiht"];
    [userDefaults synchronize];
}
+ (NSString *)getweiht {
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *weihtStr = [userDefaultes objectForKey:@"weiht"];
    return weihtStr;
}

#pragma mark --- 学历 Education
+ (void)updateEducationWithStr:(NSString *)education {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:education forKey:@"education"];
    [userDefaults synchronize];
}
+ (NSString *)getEducation {

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *educationStr = [userDefaultes objectForKey:@"education"];
    return educationStr;
}

#pragma mark --- 职业 Occupation
+ (void)updateOccupationWithStr:(NSString *)occupation {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:occupation forKey:@"occupation"];
    [userDefaults synchronize];
}
+ (NSString *)getOccupation {
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *occupationStr = [userDefaultes objectForKey:@"occupation"];
    return occupationStr;
}

#pragma mark --- 月收入 income
+ (void)updateincomeWithStr:(NSString *)income {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:income forKey:@"income"];
    [userDefaults synchronize];
}
+ (NSString *)getIncome {
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *incomeStr = [userDefaultes objectForKey:@"income"];
    return incomeStr;
}

@end
