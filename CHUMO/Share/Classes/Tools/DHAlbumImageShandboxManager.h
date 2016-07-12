//
//  DHAlbumImageShandboxManager.h
//  DHRequestServer
//
//  Created by xy2 on 16/2/25.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHImageShandboxManager.h"

@interface DHAlbumImageShandboxManager : DHImageShandboxManager
/**
 *  单例
 *
 *  @return 
 */
+ (DHAlbumImageShandboxManager *)shareAlbumManager;
/**
 *  保存相册图片到沙盒
 *
 *  @param image
 *  @param imageName
 *  @param result    
 */
- (void)asyncSaveAlbumImage:(UIImage *)image imageName:(NSString *)imageName result:(void(^)(BOOL flag,NSString *filePath))result;
@end
