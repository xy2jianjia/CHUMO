//
//  DHHttpFileServer.m
//  DHRequestServer
//
//  Created by xy2 on 16/1/20.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHHttpFileServer.h"

@implementation DHHttpFileServer
// 用户头像查询
+ (void)asyncGetPortraitWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpFileServer alloc]init] asyncGetPortraitWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncGetPortraitWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpFileServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 上传头像
+ (void)asyncUploadPortraitWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType imageData:(NSData *)imageData success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpFileServer alloc]init] asyncUploadPortraitWithApi:api parameters:parameters method:method server:serverType imageData:imageData success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncUploadPortraitWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType imageData:(NSData *)imageData success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpFileServer asyncUploadHttpImageWithApi:api parameters:parameters imagedata:imageData method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 用户相册查询
+ (void)asyncGetUserAlbumsWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpFileServer alloc]init] asyncGetUserAlbumsWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncGetUserAlbumsWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpFileServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 用户相册保存
+ (void)asyncUploadUserAlbumsWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType imageData:(NSData *)imageData success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpFileServer alloc]init] asyncUploadUserAlbumsWithApi:api parameters:parameters method:method server:serverType imageData:imageData success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncUploadUserAlbumsWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType imageData:(NSData *)imageData success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpFileServer asyncUploadHttpImageWithApi:api parameters:parameters imagedata:imageData method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 设置眼缘图
+ (void)asyncSetYANYUANPictureWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpFileServer alloc]init] asyncSetYANYUANPictureWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncSetYANYUANPictureWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpFileServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 删除相册图片
+ (void)asyncDeleteUserAlbumsWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpFileServer alloc]init] asyncDeleteUserAlbumsWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncDeleteUserAlbumsWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpFileServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 重置密码
+ (void)asyncResetPasswordWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpFileServer alloc]init] asyncResetPasswordWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncResetPasswordWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpFileServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
+ (void)asyncFindBackPasswordWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpFileServer alloc]init] asyncFindBackPasswordWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncFindBackPasswordWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpFileServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
+ (void)asyncBindPhoneNumberWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpFileServer alloc]init] asyncBindPhoneNumberWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncBindPhoneNumberWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpFileServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}

- (void)hehe{
    
}



@end
