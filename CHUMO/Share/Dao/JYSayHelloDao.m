//
//  JYSayHelloDao.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/5/30.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "JYSayHelloDao.h"
static NSString * const SAYHELLLISTTABLE = @"SAYHELLLISTTABLE";
@implementation JYSayHelloDao
+(instancetype)shareInstance{
    [super shareInstance];
    static JYSayHelloDao *dao=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dao=[[JYSayHelloDao alloc]init];
        [dao createTable];
    });
    return dao;
}
- (void)createTable{
    NSString *createTableSQL = @"CREATE TABLE SAYHELLLISTTABLE (userId text,targetId text,targetType text,date text)";
    [JYSayHelloDao createUserTableWithSQL:createTableSQL tableName:SAYHELLLISTTABLE];
}
/**
 *  插入用户数据
 *
 *  @param item
 */
+ (void) insertSayHellListUserToDBWithItem:(DHUserInfoModel *)item{
    [[JYSayHelloDao shareInstance] insertSayHellListUserToDBWithItem:item];
}
- (void) insertSayHellListUserToDBWithItem:(DHUserInfoModel *)item{
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString * insertSql = [NSString stringWithFormat:@"INSERT INTO SAYHELLLISTTABLE (userId ,targetId ,targetType ,date ) VALUES  ('%@','%@','%@','%@')",userId,item.b80,item.targetType,item.sayHellTime];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql];
    }];
}
/**
 *  查询用户
 *
 *  @param targetId 对方id
 *  @param userId   用户id
 *
 *  @return bool 是否查询到
 */
+ (BOOL) checkSayHellWithTargetId:(NSString *)targetId userId:(NSString *)userId{
    return [[JYSayHelloDao shareInstance] checkSayHellWithTargetId:targetId userId:userId];
}
- (BOOL) checkSayHellWithTargetId:(NSString *)targetId userId:(NSString *)userId{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SAYHELLLISTTABLE WHERE userId = '%@' AND targetId = '%@'",userId,targetId];
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
 *  删除打招呼用户
 *
 *  @param userId
 */
+ (void)removeSayHellListUserFromDbWithDate:(NSString *)date{
    [[JYSayHelloDao shareInstance] removeSayHellListUserFromDbWithDate:date];
}
- (void)removeSayHellListUserFromDbWithDate:(NSString *)date{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM SAYHELLLISTTABLE WHERE date !='%@'",date];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
    }];
}
@end
