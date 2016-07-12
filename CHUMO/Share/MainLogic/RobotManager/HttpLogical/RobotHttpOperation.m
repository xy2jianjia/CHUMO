//
//  HttpOperation.m
//  RobotMechanism
//
//  Created by xy2 on 16/4/11.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "RobotHttpOperation.h"
#import "SecurityUtil.h"
#import "GTMBase64.h"
/**
 *  加密key可修改
 */
static NSString * const SECURITY_ENCODE_KEY   = @"2015$!@aiyoutech";
@implementation RobotHttpOperation


- (AFHTTPRequestOperationManager *)configOperation{
    static AFHTTPRequestOperationManager *manger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [AFHTTPRequestOperationManager manager];
        manger.responseSerializer = [AFHTTPResponseSerializer serializer];
        manger.requestSerializer = [AFHTTPRequestSerializer serializer];
        manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    });
    return manger;
}

/**
 *  将返回数据转换成字典或者数组
 *
 *  @param jsonData nsdata
 *
 *  @return
 */
- (id)asyncparseJSONDataToNSDictionary:(NSData *)jsonData{
    NSData *datas = jsonData;
    NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
    NSString *decStr = nil;
    if ([result isEqualToString:@""] || result == nil){
        // 数据加载异常
        decStr = nil;
    }else{
        NSData *EncryptData = [GTMBase64 decodeString:result]; //解密前进行GTMBase64编码
        NSString * string = [SecurityUtil decryptAESData:EncryptData app_key:SECURITY_ENCODE_KEY];
        if ([string isEqualToString:@""] || string == nil) {
            // 数据加载异常
            decStr = nil;
        }else{
            decStr = [string copy];
        }
    }
    NSData *JSONData = [decStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = nil;
    if (JSONData==nil) {
        responseJSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    }else{
        responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    }
    return responseJSON;
}


@end
