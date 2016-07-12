//
//  RCloudMessage
//
//  Created by wbj on 15/6/3.
//  Copyright (c) 2015年 wbj. All rights reserved.
//

#import "DBManager.h"
#import "DBHelper.h"
@implementation DBManager




//static NSString * const ROBOTTABLE = @"ROBOTTABLE";

#pragma mark - Singleton
+ (instancetype)shareInstance{
    static DBManager* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
//        [instance createUserTable];
    });
    return instance;
}
//创建用户存储表
+ (void)createUserTableWithSQL:(NSString *)sql tableName:(NSString *)tableName{
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        if (![DBHelper isTableOK: tableName withDB:db]) {
            [db executeUpdate:sql];
        }
//        if (![DBHelper isTableOK: MESSAGETABLE withDB:db]) {
//            NSString *createTableSQL = @"CREATE TABLE MESSAGETABLE (messageId text,messageType text,message text,timeStamp text,fromUserAccount text,fromUserDevice text,toUserAccount text,token text,roomCode text,roomName text,userId text,targetId text,robotMessageType text,isRead text,targetUserType text)";
//            [db executeUpdate:createTableSQL];
//        }
//        if (![DBHelper isTableOK: USERTABLE withDB:db]) {
//            NSString *createTableSQL = @"CREATE TABLE USERTABLE (b1 text,b143 text,b144 text,b19 text,b24 text,b29 text,b32 text,b33 text,b37 text,b46 text,b52 text,b57 text,b62 text,b67 text,b69 text,b75 text,b80 text,b86 text,b87 text,b9 text,b94 text, b116 text,b17 text,b145 text)";
//            [db executeUpdate:createTableSQL];
//        }
//        if (![DBHelper isTableOK: RANDOMMESSAGETABLE withDB:db]) {
//            NSString *createTableSQL = @"CREATE TABLE RANDOMMESSAGETABLE (b34 text,b14 text,b78 text,userId text)";
//            [db executeUpdate:createTableSQL];
//        }
    }];
}
///**
// *  聊天过程，某条消息是否存在记录
// *
// *  @param chatId 消息id
// *  @param userId 当前用户id
// *
// *  @return BOOL
// */
//+ (BOOL) checkMessageWithMessageId:(NSString *)messageId targetId:(NSString *)targetId{
//    return [[DBManager shareInstance] checkMessageWithMessageId:messageId targetId:targetId];
//}
////messageId text,messageType text,timeStamp text,fromUserAccount text,fromUserDevice text,toUserAccount text,token text,userId text
//- (BOOL) checkMessageWithMessageId:(NSString *)messageId targetId:(NSString *)targetId{
//    NSString *sql10 = [NSString stringWithFormat:@"SELECT * FROM MESSAGETABLE WHERE messageId = '%@' AND targetId = '%@'",messageId,targetId];
//    __block BOOL flag = NO;
//    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
//    [queue inDatabase:^(FMDatabase *db) {
//        FMResultSet *rs = [db executeQuery:sql10];
//        while ([rs next]) {
//            flag = YES;
//        }
//        [rs close];
//    }];
//    return flag;
//}
//// 插入聊天数据
//+ (void)insertMessageDataDBWithModel:(DHMessageModel *)item userId:(NSString *)userId{
//    [[DBManager shareInstance] insertMessageDataDBWithModel:item userId:userId];
//}
//- (void)insertMessageDataDBWithModel:(DHMessageModel *)item userId:(NSString *)userId{
//    NSString * insertSql = [NSString stringWithFormat:@"INSERT INTO MESSAGETABLE (messageId ,messageType ,message ,timeStamp ,fromUserAccount ,fromUserDevice ,toUserAccount ,token, roomCode ,roomName ,userId ,targetId,robotMessageType,isRead,targetUserType) VALUES  ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",item.messageId,item.messageType,item.message,item.timeStamp,item.fromUserAccount,item.fromUserDevice,item.toUserAccount,item.token,item.roomCode,item.roomName,userId,item.targetId,item.robotMessageType,item.isRead,item.targetUserType];
//    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
//    [queue inDatabase:^(FMDatabase *db) {
//        [db executeUpdate:insertSql];
//    }];
//}
//// 修改阅读状态
//+ (void)updateMessageIsReadStatusWithStatus:(NSString *)isReadStatus targetId:(NSString *)targetId{
//    [[DBManager shareInstance] updateMessageIsReadStatusWithStatus:isReadStatus targetId:targetId];
//}
//- (void)updateMessageIsReadStatusWithStatus:(NSString *)isReadStatus targetId:(NSString *)targetId{
//    NSString * str = [NSString stringWithFormat:@"update MESSAGETABLE set isRead = '%@' where targetId = '%@'",isReadStatus,targetId];;
//    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
//    [queue inDatabase:^(FMDatabase *db) {
//        [db executeUpdate:str];
//    }];
//}
//
//+ (NSInteger )getBadgeValueWithTargetId:(NSString *)targetId currentUserId:(NSString *)currentUserId{
//    return [[DBManager shareInstance] getBadgeValueWithTargetId:targetId currentUserId:currentUserId];
//}
//- (NSInteger )getBadgeValueWithTargetId:(NSString *)targetId currentUserId:(NSString *)currentUserId{
////    NSMutableArray *allMutableArray = [NSMutableArray array];
//    __block NSInteger temp = 0;
//    NSString * sql = nil;
//    if ([targetId length] == 0) {
//        sql = [NSString stringWithFormat:@"select * from MESSAGETABLE where isRead='1' and userId='%@'",currentUserId];
//    }else{
//        sql = [NSString stringWithFormat:@"select * from MESSAGETABLE where targetId = '%@' and isRead='1' and userId='%@'",targetId,currentUserId];
//    }
//    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
//    [queue inDatabase:^(FMDatabase *db) {
//        FMResultSet *result = [db executeQuery:sql];
////        temp = [result columnCount];
//        while ([result next]) {
//           temp ++;
//        }
//        [result close];
//    }];
////    return allMutableArray;
//    return temp;
//}
//+ (NSMutableArray *)getChatListWithUserId:(NSString *)targetId roomCode:(NSString *)roomCode{
//    return [[DBManager shareInstance] getChatListWithUserId:targetId roomCode:roomCode];
//}
//- (NSMutableArray *)getChatListWithUserId:(NSString *)targetId roomCode:(NSString *)roomCode{
//    NSMutableArray *allMutableArray = [NSMutableArray array];
//    NSString * sql=[NSString stringWithFormat:@"select *from messagetable where userId = '%@' group by targetId order by timeStamp desc",targetId];
//    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
//    [queue inDatabase:^(FMDatabase *db) {
//        FMResultSet *result = [db executeQuery:sql];
//        while ([result next]) {
//            DHMessageModel *item = [DHMessageModel new];
//            // messageId ,messageType ,message ,timeStamp ,fromUserAccount ,fromUserDevice ,toUserAccount ,token ,userId
//            item.messageId = [result stringForColumn:@"messageId"];
//            item.messageType = [result stringForColumn:@"messageType"];
//            item.message = [result stringForColumn:@"message"];
//            item.timeStamp = [result stringForColumn:@"timeStamp"];
//            item.fromUserDevice = [result stringForColumn:@"fromUserDevice"];
//            item.fromUserAccount = [result stringForColumn:@"fromUserAccount"];
//            item.toUserAccount = [result stringForColumn:@"toUserAccount"];
//            item.token = [result stringForColumn:@"token"];
//            item.roomCode = [result stringForColumn:@"roomCode"];
//            item.roomName = [result stringForColumn:@"roomName"];
//            item.userId = [result stringForColumn:@"userId"];
//            item.targetId = [result stringForColumn:@"targetId"];
//            item.robotMessageType = [result stringForColumn:@"robotMessageType"];
//            item.isRead = [result stringForColumn:@"isRead"];
//            item.targetUserType = [result stringForColumn:@"targetUserType"];
//            [allMutableArray addObject:item];
//        }
//        [result close];
//    }];
//    return allMutableArray;
//}
//+ (NSMutableArray *)getRobotChatListWithUserId:(NSString *)targetId{
//    return [[DBManager shareInstance] getRobotChatListWithUserId:targetId];
//}
//- (NSMutableArray *)getRobotChatListWithUserId:(NSString *)targetId{
//    NSMutableArray *allMutableArray = [NSMutableArray array];
//    NSString * sql=[NSString stringWithFormat:@"select *from messagetable where targetId = '%@' and robotMessageType !='-1'",targetId];
//    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
//    [queue inDatabase:^(FMDatabase *db) {
//        FMResultSet *result = [db executeQuery:sql];
//        while ([result next]) {
//            DHMessageModel *item = [DHMessageModel new];
//            // messageId ,messageType ,message ,timeStamp ,fromUserAccount ,fromUserDevice ,toUserAccount ,token ,userId
//            item.messageId = [result stringForColumn:@"messageId"];
//            item.messageType = [result stringForColumn:@"messageType"];
//            item.message = [result stringForColumn:@"message"];
//            item.timeStamp = [result stringForColumn:@"timeStamp"];
//            item.fromUserDevice = [result stringForColumn:@"fromUserDevice"];
//            item.fromUserAccount = [result stringForColumn:@"fromUserAccount"];
//            item.toUserAccount = [result stringForColumn:@"toUserAccount"];
//            item.token = [result stringForColumn:@"token"];
//            item.roomCode = [result stringForColumn:@"roomCode"];
//            item.roomName = [result stringForColumn:@"roomName"];
//            item.userId = [result stringForColumn:@"userId"];
//            item.targetId = [result stringForColumn:@"targetId"];
//            item.robotMessageType = [result stringForColumn:@"robotMessageType"];
//            item.isRead = [result stringForColumn:@"isRead"];
//            item.targetUserType = [result stringForColumn:@"targetUserType"];
//            [allMutableArray addObject:item];
//        }
//        [result close];
//    }];
//    return allMutableArray;
//}
//+ (BOOL) checkRobotMessageWithRobotId:(NSString *)robotId robotMessageType:(NSString *)robotMessageType{
//    return [[DBManager shareInstance] checkRobotMessageWithRobotId:robotId robotMessageType:robotMessageType];
//}
//- (BOOL) checkRobotMessageWithRobotId:(NSString *)robotId robotMessageType:(NSString *)robotMessageType{
//    NSString *sql10 = [NSString stringWithFormat:@"SELECT * FROM MESSAGETABLE WHERE targetId = '%@' AND robotMessageType = '%@'",robotId,robotMessageType];
//    __block BOOL flag = NO;
//    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
//    [queue inDatabase:^(FMDatabase *db) {
//        FMResultSet *rs = [db executeQuery:sql10];
//        while ([rs next]) {
//            flag = YES;
//        }
//        [rs close];
//    }];
//    return flag;
//}
///**
// *  删除某个人的所有聊天记录
// *
// *  @param targetId
// *  @param userId
// */
//+ (void)deleteChatWithTargetId:(NSString *)targetId userId:(NSString *)userId{
//    [[DBManager shareInstance] deleteChatWithTargetId:targetId userId:userId];
//}
//- (void)deleteChatWithTargetId:(NSString *)targetId userId:(NSString *)userId{
//    NSString * str=[NSString stringWithFormat:@"delete from  MESSAGETABLE where targetId='%@' and userId='%@'",targetId,userId];
//    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
//    [queue inDatabase:^(FMDatabase *db) {
//        [db executeUpdate:str];
//    }];
//}
//
//
//// 修改发送成功的消息
//+ (void)updateSendMessagesToSucessWithAccount:(NSString *)account chatId:(NSString *)chatId{
//    [[DBManager shareInstance] updateSendMessagesToSucessWithAccount:account chatId:chatId];
//}
//- (void)updateSendMessagesToSucessWithAccount:(NSString *)account chatId:(NSString *)chatId{
//    NSString * str=[NSString stringWithFormat:@"update MESSAGETABLE set mark = '%d' where chatId = '%@'",1,chatId];
//    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
//    [queue inDatabase:^(FMDatabase *db) {
//        [db executeUpdate:str];
//    }];
//}
//
//// 查询某人消息列表
//+ (NSMutableArray *)selectMessageDBWithUserId:(NSString *)userId targetId:(NSString *)targetId{
//    return [[DBManager shareInstance] selectMessageDBWithUserId:userId targetId:targetId];
//}
//- (NSMutableArray *)selectMessageDBWithUserId:(NSString *)userId targetId:(NSString *)targetId{
//    NSMutableArray *allMutableArray = [NSMutableArray array];
//    NSString * sql=[NSString stringWithFormat:@"SELECT * FROM MESSAGETABLE where userId='%@' and targetId='%@'",userId,targetId];
//    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
//    [queue inDatabase:^(FMDatabase *db) {
//        FMResultSet *result = [db executeQuery:sql];
//        while ([result next]) {
//            DHMessageModel *item = [DHMessageModel new];
//            // messageId ,messageType ,message ,timeStamp ,fromUserAccount ,fromUserDevice ,toUserAccount ,token ,userId
//            item.messageId = [result stringForColumn:@"messageId"];
//            item.messageType = [result stringForColumn:@"messageType"];
//            item.message = [result stringForColumn:@"message"];
//            item.timeStamp = [result stringForColumn:@"timeStamp"];
//            item.fromUserDevice = [result stringForColumn:@"fromUserDevice"];
//            item.fromUserAccount = [result stringForColumn:@"fromUserAccount"];
//            item.toUserAccount = [result stringForColumn:@"toUserAccount"];
//            item.token = [result stringForColumn:@"token"];
//            item.roomCode = [result stringForColumn:@"roomCode"];
//            item.roomName = [result stringForColumn:@"roomName"];
//            item.userId = [result stringForColumn:@"userId"];
//            item.targetId = [result stringForColumn:@"targetId"];
//            item.robotMessageType = [result stringForColumn:@"robotMessageType"];
//            item.isRead = [result stringForColumn:@"isRead"];
//            item.targetUserType = [result stringForColumn:@"targetUserType"];
//            [allMutableArray addObject:item];
//        }
//        [result close];
//    }];
//    return allMutableArray;
//}
//
///**
// *  当前聊天对象是否存在记录
// *
// *  @param targetId 聊天对象id
// *  @param userId 当前用户
// *
// *  @return BOOL
// */
//+ (BOOL) checkChatWithTargetId:(NSString *)targetId userId:(NSString *)userId{
//    return [[DBManager shareInstance] checkChatWithTargetId:targetId userId:userId];
//}
//- (BOOL) checkChatWithTargetId:(NSString *)targetId userId:(NSString *)userId{
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM CHATLISTTABLE WHERE targetId = '%@' AND userId = '%@'",targetId,userId];
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
// *  将要聊天的用户信息插入数据库
// *
// *  @param item
// *  @param userId 当前用户信息
// */
//+ (void) insertChatToDBWithTargetId:(NSString *)targetId tagetName:(NSString *)targetName headerImage:(NSString *)headerImage time:(NSString *)createTime body:(NSString *)body currentUserId:(NSString *)userId{
//    [[DBManager shareInstance] insertChatToDBWithTargetId:targetId tagetName:targetName headerImage:headerImage time:createTime body:body currentUserId:userId];
//}
//- (void) insertChatToDBWithTargetId:(NSString *)targetId tagetName:(NSString *)targetName headerImage:(NSString *)headerImage time:(NSString *)createTime body:(NSString *)body currentUserId:(NSString *)userId{
//    NSString * insertSql = [NSString stringWithFormat:@"INSERT INTO CHATLISTTABLE (targetId ,targetName ,headerImage ,body ,time  ,userId ) VALUES  ('%@','%@','%@','%@','%@','%@')",targetId,targetName,headerImage,body,createTime,userId];
//    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
//    [queue inDatabase:^(FMDatabase *db) {
//        [db executeUpdate:insertSql];
//    }];
//}
//
//
//
///**
// *  获取当前用户下所有的消息列表
// *
// *  @param userId
// *
// *  @return
// */
//+ (NSMutableArray *)getChatListWithCurrentUserId:(NSString *)userId{
//    return [[DBManager shareInstance] getChatListWithCurrentUserId:userId];
//}
//- (NSMutableArray *)getChatListWithCurrentUserId:(NSString *)userId{
//    NSMutableArray *allMutableArray = [NSMutableArray array];
//    NSString * sql=[NSString stringWithFormat:@"SELECT * FROM CHATLISTTABLE where userId='%@'",userId];
//    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
//    [queue inDatabase:^(FMDatabase *db) {
//        FMResultSet *result = [db executeQuery:sql];
//        while ([result next]) {
//            NSString *targetId = [result stringForColumn:@"targetId"];
//            NSString *targetName = [result stringForColumn:@"targetName"];
//            NSString *headerImage = [result stringForColumn:@"headerImage"];
//            NSString *body = [result stringForColumn:@"body"];
//            NSString *createTime = [result stringForColumn:@"time"];
//            NSString *userId = [result stringForColumn:@"userId"];
//            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            [dict setObject:targetId forKey:@"targetId"];
//            [dict setObject:targetName forKey:@"targetName"];
//            [dict setObject:headerImage forKey:@"headerImage"];
//            [dict setObject:body forKey:@"body"];
//            [dict setObject:createTime forKey:@"time"];
//            [dict setObject:userId forKey:@"userId"];
//            [allMutableArray addObject:dict];
//        }
//        [result close];
//    }];
//    return allMutableArray;
//}
//+ (BOOL) checkUserWithUsertId:(NSString *)userId{
//    return [[DBManager shareInstance] checkUserWithUsertId:userId];
//}
//- (BOOL) checkUserWithUsertId:(NSString *)userId{
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM USERTABLE WHERE b80 = '%@'",userId];
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
// *  插入用户数据
// *
// *  @param item
// */
//+ (void) insertUserToDBWithItem:(DHUserInfoModel *)item{
//    [[DBManager shareInstance] insertUserToDBWithItem:item];
//}
//- (void) insertUserToDBWithItem:(DHUserInfoModel *)item{
//    NSString * insertSql = [NSString stringWithFormat:@"INSERT INTO USERTABLE (b1 ,b143 ,b144 ,b19 ,b24 ,b29 ,b32 ,b33 ,b37 ,b46 ,b52 ,b57 ,b62 ,b67 ,b69 ,b75 ,b80 ,b86 ,b87 ,b9 ,b94, b116,b17,b145) VALUES  ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",item.b1,item.b143,item.b144,item.b19,item.b24,item.b29,item.b32,item.b33,item.b37,item.b46,item.b52,item.b57,item.b62,item.b67,item.b69,item.b75,item.b80,item.b86,item.b87,item.b9,item.b94,item.b116,item.b17,item.b145];
//    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
//    [queue inDatabase:^(FMDatabase *db) {
//        [db executeUpdate:insertSql];
//    }];
//}
//
//+ (void) updateUserToDBWithItem:(DHUserInfoModel *) item userId:(NSString *)userId{
//    [[DBManager shareInstance] updateUserToDBWithItem:item userId:userId];
//}
//- (void) updateUserToDBWithItem:(DHUserInfoModel *) item userId:(NSString *)userId{
//    NSString * updateSql = [NSString stringWithFormat:@"UPDATE USERTABLE set b1='%@' ,b143='%@' ,b144='%@' ,b19='%@' ,b24='%@' ,b29='%@' ,b32='%@' ,b33='%@' ,b37='%@' ,b46='%@' ,b52='%@' ,b57='%@' ,b62='%@' ,b67='%@' ,b69='%@' ,b75='%@' ,b86='%@' ,b87='%@' ,b9='%@' ,b94='%@',b116='%@',b17='%@',b145='%@' where b80='%@'",item.b1,item.b143,item.b144,item.b19,item.b24,item.b29,item.b32,item.b33,item.b37,item.b46,item.b52,item.b57,item.b62,item.b67,item.b69,item.b75,item.b86,item.b87,item.b9,item.b94,item.b116,item.b17,item.b145,item.b80];
//    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
//    [queue inDatabase:^(FMDatabase *db) {
//        [db executeUpdate:updateSql];
//    }];
//}
//
///**
// *  获取某人数据
// *
// *  @param userId
// *
// *  @return
// */
//+ (DHUserInfoModel *)getUserWithCurrentUserId:(NSString *)userId{
//    return [[DBManager shareInstance] getUserWithCurrentUserId:userId];
//}
//- (DHUserInfoModel *)getUserWithCurrentUserId:(NSString *)userId{
//    NSString * sql=[NSString stringWithFormat:@"SELECT * FROM USERTABLE where b80='%@'",userId];
//    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
//    __block DHUserInfoModel *item = nil;
//    [queue inDatabase:^(FMDatabase *db) {
//        FMResultSet *result = [db executeQuery:sql];
//        while ([result next]) {
//            item = [[DHUserInfoModel alloc]init];
//            item.b1 = [result stringForColumn:@"b1"];
//            item.b143 = [result stringForColumn:@"b143"];
//            item.b144 = [result stringForColumn:@"b144"];
//            item.b19 = [result stringForColumn:@"b19"];
//            item.b24 = [result stringForColumn:@"b24"];
//            item.b29 = [result stringForColumn:@"b29"];
//            item.b32 = [result stringForColumn:@"b32"];
//            item.b33 = [result stringForColumn:@"b33"];
//            item.b37 = [result stringForColumn:@"b37"];
//            item.b46 = [result stringForColumn:@"b46"];
//            item.b52 = [result stringForColumn:@"b52"];
//            item.b57 = [result stringForColumn:@"b57"];
//            item.b62 = [result stringForColumn:@"b62"];
//            item.b67 = [result stringForColumn:@"b67"];
//            item.b69 = [result stringForColumn:@"b69"];
//            item.b75 = [result stringForColumn:@"b75"];
//            item.b80 = [result stringForColumn:@"b80"];
//            item.b86 = [result stringForColumn:@"b86"];
//            item.b87 = [result stringForColumn:@"b87"];
//            item.b9 = [result stringForColumn:@"b9"];
//            item.b94 = [result stringForColumn:@"b94"];
//            item.b116 = [result stringForColumn:@"b116"];
//            item.b17 = [result stringForColumn:@"b17"];
//            item.b145 = [result stringForColumn:@"b145"];
//        }
//        [result close];
//    }];
//    return item;
//}
//+ (DHUserInfoModel *)getRobotUserWithRobotId:(NSString *)robotId gender:(NSInteger )gender{
//    return [[DBManager shareInstance] getRobotUserWithRobotId:robotId gender:gender];
//}
//- (DHUserInfoModel *)getRobotUserWithRobotId:(NSString *)robotId gender:(NSInteger )gender{
//    NSMutableArray *arr = [NSMutableArray array];
//    // 判断性别,取当前用户性别相反的机器人
////    NSString *gender = [NSString stringWithFormat:@"%ld",gender];
//    NSString *gender1 = nil;
//    if (gender  == 1) {
//        gender1 = @"2";
//    }else{
//        gender1 = @"1";
//    }
//    NSString * sql= nil;
//    if ([robotId length] == 0) {
//        sql = [NSString stringWithFormat:@"SELECT * FROM USERTABLE where b143='2' and b69='%@'",gender1];
//    }else{
//      sql = [NSString stringWithFormat:@"SELECT * FROM USERTABLE where b143='2' and b80='%@' and b69='%@'",robotId,gender1];
//    }
//    
//    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
//    __block DHUserInfoModel *item = nil;
//    [queue inDatabase:^(FMDatabase *db) {
//        FMResultSet *result = [db executeQuery:sql];
//        while ([result next]) {
//            item = [[DHUserInfoModel alloc]init];
//            item.b1 = [result stringForColumn:@"b1"];
//            item.b143 = [result stringForColumn:@"b143"];
//            item.b144 = [result stringForColumn:@"b144"];
//            item.b19 = [result stringForColumn:@"b19"];
//            item.b24 = [result stringForColumn:@"b24"];
//            item.b29 = [result stringForColumn:@"b29"];
//            item.b32 = [result stringForColumn:@"b32"];
//            item.b33 = [result stringForColumn:@"b33"];
//            item.b37 = [result stringForColumn:@"b37"];
//            item.b46 = [result stringForColumn:@"b46"];
//            item.b52 = [result stringForColumn:@"b52"];
//            item.b57 = [result stringForColumn:@"b57"];
//            item.b62 = [result stringForColumn:@"b62"];
//            item.b67 = [result stringForColumn:@"b67"];
//            item.b69 = [result stringForColumn:@"b69"];
//            item.b75 = [result stringForColumn:@"b75"];
//            item.b80 = [result stringForColumn:@"b80"];
//            item.b86 = [result stringForColumn:@"b86"];
//            item.b87 = [result stringForColumn:@"b87"];
//            item.b9 = [result stringForColumn:@"b9"];
//            item.b94 = [result stringForColumn:@"b94"];
//            item.b116 = [result stringForColumn:@"b116"];
//            item.b17 = [result stringForColumn:@"b17"];
//            item.b145 = [result stringForColumn:@"b145"];
//            
//            [arr addObject:item];
//        }
//        [result close];
//    }];
//    if (arr.count > 0) {
//        NSInteger randomIndex = arc4random() % arr.count;
//        if (randomIndex < 0) {
//            randomIndex = 0;
//        }else if(randomIndex > arr.count - 1){
//            randomIndex = arr.count -1;
//        }
//        return [arr objectAtIndex:randomIndex];
//    }else{
//        return nil;
//    }
//    
//    
//}
//
//// 检查随机消息是否存在
//+ (BOOL) checkRandomMessageWithUsertId:(NSString *)userId messageId:(NSString *)messageId {
//    return [[DBManager shareInstance] checkRandomMessageWithUsertId:userId messageId:messageId];
//}
//- (BOOL) checkRandomMessageWithUsertId:(NSString *)userId messageId:(NSString *)messageId{
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM RANDOMMESSAGETABLE WHERE b34='%@' and userId = '%@'",messageId,userId];
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
//+ (void) insertRandomMessageToDBWithItem:(DHRandomMessageModel *)item userId:(NSString *)userId{
//    [[DBManager shareInstance] insertRandomMessageToDBWithItem:item userId:userId];
//    
//}
//- (void) insertRandomMessageToDBWithItem:(DHRandomMessageModel *)item userId:(NSString *)userId{
//    NSString * insertSql = [NSString stringWithFormat:@"INSERT INTO RANDOMMESSAGETABLE (b34 ,b14 ,b78 ,userId) VALUES  ('%@','%@','%@','%@')",item.b34,item.b14,item.b78,userId];
//    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
//    [queue inDatabase:^(FMDatabase *db) {
//        [db executeUpdate:insertSql];
//    }];
//}
//+ (DHRandomMessageModel *)getRandomMessageWithCurrentUserId:(NSString *)userId messageType:(NSString *)messageType{
//    return [[DBManager shareInstance] getRandomMessageWithCurrentUserId:userId messageType:messageType];
//}
//- (DHRandomMessageModel *)getRandomMessageWithCurrentUserId:(NSString *)userId messageType:(NSString *)messageType{
//    
//    NSMutableArray *arr = [NSMutableArray array];
//    NSString * sql=[NSString stringWithFormat:@"SELECT * FROM RANDOMMESSAGETABLE where userId='%@' and b78='%@'",userId,messageType];
//    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
//    [queue inDatabase:^(FMDatabase *db) {
//        FMResultSet *result = [db executeQuery:sql];
//        while ([result next]) {
//            DHRandomMessageModel *item = [[DHRandomMessageModel alloc]init];
//            item.b78 = [result stringForColumn:@"b78"];
//            item.b14 = [result stringForColumn:@"b14"];
//            item.b34 = [result stringForColumn:@"b34"];
//            [arr addObject:item];
//        }
//        [result close];
//    }];
//    if (arr.count > 0) {
//        NSInteger randomIndex = arc4random()%arr.count;
//        if (randomIndex<0) {
//            randomIndex = 0;
//        }else if(randomIndex > arr.count - 1){
//            randomIndex = arr.count - 1;
//        }
//        return [arr objectAtIndex:randomIndex];
//    }else{
//        return nil;
//    }
//    
//    
//}
//+ (BOOL) checkLoginUserWithUsertId:(NSString *)userId{
//    return [[DBManager shareInstance] checkLoginUserWithUsertId:userId];
//}
//- (BOOL) checkLoginUserWithUsertId:(NSString *)userId{
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM LOGINUSERTABLE WHERE userId = '%@'",userId];
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
@end
