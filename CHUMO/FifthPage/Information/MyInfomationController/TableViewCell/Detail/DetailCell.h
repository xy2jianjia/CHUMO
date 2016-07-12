//
//  DetailCell.h
//  StrangerChat
//
//  Created by zxs on 15/11/19.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCell : UITableViewCell {

    UILabel *nameLabel;
    
}

@property (nonatomic,strong)UILabel *upLine;
@property (nonatomic,strong)UILabel *downLine;
@property (nonatomic,strong)UILabel *details;
+ (CGFloat)detaiCellHeight;
- (void)addTxt:(NSString *)name;

@end
