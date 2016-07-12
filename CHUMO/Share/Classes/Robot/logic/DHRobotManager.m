//
//  DHRobotManager.m
//  DHRequestServer
//
//  Created by xy2 on 16/2/25.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHRobotManager.h"

@implementation DHRobotManager


+ (DHRobotManager *)asyncGetInstance{
    static DHRobotManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DHRobotManager alloc]init];
    });
    return manager;
}

+ (void)registerNotificationWithName:(NSString *)notificationName observer:(id)observer delegate:(id <DHRobotManagerDelegate>)delegate{
    
    DHRobotManager *manager = [self asyncGetInstance];
    [manager registerNotificationWithName:notificationName observer:observer delegate:delegate];
}
- (void)registerNotificationWithName:(NSString *)notificationName observer:(id)observer delegate:(id <DHRobotManagerDelegate>)delegate{
    self.delegate = delegate;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessage:) name:notificationName object:nil];
}
- (void)didReceiveMessage:(NSNotification *)notifi{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveMessageCallBacked:)]) {
        [self.delegate didReceiveMessageCallBacked:[notifi object]];
    }
}

@end
