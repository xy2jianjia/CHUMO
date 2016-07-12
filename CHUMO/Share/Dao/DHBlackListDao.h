//
//  DHBlackListDao.h
//  CHUMO
//
//  Created by xy2 on 16/3/28.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DBManager.h"

@interface DHBlackListDao : DBManager

/**
 *  获取黑名单列表
 *
 *  @param userId
 *
 *  @return
 */
+ (NSArray *)getBlackListUser;

/**
 *  插入用户黑名单
 *
 *  @param item
 */
+ (void) insertBlackListUserToDBWithItem:(DHUserInfoModel *)item;

/**
 *  查询是否存在黑名单
 *
 *  @param userId
 *
 *  @return
 */
+ (BOOL) checkBlackListUserWithUsertId:(NSString *)userId;
/**
 *  删除黑名单用户
 *
 *  @param userId 
 */
+ (void)removeBlackListUserFromDbWithUserId:(NSString *)userId;
@end
