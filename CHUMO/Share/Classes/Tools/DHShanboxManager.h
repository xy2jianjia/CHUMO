//
//  DHShanboxManager.h
//  DHRequestServer
//
//  Created by xy2 on 16/2/25.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  沙盒路径枚举
 */
typedef NS_ENUM(NSInteger ,SHANBOX_PATH_TYPE) {
    /**
     *  document 文件夹
     */
    SHANBOX_PATH_TYPE_DOCUMENT = 0,
    /**
     *  cache 文件夹
     */
    SHANBOX_PATH_TYPE_CACHE,
    /**
     *  tmp 文件夹
     */
    SHANBOX_PATH_TYPE_TEMP,
    /**
     *  family 文件夹
     */
    SHANBOX_PATH_TYPE_LIBRALY
};
/**
 *  存入沙盒的附加属性之一：主文件夹名
 */
static NSString * const SHANDBOX_FOLDER_NAME   = @"SHANDBOX_FOLDER_NAME";
/**
 *  存入沙盒的附加属性之一：子文件夹名
 */
static NSString * const SHANDBOX_SUBFOLDER_NAME   = @"SHANDBOX_SUBFOLDER_NAME";
/**
 *  存入沙盒的附加属性之一：文件名
 */
static NSString * const SHANDBOX_FOLDER_FILE_NAME   = @"SHANDBOX_FOLDER_FILE_NAME";

@interface DHShanboxManager : NSObject

/**
 *  根据类型获取沙盒路径
 *
 *  @param type SHANBOX_PATH_TYPE
 *
 *  @return 沙盒路径
 */
- (NSString *)asyncConfigShandboxType:(SHANBOX_PATH_TYPE )type;
/**
 *  将文件保存到沙盒
 *
 *  @param data        二进制文件流
 *  @param pathType    SHANBOX_PATH_TYPE
 *  @param fileInfo    文件的附加属性：保存到字典的key分别为：SHANDBOX_FOLDER_NAME，SHANDBOX_SUBFOLDER_NAME，SHANDBOX_FOLDER_FILE_NAME
 *  @param resultBlock 返回结果
 */
- (void) asyncSaveFileToShandboxWithData:(NSData *)data pathType:(SHANBOX_PATH_TYPE )pathType fileInfo:(NSDictionary *)fileInfo result:(void(^)(BOOL flag, NSString *fielPath))resultBlock;
/**
 *  获取沙盒内的文件
 *
 *  @param pathType    SHANBOX_PATH_TYPE
 *  @param fileInfo    文件的附加属性：保存到字典的key分别为：SHANDBOX_FOLDER_NAME，SHANDBOX_SUBFOLDER_NAME，SHANDBOX_FOLDER_FILE_NAME
 *  @param resultBlock 返回二进制文件流
 */
- (void )asyncGetShandboxFileWithPathtype:(SHANBOX_PATH_TYPE )pathType fileInfo:(NSDictionary *)fileInfo result:(void(^)(NSString *filePath , NSData *data))resultBlock;
@end
