//
//  HeaderViewCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/23.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "HeaderViewCell.h"

@implementation HeaderViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self n_layout];
    }
    return self;
}

- (void)n_layout {

    monthImage = [[UIImageView alloc] init];
    [self.contentView addSubview:monthImage];
    
    everyDay = [[UILabel alloc] init];
    [self.contentView addSubview:everyDay];
    
    price = [[UILabel alloc] init];
    [self.contentView addSubview:price];
    
    _dotButton = [[UIButton alloc] init];
    [self.contentView addSubview:_dotButton];
    
}


- (void)layoutSubviews {

    [super layoutSubviews];
    monthImage.frame = CGRectMake(20, 7, 55, 35);
    everyDay.frame = CGRectMake(CGRectGetMaxX(monthImage.frame)+([[UIScreen mainScreen] bounds].size.width - 60-80 -60-30-55)/3, 10, 90, 30);
    price.frame = CGRectMake(CGRectGetMaxX(everyDay.frame)+([[UIScreen mainScreen] bounds].size.width - 60-70 -60-30-55)/3, 10, 60, 30);
    _dotButton.frame = CGRectMake(self.frame.size.width-20-15, 10, 30, 30);
    

}


+ (CGFloat)HeaderViewCellHeight {
    
    return 50;
}
- (void)addWithmonthImage:(NSString *)image everyDay:(NSString *)day price:(NSString *)VipPrice {


    monthImage.image = [UIImage imageNamed:image];
    everyDay.text = day;
    price.text = VipPrice;
}
@end
