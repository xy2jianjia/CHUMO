//
//  PersonViewCell.h
//  StrangerChat
//
//  Created by zxs on 15/11/25.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonViewCell : UITableViewCell {

    UILabel *nameLabel;
    UILabel *newVersion;
    UILabel *upLine;
    UILabel *downLine;
}
+ (CGFloat)PersonViewCellHeight;
- (void)addWithName:(NSString *)name newVersion:(NSString *)version;
@end
