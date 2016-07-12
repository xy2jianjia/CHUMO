//
//  YS_OrderPayingView.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/5/6.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YS_HistoryOrderModel.h"
@protocol YS_OrderPayingViewDelegate <NSObject>

- (void) noticeToPay;//点击按钮
- (void) noticeInvalid;//订单无效
@end
@interface YS_OrderPayingView : UIView
@property (nonatomic,assign)id<YS_OrderPayingViewDelegate> delegate;
+(instancetype)orderOverInfoWithFrame:(CGRect)frame AndInfoModel:(YS_HistoryOrderModel *)model;
-(instancetype)initWithFrame:(CGRect)frame withInfoModel:(YS_HistoryOrderModel *)model;
@end
