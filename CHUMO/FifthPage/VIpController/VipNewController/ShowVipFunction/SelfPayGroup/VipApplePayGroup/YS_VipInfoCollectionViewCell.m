//
//  YS_VipInfoCollectionViewCell.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/4/19.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "YS_VipInfoCollectionViewCell.h"

@implementation YS_VipInfoCollectionViewCell
- (void)CellSetValue:(YS_PrivilegeModel*)model{
    [self.VipInfoimage sd_setImageWithURL:[NSURL URLWithString:model.b35]  placeholderImage:nil];
    self.code=model.b13;
    self.VipLable.text=model.b51;
}
- (void)awakeFromNib {
    // Initialization code
}

@end
