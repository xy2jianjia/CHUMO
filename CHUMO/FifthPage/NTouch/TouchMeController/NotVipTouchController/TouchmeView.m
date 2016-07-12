//
//  TouchmeView.m
//  StrangerChat
//
//  Created by zxs on 15/12/1.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "TouchmeView.h"

@implementation TouchmeView

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
    nameLabel.font = [UIFont systemFontOfSize:21.0f];
    [self addSubview:nameLabel];
    
    _numLabel = [[UILabel alloc] init];
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.font = [UIFont systemFontOfSize:22.0f];
    _numLabel.textColor = [UIColor blackColor];
    [self addSubview:_numLabel];
    
    crown = [[UIImageView alloc] init];
    [self addSubview:crown];
    
    someBoy = [[UILabel alloc] init];
    someBoy.textAlignment = NSTextAlignmentCenter;
    someBoy.font = [UIFont systemFontOfSize:17.0f];
    someBoy.textColor = kUIColorFromRGB(0x9b9b9b);
    [self addSubview:someBoy];
    
    vip = [[UILabel alloc] init];
    vip.textAlignment = NSTextAlignmentCenter;
    vip.font = [UIFont systemFontOfSize:18.0f];
    vip.textColor = kUIColorFromRGB(0x9b9b9b);
    [self addSubview:vip];
    
    _vipButton = [[UIButton alloc] init];
    _vipButton.backgroundColor = MainBarBackGroundColor;
    [self addSubview:_vipButton];
    
}
- (void)layoutSubviews {
    
    cupImage.frame = CGRectMake(self.bounds.size.width/2-45, gotHeight(40), got(74), gotHeight(124.5));
    nameLabel.frame = CGRectMake(0, CGRectGetMaxY(cupImage.frame)+gotHeight(20), self.bounds.size.width, gotHeight(40));
    _numLabel.frame = CGRectMake(0, CGRectGetMaxY(nameLabel.frame)+gotHeight(20), self.bounds.size.width, gotHeight(40));
    crown.frame = CGRectMake((self.bounds.size.width-35)/2, CGRectGetMaxY(_numLabel.frame)+gotHeight(20), 26.5, gotHeight(18));
    someBoy.frame = CGRectMake(0, CGRectGetMaxY(crown.frame)+gotHeight(20), [[UIScreen mainScreen] bounds].size.width, gotHeight(30));
    vip.frame = CGRectMake(0, CGRectGetMaxY(someBoy.frame)+5, [[UIScreen mainScreen] bounds].size.width, gotHeight(30));
    _vipButton.frame = CGRectMake(0, self.bounds.size.height-gotHeight(55), [[UIScreen mainScreen] bounds].size.width, gotHeight(55));
}

- (void)addWithcupImage:(NSString *)cup nameLabel:(NSString *)name crown:(NSString *)acrown someBoy:(NSString *)someboy vip:(NSString *)avip {

    cupImage.image = [UIImage imageNamed:cup];
    nameLabel.text = [NSString stringWithFormat:@"Hi,%@",name];
    crown.image = [UIImage imageNamed:acrown];
    someBoy.text = someboy;
    vip.text = avip;
}



@end
