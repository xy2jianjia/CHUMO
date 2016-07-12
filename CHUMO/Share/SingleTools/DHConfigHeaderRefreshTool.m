//
//  DHConfigHeaderRefreshTool.m
//  CHUMO
//
//  Created by xy2 on 16/2/19.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHConfigHeaderRefreshTool.h"

@implementation DHConfigHeaderRefreshTool

+ (DHConfigHeaderRefreshTool *)configHeaderWithTarget:(id )target action:(SEL )action{
    DHConfigHeaderRefreshTool *header = [DHConfigHeaderRefreshTool headerWithRefreshingTarget:target refreshingAction:action];
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 1; i < 8; i ++) {
//        NSString *imageName = [NSString stringWithFormat:@"000%02d.png",i];
        NSString *imageName = [NSString stringWithFormat:@"%02d.png",(i+1)];
        UIImage *image = [UIImage imageNamed:imageName];
        [refreshingImages addObject:image];
    }
    NSMutableArray *idleImages = [NSMutableArray array];
    for (int i = 1; i < 8; i ++) {
//        NSString *imageName = [NSString stringWithFormat:@"000%02d.png",i];
        NSString *imageName = [NSString stringWithFormat:@"%02d.png",(i+1)];
        UIImage *image = [UIImage imageNamed:imageName];
        [idleImages addObject:image];
    }
    // 隐藏时间
//    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
//    header.stateLabel.hidden = YES;
    // 设置普通状态的动画图片
    [header setImages:idleImages forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:refreshingImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
//    [header beginRefreshing];
    return header;
}

@end
