//
//  DhFriendModel.h
//  CHUMO
//
//  Created by xy2 on 16/7/14.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DhFriendModel : NSObject
/**
 *  记录ID
 */
@property (nonatomic,strong) NSString *b34;
/**
 *  用户类型 1:注册用户,2机器人,5.动态机器人
 */
@property (nonatomic,strong) NSString *b143;
/**
 *  是否vip 1:vip 2:非vip
 */
@property (nonatomic,strong) NSString *b144;
/**
 *  学历 1:初中及以下 2:高中 3:专科 4:本科 5:研究生 6:博士及以上
 */
@property (nonatomic,strong) NSString *b19;
/**
 *  好友ID
 */
@property (nonatomic,strong) NSString *b25;
/**
 *  是否有车
 */
@property (nonatomic,strong) NSString *b29;
/**
 *  是否有房
 */
@property (nonatomic,strong) NSString *b32;
/**
 *  身高
 */
@property (nonatomic,strong) NSString *b33;
/**
 *  friendName别名
 */
@property (nonatomic,strong) NSString *b26;
/**
 *  婚姻状态
 */
@property (nonatomic,strong) NSString *b46;
/**
 *  昵称
 */
@property (nonatomic,strong) NSString *b52;
/**
 *  头像连接
 */
@property (nonatomic,strong) NSString *b57;
/**
 *  职业
 */
@property (nonatomic,strong) NSString *b62;
/**
 *  省份
 */
@property (nonatomic,strong) NSString *b67;
/**
 *  性别
 */
@property (nonatomic,strong) NSString *b69;
/**
 *  年龄
 */
@property (nonatomic,strong) NSString *b1;
/**
 *  用户ID
 */
@property (nonatomic,strong) NSString *b80;
/**
 *  最高收入
 */
@property (nonatomic,strong) NSString *b86;
/**
 *  最低收入
 */
@property (nonatomic,strong) NSString *b87;
/**
 *  城市
 */
@property (nonatomic,strong) NSString *b9;
/**
 *  好友类型:1:普通 2：免费好友
 */
@property (nonatomic,strong) NSString *b78;


@end
