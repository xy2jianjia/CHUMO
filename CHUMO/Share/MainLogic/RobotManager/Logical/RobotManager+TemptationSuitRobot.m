//
//  RobotManager+TemptationSuitRobot.m
//  CHUMO
//
//  Created by xy2 on 16/6/3.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "RobotManager+TemptationSuitRobot.h"
#import "SuitRobotHttpDao.h"
@implementation RobotManager (TemptationSuitRobot)
- (void)temptation_configSuitRobot{
    __weak RobotManager *weakSelf = self;
    NSInteger timeInterval = [self randomIndexWithMaxNumber:5 min:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * 60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SuitRobotHttpDao asyncGetSuitRobotsWithType:@"2" completed:^(NSArray *messageArray) {
            self.temptationSuitRobotArr = [messageArray mutableCopy];
            [weakSelf temptation_config];
        }];
    });
}

- (void)temptation_config{
    
    __weak RobotManager *weakSelf = self;
    if (self.temptationSuitRobotArr.count > 0) {
        NSInteger random_index = [self randomIndexWithMaxNumber:self.temptationSuitRobotArr.count - 1  min:0];
        NSArray *messageList = nil;
        SuitRobotMessageModel *randomMessage = nil;
        if (random_index <= self.temptationSuitRobotArr.count - 1) {
            messageList = [[self.temptationSuitRobotArr objectAtIndex:random_index] objectForKey:[[[self.temptationSuitRobotArr objectAtIndex:random_index] allKeys] lastObject]];
        }
        NSInteger random = [self randomIndexWithMaxNumber:messageList.count - 1 min:0];
        if (random < 0) {
            random = 0;
        }else if (random >= messageList.count){
            random = messageList.count - 1;
        }
        randomMessage = [messageList objectAtIndex:random];
//        NSPredicate *preTemplate = [NSPredicate predicateWithFormat:@"b27==$NAME"];
//        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
//                           randomMessage.b27, @"NAME",nil];
//        NSPredicate *pre=[preTemplate predicateWithSubstitutionVariables: dic];
//        
//        NSArray  *arrayPre=[self.temptationSuitRobotArr filteredArrayUsingPredicate: pre];
        NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
        DHUserInfoModel *currentUserInfo = [self temptation_suit_getCurrentUserInfoWithUserId:userId];
        // 获取机器人信息
        NSString *sessionId = [NSGetTools getUserSessionId];
        NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:sessionId,@"p1",randomMessage.b27,@"p2",nil];
        
        [UserHttpDao asyncGetUserInfoWithPara:para completed:^(NSDictionary *userInfo, DHUserInfoModel *userInfoModel) {
            NSInteger totleTime=0;
//            SuitRobotMessageModel *mesModel=arrayPre[i];
            // 1~3分钟回复第二条
            
            NSInteger randomTimerDural = [self randomIndexWithMaxNumber:2 min:0];
            
            totleTime=totleTime+(randomTimerDural+1);
            NSInteger timetotle=totleTime;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((timetotle + 1) * 60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakSelf temptation_suit_sendMessageWithCurrentUserInfo:currentUserInfo targetRobot:userInfoModel nextMessage:randomMessage completed:^(DHMessageModel *lastMessage) {
                    if (lastMessage) {
                        [self.temptationSuitRobotArr removeObject:randomMessage];
                        if (self.temptationSuitRobotArr.count == 0) {
                            
                        }
                    }
                }];
                
            });
//            for (int i=0; i<arrayPre.count; i++) {
//                
//                
//                
//                
//                
//                
//            }
            
        }];
        
        
        
    }
    
}
#pragma mark 配置信息完毕，发送消息
// 发消息
- (void)temptation_suit_sendMessageWithCurrentUserInfo:(DHUserInfoModel *)userInfo targetRobot:(DHUserInfoModel *)targetRobot nextMessage:(SuitRobotMessageModel *)nextMessage completed:(void(^)(DHMessageModel *lastMessage))completed{
    DHUserInfoModel *robot = targetRobot;
    if (robot) {
        SuitRobotMessageModel *robotMessage = nextMessage;
        // 构建消息
        DHMessageModel *message = [self temptation_suit_configMessageWithCurrentUserInfo:userInfo robot:robot robotMessage:robotMessage];
        // 发送消息
        [[NSNotificationCenter defaultCenter] postNotificationName:NEW_DID_RECEIVE_MESSAGE_NOTIFICATION object:message];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadBadgeValue" object:message];
        
        
        NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
        [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *date = [[fmt stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(0, 10)];
        NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_%@suit_hasSended",date,userId]];
        completed(message);
    }else{
        completed(nil);
    }
    
}
#pragma mark 配置消息，将机器人与机器人消息整合成要发的消息
// 配置消息
- (DHMessageModel *)temptation_suit_configMessageWithCurrentUserInfo:(DHUserInfoModel *)userInfo robot:(DHUserInfoModel *)targetRobot robotMessage:(SuitRobotMessageModel *)robotMessage{
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    
    DHUserInfoModel *currentUserInfo = [self temptation_suit_getCurrentUserInfoWithUserId:userId];
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
    
    msg.messageId = [self configUUid];
    msg.token = targetRobot.b80;
    msg.roomCode = targetRobot.b80;
    msg.targetId = targetRobot.b80;
    msg.robotMessageType = robotMessage.b78;
    msg.userId = currentUserInfo.b80;
    msg.isRead = @"1";
    
    msg.fileUrl = robotMessage.b18;
    msg.length = 0;
    msg.fileName = @"";
    msg.addr = @"";
    msg.lat = 0;
    msg.lng = 0;
    msg.socketType = [robotMessage.b78 integerValue];
    if (msg.socketType == 1001) {
        msg.messageType = @"1";
    }else if (msg.socketType == 5001){
        msg.messageType = @"3";
    }else if (msg.socketType == 5002){
        msg.messageType = @"7";
    }else if (msg.socketType == 5003){
        msg.messageType = @"4";
        AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:[NSURL URLWithString:msg.fileUrl] options:nil];
        CMTime audioDuration = audioAsset.duration;
        float audioDurationSeconds =CMTimeGetSeconds(audioDuration);
        msg.fileDuration = audioDurationSeconds;
    }else if (msg.socketType == 5004){
        msg.messageType = @"9";
    }else if (msg.socketType == 1002){
        msg.messageType = @"8";
    }else if (msg.socketType == 6001){
        msg.messageType = @"10";
    }
    // 存储到数据库
    if ([[NSString stringWithFormat:@"%@",msg.targetId] length] > 0 && ![[NSString stringWithFormat:@"%@",msg.targetId] isEqualToString:@"(null)"] && ![DHMessageDao checkMessageWithMessageId:msg.messageId targetId:msg.targetId]) {
        [DHMessageDao insertMessageDataDBWithModel:msg userId:[NSString stringWithFormat:@"%@",currentUserInfo.b80]];
    }
    return msg;
}
#pragma mark 配置当前用户
// 获取当前用户信息
- (DHUserInfoModel *)temptation_suit_getCurrentUserInfoWithUserId:(NSString *)userId{
    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
    if (userInfo) {
        return userInfo;
    }else{
        return nil;
    }
}



@end
