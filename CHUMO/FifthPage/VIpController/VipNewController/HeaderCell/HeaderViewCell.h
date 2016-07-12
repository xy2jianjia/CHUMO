//
//  HeaderViewCell.h
//  StrangerChat
//
//  Created by zxs on 15/11/23.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderViewCell : UITableViewCell {

    UIImageView *monthImage;
    UILabel *everyDay;
    UILabel *price;
}
@property (nonatomic,strong)UIButton *dotButton;

+ (CGFloat)HeaderViewCellHeight;
- (void)addWithmonthImage:(NSString *)image everyDay:(NSString *)day price:(NSString *)VipPrice;
@end
