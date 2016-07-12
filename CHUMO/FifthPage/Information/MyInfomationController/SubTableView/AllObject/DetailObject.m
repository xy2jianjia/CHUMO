//
//  DetailObject.m
//  StrangerChat
//
//  Created by zxs on 15/12/15.
//  Copyright © 2015年 long. All rights reserved.
//

#import "DetailObject.h"

@implementation DetailObject
#pragma mark --- 邮箱
+ (void)updateMailboxWithStr:(NSString *)mailbox {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:mailbox forKey:@"mailbox"];
    [userDefaults synchronize];
}
+ (NSString *)getMailbox {

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *mailboxStr = [userDefaultes objectForKey:@"mailbox"];
    return mailboxStr;
}

#pragma mark --- 注册意向  intention
+ (void)updateIntentionWithStr:(NSString *)intention {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:intention forKey:@"intention"];
    [userDefaults synchronize];
    
}
+ (NSString *)getIntention {
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *intentionStr = [userDefaultes objectForKey:@"intention"];
    return intentionStr;
}

#pragma mark --- 婚姻状况  Marriage
+ (void)updateMarriageWithStr:(NSString *)marriage {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:marriage forKey:@"marriage"];
    [userDefaults synchronize];
}
+ (NSString *)getMarriage {
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *marriageStr = [userDefaultes objectForKey:@"marriage"];
    return marriageStr;
}

#pragma mark --- 是否有房  House
+ (void)updateHouseWithStr:(NSString *)house {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:house forKey:@"house"];
    [userDefaults synchronize];
}
+ (NSString *)getHouse {
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *houseStr = [userDefaultes objectForKey:@"house"];
    return houseStr;
}

#pragma mark --- 是否有车  car
+ (void)updateCarWithStr:(NSString *)car {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:car forKey:@"havecar"];
    [userDefaults synchronize];
}
+ (NSString *)getCar {
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *carStr = [userDefaultes objectForKey:@"havecar"];
    return carStr;
}

#pragma mark --- 魅力部位  charm
+ (void)updatecharmWithStr:(NSString *)charm {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:charm forKey:@"charm"];
    [userDefaults synchronize];
}
+ (NSString *)getcharm {
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *charmStr = [userDefaultes objectForKey:@"charm"];
    return charmStr;
}

#pragma mark --- 是否接受异地恋  relationship
+ (void)updateRelationshipmWithStr:(NSString *)relationship {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:relationship forKey:@"relationship"];
    [userDefaults synchronize];
}
+ (NSString *)getRelationship {
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *relationshipStr = [userDefaultes objectForKey:@"relationship"];
    return relationshipStr;
}

#pragma mark --- 喜欢的异性类型  Specific
+ (void)updateSpecificWithStr:(NSString *)specific {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:specific forKey:@"specific"];
    [userDefaults synchronize];
}
+ (NSString *)getSpecific {
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *specificStr = [userDefaultes objectForKey:@"specific"];
    return specificStr;
}

#pragma mark --- 婚前性行为     sexual
+ (void)updateSexualWithStr:(NSString *)sexual {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:sexual forKey:@"sexual"];
    [userDefaults synchronize];
}
+ (NSString *)getSexual {
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *sexualStr = [userDefaultes objectForKey:@"sexual"];
    return sexualStr;
}

#pragma mark --- 和父母同住     parent
+ (void)updateParentWithStr:(NSString *)parent {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:parent forKey:@"parent"];
    [userDefaults synchronize];
}
+ (NSString *)getParent {
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *parentStr = [userDefaultes objectForKey:@"parent"];
    return parentStr;
}
#pragma mark --- 是否要小孩     child
+ (void)updateChildWithStr:(NSString *)child {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:child forKey:@"child"];
    [userDefaults synchronize];
}
+ (NSString *)getChild {
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *childStr = [userDefaultes objectForKey:@"child"];
    return childStr;
}
@end
