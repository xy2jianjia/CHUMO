//
//  DHRandomMessageDao.m
//  DHBaseFrameWork
//
//  Created by xy2 on 16/3/23.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHRandomMessageDao.h"
#import "DBHelper.h"
static NSString * const RANDOMMESSAGETABLE = @"RANDOMMESSAGETABLE";
@implementation DHRandomMessageDao
+(instancetype)shareInstance{
    [super shareInstance];
    static DHRandomMessageDao *dao = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dao = [[DHRandomMessageDao alloc]init];
        [dao createTable];
    });
    return dao;
}
- (void)createTable{
    NSString *createTableSQL = @"CREATE TABLE RANDOMMESSAGETABLE (b34 text,b14 text,b78 text,userId text)";
    [DHRandomMessageDao createUserTableWithSQL:createTableSQL tableName:RANDOMMESSAGETABLE];
}

// 检查随机消息是否存在
+ (BOOL) checkRandomMessageWithUsertId:(NSString *)userId messageId:(NSString *)messageId {
    return [[DHRandomMessageDao shareInstance] checkRandomMessageWithUsertId:userId messageId:messageId];
}
- (BOOL) checkRandomMessageWithUsertId:(NSString *)userId messageId:(NSString *)messageId{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM RANDOMMESSAGETABLE WHERE b34='%@' and userId = '%@'",messageId,userId];
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
 *  插入随机消息数据
 *
 *  @param item
 */
+ (void) insertRandomMessageToDBWithItem:(DHRandomMessageModel *)item userId:(NSString *)userId{
    [[DHRandomMessageDao shareInstance] insertRandomMessageToDBWithItem:item userId:userId];
    
}
- (void) insertRandomMessageToDBWithItem:(DHRandomMessageModel *)item userId:(NSString *)userId{
    NSString * insertSql = [NSString stringWithFormat:@"INSERT INTO RANDOMMESSAGETABLE (b34 ,b14 ,b78 ,userId) VALUES  ('%@','%@','%@','%@')",item.b34,item.b14,item.b78,userId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql];
    }];
}
+ (DHRandomMessageModel *)getRandomMessageWithCurrentUserId:(NSString *)userId messageType:(NSString *)messageType{
    return [[DHRandomMessageDao shareInstance] getRandomMessageWithCurrentUserId:userId messageType:messageType];
}
- (DHRandomMessageModel *)getRandomMessageWithCurrentUserId:(NSString *)userId messageType:(NSString *)messageType{
    
    NSMutableArray *arr = [NSMutableArray array];
    NSString * sql=[NSString stringWithFormat:@"SELECT * FROM RANDOMMESSAGETABLE where userId='%@' and b78='%@'",userId,messageType];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            DHRandomMessageModel *item = [[DHRandomMessageModel alloc]init];
            item.b78 = [result stringForColumn:@"b78"];
            item.b14 = [result stringForColumn:@"b14"];
            item.b34 = [result stringForColumn:@"b34"];
            [arr addObject:item];
        }
        [result close];
    }];
    if (arr.count > 0) {
        NSInteger randomIndex = arc4random()%arr.count;
        if (randomIndex<0) {
            randomIndex = 0;
        }else if(randomIndex > arr.count - 1){
            randomIndex = arr.count - 1;
        }
        return [arr objectAtIndex:randomIndex];
    }else{
        return nil;
    }
    
    
}


@end
