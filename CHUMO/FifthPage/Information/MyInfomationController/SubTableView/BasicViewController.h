//
//  BasicViewController.h
//  StrangerChat
//
//  Created by zxs on 15/11/19.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicSelector.h"
#import "DatePickView.h"

#define SECTIONNUM 3


@interface BasicViewController : UIViewController


@property (nonatomic,strong)BasicSelector *selector;
@property (nonatomic,strong)DatePickView *datePickers;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,assign)NSInteger totleBasicSum;//已经选中的数量(没有头像)
@property (nonatomic,assign)NSInteger otherSum;//头像选中的数量
@end
