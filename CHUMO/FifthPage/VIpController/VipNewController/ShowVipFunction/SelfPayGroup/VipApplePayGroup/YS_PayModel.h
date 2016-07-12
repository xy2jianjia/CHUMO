//
//  YS_PayModel.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/4/19.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YS_PayModel : NSObject
/**
 *  id
 */
@property (nonatomic,strong)NSString *b34;
/**
 *  Vip 编码
 */
@property (nonatomic,strong)NSString *b133;
/**
 *  商品名称
 */
@property (nonatomic,strong)NSString *b51; //名称
/**
 *  商品编码
 */
@property (nonatomic,strong)NSString *b13; //明细编码
/**
 *  时长
 */
@property (nonatomic,strong)NSString *b137;
/**
 *  价格
 */
@property (nonatomic,strong)NSString *b126;
/**
 *  折扣
 */
@property (nonatomic,strong)NSString *b128;
/**
 *  优惠
 */
@property (nonatomic,strong)NSString *b138;
/**
 *  备注
 */
@property (nonatomic,strong)NSString *b48;
/**
 *  特权列表
 */
@property (nonatomic,strong)NSArray *privilegeList;
@end
