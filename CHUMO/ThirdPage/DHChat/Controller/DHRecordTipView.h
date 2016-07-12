//
//  DHRecordTipView.h
//  CHUMO
//
//  Created by xy2 on 16/5/17.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHRecordTipView : UIView


@property (nonatomic,strong) UIImageView *leftImageV;
@property (nonatomic,strong) UIImageView *volumeImageV;
@property (nonatomic,strong) UIImageView *warningImageV;
/**
 *  提示文字
 */
@property (nonatomic,strong) UILabel *tipLabel;
+ (void)configTipInView:(UIView *)inView volume:(CGFloat )volume;
+ (void)configWarningTipInView:(UIView *)inView;

+ (void)disMiss;
@end
