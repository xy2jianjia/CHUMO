//
//  YS_OrderPayedCollectionViewCell.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/5/5.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YS_HistoryOrderModel.h"

@interface YS_OrderPayedCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *totleLabel;
- (void)setCellByModel:(YS_HistoryOrderModel *)model;
@end
