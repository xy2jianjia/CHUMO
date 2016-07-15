//
//  DHFriendDao.h
//  CHUMO
//
//  Created by xy2 on 16/7/14.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DBManager.h"

@interface DHFriendDao : DBManager
/**
 *  用户是否存在
 *
 *  @param userId
 *
 *  @return
 */
+ (BOOL) checkFriendWithFriendId:(NSString *)friendId;
/**
 *  插入用户数据
 *
 *  @param item
 */
+ (void) insertFriendToDBWithItem:(DHUserInfoModel *)item;
/**
 *  更新用户数据
 *
 *  @param item
 *  @param userId
 */
+ (void) updateFriendToDBWithItem:(DHUserInfoModel *) item;
/**
 *  获取某人数据
 *
 *  @param userId
 *
 *  @return
 */
+ (DHUserInfoModel *)getFriendWithFriendId:(NSString *)friendId;

@end
