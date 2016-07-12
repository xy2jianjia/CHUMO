//
//  EyeLuckViewController+Banner.h
//  CHUMO
//
//  Created by xy2 on 16/4/21.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "EyeLuckViewController.h"
#import "SDCycleScrollView.h"
@interface EyeLuckViewController (Banner)<SDCycleScrollViewDelegate>
- (void)asyncGetBannerList:(void(^)(UIView *bannerView,NSArray *arr))completed;
@end
