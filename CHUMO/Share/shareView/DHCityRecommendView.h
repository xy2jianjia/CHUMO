//
//  DHCityRecommendView.h
//  CHUMO
//
//  Created by xy2 on 16/3/7.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHUserInfoModel.h"
@class DHCityRecommendDelegate;
@protocol DHCityRecommendDelegate <NSObject>

- (void)onClickedBtnWithTag:(NSInteger )tag targetUserinfo:(DHUserInfoModel *)targetUserinfo;

@end

@interface DHCityRecommendView : UIView

/**
 *  阴影遮盖
 */
@property (nonatomic,strong) UIView *bgAlphaView;
/**
 *  整个背景
 */
@property (nonatomic,strong) UIView *bgView;
/**
 *  头部图片
 */
@property (nonatomic,strong) UIImageView *topImageV;

/**
 *  头像背景
 */
@property (nonatomic,strong) UIView *midMainView;
/**
 *  头像边框
 */
@property (nonatomic,strong) UIImageView *midBorderImageV;
/**
 *  头像
 */
@property (nonatomic,strong) UIImageView *midHeaderImageV;
/**
 *  交友意向
 */
@property (nonatomic,strong) UIImageView *midPurposeImageV;

/**
 *  用户信息label背景
 */
@property (nonatomic,strong) UIView *labelBgView;
/**
 *  距离
 */
@property (nonatomic,strong) UILabel *spacingLabel;
/**
 *  年龄label
 */
@property (nonatomic,strong) UILabel *ageLabel;
/**
 *  名字label
 */
@property (nonatomic,strong) UILabel *nameLabel;

/**
 *  底部背景
 */
@property (nonatomic,strong) UIView *bottumBgView;
/**
 *  底部边框
 */
@property (nonatomic,strong) UIImageView *bottumBorderImageView;
/**
 *  底部心形
 */
@property (nonatomic,strong) UIImageView *bottumHeartImageView;
/**
 *  底部信息label
 */
@property (nonatomic,strong) UILabel *bottumInfoLabel;
/**
 *  波浪
 */
@property (nonatomic,strong) UIImageView *shakeImageV;
/**
 *  赶紧躲
 */
@property (nonatomic,strong) UIButton *cancelBtn;
/**
 *  还可以
 */
@property (nonatomic,strong) UIButton *alitleBitBtn;
/**
 *  很漂亮
 */
@property (nonatomic,strong) UIButton *yesBtn;

@property (nonatomic,weak) id<DHCityRecommendDelegate> delegate;
@property (nonatomic,strong) DHUserInfoModel *userInfo;
/**
 *  加载同城推荐
 *
 *  @param userInfo 用户信息
 *  @param inView   在哪个视图内展示
 */
+ (void)asyncConfigCityRecommendViewWithUserInfo:(DHUserInfoModel *)userInfo inView:(UIView *)inView delelgate:(id<DHCityRecommendDelegate >)delegate isCity:(BOOL)isCity;

@end

