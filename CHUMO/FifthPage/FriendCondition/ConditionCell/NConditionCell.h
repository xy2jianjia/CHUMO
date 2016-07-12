//
//  NConditionCell.h
//  StrangerChat
//
//  Created by zxs on 15/11/27.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NConditionCell : UITableViewCell {
    
    UILabel *typeLabel;
}
@property (nonatomic,strong)UILabel *allLine;
@property (nonatomic,strong)UILabel *upLine;
@property (nonatomic,strong)UILabel *contents;
+ (CGFloat)conditionCellHeight;
- (void)addTitletype:(NSString *)type;
@end
