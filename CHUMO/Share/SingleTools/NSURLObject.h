//
//  NSURLObject.h
//  StrangerChat
//
//  Created by zxs on 15/12/23.
//  Copyright © 2015年 long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLObject : NSObject

+ (void)updateConditFriendWithStr:(NSString *)Condit;
+ (NSString *)getConditFriend;

+ (void)addWithVariableDic:(NSMutableDictionary *)variabledic;
+ (void)addWithdict:(NSMutableDictionary *)dict urlStr:(NSString *)urlStr;

+ (void)addWithNString:(NSString *)contentStr secStr:(NSString *)str flashDic:(NSMutableDictionary *)flashDict variableDic:(NSMutableDictionary *)variableDic aNum:(NSString *)aNum;

+ (void)addDataWithUploadStr:(NSString *)UploadStr originalStr:(NSString *)Original variableDic:(NSMutableDictionary *)variableDic aNum:(NSString *)aNum;

+ (void)addSexWithUploadStr:(NSString *)UploadStr originalStr:(NSString *)Original sexNum:(NSNumber *)sexNum flashDic:(NSMutableDictionary *)flashDict variableDic:(NSMutableDictionary *)variableDic aNum:(NSString *)aNum;

+ (void)addWithhBronUploadStr:(NSString *)UploadStr originalStr:(NSString *)Original variableDic:(NSMutableDictionary *)variableDic aNum:(NSString *)aNum;

+ (void)addWithLiveUploadStr:(NSString *)UploadStr originalStr:(NSString *)Original variableDic:(NSMutableDictionary *)variableDic aNum:(NSString *)aproNum acityNum:(NSString *)acityNum;

+ (void)addWithIncomeUploadStr:(NSString *)UploadStr originalStr:(NSString *)Original variableDic:(NSMutableDictionary *)variableDic maxNum:(NSString *)maxNum minNum:(NSString *)minNim;
+ (void)addWithSomeUploadStr:(NSString *)UploadStr originalStr:(NSString *)Original variableDic:(NSMutableDictionary *)variableDic separatedByString:(NSString *)separatedStr keyStr:(NSObject*)string, ...NS_REQUIRES_NIL_TERMINATION;
+ (void)addArrayWithNString:(NSString *)contentStr secStr:(NSString *)str flashDic:(NSArray *)flashArray variableDic:(NSMutableDictionary *)variableDic aNum:(NSString *)aNum ;
@end
