//
//  TemptationTableViewCell.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/6/30.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemptationTableViewCell : UITableViewCell{
    UILabel *titleLabel;
    UIView *spareView;//间隔
    UIView *contentView;
}
- (void)setValueOfInfoByArray:(NSArray *)infoArr Title:(NSString *)titleStr;
@end
