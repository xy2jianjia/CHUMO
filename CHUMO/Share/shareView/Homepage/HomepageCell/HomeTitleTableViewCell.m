//
//  HomeTitleTableViewCell.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/3/7.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "HomeTitleTableViewCell.h"
@interface HomeTitleTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CellTitleConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CellImageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CellImageLeadConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *CellTitleImage;//图片
@property (weak, nonatomic) IBOutlet UILabel *CellTitleImageLabel;//图片上的文字
@property (weak, nonatomic) IBOutlet UILabel *CellMainTitle;//主要文字
@property (weak, nonatomic) IBOutlet UILabel *CellDetailTitle;//详细文字


@end
@implementation HomeTitleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)updateCellAndTitle:(NSString *)title mainTitle:(NSString *)mainTitle detailTitle:(NSString *)detailTitle AndImage:(NSString *)imageUrl{
    self.CellMainTitle.text=mainTitle;
    self.CellDetailTitle.text=detailTitle;
    self.CellTitleImage.image=[UIImage imageNamed:imageUrl];
    self.CellTitleImageLabel.text=title;
}
- (void)updateConstraintsAndImageLeadCon:(CGFloat)leadCon imageWidth:(CGFloat)imagewidth TitleCon:(CGFloat)titleCon{
    self.CellImageLeadConstraint.constant=leadCon;
    self.CellImageWidthConstraint.constant=imagewidth;
    self.CellTitleConstraint.constant=titleCon;
}
- (void)setCellTitleImageTextColor:(UIColor *)color{
    self.CellTitleImageLabel.textColor=color;
}
+ (CGFloat)CellHeight{
    return 35;
}
@end
