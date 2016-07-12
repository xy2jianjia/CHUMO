//
//  YS_PayVipCollectionViewCell.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/4/19.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "YS_PayVipCollectionViewCell.h"


@implementation YS_PayVipCollectionViewCell
- (void) cellSetValu:(YS_PayModel *)model{
    self.backGroundView.layer.cornerRadius=5;
    self.backGroundView.layer.masksToBounds=YES;
    self.vipTime.text= [NSString stringWithFormat:@"%@ 个月",model.b137];
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥ %@",model.b126]];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 1)];
    self.buyLabel.backgroundColor=[UIColor clearColor];
    
    self.giftWayLabel.layer.cornerRadius=3;
    self.giftWayLabel.layer.masksToBounds=YES;
    self.giftWayLabel.backgroundColor=kUIColorFromRGB(0xfa4b5c);
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.482 green:0.290 blue:0.702 alpha:1.000] range:NSMakeRange(0, 1)];
    self.VipInfoLabel.attributedText = str;
    if (model.b138!=nil && model.b138) {
        self.giftWayLabel.hidden=NO;
        self.giftWayLabel.text=[NSString stringWithFormat:@" 送%@个月 ",model.b138];
    }else{
        self.giftWayLabel.hidden=YES;
    }
    self.code=model.b13;
}
- (void)awakeFromNib {
    // Initialization code
}

@end
