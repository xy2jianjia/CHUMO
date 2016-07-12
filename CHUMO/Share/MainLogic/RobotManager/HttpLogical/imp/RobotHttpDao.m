//
//  RobotHttpDao.m
//  RobotMechanism
//
//  Created by xy2 on 16/4/11.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "RobotHttpDao.h"

#import "DHUserInfoDao.h"
#import "DHUserInfoModel.h"
@implementation RobotHttpDao
+ (void)asyncGetRobotsWithPara:(NSDictionary *)para completed:(void(^)(NSArray *array))completed{
    [[[RobotHttpDao alloc]init]asyncGetRobotsWithPara:para completed:completed];
}
- (void)asyncGetRobotsWithPara:(NSDictionary *)para completed:(void(^)(NSArray *array))completed{
    AFHTTPRequestOperationManager *manger = [self configOperation];
//    NSString *api = [NSString stringWithFormat:@"%@f_108_15_1.service",[HZApi BUS_API]];
//    f_108_15_1.service
     NSString *api = [NSString stringWithFormat:@"%@f_108_15_1.service",[HZApi BUS_API]];
    [manger GET:api parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [self asyncparseJSONDataToNSDictionary:responseObject];
        NSArray *temp = [dict objectForKey:@"body"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *d in temp) {
            DHUserInfoModel *item = [[DHUserInfoModel alloc]init];
            [item setValuesForKeysWithDictionary:d];
            [arr addObject:item];
            if (![DHUserInfoDao checkUserWithUsertId:item.b80]) {
                [DHUserInfoDao insertUserToDBWithItem:item];
            }else{
                [DHUserInfoDao updateUserToDBWithItem:item userId:item.b80];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(arr);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)asyncSaveToDbWithRobot:(DHUserInfoModel *)item{
    
    
    
}

@end
