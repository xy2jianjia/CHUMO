//
//  DHGroupButtonsView.h
//  CHUMO
//
//  Created by xy2 on 16/6/27.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@class DHGroupButtonsView;
@protocol DHGroupButtonsViewDelegate <NSObject>

- (void)onClickedButtonWithButton:(UIButton *)button tag:(NSInteger )tag;

@end

@interface DHGroupButtonsView : UIView
@property (weak,nonatomic) id <DHGroupButtonsViewDelegate> delegate;

+ (DHGroupButtonsView *)configActivityAlertViewInView:(UIView *)inView delegate:(id <DHGroupButtonsViewDelegate>)delegate;

@end
