//
//  DHMessageModel.h
//  DHRequestServer
//
//  Created by xy2 on 16/3/2.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHBaseModel.h"

@interface DHMessageModel : DHBaseModel
/**
 *  消息id
 */
@property (nonatomic,strong) NSString *messageId;
/**
 *  消息类型
 */
@property (nonatomic,strong) NSString *messageType;
/**
 *  消息时间
 */
@property (nonatomic,strong) NSString *timeStamp;
/**
 *  fromUserAccount 来自谁的id
 */
@property (nonatomic,strong) NSString *fromUserAccount;
/**
 *  来自什么手机
 */
@property (nonatomic,strong) NSString *fromUserDevice;
/**
 *  发给谁的id
 */
@property (nonatomic,strong) NSString *toUserAccount;
/**
 *  token
 */
@property (nonatomic,strong) NSString *token;
/**
 *  当前用户id
 */
@property (nonatomic,strong) NSString *userId;
/**
 *  消息内容
 */
@property (nonatomic,strong) NSString *message;
/**
 *  房间号
 */
@property (nonatomic,strong) NSString *roomCode;
/**
 *  房间名
 */
@property (nonatomic,strong) NSString *roomName;
/**
 *  聊天对象id
 */
@property (nonatomic,strong) NSString *targetId;
/**
 *  机器人消息类型：1、2、3、4，用户消息设定类型为-1
 */
@property (nonatomic,strong) NSString *robotMessageType;
/**
 *  是否已读：1--未读，2--已读
 */
@property (nonatomic,strong) NSString *isRead;
/**
 *  聊天用户类型：3--官方账号
 */
@property (nonatomic,strong) NSString *targetUserType;
@end
