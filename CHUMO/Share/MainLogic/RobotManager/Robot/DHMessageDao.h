//
//  DHMessageDao.h
//  DHBaseFrameWork
//
//  Created by xy2 on 16/3/23.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DBManager.h"
#import "DHMessageModel.h"
@interface DHMessageDao : DBManager
/**
 *  聊天过程，某条消息是否存在记录
 *
 *  @param messageId 消息id
 *  @param fromUserAccount 谁发给我（那个人的id）
 *
 *  @return BOOL
 */
+ (BOOL) checkMessageWithMessageId:(NSString *)messageId targetId:(NSString *)targetId;
/**
 *  插入消息
 *
 *  @param model
 *  @param userId 
 */
+ (void)insertMessageDataDBWithModel:(DHMessageModel *)model userId:(NSString *)userId;
/**
 *  修改阅读状态
 *
 *  @param isReadStatus 1---未读，2---已读
 *  @param targetId
 */
+ (void)updateMessageIsReadStatusWithStatus:(NSString *)isReadStatus targetId:(NSString *)targetId;
/**
 *  获取未读的信息数
 *
 *  @param targetId
 *
 *  @return
 */
+ (NSInteger )getBadgeValueWithTargetId:(NSString *)targetId currentUserId:(NSString *)currentUserId;
/**
 *  获取当前用户聊天列表
 *
 *  @return
 */
+ (NSMutableArray *)getChatListWithUserId:(NSString *)targetId roomCode:(NSString *)roomCode;
/**
 *  获取某个机器人发的消息，不包括某个用户给这个机器人发的消息
 *
 *  @param targetId 机器人id
 *
 *  @return
 */
+ (NSMutableArray *)getRobotChatListWithUserId:(NSString *)targetId;
/**
 *  检测当前聊天下，机器人有没有发这类消息，有返回yes，没有返回no
 *
 *  @param robotId          机器人id
 *  @param robotMessageType 消息类型1、2、3、4
 *
 *  @return
 */
+ (BOOL) checkRobotMessageWithRobotId:(NSString *)robotId robotMessageType:(NSString *)robotMessageType;
/**
 *  删除某个人的所有聊天记录
 *
 *  @param targetId
 *  @param userId
 */
+ (void)deleteChatWithTargetId:(NSString *)targetId userId:(NSString *)userId;
/**
 *  修改发送成功的消息
 *
 *  @param account
 *  @param chatId  
 */
+ (void)updateSendMessagesToSucessWithAccount:(NSString *)account chatId:(NSString *)chatId;
/**
 *  查询某人消息列表
 *
 *  @param userId
 *  @param targetId
 *
 *  @return 
 */
+ (NSMutableArray *)selectMessageDBWithUserId:(NSString *)userId targetId:(NSString *)targetId atIndex:(NSInteger )index;
/**
 *  分页专用
 *
 *  @param userId
 *  @param targetId
 *  @param lastTime 上一条时间
 *
 *  @return 
 */
+ (NSMutableArray *)selectMessageDBWithUserId:(NSString *)userId targetId:(NSString *)targetId lastTime:(NSString *)lastTime;
/**
 *  根据消息id获取某条消息
 *
 *  @param messageId
 *
 *  @return 
 */
+ (DHMessageModel *)getMessageWithMessageId:(NSString *)messageId ;

@end
