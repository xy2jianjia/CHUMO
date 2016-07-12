//
//  DHHeaderImageShandboxManager.h
//  DHRequestServer
//
//  Created by xy2 on 16/2/25.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHImageShandboxManager.h"

@interface DHHeaderImageShandboxManager : DHImageShandboxManager
/**
 *  单例
 *
 *  @return 
 */
+ (DHHeaderImageShandboxManager *)shareHeaderManager;
/**
 *  保存
 *
 *  @param image     保存头像
 *  @param imageName 图片名字
 *  @param result    
 */
- (void)asyncSavePortraitImage:(UIImage *)image imageName:(NSString *)imageName result:(void(^)(BOOL flag,NSString *filePath))result;
@end
