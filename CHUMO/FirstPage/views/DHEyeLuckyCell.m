//
//  DHEyeLuckyCell.m
//  CHUMO
//
//  Created by xy2 on 16/3/12.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHEyeLuckyCell.h"

@implementation DHEyeLuckyCell

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
    CGFloat currentWidth = KcellHeight*2;
    CGFloat currentHeight = currentWidth;
    [self setlayerBorder];
    [self setlayer];
    // 年龄
    self.ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(got(10), currentHeight+5, got(40), gotHeight(20))];
    _ageLabel.font = [UIFont systemFontOfSize:13.0];
    _ageLabel.textColor=kUIColorFromRGB(0x666666);
    [self.contentView addSubview:_ageLabel];
    
    //范围
    self.rangeLabel = [[UILabel alloc]init];
    _rangeLabel.frame = CGRectMake(currentWidth-got(5)-got(60), CGRectGetMinY(_ageLabel.frame), got(60), CGRectGetHeight(_ageLabel.frame));
    _rangeLabel.font = [UIFont systemFontOfSize:13];
    _rangeLabel.textAlignment=NSTextAlignmentLeft;
    _rangeLabel.textColor=kUIColorFromRGB(0x666666);
    [self.contentView addSubview:_rangeLabel];
    
    self.rangeimageV = [[UIImageView alloc]init];
    _rangeimageV.frame = CGRectMake(CGRectGetMinX(_rangeLabel.frame)-got(15), CGRectGetMinY(_ageLabel.frame), got(14), got(14));
    _rangeimageV.image = [UIImage imageNamed:@"icon-locate-normal.png"];
    [self.contentView addSubview:_rangeimageV];
    
    // 昵称
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(got(10), CGRectGetMaxY(self.ageLabel.frame), got(100), gotHeight(20))];
    _nameLabel.textColor = [UIColor colorWithRed:213/255.0 green:17/255.0 blue:68/255.0 alpha:1];
    _nameLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:_nameLabel];
    
    
    
    
    
    
    // 头像
    self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, currentWidth, currentHeight)];

    [self.contentView addSubview:_portraitImageView];
    
    self.vipImageV = [[UIImageView alloc]init];
    _vipImageV.frame = CGRectMake(5, 5, 33, 16);
    _vipImageV.image = [UIImage imageNamed:@"w_shouye_vip.png"];
    [self.portraitImageView addSubview:_vipImageV];
    
    // 心
    self.starButton = [[UIButton alloc] initWithFrame:CGRectMake(currentWidth/2-gotiphon6(36/2), currentHeight-gotiphon6(18), gotiphon6(36), gotiphon6(36))];
    NSLog(@"%f--来吧--%f",currentHeight/2-gotiphon6(36/2),self.starButton.centerX,nil);
    
    [self.contentView addSubview:_starButton];
    
}

@end
