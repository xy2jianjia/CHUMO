//
//  ViewController+Recommend.m
//  CHUMO
//
//  Created by xy2 on 16/3/25.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "ViewController+Recommend.h"
#import "HomeController.h"

@implementation ViewController (Recommend)


/**
 *  获取同城，全国速配
 *
 *  @param isEmpty NO--同城有数据，YES--同城无数据。
 */
- (void)asyncLoadRecommendIsEmpty:(BOOL)isEmpty{
    NSMutableArray *dict = nil;
    // 如果同城数据不为空
    if (isEmpty == NO) {
        
    }else{
        dict = [[NSGetTools getCLLocationData] mutableCopy];
        if ([self.ids length] != 0) {
            [dict setValue:self.ids forKey:@"a117"];
        }
    }
//    [DHRecommedViewV1 configRecommendViewInView:self.view userInfo:nil delelgate:self isCity:NO];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *sessionId = [NSGetTools getUserSessionId];
    NSString *url = [NSString stringWithFormat:@"%@f_108_17_1.service?p1=%@&p2=%@",kServerAddressTest2,sessionId,userId];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSArray *arr = [infoDic objectForKey:@"body"];
        if ([[infoDic objectForKey:@"code"] integerValue] == 200) {
            self.ids = [NSMutableString string];
            NSInteger index = 0;
            for (NSDictionary *temp in arr) {
                DHUserInfoModel *item = [[DHUserInfoModel alloc]init];
                if ([temp isKindOfClass:[NSDictionary class]]) {
                    [item setValuesForKeysWithDictionary:temp];
                    item.b14 = [[temp objectForKey:@"b160"] objectForKey:@"b14"];
                    item.b78 = [[temp objectForKey:@"b160"] objectForKey:@"b78"];
                    item.answerArr = [NSMutableArray array];
                    for (NSDictionary *d in [[temp objectForKey:@"b160"] objectForKey:@"b161"]) {
                        [item.answerArr addObject:d];
                    }
                    if (![DHRecommedDao checkRecommendUserWithUsertId:item.b80]) {
                        [DHRecommedDao insertRecommendUserToDBWithItem:item];
                    }else{
                        [DHRecommedDao updateRecommendUserToDBWithItem:item userId:item.b80];
                    }
                    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
                    NSArray *hasSendIds = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_recommendHasSendIds",userId]];
                    
                    // 去重:如果hasSendIds这个数组存在已经发过的用户id，则不再添加入数据源
//                    NSString *lastid = [NSString stringWithFormat:@"%@",item.b80];
//                    NSNumber *lastid = [NSNumber numberWithInteger:[item.b80 integerValue]];
                     NSNumber *lastid = (NSNumber *)item.b80;
                    if (![hasSendIds containsObject:lastid]) {
                        [self.recommendArr addObject:item];
                    }
                    if (index == arr.count-1) {
                        [self.ids appendFormat:@"%@",item.b80];
                    }else{
                        [self.ids appendFormat:@"%@,",item.b80];
                    }
                    index ++;
                }
            }
            if (self.recommendArr.count == 0 && self.reconnectedTimes <=10) {
                [self asyncLoadRecommendIsEmpty:NO];
                self.reconnectedTimes ++;
            }else{
                NSString *date = [[[DHTool shareTool] stringFromDate:[NSDate date]] substringToIndex:10];
                NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
                NSInteger count = self.recommendArr.count;
                if (count > 0) {
                    NSInteger index = (arc4random() % (self.recommendArr.count-1-0+1))+0;
                    if (index < 0) {
                        index = 0;
                    }else if (index > count - 1){
                        index = count - 1;
                    }
                    DHUserInfoModel *userInfo1 = [self.recommendArr objectAtIndex:index];
                    //                [self getUserInfo];
                    NSString *lastUserId = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"hasRecommend-%@-%@",date,userId]];
                    NSArray *arr10 = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_recommendHasSendIds",userId]];
                    
                    if (![arr10 containsObject:[NSNumber numberWithInteger:[userInfo1.b80 integerValue]]]) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(50 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if (userInfo1) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    NSDictionary *location = [NSGetTools getCLLocationData];
                                    NSInteger cityCode = [[location objectForKey:@"a9"] integerValue];
                                    if (cityCode != [userInfo1.b9 integerValue]) {
                                        UIViewController *vc = [self getCurrentVC];
                                        if ([vc isKindOfClass:[ViewController class]] || [vc isKindOfClass:[EyeLuckViewController class]]|| [vc isKindOfClass:[SearchViewController class]]|| [vc isKindOfClass:[HomeController class]]|| [vc isKindOfClass:[NearPeopleViewController class]]|| [vc isKindOfClass:[MineViewController class]]) {
                                            [DHRecommedViewV1 configRecommendViewInView:self.view userInfo:userInfo1 delelgate:self isCity:NO];
                                            //                                        [DHCityRecommendView asyncConfigCityRecommendViewWithUserInfo:userInfo1 inView:self.view delelgate:self isCity:NO];
                                        }
                                    }else{
                                        UIViewController *vc = [self getCurrentVC];
                                        if ([vc isKindOfClass:[ViewController class]] || [vc isKindOfClass:[EyeLuckViewController class]]|| [vc isKindOfClass:[SearchViewController class]]|| [vc isKindOfClass:[HomeController class]]|| [vc isKindOfClass:[NearPeopleViewController class]]|| [vc isKindOfClass:[MineViewController class]]) {
                                            [DHRecommedViewV1 configRecommendViewInView:self.view userInfo:userInfo1 delelgate:self isCity:YES];
                                            //                                        [DHCityRecommendView asyncConfigCityRecommendViewWithUserInfo:userInfo1 inView:self.view delelgate:self isCity:YES];
                                        }
                                    }
                                    NSArray *arr1 = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_recommendHasSendIds",userId]];
                                    NSMutableArray *arr2 = nil;
                                    if (arr1) {
                                        arr2 = [NSMutableArray arrayWithArray:arr1];
                                    }else{
                                        arr2 = [NSMutableArray array];
                                    }
                                    NSNumber *lastId = (NSNumber *)userInfo1.b80;
//                                    NSNumber *lastId = [NSNumber numberWithInteger:[userInfo1.b80 integerValue]];
//                                    NSString *lastId = [NSString stringWithFormat:@"%@",userInfo1.b80];
                                    if (![arr2 containsObject:lastId]) {
                                        [arr2 addObject:lastId];
                                        [[NSUserDefaults standardUserDefaults] setObject:arr2 forKey:[NSString stringWithFormat:@"%@_recommendHasSendIds",userId]];
                                    }
                                    
                                    [[NSUserDefaults standardUserDefaults] setInteger:++self.recommendTimes forKey:[NSString stringWithFormat:@"recommend-%@-%@",date,userId]];
                                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",userInfo1.b80] forKey:[NSString stringWithFormat:@"hasRecommend-%@-%@",date,userId]];
                                });
                            }
                        });
                    }else{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            if (self.reconnectedTimes <=10) {
                                [self asyncLoadRecommendIsEmpty:NO];
                                self.reconnectedTimes ++;
                            }
                        });
                    }
                }
                
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (DHUserInfoModel *)getUserInfo{
    DHUserInfoModel *userInfo1 = [DHRecommedDao getRecommendUserWithCurrentUserId:nil];
    return userInfo1;
}
// 在类目中实现代理方法，会警告在原类中也要实现。
// 在buildsetting下，other warning flag输入 -Wno-objc-protocol-method-implementation
-(void)onClickedBtnWithTag:(NSInteger)tag targetUserinfo:(DHUserInfoModel *)targetUserinfo{
    
    if (tag == 1001 || tag == 1002) {
        [self sendMessageWithUserinfo:targetUserinfo];
    }
    if (!self.recommendTimer) {
        self.recommendTimer = [NSTimer scheduledTimerWithTimeInterval:40 target:self selector:@selector(repeatShowRecommed:) userInfo:targetUserinfo repeats:YES];
        [self.recommendTimer fire];
    }
}
// 新版推荐
-(void)recommendOnclickedAnswerBtnCalledBackWithBtnTag:(NSInteger)tag targetUserInfo:(DHUserInfoModel *)targetUserInfo{
    if (tag == 1001 || tag == 1002) {
        [self sendMessageWithUserinfo:targetUserInfo];
    }
    if (!self.recommendTimer) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self repeatShowRecommed:targetUserInfo];
        });
//        self.recommendTimer = [NSTimer scheduledTimerWithTimeInterval:40 target:self selector:@selector(repeatShowRecommed:) userInfo:targetUserInfo repeats:YES];
//        [self.recommendTimer fire];
    }
}


- (void)repeatShowRecommed:(DHUserInfoModel *)userinfo{
    NSString *date = [[[DHTool shareTool] stringFromDate:[NSDate date]] substringToIndex:10];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSInteger recommendTime = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"recommend-%@-%@",date,userId]];
    NSInteger recommend_sendMsgTimes = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"recommend_sendMsg-%@-%@",date,userId]];
    if (recommendTime <= self.recommendTotalTimes && recommend_sendMsgTimes <= self.sendMessageTotalTimes) {
        [self asyncLoadRecommendIsEmpty:YES];
    }else{
        //        [timer invalidate];
        return;
    }
}
- (void)sendMessageWithUserinfo:(DHUserInfoModel *)userinfo{
    
    NSString *date = [[[DHTool shareTool] stringFromDate:[NSDate date]] substringToIndex:10];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *sessionId = [NSGetTools getUserSessionId];
    [[NSUserDefaults standardUserDefaults] setInteger:++self.sendMessageTimes forKey:[NSString stringWithFormat:@"recommend_sendMsg-%@-%@",date,userId]];
    
//    RobotMessageModel *randomMsg = [DHRobotMessageDao getRobotMessageWithCurrentUserId:userId messageType:@"1"];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:sessionId,@"p1",userId,@"p2",@"1",@"a78", nil];
    [HttpOperation asyncGetMessagesOfMySelfWithPara:para completed:^(NSArray *messageArray) {
        if (messageArray.count > 0) {
            NSInteger random_index = [self randomIndexWithMaxNumber:messageArray.count - 1  min:0];
            RobotMessageModel *randomMsg = nil;
            if (random_index <= messageArray.count - 1) {
                randomMsg = [messageArray objectAtIndex:random_index];
            }
            if (randomMsg && [randomMsg.b14 length] > 0 && ![randomMsg.b14 isEqualToString:@"(null)"]) {
                NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
                [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *fmtDate = [fmt stringFromDate:dat];
                DHMessageModel *_msg = [[DHMessageModel alloc] init];
                _msg.toUserAccount = userinfo.b80;
                _msg.roomName = userinfo.b52;
                _msg.roomCode = userinfo.b80;
                _msg.message = randomMsg.b14;
                _msg.fromUserDevice = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:2]];// 1:安卓 2:苹果 3:windowPhone
                _msg.timeStamp = fmtDate;
                
                _msg.fromUserAccount = userId;
                _msg.messageType = @"1";
                _msg.messageId = [self configUUid];// 消息ID
                _msg.targetId = userinfo.b80;
                _msg.userId = userId;
                //同城推荐消息
                _msg.targetUserType=@"4";
                // 不是机器人消息
                _msg.robotMessageType = @"-1";
                _msg.isRead = @"2";
                _msg.fileUrl = @"";
                _msg.length = 0;
                _msg.fileName = @"";
                _msg.addr = @"";
                _msg.lat = 0;
                _msg.lng = 0;
                _msg.socketType = 1001;
                // 存储到数据库
                if (![DHMessageDao checkMessageWithMessageId:_msg.messageId targetId:_msg.targetId]) {
                    [DHMessageDao insertMessageDataDBWithModel:_msg userId:[NSString stringWithFormat:@"%@",userId]];
                }
                
                [SocketManager asyncSendMessageWithMessageModel:_msg];
                [Mynotification postNotificationName:@"new_didSendedRecommendMessage" object:_msg];
            }
        }
    }];
}
- (void)getRobotMessageWithPara:(NSDictionary *)para1 completed:(void(^)(NSArray *array))completed{
    [RobotMessageHttpDao asyncGetMessagesWithPara:para1 completed:^(NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(array);
        });
    }];
}
- (NSInteger )randomIndexWithMaxNumber:(NSInteger )max min:(NSInteger )min{
    
    NSInteger index = (arc4random() % (max-min+1))+min;
    return index;
    
}
@end
