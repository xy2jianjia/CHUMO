//
//  YS_SelfMailPayViewController.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/6/30.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "JYNavigationController.h"

@interface YS_SelfMailPayViewController : UIViewController
@property (nonatomic,strong)NSString *payMainCode;
@property (nonatomic,strong)NSString *payComboType;
@property (nonatomic,strong)MBProgressHUD *HUD;
//导航条
@property (nonatomic,strong)JYNavigationController *nav;
@end
