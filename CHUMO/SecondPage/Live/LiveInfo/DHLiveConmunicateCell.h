//
//  DHLiveConmunicateCell.h
//  CHUMO
//
//  Created by xy2 on 16/7/6.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveMessageModel.h"
@interface DHLiveConmunicateCell : UITableViewCell


@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *contentLabel;

@property (nonatomic,strong) LiveMessageModel *messageModel;
- (void)setMessageModel:(LiveMessageModel *)messageModel;
@end
