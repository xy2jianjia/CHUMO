//
//  JYMoveUserDao.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/7/1.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "JYMoveUserDao.h"
static NSString * const MoveUserLISTTABLE = @"MoveUserLISTTABLE";
@implementation JYMoveUserDao
+(instancetype)shareInstance{
    [super shareInstance];
    static JYMoveUserDao *dao=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dao=[[JYMoveUserDao alloc]init];
        [dao createTable];
    });
    return dao;
}
- (void)createTable{
    NSString *createTableSQL = @"CREATE TABLE MoveUserLISTTABLE (userId text,targetId text,targetType text,date text)";
    [JYMoveUserDao createUserTableWithSQL:createTableSQL tableName:MoveUserLISTTABLE];
}
/**
 *  插入用户数据
 *
 *  @param item
 */
+ (void) insertSayHellListUserToDBWithItem:(DHUserInfoModel *)item{
    [[JYMoveUserDao shareInstance] insertSayHellListUserToDBWithItem:item];
}
- (void) insertSayHellListUserToDBWithItem:(DHUserInfoModel *)item{
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString * insertSql = [NSString stringWithFormat:@"INSERT INTO MoveUserLISTTABLE (userId ,targetId ,targetType ,date ) VALUES  ('%@','%@','%@','%@')",userId,item.b80,item.targetType,item.sayHellTime];
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
    return [[JYMoveUserDao shareInstance] checkSayHellWithTargetId:targetId userId:userId];
}
- (BOOL) checkSayHellWithTargetId:(NSString *)targetId userId:(NSString *)userId{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM MoveUserLISTTABLE WHERE userId = '%@' AND targetId = '%@'",userId,targetId];
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
    [[JYMoveUserDao shareInstance] removeSayHellListUserFromDbWithDate:date];
}
- (void)removeSayHellListUserFromDbWithDate:(NSString *)date{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM MoveUserLISTTABLE WHERE date !='%@'",date];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
    }];
}
@end
