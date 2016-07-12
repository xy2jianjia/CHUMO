//
//  DHActivityAlertView.h
//  CHUMO
//
//  Created by xy2 on 16/6/21.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YS_PayModel.h"
@class DHActivityAlertView;
@protocol DHActivityAlertViewDelegate <NSObject>

- (void)activityOnclickedWithModel:(YS_PayModel *)model;
- (void)activityOnclickedActivityDetail;
@end
@interface DHActivityAlertView : UIView<UIAlertViewDelegate>
@property (weak , nonatomic)id <DHActivityAlertViewDelegate>delegate;
@property (nonatomic,strong) NSArray *dataArr;
/**
 *  配置活动弹窗消息
 *
 *  @param inView
 *  @param delegate 
 *
 *  @return 
 */
+ (DHActivityAlertView *)configActivityAlertViewInView:(UIView *)inView delegate:(id <DHActivityAlertViewDelegate>)delegate dataSource:(NSArray *)dataSource;

@end
