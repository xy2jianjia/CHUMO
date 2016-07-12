//
//  YS_BindingThirdViewController.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/4/26.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    ThirdBindingEnumQQ=2,
    ThirdBindingEnumWX=1,
}ThirdBindingEnum;
@interface YS_BindingThirdViewController : UIViewController
@property (nonatomic,assign)NSInteger ThirdBindFlag;

@end
