//
//  DHGroupButtonsView.m
//  CHUMO
//
//  Created by xy2 on 16/6/27.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHGroupButtonsView.h"

@implementation DHGroupButtonsView

+ (DHGroupButtonsView *)configActivityAlertViewInView:(UIView *)inView delegate:(id <DHGroupButtonsViewDelegate>)delegate {
    
    return [[[DHGroupButtonsView alloc]initWithFrame:CGRectMake(ScreenWidth/2, ScreenHeight/2, 0, 0)] configActivityAlertViewInView:inView delegate:delegate ];
    
}
- (DHGroupButtonsView *)configActivityAlertViewInView:(UIView *)inView delegate:(id <DHGroupButtonsViewDelegate>)delegate {
    
    self.delegate = delegate;
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 12.5;
    UIView *bgView = [[UIView alloc]initWithFrame:inView.bounds];
    UIImage *image = nil;
    if(iPhone5){
        image=[UIImage imageNamed:@"w_denglu_bg5"];
    }else if(iPhone4){
        image=[UIImage imageNamed:@"w_denglu_bg4"];
    }else {
        image=[UIImage imageNamed:@"w_denglu_bg"];
    }
    bgView.backgroundColor = [UIColor colorWithPatternImage:[image stretchableImageWithLeftCapWidth:30 topCapHeight:30]];
    //微信
    if ([WXApi isWXAppInstalled]) {
        // 设置frame位置
        if (iPhone6 || iPhonePlus) {
            self.frame = CGRectMake(52.5, 201, inView.bounds.size.width-105, 35+40+20+40+36+20+10);
        }else if (iPhone4 || iPhone5){
            self.frame = CGRectMake(30, 100, inView.bounds.size.width-60, 35+40+20+40+36+20+10);
        }else{
            self.frame = CGRectMake(52.5, 201, inView.bounds.size.width-105, 35+40+20+40+36+20+10);
        }
    }else{
        // 设置frame位置
        if (iPhone6 || iPhonePlus) {
            self.frame = CGRectMake(52.5, 201, inView.bounds.size.width-105, 35+40+20+36+20+10);
        }else if (iPhone4 || iPhone5){
            self.frame = CGRectMake(30, 100, inView.bounds.size.width-60, 35+40+20+36+20+10);
        }else{
            self.frame = CGRectMake(52.5, 201, inView.bounds.size.width-105, 35+40+20+36+20+10);
        }
    }
    
    
    UIButton *qqBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    qqBtn.frame = CGRectMake(CGRectGetMinX(self.bounds)+37.5, CGRectGetMinY(self.bounds)+35, CGRectGetWidth(self.bounds)-75.0, 40);
    qqBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [qqBtn setImage:[UIImage imageNamed:@"w_denglu_qq"] forState:(UIControlStateNormal)];
    [qqBtn setTitle:@"   QQ登录" forState:(UIControlStateNormal)];
//    qqBtn.layer.borderWidth = 0.5;
    [qqBtn setTitleColor:kUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
    [qqBtn setBackgroundColor:kUIColorFromRGB(0x448fd0)];
//    qqBtn.layer.borderColor = [UIColor blackColor].CGColor;
    qqBtn.layer.cornerRadius=5;
    qqBtn.layer.masksToBounds=YES;
    [qqBtn addTarget:self action:@selector(qqBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    qqBtn.tag = 1000;
    [self addSubview:qqBtn];
    
    // 一键注册图片
    UIImageView *regimageV = [[UIImageView alloc]init];
    //微信
    if ([WXApi isWXAppInstalled]) {
        //微信按钮
        UIButton *loginwxBut=[UIButton buttonWithType:(UIButtonTypeCustom)];
        loginwxBut.frame=CGRectMake(CGRectGetMinX(qqBtn.frame), CGRectGetMaxY(qqBtn.frame)+20, CGRectGetWidth(qqBtn.frame), CGRectGetHeight(qqBtn.frame));
        [loginwxBut addTarget:self action:@selector(qqBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [loginwxBut setTitleColor:kUIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        [loginwxBut setImage:[UIImage imageNamed:@"w_denglu_weixin"] forState:(UIControlStateNormal)];
        [loginwxBut setTitle:@"   微信登录" forState:(UIControlStateNormal)];
        loginwxBut.titleLabel.font=[UIFont systemFontOfSize:13.0f];
        [loginwxBut setBackgroundColor:kUIColorFromRGB(0x66ab14)];
        loginwxBut.layer.cornerRadius=5;
        loginwxBut.layer.masksToBounds=YES;
        loginwxBut.tag = 1001;
        [self addSubview:loginwxBut];
    
        regimageV.frame = CGRectMake(CGRectGetMinX(qqBtn.frame), CGRectGetMaxY(loginwxBut.frame)+36, 24, 24);
    }else{
        regimageV.frame = CGRectMake(CGRectGetMinX(qqBtn.frame), CGRectGetMaxY(qqBtn.frame)+36, 24, 24);
        
    }
    regimageV.image = [UIImage imageNamed:@"w_denglu_yjzc.png"];
    [self addSubview:regimageV];
    // 一键注册按钮
    UIButton *regBtn=[UIButton buttonWithType:(UIButtonTypeCustom)];
    regBtn.frame=CGRectMake(CGRectGetMaxX(regimageV.frame)+5, CGRectGetMinY(regimageV.frame), (CGRectGetWidth(qqBtn.frame)-25-48)/2.0, CGRectGetHeight(regimageV.frame));
    [regBtn addTarget:self action:@selector(qqBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [regBtn setTitle:@"一键注册" forState:(UIControlStateNormal)];
    regBtn.titleLabel.font=[UIFont systemFontOfSize:12.0f];
    [regBtn setTitleColor:kUIColorFromRGB(0x934de5) forState:(UIControlStateNormal)];
    regBtn.tag = 1002;
    [self addSubview:regBtn];
    
    // 登录图片
    UIImageView *loginImageV = [[UIImageView alloc]init];
    loginImageV.frame = CGRectMake(CGRectGetMaxX(regBtn.frame)+10, CGRectGetMinY(regBtn.frame), CGRectGetWidth(regimageV.frame), CGRectGetHeight(regimageV.frame));
    loginImageV.image = [UIImage imageNamed:@"w_denglu_zh.png"];
    [self addSubview:loginImageV];
    
    // 登录按钮
    UIButton *loginBtn=[UIButton buttonWithType:(UIButtonTypeCustom)];
    loginBtn.frame=CGRectMake(CGRectGetMaxX(loginImageV.frame)+5, CGRectGetMinY(loginImageV.frame), CGRectGetWidth(regBtn.frame), CGRectGetHeight(regBtn.frame));
    [loginBtn addTarget:self action:@selector(qqBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [loginBtn setTitle:@"账号登录" forState:(UIControlStateNormal)];
    loginBtn.titleLabel.font=[UIFont systemFontOfSize:12.0f];
    //    [regBtn setBackgroundColor:kUIColorFromRGB(0x934de5)];
//    [loginBtn setTintColor:kUIColorFromRGB(0x934de5)];
    [loginBtn setTitleColor:kUIColorFromRGB(0x934de5) forState:(UIControlStateNormal)];
    loginBtn.tag = 1003;
    [self addSubview:loginBtn];
    
    [bgView addSubview:self];
    [inView addSubview:bgView];
    return self;
}
- (void)qqBtnAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickedButtonWithButton:tag:)]) {
        [self.delegate onClickedButtonWithButton:sender tag:sender.tag];
    }
    
}




@end
