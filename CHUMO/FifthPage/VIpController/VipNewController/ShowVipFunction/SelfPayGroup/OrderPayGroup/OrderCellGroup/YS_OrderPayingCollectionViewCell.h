//
//  YS_OrderPayingCollectionViewCell.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/5/5.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YS_HistoryOrderModel.h"
@protocol YS_OrderPayingDelegate <NSObject>

- (void) noticeToPay:(NSIndexPath *)currentIndexPath;
@end
@interface YS_OrderPayingCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totleLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (nonatomic,strong)NSIndexPath *OrderIndexPath;
@property (nonatomic,assign)id<YS_OrderPayingDelegate> delegate;
- (void)setCellByModel:(YS_HistoryOrderModel *)model;
@end
