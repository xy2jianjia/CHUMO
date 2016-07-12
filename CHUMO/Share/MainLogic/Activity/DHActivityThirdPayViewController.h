//
//  DHActivityThirdPayViewController.h
//  CHUMO
//
//  Created by xy2 on 16/6/21.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface DHActivityThirdPayViewController : UIViewController
@property (nonatomic,strong)NSString *payMainCode;
@property (nonatomic,strong)NSString *payComboType;
@property (nonatomic,strong)MBProgressHUD *HUD;

@property (nonatomic,strong) NSArray *goodInfoArr;
@end
