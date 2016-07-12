//
//  DHConfigHeaderRefreshTool.h
//  CHUMO
//
//  Created by xy2 on 16/2/19.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "MJRefreshGifHeader.h"

@interface DHConfigHeaderRefreshTool : MJRefreshGifHeader

/**
 *  配置下拉刷新
 *
 *  @param target
 *  @param action
 *
 *  @return 
 */
+ (DHConfigHeaderRefreshTool *)configHeaderWithTarget:(id )target action:(SEL )action;


@end
