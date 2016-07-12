//
//  RobotHttpDao.h
//  RobotMechanism
//
//  Created by xy2 on 16/4/11.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "RobotHttpOperation.h"

@interface RobotHttpDao : RobotHttpOperation
+ (void)asyncGetRobotsWithPara:(NSDictionary *)para completed:(void(^)(NSArray *array))completed;
@end
