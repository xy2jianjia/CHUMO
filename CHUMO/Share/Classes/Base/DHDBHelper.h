//
//  DHDBHelper.h
//  DHRequestServer
//
//  Created by xy2 on 16/2/26.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"


static NSString * const DB_QUERY_SQL_INSERT   = @"INSERT INTO";
static NSString * const DB_QUERY_SQL_DELETE   = @"DELETE FROM";
static NSString * const DB_QUERY_SQL_UPDATE   = @"UPDATE ";
static NSString * const DB_QUERY_SQL_SELECT   = @"SELECT *FROM";
static NSString * const DB_QUERY_SQL_SELECT_COUNT   = @"SELECT COUNT(*) AS COUNT FROM";
static NSString * const DB_QUERY_SQL_SELECT_CREATE_TABLE   = @"CREATE TABLE";
/**
 *  sql语句类型
 */
typedef NS_ENUM(NSInteger , DB_SQL_QUERY_TYPE) {
    /**
     *  增
     */
    DB_SQL_QUERY_TYPE_INSERT = 0,
    /**
     *  删
     */
    DB_SQL_QUERY_TYPE_DELETE,
    /**
     *  改
     */
    DB_SQL_QUERY_TYPE_UPDATE,
    /**
     *  查
     */
    DB_SQL_QUERY_TYPE_SELECT,
    /**
     *  查询数量
     */
    DB_SQL_QUERY_TYPE_SELECT_COUNT,
    
    /**
     *  建表
     */
    DB_SQL_QUERY_TYPE_CREATE_TABLE
};

@interface DHDBHelper : NSObject
/**
 *  初始化操作数据库工具
 *
 *  @param databaseName 数据库名
 *
 *  @return 队列
 */
+ (FMDatabaseQueue *) asyncGetDatabaseQueueWithDataBaseName:(NSString *)databaseName ;



+ (NSString *)asyncConfigDataBaseSqlWithType:(DB_SQL_QUERY_TYPE)sqlType;


@end
