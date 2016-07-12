//
//  SearchTableViewCell.m
//  StrangerChat
//
//  Created by long on 15/11/11.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addAllViews];
    }
    
    return self;
}

- (void)addAllViews
{
    // 头像
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(got(10), gotHeight(15), gotHeight(60), gotHeight(60))];
    _iconImageView.layer.cornerRadius = 3;
    _iconImageView.clipsToBounds = YES;
    self.iconImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.iconImageView];
    
    // 名字
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(got(20)+gotHeight(60), gotHeight(15), got(100), gotHeight(20))];
    self.nameLabel.font = [UIFont systemFontOfSize:got(14)];
    //self.nameLabel.backgroundColor = [UIColor cyanColor];
    [self.contentView addSubview:self.nameLabel];
    
    // 会员图标
    self.kingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(got(110), gotHeight(16), gotHeight(17), gotHeight(14))];
    self.kingImageView.image = [UIImage imageNamed:@"icon-name-vip.png"];
    
    
    // 距离
    self.placeImage = [[UIImageView alloc] initWithFrame:CGRectMake(got(20)+gotHeight(60), gotHeight(40), got(16), gotHeight(16))];
    _placeImage.image = [UIImage imageNamed:@"icon-locate-normal.png"];
    [self.contentView addSubview:_placeImage];
    
    self.placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(got(20)+gotHeight(60)+got(18), gotHeight(40), got(100), gotHeight(15))];
    self.placeLabel.font = [UIFont systemFontOfSize:gotiphon6(12)];
    self.placeLabel.textColor=kUIColorFromRGB(0xaaaaaa);
    //self.placeLabel.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:self.placeLabel];
    
    // 年龄等
    self.detailView = [[UILabel alloc] initWithFrame:CGRectMake(got(20)+gotHeight(60), gotHeight(65), got(220), gotHeight(15))];
//    self.detailView.textColor = [UIColor grayColor];
//    self.detailView.font = [UIFont systemFontOfSize:got(11)];
    //self.detailLabel.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:self.detailView];
    
    
}

- (void)setSearchModel:(DHUserInfoModel *)searchModel
{
    _searchModel = searchModel;
    
    // 计算文字高度
    CGFloat width = [SearchTableViewCell calsLabelHeightWithText:searchModel.b52];
    
    
    // 将文字Label高度修改
    CGRect frame = _nameLabel.frame;
    frame.size.width = width+got(10);
    _nameLabel.frame = frame;
    
    CGRect frame2 = _kingImageView.frame;
    frame2.origin.x = _nameLabel.frame.origin.x + width+got(10);
    _kingImageView.frame = frame2;
    
    
    NSURL *iconUrl = [NSURL URLWithString:searchModel.b57];
    [self.iconImageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
    
    if ([searchModel.b144 integerValue] == 1) { //会员
        self.nameLabel.textColor = [UIColor colorWithRed:236/255.0 green:49/255.0 blue:88/255.0 alpha:1];
        [self.contentView addSubview:self.kingImageView];
    }else{
        self.nameLabel.textColor = [UIColor blackColor];
        [self.kingImageView removeFromSuperview];
    }
    
    self.nameLabel.text = searchModel.b52;
    
    
    
    // b1  b33  b67 b9  b19
    NSString *str1 = @"";
    if ([searchModel.b33 integerValue] > 0) {
       str1 = [NSString stringWithFormat:@"|%@cm",searchModel.b33];
    }else{
        str1 = @"";
    }
    //获取plist中的数据
    NSDictionary *cityDict = [NSDictionary dictionary];
    NSDictionary *stateDict = [NSDictionary dictionary];
    cityDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"codeCity" ofType:@"plist"]];
    stateDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"codeProvince" ofType:@"plist"]];
    
    NSString *cityCodeStr = [NSString stringWithFormat:@"%@",searchModel.b9];
    NSString *provinceCodeStr = [NSString stringWithFormat:@"%@",searchModel.b67];
    NSDictionary *cityNameDict = cityDict[cityCodeStr];
    NSDictionary *stateNameDict = stateDict[provinceCodeStr];
    NSDictionary *localDict = [NSGetTools getCLLocationData];
    NSInteger citycode = [[localDict objectForKey:@"a9"] integerValue];
    if (citycode == [cityCodeStr integerValue]) {
        self.placeLabel.hidden = NO;
        _placeImage.hidden = NO;
        CGFloat placeNum = [searchModel.b94 integerValue]/1000;
        self.placeLabel.text = [NSString stringWithFormat:@"%.2fkm",placeNum];
    }else{
        self.placeLabel.hidden = NO;
        _placeImage.hidden = NO;
        self.placeLabel.text = [NSString stringWithFormat:@"离你很远",nil];
    }
    NSString *cityName = cityNameDict[@"city_name"];// 城市
    cityName = [cityName substringToIndex:cityName.length - 1];
    NSString *provinceName = stateNameDict[@"province_name"];// 省
    provinceName = [provinceName substringToIndex:provinceName.length - 1];
    
    NSString *str2 = @"";
    
    if (cityName.length == 0 || cityName == NULL || provinceName.length == 0 || provinceName == NULL) {
        cityName = @"";
        provinceName = @"";
        str2 = @"";
    }else{
        str2 = [NSString stringWithFormat:@"|%@%@",provinceName,cityName];
    }
    
    NSString *str3 = @"";
    NSDictionary *eduDict = [NSGetSystemTools geteducationLevel];
    NSString *eduKey  = [NSString stringWithFormat:@"%@",searchModel.b19];
    NSString *eduStr = eduDict[eduKey];
    
    if (eduStr.length == 0 || eduStr == nil) {
        str3 = @"";
    }else{
        str3 = [NSString stringWithFormat:@"|%@",eduStr];
    }
    
    //在原来基础上改,把 原来的nsmuatablstring 分成数组 ,把detailLabel 改成detailView-----20160628
//    self.detailLabel.text = [NSString stringWithFormat:@"%@岁%@%@%@",[searchModel.b1 integerValue] == 0?@"18":searchModel.b1,str1,str2,str3];
    //去除label
    for (UILabel *label in [self.detailView subviews]) {
        [label removeFromSuperview];
    }
    NSString *allString=[NSString stringWithFormat:@"%@岁%@%@%@",[searchModel.b1 integerValue] == 0?@"18":searchModel.b1,str1,str2,str3];
    NSArray *detailArray=[allString componentsSeparatedByString:@"|"];
    CGFloat allwidth=0;
    for (int i=0; i<detailArray.count; i++) {
        CGFloat myselfWidth=[SearchTableViewCell calsLabelHeightWithText:detailArray[i]];
        UILabel *myselfLabel=[[UILabel alloc]initWithFrame:CGRectMake(allwidth, 0, myselfWidth, gotiphon6(20))];
        myselfLabel.text=detailArray[i];
        myselfLabel.textColor=kUIColorFromRGB(0x323232);
        myselfLabel.font=[UIFont systemFontOfSize:10.0f];
        myselfLabel.layer.cornerRadius=gotiphon6(20.0/2);
        myselfLabel.layer.borderColor=kUIColorFromRGB(0xaaaaaa).CGColor;
        myselfLabel.layer.borderWidth=0.5f;
        myselfLabel.layer.masksToBounds=YES;
        myselfLabel.textAlignment=NSTextAlignmentCenter;
        [self.detailView addSubview:myselfLabel];
        allwidth+=(myselfWidth+5);
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
