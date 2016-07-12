//
//  MeTouchModel.h
//  StrangerChat
//
//  Created by zxs on 16/1/4.
//  Copyright © 2016年 long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeTouchModel : NSObject
@property (nonatomic,strong)NSString *ageStr;    // b1  年龄 (int)
@property (nonatomic,strong)NSString *city;      // b9  城市 (int)
@property (nonatomic,strong)NSString *education; // b19 学历 (int)
@property (nonatomic,strong)NSString *photoUrl;  // b57 头像连接
@property (nonatomic,strong)NSString *heightStr;    // b33 身高 (float)
@property (nonatomic,strong)NSString *loginTime; // b44 登陆时间
@property (nonatomic,strong)NSString *nickName;  // b52 昵称
@property (nonatomic,strong)NSString *province;  // b67 省份    (int)
@property (nonatomic,strong)NSString *wageMax;   // b86 最高收入 (int)
@property (nonatomic,strong)NSString *wageMin;   // b87 最低收入 (int)
@property (nonatomic,strong)NSString *userId;    // b80 用户ID  (long)
@property (nonatomic,strong)NSString *marriage;  // b46 婚姻状态 (int)
@property (nonatomic,strong)NSString *profession;// b62 职业    (int)
@property (nonatomic,strong)NSString *hasRoom;   // b32 是否有房 (int)
@property (nonatomic,strong)NSString *hasCar;    // b29 是否有车 (int)
@property (nonatomic,assign)NSInteger vip;       // b144 1：VIP 2：非VIP  (int)
@property (nonatomic,strong)NSString *userType;  // b143 1：注册用户2：机器人
@property (nonatomic,strong)NSString *lockedStatus;  // b41 用户禁用状态1 启用  2 禁用
@end
