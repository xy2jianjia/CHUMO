//
//  DHLiveCell.m
//  CHUMO
//
//  Created by xy2 on 16/7/6.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHLiveCell.h"
@interface DHLiveCell()

/**
 *  头像
 */
@property (nonatomic,strong) UIImageView *headerImageV;
/**
 *  用户名背景层
 */
@property (nonatomic,strong) UIView *nameBgView;
/**
 *  直播状态指示图
 */
@property (nonatomic,strong) UIImageView *statusImageV;
/**
 *  用户名
 */
@property (nonatomic,strong) UILabel *nameLabel;


@end

@implementation DHLiveCell


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configCell];
    }
    return self;
}
- (void)configCell{
    
    _headerImageV = [[UIImageView alloc]init];
    _headerImageV.frame = self.bounds;
//    [_headerImageV sd_setImageWithURL:[NSURL URLWithString:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1467786522&di=aabc13676e1bab6196f255c345e7067e&src=http://t-1.tuzhan.com/9f22a0485752/c-2/l/2013/04/15/16/782a7cb2988148eebac581a688ce8f2c.jpg"] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
    _headerImageV.contentMode = UIViewContentModeScaleAspectFill;
    _headerImageV.clipsToBounds = YES;
    [self.contentView addSubview:_headerImageV];
    
    _nameBgView = [[UIView alloc]init];
    _nameBgView.frame = CGRectMake(4, CGRectGetMaxY(_headerImageV.bounds)-22, 74, 16);
    
    _nameBgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.66666];
    _nameBgView.layer.cornerRadius = 3.5;
    _nameBgView.layer.masksToBounds = YES;
    [_headerImageV addSubview:_nameBgView];
    
    _statusImageV = [[UIImageView alloc]init];
    _statusImageV.frame = CGRectMake(CGRectGetMinX(_nameBgView.bounds)+4, CGRectGetMinY(_nameBgView.bounds)+5, 6, 6);
//    [_statusImageV sd_setImageWithURL:[NSURL URLWithString:@"http://img2.imgtn.bdimg.com/it/u=3337962088,2149159226&fm=21&gp=0.jpg"] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
    _statusImageV.backgroundColor = kUIColorFromRGB(0x934de6);
    _statusImageV.layer.cornerRadius = 3;
    _statusImageV.layer.masksToBounds = YES;
    [_nameBgView addSubview:_statusImageV];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_statusImageV.frame)+3, CGRectGetMinY(_nameBgView.bounds), CGRectGetWidth(_nameBgView.bounds)-12, CGRectGetHeight(_nameBgView.bounds));
    _nameLabel.font = [UIFont systemFontOfSize:10];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = kUIColorFromRGB(0x323232);
//    _nameLabel.text = @"宋晓梅";
    [_nameBgView addSubview:_nameLabel];
    
    
    
}
- (void)setDHLiveInfoModel:(DHLiveInfoModel *)liveInfoModel{
    _nameLabel.text = [liveInfoModel.name length] == 0? @"":liveInfoModel.name;
    [_headerImageV sd_setImageWithURL:[NSURL URLWithString:liveInfoModel.image] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
}
-(void)layoutSubviews{
    
    CGFloat width = [self hightForContent:_nameLabel.text fontSize:10].width;
    CGRect temp = _nameLabel.frame;
    temp.size.width = width + 10;
    _nameLabel.frame = temp;
    
    CGRect temp1 = _nameBgView.frame;
    temp1.size.width = CGRectGetWidth(_statusImageV.frame) + 8 + width+10;
    _nameBgView.frame = temp1;
    
}
- (CGSize )hightForContent:(NSString *)content fontSize:(CGFloat)fontSize{
    CGSize size = [content boundingRectWithSize:CGSizeMake(250, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size;
}
@end
