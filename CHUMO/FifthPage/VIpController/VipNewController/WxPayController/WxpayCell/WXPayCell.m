//
//  WXPayCell.m
//  StrangerChat
//
//  Created by zxs on 16/1/18.
//  Copyright © 2016年 long. All rights reserved.
//

#import "WXPayCell.h"

@implementation WXPayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews {
    self.backgroundColor=[UIColor whiteColor];
    _payImage = [[UIImageView alloc] init];
    _payLabel = [[UILabel alloc] init];
    _payDot   = [[UIButton alloc] init];
    
    _payLabel.font = [UIFont systemFontOfSize:18.0f];
    _payLabel.textColor = kUIColorFromRGB(0x6f6f6f);
    
    [self.contentView addSubview:_payImage];
    [self.contentView addSubview:_payLabel];
    [self.contentView addSubview:_payDot];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat widths  = [self stringWidth:_payLabel.text];
    _payImage.frame = CGRectMake(40, 10, 20, 20);
    _payLabel.frame = CGRectMake(CGRectGetMaxX(_payImage.frame)+20, CGRectGetMinY(_payImage.frame), widths, 20);
    _payLabel.font = [UIFont systemFontOfSize:12];
    _payDot.frame   = CGRectMake([[UIScreen mainScreen] bounds].size.width - 20 - 25-18, CGRectGetMinY(_payImage.frame), 20, 20);
    _payDot.userInteractionEnabled=NO;
    
}

- (CGFloat)stringWidth:(NSString *)aString{
    
    CGRect r = [aString boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f]} context:nil];
    return r.size.width;
}


- (void)setPayImage:(NSString *)payImage payLabel:(NSString *)payLabel payFlag:(NSInteger)payFlag{
    _payImage.image = [UIImage imageNamed:payImage];
    _payLabel.text = payLabel;
    self.payFlag=payFlag;
}
+ (CGFloat)wxPayCellHeight {

    return 35;
}

@end
