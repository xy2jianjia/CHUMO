//
//  BecomeVipCell.h
//  StrangerChat
//
//  Created by zxs on 15/11/23.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BecomeVipCell : UITableViewCell {

    UIView *allView;
    UIImageView *becomeVip;
    UILabel *titleLabel;
}
+ (CGFloat)becomeVipCellHeight;
- (void)addWithimage:(NSString *)imageVip title:(NSString *)title;
@end
