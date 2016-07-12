//
//  NConditionCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/27.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "NConditionCell.h"

@implementation NConditionCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        typeLabel = [[UILabel alloc] init];
        typeLabel.textColor = kUIColorFromRGB(0x808080);
        typeLabel.font = [UIFont fontWithName:Typefaces size:16.0f];
        [self.contentView addSubview:typeLabel];
        
        _contents = [[UILabel alloc] init];
        _contents.font = [UIFont fontWithName:Typefaces size:15.0f];
        _contents.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_contents];
        
        _allLine = [[UILabel alloc] init];
        _allLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
        [self.contentView addSubview:_allLine];
        
        _upLine = [[UILabel alloc] init];
        _upLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
        [self.contentView addSubview:_upLine];
    }
    return self;
}


- (void)layoutSubviews {

    typeLabel.frame = CGRectMake(20, 5, 80, 35);
    _contents.frame = CGRectMake(self.bounds.size.width - 170 - 10, 5, 170, 35);

}

+ (CGFloat)conditionCellHeight {
    
    return 45;
}
- (void)addTitletype:(NSString *)type {

    typeLabel.text = type;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
