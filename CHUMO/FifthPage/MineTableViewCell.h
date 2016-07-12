//
//  MineTableViewCell.h
//  StrangerChat
//
//  Created by 朱瀦潴 on 16/2/1.
//  Copyright © 2016年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *sysimageView;
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UIView *setContetnView;
@property (weak, nonatomic) IBOutlet UIView *havingLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightSysImageConstraint;

@end
