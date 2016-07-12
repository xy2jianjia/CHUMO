//
//  DHRecommedViewV1.m
//  CHUMO
//
//  Created by xy2 on 16/6/23.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHRecommedViewV1.h"

@implementation DHRecommedViewV1
+ (void)configRecommendViewInView:(UIView *)inview userInfo:(DHUserInfoModel *)userInfo delelgate:(id<DHRecommedViewV1Delegate >)delegate isCity:(BOOL)isCity{
    [[[DHRecommedViewV1 alloc]initWithFrame:CGRectMake(ScreenWidth/2, ScreenHeight/2, 0, 0)] configRecommendViewInView:inview userInfo:userInfo delelgate:delegate isCity:isCity];
}
- (void)configRecommendViewInView:(UIView *)inview userInfo:(DHUserInfoModel *)userInfo delelgate:(id<DHRecommedViewV1Delegate >)delegate isCity:(BOOL)isCity{
    [self dismiss];
    self.delegate = delegate;
    self.userInfo = userInfo;
    self.frame = inview.bounds;
    UIView *bgview = [[UIView alloc]init];
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    [self addSubview:bgview];
    // 设置frame位置
    if (iPhone6 || iPhonePlus) {
        bgview.frame = CGRectMake(52.5, 164, self.bounds.size.width-105, 23+50+15+14+15+30+23);
        
    }else if (iPhone4 || iPhone5){
        bgview.frame = CGRectMake(30, 164, self.bounds.size.width-60, 23+50+15+14+15+30+23);
    }else{
        bgview.frame = CGRectMake(52.5, 164, self.bounds.size.width-105,23+50+15+14+15+30+23);
    }
    
    // 背景图
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.frame = bgview.bounds;
    if (isCity) {
        imageV.image = [[UIImage imageNamed:@"w_tc_tvtj_bg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    }else{
        imageV.image = [[UIImage imageNamed:@"w_tc_qgtj_bg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    }
    imageV.userInteractionEnabled = YES;
    [bgview addSubview:imageV];
    
    // 头像
    UIImageView *portaitImageV = [[UIImageView alloc]init];
    portaitImageV.frame = CGRectMake(23, 23, 50, 50);
    portaitImageV.contentMode = UIViewContentModeScaleAspectFill;
    [portaitImageV sd_setImageWithURL:[NSURL URLWithString:userInfo.b57] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
    portaitImageV.clipsToBounds = YES;
    portaitImageV.layer.masksToBounds = YES;
    portaitImageV.layer.cornerRadius = 25;
    [imageV addSubview:portaitImageV];
    
    // 名字label
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.frame = CGRectMake(CGRectGetMaxX(portaitImageV.frame)+15, CGRectGetMinY(portaitImageV.frame)+3, CGRectGetWidth(bgview.bounds)-23-50-15, 14);
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.text = [userInfo.b52 length] == 0?@"":userInfo.b52;
    nameLabel.textColor = kUIColorFromRGB(0x323232);
    [imageV addSubview:nameLabel];
    
    if (isCity) {
        
        // 同城标志
        UIImageView *localImageV = [[UIImageView alloc]init];
        localImageV.frame = CGRectMake(CGRectGetMaxX(portaitImageV.frame)+15, CGRectGetMaxY(nameLabel.frame)+8, 16, 16);
        localImageV.image = [UIImage imageNamed:@"w_tc_tvtj_dibiao.png"];
        [imageV addSubview:localImageV];
        // 距离label
        UILabel *rangeLabel = [[UILabel alloc]init];
        rangeLabel.frame = CGRectMake(CGRectGetMaxX(localImageV.frame)+5, CGRectGetMinY(localImageV.frame), ScreenWidth-23-50-15-16-5, CGRectGetHeight(localImageV.frame));
        rangeLabel.font = [UIFont systemFontOfSize:14];
        rangeLabel.textColor = kUIColorFromRGB(0x323232);
        NSString *mile = userInfo.b94;
        NSString *range = nil;
        if ([mile floatValue] == 0.0) {
            range = @"1km";
        }else{
            range = [NSString stringWithFormat:@"%.2fkm",[mile floatValue]/1000];
        }
        rangeLabel.text = [NSString stringWithFormat:@"%@",range];
        [imageV addSubview:rangeLabel];
    }else{
        if (!([userInfo.b37 isEqualToString:@"(null)"] || [userInfo.b37 length] >0 )) {
            // b37 b24  特征和爱好
            NSDictionary *kidneyDict = nil;
            if ([userInfo.b69 integerValue] == 1) {// 男
                kidneyDict = [NSGetSystemTools getkidney1];
            }else{
                kidneyDict = [NSGetSystemTools getkidney2];
            }
            NSString *b37 = [kidneyDict objectForKey:[NSString stringWithFormat:@"%@",userInfo.b37]];
            if (b37) {
                // 个性特征label
                UILabel *characterLabel = [[UILabel alloc]init];
                characterLabel.frame = CGRectMake(CGRectGetMaxX(portaitImageV.frame)+15, CGRectGetMaxY(nameLabel.frame)+8, 55, 22);
                characterLabel.font = [UIFont systemFontOfSize:12];
                characterLabel.text = @"甜软萌";
                characterLabel.textColor = kUIColorFromRGB(0x934de6);
                characterLabel.layer.borderWidth = 0.5;
                characterLabel.layer.borderColor = kUIColorFromRGB(0x934de6).CGColor;
                characterLabel.layer.cornerRadius = 10;
                characterLabel.layer.masksToBounds = YES;
                characterLabel.textAlignment = NSTextAlignmentCenter;
                [imageV addSubview:characterLabel];
            }
        }
        
    }
    // 问题label
    UILabel *questionLabel = [[UILabel alloc]init];
    questionLabel.frame = CGRectMake(0 , CGRectGetMaxY(portaitImageV.frame)+15, CGRectGetWidth(bgview.bounds), 14);
    questionLabel.font = [UIFont systemFontOfSize:13];
    questionLabel.text = [userInfo.b14 length] == 0?@"":userInfo.b14;
    questionLabel.textColor = kUIColorFromRGB(0x666666);
    questionLabel.textAlignment = NSTextAlignmentCenter;
    [imageV addSubview:questionLabel];
    
    
    // 回答按钮2
    UIButton *midBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    midBtn.frame = CGRectMake(CGRectGetMidX(bgview.bounds)-32.5, CGRectGetMaxY(questionLabel.frame)+15, 65, 30);
    midBtn.backgroundColor = kUIColorFromRGB(0x91c8f0);
    midBtn.layer.cornerRadius = 10;
    midBtn.layer.masksToBounds = YES;
    //    [midBtn setTitle:@"还可以" forState:(UIControlStateNormal)];
    [midBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    midBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [midBtn addTarget:self action:@selector(answerBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    midBtn.tag = 1001;
    [imageV addSubview:midBtn];
    
    // 回答按钮1
    UIButton *leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    leftBtn.frame = CGRectMake(CGRectGetMinX(midBtn.frame)-20-65, CGRectGetMinY(midBtn.frame), CGRectGetWidth(midBtn.frame), CGRectGetHeight(midBtn.frame));
    leftBtn.backgroundColor = kUIColorFromRGB(0x77ddd9);
    leftBtn.layer.cornerRadius = 10;
    leftBtn.layer.masksToBounds = YES;
//    [leftBtn setTitle:@"赶紧躲" forState:(UIControlStateNormal)];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftBtn addTarget:self action:@selector(answerBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    leftBtn.tag = 1000;
    [imageV addSubview:leftBtn];
    
    
    // 回答按钮3
    UIButton *rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    rightBtn.frame = CGRectMake(CGRectGetMaxX(midBtn.frame)+20, CGRectGetMinY(midBtn.frame), CGRectGetWidth(midBtn.frame), CGRectGetHeight(midBtn.frame));
    rightBtn.backgroundColor = kUIColorFromRGB(0xb382ed);
    rightBtn.layer.cornerRadius = 10;
    rightBtn.layer.masksToBounds = YES;
//    [rightBtn setTitle:@"很漂亮" forState:(UIControlStateNormal)];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightBtn addTarget:self action:@selector(answerBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    rightBtn.tag = 1002;
    [imageV addSubview:rightBtn];
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
        [leftBtn setTitle:title1 forState:(UIControlStateNormal)];
        [midBtn setTitle:title2 forState:(UIControlStateNormal)];
        [rightBtn setTitle:title3 forState:(UIControlStateNormal)];
    }
    
    [inview addSubview:self];
}
- (void)answerBtnAction:(UIButton *)sender{
    
    NSInteger tag = sender.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(recommendOnclickedAnswerBtnCalledBackWithBtnTag:targetUserInfo:)]) {
        [self.delegate recommendOnclickedAnswerBtnCalledBackWithBtnTag:tag targetUserInfo:_userInfo];
//        [self dismiss];
    }
    [self dismiss];
    
}
- (void)dismiss{
    [self removeFromSuperview];
    
}
@end
