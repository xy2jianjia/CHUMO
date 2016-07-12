//
//  DHHttpBaseServer.h
//  DHRequestServer
//
//  Created by xy2 on 16/1/19.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHActionServer.h"

@interface DHHttpBaseServer : DHActionServer
/**
 *  请求数据基类
 *
 *  @param api        api
 *  @param parameters 参数
 *  @param method     get/post
 *  @param serverType 请求类型
 *  @param success
 *  @param falureMsg
 *  @param falure     
 */
+ (void)getHttpWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
/**
 *  上传图片
 *
 *  @param api        api
 *  @param parameters 参数
 *  @param imageData  图片文件二进制格式
 *  @param method     post
 *  @param serverType file
 *  @param success
 *  @param falureMsg
 *  @param falure
 */
+ (void)asyncUploadHttpImageWithApi:(NSString *)api parameters:(NSDictionary *)parameters imagedata:(NSData *)imageData method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure;
@end
