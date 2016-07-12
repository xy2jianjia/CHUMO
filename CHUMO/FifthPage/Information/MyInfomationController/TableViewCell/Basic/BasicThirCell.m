//
//  BasicThirCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/19.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "BasicThirCell.h"

@implementation BasicThirCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor=kUIColorFromRGB(0x323232);
    [self.contentView addSubview:nameLabel];
    
    _details = [[UILabel alloc] init];
    _details.textAlignment = NSTextAlignmentRight;
    _details.font = [UIFont systemFontOfSize:13];
    _details.textColor=kUIColorFromRGB(0x323232);
    [self.contentView addSubview:_details];
    
    _lines = [[UILabel alloc] init];
    _lines.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [self.contentView addSubview:_lines];
    
    _oneLine = [[UILabel alloc] init];
    _oneLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [self.contentView addSubview:_oneLine];
    
    _twoLine = [[UILabel alloc] init];
    _twoLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [self.contentView addSubview:_twoLine];
}

- (void)layoutSubviews {
    
    nameLabel.frame = CGRectMake(10, 5, 50, 30);
    _details.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width-120-20, 5, 120, 30);
    
}


+ (CGFloat)basicThirCellHeight {

    return 40;
}
- (void)addTxt:(NSString *)name {
    
    nameLabel.text = name;
}

@end
