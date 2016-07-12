//
//  TempHFController.h
//  StrangerChat
//
//  Created by zxs on 16/1/7.
//  Copyright © 2016年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UIImageView+Tool.h"

@interface TempHFController : UIViewController
@property (nonatomic,strong)NSString *urlWeb;
@property (nonatomic,strong)NSMutableDictionary *dicts;
@property (nonatomic,strong)MBProgressHUD *HUD;
@end
