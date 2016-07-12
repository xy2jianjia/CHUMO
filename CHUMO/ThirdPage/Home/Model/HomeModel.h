//
//  HomeCellModel.h
//  微信
//
//  Created by Think_lion on 15/6/17.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject
//聊天用户的头像头像
@property (nonatomic,copy) NSString *headerIcon;
//标题
@property (nonatomic,copy) NSString *uname;
//子标题
@property (nonatomic,copy) NSString *body;
//时间
@property (nonatomic,copy) NSString  *time;
//jid
@property (nonatomic,strong) NSString *jid; //聊天用户的jid
//数字提醒按钮
@property (nonatomic,copy) NSString *badgeValue;
//vip
@property (nonatomic,assign)BOOL vipFlag;
//同城标记
@property (nonatomic,assign)BOOL cityFlag;
@end
