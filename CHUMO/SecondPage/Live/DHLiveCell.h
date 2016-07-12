//
//  DHLiveCell.h
//  CHUMO
//
//  Created by xy2 on 16/7/6.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHLiveCell : UICollectionViewCell

@property (nonatomic,strong) DHLiveInfoModel *liveInfoModel;

- (void)setDHLiveInfoModel:(DHLiveInfoModel *)liveInfoModel;

@end
