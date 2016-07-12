//
//  NSGetSystemTools.h
//  StrangerChat
//
//  Created by long on 15/11/6.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSGetSystemTools : NSObject

#pragma mark  ---默认消息---
+ (void)updateDefaultMessageWithDict:(NSMutableDictionary *)dict;
+ (NSDictionary *)getDefaultMessage;

#pragma mark  ---魅力部位---
+ (void)updatecharmPartWithDict:(NSMutableDictionary *)dict;
+ (NSDictionary *)getcharmPart;

#pragma mark  ---婚姻状态---
+ (void)updatemarriageStatusWithDict:(NSMutableDictionary *)dict;
+ (NSDictionary *)getmarriageStatus;
#pragma mark  ---搜索婚姻状态---
+ (void)searchUpdatemarriageStatusWithDict:(NSMutableDictionary *)dict;
+ (NSDictionary *)getmarriageStatusInSearch;
#pragma mark  ---婚前性行为---
+ (void)updatemarrySexWithDict:(NSMutableDictionary *)dict;
+ (NSDictionary *)getmarrySex;

#pragma mark  ---职业---
+ (void)updateprofessionDict:(NSMutableDictionary *)dict;
+ (void)updateprofessionArray:(NSArray *)array;
+ (NSDictionary *)getprofession;
+ (NSArray *)getprofessionArray;
#pragma mark ---新的交友目的
+ (void)updatedatingPurposeWithDict:(NSMutableDictionary *)dict;
+ (NSDictionary *)getdatingPurpose;
#pragma mark ---新的爱爱地点20160630
+ (void)updatelovePlaceWithDict:(NSMutableDictionary *)dict;

+ (NSDictionary *)getlovePlace;
#pragma mark ---新的恋爱观的20160630
+ (void)updateIndulgedWithDict:(NSMutableDictionary *)dict;

+ (NSDictionary *)getIndulged;
#pragma mark ---新的首次见面地点20160630
+ (void)updateMeetPlaceWithDict:(NSMutableDictionary *)dict;

+ (NSDictionary *)getmeetPlace;
#pragma mark  ---喜欢的类型(女)---
+ (void)updateloveType2Dict:(NSMutableDictionary *)dict;
+ (NSDictionary *)getloveType2;

#pragma mark  ---异地恋---
+ (void)updatehasLoveOtherWithDict:(NSMutableDictionary *)dict;
+ (NSDictionary *)gethasLoveOther;

#pragma mark  ---星座---
+ (void)updatestarWithDict:(NSMutableDictionary *)dict;
+ (NSDictionary *)getstar;

#pragma mark  ---父母同住---
+ (void)updateliveTogetherWithDict:(NSMutableDictionary *)dict;
+ (NSDictionary *)getliveTogether;

#pragma mark  ---喜欢的类型(男)---
+ (void)updateloveType1WithDict:(NSMutableDictionary *)dict;
+ (NSDictionary *)getloveType1;
#pragma mark  ---举报原因---
+ (void)updatereport1WithDict:(NSMutableDictionary *)dict;
+ (NSDictionary *)getreport1;
#pragma mark  ---交友目的---
+ (void)updatepurposeWithDict:(NSMutableDictionary *)dict;
+ (void)updatepurposeWithArray:(NSArray *)array;
+ (NSDictionary *)getpurpose;
+ (NSArray *)getpurposeArray;

#pragma mark  ---血型---
+ (void)updatebloodWithDict:(NSMutableDictionary *)dict;
+ (NSDictionary *)getblood;

#pragma mark  ---车子---
+ (void)updatehasCarWithDict:(NSMutableDictionary *)dict;
+ (NSDictionary *)gethasCar;

#pragma mark  ---学历---
+ (void)updateeducationLevelWithDict:(NSMutableDictionary *)dict;
+ (void)updateeducationLevelWithArray:(NSArray *)array;
+ (NSDictionary *)geteducationLevel;
+ (NSArray *)geteducationLevelArray;

#pragma mark  ---小孩---
+ (void)updatehasChildWithDict:(NSMutableDictionary *)dict;
+ (NSDictionary *)gethasChild;

#pragma mark  ---系统参数---
+ (void)updatesystem_pmWithDict:(NSMutableDictionary *)dict;
+ (NSDictionary *)getsystem_pm;

#pragma mark  ---兴趣爱好(女)---
+ (void)updatefavorite2WithDict:(NSMutableDictionary *)dict;
+ (NSDictionary *)getfavorite2;

#pragma mark  ---兴趣爱好(男)---
+ (void)updatefavorite1WithDict:(NSMutableDictionary *)dict;
+ (void)updatefavorite1WithArr:(NSArray *)array;
+ (NSDictionary *)getfavorite1;
+ (NSArray *) getfavorite1Array;
#pragma mark  ---个性特征(男)---
+ (void)updatekidney1WithDict:(NSMutableDictionary *)dict;
+ (NSDictionary *)getkidney1;

#pragma mark  ---个性特征(女)---
+ (void)updatekidney2WithDict:(NSMutableDictionary *)dict;
+ (NSDictionary *)getkidney2;

#pragma mark  ---房子---
+ (void)updatehasRoomWithDict:(NSMutableDictionary *)dict;
+ (NSDictionary *)gethasRoom;

#pragma mark  ---时间戳---
+ (void)updatetimestemWithDict:(NSMutableDictionary *)dict;
+ (NSDictionary *)gettimestem;
//
//
// 年龄范围
+(NSArray *)getAgeData;
// 身高范围
+ (NSArray *)getBodyHeightData;
// 身高范围 单个值
+ (NSArray *)getBodyOneHeightData;
// 体重
+(NSArray *)getWeight;

@end
