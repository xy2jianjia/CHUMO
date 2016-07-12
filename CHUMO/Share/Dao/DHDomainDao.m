//
//  DHDomainDao.m
//  CHUMO
//
//  Created by xy2 on 16/3/25.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHDomainDao.h"
static NSString * const APITABLE = @"APITABLE";
@implementation DHDomainDao


+(instancetype)shareInstance{
    [super shareInstance];
    static DHDomainDao *dao = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dao = [[DHDomainDao alloc]init];
        [dao createTable];
    });
    return dao;
}
- (void)createTable{
    NSString *createTableSQL = @"CREATE TABLE APITABLE (apiId text,api text,apiName text,apiType text)";
    [DHDomainDao createUserTableWithSQL:createTableSQL tableName:APITABLE];
}

+ (BOOL) checkApiWithApi:(NSString *)api{
    return [[DHDomainDao shareInstance] checkApiWithApi:api];
}
- (BOOL) checkApiWithApi:(NSString *)api{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM APITABLE WHERE api = '%@'",api];
    __block BOOL flag = NO;
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            flag = YES;
        }
        [rs close];
    }];
    return flag;
}

/**
 *  插入域名
 *
 *  @param item
 */
+ (void) asyncInsertApiToDbWithItem:(DHDomainModel *)item{
    [[DHDomainDao shareInstance] asyncInsertApiToDbWithItem:item];
}
- (void) asyncInsertApiToDbWithItem:(DHDomainModel *)item{
    NSString * insertSql = [NSString stringWithFormat:@"INSERT INTO APITABLE (apiId ,api ,apiName ,apiType ) VALUES  ('%@','%@','%@','%@')",item.apiId,item.api,item.apiName,item.apiType];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql];
    }];
}
+ (DHDomainModel *)asyncGetApiWithApiName:(NSString *)apiName{
    return [[DHDomainDao shareInstance] asyncGetApiWithApiName:apiName];
}
- (DHDomainModel *)asyncGetApiWithApiName:(NSString *)apiName{
    NSMutableArray *allMutableArray = [NSMutableArray array];
    NSString * sql=[NSString stringWithFormat:@"SELECT * FROM APITABLE WHERE apiName = '%@'",apiName];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            DHDomainModel *item = [[DHDomainModel alloc]init];
            item.apiId = [result stringForColumn:@"apiId"];
            item.api = [result stringForColumn:@"api"];
            item.apiName = [result stringForColumn:@"apiName"];
            item.apiType =[result stringForColumn:@"apiType"];
            
            [allMutableArray addObject:item];
        }
        [result close];
    }];
    return [allMutableArray lastObject];
}

@end
