//
//  NextView.h
//  StrangerChat
//
//  Created by zxs on 15/11/27.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NextView : UIView{
    
    UIView *allView;
    UILabel *upLine;
    UILabel *downLine;
    UILabel *photo;
    UILabel *verificat;
    
    UIView *fristView;
    UIView *secondView;
    
}

@property (nonatomic,strong)UIButton *obtain; // 获取验证
@property (nonatomic,strong)UITextField *photoNum;
@property (nonatomic,strong)UITextField *verification;  // 验证ma
@property (nonatomic,strong)UIButton *seconds;
@property (nonatomic,strong)UIButton *submitButton;

- (void)addWithphoto:(NSString *)phototext verificat:(NSString *)verification;
@end
