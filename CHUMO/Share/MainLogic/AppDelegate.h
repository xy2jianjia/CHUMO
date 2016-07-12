//
//  AppDelegate.h
//  StrangerChat
//
//  Created by long on 15/10/2.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NResetController.h"
#import "WXApi.h"
//#import "EaseMob.h"



// 环信appkey
# define EASEMOD_APPKEY @"yooshang#chumo1919"
//# define EASEMOD_APPKEY  @"easemob-demo#chatdemoui"
// 推送证书名字，需要等到证书下来
# define EASEMOD_APP_CER @"chatdemoui_dev"


#define APP_ID @"wx1b389c3a19f8062b"
#define APP_SECRET @"0273238049886e0a164bdbd1ccf118d7"

//chatdemoui
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *openid;
@property (strong, nonatomic) NSString *nickname; // 用户昵称
@property (strong, nonatomic) NSString *headimgurl; // 用户头像地址

@end

