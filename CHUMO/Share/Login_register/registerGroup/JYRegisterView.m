//
//  JYRegisterView.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/6/1.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "JYRegisterView.h"
#import "WXApi.h"

@implementation JYRegisterView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpView];
    }
    return self;
}
- (void)setUpView{
    
    CGFloat bord=got((ScreenWidth-got(100)-150)/2) ;
    if ([WXApi isWXAppInstalled]) {
        bord=got((ScreenWidth-got(100)-150)/3);
    }
    //背景
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
    self.frame = [[UIScreen mainScreen] bounds];
    
    //弹窗
    UIImageView *alertV=[[UIImageView alloc]initWithFrame:CGRectMake(got(50), -gotHeight(190), ScreenWidth-got(100), (ScreenWidth-got(100))/1.2 )];

    alertV.userInteractionEnabled=YES;
    alertV.image=[UIImage imageNamed:@"zz-sign_in-yuanjiao"];
    {
        //头部图片
        UIImageView *hearAlertv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, alertV.frame.size.width, ((ScreenWidth-got(100))/1.2)/2)];
        hearAlertv.userInteractionEnabled=YES;
        hearAlertv.image=[UIImage imageNamed:@"w_sign_in_banner"];
        {
            //取消按钮
            UIButton *cannelBut=[[UIButton alloc]initWithFrame:CGRectMake(alertV.size.width-5-24, 0, 24, 24)];
            [cannelBut setImage:[UIImage imageNamed:@"w_tk_close"] forState:(UIControlStateNormal)];
            [cannelBut addTarget:self action:@selector(cannelButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [hearAlertv addSubview:cannelBut];
        }
        [alertV addSubview:hearAlertv];

        //QQ
        UIView *QQV=[[UIView alloc]initWithFrame:CGRectMake(bord, CGRectGetMaxY(hearAlertv.frame)+15, 50, 70)];
        QQV.tag=1000;
        {
            CALayer *QQlayer=[[CALayer alloc]init];
            QQlayer.frame=CGRectMake(0, 0, 50, 50);
            QQlayer.contents=(id)[UIImage imageNamed:@"w_sign_in_qq"].CGImage;
            [QQV.layer addSublayer:QQlayer];
            
            CATextLayer *QQTextlayer=[[CATextLayer alloc]init];
            QQTextlayer.frame =CGRectMake(0, CGRectGetMaxY(QQlayer.frame)+5, QQV.frame.size.width, 20);
            QQTextlayer.string=@"QQ注册";
            QQTextlayer.foregroundColor=kUIColorFromRGB(0x333333).CGColor;
            QQTextlayer.fontSize=12;
            QQTextlayer.contentsScale = [UIScreen mainScreen].scale;
            QQTextlayer.alignmentMode = kCAAlignmentCenter;
            [QQV.layer addSublayer:QQTextlayer];
        }
        [alertV addSubview:QQV];
        
        
        //微信
        if ([WXApi isWXAppInstalled]) {
            //微信
            UIView *WXV=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(alertV.bounds)-25, CGRectGetMaxY(hearAlertv.frame)+15, 50, 70)];
            WXV.tag=1001;
            {
                CALayer *WXlayer=[[CALayer alloc]init];
                WXlayer.frame=CGRectMake(0, 0, 50, 50);
                WXlayer.contents=(id)[UIImage imageNamed:@"w_sign_in_weixin"].CGImage;
                [WXV.layer addSublayer:WXlayer];
                
                CATextLayer *WXTextlayer=[[CATextLayer alloc]init];
                WXTextlayer.frame =CGRectMake(0, CGRectGetMaxY(WXlayer.frame)+5, WXV.frame.size.width, 20);
                WXTextlayer.string=@"微信注册";
                WXTextlayer.foregroundColor=kUIColorFromRGB(0x333333).CGColor;
                WXTextlayer.fontSize=12;
                WXTextlayer.contentsScale = [UIScreen mainScreen].scale;
                WXTextlayer.alignmentMode = kCAAlignmentCenter;
                [WXV.layer addSublayer:WXTextlayer];
            }
            [alertV addSubview:WXV];
        }
        
        //触陌
        UIView *CMV=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(alertV.bounds)-bord-50, CGRectGetMaxY(hearAlertv.frame)+15, 50, 70)];
        CMV.tag=1002;
        {
            CALayer *CMlayer=[[CALayer alloc]init];
            CMlayer.frame=CGRectMake(0, 0, 50, 50);
            CMlayer.contents=(id)[UIImage imageNamed:@"w_sign_in_chumo"].CGImage;
            [CMV.layer addSublayer:CMlayer];
            
            CATextLayer *CMTextlayer=[[CATextLayer alloc]init];
            CMTextlayer.frame =CGRectMake(0, CGRectGetMaxY(CMlayer.frame)+5, CMV.frame.size.width, 20);
            CMTextlayer.string=@"触陌注册";
            CMTextlayer.foregroundColor=kUIColorFromRGB(0x333333).CGColor;
            CMTextlayer.fontSize=12;
            CMTextlayer.contentsScale = [UIScreen mainScreen].scale;
            CMTextlayer.alignmentMode = kCAAlignmentCenter;
            [CMV.layer addSublayer:CMTextlayer];
        }
        
        [alertV addSubview:CMV];
        
        
    }
   
    [self addSubview:alertV];
    
    //动画
    [UIView animateWithDuration:1.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        alertV.frame=CGRectMake(got(50), (ScreenHeight-gotHeight(190))/2-50, ScreenWidth-got(100), (ScreenWidth-got(100))/1.2 );

        
    } completion:^(BOOL finished) {
        
    }];
}
- (void)cannelButtonAction:(UIButton *)sender{
    
    [self removeFromSuperview];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    if (touch.view.tag==1001||touch.view.tag==1000||touch.view.tag==1002) {
        if (_delegate && [_delegate respondsToSelector:@selector(getRegisterType:)]) {
            [_delegate getRegisterType:touch.view.tag];
        }
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
