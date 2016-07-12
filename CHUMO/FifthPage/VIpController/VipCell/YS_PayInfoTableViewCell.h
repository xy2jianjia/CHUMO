//
//  YS_PayInfoTableViewCell.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/5/3.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YS_PayInfoTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel *giftlabel;
@property (nonatomic,strong)UILabel *giftlabel2;
@property (nonatomic,strong)UIImageView *ButtonImage;
- (void)setPayName:(NSNumber *)Name PayPrice:(NSString *)Price ButImage:(NSString *)image giveaway:(NSString *)giftFlag giveMoney:(NSString *)moneyStr;
@end
