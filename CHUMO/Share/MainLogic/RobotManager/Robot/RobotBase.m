//
//  RobotBase.m
//  RobotMechanism
//
//  Created by xy2 on 16/4/9.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "RobotBase.h"

@implementation RobotBase

- (RobotBase *)shareInstance{
    static dispatch_once_t onceToken;
    static RobotBase *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[RobotBase alloc]init];
    });
    return instance;
}

- (void)asyncDownloadRobotsWithParameters:(NSDictionary *)para{
    
    
    
}


@end
