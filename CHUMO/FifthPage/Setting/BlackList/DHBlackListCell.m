//
//  DHBlackListCell.m
//  CHUMO
//
//  Created by xy2 on 16/3/28.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHBlackListCell.h"

@implementation DHBlackListCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configSubviews];
    }
    return self;
}
- (void)configSubviews{
    // 头像
//    if (!self.headerImageV) {
        _headerImageV = [[UIImageView alloc]init];
//    }
    _headerImageV.frame = CGRectMake(10, 5, 50, 50);
    _headerImageV.userInteractionEnabled = YES;
    _headerImageV.layer.cornerRadius = 5;
//    _headerImageV.image = [UIImage imageNamed:@"list_item_icon"];
    [self.contentView addSubview:_headerImageV];
    
    // 名字
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_headerImageV.frame)+5, CGRectGetMinY(_headerImageV.frame), CGRectGetWidth(_headerImageV.frame), 20);
    _nameLabel.font = [UIFont systemFontOfSize:12];
//    _nameLabel.text = @"呵呵呵呵";
    _nameLabel.numberOfLines = 0;
    [self.contentView addSubview:_nameLabel];
    
    // vip
    _vipImageV = [[UIImageView alloc]init];
    _vipImageV.frame = CGRectMake(5, 7, 14, 12);
    _vipImageV.userInteractionEnabled = YES;
    _vipImageV.layer.cornerRadius = 5;
    _vipImageV.image = [UIImage imageNamed:@"icon-vip"];
    [self.contentView addSubview:_vipImageV];
    
    _blackTimeLabel = [[UILabel alloc]init];
    _blackTimeLabel.frame = CGRectMake(CGRectGetMaxX(_headerImageV.frame)+5, CGRectGetMaxY(_headerImageV.frame)-20, CGRectGetWidth(_headerImageV.frame), 20);
    _blackTimeLabel.font = [UIFont systemFontOfSize:12];
//    _blackTimeLabel.text = @"呵呵呵呵";
    _blackTimeLabel.numberOfLines = 0;
    [self.contentView addSubview:_blackTimeLabel];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGSize nameSize = [self getContentLabelSizeWithContent:_nameLabel.text];
    CGRect nameRect = _nameLabel.frame;
    nameRect.size.width = nameSize.width+10;
    _nameLabel.frame = nameRect;
    
    CGRect vipRect = _vipImageV.frame;
    vipRect.origin.x = CGRectGetMaxX(_nameLabel.frame)+5;
    _vipImageV.frame = vipRect;
    
    CGSize blackSize = [self getContentLabelSizeWithContent:_blackTimeLabel.text];
    CGRect blackRect = _blackTimeLabel.frame;
    blackRect.size.width = blackSize.width+10;
    _blackTimeLabel.frame = blackRect;
}
- (CGSize )getContentLabelSizeWithContent:(NSString *)aString{
    CGRect r = [aString boundingRectWithSize:CGSizeMake(ScreenWidth-50-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil];
    return r.size;
}

@end
