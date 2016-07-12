//
//  YS_PayVipCollectionViewCell.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/4/19.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YS_PayModel.h"

@interface YS_PayVipCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *vipTime;
@property (weak, nonatomic) IBOutlet UILabel *VipInfoLabel;
@property (nonatomic,strong)NSString *code;
@property (weak, nonatomic) IBOutlet UILabel *giftWayLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyLabel;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
- (void) cellSetValu:(YS_PayModel *)model;
@end
