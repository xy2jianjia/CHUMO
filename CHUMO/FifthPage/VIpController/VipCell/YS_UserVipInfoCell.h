//
//  YS_UserVipInfoCell.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/5/4.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YS_UserVipInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipImage;
@property (weak, nonatomic) IBOutlet UIView *vipInfoView;
/**
 *  废弃
 *
 *  @param dict    <#dict description#>
 *  @param vipDict <#vipDict description#>
 */
- (void)setCellByDictionary:(NSDictionary *)dict ByVipDictionary:(NSArray *)vipDict;
- (void)setCellWithUserInfo:(DHUserInfoModel *)userinfo ByVipDictionary:(NSArray *)vipDict;
@end
