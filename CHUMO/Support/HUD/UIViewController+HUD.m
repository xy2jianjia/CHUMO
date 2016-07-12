//
//  UIViewController+HUD.m
//  XDHoHo
//
//  Created by Li Zhiping on 13-12-21.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "UIViewController+HUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>
#import "UIImageView+Tool.h"

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

#ifndef BussinessLink_MacroUtil_h
#define BussinessLink_MacroUtil_h

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#endif


@implementation UIViewController (HUD)

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.labelText = hint;
    HUD.labelFont=[UIFont systemFontOfSize:10];
    HUD.mode=MBProgressHUDModeCustomView;
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.frame = CGRectMake(0, 0, 50, 50);
    
    NSURL * url = [[NSURL alloc]initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"loading.gif" ofType:nil]];
    [imageV yh_setImage:url];
    imageV.animationDuration = 1.5; //执行一次完整动画所需的时长
    imageV.animationRepeatCount = 0;  //动画重复次数
    [imageV startAnimating];
    HUD.customView=imageV;
    [view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
}

- (void)showHint:(NSString *)hint{
    
    if ([hint isEqualToString:@"录音时间过短，没办法记录"]) {
        if (![self isChinaLanguage]) {
            hint = @"no way to record";
        }
        
    }else if ([hint isEqualToString:@"录音没有开始"]){
        if (![self isChinaLanguage]) {
            hint = @"Recording not beginning";
        }
    }
    
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = IS_IPHONE_5?200.f:150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)hideHud{
    [[self HUD] hide:YES];
}
- (BOOL)isChinaLanguage

{
    BOOL flag = NO ;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    
    if ([preferredLang isEqualToString:@"zh-Hans"]) {
        flag = YES;
    }
    
    return flag;
}

@end
