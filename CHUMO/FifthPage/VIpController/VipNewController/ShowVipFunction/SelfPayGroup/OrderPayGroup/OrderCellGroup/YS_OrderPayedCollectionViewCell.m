//
//  YS_OrderPayedCollectionViewCell.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/5/5.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "YS_OrderPayedCollectionViewCell.h"


@implementation YS_OrderPayedCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setCellByModel:(YS_HistoryOrderModel *)model{
    self.nameLabel.text=model.b119;
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.b136];
    self.priceLabel.text = [NSString stringWithFormat:@"%.1f元",[model.b123 floatValue]];
    self.totleLabel.text = [NSString stringWithFormat:@"合计: %.1f元",[model.b129 floatValue]];
    
    switch ([model.b122 integerValue]) {
        case 1:
        {
            self.statusLabel.text=@"成功";
        }
            break;
        case 2:
        {
            self.statusLabel.text=@"失败";
        }
            break;
        case 4:
        {
            self.statusLabel.text=@"已取消";
        }
            break;
            
        default:
            break;
    }
    
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
@end
