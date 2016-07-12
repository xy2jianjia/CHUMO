//
//  DHHeaderImageShandboxManager.m
//  DHRequestServer
//
//  Created by xy2 on 16/2/25.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHHeaderImageShandboxManager.h"

@implementation DHHeaderImageShandboxManager
+ (DHHeaderImageShandboxManager *)shareHeaderManager{
    static dispatch_once_t onceToken;
    static DHHeaderImageShandboxManager *manger = nil;
    dispatch_once(&onceToken, ^{
        manger = [[DHHeaderImageShandboxManager alloc]init];
    });
    return manger;
}
- (void)asyncSavePortraitImage:(UIImage *)image imageName:(NSString *)imageName result:(void(^)(BOOL flag,NSString *filePath))result{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:imageName,SHANDBOX_FOLDER_FILE_NAME,@"portrait",SHANDBOX_SUBFOLDER_NAME,nil];
    [self asynSaveImage:image attribute:dict result:^(BOOL flag, NSString *filePath) {
        result(flag,filePath);
    }];
}
@end
