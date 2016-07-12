//
//  NickName.m
//  Texts
//
//  Created by zxs on 16/2/22.
//  Copyright © 2016年 YSKS.cn. All rights reserved.
//

#import "NickName.h"

@implementation NickName
/**
 *  返回昵称
 *
 *  @param sex 性别1男2女
 *
 *  @return 返回昵称
 */
+ (NSString *)arc4randomNickName:(NSInteger)sex {
    
    NSMutableArray *boyNous = @[].mutableCopy;
    NSMutableArray *goyNous = @[].mutableCopy;
    [boyNous removeAllObjects];
    [goyNous removeAllObjects];
    NSString *bnouns   = [self adddictionary:@"bnouns"];   // 男名词
    NSString *badject  = [self adddictionary:@"badject"];  // 男形容词
    NSString *gnouns   = [self adddictionary:@"gnouns"];   // 女名词
    NSString *gadject  = [self adddictionary:@"gadject"];  // 女形容词
    NSString *currency = [self adddictionary:@"currency"]; // 通用名词
    NSString *cadject  = [self adddictionary:@"cadject"];  // 通用形容词
    // 获取
    NSString *boyf  = [NSString stringWithFormat:@"%@%@",badject,bnouns];
    NSString *boys  = [NSString stringWithFormat:@"%@%@",badject,currency];
    NSString *girlf = [NSString stringWithFormat:@"%@%@",gadject,gnouns];
    NSString *girls = [NSString stringWithFormat:@"%@%@",gadject,currency];
    NSString *bAgt  = [NSString stringWithFormat:@"%@%@",cadject,currency];  // 男女共用
    NSInteger randomIndex = arc4random() % 3;
    [boyNous addObject:boyf];
    [boyNous addObject:boys];
    [boyNous addObject:bAgt];
    [goyNous addObject:girlf];
    [goyNous addObject:girls];
    [goyNous addObject:bAgt];
    if (sex == 1) { // 1男2女
        return boyNous[randomIndex];
    }else{
        return goyNous[randomIndex];
    }
}

+ (NSString *)adddictionary:(NSString *)nouns {
    
    NSError *error;
    NSString *bnouns = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:nouns ofType:@"txt"]encoding:NSUTF8StringEncoding error:&error];
    NSArray *arr = [bnouns componentsSeparatedByString:@","];
    
    NSInteger randomIndex = arc4random() % arr.count-1;
    if (randomIndex < 0) { // 当randomIndex小于0是数组越界
        return arr[0];
    }else {
        return arr[randomIndex];
    }
}

@end
