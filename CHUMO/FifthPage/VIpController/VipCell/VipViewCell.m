
//
//  VipViewCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/20.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "VipViewCell.h"

@implementation VipViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {

    Theme = [[UILabel alloc] init];
    Theme.textColor = kUIColorFromRGB(0x808080);
    Theme.font = [UIFont fontWithName:nil size:20.0f];
    [self.contentView addSubview:Theme];
    
    line = [[UILabel alloc] init];
    line.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:line];
    
    downLine = [[UILabel alloc] init];
    downLine.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:downLine];
}

- (void)layoutSubviews {

    [super layoutSubviews];
    Theme.frame = CGRectMake(15, 10, 100, 30);
    line.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
    downLine.frame = CGRectMake(0, 50, self.frame.size.width, 0.5);
}

+ (CGFloat)VipViewCellHeight {

    return 50;
}

- (void)addTheme:(NSString *)title {
    
    Theme.text = title;
}
@end
