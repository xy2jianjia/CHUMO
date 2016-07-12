//
//  DHAlertView.m
//  CHUMO
//
//  Created by xy2 on 16/2/22.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHAlertView.h"

@implementation DHAlertView

-(instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)configAlertWithAlertTitle:(NSString *)alertTitle alertContent:(NSString *)alertContent;{
    
    
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    self.frame = [[UIScreen mainScreen] bounds];
    self.tag=2000;
    
    self.bgAlphaView = [[UIView alloc]init];
    self.bgAlphaView.layer.cornerRadius=5;
    self.bgAlphaView.layer.masksToBounds=YES;
    _bgAlphaView.frame = CGRectMake(20, CGRectGetMidY([[UIScreen mainScreen] bounds])-100, ScreenWidth-40, 160);
    _bgAlphaView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    [self addSubview:_bgAlphaView];
    // 头部背景
    self.topImageView = [[UIImageView alloc]init];
    _topImageView.frame = CGRectMake(CGRectGetMidX(_bgAlphaView.bounds)-55/2, CGRectGetMinY(_bgAlphaView.frame)-55/2, 55, 55);
    self.topImageView.centerX=_bgAlphaView.centerX;
    _topImageView.image = [UIImage imageNamed:@"w_tc_icon.png"];
    [self addSubview:_topImageView];
    
    // title
    self.titleLabel = [[UILabel alloc]init];
    _titleLabel.frame = CGRectMake(CGRectGetMinX(_bgAlphaView.bounds), 55/2+12, CGRectGetWidth(_bgAlphaView.bounds), 40);
//    titleLabel.backgroundColor = [UIColor yellowColor];
    _titleLabel.text = alertTitle;
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_bgAlphaView addSubview:_titleLabel];
    
    // 内容
    self.contentLabel = [[UILabel alloc]init];
    _contentLabel.frame = CGRectMake(CGRectGetMinX(_bgAlphaView.bounds)+10, CGRectGetMaxY(_titleLabel.frame), CGRectGetWidth(_bgAlphaView.bounds)-20, 50);
    _contentLabel.font = [UIFont systemFontOfSize:13];
    _contentLabel.numberOfLines = 0;
    _contentLabel.textAlignment = NSTextAlignmentCenter;
//    _contentLabel.backgroundColor = [UIColor lightGrayColor];
    _contentLabel.text = alertContent;
//    @"温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示";
    _contentLabel.textColor = HexRGB(0x666666);
    [_bgAlphaView addSubview:_contentLabel];
    
//    self.lineView = [[UIView alloc]init];
//    _lineView.frame = CGRectMake(CGRectGetMinX(_bgAlphaView.bounds), CGRectGetMaxY(_contentLabel.frame)+10, CGRectGetWidth(_bgAlphaView.bounds), 1);
//    _lineView.backgroundColor = HexRGB(0xe0e0e0);
//    [self.bgAlphaView addSubview:_lineView];
    
    // 取消按钮
    self.cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _cancelBtn.frame = CGRectMake(CGRectGetMinX(_bgAlphaView.bounds), CGRectGetMaxY(_contentLabel.frame), CGRectGetWidth(_bgAlphaView.bounds)/2.0-0.5, 40);
    [_cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [_cancelBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
//    _cancelBtn.backgroundColor = [UIColor yellowColor];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _cancelBtn.layer.masksToBounds = YES;
    _cancelBtn.layer.borderWidth = 0.5;
    _cancelBtn.layer.borderColor = HexRGB(0xe0e0e0).CGColor;
//    _cancelBtn.titleLabel.textColor = [UIColor grayColor];
    [_cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    _cancelBtn.tag = 0;
    [_bgAlphaView addSubview:_cancelBtn];
    
    // 确定按钮
    self.sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _sureBtn.frame = CGRectMake(CGRectGetMaxX(_cancelBtn.frame)+0.5, CGRectGetMinY(_cancelBtn.frame), CGRectGetWidth(_cancelBtn.frame), CGRectGetHeight(_cancelBtn.frame));
    [_sureBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [_sureBtn setTitleColor:HexRGB(0x934ce5) forState:(UIControlStateNormal)];
//    _sureBtn.backgroundColor = [UIColor greenColor];
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.layer.borderWidth = 0.5;
    _sureBtn.layer.borderColor = HexRGB(0xe0e0e0).CGColor;
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    _sureBtn.titleLabel.textColor = HexRGB(0xf86666);
    [_sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    _sureBtn.tag = 1;
    [_bgAlphaView addSubview:_sureBtn];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat hight = [self hightForContent:_contentLabel.text fontSize:13];
    CGRect tempContentframe = self.contentLabel.frame;
    tempContentframe.size.height = hight;
    self.contentLabel.frame = tempContentframe;
    
//    CGRect lineViewFrame = _lineView.frame;
//    lineViewFrame.origin.y = CGRectGetMaxY(_contentLabel.frame)+15;
//    _lineView.frame = lineViewFrame;
    
    if (!MyJudgeNull(self.Btnnumber)  ) {
        
        CGRect cancelBtnFrame = self.cancelBtn.frame;
        cancelBtnFrame.origin.y = CGRectGetMaxY(_contentLabel.frame)+15;
        cancelBtnFrame.size.width=0;
        self.cancelBtn.frame = cancelBtnFrame;
        
        CGRect sureBtnFrame = self.sureBtn.frame;
        sureBtnFrame.origin.y = CGRectGetMinY(self.cancelBtn.frame);
        sureBtnFrame.origin.x = CGRectGetMinX(self.cancelBtn.frame);
        sureBtnFrame.size.width = CGRectGetWidth(_bgAlphaView.bounds);
        self.sureBtn.frame = sureBtnFrame;
    }else{
        CGRect cancelBtnFrame = self.cancelBtn.frame;
        cancelBtnFrame.origin.y = CGRectGetMaxY(_contentLabel.frame)+15;
        self.cancelBtn.frame = cancelBtnFrame;
        
        
        CGRect sureBtnFrame = self.sureBtn.frame;
        sureBtnFrame.origin.y = CGRectGetMinY(self.cancelBtn.frame);
        self.sureBtn.frame = sureBtnFrame;
    }
    
    
    CGRect temp = _bgAlphaView.frame;
    temp.size.height = CGRectGetHeight(_topImageView.frame)/2+12+CGRectGetHeight(_contentLabel.frame) + CGRectGetHeight(_cancelBtn.frame)+CGRectGetHeight(_titleLabel.frame)+15;
    _bgAlphaView.frame = temp;
    
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UITouch *touch=[touches anyObject];
//    if (2000==[touch.view tag]) {
//        [self removeFromSuperview];
//    }
//}
- (void)cancelBtnAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(alertView:onClickBtnAtIndex:)]) {
        [self.delegate alertView:self onClickBtnAtIndex:sender.tag];
    }
    [self disMiss];
}
- (void)sureBtnAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(alertView:onClickBtnAtIndex:)]) {
        [self.delegate alertView:self onClickBtnAtIndex:sender.tag];
    }
    [self disMiss];
}
//- (void)alertView:(DHAlertView *)alertView onClickBtnAtIndex:(NSInteger )index{
//    if (index == 0) {
//        
//    }else if (index == 1){
//        if ([self.delegate respondsToSelector:@selector(alertView:onClickBtnAtIndex:)]) {
//            [self.delegate alertView:alertView onClickBtnAtIndex:index];
//        }
//    }
//   
//}

- (void)disMiss{
    for (UIView *subView in self.bgAlphaView.subviews) {
        [subView removeFromSuperview];
    }
    [self.bgAlphaView removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark ---- 自适应高度
- (CGFloat)hightForContent:(NSString *)content fontSize:(CGFloat)fontSize{
    CGSize size = [content boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size.height;
}
@end
