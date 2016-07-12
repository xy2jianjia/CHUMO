//
//  HomeTitleTableViewCell.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/3/7.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTitleTableViewCell : UITableViewCell
- (void)updateCellAndTitle:(NSString *)title mainTitle:(NSString *)mainTitle detailTitle:(NSString *)detailTitle AndImage:(NSString *)imageUrl;
- (void)updateConstraintsAndImageLeadCon:(CGFloat)leadCon imageWidth:(CGFloat)imagewidth TitleCon:(CGFloat)titleCon;
+ (CGFloat)CellHeight;
- (void)setCellTitleImageTextColor:(UIColor *)color;
@end
