//
//  HomeConstomView.m
//  微信
//
//  Created by Think_lion on 15/6/29.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "HomeConstomView.h"
#import "HomeModel.h"
#import "BadgeButton.h"

#define MarginLeft 10
#define headWidth 50
#define headHeight  headWidth

@interface HomeConstomView ()
//1.头像
@property (nonatomic,weak) UIImageView *head;
//2.title
@property (nonatomic,weak) UILabel *titleLabel;
//3.内容
@property (nonatomic,weak) UILabel *subTitleLabel;
//4.时间
@property (nonatomic,weak) UILabel *timeLabel;
//5.数字提醒按钮
@property (nonatomic,weak)BadgeButton *badgeButton;
//vip
@property (nonatomic,weak) UIImageView *vipImage;
//同城
@property (nonatomic,weak) UIImageView *cityImage;
@end

@implementation HomeConstomView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        [self setupView];
    }
    return self;
}

-(void)setupView
{
    //1.头像
    UIImageView *head=[[UIImageView alloc]init];
    head.frame=CGRectMake(MarginLeft, MarginLeft, headWidth, headHeight);
    head.layer.cornerRadius=5;
    head.layer.masksToBounds=YES;
    [self addSubview:head];
    self.head=head;
    //2.用户名
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.font=MyFont(17);
    titleLabel.textColor=[UIColor blackColor];
    [self addSubview:titleLabel];
    self.titleLabel=titleLabel;
    //3.内容
    UILabel *subTitleLabel=[[UILabel alloc]init];
    subTitleLabel.font=MyFont(14);
    subTitleLabel.textColor=[UIColor lightGrayColor];
    [self addSubview:subTitleLabel];
    self.subTitleLabel=subTitleLabel;
    //4.时间
    UILabel *timeLabel=[[UILabel alloc]init];
    timeLabel.font=MyFont(12);
    timeLabel.textColor=[UIColor lightGrayColor];
    [self addSubview:timeLabel];
//    timeLabel.backgroundColor = [UIColor blueColor];
//    timeLabel.layer.cornerRadius = 3;
    self.timeLabel=timeLabel;
    //5.提醒数字按钮
    BadgeButton *badgeBtn=[[BadgeButton alloc]init];
    [self addSubview:badgeBtn];
    self.badgeButton=badgeBtn;
    
    //vip标记
    UIImageView *vip=[[UIImageView alloc]init];
    vip.frame=CGRectMake(MarginLeft, MarginLeft, headWidth, headHeight);
    vip.layer.cornerRadius=5;
    [self addSubview:vip];
    self.vipImage=vip;
    
    //同城
    UIImageView *city=[[UIImageView alloc]init];
    city.frame=CGRectMake(MarginLeft, MarginLeft, headWidth, headHeight);
    city.layer.cornerRadius=5;
    [self addSubview:city];
    self.cityImage=city;
}

//传递模型
-(void)setHomeModel:(HomeModel *)homeModel
{
//    dispatch_async(dispatch_get_main_queue(), ^{
        _homeModel=homeModel;
        
        //1.设置头像
        if(homeModel.headerIcon){
            [self.head sd_setImageWithURL:[NSURL URLWithString:homeModel.headerIcon] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
//            [UIImage imageWithData:homeModel.headerIcon];
        }else{
            self.head.image=[UIImage imageNamed:@"list_item_icon.png"];
        }
        //2.设置用户名
        CGFloat nameY=MarginLeft;
        CGFloat nameX=CGRectGetMaxX(self.head.frame)+MarginLeft;
        CGSize nameSize=[homeModel.uname sizeWithAttributes:@{NSFontAttributeName:MyFont(17)}];
        self.titleLabel.frame=CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
        self.titleLabel.text=homeModel.uname;
        dispatch_async(dispatch_get_main_queue(), ^{
            //3.设置body聊天内容
            CGFloat bodyY=CGRectGetMaxY(self.titleLabel.frame)+9;
            CGFloat bodyX=nameX;
            CGFloat bodyH=20;
            CGFloat bodyW=ScreenWidth-bodyX-MarginLeft*2;
            self.subTitleLabel.frame=CGRectMake(bodyX, bodyY, bodyW, bodyH);
            NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[homeModel.body dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            NSString *string = [attrStr string];
            self.subTitleLabel.text=string;

        });
        //4.设置时间
        NSString *time = homeModel.time;
        CGSize timeSize= [self hightForContent:time fontSize:12];
        //    [homeModel.time sizeWithAttributes:@{NSFontAttributeName:MyFont(12)}];
        CGFloat timeY=MarginLeft;
        CGFloat timeX=ScreenWidth-timeSize.width-MarginLeft;
        self.timeLabel.frame=CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
        self.timeLabel.text=homeModel.time;
        
        //5.设置提醒数字按钮
        
        if([homeModel.badgeValue integerValue] > 0 && ![homeModel.badgeValue isEqualToString:@""]){
            self.badgeButton.badgeValue=homeModel.badgeValue;
            self.badgeButton.hidden=NO;
            CGFloat badgeX=CGRectGetMaxX(self.head.frame)-self.badgeButton.width*0.5;
            CGFloat badgeY=0;
            self.badgeButton.x=badgeX;
            self.badgeButton.y=badgeY;
            
        }else{
            self.badgeButton.hidden=YES;
        }
        
        //设置姓名长度范围
        if ((timeX-5-10-17-5-5)<(CGRectGetMaxX(self.titleLabel.frame))) {
            self.titleLabel.frame=CGRectMake(nameX, nameY, (timeX-5-10-17-5-5)-nameX, nameSize.height);
        }
        //vip
        if (homeModel.vipFlag) {
            self.vipImage.frame=CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+5, CGRectGetMidY(self.titleLabel.frame)-7, 17, 14);
            self.vipImage.image=[UIImage imageNamed:@"icon-name-vip"];
            self.titleLabel.textColor=[UIColor colorWithRed:235/255.0 green:45/255.0 blue:85/255.0 alpha:1];
            
            
        }else{
            self.vipImage.image=nil;
            self.titleLabel.textColor=[UIColor blackColor];
            
        }
        //同城
        if (homeModel.cityFlag) {
            if (homeModel.vipFlag) {
                self.cityImage.frame=CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+5+17+5, CGRectGetMidY(self.titleLabel.frame)-9, 18, 18);
            }else{
                self.cityImage.frame=CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+5, CGRectGetMidY(self.titleLabel.frame)-9, 18, 18);
            }
            
            self.cityImage.image=[UIImage imageNamed:@"location"];
        }else{
            self.cityImage.image=nil;
        }
//    });
    
}
- (CGSize)hightForContent:(NSString *)content fontSize:(CGFloat)fontSize{
    CGSize size = [content boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-125, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size;
}
@end
