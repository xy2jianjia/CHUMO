//
//  DHDomainDao.h
//  CHUMO
//
//  Created by xy2 on 16/3/25.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DBManager.h"

@interface DHDomainDao : DBManager
/**
 *  api是否存在
 *
 *  @param item
 */
+ (BOOL) checkApiWithApi:(NSString *)api;
/**
 *  插入api
 *
 *  @param item
 */
+ (void) asyncInsertApiToDbWithItem:(DHDomainModel *)item;

/**
 *  根据api名字查询
 *
 *  @param apiName
 *
 *  @return
 */
+ (DHDomainModel *)asyncGetApiWithApiName:(NSString *)apiName;
@end
