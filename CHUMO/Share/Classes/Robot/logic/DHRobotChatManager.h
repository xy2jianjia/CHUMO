//
//  DHRobotChatManager.h
//  DHRequestServer
//
//  Created by xy2 on 16/2/29.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHRobotMessageManager.h"
#import "DHRobotModel.h"
#import "DHUserInfoModel.h"
//#import "NSObject+Properties.h"
static NSString * const REPLY_MESSAGE_TO_ROBOT_NOTIFICATION   = @"REPLY_MESSAGE_TO_ROBOT_NOTIFICATION";
@interface DHRobotChatManager : DHRobotMessageManager
@property (nonatomic,strong) DHUserInfoModel *userinfo;
+ (void)asyncConfigRobotManagerWithFilter:(NSDictionary *)dict;

@end
