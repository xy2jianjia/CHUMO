//
//  YS_PayInfoModel.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/5/3.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YS_PayInfoModel : NSObject
//Vip 编码 b133
@property (nonatomic,strong)NSString *b133;
//明细编码  b13
@property (nonatomic,strong)NSNumber *b13;
//时长  b137
@property (nonatomic,strong)NSNumber *b137;
//价格  b126
@property (nonatomic,strong)NSNumber *b126;
//明细名称 b51
@property (nonatomic,strong)NSString *b51;
// 折扣 b128
@property (nonatomic,strong)NSNumber *b128;
// id b34
@property (nonatomic,strong)NSString *b34;
// 送 几个月 b138
@property (nonatomic,strong)NSNumber *b138;
// 送 几个月 b48
@property (nonatomic,strong)NSString *b48;
// 送 几个月 b48
@property (nonatomic,strong)NSString *b193;
@end
