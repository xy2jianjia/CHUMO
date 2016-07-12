//
//  FootReusableView.m
//  StrangerChat
//
//  Created by zxs on 15/11/20.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "FootReusableView.h"

@implementation FootReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _view = [[UILabel alloc] initWithFrame:self.bounds];
        _view.backgroundColor = kUIColorFromRGB(0xf0edf2);
        [self addSubview:_view];
    }
    return self;
}
@end
