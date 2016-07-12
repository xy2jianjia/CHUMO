//
//  ReportImageTableViewCell.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/2/19.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *reportImageView;

@property (weak, nonatomic) IBOutlet UIImageView *fristImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;

@end
