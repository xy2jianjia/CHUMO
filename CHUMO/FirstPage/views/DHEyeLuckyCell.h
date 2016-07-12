//
//  DHEyeLuckyCell.h
//  CHUMO
//
//  Created by xy2 on 16/3/12.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
#define colletionCell 2  //设置具体几列
//#define KcellHeight  got(95.0) // cell最小高
//#define KcellSpace got(10) // cell之间的间隔
#define KcellHeight  gotiphon6(117.5) // cell最小高
#define KcellSpace gotiphon6(10) // cell之间的间隔
@interface DHEyeLuckyCell : UICollectionViewCell
//@property (nonatomic,strong)DHUserInfoModel *userInfo;


@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *ageLabel;
@property (nonatomic,strong) UIImageView *rangeimageV;
@property (nonatomic,strong) UILabel *rangeLabel;
@property (nonatomic,strong) UIButton *starButton;
@property (nonatomic,strong) UIImageView *portraitImageView;
@property (nonatomic,strong) UIImageView *vipImageV;
@end
