//
//  NPhotoCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/26.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "NPhotoCell.h"

@implementation NPhotoCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _simage = [[UIImageView alloc] initWithFrame:self.bounds];
//        _simage.backgroundColor = [UIColor redColor];
        _simage.clipsToBounds = YES;
        _simage.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_simage];
    }
    return self;
}

@end
