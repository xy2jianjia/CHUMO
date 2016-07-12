//
//  HPersonalityCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/25.
//  Copyright (c) 2015年 long. All rights reserved.
// 个性特征

#import "HPersonalityCell.h"

@implementation HPersonalityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews {
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = kUIColorFromRGB(0xaaaaaa);
    titleLabel.font = [UIFont fontWithName:Typefaces size:12.0f];
    titleLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:titleLabel];
    
    self.content = [[UILabel alloc] init];
    self.content.textAlignment = NSTextAlignmentCenter;
    self.content.font = [UIFont fontWithName:Typefaces size:12.0f];
    self.content.layer.borderColor = [UIColor lightGrayColor].CGColor;//边框颜色,要为CGColor
    self.content.clipsToBounds = true;
    self.content.layer.cornerRadius = 4;
    [self.contentView addSubview:self.content];
    
    self.sContent = [[UILabel alloc] init];
    self.sContent.textAlignment = NSTextAlignmentCenter;
    self.sContent.font = [UIFont fontWithName:Typefaces size:12.0f];
    self.sContent.layer.borderColor = [UIColor lightGrayColor].CGColor;//边框颜色,要为CGColor
    self.sContent.clipsToBounds = true;  // 去掉边框颜色
    self.sContent.layer.cornerRadius = 4;
    [self.contentView addSubview:self.sContent];
    
    self.tContent = [[UILabel alloc] init];
    self.tContent.textAlignment = NSTextAlignmentCenter;
    self.tContent.font = [UIFont fontWithName:Typefaces size:12.0f];
    self.tContent.layer.borderColor = [UIColor lightGrayColor].CGColor;//边框颜色,要为CGColor
    self.tContent.clipsToBounds = true;  // 去掉边框颜色
    self.tContent.layer.cornerRadius = 4;
    [self.contentView addSubview:self.tContent];
    
    
    
    upLine = [[UILabel alloc] init];
    upLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [self.contentView addSubview:upLine];
    
    downLine = [[UILabel alloc] init];
    downLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [self.contentView addSubview:downLine];
    
}
 // (self.bounds.size.width - 335)/4
- (void)layoutSubviews {
    [super layoutSubviews];
    
    titleLabel.frame   = CGRectMake(10, 10, 60, 35);
    NSString *content  = _content.text;
    CGFloat width = [self stringWidth:content];
    self.content.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame)+15, 12.5, width+10, 30);
    
    NSString *scontent  = self.sContent.text;
    CGFloat swidth      = [self stringWidth:scontent];
    self.sContent.frame = CGRectMake(CGRectGetMaxX(self.content.frame)+5, 12.5, swidth+10, 30);
    
    NSString *tcontent  = self.tContent.text;
    CGFloat twidth      = [self stringWidth:tcontent];
    self.tContent.frame = CGRectMake(CGRectGetMaxX(self.sContent.frame)+5, 12.5, twidth+10, 30);
    
    upLine.frame = CGRectMake(0, 0, self.bounds.size.width, 0.5);
    downLine.frame = CGRectMake(0, 54.5, self.bounds.size.width, 0.5);
}



- (CGFloat)stringWidth:(NSString *)aString{
    
    CGRect r = [aString boundingRectWithSize:CGSizeMake(120, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil];
    return r.size.width;
}



+ (CGFloat)personacellHeight {

    return 55;
}



- (void)addDataWithtitleLabel:(NSString *)title {
    titleLabel.text = title;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
