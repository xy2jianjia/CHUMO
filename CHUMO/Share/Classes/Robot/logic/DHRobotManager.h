//
//  DHRobotManager.h
//  DHRequestServer
//
//  Created by xy2 on 16/2/25.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHHttpBusServer.h"
#import "DHDateFormatManager.h"
@class DHRobotManagerDelegate;
@protocol DHRobotManagerDelegate <NSObject>

- (void)didReceiveMessageCallBacked:(id)object;

@end

static  NSString *const DID_RECEIVE_MESSAGE_NOTIFICATION = @"DID_RECEIVE_MESSAGE_NOTIFICATION";

@interface DHRobotManager : NSObject

@property (nonatomic,weak) id<DHRobotManagerDelegate> delegate;

/**
 *  获取机器人组件实体
 *
 *  @return
 */
+ (DHRobotManager *)asyncGetInstance;

+ (void)registerNotificationWithName:(NSString *)notificationName observer:(id)observer delegate:(id <DHRobotManagerDelegate>)delegate;

@end
