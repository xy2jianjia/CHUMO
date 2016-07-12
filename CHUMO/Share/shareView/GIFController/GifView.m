//
//  GifView.m
//  CHUMO
//
//  Created by zxs on 16/3/8.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "GifView.h"
#import "UIImage+GIF.h"
#define GIFImage [[UIScreen mainScreen] bounds].size.width
#define LeftW 85
@implementation GifView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self RequesImage];
    }
    return self;
}

- (void)RequesImage {
    gifImage = [UIImageView new];
    searchBt = [UIButton new];
//    [gifImage.layer setCornerRadius:(GIFImage-LeftW*2)/2];
//    [gifImage.layer setMasksToBounds:YES];
//    UIImage *image = [UIImage sd_animatedGIFNamed:@"GIF"];
    UIImage *image = [UIImage imageNamed:@"w_fx_chahua"];
    
    gifImage.image = image;
    [searchBt setBackgroundColor:kUIColorFromRGB(0x934de6)];
    [searchBt.layer setCornerRadius:20];
    [searchBt.layer setMasksToBounds:YES];
    [searchBt setTitle:@"换个姿势, 再搜一次" forState:(UIControlStateNormal)];
    [searchBt.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [searchBt addTarget:self action:@selector(searchBtAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:gifImage];
    [self addSubview:searchBt];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    gifImage.frame = CGRectMake((ScreenWidth-gotHeightiphon6(210))/2, 35, gotHeightiphon6(210), gotHeightiphon6(235));
    searchBt.frame = CGRectMake((GIFImage-183)/2, CGRectGetMaxY(gifImage.frame)+30, 183, 40);
}
- (void)searchBtAction:(UIButton *)sender {
    if ([self.gifdelegates respondsToSelector:@selector(setImageGif:tagInte:)]) {
        [self.gifdelegates setImageGif:self tagInte:1];
    }
}
@end
