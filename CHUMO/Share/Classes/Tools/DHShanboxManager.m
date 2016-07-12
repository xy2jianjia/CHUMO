//
//  DHShanboxManager.m
//  DHRequestServer
//
//  Created by xy2 on 16/2/25.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHShanboxManager.h"

@implementation DHShanboxManager

- (NSString *)asyncConfigShandboxType:(SHANBOX_PATH_TYPE )type{
    switch (type) {
        case SHANBOX_PATH_TYPE_DOCUMENT:
        {
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
            return documentPath;
        }
            
            break;
        case SHANBOX_PATH_TYPE_CACHE:
        {
            NSString *cachePatch = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) lastObject];
            return cachePatch;
        }
            break;
        case SHANBOX_PATH_TYPE_TEMP:
        {
            NSString *tempPath = NSTemporaryDirectory();
            return tempPath;
        }
            break;
        case SHANBOX_PATH_TYPE_LIBRALY:
        {
            NSString *libralyPatch = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
            return libralyPatch;
        }
            break;
        default:
        {
            NSString *homePath = NSHomeDirectory();
            return homePath;
        }
            break;
    }
}
- (void )asyncSaveFileToShandboxWithData:(NSData *)data pathType:(SHANBOX_PATH_TYPE )pathType fileInfo:(NSDictionary *)fileInfo result:(void(^)(BOOL flag, NSString *filePath))resultBlock{
    NSString *folder = [fileInfo objectForKey:SHANDBOX_FOLDER_NAME];
    NSString *subfolder = [fileInfo objectForKey:SHANDBOX_SUBFOLDER_NAME];
    NSString *fileName = [fileInfo objectForKey:SHANDBOX_FOLDER_FILE_NAME];
    // 获取沙盒目录
    NSString *path = [self asyncConfigShandboxType:pathType];
    NSString *filePath = [[path stringByAppendingPathComponent:folder] stringByAppendingPathComponent:subfolder] ;
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ){
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fullPath = [filePath stringByAppendingPathComponent:fileName];
    // 将图片写入文件
    BOOL result = [data writeToFile:fullPath atomically:NO];
    resultBlock(result,fullPath);
}

- (void )asyncGetShandboxFileWithPathtype:(SHANBOX_PATH_TYPE )pathType fileInfo:(NSDictionary *)fileInfo result:(void(^)(NSString *filePath , NSData *data))resultBlock{
    NSString *folder = [fileInfo objectForKey:SHANDBOX_FOLDER_NAME];
    NSString *subfolder = [fileInfo objectForKey:SHANDBOX_SUBFOLDER_NAME];
    NSString *fileName = [fileInfo objectForKey:SHANDBOX_FOLDER_FILE_NAME];
    // 获取沙盒目录
    NSString *path = [self asyncConfigShandboxType:pathType];
    NSString *filePath = [[path stringByAppendingPathComponent:folder] stringByAppendingPathComponent:subfolder];
    NSString *fullPath = [filePath stringByAppendingPathComponent:fileName];
    NSData *data = [NSData dataWithContentsOfFile:fullPath];
    resultBlock(fullPath,data);
}


@end
