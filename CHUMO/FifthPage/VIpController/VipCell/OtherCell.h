//
//  OtherCell.h
//  StrangerChat
//
//  Created by zxs on 15/11/20.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherCell : UITableViewCell {

    UIImageView *VipImage;
    UILabel *nameLabel;
}
@property (nonatomic,strong)UILabel *lines;
- (void)addWithImage:(NSString *)image label:(NSString *)label;

@end
