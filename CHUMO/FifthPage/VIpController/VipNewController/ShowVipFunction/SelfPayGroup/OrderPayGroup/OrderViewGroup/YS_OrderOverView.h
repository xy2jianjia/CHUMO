//
//  YS_OrderOverView.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/5/6.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YS_HistoryOrderModel.h"
@interface YS_OrderOverView : UIView
+(instancetype)orderOverInfoWithFrame:(CGRect)frame AndInfoModel:(YS_HistoryOrderModel *)model;
-(instancetype)initWithFrame:(CGRect)frame withInfoModel:(YS_HistoryOrderModel *)model;
@end
