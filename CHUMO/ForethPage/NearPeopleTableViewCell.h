//
//  NearPeopleTableViewCell.h
//  StrangerChat
//
//  Created by long on 15/11/11.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearPeopleTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *iconImageView;// 头像
@property (nonatomic,strong) UIImageView *kingImageView;// 会员图标 👑
@property (nonatomic,strong) UILabel *nameLabel;// 名字
@property (nonatomic,strong) UILabel *ageLabel;// 年龄
@property (nonatomic,strong) UILabel *heightLabel;// shengao
@property (nonatomic,strong) UILabel *label2;// 爱好
@property (nonatomic,strong) UILabel *label3;

@property (nonatomic,strong) UIImageView *placeImageView;// 距离
@property (nonatomic,strong) UILabel *placeLabel;
@property (nonatomic,strong) UIButton *hiButton;//招呼

@property (nonatomic,strong) DHUserInfoModel *model;
@end
