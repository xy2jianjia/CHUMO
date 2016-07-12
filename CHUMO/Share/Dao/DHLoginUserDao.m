//
//  DHLoginUserDao.m
//  CHUMO
//
//  Created by xy2 on 16/3/24.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHLoginUserDao.h"
#import "DHLoginUserForListModel.h"
#import "DBHelper.h"
static NSString * const LOGINUSERTABLE = @"LOGINUSERTABLE";
@implementation DHLoginUserDao

+(instancetype)shareInstance{
    [super shareInstance];
    static DHLoginUserDao *dao = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dao = [[DHLoginUserDao alloc]init];
        [dao createTable];
    });
    return dao;
}
- (void)createTable{
    NSString *createTableSQL = @"CREATE TABLE LOGINUSERTABLE (userName text,passWord text,userId text,sessionId text)";
    [DHLoginUserDao createUserTableWithSQL:createTableSQL tableName:LOGINUSERTABLE];
}
+ (BOOL) checkLoginUserWithUsertId:(NSString *)userId{
    return [[DHLoginUserDao shareInstance] checkLoginUserWithUsertId:userId];
}
- (BOOL) checkLoginUserWithUsertId:(NSString *)userId{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM LOGINUSERTABLE WHERE userId = '%@'",userId];
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
+ (void) asyncInsertLoginUserToDbWithItem:(DHLoginUserForListModel *)item{
    [[DHLoginUserDao shareInstance] asyncInsertLoginUserToDbWithItem:item];
}
- (void) asyncInsertLoginUserToDbWithItem:(DHLoginUserForListModel *)item{
    NSString * insertSql = [NSString stringWithFormat:@"INSERT INTO LOGINUSERTABLE (userName ,passWord ,userId ,sessionId ) VALUES  ('%@','%@','%@','%@')",item.userName,item.passWord,item.userId,item.sessionId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql];
    }];
}
+ (NSMutableArray *)asyncGetLoginUserList{
    return [[DHLoginUserDao shareInstance] asyncGetLoginUserList];
}
- (NSMutableArray *)asyncGetLoginUserList{
    NSMutableArray *allMutableArray = [NSMutableArray array];
    NSString * sql=[NSString stringWithFormat:@"SELECT * FROM LOGINUSERTABLE"];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            DHLoginUserForListModel *item = [[DHLoginUserForListModel alloc]init];
            item.passWord = [result stringForColumn:@"passWord"];
            item.userName = [result stringForColumn:@"userName"];
            item.userId = [result stringForColumn:@"userId"];
            item.sessionId =[result stringForColumn:@"sessionId"];
            
            [allMutableArray addObject:item];
        }
        [result close];
    }];
    return allMutableArray;
}
/**
 *  更新用户信息
 */
+ (void )updateLoginUserToDbWithPassWord:(DHLoginUserForListModel *)item{
    [[DHLoginUserDao shareInstance] updateLoginUserToDbWithPassWord:item];
}
- (void )updateLoginUserToDbWithPassWord:(DHLoginUserForListModel *)item{
    //userName ,passWord ,userId ,sessionId
    NSString * updateSql = [NSString stringWithFormat:@"UPDATE LOGINUSERTABLE SET passWord='%@' WHERE userId='%@' and sessionId='%@' and userName='%@'",item.passWord,item.userId,item.sessionId,item.userName];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:updateSql];
    }];
}
@end
