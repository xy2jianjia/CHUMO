//
//  NSGetTools.h
//  StrangerChat
//
//  Created by long on 15/10/12.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSGetTools : NSObject

// UUID
+ (NSString *)getUUID;

// 手机号验证   ^1[3|4|5|7|8][0-9]{9}$
+(BOOL)checkPhoneNum:(NSString *)textString;

// 验证密码
+ (BOOL)checkPassWord:(NSString *)textString;

// 加密
+ (NSString *)EncryptionWith:(NSString *)jsonString;

//解密
+ (NSString *)DecryptWith:(NSString *)encString;


// 字典格式字符串转字典
+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;

// 获取手机型号
+ (NSString *)getCurrentDevice;

//用来辨别设备所使用网络的运营商
+ (NSString*)checkCarrier;

// 网络类型
+(NSString *)getNetWorkStates;

+ (NSString *)getIMEI;
// 获取app名字
+ (NSString *)getAPPName;

// 获取app版本
+ (NSString *)getAppVersion;

// 获取appBuild
+ (NSString *)getAppBuild;

//获取Bundle identifier
+ (NSString *)getBundleID;

// 网络判断
+ (BOOL) isConnectionAvailable;

// 获取app的公共参数
+ (NSString *)getAppInfoString;
// 获取app的公共参S数字典
+ (NSDictionary *)getAppInfoDict;



//弹出框
+ (void)showAlert:(NSString *)message;
// 晃动提示
+ (void)shotTipAnimationWith:(UIView *)view;

#pragma mark  ---是否登陆---
+ (void)updateIsLoadWithStr:(NSString *)load;
#pragma mark ---获取登录---
+ (NSString *)getIsLoad;


#pragma mark  ---聊天注册---
+ (void)updateChatRegistWithStr:(NSString *)registr;
#pragma mark ---获取注册信息---
+ (NSString *)getIsRegister;

#pragma mark  ---聊天token---
+ (void)updateTokenWithStr:(NSString *)token;
#pragma mark ---获取token---
+ (NSString *)getToken;

#pragma mark  ---聊天房间---
+ (void)updateRoomCodeWithStr:(NSString *)roomCode;
#pragma mark ---获取房间号---
+ (NSString *)getRoomCode;



#pragma mark ---用户ID---
+ (void)upDateUserID:(NSNumber *)userID;
// 获取用户ID
+ (NSNumber *)getUserID;

#pragma mark ---sessionIdID------
+ (void)upDateUserSessionId:(NSString *)sessionId;
// 获取用户sessionId
+ (NSString *)getUserSessionId;

#pragma mark ---VIP------
+ (void)upDateUserVipInfo:(NSNumber *)vipNum;
// 获取用户VIP
+ (NSNumber *)getUserVipInfo;

// 信息资料修改包b34
+ (void)upDateB34:(NSNumber *)num;
+ (NSNumber *)getB34;

// 头像b34
+ (void)upDateIconB34:(NSNumber *)num;
+ (NSNumber *)getIconB34;


// 头像b75
+ (void)upDateIconB75:(NSNumber *)num;
+ (NSNumber *)getIconB75;


// 头像b57连接
+ (void)upDateIconB57:(NSString *)iconUrl;
+ (NSString *)getIconB57;


#pragma mark ---账号----
+ (void)updateUserAccount:(NSString *)accountNum;
+ (NSString *)getUserAccount;

#pragma mark ---密码----
+ (void)updateUserPassWord:(NSString *)passWord;
+ (NSString *)getUserPassWord;


#pragma mark ---性别----
+ (void)updateUserSexInfoWithB69:(NSNumber *)sexNum;
+ (NSNumber *)getUserSexInfo;

#pragma mark----- 用户个人信息------------------------------------

+ (void)updateUserInfoWithDict:(NSMutableDictionary *)dict;

+ (NSMutableDictionary *)getUserInfoDict;

#pragma mark  ---地理位置---
+ (void)updateCLLocationWithDict:(NSMutableDictionary *)dict;
+ (NSDictionary *)getCLLocationData;

#pragma mark  ---首页眼缘b96,是否有下一页---
+ (void)updateB96WithNum:(NSNumber *)b96;
+ (NSNumber *)getLuckB96;

#pragma mark  ---附近人b96,是否有下一页---
+ (void)updateNearPeopleB96WithNum:(NSNumber *)b96;
+ (NSNumber *)getNearPeopleB96;

#pragma mark  ---搜索b96,是否有下一页---
+ (void)updateSearchB96WithNum:(NSNumber *)b96;
+ (NSNumber *)getSearchB96;

// 搜索条件保存
+ (void)updateSearchSetWithDict:(NSDictionary *)dict;
+ (NSDictionary *)getSearchSetDict;

//获取头像
+ (UIImage *)getHeadIcon;

+ (NSString*) replaceUnicode:(NSString*)aUnicodeString;

// 文字高度
+ (CGFloat)calsLabelHeightWithText:(NSString *)text;


// 搜索条件用
+ (NSNumber *)getSystemNumWithDict:(NSDictionary *)dict value:(NSString *)value;
+ (void)updateUserNickName:(NSString *)nickName;
+ (NSString *)getUserNickName;
+ (void) logOutService;
//保存购买项目
+ (void)updateSystemGoodsInfo:(NSArray *)goodsInfo;
+ (NSArray *)getSystemGoodsInfo;
+ (NSDictionary *)getSystemGoodsByType:(NSInteger)type;
@end
