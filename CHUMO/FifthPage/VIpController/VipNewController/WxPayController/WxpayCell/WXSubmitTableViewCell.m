//
//  WXSubmitTableViewCell.m
//  StrangerChat
//
//  Created by 朱瀦潴 on 16/1/26.
//  Copyright © 2016年 long. All rights reserved.
//

#import "WXSubmitTableViewCell.h"

@implementation WXSubmitTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}
-(void)setupView{
    
    self.details = [[UIButton alloc] init];
    [self.details.layer setMasksToBounds:YES];
    [self.details.layer setCornerRadius:40/2];
    self.details.backgroundColor = MainBarBackGroundColor;
    [self.details setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.contentView addSubview:_details];
}
- (void)layoutSubviews{
    self.details.frame=CGRectMake(20, 20, [[UIScreen mainScreen] bounds].size.width-20-20, 40);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
