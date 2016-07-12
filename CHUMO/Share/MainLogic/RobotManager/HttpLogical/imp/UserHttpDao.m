//
//  UserHttpDap.m
//  RobotMechanism
//
//  Created by xy2 on 16/4/27.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "UserHttpDao.h"
#import "DHUserInfoModel.h"
#import "DHUserInfoDao.h"
@implementation UserHttpDao


+ (void)asyncGetUserInfoWithPara:(NSDictionary *)para completed:(void(^)(NSDictionary *userInfo,DHUserInfoModel *userInfoModel))completed{
    [[[UserHttpDao alloc]init]asyncGetUserInfoWithPara:para completed:completed];
}
- (void)asyncGetUserInfoWithPara:(NSDictionary *)para completed:(void(^)(NSDictionary *userInfo,DHUserInfoModel *userInfoModel))completed{
    
    AFHTTPRequestOperationManager *manger = [self configOperation];
    NSString *api = [NSString stringWithFormat:@"%@f_108_13_1.service",[HZApi BUS_API]];
    [manger GET:api parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [self asyncparseJSONDataToNSDictionary:responseObject];
        NSDictionary *dict2 = dict[@"body"];
        DHUserInfoModel *item = [[DHUserInfoModel alloc]init];
        [item setValuesForKeysWithDictionary:[dict2 objectForKey:@"b112"]];
        [item setValuesForKeysWithDictionary:dict2];
        if (![DHUserInfoDao checkUserWithUsertId:item.b80]) {
            [DHUserInfoDao insertUserToDBWithItem:item];
        }else{
            [DHUserInfoDao updateUserToDBWithItem:item userId:item.b80];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(dict2,item);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
+ (void)asyncLoginWithPara:(NSDictionary *)para completed:(void(^)(NSDictionary *userInfo))completed{
    [[[UserHttpDao alloc]init]asyncLoginWithPara:para completed:completed];
}
- (void)asyncLoginWithPara:(NSDictionary *)para completed:(void(^)(NSDictionary *userInfo))completed{
    AFHTTPRequestOperationManager *manger = [self configOperation];
    NSString *api = [NSString stringWithFormat:@"%@f_120_10_1.service",[HZApi AUTHER_API]];
    [manger GET:api parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [self asyncparseJSONDataToNSDictionary:responseObject];
        NSDictionary *dict2 = dict[@"body"];
        completed(dict2);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
@end
