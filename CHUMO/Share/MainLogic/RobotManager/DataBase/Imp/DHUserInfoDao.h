//
//  DHUserInfoDao.h
//  DHBaseFrameWork
//
//  Created by xy2 on 16/3/23.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DBManager.h"
#import "DHUserInfoModel.h"
@interface DHUserInfoDao : DBManager

/**
 *  用户是否存在
 *
 *  @param userId
 *
 *  @return
 */
+ (BOOL) checkUserWithUsertId:(NSString *)userId;
/**
 *  插入用户数据
 *
 *  @param item
 */
+ (void) insertUserToDBWithItem:(DHUserInfoModel *)item;
/**
 *  更新用户数据
 *
 *  @param item
 *  @param userId
 */
+ (void) updateUserToDBWithItem:(DHUserInfoModel *) item userId:(NSString *)userId;
/**
 *  获取某人数据
 *
 *  @param userId
 *
 *  @return
 */
+ (DHUserInfoModel *)getUserWithCurrentUserId:(NSString *)userId;
/**
 *  获取某个机器人与消息列表数据匹配
 *
 *  @param userId
 *
 *  @return
 */
+ (DHUserInfoModel *)getRobotUserWithRobotId:(NSString *)robotId gender:(NSInteger)gender;
@end
