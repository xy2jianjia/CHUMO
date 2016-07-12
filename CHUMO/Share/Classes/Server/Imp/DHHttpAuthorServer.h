//
//  DHHttpAuthorServer.h
//  DHRequestServer
//
//  Created by xy2 on 16/1/20.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHHttpBaseServer.h"

@interface DHHttpAuthorServer : DHHttpBaseServer
/**
 *  短信验证码
 *
 *  @param api        f_118_10_1
 *  @param parameters a81:userName，a92:msgType-->1：注册短信 2：修改密码短信 3：绑定手机号
 *  @param method     get
 *  @param serverType lp-author-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)smsVerifyCodeWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  登陆
 *
 *  @param api        f_120_10_1
 *  @param parameters a81:userName,a56:password,p1:sessionId,p2:userId
 *  @param success    请求成功
 *  @param falureMsg  请求服务器返回的失败信息
 *  @param falure     连接服务器异常
 */
+ (void)loginWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  用户SESSION保持
 *
 *  @param api        f_120_12_1
 *  @param parameters p1:sessionID,p2:userId
 *  @param method     get
 *  @param serverType Lp-author-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)sessionOnlineWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;

@end
