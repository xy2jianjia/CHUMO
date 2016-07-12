//
//  HChooseCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/25.
//  Copyright (c) 2015年 long. All rights reserved.
//  择友标准

#import "HChooseCell.h"

@implementation HChooseCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        makeFriend = [[UILabel alloc] init];
        makeFriend.textAlignment = NSTextAlignmentRight;
        makeFriend.textColor = kUIColorFromRGB(0x808080);
        makeFriend.font = [UIFont fontWithName:Typefaces size:17.0f];
        [self.contentView addSubview:makeFriend];
        
        _contents = [[UILabel alloc] init];
        
        _contents.font = [UIFont fontWithName:Typefaces size:17.0f];
        _contents.lineBreakMode =NSLineBreakByCharWrapping; // 保留边界
        _contents.numberOfLines = 3;
        [self.contentView addSubview:_contents];
        
        upLine = [[UILabel alloc] init];
        upLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
        [self.contentView addSubview:upLine];
        
        _downLine = [[UILabel alloc] init];
        _downLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
        [self.contentView addSubview:_downLine];
        
    }
    return self;
}




- (void)layoutSubviews {
    [super layoutSubviews];
    makeFriend.frame = CGRectMake(10, 10, 80, 30);
    _marrheiht      = [self hightForContent:_contents.text fontSize:20.f];
    _contents.frame = CGRectMake(CGRectGetMaxX(makeFriend.frame)+20, 10, self.bounds.size.width-20-95, _marrheiht);
    upLine.frame = CGRectMake(0, 0, self.bounds.size.width, 0.5);
    
}

- (CGFloat)hightForContent:(NSString *)content fontSize:(CGFloat)fontSize{
    CGSize size = [content boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-20-95, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size.height;
}

- (void)addDataWithtitle:(NSString *)title {
    
    makeFriend.text = title;
    
}
+ (CGFloat)HMarriagecellHeight {
    
    return 50;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
