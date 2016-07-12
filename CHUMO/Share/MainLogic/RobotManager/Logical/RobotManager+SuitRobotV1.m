//
//  RobotManager+SuitRobotV1.m
//  CHUMO
//
//  Created by xy2 on 16/6/16.
//  Copyright © 2016年 youshon. All rights reserved.
//
/** -- by dh -- 2016年06月16日17:00:09
 *      不论是否是注册当天，每天登录后的1分钟后，发送3-5个机器人的消息，每个机器人之间间隔1-3分钟，每条消息之间的间隔是1-3分钟
 *      对同一个用户，一天最多发送10套普通消息；最多发7天，若提前用完聊天模板，则不再发。
 *      用户总共最多能收到70套
 */
#import "RobotManager+SuitRobotV1.h"
#import "SuitRobotHttpDao.h"
@implementation RobotManager (SuitRobotV1)

- (NSInteger )today_suitRobothasSended{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [[fmt stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(0, 10)];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    
    NSInteger today_suitRobothasSended = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"%@_%@today_suitRobothasSended",date,userId]];
    
    return today_suitRobothasSended;
}
- (NSInteger )suitRobothasSended{
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSInteger suitRobothasSended = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"%@_suitRobotHasSended",userId]];
    return suitRobothasSended;
}

- (void)configSuitRobot{
    
    
    
    NSInteger today_suitRobothasSended = [self today_suitRobothasSended];
    if (today_suitRobothasSended < 10) {
        // 大于等于70套消息，就让停止-----注：此处为70套消息，不是70条消息，及发70个机器人的消息 --by大海 2016年06月16日20:33:45
        NSInteger suitRobothasSended = [self suitRobothasSended];
        if (suitRobothasSended >= 70) {
            return;
        }
        __weak typeof(&*self) weakSelf = self;
        // 登录一分钟后才进行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * 1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SuitRobotHttpDao asyncGetSuitRobotsWithType:@"1" completed:^(NSArray *messageArray) {
                self.suitRobotArr = [@[] mutableCopy];
                NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
                NSArray *hasSendIds = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_hasSendIds",userId]];
                for (NSDictionary *dict in messageArray) {
                    // 去重:如果hasSendIds这个数组存在已经发过的用户id，则不再添加入数据源
                    
                    //                NSString *lastId = [NSString stringWithFormat:@"%@",[[dict allKeys] firstObject]];
                    NSString *aid = [[dict allKeys] firstObject];
                    NSNumber *lastId = [NSNumber numberWithInteger:[aid integerValue]] ;
                    //                NSNumber *lastId = [NSNumber numberWithInteger:[[[dict allKeys] firstObject] integerValue]];
                    if (![hasSendIds containsObject:lastId]) {
                        [self.suitRobotArr addObject:dict];
                    }
                }
                [weakSelf startUp];
            }];
        });
    }
    
}

- (void)startUp{
    self.suit_timerIndex = 0;
    __weak typeof(&*self) weakSelf = self;
    for (int i = 0 ;i < self.suitRobotArr.count ; i ++) {
        NSDictionary *dict = self.suitRobotArr[i];
        
        NSInteger timeInterval = self.suit_timerIndex + [self randomIndexWithMaxNumber:60 * 3 min:60];
//        (i+1) * 30 + [self randomIndexWithMaxNumber:30*2 min:30];
        self.suit_timerIndex = timeInterval;
        NSLog(@"userId:%@--第%d个人--%ld",[[dict allKeys] firstObject],i,timeInterval);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf timerActionWithInfo:dict];
        });
    }
}

- (void)timerActionWithInfo:(NSDictionary *)info{
    NSString *robotuserid = [[info allKeys] lastObject];
    NSArray *messageList = [info objectForKey:robotuserid];
    
    for ( int i = 0;i < messageList.count;i ++) {
        SuitRobotMessageModel *randomMessage = messageList[i];
        NSInteger lastTimeInterval = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"%@",robotuserid]];
        NSInteger timeInterval = lastTimeInterval + [self randomIndexWithMaxNumber:60 * 3 min:60];
        [[NSUserDefaults standardUserDefaults] setInteger:timeInterval forKey:[NSString stringWithFormat:@"%@",robotuserid]];
//        (i+1)*30+[self randomIndexWithMaxNumber:30 * 2  min:30 ];
        NSLog(@"userId:%@--%d---%ld",randomMessage.b27,i,timeInterval);

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
            DHUserInfoModel *currentUserInfo = [self suit_getCurrentUserInfoWithUserId:userId];
            if ([DHUserInfoDao checkUserWithUsertId:randomMessage.b27]) {
                DHUserInfoModel *userInfoModel =[DHUserInfoDao getUserWithCurrentUserId:randomMessage.b27];
                // 及时判断已经发出去多少个人
//                NSInteger today_suitRobothasSended = [self today_suitRobothasSended];
//                if (today_suitRobothasSended < 10) {
//                    // 大于等于70套消息，就让停止-----注：此处为70套消息，不是70条消息，及发70个机器人的消息 --by大海 2016年06月16日20:33:45
//                    NSInteger suitRobothasSended = [self suitRobothasSended];
//                    if (suitRobothasSended >= 70) {
//                        return;
//                    }
//                }else{
//                    return;
//                }
                // 同性别的不让发
                if ([currentUserInfo.b69 integerValue] == [userInfoModel.b69 integerValue]) {
                    return ;
                    //                    break;
                }
                
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
                         NSNumber *lastId = (NSNumber *)randomMessage.b27;
//                        NSString *lastId = [NSString stringWithFormat:@"%@",randomMessage.b27];
//                        NSNumber *lastId = [NSNumber numberWithInteger:[randomMessage.b27 integerValue]];
                        if (![arr containsObject:lastId]) {
                            [arr addObject:lastId];
                            [[NSUserDefaults standardUserDefaults] setObject:arr forKey:[NSString stringWithFormat:@"%@_hasSendIds",userId]];
                        }
                        // 只执行一次，记录一个机器人
                        if (i == messageList.count - 1) {
                            NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
                            NSInteger suitRobothasSended = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"%@_suitRobotHasSended",userId]];
                            // 一个机器人发送完毕，记录+1
                            [[NSUserDefaults standardUserDefaults] setInteger:suitRobothasSended+1 forKey:[NSString stringWithFormat:@"%@_suitRobotHasSended",userId]];
                        }
                        [self.suitRobotArr removeObject:info];
                    }
                }];
            }else{
                [self.suitRobotArr removeObject:info];
                if (self.suitRobotArr.count == 0) {
                    
                    NSLog(@"%s配套机器人已经停止44",__func__);
                }
            }
        });
    }
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
        
        
        
        NSArray *arr1 = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@_today_hasSendIds",date,userId]];
        NSMutableArray *arr = nil;
        if (arr1) {
            arr = [NSMutableArray arrayWithArray:arr1];
        }else{
            arr = [NSMutableArray array];
        }
        NSNumber *lastId = (NSNumber *)robotMessage.b27;
        if (![arr containsObject:lastId]) {
            [arr addObject:lastId];
            [[NSUserDefaults standardUserDefaults] setObject:arr forKey:[NSString stringWithFormat:@"%@_%@_today_hasSendIds",date,userId]];
        }
        // 保存今天发了几个人的配套
        [[NSUserDefaults standardUserDefaults] setInteger:arr.count forKey:[NSString stringWithFormat:@"%@_%@today_suitRobothasSended",date,userId]];
        
        
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
