//
//  DHRecommedDao.h
//  CHUMO
//
//  Created by xy2 on 16/3/24.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DBManager.h"

@interface DHRecommedDao : DBManager

/**
 *  检测推荐
 *
 *  @param userId <#userId description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL) checkRecommendUserWithUsertId:(NSString *)userId;
/**
 *  插入
 *
 *  @param item <#item description#>
 */
+ (void) insertRecommendUserToDBWithItem:(DHUserInfoModel *)item;
/**
 *  更新
 *
 *  @param item   <#item description#>
 *  @param userId <#userId description#>
 */
+ (void) updateRecommendUserToDBWithItem:(DHUserInfoModel *) item userId:(NSString *)userId;
/**
 *  查询
 *
 *  @param userId <#userId description#>
 *
 *  @return <#return value description#>
 */
+ (DHUserInfoModel *)getRecommendUserWithCurrentUserId:(NSString *)userId;


@end
