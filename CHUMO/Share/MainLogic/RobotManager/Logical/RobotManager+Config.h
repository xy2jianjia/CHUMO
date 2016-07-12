//
//  RobotManager+Config.h
//  RobotMechanism
//
//  Created by xy2 on 16/5/3.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "RobotManager.h"

@interface RobotManager (Config)

/**
 *  配置随机数
 *
 *  @param max 最大值
 *  @param min 最小值
 *
 *  @return 
 */
- (NSInteger )randomIndexWithMaxNumber:(NSInteger )max min:(NSInteger )min;

//- (void)configTimerWithType:(NSString *)type lastMessage:(DHMessageModel *)lastMessage;

@end
