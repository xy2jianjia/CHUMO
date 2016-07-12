//
//  DHHttpBusServer.m
//  DHRequestServer
//
//  Created by xy2 on 16/1/20.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHHttpBusServer.h"

@implementation DHHttpBusServer
// 手机注册
+ (void)asyncRegisterByPhoneNumberWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncRegisterByPhoneNumberWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncRegisterByPhoneNumberWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 账号注册
+ (void)asyncRegisterByNumberWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncRegisterByNumberWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncRegisterByNumberWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 眼缘首页（触动）
+ (void)asyncGetYANYUANListWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncGetYANYUANListWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncGetYANYUANListWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 用户详细信息
+ (void)asyncGetUserDetailInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    
    [[[DHHttpBusServer alloc]init] asyncGetUserDetailInfoWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncGetUserDetailInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
//    AFHTTPRequestOperationManager *manager = [DHHttpBusServer getRequestManager];
//    [DHHttpBusServer actionWithRequest:manager methodType:method server:DHRequestServerTypeBus service:api parameters:parameters completed:^(id result, NSInteger resultCode) {
//        success(result,resultCode);
//    } failure:^(AFHTTPRequestOperation *operation, NSDictionary *userInfo) {
//         falure(userInfo);
//    }];
    
//    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
//        success(result,code);
//    } falureMsg:^(NSString *msg) {
//        falureMsg(msg);
//    } falure:^(NSDictionary *userInfo) {
//        falure(userInfo);
//    }];
}
// 用户详细信息查询
+ (void)asyncFindUserDetailInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncFindUserDetailInfoWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncFindUserDetailInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 保存用户信息
+ (void)asyncSaveUserDetailInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncSaveUserDetailInfoWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncSaveUserDetailInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 保存点赞信息
+ (void)asyncSaveLikeDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncSaveLikeDataWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncSaveLikeDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 删除点赞信息
+ (void)asyncDeleteLikeDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncSaveLikeDataWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncDeleteLikeDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 查询征友条件
+ (void)asyncFindFriendFilterDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncFindFriendFilterDataWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncFindFriendFilterDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 保存征友条件
+ (void)asyncSaveFriendFilterDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncSaveFriendFilterDataWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncSaveFriendFilterDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 查询好友关系
+ (void)asyncFriendRelationShipDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncFriendRelationShipDataWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncFriendRelationShipDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 保存好友关系
+ (void)asyncSaveFriendRelationShipDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncSaveFriendRelationShipDataWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncSaveFriendRelationShipDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 修改好友关系
+ (void)asyncUpdateFriendRelationShipDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncUpdateFriendRelationShipDataWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncUpdateFriendRelationShipDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 删除好友关系
+ (void)asyncDeleteFriendRelationShipDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncDeleteFriendRelationShipDataWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncDeleteFriendRelationShipDataWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 查询好友关注
+ (void)asyncFindFriendFocusWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncFindFriendFocusWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncFindFriendFocusWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 保存好友关注
+ (void)asyncSaveFriendFocusWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncSaveFriendFocusWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncSaveFriendFocusWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 删除好友关注
+ (void)asyncDeleteFriendFocusWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncDeleteFriendFocusWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncDeleteFriendFocusWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 关注我的
+ (void)asyncFindFocusOnMeWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncFindFocusOnMeWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncFindFocusOnMeWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 保存关注我的
+ (void)asyncSaveFocusOnMeWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncSaveFocusOnMeWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncSaveFocusOnMeWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 搜索
+ (void)asyncFindSearchListWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncFindSearchListWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncFindSearchListWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 保存搜索条件
+ (void)asyncSaveSearchConditionWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncSaveSearchConditionWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncSaveSearchConditionWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 查询搜索条件
+ (void)asyncFindSearchConditionWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncFindSearchConditionWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncFindSearchConditionWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 保存用户位置
+ (void)asyncSaveUserLocationWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncSaveUserLocationWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncSaveUserLocationWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 删除用户位置
+ (void)asyncDeleteUserLocationWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncDeleteUserLocationWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncDeleteUserLocationWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 系统配置信息
+ (void)asyncGetSystemConfigInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncGetSystemConfigInfoWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncGetSystemConfigInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 保存用户反馈
+ (void)asyncUploadFeedbackWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncUploadFeedbackWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}

- (void)asyncUploadFeedbackWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 获取简单用户信息
+ (void)asyncGetUserSimpleInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncGetUserSimpleInfoWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncGetUserSimpleInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
// 提取用户vip特权
+ (void)asyncGetUserVIPPrivilegeWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncGetUserVIPPrivilegeWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncGetUserVIPPrivilegeWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}

+ (void)asyncGetSystemVIPInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncGetSystemVIPInfoWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncGetSystemVIPInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
+ (void)asyncSaveOrderInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncSaveOrderInfoWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncSaveOrderInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
+ (void)asyncGetUserVIPInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncGetUserVIPInfoWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncGetUserVIPInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
+ (void)asyncGetOrderProtocolInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncGetOrderProtocolInfoWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncGetOrderProtocolInfoWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}
+ (void)asyncRandomMessageListWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncRandomMessageListWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncRandomMessageListWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
//    AFHTTPRequestOperationManager *manager = [DHHttpBusServer getRequestManager];
//    [DHHttpBusServer actionWithRequest:manager methodType:method server:DHRequestServerTypeBus service:api parameters:parameters completed:^(id result, NSInteger resultCode) {
//        success(result,resultCode);
//    } failure:^(AFHTTPRequestOperation *operation, NSDictionary *userInfo) {
//        falure(userInfo);
//    }];
//    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
//        success(result,code);
//    } falureMsg:^(NSString *msg) {
//        falureMsg(msg);
//    } falure:^(NSDictionary *userInfo) {
//        falure(userInfo);
//    }];
}
+ (void)asyncRobotListWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncRobotListWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncRobotListWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    
//    AFHTTPRequestOperationManager *manager = [DHHttpBusServer getRequestManager];
//    [DHHttpBusServer actionWithRequest:manager methodType:method server:DHRequestServerTypeBus service:api parameters:parameters completed:^(id result, NSInteger resultCode) {
//        success(result,resultCode);
//    } failure:^(AFHTTPRequestOperation *operation, NSDictionary *userInfo) {
//        falure(userInfo);
//    }];
    
//    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
//        success(result,code);
//    } falureMsg:^(NSString *msg) {
//        falureMsg(msg);
//    } falure:^(NSDictionary *userInfo) {
//        falure(userInfo);
//    }];
}
+ (void)asyncNearbyListWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [[[DHHttpBusServer alloc]init] asyncNearbyListWithApi:api parameters:parameters method:method server:serverType success:success falureMsg:falureMsg falure:falure];
}
- (void)asyncNearbyListWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    [DHHttpBusServer getHttpWithApi:api parameters:parameters method:method server:serverType success:^(id result, NSInteger code) {
        success(result,code);
    } falureMsg:^(NSString *msg) {
        falureMsg(msg);
    } falure:^(NSDictionary *userInfo) {
        falure(userInfo);
    }];
}

@end
