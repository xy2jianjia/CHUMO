//
//  NSObject+Chat.m
//  CHUMO
//
//  Created by xy2 on 16/5/4.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "NSObject+Chat.h"
#import "DHMsgPlaySound.h"
@implementation NSObject (Chat)


- (void)registerChatNotification{
    
    [Mynotification addObserver:self selector:@selector(new_didReceiveOnlineMessage:) name:NEW_DIDRECEIVE_ONLINE_MESSAGE_NOTIFICATION object:nil];
    [Mynotification addObserver:self selector:@selector(new_didReceiveOfflineMessage:) name:NEW_DIDRECEIVE_OFFLINE_MESSAGE_NOTIFICATION object:nil];
}
- (void)new_didReceiveOnlineMessage:(NSNotification *)notifi{
    DHMessageModel *message = notifi.object;
    [self loadChatData:message];
    
}
- (void)new_didReceiveOfflineMessage:(NSNotification *)notifi{
    
    NSArray *messageArr = [notifi object];
    for (DHMessageModel *message in messageArr) {
        [self loadChatData:message];
    }
}
- (void)loadChatData:(DHMessageModel *)msg{
    [self localNotification:msg];
    // 存储到数据库
    if (![DHMessageDao checkMessageWithMessageId:msg.messageId targetId:msg.targetId]) {
        [DHMessageDao insertMessageDataDBWithModel:msg userId:[NSString stringWithFormat:@"%@",msg.userId]];
    }
    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:msg.targetId];
    BOOL isblack = [DHBlackListDao checkBlackListUserWithUsertId:msg.fromUserAccount];
    if (isblack) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //                    [self showHint:@"已经被拉黑，不接收此人的消息"];
        });
    }else{
        if (!userInfo) {
            [self getTargetUserInfoWithUserId:msg.targetId];
        }
        NSInteger badgeValue = [DHMessageDao getBadgeValueWithTargetId:nil currentUserId:msg.userId];
        [UIApplication sharedApplication].applicationIconBadgeNumber = badgeValue;
        if (badgeValue) {
            [Mynotification postNotificationName:@"loadBadgeValue" object:nil];
        }
        [Mynotification postNotificationName:@"shouMessageToustView" object:msg];
        DHMsgPlaySound *sound = [[DHMsgPlaySound alloc]initSystemSoundWithName:nil SoundType:nil];
        [sound play];
    }
}

- (void)localNotification:(DHMessageModel *)message{
    
    [Mynotification postNotificationName:@"shouMessageToustView" object:message];
}
- (void)getTargetUserInfoWithUserId:(NSString *)userId{
    [HttpOperation asyncGetUserInfoWithUserId:userId queue:dispatch_get_main_queue() completed:^(NSDictionary *info, DHUserInfoModel *userInfoModel) {
        
    }];
}


@end
