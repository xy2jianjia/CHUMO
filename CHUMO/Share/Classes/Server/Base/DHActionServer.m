//
//  DHActionServer.m
//  DHRequestServer
//
//  Created by xy2 on 16/1/19.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHActionServer.h"
@implementation DHActionServer

+ (DHActionServer *)shareActionServer{
    static DHActionServer *action = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        action = [[DHActionServer alloc]init];
    });
    return action;
}
/**
 *  配置url，
 *
 *  @param domain 请求二级域名类型
 *  @param api    服务端方法名
 *
 *  @return
 */
- (NSString *)asyncConfigURLWithRootDomain:(const NSString *)domain server:(DHRequestServerType )serverType api:(NSString *)api{
    NSString *server = nil;
    if (serverType == DHRequestServerTypeAuthor) {
        server = SERVER_DOMAIN_AUTHOR;
    }else if (serverType == DHRequestServerTypeBus){
        server = SERVER_DOMAIN_BUS;
    }else if(serverType == DHRequestServerTypeFile){
        server = SERVER_DOMAIN_FILE;
    }else if (serverType == DHRequestServerTypePay){
         server = SERVER_DOMAIN_PAY;
    }
    return [NSString stringWithFormat:@"%@%@%@",domain,server,api];
}
// 请求服务器
+ (void)asyncQueryWithMethodType:(DHRequestMethodType )methodType domain:(DHRequestServerType )domain function:(NSString *)function parameters:(NSDictionary *)parameters completed:(void(^)(id result ,NSInteger resultCode))completed{
    [[DHActionServer shareActionServer] asyncQueryWithMethodType:methodType domain:domain function:function parameters:parameters completed:completed];
    
}
- (void)asyncQueryWithMethodType:(DHRequestMethodType )methodType domain:(DHRequestServerType )domain function:(NSString *)function parameters:(NSDictionary *)parameters completed:(void(^)(id result ,NSInteger resultCode))completed {
        NSMutableString *str = [NSMutableString string];
        for (int i = 0; i < [[parameters allKeys] count]; i ++) {
            if (i == [[parameters allKeys] count] - 1) {
                [str appendFormat:@"%@=%@",[[parameters allKeys] objectAtIndex:i],[parameters objectForKey:[[parameters allKeys] objectAtIndex:i]]];
            }else{
                [str appendFormat:@"%@=%@&",[[parameters allKeys] objectAtIndex:i],[parameters objectForKey:[[parameters allKeys] objectAtIndex:i]]];
            }
        }
        __weak DHActionServer *weakSelf = self;
        NSString *url = [weakSelf asyncConfigURLWithRootDomain:LOCAL_194_SERVERURL server:domain api:[NSString stringWithFormat:@"%@?%@",function,str]];
        ASIHTTPRequest *request1 = [weakSelf getRequestWithMethod:@"GET" api:url];
        [weakSelf resultWithRequest:request1 result:^(id result, NSInteger resultCode) {
            completed(result,resultCode);
        }];
}
+ (void)asyncUploadWithImageData:(NSData *)imageData methodType:(DHRequestMethodType )methodType server:(DHRequestServerType )serverType service:(NSString *)service parameters:(NSDictionary *)parameters completed:(void(^)(id result ,NSInteger resultCode))completed failure:(void(^)(NSDictionary *userInfo))failureBlock{
    [[DHActionServer shareActionServer] asyncUploadWithImageData:imageData methodType:methodType server:serverType service:service parameters:parameters completed:completed failure:failureBlock];
}
- (void)asyncUploadWithImageData:(NSData *)imageData methodType:(DHRequestMethodType )methodType server:(DHRequestServerType )serverType service:(NSString *)service parameters:(NSDictionary *)parameters completed:(void(^)(id result ,NSInteger resultCode))completed failure:(void(^)(NSDictionary *userInfo))failureBlock{
    NSMutableString *urlStr = [NSMutableString string];
    for (NSString *akey in [parameters allKeys]) {
        [urlStr appendFormat:@"%@=%@&",akey,[parameters objectForKey:akey]];
    }
    NSString *urlString = nil;
    if ([urlStr length] > 0) {
        urlString = [NSString stringWithFormat:@"%@",[urlStr substringToIndex:[urlStr length]-1]];
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",[self asyncConfigURLWithRootDomain:LOCAL_194_SERVERURL server:serverType api:service],urlString];
//    [NSString stringWithFormat:@"%@%@%@.service?%@",INLINE_FILE_SERVER_URL,server,service,urlString];
    NSData *data = imageData;
    NSMutableData *myRequestData=[NSMutableData data];
    //分界线 --AaB03x
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //        //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableString *imgbody = [[NSMutableString alloc] init];
    ////添加分界线，换行
    [imgbody appendFormat:@"%@\r\n",MPboundary];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmsssss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@", str];
    //声明pic字段，文件名为数字.png，方便后面使用
    [imgbody appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n",@"a102",fileName];
    //声明上传文件的格式
    //            [imgbody appendFormat:@"Content-Type: image/png\r\n\r\n"];
    [imgbody appendFormat:@"Content-Type: application/octet-stream; charset=utf-8\r\n\r\n"];
    //声明myRequestData，用来放入http body
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[imgbody dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    [myRequestData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"%@\r\n",endMPboundary];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request addRequestHeader:@"Content-Type" value:content];
    //设置http body
    [request setPostBody:myRequestData];
    if (methodType == DHRequestMethodTypePost) {
        [request setRequestMethod:@"POST"];
    }else{
        [request setRequestMethod:@"GET"];
    }
    [request setTimeOutSeconds:1200];
    [request setDelegate:self];
    [request startSynchronous];
    NSInteger responseCode = [request responseStatusCode];
    NSData *responseObject = request.responseData;
    id responseJSON = [self asyncparseJSONDataToNSDictionary:responseObject];
    NSInteger codeNum = [responseJSON[@"code"] integerValue];
    if (responseCode == 200 && codeNum == 200) {
        completed(responseJSON,codeNum);
    }else{
        failureBlock(responseJSON);
    }
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
/**
 *  开始请求
 *
 *  @param request
 *  @param resultBlock
 */
- (void)resultWithRequest:(ASIHTTPRequest *)request result:(void(^)(id result ,NSInteger resultCode))resultBlock{
    __weak ASIHTTPRequest *weakrequet = request;
    __block NSInteger responseCode = 0;
    [request startAsynchronous];
    [request setCompletionBlock:^{
        NSData* data = weakrequet.responseData;
        NSDictionary *responseJSON = [self asyncparseJSONDataToNSDictionary:data];
        responseCode = weakrequet.responseStatusCode;
        resultBlock(responseJSON,responseCode);
    }];
    [request setFailedBlock:^{
        responseCode = weakrequet.responseStatusCode;
        NSDictionary *dict = weakrequet.error.userInfo;
        resultBlock(dict,responseCode);
    }];
}
/**
 *  获取请求对象
 *
 *  @param method GET/POST
 *  @param api
 *
 *  @return
 */
- (ASIHTTPRequest *)getRequestWithMethod:(NSString *)method api:(NSString *)api {
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:api]];
    [request setRequestMethod:method];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setTimeOutSeconds:1600];
    return request;
}


@end
