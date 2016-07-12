//
//  DHCollectDao.m
//  CHUMO
//
//  Created by xy2 on 16/7/7.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHCollectDao.h"
#import "DBHelper.h"
static NSString * const COLLECTTABLE = @"COLLECTTABLE";
@implementation DHCollectDao
+(instancetype)shareInstance{
    [super shareInstance];
    static DHCollectDao *dao = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dao = [[DHCollectDao alloc]init];
        [dao createTable];
    });
    return dao;
}
- (void)createTable{
    NSString *createTableSQL = @"CREATE TABLE COLLECTTABLE (userType1 text,payType text,price text,status1 text,goodCode text,orderNum text,userType2 text,pointType text,oldAppVer text,oldAppName text,source text,status2 text,target_app_id text,ticket text,webCode text,appId text,downloadType text,keynum text,userId text,collectType text)";
    [DHCollectDao createUserTableWithSQL:createTableSQL tableName:COLLECTTABLE];
}

// 检查随机消息是否存在
//+ (BOOL) checkCollectWithUsertId:(NSString *)userId messageId:(NSString *)messageId {
//    return [[DHCollectDao shareInstance] checkRobotMessageWithUsertId:userId messageId:messageId];
//}
//- (BOOL) checkRobotMessageWithUsertId:(NSString *)userId messageId:(NSString *)messageId{
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM COLLECTTABLE WHERE b34='%@' and userId = '%@'",messageId,userId];
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
/**
 *  插入统计数据
 *
 *  @param item
 */
+ (void) insertCollectToDBWithItem:(CollectModel *)item userId:(NSString *)userId collectType:(NSString *)collectType{
    [[DHCollectDao shareInstance] insertCollectToDBWithItem:item userId:userId collectType:collectType];
    
}
- (void) insertCollectToDBWithItem:(CollectModel *)item userId:(NSString *)userId collectType:(NSString *)collectType{
    NSString * insertSql = [NSString stringWithFormat:@"INSERT INTO COLLECTTABLE (userType1 ,payType ,price ,status1 ,goodCode ,orderNum ,userType2 ,pointType ,oldAppVer ,oldAppName ,source ,status2 ,target_app_id ,ticket ,webCode ,appId ,downloadType ,keynum ,userId ,collectType ) VALUES  ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",item.userType1,item.payType,item.price,item.status1,item.goodCode,item.orderNum,item.userType2,item.pointType,item.oldAppVer,item.oldAppName,item.source,item.status2,item.target_app_id,item.ticket,item.webCode,item.appId,item.downloadType,item.keynum,userId,collectType];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql];
    }];
}
+ (NSMutableArray *)getCollectWithCurrentUserId:(NSString *)userId collectType:(NSString *)collectType{
    return [[DHCollectDao shareInstance] getCollectWithCurrentUserId:userId collectType:collectType];
}
- (NSMutableArray *)getCollectWithCurrentUserId:(NSString *)userId collectType:(NSString *)collectType{
    
    NSMutableArray *arr = [NSMutableArray array];
    NSString * sql=[NSString stringWithFormat:@"SELECT * FROM COLLECTTABLE where userId='%@' and collectType='%@'",userId,collectType];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            CollectModel *item = [[CollectModel alloc]init];
            item.userType1 = [result stringForColumn:@"userType1"];
            item.payType = [result stringForColumn:@"payType"];
            item.price = [result stringForColumn:@"price"];
            item.status1 = [result stringForColumn:@"status1"];
            item.goodCode = [result stringForColumn:@"goodCode"];
            item.orderNum = [result stringForColumn:@"orderNum"];
            item.userType2 = [result stringForColumn:@"userType2"];
            item.pointType = [result stringForColumn:@"pointType"];
            item.oldAppVer = [result stringForColumn:@"oldAppVer"];
            item.oldAppName = [result stringForColumn:@"oldAppName"];
            item.source = [result stringForColumn:@"source"];
            item.status2 = [result stringForColumn:@"status2"];
            item.target_app_id = [result stringForColumn:@"target_app_id"];
            item.ticket = [result stringForColumn:@"ticket"];
            item.webCode = [result stringForColumn:@"webCode"];
            item.appId = [result stringForColumn:@"appId"];
            item.downloadType = [result stringForColumn:@"downloadType"];
            item.keynum = [result stringForColumn:@"keynum"];
            
            [arr addObject:item];
        }
        [result close];
    }];
    return arr;
}
//+ (void) deleteCollectToDBWithItem:(CollectModel *)item userId:(NSString *)userId collectType:(NSString *)collectType{
//    [[DHCollectDao shareInstance] insertCollectToDBWithItem:item userId:userId collectType:collectType];
//    
//}
//- (void) insertCollectToDBWithItem:(CollectModel *)item userId:(NSString *)userId collectType:(NSString *)collectType{
//    NSString * insertSql = [NSString stringWithFormat:@"INSERT INTO COLLECTTABLE (userType1 ,payType ,price ,status1 ,goodCode ,orderNum ,userType2 ,pointType ,oldAppVer ,oldAppName ,source ,status2 ,target_app_id ,ticket ,webCode ,appId ,downloadType ,keynum ,userId ,collectType ) VALUES  ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",item.userType1,item.payType,item.price,item.status1,item.goodCode,item.orderNum,item.userType2,item.pointType,item.oldAppVer,item.oldAppName,item.source,item.status2,item.target_app_id,item.ticket,item.webCode,item.appId,item.downloadType,item.keynum,userId,collectType];
//    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
//    [queue inDatabase:^(FMDatabase *db) {
//        [db executeUpdate:insertSql];
//    }];
//}
@end
