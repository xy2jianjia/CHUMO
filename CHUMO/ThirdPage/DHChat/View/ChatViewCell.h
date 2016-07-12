//
//  ChatViewCell.h
//  微信
//
//  Created by Think_lion on 15/6/19.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewShow.h"
@class MessageFrameModel;


@interface ChatViewCell : UITableViewCell

//+(instancetype)cellWithTableView:(UITableView*)tableView indentifier:(NSString*)indentifier;
+ (ChatViewCell *)configTableViewCell;
@property (nonatomic,strong) MessageFrameModel *frameModel;
@property (nonatomic,weak)  ChatViewShow *viewShow;
@end
