//
//  DHCityRecommendView.m
//  CHUMO
//
//  Created by xy2 on 16/3/7.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHCityRecommendView.h"

@implementation DHCityRecommendView

+ (DHCityRecommendView *)shareInstanceWithUserInfo:(DHUserInfoModel *)userInfo delelgate:(id<DHCityRecommendDelegate >)delegate isCity:(BOOL)isCity{
    static DHCityRecommendView *instanceView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instanceView = [[DHCityRecommendView alloc]init];
        instanceView.delegate = delegate;
    });
    return [instanceView configSubViewsWithUserInfo:userInfo delelgate:delegate isCity:isCity];
}

+ (void)asyncConfigCityRecommendViewWithUserInfo:(DHUserInfoModel *)userInfo inView:(UIView *)inView delelgate:(id<DHCityRecommendDelegate >)delegate isCity:(BOOL)isCity{
    
    [inView addSubview:[DHCityRecommendView shareInstanceWithUserInfo:userInfo delelgate:delegate isCity:isCity] ];
}

- (DHCityRecommendView *)configSubViewsWithUserInfo:(DHUserInfoModel *)userInfo delelgate:(id<DHCityRecommendDelegate >)delegate isCity:(BOOL)isCity{
    self.userInfo = userInfo;
    self.alpha = 1;
    // 遮罩
//    if (!self.bgAlphaView) {
//        _bgAlphaView = [[UIView alloc]init];
//    }
//    _bgAlphaView.frame = [[UIScreen mainScreen] bounds];
////        _bgAlphaView.userInteractionEnabled = YES;
//    _bgAlphaView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//    [self addSubview:_bgAlphaView];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.frame = [[UIScreen mainScreen] bounds];
    // 背景
    if (!self.bgView) {
        _bgView = [[UIView alloc]init];
    }
    if (iPhone4) {
        _bgView.frame = CGRectMake(29.8, 69.1, ScreenWidth-29.8-43.5, ScreenHeight-69.1-71.96);
    }else if (iPhone5){
        _bgView.frame = CGRectMake(29.8, 81.9, ScreenWidth-29.8-43.5, ScreenHeight-81.9-85.2);
    }else{
        _bgView.frame = CGRectMake(35, 96, ScreenWidth-35-51, ScreenHeight-96-100);
    }
//        _bgView.userInteractionEnabled = YES;
    [self addSubview:_bgView];
    // 顶部图片
    if (!self.topImageV) {
        _topImageV = [[UIImageView alloc]init];
    }
    if (iPhone4) {
        _topImageV.frame = CGRectMake(0, 5, CGRectGetWidth(_bgView.bounds)-0, 89.95);
    }else if (iPhone5){
        _topImageV.frame = CGRectMake(0, 5, CGRectGetWidth(_bgView.bounds)-0, 106.44);
    }else{
        _topImageV.frame = CGRectMake(0, 5, CGRectGetWidth(_bgView.bounds)-0, 125);
    }
    
    if (isCity) {
        if ([userInfo.b69 integerValue] == 1) {
            _topImageV.image = [UIImage imageNamed:@"gift_blue_man.png"];
        }else{
            _topImageV.image = [UIImage imageNamed:@"gift_blue_girl.png"];
        }
    }else{
        if ([userInfo.b69 integerValue] == 1) {
            _topImageV.image = [UIImage imageNamed:@"gift-country-man.png"];
        }else{
            _topImageV.image = [UIImage imageNamed:@"gift-country-girl.png"];
        }
    }
    _topImageV.userInteractionEnabled = YES;
    [_bgView addSubview:_topImageV];
    
    // 头像背景
    if (!self.midMainView) {
        _midMainView = [[UIView alloc]init];
    }
    if (iPhone4) {
        _midMainView.frame = CGRectMake(CGRectGetMidX(_topImageV.frame)-89.90, CGRectGetMaxY(_topImageV.frame)+6, 192.42, 134.21);
    }else if (iPhone5){
        _midMainView.frame = CGRectMake(CGRectGetMidX(_topImageV.frame)-89.90, CGRectGetMaxY(_topImageV.frame)+6, 192.42, 158.82);
    }else{
        _midMainView.frame = CGRectMake(CGRectGetMidX(_topImageV.frame)-105.35, CGRectGetMaxY(_topImageV.frame)+6, 225.5, 186.5);
    }
    _midMainView.userInteractionEnabled = YES;
    [_bgView addSubview:_midMainView];
    // 头像
    if (!self.midHeaderImageV) {
        _midHeaderImageV = [[UIImageView alloc]init];
    }
    _midHeaderImageV.frame = _midMainView.bounds;
    _midHeaderImageV.layer.borderWidth = 2.0;
    if ([userInfo.b69 integerValue] == 1) {
        _midHeaderImageV.layer.borderColor = [UIColor colorWithRed:238/255.0 green:195/255.0 blue:23/255.0 alpha:1].CGColor;
    }else{
        _midHeaderImageV.layer.borderColor = HexRGB(0xf04d6d).CGColor;
    }
    
    _midHeaderImageV.contentMode = UIViewContentModeScaleAspectFill;
    _midHeaderImageV.clipsToBounds = YES;
    [_midHeaderImageV sd_setImageWithURL:[NSURL URLWithString:userInfo.b57] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
    _midHeaderImageV.userInteractionEnabled = YES;
    [_midMainView addSubview:_midHeaderImageV];
    
    // 用户信息label背景
    if (!self.labelBgView) {
        _labelBgView = [[UIView alloc]init];
    }
    _labelBgView.frame = CGRectMake(CGRectGetMinX(_midHeaderImageV.bounds), CGRectGetMaxY(_midHeaderImageV.bounds)-30, CGRectGetWidth(_midHeaderImageV.bounds), 30);
    _labelBgView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    _labelBgView.userInteractionEnabled = YES;
    [_midHeaderImageV addSubview:_labelBgView];
    
    NSString *mile = userInfo.b94;
    if ([mile isEqualToString:@"(null)"] || [mile length] == 0) {
        mile = nil;
    }else{
        // 距离label
        if (!self.spacingLabel) {
            _spacingLabel = [[UILabel alloc]init];
        }
        _spacingLabel.frame = CGRectMake(0, 0, CGRectGetWidth(_labelBgView.bounds)/3, CGRectGetHeight(_labelBgView.bounds));
        _spacingLabel.text = [NSString stringWithFormat:@"%.2f km",[mile floatValue]/1000];
        _spacingLabel.textColor = [UIColor whiteColor];
        _spacingLabel.textAlignment = NSTextAlignmentCenter;
        _spacingLabel.font = [UIFont systemFontOfSize:12];
        _spacingLabel.userInteractionEnabled = YES;
        [_labelBgView addSubview:_spacingLabel];
    }
    
    // 年龄label
    if (!self.ageLabel) {
        _ageLabel = [[UILabel alloc]init];
    }
    _ageLabel.frame = CGRectMake(CGRectGetMaxX(_spacingLabel.frame), 0, CGRectGetWidth(_labelBgView.bounds)/3, CGRectGetHeight(_labelBgView.bounds));
    if ([userInfo.b1 isEqualToString:@"(null)"] || [userInfo.b1 length] == 0) {
        _ageLabel.text = [NSString stringWithFormat:@"%@岁",@"18"];
    }else{
        _ageLabel.text = [NSString stringWithFormat:@"%@岁",userInfo.b1];
    }
    
    _ageLabel.textColor = [UIColor whiteColor];
    _ageLabel.textAlignment = NSTextAlignmentCenter;
    _ageLabel.font = [UIFont systemFontOfSize:12];
    _ageLabel.userInteractionEnabled = YES;
    [_labelBgView addSubview:_ageLabel];
    // 名字label
    if (!self.nameLabel) {
        _nameLabel = [[UILabel alloc]init];
    }
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_ageLabel.frame), 0, CGRectGetWidth(_labelBgView.bounds)/3, CGRectGetHeight(_labelBgView.bounds));
    if ([userInfo.b52 length] == 0 || [userInfo.b52 isEqualToString:@"(null)"]) {
        _nameLabel.text = [NSString stringWithFormat:@"%@",@""];
    }else{
        _nameLabel.text = [NSString stringWithFormat:@"%@",userInfo.b52];
    }
    
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = [UIFont systemFontOfSize:12];
    _nameLabel.userInteractionEnabled = YES;
    [_labelBgView addSubview:_nameLabel];
    // 交友意向
    if (!self.midPurposeImageV) {
        _midPurposeImageV = [[UIImageView alloc]init];
    }
    
    _midPurposeImageV.frame = CGRectMake(CGRectGetMaxX(_midHeaderImageV.bounds)-30, CGRectGetMaxY(_midHeaderImageV.bounds)-32, 47, 46);
    
    NSString *perposeCode = userInfo.b145;
    NSDictionary *tempDict = [NSGetSystemTools getpurpose];
    if ([[tempDict allKeys] containsObject:perposeCode]) {
        if ([userInfo.b69 integerValue] == 1) {
            _midPurposeImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"welfare-label-man-%@",perposeCode]];
        }else{
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"welfare-label-girl-%@",perposeCode]];
            _midPurposeImageV.image = image;
        }
    }
    _midPurposeImageV.userInteractionEnabled = YES;
    [_midMainView addSubview:_midPurposeImageV];
    // 底部背景
    if (!self.bottumBgView) {
        _bottumBgView = [[UIView alloc]init];
    }
    if (iPhone4) {
        _bottumBgView.frame = CGRectMake(CGRectGetMidX(_midMainView.frame)-114.35, CGRectGetMaxY(_midMainView.frame) + 16, 228.69, 80);
    }else if (iPhone5){
        _bottumBgView.frame = CGRectMake(CGRectGetMidX(_midMainView.frame)-114.35, CGRectGetMaxY(_midMainView.frame) + 16, 228.69, 80);
    }else{
        _bottumBgView.frame = CGRectMake(CGRectGetMidX(_midMainView.frame)-134, CGRectGetMaxY(_midMainView.frame) + 16, 268, 80);
    }
    _bottumBgView.userInteractionEnabled = YES;
    [_bgView addSubview:_bottumBgView];
    // 底部边框
    if (!self.bottumBorderImageView) {
        _bottumBorderImageView = [[UIImageView alloc]init];
    }
    _bottumBorderImageView.frame = _bottumBgView.bounds;
    _bottumBorderImageView.userInteractionEnabled = YES;
    _bottumBorderImageView.image = [UIImage imageNamed:@"writing_Base map_boy"];
    [_bottumBgView addSubview:_bottumBorderImageView];
    // 底部心形
    if (!self.bottumHeartImageView) {
        _bottumHeartImageView = [[UIImageView alloc]init];
    }
    if (iPhone4) {
        _bottumHeartImageView.frame = CGRectMake(CGRectGetMinX(_bottumBgView.bounds)+66.79, 12, 13.0, 10.5);
    }else if (iPhone5){
        _bottumHeartImageView.frame = CGRectMake(CGRectGetMinX(_bottumBgView.bounds)+66.79, 12, 13.0, 10.5);
    }else{
        _bottumHeartImageView.frame = CGRectMake(CGRectGetMinX(_bottumBgView.bounds)+90, 12, 13.0, 10.5);
    }
    _bottumHeartImageView.userInteractionEnabled = YES;
    _bottumHeartImageView.image = [UIImage imageNamed:@"Love-normal.png"];
    [_bottumBgView addSubview:_bottumHeartImageView];
    // 底部信息label
    if (!self.bottumInfoLabel) {
        _bottumInfoLabel = [[UILabel alloc]init];
    }
    _bottumInfoLabel.frame = CGRectMake(CGRectGetMaxX(_bottumHeartImageView.frame)+10, CGRectGetMinY(_bottumHeartImageView.frame), 120, CGRectGetHeight(_bottumHeartImageView.frame));
    _bottumInfoLabel.text = userInfo.b14;
    _bottumInfoLabel.font = [UIFont systemFontOfSize:12];
    _bottumInfoLabel.userInteractionEnabled = YES;
    [_bottumBgView addSubview:_bottumInfoLabel];
    
    if (!self.shakeImageV) {
        _shakeImageV = [[UIImageView alloc]init];
    }
    _shakeImageV.frame = CGRectMake(CGRectGetMidX(_bottumBorderImageView.bounds)-69.5, CGRectGetMaxY(_bottumInfoLabel.frame)+9, 139, 5.5);
    _shakeImageV.image = [UIImage imageNamed:@"Shading_Writing.png"];
    _shakeImageV.userInteractionEnabled = YES;
    [_bottumBorderImageView addSubview:_shakeImageV];
    // 躲远点
    if (!self.cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    }
    _cancelBtn.frame = CGRectMake(CGRectGetMinX(_bottumBgView.bounds)+13, CGRectGetMaxY(_bottumBgView.bounds)-36, (CGRectGetWidth(_bottumBgView.bounds)-26-32)/3, 26);
    [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"hide_girl.png"] forState:(UIControlStateNormal)];
   
    
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _cancelBtn.tag = 1000;
    [_cancelBtn addTarget:self action:@selector(selectedBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    _cancelBtn.userInteractionEnabled = YES;
    [_bottumBgView addSubview:_cancelBtn];
    // 还可以
    if (!self.alitleBitBtn) {
        _alitleBitBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    }
    _alitleBitBtn.frame = CGRectMake(CGRectGetMaxX(_cancelBtn.frame)+13, CGRectGetMinY(_cancelBtn.frame), CGRectGetWidth(_cancelBtn.frame), CGRectGetHeight(_cancelBtn.frame));
    [_alitleBitBtn setBackgroundImage:[UIImage imageNamed:@"so so_girl.png"] forState:(UIControlStateNormal)];
   
    _alitleBitBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _alitleBitBtn.tag = 1001;
    [_alitleBitBtn addTarget:self action:@selector(selectedBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    _alitleBitBtn.userInteractionEnabled = YES;
    [_bottumBgView addSubview:_alitleBitBtn];
    // 很漂亮
    if (!self.yesBtn) {
        _yesBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    }
    _yesBtn.frame = CGRectMake(CGRectGetMaxX(_alitleBitBtn.frame)+13, CGRectGetMinY(_alitleBitBtn.frame), CGRectGetWidth(_alitleBitBtn.frame), CGRectGetHeight(_alitleBitBtn.frame));
    [_yesBtn setBackgroundImage:[UIImage imageNamed:@"beautiful_girl.png"] forState:(UIControlStateNormal)];
    
    _yesBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _yesBtn.tag = 1002;
    [_yesBtn addTarget:self action:@selector(selectedBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    _yesBtn.userInteractionEnabled = YES;
    [_bottumBgView addSubview:_yesBtn];
    NSArray *arr1 = userInfo.answerArr;
    if (arr1.count >= 3) {
        
        NSString *title1 = nil;
        if ([[arr1[0] objectForKey:@"b14"] length] == 0 || [[arr1[0] objectForKey:@"b14"] isEqualToString:@"(null)"]) {
            title1 = @"";
        }else{
            title1 = [arr1[0] objectForKey:@"b14"];
        }
        NSString *title2 = nil;
        if ([[arr1[1] objectForKey:@"b14"] length] == 0 || [[arr1[1] objectForKey:@"b14"] isEqualToString:@"(null)"]) {
            title2 = @"";
        }else{
            title2 = [arr1[1] objectForKey:@"b14"];
        }
        NSString *title3 = nil;
        if ([[arr1[2] objectForKey:@"b14"] length] == 0 || [[arr1[2] objectForKey:@"b14"] isEqualToString:@"(null)"]) {
            title3 = @"";
        }else{
            title3 = [arr1[2] objectForKey:@"b14"];
        }
        [_cancelBtn setTitle:title1 forState:(UIControlStateNormal)];
        [_alitleBitBtn setTitle:title2 forState:(UIControlStateNormal)];
        [_yesBtn setTitle:title3 forState:(UIControlStateNormal)];
    }
    return self;
}
- (void) selectedBtnAction:(UIButton *)sender{
    
    NSInteger tag = sender.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickedBtnWithTag:targetUserinfo:)]) {
        [self.delegate onClickedBtnWithTag:tag targetUserinfo:_userInfo];
        [self dismiss];
    }
    [self dismiss];
//    if (tag == 1000) {
//        [self dismiss];
//    }else{
//        
//    }
    
}
- (void)dismiss{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect temp = self.bgView.frame;
        temp.origin.y = -(temp.origin.y + temp.size.height);
        self.bgView.frame = temp;
        self.alpha = 0;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
    
}
@end
