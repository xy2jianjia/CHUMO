//
//  SuitRobotHttpDao.m
//  CHUMO
//
//  Created by xy2 on 16/6/2.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "SuitRobotHttpDao.h"
#import "SuitRobotMessageModel.h"
@implementation SuitRobotHttpDao

+ (void)asyncGetSuitRobotsWithType:(NSString *)type completed:(void(^)(NSArray *array))completed{
    [[[SuitRobotHttpDao alloc]init]asyncGetSuitRobotsWithType:type completed:completed];
}
- (void)asyncGetSuitRobotsWithType:(NSString *)type completed:(void(^)(NSArray *array))completed{
    AFHTTPRequestOperationManager *manger = [self configOperation];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *sessionId = [NSGetTools getUserSessionId];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:type forKey:@"a78"];
    [dict setObject:userId forKey:@"p2"];
    [dict setObject:sessionId forKey:@"p1"];
    NSString *api = [NSString stringWithFormat:@"%@f_136_10_1.service",[HZApi BUS_API]];
    [manger GET:api parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [self asyncparseJSONDataToNSDictionary:responseObject];
        NSArray *temp = [dict objectForKey:@"body"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dict1 in temp) {
            NSMutableDictionary *d = [NSMutableDictionary dictionary];
            NSMutableArray *tempArr = [NSMutableArray array];
            //保存用户诱惑消息
            for (NSDictionary *msg in [dict1 objectForKey:@"b186"]) {
                SuitRobotMessageModel *item = [[SuitRobotMessageModel alloc]init];
                [item setValuesForKeysWithDictionary:msg];
                item.b27 = [dict1 objectForKey:@"b27"];
                item.isSending=NO;
//                [arr addObject:item];
                [tempArr addObject:item];
//                [arr insertObject:item atIndex:0];
            }
            [d setObject:tempArr forKey:[NSString stringWithFormat:@"%@",[dict1 objectForKey:@"b27"]]];
            [arr addObject:d];
            //请求用户信息
            // 获取机器人信息
            NSString *sessionId = [NSGetTools getUserSessionId];
            NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:sessionId,@"p1",[dict1 objectForKey:@"b27"],@"p2",nil];
            [UserHttpDao asyncGetUserInfoWithPara:para completed:^(NSDictionary *userInfo, DHUserInfoModel *userInfoModel) {
                
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(arr);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
