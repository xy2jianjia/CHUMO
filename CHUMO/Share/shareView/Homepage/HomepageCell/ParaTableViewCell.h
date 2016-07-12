//
//  ParaTableViewCell.h
//  ParallaxScroll_Demo
//
//  Created by Tom on 15/11/25.
//  Copyright © 2015年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NHome.h"
@interface ParaTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *heartImage;
@property (nonatomic,strong)UIImageView *wxImage;
@property (nonatomic,strong)UILabel *clockLabel;
@property (nonatomic,strong)UILabel *contactLabel;
@property (nonatomic,strong)UIImageView *addressImage;


+ (CGFloat)cellHeight;

- (void)cellLoadDataWithBackground:(NSString *)groudImage heart:(NSString *)heart wxpic:(NSString *)picture ageImage:(NSString *)image age:(NSString *)age dressImage:(NSString *)dreImage address:(NSString *)address timeImage:(NSString *)timeImage time:(NSString *)time model:(NHome *)item ;

- (void)updateHeightWithRect:(CGRect)rect;

// 昵称
- (void)cellLoadWithnickname:(NSString *)nickname isVip:(BOOL )isvip;

// 头像
- (void)cellLoadWithurlStr:(NSString *)url;
//审核中的头像
- (void)cellLoadStatusWithurlStr:(NSString *)urlStr andStatus:(NSString *)str;



@end
