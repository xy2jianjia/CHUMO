//
//  BasicCell.h
//  StrangerChat
//
//  Created by zxs on 15/11/19.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicCell : UITableViewCell {


    UILabel *textLabel;
    UIImageView *portrait;  // 头像
    UIImageView *arrow;
    UILabel *oneLine;
    UILabel *twoLine;

}
+ (CGFloat)basicCellHeight;

- (void)addWithText:(NSString *)text portrait:(NSURL *)aportrait arrow:(NSString *)arrowImage;
@end
