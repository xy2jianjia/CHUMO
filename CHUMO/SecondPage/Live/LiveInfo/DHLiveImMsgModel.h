//
//  DHLiveImMsgModel.h
//  CHUMO
//
//  Created by xy2 on 16/7/13.
//  Copyright © 2016年 youshon. All rights reserved.
//
/**
 *  直播聊天室model --by大海 2016年07月13日15:39:43
 *
 *  @param nonatomic
 *  @param strong
 *
 *  @return
 */
#import <Foundation/Foundation.h>

@interface DHLiveImMsgModel : NSObject

/**
 *  消息发送时间
 */
@property (nonatomic,strong) NSString *time;
/**
 *  用户头像
 */
@property (nonatomic,strong) NSString *fromAvator;
/**
 *  消息id
 */
@property (nonatomic,strong) NSString *msgid_client;
/**
 *  客户端类型
 */
@property (nonatomic,strong) NSString *fromClientType;
/**
 *  消息内容
 */
@property (nonatomic,strong) NSString *attach;
/**
 *  房间id
 */
@property (nonatomic,strong) NSString *roomId;
/**
 *  用户名称
 */
@property (nonatomic,strong) NSString *fromAccount;
/**
 *  用户昵称
 */
@property (nonatomic,strong) NSString *fromNick;
/**
 *  消息类型
 */
@property (nonatomic,strong) NSString *type;

@end
