//
//  DHEyeLuckyBottumCell.h
//  CHUMO
//
//  Created by xy2 on 16/3/14.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
//#define KcellHeight  got(95.0) // cell最小高
//#define KcellSpace got(10) // cell之间的间隔
#define KcellHeight  gotiphon6(115.0) // cell最小高
#define KcellSpace gotiphon6(10) // cell之间的间隔
@interface DHEyeLuckyBottumCell : UICollectionViewCell
@property (nonatomic,strong) UIButton *starButton;
@property (nonatomic,strong) UIImageView *portraitImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@end
