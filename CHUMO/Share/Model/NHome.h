//
//  NHome.h
//  StrangerChat
//
//  Created by zxs on 15/12/2.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NHome : NSObject

@property (nonatomic,strong)NSNumber *age;            // b1   根据生日计算
@property (nonatomic,strong)NSNumber *d1Status;       // b118 独白审核 1通过 2等待审核 3未通过
@property (nonatomic,strong)NSNumber *photoStatus;    // b142 头像状态 1通过 2等待审核 3未通过
@property (nonatomic,strong)NSNumber *vip;            // b144  vip 1vip 2不是vip
@property (nonatomic,strong)NSNumber *userType;       // b143  用户类型   1 用户注册  2 机器人
@property (nonatomic,strong)NSString *describe;       // b17  内心独白  交友宣言
@property (nonatomic,strong)NSString *systemName;     // b152 用户系统编号
@property (nonatomic,strong)NSNumber *id;             // b34
@property (nonatomic,strong)NSString *birthday;       // b4   生日
@property (nonatomic,strong)NSString *loginTime;      // b44  登陆时间
@property (nonatomic,strong)NSString *nickName;       // b52  昵称
@property (nonatomic,strong)NSString *photoUrl;       // b57  头像链接
@property (nonatomic,strong)NSNumber *sex;            // b69  性别 1 男 2女
@property (nonatomic,strong)NSNumber *status;         // b75  昵称审核 1通过 2等待审核 3未通过
@property (nonatomic,strong)NSNumber *userId;         // b80  用户id 不能为空
@property (nonatomic,strong)NSString *purpose;         // b145  意向


@property (nonatomic,strong)NSString *kidney;         // b37  个性特征
@property (nonatomic,strong)NSString *weight;         // b88  体重
@property (nonatomic,strong)NSString *favorite;       // b24  性趣爱好
@property (nonatomic,strong)NSString *together;       // b39  和父母同住
@property (nonatomic,strong)NSString *loveType;       // b45  喜欢异性的类型
@property (nonatomic,strong)NSString *marrySex;       // b47    婚姻性行为
@property (nonatomic,strong)NSString *marriage;       // b46  婚姻状况
@property (nonatomic,strong)NSString *education;      // b19  学历
@property (nonatomic,strong)NSString *city;           // b9   居住地(市)
@property (nonatomic,strong)NSString *province;       // b67  居住地(省)
@property (nonatomic,strong)NSString *star;           // b74  星座 1-12
@property (nonatomic,strong)NSString *hasChild;       // b30  是否想要小孩
@property (nonatomic,strong)NSString *LoveOther;      // b31  是否接受异地恋
@property (nonatomic,strong)NSString *hasRoom;        // b32  是否有房
@property (nonatomic,strong)NSString *hasCar;         // b29  是否有车
@property (nonatomic,strong)NSNumber *wageMax;        // b86  月收入最大值
@property (nonatomic,strong)NSNumber *wageMin;        // b87  月收入最小值
@property (nonatomic,strong)NSString *profession;     // b62  职业
@property (nonatomic,strong)NSString *blood;          // b5   血型  10 2A  3B 4AB 5其他
@property (nonatomic,strong)NSString *height;         // b33  身高
@property (nonatomic,strong)NSString *charmPart;      // b8   魅力部位

@property (nonatomic,strong)NSString *qq;             // b156   QQ号码
@property (nonatomic,strong)NSString *qqStatus;       // b158   QQ显示状态
@property (nonatomic,strong)NSString *wx;             // b157   微信
@property (nonatomic,strong)NSString *wxStatus;       // b159   微信显示状态

@end
