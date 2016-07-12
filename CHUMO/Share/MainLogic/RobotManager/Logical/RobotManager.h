//
//  RobotManager.h
//  RobotMechanism
//
//  Created by xy2 on 16/4/27.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DHUserInfoModel.h"
#import "DHUserInfoDao.h"
#import "DHRobotMessageDao.h"
#import "RobotMessageModel.h"
#import "DHMessageModel.h"
#import "DHMessageDao.h"
#import "UserHttpDao.h"
#import "RobotHttpDao.h"
#import "RobotMessageHttpDao.h"


static NSString * const NEW_DID_RECEIVE_MESSAGE_NOTIFICATION = @"NEW_DID_RECEIVE_MESSAGE_NOTIFICATION";
static NSString * const NEW_DID_REPLY_MESSAGE_NOTIFICATION = @"NEW_DID_REPLY_MESSAGE_NOTIFICATION";
@class RobotManager;
@protocol RobotManagerDelegate <NSObject>
/**
 *  接收到机器人消息，用代理回调
 *
 *  @param object 
 */
- (void)didReceiveRobotMessageCallBacked:(id)object;

@end

@interface RobotManager : NSObject
/**
 *  记录配套消息循环的下标
 */
@property (nonatomic,assign) NSInteger suit_timerIndex;
@property (weak,nonatomic)id <RobotManagerDelegate>delegate;

/**
 *  机器人入口
 *
 *  @param delegate 代理
 */
+ (void)startupRobotManagerWithDelegate:(id <RobotManagerDelegate>)delegate;

/**
 *  配套机器人消息数组
 */
@property (atomic,strong) NSMutableArray *suitRobotArr;
/**
 *  诱惑配套机器人消息数组
 */
@property (nonatomic,strong) NSMutableArray *temptationSuitRobotArr;
@end
