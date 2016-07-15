//
//  SocketManager.h
//  StrangerChat
//
//  Created by long on 15/11/23.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Message.h"
//typedef void (^ablock)(Message *model);
#import "DHMessageModel.h"
@interface SocketManager : NSObject <GCDAsyncSocketDelegate>

+(instancetype) shareInstance;
//@property (nonatomic, strong) ablock block;// 回调用的
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) GCDAsyncSocket *client;
@property (nonatomic,strong) NSMutableArray *friendArr;
/**
 *  退出im
 */
+ (void)asyncLogout;
+ (void)ClientConnectServer;
/**
 *  发送消息 2016年05月04日11:57:58 --by大海
 *
 *  @param message
 */
+ (void)asyncSendMessageWithMessageModel:(DHMessageModel *)message;
/**
 *  上传图片
 *
 *  @param imageList
 *  @param completed 
 */
+ (void)asyncUploadImageWithImageList:(NSArray *)imageList completed:(void(^)(NSString *imageUrl ,long dataLength,NSString *fileName))completed;
/**
 *  上传音频
 *
 *  @param audioData
 *  @param completed 
 */
+ (void)asyncUploadAudioWithFileData:(NSData *)audioData completed:(void(^)(NSString *audioUrl ,long dataLength,NSString *fileName))completed;
@end
