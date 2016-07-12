//
//  SuitRobotHttpDao.h
//  CHUMO
//
//  Created by xy2 on 16/6/2.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "RobotHttpOperation.h"

@interface SuitRobotHttpDao : RobotHttpOperation
/**
 *  获取配套机器人消息
 *
 *  @param type      1：普通  2：诱惑
 *  @param completed 
 */
+ (void)asyncGetSuitRobotsWithType:(NSString *)type completed:(void(^)(NSArray *array))completed;
@end
