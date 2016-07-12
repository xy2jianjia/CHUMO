//
//  NewPasswrodController.h
//  StrangerChat
//
//  Created by zxs on 15/11/28.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPasswrodController : UIViewController
/**
 *  验证码
 */
@property (nonatomic,copy) NSString *verifyCode;
/**
 *  电话号码
 */
@property (nonatomic,copy) NSString *phoneNumber;
@end
