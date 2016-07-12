//
//  HTBasicdataCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/25.
//  Copyright (c) 2015年 long. All rights reserved.
//  基本资料

#import "HTBasicdataCell.h"

@implementation HTBasicdataCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        someData = [[UILabel alloc] init];
        someData.textColor = kUIColorFromRGB(0x808080);
        someData.font = [UIFont fontWithName:Typefaces size:16.0f];
        someData.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:someData];
         
        
        _choice = [[UILabel alloc] init];
        _choice.font = [UIFont fontWithName:Typefaces size:13.0f];
        [self.contentView addSubview:_choice];
        
        
        _shortLine = [[UILabel alloc] init];
        _shortLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
        [self.contentView addSubview:_shortLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    someData.frame = CGRectMake(10, 10, 80, 35);
    _choice.frame = CGRectMake(CGRectGetMaxX(someData.frame)+15, 10, 220, 35);
    
    
}

+ (CGFloat)basicdatacellHeight {

    return 55;
}

- (void)addDataWithsomeData:(NSString *)data  {
    
    someData.text = data;
    

}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
