//
//  DHLiveInfoViewController.h
//  CHUMO
//
//  Created by xy2 on 16/7/6.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHLiveInfoViewController : UIViewController

/**
 *  是否主播
 */
@property (nonatomic,assign) NSInteger isAnchor;

@property (nonatomic,strong) DHLiveInfoModel *liveInfoModel;

@end
