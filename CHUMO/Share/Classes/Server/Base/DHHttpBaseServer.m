//
//  DHHttpBaseServer.m
//  DHRequestServer
//
//  Created by xy2 on 16/1/19.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHHttpBaseServer.h"

@implementation DHHttpBaseServer


+ (void)getHttpWithApi:(NSString *)api parameters:(NSDictionary *)parameters method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
//    AFHTTPRequestOperationManager *manager = [DHHttpBaseServer getRequestManager];
//    
//    [DHHttpBaseServer actionWithRequest:manager methodType:method server:serverType service:api parameters:parameters completed:^(id result, NSInteger resultCode) {
//        if (resultCode == 200) {
//            success(result,resultCode);
//        }else{
//            falureMsg([result objectForKey:@"msg"]);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSDictionary *userInfo) {
//        falure(userInfo);
//    }];
}
+ (void)asyncUploadHttpImageWithApi:(NSString *)api parameters:(NSDictionary *)parameters imagedata:(NSData *)imageData method:(DHRequestMethodType )method server:(DHRequestServerType )serverType success:(void(^)(id result , NSInteger code))success falureMsg:(void(^)(NSString *msg))falureMsg falure:(void (^)(NSDictionary *userInfo))falure{
    
//    [DHHttpBaseServer actionFromImageTypeForUploadImageData:imageData methodType:method server:serverType service:api parameters:parameters completed:^(id result, NSInteger resultCode) {
//        if (resultCode == 200) {
//            success(result,resultCode);
//        }else{
//            falureMsg([result objectForKey:@"msg"]);
//        }
//    } failure:^(NSDictionary *userInfo) {
//        falure(userInfo);
//    }];
}
@end
