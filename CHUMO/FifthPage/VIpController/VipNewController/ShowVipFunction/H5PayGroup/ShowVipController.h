//
//  ShowVipController.h
//  StrangerChat
//
//  Created by zxs on 16/1/9.
//  Copyright © 2016年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UIImageView+Tool.h"
@interface ShowVipController : UIViewController
@property (nonatomic,strong)NSString *showUrl;
@property (nonatomic,strong)NSDictionary *dicts;
@property (nonatomic,strong)NSString * number;
@property (nonatomic,strong)MBProgressHUD *HUD;
@end
