//
//  DHHttpAuthorServer.m
//  DHRequestServer
//
//  Created by xy2 on 16/1/20.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHHttpAuthorServer.h"

@implementation DHHttpAuthorServer
// 短信验证码
+ (void)smsVerifyCodeWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpAuthorServer alloc]init] smsVerifyCodeWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)smsVerifyCodeWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpAuthorServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 登陆
+ (void)loginWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpAuthorServer alloc]init] loginWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)loginWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpAuthorServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// session 保持
+ (void)sessionOnlineWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpAuthorServer alloc]init] sessionOnlineWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)sessionOnlineWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpAuthorServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
@end
