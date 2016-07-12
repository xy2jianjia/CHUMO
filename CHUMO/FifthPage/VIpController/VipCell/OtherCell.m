//
//  OtherCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/20.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "OtherCell.h"

@implementation OtherCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self n_setUp];
    }
    return self;
}

- (void)n_setUp {

    VipImage = [[UIImageView alloc] init];
    [self.contentView addSubview:VipImage];
    
    nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:nameLabel];
    
    _lines = [[UILabel alloc] init];
    _lines.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_lines];

}

- (void)layoutSubviews {

    VipImage.frame = CGRectMake(15, 10, 30, 30);
    nameLabel.frame = CGRectMake(CGRectGetMaxX(VipImage.frame)+20, 10, 150, 30);
    
}

- (void)addWithImage:(NSString *)image label:(NSString *)label {

    VipImage.image = [UIImage imageNamed:image];
    nameLabel.text = label;
}

@end
