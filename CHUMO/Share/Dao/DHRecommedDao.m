//
//  DHRecommedDao.m
//  CHUMO
//
//  Created by xy2 on 16/3/24.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHRecommedDao.h"
#import "DBHelper.h"
#import "DHUserInfoModel.h"
static NSString * const RECOMMEDTABLE = @"RECOMMEDTABLE";
@implementation DHRecommedDao

+(instancetype)shareInstance{
    [super shareInstance];
    static DHRecommedDao *dao = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dao = [[DHRecommedDao alloc]init];
        [dao createTable];
    });
    return dao;
}
- (void)createTable{
    NSString *createTableSQL = @"CREATE TABLE RECOMMEDTABLE (b1 text,b143 text,b144 text,b19 text,b24 text,b29 text,b32 text,b33 text,b37 text,b46 text,b52 text,b57 text,b62 text,b67 text,b69 text,b75 text,b80 text,b86 text,b87 text,b9 text,b94 text, b116 text,b17 text,b14 text,b78 text,b14_1 text,b78_1 text,b14_2 text,b78_2 text,b14_3 text,b78_3 text,b145 text,userId text)";
    [DHRecommedDao createUserTableWithSQL:createTableSQL tableName:RECOMMEDTABLE];
}

+ (BOOL) checkRecommendUserWithUsertId:(NSString *)userId{
    return [[DHRecommedDao shareInstance] checkRecommendUserWithUsertId:userId];
}
- (BOOL) checkRecommendUserWithUsertId:(NSString *)userId{
    NSString *userid = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM RECOMMEDTABLE WHERE b80 = '%@' AND userId = '%@'",userId,userid];
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
+ (void) insertRecommendUserToDBWithItem:(DHUserInfoModel *)item{
    [[DHRecommedDao shareInstance] insertRecommendUserToDBWithItem:item];
}
- (void) insertRecommendUserToDBWithItem:(DHUserInfoModel *)item{
    NSString *userid = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSArray *arr = item.answerArr;
    NSString *b14_1 = nil;
    NSString *b78_1 = nil;
    NSString *b14_2 = nil;
    NSString *b78_2 = nil;
    NSString *b14_3 = nil;
    NSString *b78_3 = nil;
    if (arr.count >= 3) {
        b14_1 = [arr[0] objectForKey:@"b14"];
        b78_1 = [arr[0] objectForKey:@"b78"];
        b14_2 = [arr[1] objectForKey:@"b14"];
        b78_2 = [arr[1] objectForKey:@"b78"];
        b14_3 = [arr[2] objectForKey:@"b14"];
        b78_3 = [arr[2] objectForKey:@"b78"];
    }
    NSString * insertSql = [NSString stringWithFormat:@"INSERT INTO RECOMMEDTABLE (b1 ,b143 ,b144 ,b19 ,b24 ,b29 ,b32 ,b33 ,b37 ,b46 ,b52 ,b57 ,b62 ,b67 ,b69 ,b75 ,b80 ,b86 ,b87 ,b9 ,b94, b116,b17,b14 ,b78 ,b14_1 ,b78_1 ,b14_2 ,b78_2 ,b14_3 ,b78_3,b145,userId ) VALUES  ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",item.b1,item.b143,item.b144,item.b19,item.b24,item.b29,item.b32,item.b33,item.b37,item.b46,item.b52,item.b57,item.b62,item.b67,item.b69,item.b75,item.b80,item.b86,item.b87,item.b9,item.b94,item.b116,item.b17,item.b14,item.b78,b14_1,b78_1,b14_2,b78_2,b14_3,b78_3,item.b145,userid];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql];
    }];
}
+ (void) updateRecommendUserToDBWithItem:(DHUserInfoModel *) item userId:(NSString *)userId{
    [[DHRecommedDao shareInstance] updateRecommendUserToDBWithItem:item userId:userId];
}
- (void) updateRecommendUserToDBWithItem:(DHUserInfoModel *) item userId:(NSString *)userId{
    NSString *userid = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSArray *arr = item.answerArr;
    NSString *b14_1 = nil;
    NSString *b78_1 = nil;
    NSString *b14_2 = nil;
    NSString *b78_2 = nil;
    NSString *b14_3 = nil;
    NSString *b78_3 = nil;
    if (arr.count >= 3) {
        b14_1 = [arr[0] objectForKey:@"b14"];
        b78_1 = [arr[0] objectForKey:@"b78"];
        b14_2 = [arr[1] objectForKey:@"b14"];
        b78_2 = [arr[1] objectForKey:@"b78"];
        b14_3 = [arr[2] objectForKey:@"b14"];
        b78_3 = [arr[2] objectForKey:@"b78"];
    }
    NSString * updateSql = [NSString stringWithFormat:@"UPDATE RECOMMEDTABLE set b1='%@' ,b143='%@' ,b144='%@' ,b19='%@' ,b24='%@' ,b29='%@' ,b32='%@' ,b33='%@' ,b37='%@' ,b46='%@' ,b52='%@' ,b57='%@' ,b62='%@' ,b67='%@' ,b69='%@' ,b75='%@' ,b86='%@' ,b87='%@' ,b9='%@' ,b94='%@',b116='%@',b17='%@',b14='%@',b78='%@',b14_1='%@',b78_1='%@',b14_2='%@',b78_2='%@',b14_3='%@',b78_3='%@',b145='%@' where b80='%@' and userId = '%@'",item.b1,item.b143,item.b144,item.b19,item.b24,item.b29,item.b32,item.b33,item.b37,item.b46,item.b52,item.b57,item.b62,item.b67,item.b69,item.b75,item.b86,item.b87,item.b9,item.b94,item.b116,item.b17,item.b14,item.b78,b14_1,b78_1,b14_2,b78_2,b14_3,b78_3,item.b145,item.b80,userid];
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
+ (DHUserInfoModel *)getRecommendUserWithCurrentUserId:(NSString *)userId{
    return [[DHRecommedDao shareInstance] getRecommendUserWithCurrentUserId:userId];
}
- (DHUserInfoModel *)getRecommendUserWithCurrentUserId:(NSString *)userId{
    NSString *userid = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString * sql= nil;
    if (userId) {
        sql = [NSString stringWithFormat:@"SELECT * FROM RECOMMEDTABLE where b80='%@' and userId='%@'",userId,userid];
    }else{
        sql = [NSString stringWithFormat:@"SELECT * FROM RECOMMEDTABLE where userId = '%@' ",userid];
    }
    
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    //    __block DHUserInfoModel *item = nil;
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
            item.answerArr = [NSMutableArray array];
            NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:[result stringForColumn:@"b14_1"],@"b14",[result stringForColumn:@"b78_1"],@"b78", nil];
            NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:[result stringForColumn:@"b14_2"],@"b14",[result stringForColumn:@"b78_2"],@"b78", nil];
            NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:[result stringForColumn:@"b14_3"],@"b14",[result stringForColumn:@"b78_3"],@"b78", nil];
            [item.answerArr addObject:dict1];
            [item.answerArr addObject:dict2];
            [item.answerArr addObject:dict3];
            [tempArr addObject:item];
        }
        [result close];
    }];
    if (tempArr.count > 0) {
        NSInteger randomIndex = arc4random()%tempArr.count-1;
        if (randomIndex<0) {
            randomIndex = 0;
        }else if(randomIndex > tempArr.count - 1){
            randomIndex = tempArr.count - 1;
        }
        return [tempArr objectAtIndex:randomIndex];
    }else{
        return nil;
    }
    //    return item;
}
@end