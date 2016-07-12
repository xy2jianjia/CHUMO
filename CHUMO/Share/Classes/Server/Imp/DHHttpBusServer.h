//
//  DHHttpBusServer.h
//  DHRequestServer
//
//  Created by xy2 on 16/1/20.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHHttpBaseServer.h"

@interface DHHttpBusServer : DHHttpBaseServer
/**
 *  手机注册（）
 *
 *  @param api        f_119_10_1
 *  @param parameters a81：电话号码，a56：密码，a115：确认密码，a93：短信验证码，a151：手机序列号
 *  @param method     get
 *  @param serverType lp-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncRegisterByPhoneNumberWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  账号注册
 *
 *  @param api         f_119_11_1
 *  @param parameters a151：手机序列号
 *  @param method     get
 *  @param serverType lp-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncRegisterByNumberWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  触动首页
 *
 *  @param api        f_111_15_1
 *  @param parameters a95：1，a69：1-男，2-女，a67：省份代码，a9：市代码，a40：经度，a38：纬度
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncGetYANYUANListWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  用户信息
 *
 *  @param api         f_108_13_1
 *  @param parameters p1:sessionId，p2:userId
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncGetUserDetailInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  用户信息查询
 *
 *  @param api        f_108_10_1
 *  @param parameters p1:sessionId，p2:userId
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncFindUserDetailInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  保存用户信息
 *
 *  @param api        f_108_11_2
 *  @param parameters 参数过多：对照开发文档
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncSaveUserDetailInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  点赞保存
 *
 *  @param api        f_113_10_5
 *  @param parameters a109：点赞用户ID，a108：photoId，a52：nickName
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncSaveLikeDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  点赞删除
 *
 *  @param api         f_113_11_5
 *  @param parameters a109：点赞用户ID，a108：photoId
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncDeleteLikeDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;

/**
 *  征友条件查询
 *
 *  @param api         f_110_10_1
 *  @param parameters p1,p2
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncFindFriendFilterDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  征友条件保存
 *
 *  @param api         f_110_11_2
 *  @param parameters a34：数据库记录id,a9：市代码，a67：省代码，a1：年龄范围（20-25），a85：收入范围（Eg:10000-15000）a19：最低学历 >=1，a33：身高，a46：婚姻状态
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncSaveFriendFilterDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  好友关系查询
 *
 *  @param api         f_106_11_1
 *  @param parameters
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncFriendRelationShipDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  好友关系保存
 *
 *  @param api         f_106_10_2
 *  @param parameters a25：好友ID，a26：好友别称
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncSaveFriendRelationShipDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  好友关系修改
 *
 *  @param api         f_106_13_4
 *  @param parameters a25：好友ID，a26：好友别称
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncUpdateFriendRelationShipDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  好友关系删除
 *
 *  @param api         f_106_12_3
 *  @param parameters a25：好友Id
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncDeleteFriendRelationShipDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  好友关注查询
 *
 *  @param api         f_105_11_1
 *  @param parameters a78：1-关注2-被关注，a95：分页参数
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncFindFriendFocusWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  好友关注保存
 *
 *  @param api         f_105_10_2
 *  @param parameters a77：被关注用户Id
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncSaveFriendFocusWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  好友关注删除
 *
 *  @param api         f_105_12_3
 *  @param parameters a77：被关注用户Id
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncDeleteFriendFocusWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  谁看过我查询
 *
 *  @param api  f_109_10_1
 *  @param parameters a95：分页参数
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncFindFocusOnMeWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  谁看过我保存
 *
 *  @param api  f_109_11_2
 *  @param parameters a77：被查看用户ID
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncSaveFocusOnMeWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  搜索界面以及搜索条件界面
 *
 *  @param api  f_108_12_1
 *  @param parameters a69：性别（搜索页给性别即可，搜索条件再添加其他参数）
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncFindSearchListWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  搜索条件保存
 *
 *  @param api  love/ f_114_10_2
 *  @param parameters a34：记录id，其他参数对照文档
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncSaveSearchConditionWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  搜索条件查询
 *
 *  @param api  f_114_11_1
 *  @param parameters
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncFindSearchConditionWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  用户位置保存
 *
 *  @param api  f_112_11_2
 *  @param parameters a40：经度，a38：纬度
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncSaveUserLocationWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  用户位置删除
 *
 *  @param api  f_112_12_3
 *  @param parameters a34：记录id
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncDeleteUserLocationWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  系统参数查询（各类所需信息）
 *
 *  @param api  f_101_10_1
 *  @param parameters a78：1-系统设置参数 2-常量配置，a20：当type=2时，此参数启用；当enumCode为空时，提取所有枚举数据
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncGetSystemConfigInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  用户反馈信息保存
 *
 *  @param api  f_103_10_2
 *  @param parameters a14：内容，a61：客户端类型 1-安卓,2-iOS，a2：应用版本号，a49：机型，a68：机型版本号，a81：userName
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncUploadFeedbackWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  用户简要信息查询
 *
 *  @param api  f_108_14_1
 *  @param parameters a117：userId数组：（1001,1002,1003）
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncGetUserSimpleInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  提取用户vip特权
 *
 *  @param api  f_115_11_1
 *  @param parameters p1,p2
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncGetUserVIPPrivilegeWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  用户订单信息保存
 *
 *  @param api  f_115_10_2
 *  @param parameters 参数较多，对照开发文档
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncSaveOrderInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  提取系统vip信息
 *
 *  @param api  f_115_12_1
 *  @param parameters p1,p2，a78：1-套餐2-单卖，a13：编码
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncGetSystemVIPInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  提取用户vip信息
 *
 *  @param api   f_115_13_1
 *  @param parameters p1,p2
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncGetUserVIPInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  提取协议内容
 *
 *  @param api   f_116_10_1
 *  @param parameters a78：1001-付款协议
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncGetOrderProtocolInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  随机消息列表
 *
 *  @param api   f_117_10_1
 *  @param parameters
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncRandomMessageListWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  机器人用户列表
 *
 *  @param api   f_108_15_1
 *  @param parameters
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncRobotListWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  附近的人
 *
 *  @param api   f_108_16_1
 *  @param parameters a95：1，a9：市代码，a67：省代码，a69：性别，a40：经度，a38：纬度
 *  @param method     get
 *  @param serverType LP-bus-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncNearbyListWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;

@end
