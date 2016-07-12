//
//  TemptationTableViewCell.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/6/30.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "TemptationTableViewCell.h"

@implementation TemptationTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self set_upView];
    }
    return self;
}
- (void)set_upView{
    titleLabel=[UILabel new];
    titleLabel.frame=CGRectMake(10, CGRectGetMaxY(spareView.frame), 60, 25);
    
    titleLabel.textColor =  kUIColorFromRGB(0xaaaaaa);
    titleLabel.font=[UIFont fontWithName:Typefaces size:12.0f];
    titleLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:titleLabel];
    
    
    spareView=[UIView new];
    spareView.frame=CGRectMake(0, 0, ScreenWidth, gotHeight(10));
    spareView.backgroundColor=kUIColorFromRGB(0xf0edf2);
    [self.contentView addSubview:spareView];
    
    contentView=[UIView new];
    [self.contentView addSubview:contentView];
    
    
}
-(void)layoutSubviews{
    spareView.frame=CGRectMake(0, 0, ScreenWidth, gotHeight(10));
    titleLabel.frame=CGRectMake(10, CGRectGetMaxY(spareView.frame), 60, 25);
    
}
- (void)setValueOfInfoByArray:(NSArray *)infoArr Title:(NSString *)titleStr{
    titleLabel.text=titleStr;
    CGFloat allHeight=0;
    contentView.frame=CGRectMake(0, CGRectGetMaxY(titleLabel.frame), ScreenWidth, infoArr.count*35);
    
    for (UIView *viewa in contentView.subviews) {
        [viewa removeFromSuperview];
    }
    
    for (int i=0; i<infoArr.count; i++) {
        
        NSString *keyvalue = [[infoArr[i] allKeys] lastObject];
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+15, allHeight, 100, 35)];
        title.textColor=kUIColorFromRGB(0x323232);
        title.font=[UIFont systemFontOfSize:gotiphon6(13.0f)];
        title.text=keyvalue;
        
        [contentView addSubview:title];
        
        UILabel *info=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(title.frame)+10, allHeight, ScreenWidth-CGRectGetMaxX(title.frame)-10-10, 35)];
        info.textColor=kUIColorFromRGB(0x323232);
        info.font=[UIFont systemFontOfSize:gotiphon6(13.0f)];
        info.text=[infoArr[i] objectForKey:keyvalue];
        info.numberOfLines=0;
        if (([self mimiLabelHeightWithText:[infoArr[i] objectForKey:keyvalue]]) >(ScreenWidth-CGRectGetMaxX(title.frame)-10-10)) {
            info.textAlignment=NSTextAlignmentLeft;
        }else{
            info.textAlignment=NSTextAlignmentRight;
        }
        
        [contentView addSubview:info];
        
        if (i!=0) {
            UIView *spareLine=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+5, allHeight, ScreenWidth-CGRectGetMaxX(titleLabel.frame)-5, 0.5)];
            spareLine.backgroundColor=kUIColorFromRGB(0xebe8ed);
            [contentView addSubview:spareLine];
        }
        allHeight+=35;
        
    }
    
}

// 文字宽度
- (CGFloat)mimiLabelHeightWithText:(NSString *)string
{
    //size:表示允许文字所在的最大范围
    //options: 一个参数,计算高度时候用 NSStringDrawingUserLineFragmentOrigin
    //attributes:表示文字的某个属性(通常是文字大小)
    //context:上下文对象,通常写nil;
    CGRect rect = [string boundingRectWithSize:CGSizeMake(2000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:gotiphon6(13.0f)]} context:nil];
    
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
