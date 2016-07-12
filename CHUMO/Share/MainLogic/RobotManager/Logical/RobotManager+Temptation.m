//
//  RobotManager+Temptation.m
//  CHUMO
//
//  Created by xy2 on 16/5/21.
//  Copyright © 2016年 youshon. All rights reserved.
//
/**
 *  诱惑型消息机制
 *
 *  @param Temptation
 *
 *  @return
 ¬	用户注册当天，注册后的1-5分钟内，发送1个诱惑机器人
 ¬	非注册当天，若用户在21-24点登录，发送1个诱惑机器人
 ¬	一天发送1条，共发送3条诱惑消息
 ¬	一个机器人只能向同一个用户发1条诱惑消息
 ¬	向用户发诱惑消息的机器人，发完诱惑消息后，不再回应用户
 
 */
#import "RobotManager+Temptation.h"

@implementation RobotManager (Temptation)


- (void)temptation_configMessage{
    
    NSInteger timeInterval = [self randomIndexWithMaxNumber:5 min:1];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * 60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [self temptation_pubWithType:@"7" completed:^(DHMessageModel *lastMessage) {
           
       }];
    });
    
}
- (void)temptation_pubWithType:(NSString *)type completed:(void(^)(DHMessageModel *lastMessage))completed{
    __weak RobotManager *weakManager = self;
    
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *sessionId = [NSGetTools getUserSessionId];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:sessionId,@"p1",userId,@"p2",type,@"a78", nil];
    [UserHttpDao asyncGetUserInfoWithPara:para completed:^(NSDictionary *userInfo, DHUserInfoModel *userInfoModel) {
        [weakManager temptation_getRobotListWithPara:nil completed:^(NSArray *robotArray) {
            // 配置随机机器人，这个机器人目前随机，未加去重
            DHUserInfoModel *randomRobot = [DHUserInfoDao getUserWithCurrentUserId:nil];
            if (!randomRobot) {
                if (robotArray.count > 0) {
                    NSInteger randomIndex = [self randomIndexWithMaxNumber:robotArray.count - 1 min:0];
                    if (randomIndex <= robotArray.count - 1) {
                        randomRobot = [robotArray objectAtIndex:randomIndex];
                    }
                }
                
            }
            [weakManager temptation_getRobotMessageWithPara:para completed:^(NSArray *messageArray) {
                if (messageArray.count > 0) {
                    NSInteger random_index = [self randomIndexWithMaxNumber:messageArray.count - 1  min:0];
                    RobotMessageModel *randomMessage = nil;
                    if (random_index <= messageArray.count - 1) {
                        randomMessage = [messageArray objectAtIndex:random_index];
                    }
                    // 第一次发消息，targetId为空
                    [weakManager temptation_sendMessageWithCurrentUserInfo:userInfoModel targetRobot:randomRobot nextMessage:randomMessage completed:^(DHMessageModel *lastMessage) {
                        completed(lastMessage);
                    }];
                }
            }];
        }];
    }];
}
#pragma mark 配置信息完毕，发送消息
// 发消息
- (void)temptation_sendMessageWithCurrentUserInfo:(DHUserInfoModel *)userInfo targetRobot:(DHUserInfoModel *)targetRobot nextMessage:(RobotMessageModel *)nextMessage completed:(void(^)(DHMessageModel *lastMessage))completed{
    DHUserInfoModel *robot = targetRobot;
    if (robot) {
        RobotMessageModel *robotMessage = nextMessage;
        // 构建消息
        DHMessageModel *message = [self temptation_configMessageWithCurrentUserInfo:userInfo robot:robot robotMessage:robotMessage];
        // 发送消息
        [[NSNotificationCenter defaultCenter] postNotificationName:NEW_DID_RECEIVE_MESSAGE_NOTIFICATION object:message];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadBadgeValue" object:message];
        
        
        NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
        [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *date = [[fmt stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(0, 10)];
        NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_%@hasSended",date,userId]];
        completed(message);
    }else{
        completed(nil);
    }
    
}
#pragma mark 配置消息，将机器人与机器人消息整合成要发的消息
// 配置消息
- (DHMessageModel *)temptation_configMessageWithCurrentUserInfo:(DHUserInfoModel *)userInfo robot:(DHUserInfoModel *)targetRobot robotMessage:(RobotMessageModel *)robotMessage{
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    
    DHUserInfoModel *currentUserInfo = [self temptation_getCurrentUserInfoWithUserId:userId];
    DHMessageModel *msg = [[DHMessageModel alloc]init];
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *fmtDate = [fmt stringFromDate:dat];
    
    msg.toUserAccount = currentUserInfo.b80;
    msg.roomName = targetRobot.b52;
    msg.roomCode = currentUserInfo.b80;
    msg.message = robotMessage.b14;
    msg.fromUserDevice = @"2";// 1:安卓 2:苹果 3:windowPhone
    msg.timeStamp = fmtDate;
    msg.fromUserAccount = targetRobot.b80;
    msg.messageType = @"1";
    msg.messageId = [self configUUid];
    msg.token = targetRobot.b80;
    msg.roomCode = targetRobot.b80;
    msg.targetId = targetRobot.b80;
    msg.robotMessageType = robotMessage.b78;
    msg.userId = currentUserInfo.b80;
    msg.isRead = @"1";
    
    msg.fileUrl = @"";
    msg.length = 0;
    msg.fileName = @"";
    msg.addr = @"";
    msg.lat = 0;
    msg.lng = 0;
    msg.socketType = 1001;
    
    
    // 存储到数据库
    if ([[NSString stringWithFormat:@"%@",msg.targetId] length] > 0 && ![[NSString stringWithFormat:@"%@",msg.targetId] isEqualToString:@"(null)"] && ![DHMessageDao checkMessageWithMessageId:msg.messageId targetId:msg.targetId]) {
        [DHMessageDao insertMessageDataDBWithModel:msg userId:[NSString stringWithFormat:@"%@",currentUserInfo.b80]];
    }
    return msg;
}
#pragma mark 配置当前用户
// 获取当前用户信息
- (DHUserInfoModel *)temptation_getCurrentUserInfoWithUserId:(NSString *)userId{
    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
    if (userInfo) {
        return userInfo;
    }else{
        return nil;
    }
}
- (void)temptation_getRobotMessageWithPara:(NSDictionary *)para1 completed:(void(^)(NSArray *array))completed{
    [RobotMessageHttpDao asyncGetMessagesWithPara:para1 completed:^(NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(array);
        });
    }];
}
- (void)temptation_getRobotListWithPara:(NSDictionary *)para1 completed:(void(^)(NSArray *array))completed{
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *sessionId = [NSGetTools getUserSessionId];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:sessionId,@"p1",userId,@"p2",@"2",@"a78", nil];
    [RobotHttpDao  asyncGetRobotsWithPara:para completed:^(NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(array);
        });
    }];
}
@end
