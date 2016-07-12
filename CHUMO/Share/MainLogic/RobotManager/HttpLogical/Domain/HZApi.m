//
//  HZApi.m
//  CHUMO
//
//  Created by xy2 on 16/3/31.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "HZApi.h"

@implementation HZApi

+ (NSString *)configApiFromPlistFileWithKey:(NSString *)key{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"APIList.plist" ofType:nil];
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *apiDict = nil;
    switch (kAPIType) {
        case 1000:
            apiDict = [temp objectForKey:@"INLINE_DOMAIN"];
            break;
        case 2000:
            apiDict = [temp objectForKey:@"COM_DOMAIN"];
            break;
        case 3000:
            apiDict = [temp objectForKey:@"COM_DOMAIN_1"];
            break;
        case 4000:
            apiDict = [temp objectForKey:@"COM_DOMAIN_2"];
            break;
        default:
            return nil;
            break;
    }
    return [apiDict objectForKey:key];
    
}

+ (NSString *)AUTHER_API{
    
//    return [HZApi AUTHER_API];
    return [HZApi configApiFromPlistFileWithKey:@"AUTHER_API"];
}
+ (NSString *)BUS_API{
    return [HZApi configApiFromPlistFileWithKey:@"BUS_API"];
//    return [HZApi BUS_API];
}
+ (NSString *)PAY_API{
//    return [HZApi PAY_API];
    return [HZApi configApiFromPlistFileWithKey:@"PAY_API"];
}
+ (NSString *)FILE_API{
//    return [HZApi FILE_API];
    return [HZApi configApiFromPlistFileWithKey:@"FILE_API"];
}
+ (NSString *)H5_API{
//    return [HZApi H5_API];
    return [HZApi configApiFromPlistFileWithKey:@"H5_API"];
}
@end
