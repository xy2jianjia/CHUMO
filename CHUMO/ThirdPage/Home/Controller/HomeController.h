//
//  HomeController.h
//  微信
//
//  Created by Think_lion on 15-6-14.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHMsgPlaySound.h"
@interface HomeController : UITableViewController
//存放聊天最后一段信息的数组
@property(nonatomic,strong) NSMutableArray *chatData;
/**
 *  消息数组，从viewcontroller传过来
 */
@property(nonatomic,strong) NSMutableArray *chatDataArr;

@end
