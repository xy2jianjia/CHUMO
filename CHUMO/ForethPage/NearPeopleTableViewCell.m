//
//  NearPeopleTableViewCell.m
//  StrangerChat
//
//  Created by long on 15/11/11.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "NearPeopleTableViewCell.h"

@implementation NearPeopleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addAllViews];
    }
    
    return self;
}
- (NSInteger )randomIndexWithMaxNumber:(NSInteger )max min:(NSInteger )min{
    
    NSInteger index = (arc4random() % (max-min+1))+min;
    return index;
    
}
- (UIColor *)getBorderColor{
    switch ([self randomIndexWithMaxNumber:8 min:1] ) {
        case 1:
        {
            return kUIColorFromRGB(0xffca39);
        }
            break;
        case 2:
        {
            return kUIColorFromRGB(0x39c9ff);
        }
            break;
        case 3:
        {
            return kUIColorFromRGB(0xff8d39);
        }
            break;
        case 4:
        {
            return kUIColorFromRGB(0x52c86e);
        }
            break;
        case 5:
        {
            return kUIColorFromRGB(0x9a52c8);
        }
            break;
        case 6:
        {
            return kUIColorFromRGB(0x57b1b4);
        }
            break;
        case 7:
        {
            return kUIColorFromRGB(0xdb6161);
        }
            break;
        case 8:
        {
            return kUIColorFromRGB(0xffb84c);
        }
            break;
            
        default:
        {
            return kUIColorFromRGB(0xffca39);
        }
            break;
    }
}
- (void)addAllViews
{
    UIColor *currentColor=[self getBorderColor];
    // 头像
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(got(10), gotHeight(15), gotHeight(60), gotHeight(60))];
    _iconImageView.layer.cornerRadius = gotHeight(30);
    _iconImageView.clipsToBounds = YES;
//    self.iconImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.iconImageView];
    
    // 名字
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(got(20)+gotHeight(60), gotHeight(10), got(100), gotHeight(20))];
    self.nameLabel.font = [UIFont systemFontOfSize:got(14)];
    //self.nameLabel.backgroundColor = [UIColor cyanColor];
    [self.contentView addSubview:self.nameLabel];
    
    // 会员图标
    self.kingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(got(110), gotHeight(11), gotHeight(17), gotHeight(14))];
    self.kingImageView.image = [UIImage imageNamed:@"icon-name-vip.png"];
    
    // 年龄
    self.ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(got(20)+gotHeight(60), gotHeight(35), got(30), gotHeight(20))];
    self.ageLabel.font = [UIFont systemFontOfSize:got(11)];
    [self.contentView addSubview:self.ageLabel];
    // 身高
    self.heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_ageLabel.frame)+10, CGRectGetMinY(_ageLabel.frame), got(60), CGRectGetHeight(_ageLabel.frame))];
    self.heightLabel.font = [UIFont systemFontOfSize:got(11)];
//    self.heightLabel.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_heightLabel];
    // 兴趣
    self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(got(20)+gotHeight(60), gotHeight(65), got(30), gotHeight(15))];
    //self.label2.backgroundColor = [UIColor yellowColor];
    self.label2.layer.cornerRadius = got(2);
    self.label2.clipsToBounds = YES;
    self.label2.layer.borderWidth = got(1);
    self.label2.font = [UIFont systemFontOfSize:got(11)];
    self.label2.textAlignment = NSTextAlignmentCenter;
    self.label2.layer.borderColor = currentColor.CGColor;
    self.label2.hidden=YES;
    self.label2.textColor = currentColor;
    
    [self.contentView addSubview:self.label2];

    self.label3 = [[UILabel alloc] initWithFrame:CGRectMake(got(20)+gotHeight(60)+got(45), gotHeight(65), got(30), gotHeight(15))];
    //self.label3.backgroundColor = [UIColor blueColor];
    self.label3.layer.cornerRadius = got(2);
    self.label3.clipsToBounds = YES;
    self.label3.textAlignment = NSTextAlignmentCenter;
    self.label3.layer.borderWidth = got(1);
    self.label3.layer.borderColor = currentColor.CGColor;
    self.label3.font = [UIFont systemFontOfSize:got(11)];
    self.label3.textColor = currentColor;
    self.label3.hidden=YES;
    [self.contentView addSubview:self.label3];
    
    // 距离
    self.placeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(got(225), gotHeight(16), got(11), gotHeight(13))];
    _placeImageView.image = [UIImage imageNamed:@"icon-locate-normal.png"];
    [self.contentView addSubview:self.placeImageView];
    
    self.placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(got(245), gotHeight(15), got(70), gotHeight(15))];
    self.placeLabel.textColor = [UIColor grayColor];
    self.placeLabel.font = [UIFont systemFontOfSize:got(12)];
    [self.contentView addSubview:self.placeLabel];
    
    // 打招呼
    self.hiButton = [[UIButton alloc] initWithFrame:CGRectMake(got(220), gotHeight(35), got(67), gotHeight(20))];
//    [self.hiButton setTitle:@"打招呼" forState:(UIControlStateNormal)];
    self.hiButton.titleLabel.textAlignment = NSTextAlignmentRight;
    self.hiButton.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [self.contentView addSubview:self.hiButton];

}

- (void)setModel:(DHUserInfoModel *)model
{
    _model = model;
    
    // 计算文字高度
    CGFloat width = [NearPeopleTableViewCell calsLabelHeightWithText:model.b52];
    
    // 将文字Label高度修改
    CGRect frame = _nameLabel.frame;
    frame.size.width = width+got(10);
    _nameLabel.frame = frame;
    
    CGRect frame2 = _kingImageView.frame;
    frame2.origin.x = _nameLabel.frame.origin.x + width+got(10);
    _kingImageView.frame = frame2;
    
    // 会员标识
    NSURL *iconUrl = [NSURL URLWithString:model.b57];
    [self.iconImageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
    
    if ([model.b144 integerValue] == 1) { //会员
        self.nameLabel.textColor = [UIColor colorWithRed:239/255.0 green:45/255.0 blue:85/255.0 alpha:1];
        [self.contentView addSubview:self.kingImageView];
    }else{
        self.nameLabel.textColor = [UIColor blackColor];
        [self.kingImageView removeFromSuperview];
    }
    // 名字
    self.nameLabel.text = model.b52;
    
    // b1 b33
    NSString *ageStr = nil;
    NSString *bodyHeight = nil;
    if ([model.b1 integerValue] == 0 || model.b1 == NULL) {
        ageStr = @"保密";
    }else{
        ageStr = [NSString stringWithFormat:@"%@岁",model.b1];
    }
    if ([model.b33 integerValue] == 0 || model.b33 == NULL) {
        bodyHeight = @"保密";
    }else{
        bodyHeight = [NSString stringWithFormat:@"%@ cm",model.b33];
    }
    
    self.ageLabel.text = [NSString stringWithFormat:@"%@",ageStr];
    self.heightLabel.text = [NSString stringWithFormat:@"%@",bodyHeight];
    CGFloat placeNum = [model.b94 floatValue]/1000;
    
    if (placeNum<0.1) {
        self.placeLabel.text = [NSString stringWithFormat:@"< 100m"];
    }else{
       self.placeLabel.text = [NSString stringWithFormat:@"%.2fkm",placeNum];
    }
    
    
    // b37 b24  特征和爱好
    NSDictionary *kidneyDict = nil;
//    [NSDictionary dictionary];// 特征
    NSDictionary *favoriteDict = nil;
//    [NSDictionary dictionary];
    
    if ([model.b69 integerValue] == 1) {// 男
        kidneyDict = [NSGetSystemTools getkidney1];
        favoriteDict = [NSGetSystemTools getfavorite1];
    }else{
        kidneyDict = [NSGetSystemTools getkidney2];
        favoriteDict = [NSGetSystemTools getfavorite2];
    }
    if ([model.b37 length] > 0) {
        self.label2.hidden=NO;
        NSString *b37 = [model.b37 substringToIndex:4];
        NSString *kidneyStr = kidneyDict[b37];
        CGFloat width2 = [NearPeopleTableViewCell calsLabelHeightWithText:kidneyStr];
        CGRect frame3 = _label2.frame;
        frame3.size.width = width2+got(5);
        _label2.frame = frame3;
        
        self.label2.text = kidneyStr;
        if (model.b24 != nil || model.b24 != NULL ) {
            self.label3.hidden=NO;
            NSString *b24 = [model.b24 substringToIndex:4];
            NSString *favoriteStr = favoriteDict[b24];
            
            CGFloat width4 = [NearPeopleTableViewCell calsLabelHeightWithText:favoriteStr];
            CGRect frame5 = _label3.frame;
            frame5.origin.x = _label2.frame.origin.x + width2 + got(10);
            frame5.size.width = width4+got(5);
            _label3.frame = frame5;
            self.label3.text = favoriteStr;
        }else{
            self.label3.hidden=YES ;
        }
    }else{
        self.label2.hidden=YES;
        if ([model.b24 length] > 0 ) {
            self.label3.hidden=NO;
            NSString *b24 = [model.b24 substringToIndex:4];
            NSString *favoriteStr = favoriteDict[b24];
            CGFloat width3 = [NearPeopleTableViewCell calsLabelHeightWithText:favoriteStr];
            CGRect frame4 = _label3.frame;
            frame4.origin.x = got(20)+gotHeight(60);
            frame4.size.width = width3+got(5);
            _label3.frame = frame4;
            self.label3.text = favoriteStr;
        }else{
            self.label3.hidden=YES ;
        }
        
    }
    
    
    
}


// 文字宽度
+ (CGFloat)calsLabelHeightWithText:(NSString *)string;
{
    //size:表示允许文字所在的最大范围
    //options: 一个参数,计算高度时候用 NSStringDrawingUserLineFragmentOrigin
    //attributes:表示文字的某个属性(通常是文字大小)
    //context:上下文对象,通常写nil;
    CGRect rect = [string boundingRectWithSize:CGSizeMake(got(100), 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0f]} context:nil];
    return rect.size.width;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
