//

//  RCloudMessage
//
//  Created by wjb on 15/6/3.
//  Copyright (c) 2015年 wbj. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "DHMessageModel.h"
//#import "DHUserInfoModel.h"
//#import "DHRandomMessageModel.h"
//#import "DHLoginUserForListModel.h"
//#import "DHDomainModel.h"
@interface DBManager : NSObject
/**
 *  单例
 *
 *  @return 返回DBManager对象
 */
+ (instancetype)shareInstance;
+ (void)createUserTableWithSQL:(NSString *)sql tableName:(NSString *)tableName;
// 插入聊天数据
//+ (void)insertMessageDataDBWithModel:(DHMessageModel *)model userId:(NSString *)userId;
/**
 *  修改阅读状态
 *
 *  @param isReadStatus 1---未读，2---已读
 *  @param targetId
 */
//+ (void)updateMessageIsReadStatusWithStatus:(NSString *)isReadStatus targetId:(NSString *)targetId;
/**
 *  获取未读的信息数
 *
 *  @param targetId
 *
 *  @return 
 */
//+ (NSInteger )getBadgeValueWithTargetId:(NSString *)targetId currentUserId:(NSString *)currentUserId;
// 修改发送成功的消息
//+ (void)updateSendMessagesToSucessWithAccount:(NSString *)account chatId:(NSString *)chatId;
/**
 *  聊天过程，某条消息是否存在记录
 *
 *  @param messageId 消息id
 *  @param fromUserAccount 谁发给我（那个人的id）
 *
 *  @return BOOL
 */
//+ (BOOL) checkMessageWithMessageId:(NSString *)messageId targetId:(NSString *)targetId;
// 查询某人消息列表
//+ (NSMutableArray *)selectMessageDBWithUserId:(NSString *)userId targetId:(NSString *)targetId;
/**
 *  获取当前用户聊天列表
 *
 *  @return 
 */
//+ (NSMutableArray *)getChatListWithUserId:(NSString *)targetId roomCode:(NSString *)roomCode;
/**
 *  获取某个机器人发的消息，不包括某个用户给这个机器人发的消息
 *
 *  @param targetId 机器人id
 *
 *  @return
 */
//+ (NSMutableArray *)getRobotChatListWithUserId:(NSString *)targetId;
/**
 *  检测当前聊天下，机器人有没有发这类消息，有返回yes，没有返回no
 *
 *  @param robotId          机器人id
 *  @param robotMessageType 消息类型1、2、3、4
 *
 *  @return
 */
//+ (BOOL) checkRobotMessageWithRobotId:(NSString *)robotId robotMessageType:(NSString *)robotMessageType;

/**
 *  获取当前用户下所有的消息列表
 *
 *  @param userId
 *
 *  @return
 */
+ (NSMutableArray *)getChatListWithCurrentUserId:(NSString *)userId;
/**
 *  将要聊天的用户信息插入数据库
 *
 *  @param item
 *  @param userId 当前用户信息
 */
+ (void) insertChatToDBWithTargetId:(NSString *)targetId tagetName:(NSString *)targetName headerImage:(NSString *)headerImage time:(NSString *)createTime body:(NSString *)body currentUserId:(NSString *)userId;
/**
 *  当前聊天对象是否存在记录
 *
 *  @param targetId 聊天对象id
 *  @param userId 当前用户
 *
 *  @return BOOL
 */
+ (BOOL) checkChatWithTargetId:(NSString *)targetId userId:(NSString *)userId;
/**
 *  用户是否存在
 *
 *  @param userId
 *
 *  @return
 */
//+ (BOOL) checkUserWithUsertId:(NSString *)userId;
/**
 *  插入用户数据
 *
 *  @param item
 */
//+ (void) insertUserToDBWithItem:(DHUserInfoModel *)item;
/**
 *  更新用户数据
 *
 *  @param item
 *  @param userId
 */
//+ (void) updateUserToDBWithItem:(DHUserInfoModel *) item userId:(NSString *)userId;
/**
 *  获取某人数据
 *
 *  @param userId
 *
 *  @return
 */
//+ (DHUserInfoModel *)getUserWithCurrentUserId:(NSString *)userId;
/**
 *  获取某个机器人与消息列表数据匹配
 *
 *  @param userId
 *
 *  @return
 */
//+ (DHUserInfoModel *)getRobotUserWithRobotId:(NSString *)robotId gender:(NSInteger)gender;
/**
 *  删除某个人的所有聊天记录
 *
 *  @param targetId
 *  @param userId
 */
//+ (void)deleteChatWithTargetId:(NSString *)targetId userId:(NSString *)userId;

/**
 *  检查随机消息是否存在
 *
 *  @param userId    当前用户id
 *  @param messageId 消息id，b34
 *
 *  @return
 */
//+ (BOOL) checkRandomMessageWithUsertId:(NSString *)userId messageId:(NSString *)messageId;
/**
 *  插入随机消息
 *
 *  @param item
 *  @param userId 当前用户id
 */
//+ (void) insertRandomMessageToDBWithItem:(DHRandomMessageModel *)item userId:(NSString *)userId;
/**
 *  查询某类型的随机一条消息
 *
 *  @param userId      当前用户id
 *  @param messageType 消息类型
 *
 *  @return <#return value description#>
 */
//+ (DHRandomMessageModel *)getRandomMessageWithCurrentUserId:(NSString *)userId messageType:(NSString *)messageType;
/**
 *  查询登录列表是否有登录过
 *
 *  @param userId
 *
 *  @return 
 */
//+ (BOOL) checkLoginUserWithUsertId:(NSString *)userId;

@end
