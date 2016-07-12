//
//  HMakeFriendCell.h
//  StrangerChat
//
//  Created by zxs on 15/11/25.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMakeFriendCell : UITableViewCell {

    UILabel *makeFriend;
    UILabel *upLine;
    
}
@property (nonatomic,strong)UILabel *content;
@property (nonatomic,strong)UILabel *downLine;
+ (CGFloat)makeFriendcellHeight;
- (void)addDataWithtitle:(NSString *)title;

@end
