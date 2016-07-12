//
//  HobbyViewController.h
//  StrangerChat
//
//  Created by zxs on 15/11/19.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SizeNum [[UIScreen mainScreen] bounds].size.width/20
#define WIDTH [[UIScreen mainScreen] bounds].size.width
@interface HobbyViewController : UIViewController 
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,assign)NSInteger totleHobbySum;
@end
