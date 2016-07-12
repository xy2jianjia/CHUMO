//
//  SuitRobotDao.m
//  CHUMO
//
//  Created by xy2 on 16/6/2.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "SuitRobotDao.h"
#import "DBHelper.h"
static NSString * const SUITROBOTTABLE = @"SUITROBOTTABLE";
@implementation SuitRobotDao

//+(instancetype)shareInstance{
//    [super shareInstance];
//    static SuitRobotDao *dao = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        dao = [[SuitRobotDao alloc]init];
//        [dao createTable];
//    });
//    return dao;
//}
//- (void)createTable{
//    NSString *createTableSQL = @"CREATE TABLE ROBOTMESSAGETABLE (b34 text,b14 text,b78 text,userId text)";
//    [DHRobotMessageDao createUserTableWithSQL:createTableSQL tableName:ROBOTMESSAGETABLE];
//}
//
//// 检查随机消息是否存在
//+ (BOOL) checkRobotMessageWithUsertId:(NSString *)userId messageId:(NSString *)messageId {
//    return [[DHRobotMessageDao shareInstance] checkRobotMessageWithUsertId:userId messageId:messageId];
//}
//- (BOOL) checkRobotMessageWithUsertId:(NSString *)userId messageId:(NSString *)messageId{
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM ROBOTMESSAGETABLE WHERE b34='%@' and userId = '%@'",messageId,userId];
//    __block BOOL flag = NO;
//    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
//    [queue inDatabase:^(FMDatabase *db) {
//        FMResultSet *rs = [db executeQuery:sql];
//        while ([rs next]) {
//            flag = YES;
//        }
//        [rs close];
//    }];
//    return flag;
//}
///**
// *  插入随机消息数据
// *
// *  @param item
// */
//+ (void) insertRobotMessageToDBWithItem:(RobotMessageModel *)item userId:(NSString *)userId{
//    [[DHRobotMessageDao shareInstance] insertRobotMessageToDBWithItem:item userId:userId];
//    
//}
//- (void) insertRobotMessageToDBWithItem:(RobotMessageModel *)item userId:(NSString *)userId{
//    NSString * insertSql = [NSString stringWithFormat:@"INSERT INTO ROBOTMESSAGETABLE (b34 ,b14 ,b78 ,userId) VALUES  ('%@','%@','%@','%@')",item.b34,item.b14,item.b78,userId];
//    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
//    [queue inDatabase:^(FMDatabase *db) {
//        [db executeUpdate:insertSql];
//    }];
//}
//+ (RobotMessageModel *)getRobotMessageWithCurrentUserId:(NSString *)userId messageType:(NSString *)messageType{
//    return [[DHRobotMessageDao shareInstance] getRobotMessageWithCurrentUserId:userId messageType:messageType];
//}
//- (RobotMessageModel *)getRobotMessageWithCurrentUserId:(NSString *)userId messageType:(NSString *)messageType{
//    
//    NSMutableArray *arr = [NSMutableArray array];
//    NSString * sql=[NSString stringWithFormat:@"SELECT * FROM ROBOTMESSAGETABLE where userId='%@' and b78='%@'",userId,messageType];
//    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
//    [queue inDatabase:^(FMDatabase *db) {
//        FMResultSet *result = [db executeQuery:sql];
//        while ([result next]) {
//            RobotMessageModel *item = [[RobotMessageModel alloc]init];
//            item.b78 = [result stringForColumn:@"b78"];
//            item.b14 = [result stringForColumn:@"b14"];
//            item.b34 = [result stringForColumn:@"b34"];
//            [arr addObject:item];
//        }
//        [result close];
//    }];
//    if (arr.count > 0) {
//        NSInteger RobotIndex = arc4random()%arr.count;
//        if (RobotIndex<0) {
//            RobotIndex = 0;
//        }else if(RobotIndex > arr.count - 1){
//            RobotIndex = arr.count - 1;
//        }
//        return [arr objectAtIndex:RobotIndex];
//    }else{
//        return nil;
//    }
//    
//    
//}
@end
