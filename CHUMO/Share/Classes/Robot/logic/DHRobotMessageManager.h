//
//  DHRobotMessageManager.h
//  DHRequestServer
//
//  Created by xy2 on 16/2/29.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHRobotManager.h"

@interface DHRobotMessageManager : DHRobotManager
/**
 *  获取随机
 *
 *  @param api        api
 *  @param parameters 请求参数
 *  @param completed
 *  @param falure
 */
+ (void)asyncLoadRandomMessageWithApi:(NSString *)api parameters:(NSDictionary *)parameters completed:(void(^)(NSArray *messages , NSInteger code))completed falure:(void(^)(NSString *msg))falure;

@end
