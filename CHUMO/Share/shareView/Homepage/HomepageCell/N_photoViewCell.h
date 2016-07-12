//
//  N_photoViewCell.h
//  StrangerChat
//
//  Created by zxs on 15/11/25.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface N_photoViewCell : UITableViewCell {

    UILabel *upLine;
    UILabel *downLine;
}
+ (CGFloat)photocellHeight;
@property (nonatomic,strong)UIView *allView;
@end
