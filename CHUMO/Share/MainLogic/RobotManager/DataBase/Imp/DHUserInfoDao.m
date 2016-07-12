//
//  DHUserInfoDao.m
//  DHBaseFrameWork
//
//  Created by xy2 on 16/3/23.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHUserInfoDao.h"
#import "DBHelper.h"
static NSString * const USERTABLE = @"USERTABLE";
@implementation DHUserInfoDao

+(instancetype)shareInstance{
    [super shareInstance];
    static DHUserInfoDao *dao = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dao = [[DHUserInfoDao alloc]init];
        [dao createTable];
    });
    return dao;
}

- (void)createTable{
    NSString *createTableSQL = @"CREATE TABLE USERTABLE (b1 text,b143 text,b144 text,b19 text,b24 text,b29 text,b32 text,b33 text,b37 text,b46 text,b52 text,b57 text,b62 text,b67 text,b69 text,b75 text,b80 text,b86 text,b87 text,b9 text,b94 text, b116 text,b17 text,b145 text,blackTime text)";
    [DHUserInfoDao createUserTableWithSQL:createTableSQL tableName:USERTABLE];
}
+ (BOOL) checkUserWithUsertId:(NSString *)userId{
    return [[DHUserInfoDao shareInstance] checkUserWithUsertId:userId];
}
- (BOOL) checkUserWithUsertId:(NSString *)userId{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM USERTABLE WHERE b80 = '%@'",userId];
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
+ (void) insertUserToDBWithItem:(DHUserInfoModel *)item{
    [[DHUserInfoDao shareInstance] insertUserToDBWithItem:item];
}
- (void) insertUserToDBWithItem:(DHUserInfoModel *)item{
    
    if (item == nil|| [[NSString stringWithFormat:@"%@",item.b80] isEqualToString:@"(null)" ]|| [[NSString stringWithFormat:@"%@",item.b80] length] == 0) {
        
    }else{
        NSString * insertSql = [NSString stringWithFormat:@"INSERT INTO USERTABLE (b1 ,b143 ,b144 ,b19 ,b24 ,b29 ,b32 ,b33 ,b37 ,b46 ,b52 ,b57 ,b62 ,b67 ,b69 ,b75 ,b80 ,b86 ,b87 ,b9 ,b94, b116,b17,b145,blackTime) VALUES  ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",item.b1,item.b143,item.b144,item.b19,item.b24,item.b29,item.b32,item.b33,item.b37,item.b46,item.b52,item.b57,item.b62,item.b67,item.b69,item.b75,item.b80,item.b86,item.b87,item.b9,item.b94,item.b116,item.b17,item.b145,item.blackTime];
        FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
        [queue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:insertSql];
        }];
    }
    
}

+ (void) updateUserToDBWithItem:(DHUserInfoModel *) item userId:(NSString *)userId{
    [[DHUserInfoDao shareInstance] updateUserToDBWithItem:item userId:userId];
}
- (void) updateUserToDBWithItem:(DHUserInfoModel *) item userId:(NSString *)userId{
    NSString * updateSql = [NSString stringWithFormat:@"UPDATE USERTABLE set b1='%@' ,b143='%@' ,b144='%@' ,b19='%@' ,b24='%@' ,b29='%@' ,b32='%@' ,b33='%@' ,b37='%@' ,b46='%@' ,b52='%@' ,b57='%@' ,b62='%@' ,b67='%@' ,b69='%@' ,b75='%@' ,b86='%@' ,b87='%@' ,b9='%@' ,b94='%@',b116='%@',b17='%@',b145='%@',blackTime='%@' where b80='%@'",item.b1,item.b143,item.b144,item.b19,item.b24,item.b29,item.b32,item.b33,item.b37,item.b46,item.b52,item.b57,item.b62,item.b67,item.b69,item.b75,item.b86,item.b87,item.b9,item.b94,item.b116,item.b17,item.b145,item.blackTime,item.b80];
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
+ (DHUserInfoModel *)getUserWithCurrentUserId:(NSString *)userId{
    return [[DHUserInfoDao shareInstance] getUserWithCurrentUserId:userId];
}
- (DHUserInfoModel *)getUserWithCurrentUserId:(NSString *)userId{
    NSString * sql=[NSString stringWithFormat:@"SELECT * FROM USERTABLE where b80='%@'",userId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    __block DHUserInfoModel *item = nil;
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            item = [[DHUserInfoModel alloc]init];
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
        }
        [result close];
    }];
    return item;
}
+ (DHUserInfoModel *)getRobotUserWithRobotId:(NSString *)robotId gender:(NSInteger )gender{
    return [[DHUserInfoDao shareInstance] getRobotUserWithRobotId:robotId gender:gender];
}
- (DHUserInfoModel *)getRobotUserWithRobotId:(NSString *)robotId gender:(NSInteger )gender{
    NSMutableArray *arr = [NSMutableArray array];
    // 判断性别,取当前用户性别相反的机器人
    //    NSString *gender = [NSString stringWithFormat:@"%ld",gender];
    NSString *gender1 = nil;
    if (gender  == 1) {
        gender1 = @"2";
    }else{
        gender1 = @"1";
    }
    NSString * sql= nil;
    if ([robotId length] == 0) {
        sql = [NSString stringWithFormat:@"SELECT * FROM USERTABLE where b143='2' and b69='%@'",gender1];
    }else{
        sql = [NSString stringWithFormat:@"SELECT * FROM USERTABLE where b143='2' and b80='%@' and b69='%@'",robotId,gender1];
    }
    
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    __block DHUserInfoModel *item = nil;
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            item = [[DHUserInfoModel alloc]init];
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
            [arr addObject:item];
        }
        [result close];
    }];
    if (arr.count > 0) {
        NSInteger randomIndex = arc4random() % arr.count;
        if (randomIndex < 0) {
            randomIndex = 0;
        }else if(randomIndex > arr.count - 1){
            randomIndex = arr.count -1;
        }
        return [arr objectAtIndex:randomIndex];
    }else{
        return nil;
    }
    
    
}

@end
