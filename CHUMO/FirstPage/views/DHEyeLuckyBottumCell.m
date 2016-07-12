//
//  DHEyeLuckyBottumCell.m
//  CHUMO
//
//  Created by xy2 on 16/3/14.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHEyeLuckyBottumCell.h"

@implementation DHEyeLuckyBottumCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}
- (void)setlayer{
    //使用贝塞尔曲线设置左上 右上圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.frame byRoundingCorners:UIRectCornerTopRight|UIRectCornerTopLeft|UIRectCornerBottomRight|UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
    
    //只能描绘边缘  不能填充
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    CGRect test=self.contentView.bounds;
    maskLayer.frame = test;
    maskLayer.path = maskPath.CGPath;
    maskLayer.strokeColor= [UIColor redColor].CGColor;
    maskLayer.lineWidth=0.5f;
    maskLayer.lineCap = kCALineCapSquare;
    maskLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
    maskLayer.contentsScale = [UIScreen mainScreen].scale;
    self.layer.mask = maskLayer;
}
- (void)setlayerBorder{
    //使用贝塞尔曲线设置左上 右上圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.frame byRoundingCorners:UIRectCornerTopRight|UIRectCornerTopLeft|UIRectCornerBottomRight|UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
    
    //只能描绘边缘  不能填充
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    CGRect test=self.contentView.bounds;
    maskLayer.frame = test;
    maskLayer.path = maskPath.CGPath;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.strokeColor=[UIColor colorWithRed:0.576 green:0.302 blue:0.902 alpha:1.000].CGColor;
    maskLayer.lineWidth=0.5f;
    maskLayer.lineCap = kCALineCapSquare;
    maskLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
    maskLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:maskLayer];
}
- (void)config{
    CGFloat currentWidth = KcellHeight;
    CGFloat currentHeight =  KcellHeight;
    [self setlayer];
    [self setlayerBorder];
    
    self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, currentWidth, currentHeight)];
    [self.contentView addSubview:_portraitImageView];
    // 小图布局
    self.starButton = [[UIButton alloc] initWithFrame:CGRectMake(currentWidth/2-gotiphon6(28)/2, currentHeight-gotiphon6(28)/2, gotiphon6(28), gotiphon6(28))];
    [self.contentView addSubview:_starButton];
    
    // 昵称
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(got(3), CGRectGetMaxY(_starButton.frame), currentHeight-gotiphon6(6), got(13))];
    _nameLabel.font = [UIFont systemFontOfSize:got(11)];
    _nameLabel.textAlignment=NSTextAlignmentCenter;
    _nameLabel.textColor=kUIColorFromRGB(0x323232);
    [self.contentView addSubview:_nameLabel];
}
@end
