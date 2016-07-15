//
//  DHFriendDao.m
//  CHUMO
//
//  Created by xy2 on 16/7/14.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHFriendDao.h"
#import "DBHelper.h"
#define currentUserId [NSString stringWithFormat:@"%@",[NSGetTools getUserID]]

static NSString * const FRIENDTABLE = @"FRIENDTABLE";
@implementation DHFriendDao
+(instancetype)shareInstance{
    [super shareInstance];
    static DHFriendDao *dao = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dao = [[DHFriendDao alloc]init];
        [dao createTable];
    });
    return dao;
}

- (void)createTable{
    NSString *createTableSQL = @"CREATE TABLE FRIENDTABLE (b25 text,b26 text, b1 text,b143 text,b144 text,b19 text,b24 text,b29 text,b32 text,b33 text,b37 text,b46 text,b52 text,b57 text,b62 text,b67 text,b69 text,b75 text,b80 text,b86 text,b87 text,b9 text,b94 text, b116 text,b17 text,b145 text,blackTime text,friendType text,userId text)";
    [DHFriendDao createUserTableWithSQL:createTableSQL tableName:FRIENDTABLE];
}
+ (BOOL) checkFriendWithFriendId:(NSString *)friendId{
    return [[DHFriendDao shareInstance] checkFriendWithFriendId:friendId];
}
- (BOOL) checkFriendWithFriendId:(NSString *)friendId{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM FRIENDTABLE WHERE b25 = '%@' and userId = '%@'",friendId,currentUserId];
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
+ (void) insertFriendToDBWithItem:(DHUserInfoModel *)item{
    [[DHFriendDao shareInstance] insertFriendToDBWithItem:item];
}
- (void) insertFriendToDBWithItem:(DHUserInfoModel *)item{
    
    if (item == nil|| [[NSString stringWithFormat:@"%@",item.b25] isEqualToString:@"(null)" ]|| [[NSString stringWithFormat:@"%@",item.b25] length] == 0) {
        
    }else{
        NSString * insertSql = [NSString stringWithFormat:@"INSERT INTO FRIENDTABLE (b25,b26,b1 ,b143 ,b144 ,b19 ,b24 ,b29 ,b32 ,b33 ,b37 ,b46 ,b52 ,b57 ,b62 ,b67 ,b69 ,b75 ,b80 ,b86 ,b87 ,b9 ,b94, b116,b17,b145,blackTime,friendType,userId) VALUES  ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",item.b25,item.b26, item.b1,item.b143,item.b144,item.b19,item.b24,item.b29,item.b32,item.b33,item.b37,item.b46,item.b52,item.b57,item.b62,item.b67,item.b69,item.b75,item.b80,item.b86,item.b87,item.b9,item.b94,item.b116,item.b17,item.b145,item.blackTime,item.friendType,currentUserId];
        FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
        [queue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:insertSql];
        }];
    }
    
}

+ (void) updateFriendToDBWithItem:(DHUserInfoModel *) item{
    [[DHFriendDao shareInstance] updateFriendToDBWithItem:item];
}
- (void) updateFriendToDBWithItem:(DHUserInfoModel *) item{
    NSString * updateSql = [NSString stringWithFormat:@"UPDATE FRIENDTABLE set b26 = '%@', b1='%@' ,b143='%@' ,b144='%@' ,b19='%@' ,b24='%@' ,b29='%@' ,b32='%@' ,b33='%@' ,b37='%@' ,b46='%@' ,b52='%@' ,b57='%@' ,b62='%@' ,b67='%@' ,b69='%@' ,b75='%@' ,b86='%@' ,b87='%@' ,b9='%@' ,b94='%@',b116='%@',b17='%@',b145='%@',blackTime='%@',friendType='%@' where b25='%@' and userId='%@'",item.b26,item.b1,item.b143,item.b144,item.b19,item.b24,item.b29,item.b32,item.b33,item.b37,item.b46,item.b52,item.b57,item.b62,item.b67,item.b69,item.b75,item.b86,item.b87,item.b9,item.b94,item.b116,item.b17,item.b145,item.blackTime,item.friendType,item.b25,currentUserId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:updateSql];
    }];
}

/**
 *  获取某人数据
 *
 *  @param userId
 *
 *  @return
 */
+ (DHUserInfoModel *)getFriendWithFriendId:(NSString *)friendId{
    return [[DHFriendDao shareInstance] getFriendWithFriendId:friendId];
}
- (DHUserInfoModel *)getFriendWithFriendId:(NSString *)friendId{
    NSString * sql=[NSString stringWithFormat:@"SELECT * FROM FRIENDTABLE where b25='%@' and userId = '%@'",friendId,currentUserId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    __block DHUserInfoModel *item = nil;
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            item = [[DHUserInfoModel alloc]init];
            item.b25 = [result stringForColumn:@"b25"];
            item.b26 = [result stringForColumn:@"b26"];
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
            item.b145 = [result stringForColumn:@"b145"];
            item.blackTime = [result stringForColumn:@"blackTime"];
            item.friendType = [result stringForColumn:@"friendType"];
            
        }
        [result close];
    }];
    return item;
}

@end
