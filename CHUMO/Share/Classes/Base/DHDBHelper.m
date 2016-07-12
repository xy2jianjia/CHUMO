//
//  DHDBHelper.m
//  DHRequestServer
//
//  Created by xy2 on 16/2/26.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHDBHelper.h"
#import "DHShanboxManager.h"
@implementation DHDBHelper
static FMDatabaseQueue *queue = nil;

+ (FMDatabaseQueue *) asyncGetDatabaseQueueWithDataBaseName:(NSString *)databaseName {
    DHShanboxManager *shandboxManager = [DHShanboxManager new];
    NSString *paths = [shandboxManager asyncConfigShandboxType:SHANBOX_PATH_TYPE_DOCUMENT];
    NSString *dbPath = [paths stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",databaseName]];
    if (!queue) {
        queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        NSLog(@"%@",dbPath);
    }
    return queue;
}
+ (NSString *)asyncConfigDataBaseSqlWithType:(DB_SQL_QUERY_TYPE)sqlType{
    switch (sqlType) {
        case DB_SQL_QUERY_TYPE_INSERT:
        {
            return DB_QUERY_SQL_INSERT;
        }
            break;
        case DB_SQL_QUERY_TYPE_DELETE:
        {
            return DB_QUERY_SQL_DELETE;
        }
            break;
        case DB_SQL_QUERY_TYPE_UPDATE:
        {
            return DB_QUERY_SQL_UPDATE;
        }
            break;
        case DB_SQL_QUERY_TYPE_SELECT:
        {
            return DB_QUERY_SQL_SELECT;
        }
            break;
        case DB_SQL_QUERY_TYPE_SELECT_COUNT:
        {
            return DB_QUERY_SQL_SELECT_COUNT;
        }
            break;
        default:
        {
            return DB_QUERY_SQL_SELECT_CREATE_TABLE;
        }
            break;
    }
}

@end
