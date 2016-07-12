//
//  DHFileShandboxManager.m
//  DHRequestServer
//
//  Created by xy2 on 16/2/25.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHFileShandboxManager.h"

@implementation DHFileShandboxManager

- (void)asynSaveFile:(NSData *)data attribute:(NSDictionary *)attribute result:(void (^)(BOOL flag, NSString *fielPath))result{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:attribute];
    [dict setObject:@"download" forKey:SHANDBOX_FOLDER_NAME];
    [self asyncSaveFileToShandboxWithData:data pathType:SHANBOX_PATH_TYPE_CACHE fileInfo:dict result:^(BOOL flag, NSString *fielPath) {
        result(flag,fielPath);
    }];
    
}
@end
