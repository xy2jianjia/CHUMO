//
//  AFNHttpRequestOPManager.h
//  CaiFuTong
//
//  Created by 朱瀦潴 on 15/10/5.
//  Copyright (c) 2015年 CFT. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"
@protocol AFNHttpRequestOPManagerDelegate <NSObject>
- (void)havingNetwork:(BOOL)isNetWorking;
@end
@interface AFNHttpRequestOPManager : AFHTTPRequestOperationManager
+ (instancetype)sharedClient:(id)sender;
+ (void)netWorkStatus;
+ (void)JSONDataWithUrl:(NSString *)url success:(void (^)(id json))success fail:(void (^)())fail;
+ (void)XMLDataWithUrl:(NSString *)urlStr success:(void (^)(id xml))success fail:(void (^)())fail;
+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)())fail;
+ (void)sessionDownloadWithUrl:(NSString *)urlStr success:(void (^)(NSURL *fileURL))success fail:(void (^)())fail;
+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL fileName:(NSString *)fileName fileType:(NSString *)fileTye success:(void (^)(id responseObject))success fail:(void (^)())fail;
+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL success:(void (^)(id responseObject))success fail:(void (^)())fail;
+ (void)postWithParameters:(NSDictionary *)Parameters
                    subUrl:(NSString *)suburl
                imageDatas:(NSArray *)imageDatas
                     names:(NSArray *)names
                     video:(NSData *)video
                     block:(void (^)(NSDictionary *resultDic, NSError *error))block;
/*
 *brief 取消网络请求
 */
+ (void)cancelRequest;

@end
