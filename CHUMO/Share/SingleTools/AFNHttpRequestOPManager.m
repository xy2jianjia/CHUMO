//
//  AFNHttpRequestOPManager.m
//  CaiFuTong
//
//  Created by 朱瀦潴 on 15/10/5.
//  Copyright (c) 2015年 CFT. All rights reserved.
//

#import "AFNHttpRequestOPManager.h"
#import "AFHTTPRequestOperationManager.h"

static NSString * const AFAppDotNetAPIBaseURLString = @"http://www.baidu.com";

@implementation AFNHttpRequestOPManager

+ (instancetype)sharedClient:(id)sender{
    
    static AFNHttpRequestOPManager *_sharedClient = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[AFNHttpRequestOPManager alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", nil];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        
        
        [_sharedClient.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            switch (status) {
                    
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    
                {NSLog(@"-------AFNetworkReachabilityStatusReachableViaWWAN------");
//                    if (sender && [sender respondsToSelector:@selector(havingNetwork:)]) {
//                        [sender havingNetwork:YES];
//                    }
                    [Mynotification postNotificationName:@"AFNetworkReachabilityStatusYes" object:@"YES"];
                    break;
                    
                }
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                
                    NSLog(@"-------AFNetworkReachabilityStatusReachableViaWiFi------");
//                    if (sender && [sender respondsToSelector:@selector(havingNetwork:)]) {
//                        [sender havingNetwork:YES];
//                    }
                    [Mynotification postNotificationName:@"AFNetworkReachabilityStatusYes" object:@"YES"];
                    break;
                }
                    
                case AFNetworkReachabilityStatusNotReachable:
                {
//                    if (sender && [sender respondsToSelector:@selector(havingNetwork:)]) {
//                        [sender havingNetwork:NO];
//                    }
                    [Mynotification postNotificationName:@"AFNetworkReachabilityStatusYes" object:@"NO"];
                    
                    break;
                }
                default:
//                    if (sender && [sender respondsToSelector:@selector(havingNetwork:)]) {
//                        [sender havingNetwork:YES];
//                    }
                    [Mynotification postNotificationName:@"AFNetworkReachabilityStatusYes" object:@"YES"];
                    break;
                    
            }
            
        }];
        
        [_sharedClient.reachabilityManager startMonitoring];
        
    });
    
    
    
    return _sharedClient;
    
}



+ (void)netWorkStatus

{
    
    /**
     
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     
     */
    
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        NSLog(@"%ld", status);
        
    }];
    
}




//JSON方式获取数据：

+ (void)JSONDataWithUrl:(NSString *)url success:(void (^)(id json))success fail:(void (^)())fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *dict = @{@"format": @"json"};
    // 网络访问是异步的,回调是主线程的,
    [manager GET:[NSString stringWithFormat:@"%@%@",AFAppDotNetAPIBaseURLString,url] parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSString *html = operation.responseString; 
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dict=[NSJSONSerialization  JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

            success(dict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (fail) {
            fail();
        }
    }];
}


//xml方式获取数据：


+ (void)XMLDataWithUrl:(NSString *)urlStr success:(void (^)(id xml))success fail:(void (^)())fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 返回的数据格式是XML
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    NSDictionary *dict = @{@"format": @"xml"};
    
    // 网络访问是异步的,回调是主线程的
    [manager GET:[NSString stringWithFormat:@"%@%@",AFAppDotNetAPIBaseURLString,urlStr] parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (fail) {
            fail();
        }
    }];
}

//post提交json数据：


+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@%@",AFAppDotNetAPIBaseURLString,urlStr] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            success(dict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (fail) {
            fail();
        }
    }];
    
}


//下载文件：

+ (void)sessionDownloadWithUrl:(NSString *)urlStr success:(void (^)(NSURL *fileURL))success fail:(void (^)())fail
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSString *urlString = [[NSString stringWithFormat:@"%@%@",AFAppDotNetAPIBaseURLString,urlStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // 指定下载文件保存的路径
        //        NSLog(@"%@ %@", targetPath, response.suggestedFilename);
        // 将下载文件保存在缓存路径中
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
        
        // URLWithString返回的是网络的URL,如果使用本地URL,需要注意
        //        NSURL *fileURL1 = [NSURL URLWithString:path];
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        
        //        NSLog(@"== %@ |||| %@", fileURL1, fileURL);
        if (success) {
            success(fileURL);
        }
        
        return fileURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"%@ %@", filePath, error);
        if (fail) {
            fail();
        }
    }];
    
    [task resume];
}
//文件上传
+ (void)postWithParameters:(NSDictionary *)Parameters
                    subUrl:(NSString *)suburl
                imageDatas:(NSArray *)imageDatas
                     names:(NSArray *)names
                     video:(NSData *)video
                     block:(void (^)(NSDictionary *resultDic, NSError *error))block{
  
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager  POST:[NSString stringWithFormat:@"%@%@",AFAppDotNetAPIBaseURLString,suburl]
                             parameters:Parameters
              constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                  
                  for (int i = 0; i<imageDatas.count; i++) {
                      [formData appendPartWithFileData:[imageDatas objectAtIndex:i]
                                                  name:[names objectAtIndex:i]
                                              fileName:[NSString stringWithFormat:@"%@.jpg",[names objectAtIndex:i]]
                                              mimeType:@"image/jpeg"];
                      
                  }
                  
                  
                  if (video) {
                      [formData appendPartWithFileData:video
                                                  name:@"video"
                                              fileName:[NSString stringWithFormat:@"%@.mp4",@"video"]
                                              mimeType:@"video/mp4"];
                  }
                  
                  
              } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  NSString *html = operation.responseString;
                  NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                  id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                  
                  if (block && dict) {
                      block(dict,nil);
                  }
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  NSLog(@"error = %@",error.description);
                  if (block) {
                      block(nil,error);
                  }
                  
              }];
    
    
}
//文件上传－自定义上传文件名：

+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL fileName:(NSString *)fileName fileType:(NSString *)fileTye success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    // 本地上传给服务器时,没有确定的URL,不好用MD5的方式处理
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //@"http://localhost/demo/upload.php"
    [manager POST:[NSString stringWithFormat:@"%@%@",AFAppDotNetAPIBaseURLString,urlStr] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"头像1.png" withExtension:nil];
        
        // 要上传保存在服务器中的名称
        // 使用时间来作为文件名 2014-04-30 14:20:57.png
        // 让不同的用户信息,保存在不同目录中
        //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //        // 设置日期格式
        //        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        //        NSString *fileName = [formatter stringFromDate:[NSDate date]];
        
        //@"image/png"
        [formData appendPartWithFileURL:fileURL name:@"uploadFile" fileName:fileName mimeType:fileTye error:NULL];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail();
        }
    }];
}
//文件上传－随机生成文件名：

+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // AFHTTPResponseSerializer就是正常的HTTP请求响应结果:NSData
    // 当请求的返回数据不是JSON,XML,PList,UIImage之外,使用AFHTTPResponseSerializer
    // 例如返回一个html,text...
    //
    // 实际上就是AFN没有对响应数据做任何处理的情况
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // formData是遵守了AFMultipartFormData的对象
    [manager POST:[NSString stringWithFormat:@"%@%@",AFAppDotNetAPIBaseURLString,urlStr] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 将本地的文件上传至服务器
        //        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"头像1.png" withExtension:nil];
        
        [formData appendPartWithFileURL:fileURL name:@"uploadFile" error:NULL];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //
        //        NSLog(@"完成 %@", result);
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误 %@", error.localizedDescription);
        if (fail) {
            fail();
        }
    }];
}

#pragma mark 取消网络请求

+ (void)cancelRequest{
    
    NSLog(@"cancelRequest");
    [[[[self class] sharedManager] operationQueue] cancelAllOperations];
    
}
@end
