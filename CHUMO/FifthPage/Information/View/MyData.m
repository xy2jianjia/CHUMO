//
//  MyData.m
//  StrangerChat
//
//  Created by zxs on 15/11/19.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "MyData.h"

@implementation MyData

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self n_setupView];
    }
    return self;
}
// Basic 基本 Detailed 详细  Hobbies 爱好  @"Helvetica-Bold"
- (void)n_setupView
{
    
    self.scrollView = [[UIScrollView alloc] init];
    [self addSubview:self.scrollView];
    
    allView = [[UIView alloc] init];
    allView.backgroundColor = [UIColor whiteColor];
    [self addSubview:allView];
    
    
    vertical = [[UILabel alloc] init];
    vertical.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [allView addSubview:vertical];
    
    verticaLine = [[UILabel alloc] init];
    verticaLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [allView addSubview:verticaLine];
    // 字体
    self.basic = [[UIButton alloc] init];
    [self.basic setTitle:@"基本资料" forState:(UIControlStateNormal)];
    self.basic.titleLabel.font = [UIFont systemFontOfSize:16];
    [allView addSubview:self.basic];
    
    self.detaile = [[UIButton alloc] init];
    [self.detaile setTitle:@"详细信息" forState:(UIControlStateNormal)];
    self.detaile.titleLabel.font = [UIFont systemFontOfSize:16];
    [allView addSubview:self.detaile];
    
    self.hobbies = [[UIButton alloc] init];
    [self.hobbies setTitle:@"个性爱好" forState:(UIControlStateNormal)];
    self.hobbies.titleLabel.font = [UIFont systemFontOfSize:16];
    [allView addSubview:self.hobbies];
    
    
    basicLabel = [[UILabel alloc] init];
//    basicLabel.font = 
    basicLabel.textAlignment = NSTextAlignmentCenter;
    basicLabel.font = [UIFont fontWithName:Typefaces size:10.0f];
    [allView addSubview:basicLabel];
    
    detaileLabel = [[UILabel alloc] init];
//    detaileLabel.font = [UIFont systemFontOfSize:16];
    detaileLabel.textAlignment = NSTextAlignmentCenter;
    detaileLabel.font = [UIFont fontWithName:Typefaces size:10.0f];
    [allView addSubview:detaileLabel];
    
    hobbiesLabel = [[UILabel alloc] init];
//    hobbiesLabel.font = [UIFont systemFontOfSize:16];
    hobbiesLabel.textAlignment = NSTextAlignmentCenter;
    hobbiesLabel.font = [UIFont fontWithName:Typefaces size:10.0f];
    [allView addSubview:hobbiesLabel];
    
    line = [[UILabel alloc] init];
    line.backgroundColor = [UIColor grayColor];
    [allView addSubview:line];
    
    _dividLine = [[UILabel alloc] init];
    _dividLine.backgroundColor = kUIColorFromRGB(0x934de6);
    [allView addSubview:_dividLine];
    
}


#pragma mark --- ((DATAWIDTH/2-45)/2-45)  间距
- (void)layoutSubviews {

    allView.frame = CGRectMake(0, 0, DATAWIDTH, 65);
    line.frame = CGRectMake(0, 1, DATAWIDTH, 0.5);
    
    NSString *str = [AllRegular getInterger];
    NSInteger inte = [str integerValue];
    if (inte == 1) {
        self.dividLine.frame = CGRectMake((DATAWIDTH/2-45)/2-45, 64, 90, 2);
    }else if (inte == 2) {
        self.dividLine.frame = CGRectMake(DATAWIDTH/2-45, 64, 90, 2);
    }else if (inte == 3) {
        self.dividLine.frame = CGRectMake(DATAWIDTH/2-45+((DATAWIDTH/2-45)/2-45)+90, 64, 90, 2);
    }else {
        _dividLine.frame = CGRectMake((DATAWIDTH/2-45)/2-45, 64, 90, 2);
    }
    
#pragma mark --- 三个label
    self.basic.frame = CGRectMake((DATAWIDTH/2-45)/2-45, 20, 90, 25);
    self.detaile.frame = CGRectMake(DATAWIDTH/2-45, 20, 90, 25);
    self.hobbies.frame = CGRectMake(CGRectGetMaxX(self.detaile.frame)+((DATAWIDTH/2-45)/2-45), 20, 90, 25);
#pragma mark --- 两条竖线
    vertical.frame = CGRectMake(DATAWIDTH/2-45-((DATAWIDTH/2-45)/2-45)/2, 17, 1, 30);
    verticaLine.frame = CGRectMake(CGRectGetMaxX(self.detaile.frame)+((DATAWIDTH/2-45)/2-45)/2, 17, 1, 30);
#pragma mark --- 数字
    basicLabel.frame = CGRectMake(CGRectGetMinX(self.basic.frame), CGRectGetMaxY(self.basic.frame), 90, 15);
    detaileLabel.frame = CGRectMake(CGRectGetMinX(self.detaile.frame), CGRectGetMaxY(self.detaile.frame), 90, 15);
    hobbiesLabel.frame = CGRectMake(CGRectGetMinX(self.hobbies.frame), CGRectGetMaxY(self.hobbies.frame), 90, 15);
    
    self.scrollView.frame = CGRectMake(0, 64, CGRectGetWidth(self.frame), DATAHEIGTH);
}

- (void)addWithbasicNum:(NSString *)basic detaile:(NSString *)detaile hobbies:(NSString *)hobbies {

    basicLabel.text = basic;
    detaileLabel.text = detaile;
    hobbiesLabel.text = hobbies;

}
- (void)setColorWithNumer:(NSInteger)num{
    
    [basicLabel setTextColor:kUIColorFromRGB(0xaaaaaa)];
    [detaileLabel setTextColor:kUIColorFromRGB(0xaaaaaa)];
    [hobbiesLabel setTextColor:kUIColorFromRGB(0xaaaaaa)];
    switch (num) {
        case 1:
        {
            [basicLabel setTextColor:kUIColorFromRGB(0x934de6)];
        }
            break;
        case 2:
        {
            [detaileLabel setTextColor:kUIColorFromRGB(0x934de6)];
        }
            break;
        case 3:
        {
            [hobbiesLabel setTextColor:kUIColorFromRGB(0x934de6)];
        }
            break;
            
        default:
            break;
    }
    
}



@end
