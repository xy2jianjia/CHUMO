//
//  RobotManager+SuitRobot.m
//  CHUMO
//
//  Created by xy2 on 16/6/2.
//  Copyright © 2016年 youshon. All rights reserved.
//
/** -- by dh --2016年06月03日14:41:44
 *      不论是否是注册当天，每天登录后的1分钟后，发送3-5套机器人消息，每套间隔1-3分钟
 *      对同一个用户，一天最多发送10套普通消息；最多发7天，若提前用完聊天模板，则不再发。
 *      用户总共最多能收到70套
 */

#import "RobotManager+SuitRobot.h"
#import "SuitRobotHttpDao.h"
@implementation RobotManager (SuitRobot)
- (void)configSuitRobot{
    // 登录一分钟后才进行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SuitRobotHttpDao asyncGetSuitRobotsWithType:@"1" completed:^(NSArray *messageArray) {
            self.suitRobotArr = [@[] mutableCopy];
            NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
            NSArray *hasSendIds = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_hasSendIds",userId]];
            for (SuitRobotMessageModel *msg in messageArray) {
                // 去重:如果hasSendIds这个数组存在已经发过的用户id，则不再添加入数据源
                if (![hasSendIds containsObject:msg.b27]) {
                    [self.suitRobotArr addObject:msg];
                }
            }
            self.suit_timerIndex = 0;
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 * 1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
            [timer fire];
        }];
    });
}

- (void)timerAction:(NSTimer *)timer{
    if (self.suit_timerIndex == self.suitRobotArr.count ) {
        [timer invalidate];
        self.suit_timerIndex = 0;
        NSLog(@"%s配套机器人已经停止00",__func__);
        return;
    }
    self.suit_timerIndex ++;
    if (self.suitRobotArr.count == 0) {
        [timer invalidate];
        NSLog(@"%s配套机器人已经停止33",__func__);
        return;
    }
    //保存
     __block SuitRobotMessageModel *randomMessage = nil;
    __block NSArray *arrayPre=nil;
//    if (self.suitRobotArr.count > 0) {
//        
//        
//        randomMessage = [self.suitRobotArr firstObject];
//        
////        NSInteger random_index = [self randomIndexWithMaxNumber:self.suitRobotArr.count - 1  min:0];
////        
////        if (random_index <= self.suitRobotArr.count - 1) {
////            randomMessage = [self.suitRobotArr objectAtIndex:random_index];
////            //这个用户已经有一条正在发送的信息了,去发送其他用户
////            NSInteger numRobot = self.suitRobotArr.count-1;
////            while (randomMessage.isSending) {
////                random_index = [self randomIndexWithMaxNumber:self.suitRobotArr.count - 1  min:0];
////                if (random_index <= self.suitRobotArr.count - 1) {
////                    randomMessage = [self.suitRobotArr objectAtIndex:random_index];
////                    numRobot--;
////                }
////                if (numRobot<=0) {
////                    return;
////                }
////                
////            }
////            
////            NSPredicate *preTemplate = [NSPredicate predicateWithFormat:@"b27==$NAME"];
////            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
////                               randomMessage.b27, @"NAME",nil];
////            NSPredicate *pre=[preTemplate predicateWithSubstitutionVariables: dic];
////            
////            arrayPre=[self.suitRobotArr filteredArrayUsingPredicate: pre];
////            //设置成正在发送的用户
////            
////            for (SuitRobotMessageModel *model in arrayPre) {
////                model.isSending=YES;
////            }
////            
////            //给个正在发送中的状态
////            randomMessage=arrayPre[0];
////        }
//        
//    }
//    NSInteger randomTimerDural1 = (20 + self.suit_timerIndex*[self randomIndexWithMaxNumber:10 min:5]);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(randomTimerDural1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger randomTimerDural = [self randomIndexWithMaxNumber:self.suitRobotArr.count*60 min:60*1];
        NSLog(@"%s%ld",__func__,randomTimerDural);
        // 1~3分钟回复第二条
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(randomTimerDural * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (nil==[[NSUserDefaults standardUserDefaults] objectForKey:@"XXAccount"]){
                if (self.suitRobotArr.count == 0) {
                    [timer invalidate];
                    NSLog(@"%s配套机器人已经停止11",__func__);
                    return;
                }
                __weak RobotManager *weakSelf = self;
                
                if (self.suitRobotArr.count > 0) {
                    randomMessage = [self.suitRobotArr firstObject];
                    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
                    DHUserInfoModel *currentUserInfo = [self suit_getCurrentUserInfoWithUserId:userId];
                    
                    if ([DHUserInfoDao checkUserWithUsertId:randomMessage.b27]) {
                        DHUserInfoModel *userInfoModel =[DHUserInfoDao getUserWithCurrentUserId:randomMessage.b27];
                        //发送消息
                        [self suit_sendMessageWithCurrentUserInfo:currentUserInfo targetRobot:userInfoModel nextMessage:randomMessage completed:^(DHMessageModel *lastMessage) {
                            if (lastMessage) {
                                NSArray *arr1 = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_hasSendIds",userId]];
                                NSMutableArray *arr = nil;
                                if (arr1) {
                                    arr = [NSMutableArray arrayWithArray:arr1];
                                }else{
                                    arr = [NSMutableArray array];
                                }
                                if (![arr containsObject:randomMessage.b27]) {
                                    [arr addObject:randomMessage.b27];
                                    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:[NSString stringWithFormat:@"%@_hasSendIds",userId]];
                                }
                                //获取发送完的用户
                                
                                for (SuitRobotMessageModel *model in arrayPre) {
                                    model.isSending=NO;
                                }
                                
                                
                                [self.suitRobotArr removeObject:randomMessage];
                                if (self.suitRobotArr.count == 0) {
                                    [timer invalidate];
                                    NSLog(@"%s配套机器人已经停止22",__func__);
                                }
                            }
                        }];
                    }else{
                        [self.suitRobotArr removeObject:randomMessage];
                        if (self.suitRobotArr.count == 0) {
                            [timer invalidate];
                            NSLog(@"%s配套机器人已经停止44",__func__);
                        }
                    }
                    
                }
            }else{
                [timer invalidate];
                NSLog(@"%s配套机器人已经停止55",__func__);
                return;
            }
        });
//    });
}
#pragma mark 配置信息完毕，发送消息
// 发消息
- (void)suit_sendMessageWithCurrentUserInfo:(DHUserInfoModel *)userInfo targetRobot:(DHUserInfoModel *)targetRobot nextMessage:(SuitRobotMessageModel *)nextMessage completed:(void(^)(DHMessageModel *lastMessage))completed{
    DHUserInfoModel *robot = targetRobot;
    if (robot) {
        SuitRobotMessageModel *robotMessage = nextMessage;
        // 构建消息
        DHMessageModel *message = [self suit_configMessageWithCurrentUserInfo:userInfo robot:robot robotMessage:robotMessage];
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
- (DHMessageModel *)suit_configMessageWithCurrentUserInfo:(DHUserInfoModel *)userInfo robot:(DHUserInfoModel *)targetRobot robotMessage:(SuitRobotMessageModel *)robotMessage{
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    
    DHUserInfoModel *currentUserInfo = [self suit_getCurrentUserInfoWithUserId:userId];
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
- (DHUserInfoModel *)suit_getCurrentUserInfoWithUserId:(NSString *)userId{
    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
    if (userInfo) {
        return userInfo;
    }else{
        return nil;
    }
}
@end
