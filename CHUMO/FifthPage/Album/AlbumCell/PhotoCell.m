//
//  PhotoCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/24.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}
- (void)setUpView{
    _simage = [[UIImageView alloc] initWithFrame:self.bounds];
    _simage.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_simage];
    
    _bgTitleView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds)-20, CGRectGetWidth(self.bounds), 20)];
    _bgTitleView.backgroundColor=[UIColor colorWithWhite:0.000 alpha:0.700];
    [self.contentView addSubview:_bgTitleView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 20)];
    _titleLabel.textColor=kUIColorFromRGB(0xffffff);
    _titleLabel.font=[UIFont systemFontOfSize:11.0f];
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    [_bgTitleView addSubview:_titleLabel];
    self.layer.cornerRadius=5;
    self.layer.masksToBounds=YES;
}
@end
