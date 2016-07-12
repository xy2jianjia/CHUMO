//
//  UserGuidedTwo.h
//  CHUMO
//
//  Created by zxs on 16/2/19.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserGuidedTwo : UIViewController
@property (nonatomic, strong) NSString *sex;
@property (nonatomic,assign)NSInteger otherSum;//头像选中的数量
/**
 *  是否来自注册页面
 */
@property (nonatomic,assign) BOOL isFromRegister;

@end
