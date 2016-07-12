//
//  DHImageShandboxManager.m
//  DHRequestServer
//
//  Created by xy2 on 16/2/25.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHImageShandboxManager.h"

@implementation DHImageShandboxManager

- (void)asynSaveImage:(UIImage *)image attribute:(NSDictionary *)attribute result:(void (^)(BOOL flag, NSString *filePath))result{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:attribute];
    [dict setObject:@"images" forKey:SHANDBOX_FOLDER_NAME];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    [self asyncSaveFileToShandboxWithData:data pathType:SHANBOX_PATH_TYPE_CACHE fileInfo:dict result:^(BOOL flag, NSString *filePath) {
        result(flag,filePath);
    }];
}

@end
