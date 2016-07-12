//
//  HMakeFriendCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/25.
//  Copyright (c) 2015年 long. All rights reserved.
//  交友宣言

#import "HMakeFriendCell.h"

@implementation HMakeFriendCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        makeFriend = [[UILabel alloc] init];
        makeFriend.textColor = kUIColorFromRGB(0xaaaaaa);
        makeFriend.textAlignment = NSTextAlignmentRight;
        makeFriend.font = [UIFont fontWithName:Typefaces size:12.0f];
        [self.contentView addSubview:makeFriend];
        
        upLine = [[UILabel alloc] init];
        upLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
        [self.contentView addSubview:upLine];
        
        _downLine = [[UILabel alloc] init];
        _downLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
        [self.contentView addSubview:_downLine];
        
    }
    return self;
}

- (UILabel *)content
{
    if (_content == nil) {
        _content = [[UILabel alloc] init];
        _content.frame = CGRectMake(70+20, 15, [[UIScreen mainScreen]bounds].size.width-20-10-70, 30);
        _content.font = [UIFont fontWithName:nil size:13.0f];
        _content.lineBreakMode =NSLineBreakByCharWrapping; // 保留边界
        _content.numberOfLines = 0;
        _content.textColor=kUIColorFromRGB(0x323232);
        [self.contentView addSubview:_content];
    }
    return _content;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    makeFriend.frame = CGRectMake(10, 10, 60, 25);
    upLine.frame = CGRectMake(0, 0, self.bounds.size.width, 0.5);
}

- (void)addDataWithtitle:(NSString *)title {

    makeFriend.text = title;
    
}
+ (CGFloat)makeFriendcellHeight {

    return 0;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
