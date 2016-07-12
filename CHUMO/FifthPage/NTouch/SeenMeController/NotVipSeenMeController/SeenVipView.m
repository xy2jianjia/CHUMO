//
//  SeenVipView.m
//  StrangerChat
//
//  Created by zxs on 15/12/1.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "SeenVipView.h"

@implementation SeenVipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self n_layoutViews];
    }
    return self;
}


- (void)n_layoutViews {
    
    cupImage = [[UIImageView alloc] init];
    [self addSubview:cupImage];
    
    nameLabel = [[UILabel alloc] init];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:nameLabel];
    
    _numLabel = [[UILabel alloc] init];
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.font = [UIFont systemFontOfSize:15.0f];
    _numLabel.textColor = [UIColor colorWithWhite:0.196 alpha:1.000];
    [self addSubview:_numLabel];
    
    
    leftView = [[UIView alloc]init];
    leftView.backgroundColor=kUIColorFromRGB(0xe4e1e6);
    [self addSubview:leftView];
    
    crown = [[UIImageView alloc] init];
    [self addSubview:crown];
    
    rightView = [[UIView alloc]init];
    rightView.backgroundColor=kUIColorFromRGB(0xe4e1e6);
    [self addSubview:rightView];
    
    
    someBoy = [[UILabel alloc] init];
    someBoy.textAlignment = NSTextAlignmentCenter;
    someBoy.font = [UIFont systemFontOfSize:13.0f];
    someBoy.textColor = kUIColorFromRGB(0xaaaaaa);
    [self addSubview:someBoy];
    
    vip = [[UILabel alloc] init];
    vip.textAlignment = NSTextAlignmentCenter;
    vip.font = [UIFont systemFontOfSize:13.0f];
    vip.textColor = kUIColorFromRGB(0xaaaaaa);
    [self addSubview:vip];
    
    _vipButton = [[UIButton alloc] init];
    _vipButton.backgroundColor = MainBarBackGroundColor;
    _vipButton.layer.cornerRadius=gotHeight(40)/2;
    _vipButton.layer.masksToBounds=YES;
    [self addSubview:_vipButton];
    
}
- (void)layoutSubviews {
    
    cupImage.frame = CGRectMake(self.bounds.size.width/2-gotHeight(155/2),gotHeight(40),got(155), got(127));
    cupImage.centerX=self.centerX;
    nameLabel.frame = CGRectMake(0, CGRectGetMaxY(cupImage.frame)+10, self.bounds.size.width, gotHeight(30));
    _numLabel.frame = CGRectMake(0, CGRectGetMaxY(nameLabel.frame)+10, self.bounds.size.width, gotHeight(30));
    
    crown.frame = CGRectMake((self.bounds.size.width-35)/2, CGRectGetMaxY(_numLabel.frame)+gotHeight(40), got(26.5), gotHeight(18));
    leftView.frame=CGRectMake(CGRectGetMinX(crown.frame)-10-got(110), CGRectGetMinY(crown.frame)+gotHeight(18/2), got(110), 0.5);
    rightView.frame=CGRectMake(CGRectGetMaxX(crown.frame)+10, CGRectGetMinY(crown.frame)+gotHeight(18/2), got(110), 0.5);
    
    someBoy.frame = CGRectMake(0, CGRectGetMaxY(crown.frame)+gotHeight(20), [[UIScreen mainScreen] bounds].size.width, gotHeight(20));
    vip.frame = CGRectMake(0, CGRectGetMaxY(someBoy.frame), [[UIScreen mainScreen] bounds].size.width, gotHeight(20));
    _vipButton.frame = CGRectMake(CGRectGetMidX(self.bounds)-got(150/2), CGRectGetMaxY(vip.frame)+gotHeight(40), got(150), gotHeight(40));
}

- (void)addWithcupImage:(NSString *)cup nameLabel:(NSString *)name crown:(NSString *)acrown someBoy:(NSString *)someboy vip:(NSString *)avip {
    
    cupImage.image = [UIImage imageNamed:cup];
    nameLabel.text = [NSString stringWithFormat:@"Hi,%@",name];
    crown.image = [UIImage imageNamed:acrown];
    someBoy.text = someboy;
    vip.text = avip;
}

@end
