//
//  DHGetRobotManager.m
//  DHRequestServer
//
//  Created by xy2 on 16/2/29.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHGetRobotManager.h"

@implementation DHGetRobotManager
/**
 *  获取机器人
 *
 *  @param api        api
 *  @param parameters 请求参数
 *  @param compelted
 *  @param falure
 */
+ (void)asyncLoadRobotsWithApi:(NSString *)api  parameters:(NSDictionary *)parameters compeleted:(void(^)(NSArray *robots ,  NSInteger code))compeleted falure:(void(^)(NSString *msg))falure{
    [DHHttpBusServer asyncRobotListWithApi:api parameters:parameters method:DHRequestMethodTypeGet server:DHRequestServerTypeBus success:^(id result, NSInteger code) {
        compeleted([result objectForKey:@"body"],code);
    } falureMsg:^(NSString *msg) {
        if (msg) {
            falure(msg);
        }
        
    } falure:^(NSDictionary *userInfo) {
        
    }];
}





@end
