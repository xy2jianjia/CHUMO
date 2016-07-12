//
//  YS_HistoryOrderModel.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/5/5.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YS_HistoryOrderModel : NSObject
//b119 订单名称
@property (nonatomic,strong)NSString *b119;
//b122 订单状态
@property (nonatomic,strong)NSNumber *b122;
//b123 原始费用
@property (nonatomic,strong)NSNumber *b123;
//b128 折扣
@property (nonatomic,strong)NSString *b128;
//b129 实际费用
@property (nonatomic,strong)NSNumber *b129;
//b130 支付渠道
@property (nonatomic,strong)NSNumber *b130;
//b131 商品编号
@property (nonatomic,strong)NSNumber *b131;
//b132 订单编号
@property (nonatomic,strong)NSString *b132;
//b135 订单记录时间
@property (nonatomic,strong)NSString *b135;
//b136 订单失效时间
@property (nonatomic,strong)NSString *b136;
//b34 记录id
@property (nonatomic,strong)NSNumber *b34;
//b80 用户编号
@property (nonatomic,strong)NSNumber *b80;
//m7 系统类型
@property (nonatomic,strong)NSNumber *m7;
@end
