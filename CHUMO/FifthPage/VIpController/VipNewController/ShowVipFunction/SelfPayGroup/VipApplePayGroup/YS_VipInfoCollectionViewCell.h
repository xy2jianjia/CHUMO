//
//  YS_VipInfoCollectionViewCell.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/4/19.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YS_PrivilegeModel.h"

@interface YS_VipInfoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *VipInfoimage;
@property (weak, nonatomic) IBOutlet UILabel *VipLable;
@property (nonatomic,strong)NSString *code;//编号
- (void)CellSetValue:(YS_PrivilegeModel*)model;
@end
