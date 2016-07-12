//
//  YS_HtmlPayViewController.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/4/20.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UIImageView+Tool.h"

@interface YS_HtmlPayViewController : UIViewController
@property (nonatomic,strong)MBProgressHUD *HUD;
@property (nonatomic,strong)NSString *urlWeb;
@property (nonatomic,strong)NSString *payMainCode;
@property (nonatomic,strong)NSString *payComboType;
@end
