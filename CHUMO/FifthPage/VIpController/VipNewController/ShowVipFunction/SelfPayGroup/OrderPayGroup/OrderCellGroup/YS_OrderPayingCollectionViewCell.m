//
//  YS_OrderPayingCollectionViewCell.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/5/5.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "YS_OrderPayingCollectionViewCell.h"

@implementation YS_OrderPayingCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setCellByModel:(YS_HistoryOrderModel *)model{
    self.payButton.layer.cornerRadius=12;
    self.payButton.layer.masksToBounds=YES;
    self.nameLabel.text=model.b119;
    self.discountLabel.text=[NSString stringWithFormat:@"%@ 折",model.b128];
    
    self.discountPriceLabel.text=[NSString stringWithFormat:@"-%.1f元",[model.b123 floatValue]*(10-[model.b128 floatValue])];
    self.priceLabel.text = [NSString stringWithFormat:@"%.1f元",[model.b123 floatValue]];
    self.totleLabel.text = [NSString stringWithFormat:@"合计: %.1f元",[model.b129 floatValue]];
    switch ([model.b130 integerValue]) {
        case 1:
        {
            self.typeLabel.text=@"支付宝支付";
        }
            break;
        case 2:
        {
            self.typeLabel.text=@"微信支付";
        }
            break;
        case 6:
        {
            self.typeLabel.text=@"现在支付宝支付";
        }
            break;
        case 7:
        {
            self.typeLabel.text=@"现在银联支付";
        }
            break;
        case 8:
        {
            self.typeLabel.text=@"苹果内购支付";
        }
            break;
        case 9:
        {
            self.typeLabel.text=@"汇付宝银联支付";
        }
            break;
        case 11:
        {
            self.typeLabel.text=@"汇付宝微信支付";
        }
            break;
        case 12:
        {
            self.typeLabel.text=@"汇付宝支付宝支付";
        }
            break;
            
            
        default:
            break;
    }
}
- (IBAction)PayAction:(id)sender {
    if (nil!=_delegate && [_delegate respondsToSelector:@selector(noticeToPay:)]) {
        [_delegate noticeToPay:_OrderIndexPath];
    }
}

@end
