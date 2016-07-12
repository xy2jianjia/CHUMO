//
//  BindView.m
//  StrangerChat
//
//  Created by zxs on 15/11/28.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "BindView.h"

@implementation BindView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        photoImage = [[UIImageView alloc] init];
        [self addSubview:photoImage];
        
        bindNum = [[UILabel alloc] init];
        bindNum.font = [UIFont systemFontOfSize:15.0f];
        bindNum.textColor=kUIColorFromRGB(0x323232);
        bindNum.textAlignment = NSTextAlignmentCenter;
        [self addSubview:bindNum];
        
        _replacement = [[UIButton alloc] init];
        [_replacement.layer setMasksToBounds:true];
        [_replacement.layer setCornerRadius:20];
        [_replacement setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _replacement.titleLabel.font = [UIFont fontWithName:Typeface size:16.0f];
        _replacement.backgroundColor = kUIColorFromRGB(0x934de6);
        [self addSubview:_replacement];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    photoImage.frame = CGRectMake((self.bounds.size.width-150)/2, 60, 150, 150);
    bindNum.frame = CGRectMake(40, CGRectGetMaxY(photoImage.frame)+20, self.bounds.size.width - 40*2, 40);
    _replacement.frame = CGRectMake(30, CGRectGetMaxY(bindNum.frame)+40, self.bounds.size.width-30*2, 40);

}


- (void)addDataWithphotoImage:(NSString *)image bindNum:(NSString *)bind {

    photoImage.image = [UIImage imageNamed:image];
    bindNum.text = bind;
}

@end
