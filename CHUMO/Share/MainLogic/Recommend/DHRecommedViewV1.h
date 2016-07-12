//
//  DHRecommedViewV1.h
//  CHUMO
//
//  Created by xy2 on 16/6/23.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DHRecommedViewV1;

@protocol DHRecommedViewV1Delegate <NSObject>

- (void)recommendOnclickedAnswerBtnCalledBackWithBtnTag:(NSInteger )tag targetUserInfo:(DHUserInfoModel *)targetUserInfo;

@end


@interface DHRecommedViewV1 : UIView
@property (nonatomic,weak) id<DHRecommedViewV1Delegate >delegate;
@property (nonatomic,strong) DHUserInfoModel *userInfo;

/**
 *  配置同城推荐页面
 *
 *  @param inview   在哪个页面显示
 *  @param userInfo 要显示的用户
 *  @param delegate 代理
 *  @param isCity   是否是同城：yes：同城，NO：全国
 */
+ (void)configRecommendViewInView:(UIView *)inview userInfo:(DHUserInfoModel *)userInfo delelgate:(id<DHRecommedViewV1Delegate >)delegate isCity:(BOOL)isCity;

@end
