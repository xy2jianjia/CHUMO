//
//  DHAlertView.h
//  CHUMO
//
//  Created by xy2 on 16/2/22.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DHAlertView;
@protocol DHAlertViewDelegate <NSObject>

- (void)alertView:(DHAlertView *)alertView onClickBtnAtIndex:(NSInteger )index;

@end

@interface DHAlertView : UIView

@property (nonatomic,strong) UIView *bgAlphaView;

@property (nonatomic,strong) UIImageView *topImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *contentLabel;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,assign) id<DHAlertViewDelegate>delegate;
@property (nonatomic,strong) NSString *Btnnumber;

- (void)configAlertWithAlertTitle:(NSString *)alertTitle alertContent:(NSString *)alertContent;

@end
