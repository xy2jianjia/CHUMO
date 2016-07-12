//
//  HobbyCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/20.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "HobbyCell.h"

@implementation HobbyCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupView];
    }
    return self;
}

- (void)p_setupView
{
    // @"Helvetica-Bold"
    
    self.collectionLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    self.collectionLabel.backgroundColor = [UIColor colorWithWhite:0.898 alpha:1.000];
    self.collectionLabel.layer.borderColor = [[UIColor colorWithWhite:0.898 alpha:1.000]CGColor];
    self.collectionLabel.font = [UIFont systemFontOfSize:13.0f];
    self.collectionLabel.textAlignment = NSTextAlignmentCenter;
    self.collectionLabel.layer.borderWidth = 0.5f;
    self.collectionLabel.layer.cornerRadius =25.0/2;
    self.collectionLabel.layer.masksToBounds = YES;
    self.collectionLabel.textColor = [UIColor colorWithWhite:0.196 alpha:1.000];
    [self.contentView addSubview:self.collectionLabel];
    
    self.selectedImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"w_wo_xc_pitchon"]];
    self.selectedImage.hidden=YES;
    [self.contentView addSubview:self.selectedImage];
    
}


- (void)layoutSubviews {

    [super layoutSubviews];

    self.collectionLabel.frame = self.bounds;
    self.selectedImage.frame=CGRectMake(self.bounds.size.width-10, -2, 13, 13);
    
}






@end
