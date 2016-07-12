//
//  AllRegular.h
//  StrangerChat
//
//  Created by zxs on 15/12/18.
//  Copyright © 2015年 long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NResetController.h"
@interface AllRegular : NSObject

#pragma mark --- 邮箱正则
+ (BOOL) validateEmail:(NSString *)email;
#pragma mark --- 手机正则
+ (BOOL) validateMobile:(NSString *)mobile;
+ (void)updatehasCarWithDict:(NSString *)interger;
+ (NSString *)getInterger;

@end
