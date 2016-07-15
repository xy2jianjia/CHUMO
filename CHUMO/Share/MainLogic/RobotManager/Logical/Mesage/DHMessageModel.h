//
//  DHMessageModel.h
//  DHRequestServer
//
//  Created by xy2 on 16/3/2.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHMessageModel : NSObject
/**
 *  消息id
 */
@property (nonatomic,strong) NSString *messageId;
/**
 *  消息类型，1、文本类型；2、HTML类型 3、图片、4、语音 5、VIP,6写信，7、视频 ,8、地理位置 9、文件 10、穿透
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
#pragma  mark 2016年05月13日16:06:11 加入 --by大海 socket数据
/**
 *  文件的url
 */
@property (nonatomic,strong) NSString *fileUrl;
@property (nonatomic,assign) long length;
@property (nonatomic,strong) NSString *fileName;
@property (nonatomic,strong) NSString *addr;
@property (nonatomic,assign) double lat;
@property (nonatomic,assign) double lng;
/**
 *  5001: 图片  5002: 视频5003:音频  5004:文件 1001:文本，1002：地理位置 6001：穿透
 */
@property (nonatomic,assign) NSInteger socketType;
/**
 *  文件时长（针对音频和视频文件）
 */
@property (nonatomic,assign) CGFloat fileDuration;
/**
 *  朋友关系1：普通，2：免费
 */
@property (nonatomic,assign) NSInteger friendType;

@end
