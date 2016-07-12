//
//  PersonViewCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/25.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "PersonViewCell.h"

@implementation PersonViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:nameLabel];
        
        newVersion = [[UILabel alloc] init];
        newVersion.textColor = kUIColorFromRGB(0xF04D6D);
        newVersion.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:newVersion];
        
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

    nameLabel.frame = CGRectMake(15, 10, 120, 30);
    newVersion.frame = CGRectMake(self.bounds.size.width - 120 - 30, 10, 120, 30);
    upLine.frame = CGRectMake(0, 0, self.bounds.size.width, 0.5);
    downLine.frame = CGRectMake(0, 44.5, self.bounds.size.width, 0.5);
}

+ (CGFloat)PersonViewCellHeight {

    return 35;
}
- (void)addWithName:(NSString *)name newVersion:(NSString *)version {

    nameLabel.text = name;
    newVersion.text = version;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
