//
//  DHAlbumImageShandboxManager.m
//  DHRequestServer
//
//  Created by xy2 on 16/2/25.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHAlbumImageShandboxManager.h"

@implementation DHAlbumImageShandboxManager
+ (DHAlbumImageShandboxManager *)shareAlbumManager{
    static dispatch_once_t onceToken;
    static DHAlbumImageShandboxManager *manger = nil;
    dispatch_once(&onceToken, ^{
        manger = [[DHAlbumImageShandboxManager alloc]init];
    });
    return manger;
}
- (void)asyncSaveAlbumImage:(UIImage *)image imageName:(NSString *)imageName result:(void(^)(BOOL flag,NSString *filePath))result{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:imageName,SHANDBOX_FOLDER_FILE_NAME,@"photos",SHANDBOX_SUBFOLDER_NAME,nil];
    [self asynSaveImage:image attribute:dict result:^(BOOL flag, NSString *filePath) {
        result(flag,filePath);
    }];
}
@end
