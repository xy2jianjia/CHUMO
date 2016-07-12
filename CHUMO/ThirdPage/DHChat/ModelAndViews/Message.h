//
//  Message.h
//  ChatDemo
//
//  Created by long on 15/4/11.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    MessageTypeMe = 0, // 自己发的
    MessageTypeOther = 1 //别人发得
    
} MessageType;
//messageId text,messageType text,message text,timeStamp text,fromUserAccount text,fromUserDevice text,toUserAccount text,token text,userId text
@interface Message : NSObject
/**
 *  消息id
 */
@property (nonatomic,strong) NSString *messageId;
/**
 *  消息类型1、文本消息；2、html消息
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
 *  房间名//用户昵称
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
 *  聊天用户类型：3--为官方账号
 */
@property (nonatomic,strong) NSString *targetUserType;




@end
