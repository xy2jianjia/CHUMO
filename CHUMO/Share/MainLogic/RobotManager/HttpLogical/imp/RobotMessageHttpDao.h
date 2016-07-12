//
//  RobotMessageHttpDao.h
//  RobotMechanism
//
//  Created by xy2 on 16/4/27.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "RobotHttpOperation.h"

@interface RobotMessageHttpDao : RobotHttpOperation

+ (void)asyncGetMessagesWithPara:(NSDictionary *)para completed:(void(^)(NSArray *array))completed;
+ (void)asyncGetMessagesOfMySelfWithPara:(NSDictionary *)para completed:(void(^)(NSArray *array))completed;
@end
