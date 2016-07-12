//
//  NextView.m
//  StrangerChat
//
//  Created by zxs on 15/11/27.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "NextView.h"

@implementation NextView

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
    
    
    _photoNum = [[UITextField alloc] init];
    _photoNum.placeholder = @"请输入手机号码";
    _photoNum.clearButtonMode =  UITextFieldViewModeAlways;
    _photoNum.keyboardType = UIKeyboardTypeNumberPad;
    _photoNum.returnKeyType = UIReturnKeyDone;
    _photoNum.textAlignment = NSTextAlignmentLeft;
    _photoNum.font = [UIFont systemFontOfSize:got(12.0f)];
    [fristView addSubview:_photoNum];
    
    _verification = [[UITextField alloc] init];
    _verification.placeholder = @"请输入验证码";
    _verification.clearButtonMode =  UITextFieldViewModeAlways;
    _verification.keyboardType = UIKeyboardTypeNumberPad;
    _verification.returnKeyType = UIReturnKeyDone;
    _verification.textAlignment = NSTextAlignmentLeft;
    _verification.font = [UIFont systemFontOfSize:13.0f];
    [secondView addSubview:_verification];
    
    
    _obtain = [[UIButton alloc] init];
    [_obtain.layer setMasksToBounds:true];
    [_obtain.layer setCornerRadius:36.0/2];
    [_obtain setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _obtain.titleLabel.font = [UIFont fontWithName:Typeface size:13.0f];
    _obtain.backgroundColor = MainBarBackGroundColor;
    [fristView addSubview:_obtain];
    
//    upLine = [[UILabel alloc] init];
//    upLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
//    [allView addSubview:upLine];
    
//    downLine = [[UILabel alloc] init];
//    downLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
//    [allView addSubview:downLine];
    
    _seconds = [[UIButton alloc] init];
    [_seconds.layer setMasksToBounds:true];
    [_seconds.layer setCornerRadius:36.0/2];
    [_seconds setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _seconds.titleLabel.font = [UIFont fontWithName:Typeface size:12.0f];
    _seconds.backgroundColor = MainBarBackGroundColor;
    [fristView addSubview:_seconds];
    
    
    self.submitButton = [[UIButton alloc]init];
    self.submitButton.backgroundColor=MainBarBackGroundColor;
    self.submitButton.layer.cornerRadius=20;
    [self.submitButton setTitle:@"下一步" forState:(UIControlStateNormal)];
    self.submitButton.layer.masksToBounds=YES;
    [self addSubview:self.submitButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    allView.frame = CGRectMake(0, 0, self.bounds.size.width, 130);
    fristView.frame=CGRectMake(got(35), 30, ScreenWidth-got(70), 40);
    secondView.frame=CGRectMake(got(35), CGRectGetMaxY(fristView.frame)+20, ScreenWidth-got(70), 40);
    self.submitButton.frame=CGRectMake(got(35), CGRectGetMaxY(allView.frame)+20, ScreenWidth-got(70), 40);
    
    _photoNum.frame = CGRectMake(15,5, got(110), 30);
    _verification.frame = CGRectMake(15,5, 150, 30);
    _obtain.frame = CGRectMake(fristView.bounds.size.width - 100 - 2, 2, 100, 36);
//    upLine.frame = CGRectMake(15, 89.5, self.bounds.size.width, 0.5);
//    downLine.frame = CGRectMake(15, 179.5, self.bounds.size.width, 0.5);
    
}

- (void)addWithphoto:(NSString *)phototext verificat:(NSString *)verification {

    photo.text = phototext;
    verificat.text = verification;
}

@end
