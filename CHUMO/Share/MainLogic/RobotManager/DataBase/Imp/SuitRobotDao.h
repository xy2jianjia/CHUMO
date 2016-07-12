//
//  SuitRobotDao.h
//  CHUMO
//
//  Created by xy2 on 16/6/2.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DBManager.h"

@interface SuitRobotDao : DBManager

/**
 *  检查随机消息是否存在
 *
 *  @param userId    当前用户id
 *  @param messageId 消息id，b34
 *
 *  @return
 */
+ (BOOL) checkRobotMessageWithUsertId:(NSString *)userId messageId:(NSString *)messageId;
/**
 *  插入随机消息
 *
 *  @param item
 *  @param userId 当前用户id
 */
+ (void) insertRobotMessageToDBWithItem:(RobotMessageModel *)item userId:(NSString *)userId;
/**
 *  查询某类型的随机一条消息
 *
 *  @param userId      当前用户id
 *  @param messageType 消息类型
 *
 *  @return <#return value description#>
 */
+ (RobotMessageModel *)getRobotMessageWithCurrentUserId:(NSString *)userId messageType:(NSString *)messageType;


@end
