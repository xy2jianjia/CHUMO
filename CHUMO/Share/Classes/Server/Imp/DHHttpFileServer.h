//
//  DHHttpFileServer.h
//  DHRequestServer
//
//  Created by xy2 on 16/1/20.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHHttpBaseServer.h"

@interface DHHttpFileServer : DHHttpBaseServer
/**
 *  用户头像查询
 *
 *  @param api        f_107_11_1
 *  @param parameters a78：type-->图片类型:156,120,90,72,1000(原图) （不传提取所有）
 *  @param method     get
 *  @param serverType LP-file-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncGetPortraitWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  用户头像保存
 *
 *  @param api        f_107_10_2
 *  @param parameters a102：图片文件流
 *  @param method     post
 *  @param serverType LP-file-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncUploadPortraitWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType imageData:(NSData *)imageData success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  用户相册查询
 *
 *  @param api        f_111_11_1
 *  @param parameters a78：图片类型-->1：眼缘大图 2：普通 (无参数，提取所有数据)，a95:分页参数,a110:是否提取点赞数据-->1:提取  2：不提取(默认不提取)
 *  @param method     get
 *  @param serverType LP-file-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncGetUserAlbumsWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  用户相册保存
 *
 *  @param api        f_111_10_2
 *  @param parameters a78：-->1：眼缘大图 2：普通，a73:排序,a17:描述,a102:图片文件流
 *  @param method     post
 *  @param serverType LP-file-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncUploadUserAlbumsWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  用户相册设置眼缘图
 *
 *  @param api        f_111_14_4
 *  @param parameters a78：->1：眼缘大图 2：普通,a34:图片ID
 *  @param method     get
 *  @param serverType LP-file-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncSetYANYUANPictureWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  用户相册删除
 *
 *  @param api        f_111_12_3
 *  @param parameters a34：图片ID
 *  @param method     get
 *  @param serverType LP-file-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncDeleteUserAlbumsWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  重置密码
 *
 *  @param api        f_120_15_1
 *  @param parameters a81：userName，a56：password，a115：confirmPwd确认密码，a93：短信验证码，p1：sessionId，p2:userId
 *  @param method     get
 *  @param serverType LP-file-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncResetPasswordWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  找回密码
 *
 *  @param api        f_120_13_1
 *  @param parameters a81：userName，a56：password，a115：confirmPwd确认密码，a93：短信验证码
 *  @param method     get
 *  @param serverType LP-file-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncFindBackPasswordWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  电话号码绑定
 *
 *  @param api        f_120_14_1
 *  @param parameters a81：userName，a152：系统产生用户号，a93：短信验证码
 *  @param method     get
 *  @param serverType LP-file-msc
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncBindPhoneNumberWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;



@end
