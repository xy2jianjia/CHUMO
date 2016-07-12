//
//  VipViewCell.h
//  StrangerChat
//
//  Created by zxs on 15/11/20.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VipViewCell : UITableViewCell {

    UILabel *Theme; //主题
    UILabel *line;
    UILabel *downLine;
}

+ (CGFloat)VipViewCellHeight;
- (void)addTheme:(NSString *)title;
@end
