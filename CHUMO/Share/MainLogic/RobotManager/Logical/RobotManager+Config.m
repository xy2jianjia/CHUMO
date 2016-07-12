//
//  RobotManager+Config.m
//  RobotMechanism
//
//  Created by xy2 on 16/5/3.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "RobotManager+Config.h"

@implementation RobotManager (Config)


- (NSInteger )randomIndexWithMaxNumber:(NSInteger )max min:(NSInteger )min{
    
    NSInteger index = (arc4random() % (max-min+1))+min;
    return index;
    
}

//- (void)configTimerWithType:(NSString *)type lastMessage:(DHMessageModel *)lastMessage{
//    // 配置登录后随机事件
//    float timerInterval = [self randomIndexWithMaxNumber:2 min:1] + 0.1;
//    NSInteger random1 = [self randomIndexWithMaxNumber:10 min:1];
//    NSInteger random2 = [self randomIndexWithMaxNumber:10 min:1];
//    NSInteger random3 = [self randomIndexWithMaxNumber:10 min:1];
//    NSDictionary *userinfo = nil;
//    if (lastMessage) {
//        userinfo = [NSDictionary dictionaryWithObjectsAndKeys:type,@"type",[NSNumber numberWithInteger:random1],@"random",lastMessage,@"lastMessage", nil];
//    }else{
//        userinfo = [NSDictionary dictionaryWithObjectsAndKeys:type,@"type",[NSNumber numberWithInteger:random1],@"random",nil];
//    }
//        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: timerInterval*5 target:self selector:@selector(configTimerWithRandomTimeInterval:) userInfo:userinfo repeats:YES];
//        [timer fire];
//}
//- (void)configTimerWithRandomTimeInterval:(NSTimer *)timer{
//    NSInteger timeInterval = [[timer.userInfo objectForKey:@"random"] integerValue];
//    NSString *type = [timer.userInfo objectForKey:@"type"];
//    DHMessageModel *lastMessage = [timer.userInfo objectForKey:@"lastMessage"];
//    // 等待timeInterval分钟后才发送消息
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval *5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        __weak RobotManager *weakManager = self;
//        NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"27c477b86144e8c6c04db807b5304927",@"p1",@"104134401",@"p2",@"1",@"a78", nil];
//        [UserHttpDao asyncGetUserInfoWithPara:para completed:^(NSDictionary *userInfo, DHUserInfoModel *userInfoModel) {
//            [weakManager getRobotListWithPara:nil completed:^(NSArray *array) {
//                [weakManager getRobotMessageWithPara:para completed:^(NSArray *array) {
//                    // 第一次发消息，targetId为空
//                    [weakManager sendMessageWithCurrentUserInfo:userInfoModel targetId:lastMessage.targetId nextType:type];
//                }];
//            }];
//        }];
//        
//    });
//}
@end
