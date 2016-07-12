//
//  BasicThirCell.h
//  StrangerChat
//
//  Created by zxs on 15/11/19.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicThirCell : UITableViewCell {

    UILabel *nameLabel;
    
}
+ (CGFloat)basicThirCellHeight;
- (void)addTxt:(NSString *)name;
@property (nonatomic,strong)UILabel *details;
@property (nonatomic,strong)UILabel *lines;
@property (nonatomic,strong)UILabel *oneLine;
@property (nonatomic,strong)UILabel *twoLine;
@end
