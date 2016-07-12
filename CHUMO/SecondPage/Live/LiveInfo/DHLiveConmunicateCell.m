//
//  DHLiveConmunicateCell.m
//  CHUMO
//
//  Created by xy2 on 16/7/6.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHLiveConmunicateCell.h"

@implementation DHLiveConmunicateCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self configViews];
    }
    return self;
}
- (void)configViews{
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.frame = CGRectMake(CGRectGetMinX([[UIScreen mainScreen] bounds]), 0, 100, 15);
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.textColor = kUIColorFromRGB(0xc4c4c4);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
//    _nameLabel.text = @"我是罗德曼：";
    [self.contentView addSubview:_nameLabel];
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame)+0, CGRectGetMinY(_nameLabel.frame), 100, 15);
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.textColor = kUIColorFromRGB(0xfffffe);
    _contentLabel.textAlignment = NSTextAlignmentLeft;
//    _contentLabel.text = @"主播哪个区的？。。。";
    _contentLabel.numberOfLines = 0;
    
    _contentLabel.shadowOffset = CGSizeMake(0, 1.0);
    _contentLabel.shadowColor = kUIColorFromRGB(0x333);
    _contentLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:_contentLabel];
    
}


-(void)setMessageModel:(LiveMessageModel *)messageModel{
    _nameLabel.text = [NSString stringWithFormat:@"%@：",messageModel.targetName];
    _contentLabel.text = [NSString stringWithFormat:@"%@",messageModel.message];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size1 = [self hightForContent:_nameLabel.text fontSize:15];
    
    CGRect temp1 = _nameLabel.frame;
    temp1.origin.x = CGRectGetMinX([[UIScreen mainScreen] bounds]);
    temp1.size.width = size1.width+0;
    temp1.size.height = size1.height+10;
    _nameLabel.frame = temp1;
    
    
    
    CGSize size2 = [self hightForContent:_contentLabel.text fontSize:15];
    CGRect temp2 = _contentLabel.frame;
    temp2.size.width = size2.width+10;
    temp2.size.height = size2.height + 10;
    temp2.origin.x =CGRectGetMaxX(_nameLabel.frame);
    _contentLabel.frame = temp2;
    
    CGRect temp3 = self.frame;
    if (_nameLabel.size.height == _contentLabel.size.height) {
        temp3.size.height = _nameLabel.size.height+0+0;
    }else{
        temp3.size.height = _nameLabel.size.height > _contentLabel.size.height ?_nameLabel.size.height+0+0:_contentLabel.size.height;
    }
    self.frame = temp3;
}
- (CGSize )hightForContent:(NSString *)content fontSize:(CGFloat)fontSize{
    CGSize size = [content boundingRectWithSize:CGSizeMake(ScreenWidth-120, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
