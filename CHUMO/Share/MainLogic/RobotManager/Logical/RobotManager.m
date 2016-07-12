//
//  RobotManager.m
//  RobotMechanism
//
//  Created by xy2 on 16/4/27.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "RobotManager.h"
#import "RobotManager+Config.h"
#import "RobotManager+Temptation.h"
#import "RobotManager+SuitRobotV1.h"
#import "RobotManager+TemptationSuitRobot.h"
@interface RobotManager ()

//@property (nonatomic,strong)NSTimer *timer;
//@property (nonatomic,strong) DHMessageModel *lastMessage;
/**
 *  记录发几个机器人
 */
@property (nonatomic,assign) NSInteger index;
/**
 *  发送了多少轮，最多3轮
 */
//@property (nonatomic,assign) NSInteger sendTimes;
/**
 *  记录2、3和2、4类型聊天时，若出现过2类型，则不再出现2类型。nextMessageType设定值1
 */
@property (nonatomic,assign) NSInteger nextMessageType;

//@property (nonatomic,strong) NSTimer *timer;// 机器人计时器
@end

@implementation RobotManager

/**
 *  机器人入口
 *
 *  @param delegate 代理
 */

+ (void)startupRobotManagerWithDelegate:(id <RobotManagerDelegate>)delegate{
    RobotManager *manager = [RobotManager shareInstance];
    [manager registerNotificationWithstartupRobotManagerWithDelegate:delegate];
    
}
- (void) registerNotificationWithstartupRobotManagerWithDelegate:(id <RobotManagerDelegate>)delegate{
    self.delegate = delegate;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveRobotMessageNotification:) name:NEW_DID_RECEIVE_MESSAGE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReplyRobotMessageNotification:) name:NEW_DID_REPLY_MESSAGE_NOTIFICATION object:nil];
}
- (void)didReceiveRobotMessageNotification:(NSNotification *)notifi{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveRobotMessageCallBacked:)]) {
        [self.delegate didReceiveRobotMessageCallBacked:[notifi object]];
    }
}

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static RobotManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[RobotManager alloc]init];
    });

    // 配套机器人
#warning 此处没有感叹号 -- by大海2016年06月16日17:44:39
    if ([manager isAllReady]) {
        BOOL suit_isTemptationAllReady = [manager suit_isTemptationAllReady];
        #warning 此处没有感叹号 --by 大海 2016年06月25日11:30:16
        if (suit_isTemptationAllReady) {
            [manager temptation_configSuitRobot];
        }
        [manager configSuitRobot];
    }else{
#warning 记得解开
        BOOL isTemptationAllReady = [manager isTemptationAllReady];
        if (isTemptationAllReady) {
            NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
            DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
            // 女用户不再发机器人消息 --by大海 2016年06月30日10:38:18
            if ([userInfo.b69 integerValue] == 1) {
                // 男用户流程不变
                [manager temptation_configMessage];
            }
            
        }
        NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
        DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
        // 女用户不再发机器人消息 --by大海 2016年06月30日10:38:18
        if ([userInfo.b69 integerValue] == 1) {
            // 男用户流程不变
            [manager configTimer];
        }
//        // 男用户流程不变
//        [manager configTimer];

//        // 已经支付过的，如果是今天支付的，延期两天继续发消息
//        if (nil!=[[NSUserDefaults standardUserDefaults] objectForKey:@"XXAccount"]){
//            if ([manager isPayToday]) {
//                [manager configTimer];
//            }
//        }else{
//            NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
//            // 未支付的
//            DHUserInfoModel *userinfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
//            // 女用户,三天后就不发了
//            if ([userinfo.b69 integerValue] == 2) {
//                if ([manager isGirlRegToday]) {
//                    [manager configTimer];
//                }
//            }else{
//                // 男用户流程不变
//                [manager configTimer];
//            }
//            
//        }
    }
    manager.index = 0;
    return manager;
}
- (BOOL)isGirlRegToday{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [[fmt stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(0, 10)];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    // 某用户某天注册的
    BOOL isTodayRegister = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@_%@_registerDate",date,userId]];
    NSInteger interval = 24*60*60;
    NSString *tomorrow = [[fmt stringFromDate:[NSDate dateWithTimeIntervalSinceNow:interval]] substringWithRange:NSMakeRange(0, 10)];
    NSString *afterTomorrow = [[fmt stringFromDate:[NSDate dateWithTimeIntervalSinceNow:interval * 2]] substringWithRange:NSMakeRange(0, 10)];
    BOOL isTomorrow = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@_%@_registerDate",tomorrow,userId]];
    BOOL isAfterTomorrow = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@_%@_registerDate",afterTomorrow,userId]];
    
    return isTodayRegister || isTomorrow || isAfterTomorrow;
}
/**
 *  支付成功后，明天再发一天后停止发送
 *
 *  @return
 */
- (BOOL)isPayToday{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *today = [[fmt stringFromDate:[NSDate date]] substringToIndex:11];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
//    [[NSUserDefaults standardUserDefaults] setObject:today forKey:[NSString stringWithFormat:@"%@_%@_paysuccess",today,userId]];
    BOOL date = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@_%@_paysuccess",today,userId]];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    //明天时间
    NSString *tomorrow = [[fmt stringFromDate:[[NSDate alloc] initWithTimeIntervalSinceNow:secondsPerDay]] substringToIndex:11];
    BOOL tomorrowDate = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@_%@_paysuccess",tomorrow,userId]];
    return date || tomorrowDate;
    
}

// 未付费的男用户
- (BOOL)isAllReady{
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
    if (nil==[[NSUserDefaults standardUserDefaults] objectForKey:@"XXAccount"]){
        if ([userInfo.b69 integerValue] == 1) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
   
    
}
/**
 *  是否具备发送诱惑消息的条件--- 非注册当天，若用户在21-24点登录，发送1个诱惑机器人
 
 *
 *  @return yes：具备：发送诱惑消息；；NO：不具备，不发送诱惑消息
 */
- (BOOL )isTemptationAllReady{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [[fmt stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(0, 10)];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    BOOL isSended = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@_%@hasSended",date,userId]];
    // 某用户某天注册的
    BOOL isTodayRegister = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@_%@_registerDate",date,userId]];
    // 不是当天注册的
    if (isTodayRegister == NO) {
        NSString *date = [[fmt stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(11, 2)];
        if ([date integerValue] <= 24 && [date integerValue] >= 21) {
            return YES;
        }else{
            return NO;
        }
    }else{
        if (isSended) {
            return NO;
        }else{
            // 当天注册
            return YES;
        }
    }
}
- (BOOL )suit_isTemptationAllReady{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [[fmt stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(0, 10)];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    BOOL isSended = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@_%@suit_hasSended",date,userId]];
    // 某用户某天注册的
    BOOL isTodayRegister = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@_%@_registerDate",date,userId]];
    // 不是当天注册的
    if (isTodayRegister == NO) {
        NSString *date = [[fmt stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(11, 2)];
        if ([date integerValue] <= 24 && [date integerValue] >= 21) {
            return YES;
        }else{
            return NO;
        }
    }else{
        if (isSended) {
            return NO;
        }else{
            // 当天注册
            return YES;
        }
    }
}
- (void)configTimer{
//    _sendTimes = 0;
    // 配置登录后随机事件
    NSMutableArray *temp = [NSMutableArray array];
    while (_index < 3) {
        NSInteger timeInterval = [self randomIndexWithMaxNumber:10 min:1];
        NSLog(@"before：%s:%ld",__func__,timeInterval);
        // 去重机制：当数组内不包含相同的数字，则自增
        if (![temp containsObject:[NSString stringWithFormat:@"%ld",timeInterval]]) {
            [temp addObject:[NSString stringWithFormat:@"%ld",timeInterval]];
            _index ++;
        }
        if (temp.count == 3) {
            for (int i = 0;i < temp.count ; i ++) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([[temp objectAtIndex:i] integerValue] * 60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    NSArray *arr = @[@"0",@"0.1",@"0.2",@"0.3",@"0.4",@"0.5",@"0.6",@"0.7",@"0.8",@"0.9",@"1.0"];
                    float timerInterval = 1.0 + [self randomIndexWithMaxNumber:arr.count - 1 min:0];
                    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: timerInterval*10 target:self selector:@selector(timerWithRandomTimeInterval:) userInfo:[NSNumber numberWithInt:(i+1)] repeats:YES];
                    [timer fire];
                });
            }
        }
    }
}
- (void)timerWithRandomTimeInterval:(NSTimer *)timer{
    NSInteger timerTag = [timer.userInfo integerValue];
    if (nil!=[[NSUserDefaults standardUserDefaults] objectForKey:@"XXAccount"]){
        [timer invalidate];
        return;
    }
    NSLog(@"%s%@",__func__,timer);
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [[fmt stringFromDate:[NSDate date]] substringToIndex:11];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    
    // 某个机器人是某完成聊天，yes：完成，不再发消息；NO：为完成，继续发送
    __block NSInteger sendtimes = [[NSUserDefaults standardUserDefaults]integerForKey:[NSString stringWithFormat:@"%@_%@",date,userId]];
    if (sendtimes <= 3 ) {
//        DHUserInfoModel *userinfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
//        NSInteger b144 = [userinfo.b144 integerValue];
        
        NSInteger maxType = 0;
        if (nil!=[[NSUserDefaults standardUserDefaults] objectForKey:@"XXAccount"]){
            // vip
            maxType = 4;
        }else{
            maxType = 3;
        }
        NSInteger timeInterval = [self randomIndexWithMaxNumber:20 min:10];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *messageId = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@_%ld_hasSend",date,userId,timerTag]];
            DHMessageModel *lastMessage = [DHMessageDao getMessageWithMessageId:messageId];
            NSInteger nextType = [lastMessage.robotMessageType integerValue];
            if ([lastMessage.robotMessageType integerValue] <= 0) {
                NSInteger randomTemp = [self randomIndexWithMaxNumber:2 min:1];
                nextType = randomTemp;
                [self pubWithMessage:lastMessage type: [NSString stringWithFormat:@"%ld",nextType] completed:^(DHMessageModel *lastMessage) {
                    //                    // 记录某天哪个机器人发过消息
                    [[NSUserDefaults standardUserDefaults] setObject:lastMessage.messageId forKey:[NSString stringWithFormat:@"%@_%@_%ld_hasSend",date,userId,timerTag]];
                    //                    _lastMessage = lastMessage;
                }];
                // 若是取到类型2，则停止本轮循环
                if (nextType == 2) {
                    NSLog(@"%s我已经停止2：%@",__func__,timer);
                    [timer invalidate];
                    //                    timer = nil;
                    sendtimes ++;
                    [[NSUserDefaults standardUserDefaults] setInteger:sendtimes forKey:[NSString stringWithFormat:@"%@_%@",date,userId]];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@_%@_%ld_hasSend",date,userId,timerTag]];//
                    //                    _lastMessage = nil;
                }
            }else if([lastMessage.robotMessageType integerValue] >= maxType){
                NSLog(@"%s我已经停止max：%@",__func__,timer);
                nextType = maxType;
                [timer invalidate];
                //                timer = nil;
                sendtimes ++;
                [[NSUserDefaults standardUserDefaults] setInteger:sendtimes forKey:[NSString stringWithFormat:@"%@_%@",date,userId]];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@_%@_%ld_hasSend",date,userId,timerTag]];//
                //                _lastMessage = nil;
                
            }else{
                switch (nextType) {
                    case 1:{
                        if (nil!=[[NSUserDefaults standardUserDefaults] objectForKey:@"XXAccount"]){
                            NSInteger randomTemp = 2;
                            nextType = randomTemp;
                        }else{
                            NSInteger randomTemp = [self randomIndexWithMaxNumber:3 min:2];
                            nextType = randomTemp;
                        }
                    }
                        break;
                    case 2:{
                        NSInteger randomTemp = 0;
                        if (nil!=[[NSUserDefaults standardUserDefaults] objectForKey:@"XXAccount"]){
                            NSArray *arr = @[@"2",@"4"];
                            randomTemp = [[arr objectAtIndex:[self randomIndexWithMaxNumber:1 min:0]] integerValue];
                            if (_nextMessageType == 1) {
                                randomTemp = 4;
                            }
                        }else{
                            randomTemp = [self randomIndexWithMaxNumber:3 min:2];
                            if (_nextMessageType == 1) {
                                randomTemp = 3;
                            }
                        }
                        nextType = randomTemp;
                        if (randomTemp == 2) {
                            _nextMessageType = 1;
                        }
                    }
                        break;
                    default:
                        break;
                }
                [self pubWithMessage:lastMessage type: [NSString stringWithFormat:@"%ld",nextType] completed:^(DHMessageModel *lastMessage) {
                    [[NSUserDefaults standardUserDefaults] setObject:lastMessage.messageId forKey:[NSString stringWithFormat:@"%@_%@_%ld_hasSend",date,userId,timerTag]];
                    //                    _lastMessage = lastMessage;
                }];
            }
        });
    }else{
        [timer invalidate];
    }
}
- (void)pubWithMessage:(DHMessageModel *)lastMessage type:(NSString *)type completed:(void(^)(DHMessageModel *lastMessage))completed{
    __weak RobotManager *weakManager = self;
    
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *sessionId = [NSGetTools getUserSessionId];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:sessionId,@"p1",userId,@"p2",type,@"a78", nil];
    [UserHttpDao asyncGetUserInfoWithPara:para completed:^(NSDictionary *userInfo, DHUserInfoModel *userInfoModel) {
        [weakManager getRobotListWithPara:nil completed:^(NSArray *robotArray) {
            DHUserInfoModel *randomRobot = [DHUserInfoDao getUserWithCurrentUserId:lastMessage.targetId];
            if (!randomRobot) {
                if (robotArray.count > 0) {
                    NSInteger randomIndex = [self randomIndexWithMaxNumber:robotArray.count - 1 min:0];
                    if (randomIndex <= robotArray.count - 1) {
                        randomRobot = [robotArray objectAtIndex:randomIndex];
                    }
                }
            }
            [weakManager getRobotMessageWithPara:para completed:^(NSArray *messageArray) {
                if (messageArray.count > 0) {
                    NSInteger random_index = [self randomIndexWithMaxNumber:messageArray.count - 1  min:0];
                    RobotMessageModel *randomMessage = nil;
                    if (random_index <= messageArray.count - 1) {
                        randomMessage = [messageArray objectAtIndex:random_index];
                    }
                    // 第一次发消息，targetId为空
                    [weakManager sendMessageWithCurrentUserInfo:userInfoModel targetRobot:randomRobot nextMessage:randomMessage completed:^(DHMessageModel *lastMessage) {
                        completed(lastMessage);
                    }];
                }
                
                //                RobotMessageModel *randomMessage = [messageArray firstObject];
                
            }];
        }];
    }];
}

- (void)didReplyRobotMessageNotification:(NSNotification *)notifi{
    NSInteger randomTimerInterVal = [self randomIndexWithMaxNumber:10 min:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * randomTimerInterVal * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DHMessageModel *lastMessage = notifi.object;
//        DHUserInfoModel *currentUserinfo = [DHUserInfoDao getUserWithCurrentUserId:lastMessage.userId];
        NSInteger maxType = 0;
        if (nil!=[[NSUserDefaults standardUserDefaults] objectForKey:@"XXAccount"]){
            maxType = 4;
        }else{
            maxType = 3;
        }
        // 配置下一个类型的消息
        NSInteger nextType = 0;
        NSInteger randomTemp = 0;
        if (nil!=[[NSUserDefaults standardUserDefaults] objectForKey:@"XXAccount"]){
            NSArray *arr = @[@"2",@"4"];
            randomTemp = [[arr objectAtIndex:[self randomIndexWithMaxNumber:1 min:0]] integerValue];
        }else{
            randomTemp = [self randomIndexWithMaxNumber:3 min:2];
        }
        nextType = randomTemp;
        if (nextType < 0) {
            nextType = 1;
            [self pubWithMessage:lastMessage type:[NSString stringWithFormat:@"%ld",nextType] completed:^(DHMessageModel *lastMessage) {
                //                _lastMessage = lastMessage;
            }];
        }else if (nextType > maxType){
            nextType = maxType;
        }else{
            [self pubWithMessage:lastMessage type:[NSString stringWithFormat:@"%ld",nextType] completed:^(DHMessageModel *lastMessage) {
                //                _lastMessage = lastMessage;
            }];
        }
    });
}
#pragma mark 配置信息完毕，发送消息
// 发消息
- (void)sendMessageWithCurrentUserInfo:(DHUserInfoModel *)userInfo targetRobot:(DHUserInfoModel *)targetRobot nextMessage:(RobotMessageModel *)nextMessage completed:(void(^)(DHMessageModel *lastMessage))completed{
    DHUserInfoModel *robot = targetRobot;
    if (robot) {
        RobotMessageModel *robotMessage = nextMessage;
        // 构建消息
        DHMessageModel *message = [self configMessageWithCurrentUserInfo:userInfo robot:robot robotMessage:robotMessage];
        BOOL isblack = [DHBlackListDao checkBlackListUserWithUsertId:targetRobot.b80];
        // 检测是否被拉黑
        if (!isblack) {
            // 发送消息
            [[NSNotificationCenter defaultCenter] postNotificationName:NEW_DID_RECEIVE_MESSAGE_NOTIFICATION object:message];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadBadgeValue" object:message];
            completed(message);
        }
    }else{
        completed(nil);
    }
    
}
#pragma mark 配置消息，将机器人与机器人消息整合成要发的消息
// 配置消息
- (DHMessageModel *)configMessageWithCurrentUserInfo:(DHUserInfoModel *)userInfo robot:(DHUserInfoModel *)targetRobot robotMessage:(RobotMessageModel *)robotMessage{
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    
    DHUserInfoModel *currentUserInfo = [self getCurrentUserInfoWithUserId:userId];
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
    // 存储到数据库
    if ([[NSString stringWithFormat:@"%@",msg.targetId] length] > 0 && ![[NSString stringWithFormat:@"%@",msg.targetId] isEqualToString:@"(null)"] && ![DHMessageDao checkMessageWithMessageId:msg.messageId targetId:msg.targetId]) {
        [DHMessageDao insertMessageDataDBWithModel:msg userId:[NSString stringWithFormat:@"%@",currentUserInfo.b80]];
    }
    return msg;
}
#pragma mark 配置机器人消息
// 配置机器人消息
- (RobotMessageModel *)configRobotMessageWithUserId:(NSString *)userId messageType:(NSString *)messageType{
    RobotMessageModel *mesg = [DHRobotMessageDao getRobotMessageWithCurrentUserId:userId messageType:messageType];
    return mesg;
}
#pragma mark 配置机器人
// 配置机器人
- (DHUserInfoModel *)configRobotWithRobotId:(NSString *)robotId{
    DHUserInfoModel *robot = [DHUserInfoDao getRobotUserWithRobotId:robotId gender:1];
    return robot;
}
#pragma mark 配置当前用户
// 获取当前用户信息
- (DHUserInfoModel *)getCurrentUserInfoWithUserId:(NSString *)userId{
    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
    if (userInfo) {
        return userInfo;
    }else{
        return nil;
    }
}
- (void)getRobotMessageWithPara:(NSDictionary *)para1 completed:(void(^)(NSArray *array))completed{
    //    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:@"27c477b86144e8c6c04db807b5304927",@"p1",@"104134401",@"p2",@"2",@"a78", nil];
    [RobotMessageHttpDao asyncGetMessagesWithPara:para1 completed:^(NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(array);
        });
    }];
}
- (void)getRobotListWithPara:(NSDictionary *)para1 completed:(void(^)(NSArray *array))completed{
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *sessionId = [NSGetTools getUserSessionId];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:sessionId,@"p1",userId,@"p2",@"7",@"a78", nil];
    [RobotHttpDao  asyncGetRobotsWithPara:para completed:^(NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(array);
        });
    }];
}

- (void)dealloc{
    NSLog(@"%s销毁timer",__func__);
    //    [_timer invalidate];
    //    _timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
