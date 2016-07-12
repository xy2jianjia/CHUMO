//
//  MonthlyView.m
//  Monthly
//
//  Created by zxs on 16/4/19.
//  Copyright © 2016年 YSKS.cn. All rights reserved.
//

#import "MonthlyView.h"

@implementation MonthlyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self monthlyView];
    }
    return self;
}

- (void)monthlyView {
    
    _backgroundImage = [UIImageView new];
    _dotView = [UIView new];
    _monthlyLabel = [UILabel new];
    _monthlyContent = [UILabel new];
    
    
    [_backgroundImage setImage:[UIImage imageNamed:@"w_wdzx_xxby_tp"]];
    
    [_dotView.layer setMasksToBounds:true];
    [_dotView.layer setCornerRadius:5];
    [_dotView setBackgroundColor:[UIColor redColor]];
    
    [_monthlyLabel setText:@"写信包月服务"];
    [_monthlyLabel setFont:[UIFont systemFontOfSize:18]];
    
    [_monthlyContent setText:@"服务期内，发信回信全免费，与心仪对象欢乐畅聊"];
    [_monthlyContent setFont:[UIFont systemFontOfSize:13]];
    [_monthlyContent setTextColor:kUIColorFromRGB(0x646464)];
    
    [self addSubview:_backgroundImage];
    [self addSubview:_dotView];
    [self addSubview:_monthlyLabel];
    [self addSubview:_monthlyContent];
    
}


- (void)layoutSubviews {

    CGFloat monthlyW = [self stringWidth:_monthlyLabel.text fontSize:18];
    [_backgroundImage setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height/2-80)];
    [_dotView setFrame:CGRectMake(20, CGRectGetMaxY(_backgroundImage.frame)+30/2-5/2+22, 5, 5)];
    [_monthlyLabel setFrame:CGRectMake(CGRectGetMaxX(_dotView.frame)+5, CGRectGetMaxY(_backgroundImage.frame)+22, monthlyW, 25)];
    [_monthlyContent setFrame:CGRectMake(CGRectGetMinX(_monthlyLabel.frame), CGRectGetMaxY(_monthlyLabel.frame)+5, [[UIScreen mainScreen] bounds].size.width-25, 20)];
}
- (void)priceAction:(UIButton *)sender {
    if ([self.monthlydelegate respondsToSelector:@selector(clickMonthlyButton:indexTag:)]) {
        [self.monthlydelegate clickMonthlyButton:self indexTag:sender.tag];
    }
}
- (void)setmonthlyArray:(NSArray *)n_monthlyArray priceArray:(NSArray *)n_priceArray buyArray:(NSArray *)n_buyArray giftArray:(NSArray *)n_giftArray{
    

    for (int i = 0; i < n_monthlyArray.count; i++) {
        NSInteger code=[n_buyArray[i] integerValue];
        _priceButton = [UIButton new];
        [_priceButton setTag:code];
        [_priceButton setBackgroundColor:kUIColorFromRGB(0xe5d3fa)];
        _priceButton.layer.cornerRadius=5;
        _priceButton.layer.masksToBounds=YES;

        [_priceButton setFrame:CGRectMake(20,([[UIScreen mainScreen] bounds].size.height/2-20-64)+22+25+5+20+52/2 + i * 10 + 40 * i, [[UIScreen mainScreen] bounds].size.width-40, 40)];
        [_priceButton addTarget:self action:@selector(priceAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_priceButton];
        _mounthLabel = [UILabel new];
        _priceLabel = [UILabel new];
        _buyLabel = [UILabel new];
        _giftLabel = [UILabel new];
        
        [_mounthLabel setFrame:CGRectMake(36/2, 7, 60, 25)];
        [_mounthLabel setFont:[UIFont systemFontOfSize:15]];
        _mounthLabel.textColor=kUIColorFromRGB(0x7b4ab3);
        
        [_priceLabel setFrame:CGRectMake(CGRectGetMaxX(_mounthLabel.frame)+20, 9, 50, 21)];
        [_priceLabel setFont:[UIFont systemFontOfSize:15]];
        _priceLabel.textColor=kUIColorFromRGB(0x7b4ab3);
        
        [_buyLabel setFrame:CGRectMake(_priceButton.frame.size.width-50, 7, 50, 24)];
        [_buyLabel setFont:[UIFont systemFontOfSize:14]];
        _buyLabel.layer.cornerRadius=12;
        _buyLabel.layer.masksToBounds=YES;
        _buyLabel.backgroundColor=[UIColor clearColor];
        _buyLabel.textAlignment=NSTextAlignmentCenter;
        _buyLabel.textColor=kUIColorFromRGB(0x7b4ab3);
        
        [_giftLabel setFrame:CGRectMake(CGRectGetMinX(_buyLabel.frame)-5-70, 9, 60, 21)];
        [_giftLabel setFont:[UIFont systemFontOfSize:12]];
        _giftLabel.textAlignment=NSTextAlignmentCenter;
        _giftLabel.backgroundColor=kUIColorFromRGB(0xfa4b5c);
        _giftLabel.layer.cornerRadius=3;
        _giftLabel.layer.masksToBounds=YES;
        [_giftLabel setTextColor:kUIColorFromRGB(0xffffff)];
        
        [_mounthLabel setTag:code];
        [_priceLabel setTag:code];
        [_buyLabel setTag:code];
        [_giftLabel setTag:code];
        
        _mounthLabel.text=[NSString stringWithFormat:@"%@ 个月",n_monthlyArray[i]];
        _priceLabel.text= [NSString stringWithFormat:@"￥ %@",n_priceArray[i]];
        if ([n_giftArray[i] integerValue]>0) {
            _giftLabel.text =[NSString stringWithFormat:@" 送%@个月 ",n_giftArray[i]];
            [_priceButton addSubview:_giftLabel];
        }
        _buyLabel.text=@"购买";
        
        [_priceButton addSubview:_mounthLabel];
        [_priceButton addSubview:_priceLabel];
        [_priceButton addSubview:_buyLabel];
        
        
        if (i==(n_monthlyArray.count-1)) {
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_priceButton.frame)+20, ScreenWidth, 25)];
            UIView *footV=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(view.bounds)-100, CGRectGetHeight(view.bounds)-25, 200, 20)];
            
            UILabel *textL=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(footV.bounds)-60, 20)];
            textL.text=@"支付代表你已经阅读并同意触陌";
            textL.font=[UIFont systemFontOfSize:10];
            textL.textColor=[UIColor colorWithWhite:0.600 alpha:1.000];
            [footV addSubview:textL];
            UIButton *goBut=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textL.frame), 0, 60, 20)];
            [goBut setTitle:@"服务条款" forState:(UIControlStateNormal)];
            goBut.titleLabel.font=[UIFont systemFontOfSize:10];
            [goBut setTitleColor:[UIColor colorWithRed:0.329 green:0.467 blue:0.910 alpha:1.000] forState:(UIControlStateNormal)];
            [goBut addTarget:self action:@selector(gotoServiceAction) forControlEvents:(UIControlEventTouchUpInside)];
            [footV addSubview:goBut];
            footV.backgroundColor=[UIColor clearColor];
            [view addSubview:footV];
            view.backgroundColor=[UIColor clearColor];
            [self addSubview:view];
        }

        
    }

    
}
- (void)gotoServiceAction{
    if (_monthlydelegate && [_monthlydelegate respondsToSelector:@selector(gotoServiceAction)]) {
        [_monthlydelegate gotoServiceAction];
    }
}

#pragma mark ---- 自适应宽度
- (CGFloat)stringWidth:(NSString *)aString fontSize:(CGFloat)fontSize {
    CGRect r = [aString boundingRectWithSize:CGSizeMake(250, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return r.size.width;
}
@end
