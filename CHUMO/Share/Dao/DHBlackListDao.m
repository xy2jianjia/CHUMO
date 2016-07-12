//
//  DHBlackListDao.m
//  CHUMO
//
//  Created by xy2 on 16/3/28.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHBlackListDao.h"
static NSString * const BLACKLISTTABLE = @"BLACKLISTTABLE";
@implementation DHBlackListDao

+(instancetype)shareInstance{
    [super shareInstance];
    static DHBlackListDao *dao = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dao = [[DHBlackListDao alloc]init];
        [dao createTable];
    });
    return dao;
}
- (void)createTable{
    NSString *createTableSQL = @"CREATE TABLE BLACKLISTTABLE (b1 text,b143 text,b144 text,b19 text,b24 text,b29 text,b32 text,b33 text,b37 text,b46 text,b52 text,b57 text,b62 text,b67 text,b69 text,b75 text,b80 text,b86 text,b87 text,b9 text,b94 text, b116 text,b17 text,b14 text,b78 text,b145 text ,blackTime text,userId text)";
    [DHBlackListDao createUserTableWithSQL:createTableSQL tableName:BLACKLISTTABLE];
}

+ (BOOL) checkBlackListUserWithUsertId:(NSString *)userId{
    return [[DHBlackListDao shareInstance] checkBlackListUserWithUsertId:userId];
}
- (BOOL) checkBlackListUserWithUsertId:(NSString *)userId{
    NSString *currentUserId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM BLACKLISTTABLE WHERE b80 = '%@' and userId='%@'",userId,currentUserId];
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
 *  插入用户数据
 *
 *  @param item
 */
+ (void) insertBlackListUserToDBWithItem:(DHUserInfoModel *)item{
    [[DHBlackListDao shareInstance] insertBlackListUserToDBWithItem:item];
}
- (void) insertBlackListUserToDBWithItem:(DHUserInfoModel *)item{
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString * insertSql = [NSString stringWithFormat:@"INSERT INTO BLACKLISTTABLE (b1 ,b143 ,b144 ,b19 ,b24 ,b29 ,b32 ,b33 ,b37 ,b46 ,b52 ,b57 ,b62 ,b67 ,b69 ,b75 ,b80 ,b86 ,b87 ,b9 ,b94, b116,b17,b14 ,b78 ,b145 ,blackTime,userId) VALUES  ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",item.b1,item.b143,item.b144,item.b19,item.b24,item.b29,item.b32,item.b33,item.b37,item.b46,item.b52,item.b57,item.b62,item.b67,item.b69,item.b75,item.b80,item.b86,item.b87,item.b9,item.b94,item.b116,item.b17,item.b14,item.b78,item.b145,item.blackTime,userId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql];
    }];
}
/**
 *  获取黑名单列表
 *
 *  @param userId
 *
 *  @return
 */
+ (NSArray *)getBlackListUser{
    return [[DHBlackListDao shareInstance] getBlackListUser];
}
- (NSArray *)getBlackListUser{
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString * sql= nil;
    sql = [NSString stringWithFormat:@"SELECT * FROM BLACKLISTTABLE where userId = '%@'",userId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    
    __block NSMutableArray *tempArr = [NSMutableArray array];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            DHUserInfoModel *item = [[DHUserInfoModel alloc]init];
            item.b1 = [result stringForColumn:@"b1"];
            item.b143 = [result stringForColumn:@"b143"];
            item.b144 = [result stringForColumn:@"b144"];
            item.b19 = [result stringForColumn:@"b19"];
            item.b24 = [result stringForColumn:@"b24"];
            item.b29 = [result stringForColumn:@"b29"];
            item.b32 = [result stringForColumn:@"b32"];
            item.b33 = [result stringForColumn:@"b33"];
            item.b37 = [result stringForColumn:@"b37"];
            item.b46 = [result stringForColumn:@"b46"];
            item.b52 = [result stringForColumn:@"b52"];
            item.b57 = [result stringForColumn:@"b57"];
            item.b62 = [result stringForColumn:@"b62"];
            item.b67 = [result stringForColumn:@"b67"];
            item.b69 = [result stringForColumn:@"b69"];
            item.b75 = [result stringForColumn:@"b75"];
            item.b80 = [result stringForColumn:@"b80"];
            item.b86 = [result stringForColumn:@"b86"];
            item.b87 = [result stringForColumn:@"b87"];
            item.b9 = [result stringForColumn:@"b9"];
            item.b94 = [result stringForColumn:@"b94"];
            item.b116 = [result stringForColumn:@"b116"];
            item.b17 = [result stringForColumn:@"b17"];
            item.b14 = [result stringForColumn:@"b14"];
            item.b78 = [result stringForColumn:@"b78"];
            item.b145 = [result stringForColumn:@"b145"];
            item.blackTime = [result stringForColumn:@"blackTime"];
            [tempArr addObject:item];
        }
        [result close];
    }];
    return tempArr;
}
+ (void)removeBlackListUserFromDbWithUserId:(NSString *)userId{
    [[DHBlackListDao shareInstance]removeBlackListUserFromDbWithUserId:userId];
}
- (void)removeBlackListUserFromDbWithUserId:(NSString *)userId{
    NSString *currentUserId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM BLACKLISTTABLE WHERE b80='%@' and userId='%@'",userId,currentUserId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
    }];
}
@end
