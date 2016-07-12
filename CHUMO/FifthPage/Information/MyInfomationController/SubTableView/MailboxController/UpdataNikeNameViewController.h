//
//  UpdataNikeNameViewController.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/3/8.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^updateBlock) (NSString *);
@interface UpdataNikeNameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *updateNameText;
@property (nonatomic,copy)updateBlock UB;
@property (nonatomic,strong)NSString *currentName;
@end
