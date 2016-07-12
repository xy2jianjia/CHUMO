//
//  YS_borderView.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/4/26.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "YS_borderView.h"

@implementation YS_borderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setNeedsDisplay];
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.layer.borderColor=[UIColor colorWithRed:0.576 green:0.302 blue:0.902 alpha:1.000].CGColor;
    self.layer.cornerRadius=20;
    self.layer.masksToBounds=YES;
    self.layer.borderWidth=1;
}


@end
