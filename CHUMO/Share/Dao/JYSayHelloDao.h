//
//  JYSayHelloDao.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/5/30.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DBManager.h"

@interface JYSayHelloDao : DBManager
/**
 *  插入用户数据
 *
 *  @param item
 */
+ (void) insertSayHellListUserToDBWithItem:(DHUserInfoModel *)item;
/**
 *  查询用户
 *
 *  @param targetId 对方id
 *  @param userId   用户id
 *
 *  @return bool 是否查询到
 */
+ (BOOL) checkSayHellWithTargetId:(NSString *)targetId userId:(NSString *)userId;
/**
 *  根据日期删除打招呼用户
 *
 *  @param date 日期
 */
+ (void)removeSayHellListUserFromDbWithDate:(NSString *)date;
@end
