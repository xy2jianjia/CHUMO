//
//  YS_PayVipAlertCollectionViewCell.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/6/25.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YS_PayVipAlertCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *vipTime;
@property (weak, nonatomic) IBOutlet UILabel *VipInfoLabel;
@property (nonatomic,strong)NSString *code;
@property (weak, nonatomic) IBOutlet UILabel *giftWayLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyLabel;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
- (void) cellSetValu:(YS_PayModel *)model;
@end
