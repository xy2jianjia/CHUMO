//
//  HomeViewCell.h
//  微信
//
//  Created by Think_lion on 15/6/17.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeModel;

@interface HomeViewCell : UITableViewCell

@property (nonatomic,strong) HomeModel *homeModel;

+(id)cellWithTableView:(UITableView*)tableView cellWithIdentifier:(NSString*)indentifier;

@end
