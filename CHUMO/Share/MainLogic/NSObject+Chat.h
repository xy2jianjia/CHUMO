//
//  NSObject+Chat.h
//  CHUMO
//
//  Created by xy2 on 16/5/4.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString * const NEW_DIDRECEIVE_ONLINE_MESSAGE_NOTIFICATION = @"NEW_DIDRECEIVE_ONLINE_MESSAGE_NOTIFICATION";
static NSString * const NEW_DIDRECEIVE_OFFLINE_MESSAGE_NOTIFICATION = @"NEW_DIDRECEIVE_OFFLINE_MESSAGE_NOTIFICATION";
@interface NSObject (Chat)
/**
 *  入口，注册通知中心 2016年05月04日16:37:05 --by大海
 */
- (void)registerChatNotification;
@end
