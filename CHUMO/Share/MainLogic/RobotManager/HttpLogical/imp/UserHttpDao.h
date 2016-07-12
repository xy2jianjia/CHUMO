//
//  UserHttpDap.h
//  RobotMechanism
//
//  Created by xy2 on 16/4/27.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "RobotHttpOperation.h"
#import "DHUserInfoModel.h"
@interface UserHttpDao : RobotHttpOperation

+ (void)asyncGetUserInfoWithPara:(NSDictionary *)para completed:(void(^)(NSDictionary *userInfo,DHUserInfoModel *userInfoModel))completed;
+ (void)asyncLoginWithPara:(NSDictionary *)para completed:(void(^)(NSDictionary *userInfo))completed;
@end
