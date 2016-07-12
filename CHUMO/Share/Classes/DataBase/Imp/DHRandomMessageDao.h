//
//  DHRandomMessageDao.h
//  DHBaseFrameWork
//
//  Created by xy2 on 16/3/23.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DBManager.h"

@interface DHRandomMessageDao : DBManager
/**
 *  检查随机消息是否存在
 *
 *  @param userId    当前用户id
 *  @param messageId 消息id，b34
 *
 *  @return
 */
+ (BOOL) checkRandomMessageWithUsertId:(NSString *)userId messageId:(NSString *)messageId;
/**
 *  插入随机消息
 *
 *  @param item
 *  @param userId 当前用户id
 */
+ (void) insertRandomMessageToDBWithItem:(DHRandomMessageModel *)item userId:(NSString *)userId;
/**
 *  查询某类型的随机一条消息
 *
 *  @param userId      当前用户id
 *  @param messageType 消息类型
 *
 *  @return <#return value description#>
 */
+ (DHRandomMessageModel *)getRandomMessageWithCurrentUserId:(NSString *)userId messageType:(NSString *)messageType;
@end
