//
//  YS_PayInfoTableViewCell.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/5/3.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "YS_PayInfoTableViewCell.h"
@interface YS_PayInfoTableViewCell()
{
    UILabel *payName;
    UILabel *payPrice;
    UIView *gift;
}
@end
@implementation YS_PayInfoTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpView];
    }
    return self;
}
//设置样式
- (void)setUpView{
    self.backgroundColor=kUIColorFromRGB(0xffffff);
    payName=[[UILabel alloc]init];
    payName.font=[UIFont systemFontOfSize:15];
    payName.textColor = kUIColorFromRGB(0x323232);
    [self.contentView addSubview:payName];
    
    payPrice=[[UILabel alloc]init];
    payPrice.font=[UIFont systemFontOfSize:15];
    payPrice.textAlignment=NSTextAlignmentRight;
    payPrice.textColor = kUIColorFromRGB(0x323232);
    [self.contentView addSubview:payPrice];
    
    gift=[[UIView alloc]init];
    gift.layer.cornerRadius=4;
    gift.layer.masksToBounds=YES;
    
    gift.backgroundColor=kUIColorFromRGB(0xfa4b5c);
//    gift.textColor = kUIColorFromRGB(0xffffff);
    
    
    self.ButtonImage=[[UIImageView alloc]init];
    [self.contentView addSubview:_ButtonImage];
}
//设置大小
-(void)layoutSubviews{
    payName.frame=CGRectMake(40, 10,80, 20);
    
//    gift.frame =CGRectMake(ScreenWidth/2-40, 10, 80, 20);
    self.ButtonImage.frame=CGRectMake(ScreenWidth-20-25-18, 11, 18, 18);
    payPrice.frame=CGRectMake(CGRectGetMinX(self.ButtonImage.frame)-10-50, 10, 50, 20);
    
}
//设置数据
- (void)setPayName:(NSNumber *)Name PayPrice:(NSString *)Price ButImage:(NSString *)image giveaway:(NSString *)giftFlag giveMoney:(NSString *)moneyStr{
    
    payName.text=[NSString stringWithFormat:@"%@个月",Name];
    payPrice.text=Price;
    self.ButtonImage.image=[UIImage imageNamed:image];
//    NSMutableString *giftStr=[NSMutableString new];
    NSInteger num=0;
    if (giftFlag !=nil) {
        num++;
    }
    if (!MyJudgeNull(moneyStr) && ![moneyStr isEqualToString:@"(null)"] ) {
        num++;
    }
    if (num>0) {
        gift.frame =CGRectMake(ScreenWidth/2-40, 5, 80, 10*num+10);
        [self.contentView addSubview:gift];
    }
    if (giftFlag !=nil) {
//        num++;
//        [giftStr appendFormat:@"%@",giftFlag];
        self.giftlabel.frame  =CGRectMake(0, 5, CGRectGetWidth(gift.bounds), 10);

        _giftlabel.text=giftFlag;

    }
    
    
    if (!MyJudgeNull(moneyStr) && ![moneyStr isEqualToString:@"(null)"] ) {
        CGFloat heightm=0;
        if (num>0) {
            heightm = 10*(num-1);
        }
        self.giftlabel2.frame=CGRectMake(0, heightm+5, CGRectGetWidth(gift.bounds), 10);
        _giftlabel2.text=moneyStr;

    }
    
    
    
    
}
-(UILabel *)giftlabel2{
    if (!_giftlabel2) {
        _giftlabel2=[[UILabel alloc]init];
        _giftlabel2.font=[UIFont systemFontOfSize:10];
        _giftlabel2.textAlignment=NSTextAlignmentCenter;
        _giftlabel2.textColor = kUIColorFromRGB(0xffffff);
        [gift addSubview:_giftlabel2];
    }
    return _giftlabel2;
}
-(UILabel *)giftlabel{
    if (!_giftlabel) {
        _giftlabel=[[UILabel alloc]init];
        _giftlabel.font=[UIFont systemFontOfSize:10];
        _giftlabel.textAlignment=NSTextAlignmentCenter;
        _giftlabel.textColor = kUIColorFromRGB(0xffffff);
        [gift addSubview:_giftlabel];
    }
    return _giftlabel;
}
@end
