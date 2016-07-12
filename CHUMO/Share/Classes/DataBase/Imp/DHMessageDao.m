//
//  DHMessageDao.m
//  DHBaseFrameWork
//
//  Created by xy2 on 16/3/23.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHMessageDao.h"
#import "DBHelper.h"
static NSString * const MESSAGETABLE   = @"MESSAGETABLE";
@implementation DHMessageDao

+(instancetype)shareInstance{
    [super shareInstance];
    static DHMessageDao *dao = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dao = [[DHMessageDao alloc]init];
        [dao createTable];
    });
    return dao;
}
- (void)createTable{
    NSString *createTableSQL = @"CREATE TABLE MESSAGETABLE (messageId text,messageType text,message text,timeStamp text,fromUserAccount text,fromUserDevice text,toUserAccount text,token text,roomCode text,roomName text,userId text,targetId text,robotMessageType text,isRead text,targetUserType text)";
    [DHMessageDao createUserTableWithSQL:createTableSQL tableName:MESSAGETABLE];
}

/**
 *  聊天过程，某条消息是否存在记录
 *
 *  @param chatId 消息id
 *  @param userId 当前用户id
 *
 *  @return BOOL
 */
+ (BOOL) checkMessageWithMessageId:(NSString *)messageId targetId:(NSString *)targetId{
    return [[DHMessageDao shareInstance] checkMessageWithMessageId:messageId targetId:targetId];
}
//messageId text,messageType text,timeStamp text,fromUserAccount text,fromUserDevice text,toUserAccount text,token text,userId text
- (BOOL) checkMessageWithMessageId:(NSString *)messageId targetId:(NSString *)targetId{
    NSString *sql10 = [NSString stringWithFormat:@"SELECT * FROM MESSAGETABLE WHERE messageId = '%@' AND targetId = '%@'",messageId,targetId];
    __block BOOL flag = NO;
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql10];
        while ([rs next]) {
            flag = YES;
        }
        [rs close];
    }];
    return flag;
}
// 插入聊天数据
+ (void)insertMessageDataDBWithModel:(DHMessageModel *)item userId:(NSString *)userId{
    [[DHMessageDao shareInstance] insertMessageDataDBWithModel:item userId:userId];
}
- (void)insertMessageDataDBWithModel:(DHMessageModel *)item userId:(NSString *)userId{
    NSString * insertSql = [NSString stringWithFormat:@"INSERT INTO MESSAGETABLE (messageId ,messageType ,message ,timeStamp ,fromUserAccount ,fromUserDevice ,toUserAccount ,token, roomCode ,roomName ,userId ,targetId,robotMessageType,isRead,targetUserType) VALUES  ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",item.messageId,item.messageType,item.message,item.timeStamp,item.fromUserAccount,item.fromUserDevice,item.toUserAccount,item.token,item.roomCode,item.roomName,userId,item.targetId,item.robotMessageType,item.isRead,item.targetUserType];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql];
    }];
}
// 修改阅读状态
+ (void)updateMessageIsReadStatusWithStatus:(NSString *)isReadStatus targetId:(NSString *)targetId{
    [[DHMessageDao shareInstance] updateMessageIsReadStatusWithStatus:isReadStatus targetId:targetId];
}
- (void)updateMessageIsReadStatusWithStatus:(NSString *)isReadStatus targetId:(NSString *)targetId{
    NSString * str = [NSString stringWithFormat:@"update MESSAGETABLE set isRead = '%@' where targetId = '%@'",isReadStatus,targetId];;
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:str];
    }];
}

+ (NSInteger )getBadgeValueWithTargetId:(NSString *)targetId currentUserId:(NSString *)currentUserId{
    return [[DHMessageDao shareInstance] getBadgeValueWithTargetId:targetId currentUserId:currentUserId];
}
- (NSInteger )getBadgeValueWithTargetId:(NSString *)targetId currentUserId:(NSString *)currentUserId{
    //    NSMutableArray *allMutableArray = [NSMutableArray array];
    __block NSInteger temp = 0;
    NSString * sql = nil;
    if ([targetId length] == 0) {
        sql = [NSString stringWithFormat:@"select * from MESSAGETABLE where isRead='1' and userId='%@'",currentUserId];
    }else{
        sql = [NSString stringWithFormat:@"select * from MESSAGETABLE where targetId = '%@' and isRead='1' and userId='%@'",targetId,currentUserId];
    }
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        //        temp = [result columnCount];
        while ([result next]) {
            temp ++;
        }
        [result close];
    }];
    //    return allMutableArray;
    return temp;
}
+ (NSMutableArray *)getChatListWithUserId:(NSString *)targetId roomCode:(NSString *)roomCode{
    return [[DHMessageDao shareInstance] getChatListWithUserId:targetId roomCode:roomCode];
}
- (NSMutableArray *)getChatListWithUserId:(NSString *)targetId roomCode:(NSString *)roomCode{
    NSMutableArray *allMutableArray = [NSMutableArray array];
    NSString * sql=[NSString stringWithFormat:@"select *from messagetable where userId = '%@' group by targetId order by timeStamp desc",targetId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            DHMessageModel *item = [DHMessageModel new];
            // messageId ,messageType ,message ,timeStamp ,fromUserAccount ,fromUserDevice ,toUserAccount ,token ,userId
            item.messageId = [result stringForColumn:@"messageId"];
            item.messageType = [result stringForColumn:@"messageType"];
            item.message = [result stringForColumn:@"message"];
            item.timeStamp = [result stringForColumn:@"timeStamp"];
            item.fromUserDevice = [result stringForColumn:@"fromUserDevice"];
            item.fromUserAccount = [result stringForColumn:@"fromUserAccount"];
            item.toUserAccount = [result stringForColumn:@"toUserAccount"];
            item.token = [result stringForColumn:@"token"];
            item.roomCode = [result stringForColumn:@"roomCode"];
            item.roomName = [result stringForColumn:@"roomName"];
            item.userId = [result stringForColumn:@"userId"];
            item.targetId = [result stringForColumn:@"targetId"];
            item.robotMessageType = [result stringForColumn:@"robotMessageType"];
            item.isRead = [result stringForColumn:@"isRead"];
            item.targetUserType = [result stringForColumn:@"targetUserType"];
            [allMutableArray addObject:item];
        }
        [result close];
    }];
    return allMutableArray;
}
+ (NSMutableArray *)getRobotChatListWithUserId:(NSString *)targetId{
    return [[DHMessageDao shareInstance] getRobotChatListWithUserId:targetId];
}
- (NSMutableArray *)getRobotChatListWithUserId:(NSString *)targetId{
    NSMutableArray *allMutableArray = [NSMutableArray array];
    NSString * sql=[NSString stringWithFormat:@"select *from messagetable where targetId = '%@' and robotMessageType !='-1'",targetId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            DHMessageModel *item = [DHMessageModel new];
            // messageId ,messageType ,message ,timeStamp ,fromUserAccount ,fromUserDevice ,toUserAccount ,token ,userId
            item.messageId = [result stringForColumn:@"messageId"];
            item.messageType = [result stringForColumn:@"messageType"];
            item.message = [result stringForColumn:@"message"];
            item.timeStamp = [result stringForColumn:@"timeStamp"];
            item.fromUserDevice = [result stringForColumn:@"fromUserDevice"];
            item.fromUserAccount = [result stringForColumn:@"fromUserAccount"];
            item.toUserAccount = [result stringForColumn:@"toUserAccount"];
            item.token = [result stringForColumn:@"token"];
            item.roomCode = [result stringForColumn:@"roomCode"];
            item.roomName = [result stringForColumn:@"roomName"];
            item.userId = [result stringForColumn:@"userId"];
            item.targetId = [result stringForColumn:@"targetId"];
            item.robotMessageType = [result stringForColumn:@"robotMessageType"];
            item.isRead = [result stringForColumn:@"isRead"];
            item.targetUserType = [result stringForColumn:@"targetUserType"];
            [allMutableArray addObject:item];
        }
        [result close];
    }];
    return allMutableArray;
}
+ (BOOL) checkRobotMessageWithRobotId:(NSString *)robotId robotMessageType:(NSString *)robotMessageType{
    return [[DHMessageDao shareInstance] checkRobotMessageWithRobotId:robotId robotMessageType:robotMessageType];
}
- (BOOL) checkRobotMessageWithRobotId:(NSString *)robotId robotMessageType:(NSString *)robotMessageType{
    NSString *sql10 = [NSString stringWithFormat:@"SELECT * FROM MESSAGETABLE WHERE targetId = '%@' AND robotMessageType = '%@'",robotId,robotMessageType];
    __block BOOL flag = NO;
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql10];
        while ([rs next]) {
            flag = YES;
        }
        [rs close];
    }];
    return flag;
}
/**
 *  删除某个人的所有聊天记录
 *
 *  @param targetId
 *  @param userId
 */
+ (void)deleteChatWithTargetId:(NSString *)targetId userId:(NSString *)userId{
    [[DHMessageDao shareInstance] deleteChatWithTargetId:targetId userId:userId];
}
- (void)deleteChatWithTargetId:(NSString *)targetId userId:(NSString *)userId{
    NSString * str=[NSString stringWithFormat:@"delete from  MESSAGETABLE where targetId='%@' and userId='%@'",targetId,userId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:str];
    }];
}


// 修改发送成功的消息
+ (void)updateSendMessagesToSucessWithAccount:(NSString *)account chatId:(NSString *)chatId{
    [[DHMessageDao shareInstance] updateSendMessagesToSucessWithAccount:account chatId:chatId];
}
- (void)updateSendMessagesToSucessWithAccount:(NSString *)account chatId:(NSString *)chatId{
    NSString * str=[NSString stringWithFormat:@"update MESSAGETABLE set mark = '%d' where chatId = '%@'",1,chatId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:str];
    }];
}

// 查询某人消息列表
+ (NSMutableArray *)selectMessageDBWithUserId:(NSString *)userId targetId:(NSString *)targetId{
    return [[DHMessageDao shareInstance] selectMessageDBWithUserId:userId targetId:targetId];
}
- (NSMutableArray *)selectMessageDBWithUserId:(NSString *)userId targetId:(NSString *)targetId{
    NSMutableArray *allMutableArray = [NSMutableArray array];
    NSString * sql=[NSString stringWithFormat:@"SELECT * FROM MESSAGETABLE where userId='%@' and targetId='%@'",userId,targetId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            DHMessageModel *item = [DHMessageModel new];
            // messageId ,messageType ,message ,timeStamp ,fromUserAccount ,fromUserDevice ,toUserAccount ,token ,userId
            item.messageId = [result stringForColumn:@"messageId"];
            item.messageType = [result stringForColumn:@"messageType"];
            item.message = [result stringForColumn:@"message"];
            item.timeStamp = [result stringForColumn:@"timeStamp"];
            item.fromUserDevice = [result stringForColumn:@"fromUserDevice"];
            item.fromUserAccount = [result stringForColumn:@"fromUserAccount"];
            item.toUserAccount = [result stringForColumn:@"toUserAccount"];
            item.token = [result stringForColumn:@"token"];
            item.roomCode = [result stringForColumn:@"roomCode"];
            item.roomName = [result stringForColumn:@"roomName"];
            item.userId = [result stringForColumn:@"userId"];
            item.targetId = [result stringForColumn:@"targetId"];
            item.robotMessageType = [result stringForColumn:@"robotMessageType"];
            item.isRead = [result stringForColumn:@"isRead"];
            item.targetUserType = [result stringForColumn:@"targetUserType"];
            [allMutableArray addObject:item];
        }
        [result close];
    }];
    return allMutableArray;
}


@end
