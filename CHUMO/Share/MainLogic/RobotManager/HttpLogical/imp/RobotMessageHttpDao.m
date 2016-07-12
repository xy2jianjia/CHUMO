//
//  RobotMessageHttpDao.m
//  RobotMechanism
//
//  Created by xy2 on 16/4/27.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "RobotMessageHttpDao.h"
#import "RobotMessageModel.h"
#import "DHRobotMessageDao.h"
@implementation RobotMessageHttpDao
+ (void)asyncGetMessagesWithPara:(NSDictionary *)para completed:(void(^)(NSArray *array))completed{
    [[[RobotMessageHttpDao alloc]init]asyncGetMessagesWithPara:para completed:completed];
}
- (void)asyncGetMessagesWithPara:(NSDictionary *)para completed:(void(^)(NSArray *array))completed{
    AFHTTPRequestOperationManager *manger = [self configOperation];
    NSString *api = [NSString stringWithFormat:@"%@f_117_11_1.service",[HZApi BUS_API]];
    [manger GET:api parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [self asyncparseJSONDataToNSDictionary:responseObject];
        NSArray *temp = [dict objectForKey:@"body"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *d in temp) {
            RobotMessageModel *item = [[RobotMessageModel alloc]init];
            [item setValuesForKeysWithDictionary:d];
            [arr addObject:item];
            if (![DHRobotMessageDao checkRobotMessageWithUsertId:[para objectForKey:@"p2"] messageId:item.b34]) {
                [DHRobotMessageDao insertRobotMessageToDBWithItem:item userId:[para objectForKey:@"p2"]];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(arr);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
+ (void)asyncGetMessagesOfMySelfWithPara:(NSDictionary *)para completed:(void(^)(NSArray *array))completed{
    [[[RobotMessageHttpDao alloc]init]asyncGetMessagesOfMySelfWithPara:para completed:completed];
}
- (void)asyncGetMessagesOfMySelfWithPara:(NSDictionary *)para completed:(void(^)(NSArray *array))completed{
    AFHTTPRequestOperationManager *manger = [self configOperation];
    NSString *api = [NSString stringWithFormat:@"%@f_117_13_1.service",[HZApi BUS_API]];
    [manger GET:api parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [self asyncparseJSONDataToNSDictionary:responseObject];
        NSArray *temp = [dict objectForKey:@"body"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *d in temp) {
            RobotMessageModel *item = [[RobotMessageModel alloc]init];
            [item setValuesForKeysWithDictionary:d];
            [arr addObject:item];
            if (![DHRobotMessageDao checkRobotMessageWithUsertId:[para objectForKey:@"p2"] messageId:item.b34]) {
                [DHRobotMessageDao insertRobotMessageToDBWithItem:item userId:[para objectForKey:@"p2"]];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(arr);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
@end
