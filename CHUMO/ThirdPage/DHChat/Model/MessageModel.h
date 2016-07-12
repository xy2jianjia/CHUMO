//
//  MessageModel.h
//  微信
//
//  Created by Think_lion on 15/6/20.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic,copy) NSString *body; //消息的内容
@property (nonatomic, copy) NSAttributedString *attributedBody;

@property (nonatomic,copy) NSString *time ;//消息的时间
@property (nonatomic,assign) BOOL isCurrentUser;  //如果是YES就是当前用户  如果是NO就是聊天的用户
@property (nonatomic,copy) NSString *from; //谁发的消息
@property (nonatomic,copy) NSString *to ;//发给谁的消息
/**
 *  对方头像imageV
 */
//@property (nonatomic,strong) UIImageView *targetHeaderImageV;
////用户自己的头像
//@property (nonatomic,strong) UIImageView *headImageV;
/**
 *  对方头像url
 */
@property (nonatomic,strong) NSString *targetHeaderUrl;
/**
 *  自己头像url
 */
@property (nonatomic,strong) NSString *headerUrl;
//是否隐藏时间
@property (nonatomic,assign) BOOL hiddenTime;

@property (nonatomic,strong) NSString *messageId;
/**
 *  消息类型，1、文本类型；2、HTML类型 3、图片、4、语音 5、VIP,6写信，7、视频
 */
@property (nonatomic,strong) NSString *messageType;
/**
 *  聊天用户类型：3--官方账号
 */
@property (nonatomic,strong) NSString *targetUserType;
/**
 *  聊天目标用户
 */
@property (nonatomic,strong) NSString *targetId;
/**
 *  文件路径，
 */
@property (nonatomic,strong) NSString *fileUrl;
/**
 *  聊天图片
 */
@property (nonatomic,strong) NSString *chatImageUrl;
/**
 *  已经缓存过的图片
 */
@property (nonatomic,strong) UIImage *localChatImage;
/**
 *  音频的时间长度
 */
@property (nonatomic,assign) double audioDuration;
/**
 *  文件类型.mp3.amr.wav...
 */
@property (nonatomic,strong) NSString *fileType;
@end
