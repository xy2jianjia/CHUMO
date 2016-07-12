//
//  SuitRobotMessageModel.h
//  CHUMO
//
//  Created by xy2 on 16/6/2.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuitRobotMessageModel : NSObject
/**
 *  记录id
 */
@property (nonatomic,strong) NSString *b34;
/**
 *  消息类型1001：文本消息 5001：图片消息 5003：音频消息
 */
@property (nonatomic,strong) NSString *b78;
/**
 *  消息内容
 */
@property (nonatomic,strong) NSString *b14;
/**
 *  userid
 */
@property (nonatomic,strong) NSString *b27;
/**
 *  语音时长
 */
@property (nonatomic,strong) NSString *b187;
/**
 *  图片或语音的链接地址
 */
@property (nonatomic,strong) NSString *b18;
//发送过得消息
@property (nonatomic,assign) BOOL isSending;
//该用户有正在发送消息
@property (nonatomic,assign) BOOL haveMassaging;
@end
