//
//  PassView.m
//  StrangerChat
//
//  Created by zxs on 15/11/28.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "PassView.h"

@implementation PassView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self n_layOut];
    }
    return self;
}


- (void)n_layOut {
    
    
    allView = [[UIView alloc] init];
    allView.backgroundColor = [UIColor whiteColor];
    [self addSubview:allView];
    
    fristView=[[UIView alloc]init];
    fristView.backgroundColor=kUIColorFromRGB(0xffffff);
    fristView.layer.borderColor=kUIColorFromRGB(0x934ce5).CGColor;
    fristView.layer.borderWidth=0.5;
    fristView.layer.cornerRadius=20;
    fristView.layer.masksToBounds=YES;
    [allView addSubview:fristView];
    
    secondView=[[UIView alloc]init];
    secondView.backgroundColor=kUIColorFromRGB(0xffffff);
    secondView.layer.borderColor=kUIColorFromRGB(0x934ce5).CGColor;
    secondView.layer.borderWidth=0.5;
    secondView.layer.cornerRadius=20;
    secondView.layer.masksToBounds=YES;
    [allView addSubview:secondView];
    
//    photo = [[UILabel alloc] init];
//    photo.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
//    [allView addSubview:photo];
//    
//    verificat = [[UILabel alloc] init];
//    verificat.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
//    [allView addSubview:verificat];
    
    _photoNum = [[UITextField alloc] init];
    _photoNum.secureTextEntry = YES;
    _photoNum.placeholder = @"密码长度6~16位,由数字和字母组成";
    _photoNum.clearButtonMode =  UITextFieldViewModeAlways;
    _photoNum.keyboardType = UIKeyboardTypeASCIICapable;
    _photoNum.returnKeyType = UIReturnKeyDone;
    _photoNum.textAlignment = NSTextAlignmentLeft;
    _photoNum.font = [UIFont systemFontOfSize:13.0f];
    [fristView addSubview:_photoNum];
    
    _verification = [[UITextField alloc] init];
    _verification.secureTextEntry = YES;
    _verification.placeholder = @"再次输入密码";
    _verification.clearButtonMode =  UITextFieldViewModeAlways;
    _verification.keyboardType = UIKeyboardTypeASCIICapable;
    _verification.returnKeyType = UIReturnKeyDone;
    _verification.textAlignment = NSTextAlignmentLeft;
    _verification.font = [UIFont systemFontOfSize:13.0f];
    [secondView addSubview:_verification];
    
    
//    upLine = [[UILabel alloc] init];
//    upLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
//    [allView addSubview:upLine];
//    
//    downLine = [[UILabel alloc] init];
//    downLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
//    [allView addSubview:downLine];
    
    self.submitButton = [[UIButton alloc]init];
    self.submitButton.backgroundColor=MainBarBackGroundColor;
    self.submitButton.layer.cornerRadius=20;
    [self.submitButton setTitle:@"完成" forState:(UIControlStateNormal)];
    self.submitButton.layer.masksToBounds=YES;
    [self addSubview:self.submitButton];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    allView.frame = CGRectMake(0, 0, self.bounds.size.width, 130);
    fristView.frame=CGRectMake(got(35), 30, ScreenWidth-got(70), 40);
    secondView.frame=CGRectMake(got(35), CGRectGetMaxY(fristView.frame)+20, ScreenWidth-got(70), 40);
    self.submitButton.frame=CGRectMake(got(35), CGRectGetMaxY(allView.frame)+20, ScreenWidth-got(70), 40);
    
//    photo.frame = CGRectMake(15, 40, 55, 40);
//    verificat.frame = CGRectMake(15, 130, 85, 40);
    _photoNum.frame = CGRectMake(15,5, CGRectGetWidth(fristView.bounds)-30, 30);
    _verification.frame = CGRectMake(15,5, CGRectGetWidth(secondView.bounds)-30, 30);
    
//    upLine.frame = CGRectMake(15, 89.5, self.bounds.size.width, 0.5);
//    downLine.frame = CGRectMake(15, 179.5, self.bounds.size.width, 0.5);
    
}

- (void)addWithphoto:(NSString *)phototext verificat:(NSString *)verification {
    
    photo.text = phototext;
    verificat.text = verification;
}

@end
