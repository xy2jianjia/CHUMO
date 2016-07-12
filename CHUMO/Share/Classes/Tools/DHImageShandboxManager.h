//
//  DHImageShandboxManager.h
//  DHRequestServer
//
//  Created by xy2 on 16/2/25.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHShanboxManager.h"
#import <UIKit/UIKit.h>
@interface DHImageShandboxManager : DHShanboxManager

/**
 *  保存图片到沙盒
 *
 *  @param image     image
 *  @param attribute 图片属性，key为const常量
 *  @param result    
 */
- (void)asynSaveImage:(UIImage *)image attribute:(NSDictionary *)attribute result:(void (^)(BOOL flag, NSString *fielPath))result;

@end
