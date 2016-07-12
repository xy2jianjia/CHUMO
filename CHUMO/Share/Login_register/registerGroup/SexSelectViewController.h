//
//  SexSelectViewController.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/6/2.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SexSelectViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *manView;
@property (weak, nonatomic) IBOutlet UIImageView *manClickImage;

@property (weak, nonatomic) IBOutlet UIView *feManView;
@property (weak, nonatomic) IBOutlet UIImageView *feManClickImage;
@property (weak, nonatomic) IBOutlet UIButton *trueButton;

@property (nonatomic,assign)BOOL isNotThird;
@end
