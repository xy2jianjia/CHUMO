//
//  SearchTableViewCell.h
//  StrangerChat
//
//  Created by long on 15/11/11.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell 

@property (nonatomic,strong) UIImageView *iconImageView; // 头像
@property (nonatomic,strong) UIImageView *kingImageView;// 会员图标 �
@property (nonatomic,strong) UILabel *nameLabel;// 名字
@property (nonatomic,strong) UILabel *placeLabel;// 距离
@property (nonatomic,strong) UILabel *detailView;// 年龄,省市,身高,学历等
@property (nonatomic,strong) DHUserInfoModel *searchModel;
@property (nonatomic,strong) UIImageView *placeImage;
@end
