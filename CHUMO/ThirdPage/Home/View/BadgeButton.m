//
//  BadgeButton.m
//  微信
//
//  Created by Think_lion on 15-6-14.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "BadgeButton.h"

@implementation BadgeButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        self.hidden=YES;
        self.titleLabel.font=MyFont(11);
        [self setBackgroundImage:[UIImage resizedImage:@"tabbar_badge"] forState:UIControlStateNormal];
        //[self setBackgroundImage:[UIImage resizedImage:@"tabbar_badge" left:0.5 top:0.5] forState:UIControlStateNormal];
        self.userInteractionEnabled=NO; //提醒数字按钮不能狡猾
        
    }
    return self;
}


-(void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue=[badgeValue copy];  //copy值
    
    if(badgeValue && ![badgeValue isEqualToString:@"0"]){
        self.hidden=NO;
        //设置文字
        [self setTitle:badgeValue forState:UIControlStateNormal];
        //如果大于1个数字
        if(badgeValue.length>1){
            
            CGSize btnSize=[badgeValue sizeWithAttributes:@{NSFontAttributeName:MyFont(11)}];
            self.width=btnSize.width+20; //宽度+10
            self.height=self.currentBackgroundImage.size.height;
        }else{
            self.width=self.currentBackgroundImage.size.width;
            self.height=self.currentBackgroundImage.size.height;
        }
        
    }else{
        self.hidden=YES;
    }
    
//    if(badgeValue && ![badgeValue isEqualToString:@"0"]){
//        self.hidden=NO;
//        //设置文字
//        [self setTitle:badgeValue forState:UIControlStateNormal];
//        //获得这个按钮的frmae
//        CGRect frame=self.frame;
//        //设置frame    宽和高是图片的大小
//        CGFloat badgeH=self.currentBackgroundImage.size.height;
//        CGFloat badgeW=self.currentBackgroundImage.size.width;
//        
//        if(badgeValue.length>1){
//            //文字的尺寸
//            //CGSize badgeSize=[item.badgeValue sizeWithFont:self.badgeButton.titleLabel.font];
//            CGSize badgeSize=[badgeValue sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
//            badgeW=badgeSize.width+10;
//        }
//        
//        frame.size.width=badgeW;
//        frame.size.height=badgeH;
//        self.frame=frame;
//    }else{
//        self.hidden=YES;
//    }

}

@end
