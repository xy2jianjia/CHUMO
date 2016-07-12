//
//  HeaderView.m
//  StrangerChat
//
//  Created by zxs on 15/11/20.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        headerView = [[UIView alloc] initWithFrame:self.bounds];
        headerView.backgroundColor = [UIColor greenColor];
        [self addSubview:headerView];
    }
    return self;
}

@end
