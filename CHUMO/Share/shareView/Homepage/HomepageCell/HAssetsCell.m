//
//  HAssetsCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/25.
//  Copyright (c) 2015年 long. All rights reserved.
//  资产

#import "HAssetsCell.h"

@implementation HAssetsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews {
    
    assets = [[UILabel alloc] init];
    assets.textColor = kUIColorFromRGB(0xaaaaaa);
    assets.font = [UIFont fontWithName:Typefaces size:12.0f];
    assets.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:assets];
    
    monthImage = [[UIImageView alloc] init];
    monthImage.backgroundColor = kUIColorFromRGB(0xCCCCCC);
    [self.contentView addSubview:monthImage];
    
    month = [[UILabel alloc] init];
    month.font = [UIFont fontWithName:Typefaces size:14.0f];
    [self.contentView addSubview:month];
    
    propertyImage = [[UIImageView alloc] init];
    propertyImage.backgroundColor = kUIColorFromRGB(0xCCCCCC);
    [self.contentView addSubview:propertyImage];
    
    property = [[UILabel alloc] init];
    property.font = [UIFont fontWithName:Typefaces size:14.0f];
    [self.contentView addSubview:property];
    
    carImage = [[UIImageView alloc] init];
    carImage.backgroundColor = kUIColorFromRGB(0xCCCCCC);
    [self.contentView addSubview:carImage];
    
    car = [[UILabel alloc] init];
    car.font = [UIFont fontWithName:Typefaces size:14.0f];
    [self.contentView addSubview:car];
    
    vipImage = [[UIButton alloc] init];
    [vipImage addTarget:self action:@selector(vipAciton:) forControlEvents:(UIControlEventTouchUpInside)];
    vipImage.tag = 101;
    [self.contentView addSubview:vipImage];

    upLine = [[UILabel alloc] init];
    upLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [self.contentView addSubview:upLine];
    
    downLine = [[UILabel alloc] init];
    downLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [self.contentView addSubview:downLine];
    
}

- (void)vipAciton:(UIButton *)sender {

    [self.assetsDelegate setCellBt:self vcBtag:sender.tag];
}

- (void)layoutSubviews {

    assets.frame = CGRectMake(10, 10, 60, 35);
    monthImage.frame = CGRectMake(CGRectGetMaxX(assets.frame)+15, 21, 12, 12);
    monthImage.layer.cornerRadius = monthImage.frame.size.width / 2;
    month.frame = CGRectMake(CGRectGetMaxX(monthImage.frame), 10, 55, 35);
    
    propertyImage.frame = CGRectMake(CGRectGetMaxX(month.frame)+([[UIScreen mainScreen] bounds].size.width - 351)/3, 21, 12, 12);
    propertyImage.layer.cornerRadius = propertyImage.frame.size.width / 2;
    property.frame = CGRectMake(CGRectGetMaxX(propertyImage.frame), 10, 40, 35);
    carImage.frame = CGRectMake(CGRectGetMaxX(property.frame)+([[UIScreen mainScreen] bounds].size.width - 351)/3, 21, 12, 12);
    carImage.layer.cornerRadius = carImage.frame.size.width / 2;
    car.frame = CGRectMake(CGRectGetMaxX(carImage.frame), 10, 40, 35);
    
    vipImage.frame = CGRectMake(self.bounds.size.width - 60 - 15, 12.5, 65, 30);
    upLine.frame = CGRectMake(0, 0, self.bounds.size.width, 0.5);
    downLine.frame = CGRectMake(0, 54.5, self.bounds.size.width, 0.5);
}

+ (CGFloat)assetscellHeight{
    
    return 55;
}

- (void)addDataWithassets:(NSString *)assetsTitle monthImage:(NSString *)monImage month:(NSString *)mon propertyImage:(NSString *)proImage property:(NSString *)proper carImage:(NSString *)carImag car:(NSString *)cars vipImage:(NSString *)vip {

    assets.text = assetsTitle;
    monthImage.image = [UIImage imageNamed:monImage];
    month.text = mon;
    propertyImage.image = [UIImage imageNamed:proImage];
    property.text = proper;
    carImage.image = [UIImage imageNamed:carImag];
    car.text = cars;
    [vipImage setImage:[UIImage imageNamed:vip] forState:(UIControlStateNormal)];

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
