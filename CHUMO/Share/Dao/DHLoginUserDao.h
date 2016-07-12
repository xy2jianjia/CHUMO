//
//  DHLoginUserDao.h
//  CHUMO
//
//  Created by xy2 on 16/3/24.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DBManager.h"

@interface DHLoginUserDao : DBManager
/**
 *  查询登录列表是否有登录过
 *
 *  @param userId
 *
 *  @return
 */
+ (BOOL) checkLoginUserWithUsertId:(NSString *)userId;

/**
 *  保存已经登录的用户，为了登录页登录用户的列表 2016年02月19日17:39:11---ndh
 *
 *  @param item
 */
+ (void)asyncInsertLoginUserToDbWithItem:(DHLoginUserForListModel *)item;
/**
 *  获取登录列表
 *
 *  @return
 */
+ (NSMutableArray *)asyncGetLoginUserList;
/**
 *  更新用户信息
 */
+ (void )updateLoginUserToDbWithPassWord:(DHLoginUserForListModel *)item;
@end
