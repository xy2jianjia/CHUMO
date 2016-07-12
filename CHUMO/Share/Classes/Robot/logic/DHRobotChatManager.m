//
//  DHRobotChatManager.m
//  DHRequestServer
//
//  Created by xy2 on 16/2/29.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHRobotChatManager.h"
//#import "DHRobotTableDao.h"
//#import "DHUserTableDao.h"
#import "DHRandomMessageModel.h"
#import "DHMessageModel.h"
//#import "DHChatMessageDao.h"
#import "DHGetRobotManager.h"
//#import "DHRandomMessageDao.h"
#import "DBManager.h"
#import "DHMsgPlaySound.h"
#import "DHMessageDao.h"
#import "DHUserInfoDao.h"
#import "DHRandomMessageDao.h"
@implementation DHRobotChatManager

+ (void)asyncConfigRobotManagerWithFilter:(NSDictionary *)dict{
    static DHRobotChatManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DHRobotChatManager alloc]init];
//        __weak DHRobotChatManager *weakManager = manager;
        NSString *userId = [dict objectForKey:@"p2"];
        [manager asyncLoadRobotsAtBackGroundWithFilter:dict];
        [manager asyncLoadRandomMessageAtBackGroundWithFilter:dict];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [manager asyncGetCurrentUserInfoWithUserId:userId completed:^(DHUserInfoModel *userInfo, NSString *sql) {
                    [manager pushfirstNotificationWithUserInfo:userInfo currentUserId:userId];
                }];
            });
        });
    });
}
- (void)asyncLoadRobotsAtBackGroundWithFilter:(NSDictionary *)dict{
    NSString *api = @"f_108_15_1.service";
    NSString *userId = [dict objectForKey:@"p2"];
    [DHActionServer asyncQueryWithMethodType:DHRequestMethodTypeGet domain:DHRequestServerTypeBus function:api parameters:dict completed:^(id result, NSInteger resultCode) {
        for ( NSDictionary *robot in [result objectForKey:@"body"]) {
            DHUserInfoModel *item = [DHUserInfoModel new];
            [item setValuesForKeysWithDictionary:robot];
            if (![DHUserInfoDao checkUserWithUsertId:item.b80]) {
                [DHUserInfoDao insertUserToDBWithItem:item];
            }else{
                [DHUserInfoDao updateUserToDBWithItem:item userId:item.b80];
            }
        }
    }];
}
- (void)asyncLoadRandomMessageAtBackGroundWithFilter:(NSDictionary *)dict{
    [DHActionServer asyncQueryWithMethodType:DHRequestMethodTypeGet domain:DHRequestServerTypeBus function:@"f_117_10_1.service" parameters:dict completed:^(id result, NSInteger resultCode) {
        NSString *userId = [dict objectForKey:@"p2"];
        for (NSDictionary *dict1 in [result objectForKey:@"body"]) {
            DHRandomMessageModel *item = [[DHRandomMessageModel alloc]init];
            [item setValuesForKeysWithDictionary:dict1];
            if (![DHRandomMessageDao checkRandomMessageWithUsertId:userId messageId:item.b34]) {
                [DHRandomMessageDao insertRandomMessageToDBWithItem:item userId:userId];
            }
//            [DHRandomMessageDao asyncExecuteSaveMessageInfoToDataBaseWithItem:item currentUserId:userId];
        }
    }];
}

/**
 *  发送第一条消息
 */
- (void)pushfirstNotificationWithUserInfo:(DHUserInfoModel *)item currentUserId:(NSString *)userId{
    self.userinfo = item;
    NSTimeInterval waitTime = 60;
    NSTimeInterval fireTime1 = arc4random() % (300-60 + 1) + 60;
    NSTimeInterval fireTime2 = arc4random() % (300-60 + 1) + 60;
    NSTimeInterval fireTime3 = arc4random() % (300-60 + 1) + 60;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replyMessageToRobot:) name:REPLY_MESSAGE_TO_ROBOT_NOTIFICATION object:nil];
    NSString *date = [[DHDateFormatManager asyncStringFromDate:[NSDate date]] substringToIndex:10];
    BOOL istodaysended = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@-%@",date,userId]];
    NSInteger randomIndex = (arc4random() % 2)+1;
    //    istodaysended = NO;
    if (!istodaysended) {
        //        if ([item.b144 integerValue] == 2) {
        NSString *firstRobotRobotId = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@-firstRobot",date]];
        NSArray *temp1 = [DHMessageDao getRobotChatListWithUserId:firstRobotRobotId];
        DHMessageModel *lastMessage1 = [temp1 lastObject];
        NSString *lastMessageDate1 = nil;
        if ([lastMessage1.timeStamp length] > 0 && ![lastMessage1.timeStamp isEqualToString:@"(null)"]) {
            lastMessageDate1 = [lastMessage1.timeStamp substringToIndex:10];
        }
        NSString *type1 = nil;
        if (!lastMessage1) {
            type1 = @"1";
        }else{
            // 如果bu是同一天不变，不是同一天，就取一
            if ([lastMessageDate1 isEqualToString:date] && [lastMessage1.robotMessageType integerValue] <= 4) {
                type1 = [NSString stringWithFormat:@"%ld",[lastMessage1.robotMessageType integerValue]+randomIndex];
                if ([type1 integerValue] > 4) {
                    type1 = @"4";
                }
            }else{
                type1 = @"1";
            }
        }
        if ([type1 integerValue] <= 4 && [lastMessage1.robotMessageType integerValue] < 4) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(waitTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *robotMessageType = type1;
                NSString *robotId = [self pushfirstNotificationWhenAfterLogin:item lastRobotMessageType:[robotMessageType integerValue] targetRobotId:firstRobotRobotId];
                if (robotId) {
                    // 设置第一个机器人发过
                    [[NSUserDefaults standardUserDefaults] setObject:robotId forKey:[NSString stringWithFormat:@"%@-firstRobot",date]];
                }
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:item,@"currentUserinfo",robotId,@"robotId",robotMessageType,@"robotMessageType", nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(fireTime1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:fireTime1 target:self selector:@selector(pushRobotMessage:) userInfo:dict repeats:YES];
                    [timer fire];
                });
            });
        }
        NSString *secondRobotRobotId = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@-secondRobot",date]];
        NSArray *temp2 = [DHMessageDao getRobotChatListWithUserId:secondRobotRobotId];
        DHMessageModel *lastMessage2 = [temp2 lastObject];
        NSString *lastMessageDate2 = nil;
        if ([lastMessage2.timeStamp length] > 0 && ![lastMessage2.timeStamp isEqualToString:@"(null)"]) {
            lastMessageDate2 = [lastMessage2.timeStamp substringToIndex:10];
        }
        NSString *type2 = nil;
        if (!lastMessage2) {
            type2 = @"1";
        }else{
            // 如果bu是同一天不变，不是同一天，就取一
            if ([lastMessageDate2 isEqualToString:date] && [lastMessage2.robotMessageType integerValue] <= 4) {
                type2 = [NSString stringWithFormat:@"%ld",[lastMessage2.robotMessageType integerValue]+randomIndex];
                if ([type2 integerValue] > 4) {
                    type2 = @"4";
                }
            }else{
                type2 = @"1";
            }
        }
        if ([type2 integerValue] <= 4 && [lastMessage2.robotMessageType integerValue] < 4) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(waitTime*2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *robotMessageType = type2;
                NSString *robotId = [self pushfirstNotificationWhenAfterLogin:item lastRobotMessageType:[robotMessageType integerValue] targetRobotId:secondRobotRobotId];
                if (robotId) {
                    // 设置第一个机器人发过
                    [[NSUserDefaults standardUserDefaults] setObject:robotId forKey:[NSString stringWithFormat:@"%@-secondRobot",date]];
                }
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:item,@"currentUserinfo",robotId,@"robotId",robotMessageType,@"robotMessageType", nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(fireTime2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:fireTime2 target:self selector:@selector(pushRobotMessage:) userInfo:dict repeats:YES];
                    [timer fire];
                });
            });
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(waitTime*5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *robotMessageType = @"1";
            NSString *robotId = [self pushfirstNotificationWhenAfterLogin:item lastRobotMessageType:[robotMessageType integerValue] targetRobotId:nil];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:item,@"currentUserinfo",robotId,@"robotId",robotMessageType,@"robotMessageType", nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(fireTime3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:fireTime3 target:self selector:@selector(pushRobotMessage:) userInfo:dict repeats:YES];
                [timer fire];
                // 记录当天已经发送了三个人
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@-%@",date,userId]];
            });
            
        });
        //        }
    }
}
/**
 *  机器人给用户发消息
 *
 *  @param timer
 */
- (void)pushRobotMessage:(NSTimer *)timer{
    NSDictionary *dict = timer.userInfo;
    DHUserInfoModel *item = [dict objectForKey:@"currentUserinfo"];
    NSString *robotId = [dict objectForKey:@"robotId"];
    NSInteger robotMessageType = [[NSUserDefaults standardUserDefaults] integerForKey:robotId];
    if (robotMessageType == 0) {
        robotMessageType = 1;
    }
    NSString *targetRobotId = [[NSUserDefaults standardUserDefaults] objectForKey:@"targetRobotId"];
    if (!targetRobotId) {
        // 如果已经发送过，则发送下一个类型的消息
        if ([DHMessageDao checkRobotMessageWithRobotId:robotId robotMessageType:[NSString stringWithFormat:@"%ld",robotMessageType]]) {
            NSInteger type = 0;
            if (robotMessageType == 1) {
                type = robotMessageType  + 2;
            }else{
                type = robotMessageType  + 1;
            }
            if (type > 4) {
                type = 4;
            }
            NSString *robotId1 = [self pushfirstNotificationWhenAfterLogin:item lastRobotMessageType:type targetRobotId:robotId];
            [[NSUserDefaults standardUserDefaults] setInteger:type forKey:robotId1];
            // 发了第4种类型消息，停止发送
            if (type == 4) {
                [timer invalidate];
                timer = nil;
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:robotId1];
            }
        }else{
            NSInteger type = robotMessageType;
            NSString *robotId1 = [self pushfirstNotificationWhenAfterLogin:item lastRobotMessageType:type targetRobotId:robotId];
            [[NSUserDefaults standardUserDefaults] setInteger:type forKey:robotId1];
        }
        
    }
}
/**
 *  用户回复机器人情况
 *
 *  @param notifi 通知回调
 */
- (void)replyMessageToRobot:(NSNotification *)notifi{
    NSDictionary *dict = notifi.object;
    NSInteger lastRobotMessageType = [[dict objectForKey:@"lastRobotMessageType"] integerValue];
    if (lastRobotMessageType == 0) {
        lastRobotMessageType = 1;
    }
    NSString *targetRobotId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"targetRobotId"]];
    //    DHUserInfoModel *userinfo = [dict objectForKey:@"robotUserinfo"];
    // 保存到本地，用于判断是否回复
    [[NSUserDefaults standardUserDefaults] setObject:targetRobotId forKey:@"targetRobotId"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        switch (lastRobotMessageType) {
            case 1:{
                // 回复类型1，发类型2或者4
                NSInteger temp = arc4random() % 2;
                NSInteger type = temp == 0 ? 2 : 4;
                [self pushfirstNotificationWhenAfterLogin:self.userinfo lastRobotMessageType:type targetRobotId:targetRobotId];
            }
                break;
            case 2:{
                // 回复类型2，发类型4
                NSInteger type = 4;
                [self pushfirstNotificationWhenAfterLogin:self.userinfo lastRobotMessageType:type targetRobotId:targetRobotId];
            }
                break;
            case 4:{
                // 回复类型4，停止发送
                return ;
                
            }
                break;
            default:
                break;
        }
    });
}

- (NSString * )pushfirstNotificationWhenAfterLogin:(DHUserInfoModel *)item lastRobotMessageType:(NSInteger )lastRobotMessageType targetRobotId:(NSString *)targetRobotId {
    __block DHRandomMessageModel *messageItem = nil;
    DHUserInfoModel *userinfo = item;
    messageItem = [DHRandomMessageDao getRandomMessageWithCurrentUserId:userinfo.b80 messageType:[NSString stringWithFormat:@"%ld",lastRobotMessageType]];
    if (![messageItem.b14 isEqualToString:@"(null)"] && [messageItem.b14 length] > 0) {
        //#warning gender 为当前用户的性别。
        DHUserInfoModel *robotUser = [DHUserInfoDao getRobotUserWithRobotId:targetRobotId gender:[userinfo.b69 integerValue]];
        if (robotUser) {
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a = [dat timeIntervalSince1970]*1000;
            long long b = a;
            NSString *timeString = [NSString stringWithFormat:@"%lld", b];//转为字符型
            NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
            [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *fmtDate = [fmt stringFromDate:dat];
            DHMessageModel *msg = [[DHMessageModel alloc] init];
            msg.toUserAccount = userinfo.b80;
            msg.roomName = robotUser.b52;
            msg.roomCode = userinfo.b80;
            msg.message = messageItem.b14;
            msg.fromUserDevice = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:2]];// 1:安卓 2:苹果 3:windowPhone
            msg.timeStamp = fmtDate;
            msg.fromUserAccount = robotUser.b80;
            msg.messageType = @"1";
            msg.messageId = timeString;// 消息ID
            msg.token = @"";
            msg.roomCode = robotUser.b80;
            msg.targetId = robotUser.b80;
            msg.robotMessageType = messageItem.b78;
            msg.userId = userinfo.b80;
            msg.isRead = @"1";
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_RECEIVE_MESSAGE_NOTIFICATION object:msg];
            // 存储到数据库
            if ([[NSString stringWithFormat:@"%@",msg.targetId] length] > 0 && ![[NSString stringWithFormat:@"%@",msg.targetId] isEqualToString:@"(null)"] && ![DHMessageDao checkMessageWithMessageId:msg.messageId targetId:msg.targetId]) {
                [DHMessageDao insertMessageDataDBWithModel:msg userId:[NSString stringWithFormat:@"%@",userinfo.b80]];
            }
            //    _timerIndex ++;
            dispatch_async(dispatch_get_main_queue(), ^{
                DHMsgPlaySound *sound = [[DHMsgPlaySound alloc]initSystemSoundWithName:nil SoundType:nil];
                [sound play];
            });
            return robotUser.b80;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
    
}
/**
 *  获取当前用户信息
 *
 *  @param userId
 *  @param completed
 */
- (void )asyncGetCurrentUserInfoWithUserId:(NSString *)userId completed:(void(^)(DHUserInfoModel *userInfo,NSString *sql))completed{
    DHUserInfoModel *item = [DHUserInfoDao getUserWithCurrentUserId:userId];
    if (item) {
        completed(item,nil);
    }else{
        NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"c1502b8c6f4e217c0956f175096655c7",@"p1",userId,@"p2",nil];
        [DHActionServer asyncQueryWithMethodType:DHRequestMethodTypeGet domain:DHRequestServerTypeBus function:@"f_108_13_1.service" parameters:dict1 completed:^(id result, NSInteger resultCode) {
            NSDictionary *infoDict = [result objectForKey:@"body"];
            DHUserInfoModel *item = [[DHUserInfoModel alloc]init];
            [item setValuesForKeysWithDictionary:infoDict];
            NSDictionary *b112Dict = [infoDict objectForKey:@"b112"];
            [item setValuesForKeysWithDictionary:b112Dict];
            NSArray *b113Arr = [infoDict objectForKey:@"b113"];
            for (NSDictionary *b113Dict in b113Arr) {
                [item setValuesForKeysWithDictionary:b113Dict];
            }
            
            if (![DHUserInfoDao checkUserWithUsertId:item.b80]) {
                [DHUserInfoDao insertUserToDBWithItem:item];
            }else{
                [DHUserInfoDao updateUserToDBWithItem:item userId:item.b80];
            }
            completed(item,nil);
        }];
    }
}
/**
 *  获取机器人用户信息
 *
 *  @param userId    当前用户id
 *  @param robotId   机器人id---可为空，若为空，则随机获取一个机器人，若不为空，则获取该id的机器人
 *  @param gender    性别，取反
 *  @param completed
 */
- (DHUserInfoModel * )asyncGetRobotInfoWithUserId:(NSString *)userId robotId:(NSString *)robotId gender:(NSString *)gender {
    
    DHUserInfoModel *userinfo = [DHUserInfoDao getRobotUserWithRobotId:robotId gender:[gender integerValue]];
    return userinfo;
}
/**
 *  获取随机消息
 *
 *  @param userId     当前用户id
 *  @param compeleted
 */
- (DHRandomMessageModel *)asyncConfigRandomMessageWithUserId:(NSString *)userId lastRobotMessageType:(NSInteger )lastRobotMessageType {
//    NSDictionary *groupFilter = [NSDictionary dictionaryWithObjectsAndKeys:@"timeStamp",@"targetId", nil];
//    NSDictionary *filter = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",lastRobotMessageType],@"b78", nil];
//    NSArray *array = [DHRandomMessageDao asyncExecuteQueryMessageInfoWithCurrentUserId:userId filter:filter groupFilter:nil ];
//    if (array.count > 0) {
//        NSInteger randomIndex = arc4random()%array.count-1;
//        if (randomIndex<0) {
//            randomIndex = 0;
//        }else if(randomIndex > array.count - 1){
//            randomIndex = array.count - 1;
//        }
//       DHRandomMessageModel *item = [array objectAtIndex:randomIndex];
//        return item;
//    }else{
//        return nil;
//    }
     DHRandomMessageModel *item = [DHRandomMessageDao getRandomMessageWithCurrentUserId:userId messageType:[NSString stringWithFormat:@"%ld",lastRobotMessageType]];
    return item;
}
@end
