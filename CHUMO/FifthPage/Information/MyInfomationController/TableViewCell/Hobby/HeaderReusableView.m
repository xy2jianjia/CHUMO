//
//  HeaderReusableView.m
//  StrangerChat
//
//  Created by zxs on 15/11/20.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "HeaderReusableView.h"

@implementation HeaderReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupView];
    }
    return self;
}
// @"Helvetica-Bold"
- (void)p_setupView {
    
    titleView = [[UIView alloc]initWithFrame:CGRectZero];
    titleView.backgroundColor=kUIColorFromRGB(0xf0edf2);
    [self addSubview:titleView];
    
    
    
    
    view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = kUIColorFromRGB(0xffffff);
    [self addSubview:view];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont fontWithName:Typefaces size:15.0f];
    self.nameLabel.textColor = kUIColorFromRGB(0x323232);
    [view addSubview:self.nameLabel];
    
    self.secUpdate = [[UIButton alloc] init];
    [view addSubview:self.secUpdate];
    
    self.update = [[UIButton alloc] init];
    [view addSubview:self.update];
    
    self.footButton = [[UIButton alloc] init];
    [view addSubview:self.footButton];
    
    self.secFootButton = [[UIButton alloc] init];
    [view addSubview:self.secFootButton];
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    titleView.frame = CGRectMake(0, 0, ScreenWidth, 10);
    view.frame=CGRectMake(0, CGRectGetMaxY(titleView.frame), ScreenWidth, CGRectGetHeight(self.frame)-CGRectGetHeight(titleView.frame));
    self.nameLabel.frame = CGRectMake(15, 10, 120, 30);
    self.secUpdate.frame = CGRectMake(self.frame.size.width - 40-15, 10, 40, 30);
    self.update.frame = CGRectMake(self.frame.size.width - 40-15, 10, 40, 30);
    self.footButton.frame = CGRectMake(self.frame.size.width - 40-15, 10, 40, 30);
    self.secFootButton.frame = CGRectMake(self.frame.size.width - 40-15, 10, 40, 30);
}

@end
