//
//  DHGetRobotManager.h
//  DHRequestServer
//
//  Created by xy2 on 16/2/29.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHRobotManager.h"

@interface DHGetRobotManager : DHRobotManager

/**
 *  获取机器人
 *
 *  @param api        api
 *  @param parameters 请求参数
 *  @param compelted
 *  @param falure
 */
+ (void)asyncLoadRobotsWithApi:(NSString *)api  parameters:(NSDictionary *)parameters compeleted:(void(^)(NSArray *robots ,  NSInteger code))compeleted falure:(void(^)(NSString *msg))falure;
@end
