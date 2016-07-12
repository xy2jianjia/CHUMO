//
//  N_photoViewCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/25.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "N_photoViewCell.h"

@implementation N_photoViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _allView = [[UIView alloc] init];
        _allView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_allView];
        
        upLine = [[UILabel alloc] init];
        upLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
        [self.contentView addSubview:upLine];
        
        downLine = [[UILabel alloc] init];
        downLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
        [self.contentView addSubview:downLine];
    }
    return self;
}

- (void)layoutSubviews {

    [super layoutSubviews];
    _allView.frame = self.bounds;
    upLine.frame = CGRectMake(0, 0, self.bounds.size.width, 0.5);
    downLine.frame = CGRectMake(0, 80-0.5, self.bounds.size.width, 0.5);

}

+ (CGFloat)photocellHeight {

    return 80;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
