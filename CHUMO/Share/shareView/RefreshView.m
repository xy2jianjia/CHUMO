//
//  RefreshView.m
//  CHUMO
//
//  Created by zxs on 16/2/23.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "RefreshView.h"

@implementation RefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self refreshCom];
    }
    return self;
}

- (void)refreshCom {
    comImage = [[UIImageView alloc] init];
    refresh = [[UIButton alloc] init];
    refresh.tag = 1000;
    [refresh setBackgroundColor:kUIColorFromRGB(0xf04d6d)];
    [refresh.layer setCornerRadius:40/2];
    [refresh.layer setMasksToBounds:YES];
    [comImage setImage:[UIImage imageNamed:@"server"]];
    [comImage setContentMode:UIViewContentModeScaleAspectFill];
    [refresh setTitle:@"刷新" forState:(UIControlStateNormal)];
    [refresh addTarget:self action:@selector(refresAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:comImage];
    [self addSubview:refresh];
}

- (void)refresAction:(UIButton *)sender {
    if ([self.refreshDelegate respondsToSelector:@selector(setRefre:inte:)]) {
        [self.refreshDelegate setRefre:self inte:sender.tag];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    comImage.frame = CGRectMake((Width- (Width/2+20))/2, 90, Width/2+20, Height/2-40);
    refresh.frame = CGRectMake((Width-Width/3)/2, CGRectGetMaxY(comImage.frame)+31, Width/3, 40);
}

@end
