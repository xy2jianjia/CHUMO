//
//  NSObject+UUID.m
//  CHUMO
//
//  Created by xy2 on 16/5/18.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "NSObject+UUID.h"

@implementation NSObject (UUID)

/**
 *  生成32位uuid
 *
 *  @return
 */
- (NSString *)configUUid{
//    char data[32];
//    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
//    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}

@end
