//
//  DHRobotMessageManager.m
//  DHRequestServer
//
//  Created by xy2 on 16/2/29.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHRobotMessageManager.h"

@implementation DHRobotMessageManager

+ (void)asyncLoadRandomMessageWithApi:(NSString *)api parameters:(NSDictionary *)parameters completed:(void(^)(NSArray *messages , NSInteger code))completed falure:(void(^)(NSString *msg))falure{
    
    [DHHttpBusServer asyncRandomMessageListWithApi:api parameters:parameters method:DHRequestMethodTypeGet server:DHRequestServerTypeBus success:^(id result, NSInteger code) {
        completed([result objectForKey:@"body"],code);
    } falureMsg:^(NSString *msg) {
        falure(msg);
    } falure:^(NSDictionary *userInfo) {
        
    }];
}

@end
