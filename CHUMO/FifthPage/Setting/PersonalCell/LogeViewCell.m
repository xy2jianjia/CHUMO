//
//  LogeViewCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/25.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "LogeViewCell.h"

@implementation LogeViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        signOut = [[UILabel alloc] init];
        signOut.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:signOut];
        
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
    signOut.frame = CGRectMake(self.bounds.size.width/2 - 60, 10, 120, 35);
    upLine.frame = CGRectMake(0, 0, self.bounds.size.width, 0.5);
    downLine.frame = CGRectMake(0, 54.5, self.bounds.size.width, 0.5);
}
- (void)addWithSign:(NSString *)sign {

    signOut.text = sign;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
