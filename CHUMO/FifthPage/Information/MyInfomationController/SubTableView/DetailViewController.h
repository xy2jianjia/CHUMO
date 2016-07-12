//
//  DetailViewController.h
//  StrangerChat
//
//  Created by zxs on 15/11/19.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetaiPicker.h"
@interface DetailViewController : UIViewController
@property (nonatomic,strong)DetaiPicker *detaPick;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,assign)NSInteger totleDetailSum;
@end
