//
//  DetailObject.h
//  StrangerChat
//
//  Created by zxs on 15/12/15.
//  Copyright © 2015年 long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailObject : NSObject
#pragma mark --- 邮箱
+ (void)updateMailboxWithStr:(NSString *)mailbox;
+ (NSString *)getMailbox;

#pragma mark --- 注册意向  intention
+ (void)updateIntentionWithStr:(NSString *)intention;
+ (NSString *)getIntention;

#pragma mark --- 婚姻状况  Marriage
+ (void)updateMarriageWithStr:(NSString *)marriage;
+ (NSString *)getMarriage;

#pragma mark --- 是否有房  House
+ (void)updateHouseWithStr:(NSString *)house;
+ (NSString *)getHouse;

#pragma mark --- 是否有车  car
+ (void)updateCarWithStr:(NSString *)car;
+ (NSString *)getCar;

#pragma mark --- 魅力部位  charm
+ (void)updatecharmWithStr:(NSString *)charm;
+ (NSString *)getcharm;

#pragma mark --- 是否接受异地恋  relationship
+ (void)updateRelationshipmWithStr:(NSString *)relationship;
+ (NSString *)getRelationship;

#pragma mark --- 喜欢的异性类型  Specific
+ (void)updateSpecificWithStr:(NSString *)specific;
+ (NSString *)getSpecific;

#pragma mark --- 婚前性行为     sexual
+ (void)updateSexualWithStr:(NSString *)sexual;
+ (NSString *)getSexual;

#pragma mark --- 和父母同住     parent
+ (void)updateParentWithStr:(NSString *)parent;
+ (NSString *)getParent;
#pragma mark --- 是否要小孩     child
+ (void)updateChildWithStr:(NSString *)child;
+ (NSString *)getChild;
@end
