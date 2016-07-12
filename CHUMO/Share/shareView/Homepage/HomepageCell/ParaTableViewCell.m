//
//  ParaTableViewCell.m
//  ParallaxScroll_Demo
//
//  Created by Tom on 15/11/25.
//  Copyright © 2015年 Tom. All rights reserved.
//

#import "ParaTableViewCell.h"

@interface ParaTableViewCell()
{
    UIImageView *backImv;
    UIView *infoView;
    UIImageView *avaterImv;
    UIView *avaterImvbor;
    
    UILabel *titleLabel;
    UIImageView *smallImage;
    UILabel * ageLabel;
//    UIImageView *addressImage;
    UILabel * addressLabel;
    UIImageView *clockImage;
    UIImageView *contactImage;
    
    UILabel *nickNameStatusLabel;
}
@end

@implementation ParaTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self n_layoutView];
    }
    return self;
}


- (void)n_layoutView {

    backImv = [[UIImageView alloc]init];
    backImv.clipsToBounds = YES;
    backImv.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:backImv];
    
    infoView = [[UIView alloc]init];
    [self.contentView addSubview:infoView];
    
    avaterImvbor = [[UIView alloc]init];
    avaterImvbor.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.300];
    [infoView addSubview:avaterImvbor];
    
    avaterImv = [[UIImageView alloc]init];
    avaterImv.backgroundColor = [UIColor whiteColor];
    avaterImv.contentMode = UIViewContentModeScaleAspectFill;  // 内容缩放以填充固定的方面
    avaterImv.clipsToBounds = YES;
    [avaterImvbor addSubview:avaterImv];
    
    nickNameStatusLabel = [[UILabel alloc]init];
    nickNameStatusLabel.textAlignment = NSTextAlignmentCenter;
    nickNameStatusLabel.font = [UIFont fontWithName:Typefaces size:13.0f];
    nickNameStatusLabel.textColor=kUIColorFromRGB(0xffffff);
    [infoView addSubview:nickNameStatusLabel];
    
//    _heartImage = [[UIImageView alloc] init];
//    _heartImage.clipsToBounds = YES;
//    _heartImage.contentMode = UIViewContentModeScaleAspectFill;
//    [infoView addSubview:_heartImage];
//    
//    _wxImage = [[UIImageView alloc] init];
//    _wxImage.clipsToBounds = YES;
//    _wxImage.contentMode = UIViewContentModeScaleAspectFill;
//    [infoView addSubview:_wxImage];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:Typefaces size:15.0f];
    titleLabel.textColor=kUIColorFromRGB(0xffffff);
    [infoView addSubview:titleLabel];
    
    smallImage = [[UIImageView alloc] init];
    smallImage.clipsToBounds = YES;
    smallImage.contentMode = UIViewContentModeScaleAspectFill;
    [infoView addSubview:smallImage];
    
    ageLabel = [[UILabel alloc] init];
    ageLabel.font = [UIFont fontWithName:Typefaces size:12.0f];
    [infoView addSubview:ageLabel];
    
    addressLabel = [[UILabel alloc] init];
    addressLabel.font = [UIFont fontWithName:Typefaces size:12.0f];
    addressLabel.textAlignment=NSTextAlignmentCenter;
    [infoView addSubview:addressLabel];
    
    _addressImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    _addressImage.clipsToBounds = YES;
    _addressImage.contentMode = UIViewContentModeScaleAspectFit;
    [infoView addSubview:_addressImage];
    
    clockImage = [[UIImageView alloc] init];
    clockImage.clipsToBounds = YES;
    clockImage.contentMode = UIViewContentModeScaleAspectFit;
    [infoView addSubview:clockImage];
    
    _clockLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _clockLabel.textAlignment = NSTextAlignmentLeft;
    _clockLabel.userInteractionEnabled=YES;
    _clockLabel.tag=1000;
    _clockLabel.font = [UIFont fontWithName:Typefaces size:12];
    [infoView addSubview:_clockLabel];
    
    contactImage = [[UIImageView alloc] init];
    contactImage.clipsToBounds = YES;
    contactImage.contentMode = UIViewContentModeScaleAspectFit;
    [infoView addSubview:contactImage];
    
    _contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _contactLabel.textAlignment = NSTextAlignmentLeft;
    _contactLabel.userInteractionEnabled=YES;
    _contactLabel.tag=1001;
    _contactLabel.font = [UIFont fontWithName:Typefaces size:12];
    [infoView addSubview:_contactLabel];
    
    
    
}

// heartImage wxImage titleLabel smallImage ageLabel addressImage addressLabel clockImage clockLabel
- (void)layoutSubviews {
    [super layoutSubviews];
    backImv.frame      = CGRectMake(0, 0, self.contentView.frame.size.width, [ParaTableViewCell cellHeight]);
    infoView.frame     = CGRectMake(0, 64+75/2+30, self.contentView.frame.size.width, 180);
    avaterImvbor.frame = CGRectMake(0, 0, 75, 75);
    avaterImvbor.layer.cornerRadius=75/2;
    avaterImvbor.layer.masksToBounds=YES;
    avaterImvbor.center   = CGPointMake(CGRectGetMidX(infoView.bounds), CGRectGetMinY(infoView.bounds));
    avaterImv.frame    = CGRectMake(2, 2, 71, 71);
    avaterImv.layer.cornerRadius = CGRectGetWidth(avaterImv.frame)/2;
    avaterImv.layer.masksToBounds=YES;
    
//    _heartImage.frame   = CGRectMake(CGRectGetMinX(avaterImv.frame)-35-30, 15, 30, 30);
//    _wxImage.frame      = CGRectMake(CGRectGetMaxX(avaterImv.frame)+30, 15, 30, 30);
    titleLabel.frame   = CGRectMake(self.bounds.size.width/2 -100, CGRectGetMaxY(avaterImvbor.frame)+3, 200, 30);
    
    nickNameStatusLabel.frame = CGRectMake(CGRectGetMidX(self.contentView.frame)-100, CGRectGetMaxY(titleLabel.frame), 200, 18);
//    addressLabel.frame = CGRectMake(CGRectGetMidX(self.contentView.frame)-100, CGRectGetMaxY(titleLabel.frame), 200, 18);
    
    _clockLabel.frame   = CGRectMake(27, CGRectGetMaxY(nickNameStatusLabel.frame)+5, 170, 18);
    clockImage.frame   = CGRectMake(CGRectGetMinX(_clockLabel.frame)-17, CGRectGetMinY(_clockLabel.frame)+3, 12, 12);
    _contactLabel.frame   = CGRectMake(CGRectGetMidX(self.contentView.frame)+45, CGRectGetMaxY(nickNameStatusLabel.frame)+5, 170, 18);
    contactImage.frame   = CGRectMake(CGRectGetMinX(_contactLabel.frame)-17, CGRectGetMinY(_contactLabel.frame)+3, 12, 12);
}

+(CGFloat)cellHeight
{
    return 253;
}

/*
 * groudImage 背景图
 * aimage     头像
 * heart      心形图
 * picture    微信图
 * nickname   昵称
 * image      年龄图
 * age        年龄
 * dreImage   地址图
 * address    地址
 * timeImage  时间图
 * time       时间
 **/

- (void)cellLoadDataWithBackground:(NSString *)groudImage heart:(NSString *)heart wxpic:(NSString *)picture ageImage:(NSString *)image age:(NSString *)age dressImage:(NSString *)dreImage address:(NSString *)address timeImage:(NSString *)timeImage time:(NSString *)time model:(NHome *)item{
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    //昵称审核
    //判断查看的用户  是否是VIP
    BOOL objectVip=[item.vip integerValue]==1?YES:NO;
    
    [self cellLoadWithnickname:item.nickName isVip:objectVip];
    //用户审核状态
    if ([userId isEqualToString:[NSString stringWithFormat:@"%@",item.userId]]) {
        if ([item.status intValue] == 1 ) {  // 昵称审核
            
        }else if ([item.status intValue] == 2) {
            nickNameStatusLabel.text=@"(审核中)";
            
        }else if ([item.status intValue] == 3){
            nickNameStatusLabel.text=@"(审核不通过)";
            
        }else{
            
        }
        
    }else{
         [self cellLoadWithnickname:item.nickName isVip:objectVip];
    }
    
    
    //头像审核
    if ([userId isEqualToString:[NSString stringWithFormat:@"%@",item.userId]]) {
        
        if ([item.photoStatus intValue] == 1) {  // 头像审核
            [self cellLoadWithurlStr:item.photoUrl];
        }else if ([item.photoStatus intValue] == 2) {
            [self cellLoadStatusWithurlStr:item.photoUrl andStatus:@"审核中..."];
            
        }else if ([item.photoStatus intValue] == 3){
            
            [self cellLoadStatusWithurlStr:item.photoUrl andStatus:@"审核不通过"];
        }else{
            [self cellLoadWithurlStr:item.photoUrl];
        }
    }else{
        [self cellLoadWithurlStr:item.photoUrl];
    }
    
    
//    ageLabel.text     = age;
    //用户微信QQ,登陆时间模块
    //查看用户是否是VIP
    
    
    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
    BOOL vip = [userInfo.b144 integerValue] == 1?YES:NO;
    
    if (vip) {
        
        _clockLabel.text   = [NSString stringWithFormat:@"登录时间  %@",[time length] == 0?@"未记录":time];
        if (item.qq.length>0) {
            contactImage.image = [UIImage imageNamed:@"icon-qq.png"];
            if ([item.qqStatus integerValue ]==2) {
                if(item.wx.length>0){
                    if ([item.wxStatus integerValue]!=2) {
                        contactImage.image = [UIImage imageNamed:@"icon-wx.png"];
                        _contactLabel.text = [NSString stringWithFormat:@"微信  %@",[item.wx length]==0?@"未记录":item.wx];
                    }else{
                        _contactLabel.text = [NSString stringWithFormat:@"QQ  保密",nil];
                    }
                }else{
                    _contactLabel.text = [NSString stringWithFormat:@"QQ  保密",nil];
                }
                
            }else{
                _contactLabel.text = [NSString stringWithFormat:@"QQ  %@",[item.qq length] == 0?@"未记录":item.qq];
            }
            
        }else if(item.wx.length>0){
            contactImage.image = [UIImage imageNamed:@"icon-wx.png"];
            if ([item.wxStatus integerValue]==2) {
                _contactLabel.text = [NSString stringWithFormat:@"微信  保密",nil];
            }else{
                _contactLabel.text = [NSString stringWithFormat:@"微信  %@",[item.wx length]==0?@"未记录":item.wx];
            }
            
        }else{
            contactImage.image = [UIImage imageNamed:@"icon-qq.png"];
            _contactLabel.text = [NSString stringWithFormat:@"QQ  保密",nil];
        }
        
    }else{
        contactImage.image = [UIImage imageNamed:@"icon-qq.png"];
        
        _clockLabel.text   = [NSString stringWithFormat:@"登录时间  点击查看"];
        _contactLabel.text = [NSString stringWithFormat:@"QQ  点击查看",nil];
    }
    if ([userId isEqualToString:[NSString stringWithFormat:@"%@",item.userId]]) {
        _clockLabel.text   = [NSString stringWithFormat:@"登录时间  %@",[time length] == 0?@"未记录":time];
        if (item.qq.length>0) {
            contactImage.image = [UIImage imageNamed:@"icon-qq.png"];
            if ([item.qqStatus integerValue ]==2) {
                if(item.wx.length>0){
                    if ([item.wxStatus integerValue]!=2) {
                        contactImage.image = [UIImage imageNamed:@"icon-wx.png"];
                        _contactLabel.text = [NSString stringWithFormat:@"微信  %@",[item.wx length]==0?@"未记录":item.wx];
                    }else{
                        _contactLabel.text = [NSString stringWithFormat:@"QQ  保密",nil];
                    }
                }else{
                    _contactLabel.text = [NSString stringWithFormat:@"QQ  保密",nil];
                }
                
            }else{
                _contactLabel.text = [NSString stringWithFormat:@"QQ  %@",[item.qq length] == 0?@"未记录":item.qq];
            }
            
        }else if(item.wx.length>0){
            contactImage.image = [UIImage imageNamed:@"icon-wx.png"];
            if ([item.wxStatus integerValue]==2) {
                _contactLabel.text = [NSString stringWithFormat:@"微信  保密",nil];
            }else{
                _contactLabel.text = [NSString stringWithFormat:@"微信  %@",[item.wx length]==0?@"未记录":item.wx];
            }
            
        }else{
            contactImage.image = [UIImage imageNamed:@"icon-qq.png"];
            _contactLabel.text = [NSString stringWithFormat:@"QQ  保密",nil];
        }
    }
    
    
    _clockLabel.textColor=kUIColorFromRGB(0xffffff);
    _contactLabel.textColor=kUIColorFromRGB(0xffffff);
//    if (nil==address|| NULL==address || [address isKindOfClass:[NSNull class]] ||[[address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
//        addressLabel.text = @"保密";
//    }else{
//        addressLabel.text = address;
//    }
    
//    _wxImage.image     = [UIImage imageNamed:picture];
//    _heartImage.image  = [UIImage imageNamed:heart];
//    smallImage.image  = [UIImage imageNamed:image];
    backImv.image     = [UIImage imageNamed:groudImage];
    
    clockImage.image  = [UIImage imageNamed:timeImage];
//    _addressImage.image = [UIImage imageNamed:dreImage];
    
}

- (void)cellLoadWithnickname:(NSString *)nickname isVip:(BOOL )isvip{
    if (isvip) {
        titleLabel.textColor = [UIColor whiteColor];
    }
    titleLabel.text   = nickname;
}

- (void)cellLoadWithurlStr:(NSString *)url {
    
    [avaterImv sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}
- (void)cellLoadStatusWithurlStr:(NSString *)urlStr andStatus:(NSString *)str{
    
    NSURL *url=[NSURL URLWithString:urlStr];
    
    
    [avaterImv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"list_item_icon.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CALayer *statusLayer=[[CALayer alloc]init];
            statusLayer.frame=CGRectMake(0, 0, CGRectGetWidth(avaterImv.frame), CGRectGetWidth(avaterImv.frame));
            statusLayer.backgroundColor=[UIColor colorWithWhite:0.000 alpha:0.300].CGColor;
            [avaterImv.layer addSublayer:statusLayer];
            
            CATextLayer *textLayer=[[CATextLayer alloc]init];
            textLayer.string=str;
            textLayer.fontSize=10;
            textLayer.alignmentMode=kCAAlignmentCenter;
            textLayer.foregroundColor=[UIColor whiteColor].CGColor;
            textLayer.contentsScale=[[UIScreen mainScreen] scale];
            textLayer.frame=CGRectMake(CGRectGetMidX(avaterImv.bounds)-50, CGRectGetMidY(avaterImv.bounds)-10, 100, 20);
            
            [statusLayer addSublayer:textLayer];
        });
        
    }];
}

- (void)updateHeightWithRect:(CGRect)rect
{
    backImv.frame = rect;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
