//
//  NResetController.h
//  StrangerChat
//
//  Created by zxs on 15/11/27.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
#define COUNTDOWN 30
@interface NResetController : UIViewController
/**
 *  短信类型，1、注册，2、修改密码，3、绑定手机
 */
@property (nonatomic,copy) NSString *msgType;
/**
 *  是否来自登录页面，由于登录页面没有导航条
 */
@property (nonatomic ,assign) BOOL isFromLoginVc;

@end
