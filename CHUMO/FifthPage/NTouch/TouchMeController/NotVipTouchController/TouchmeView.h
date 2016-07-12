//
//  TouchmeView.h
//  StrangerChat
//
//  Created by zxs on 15/12/1.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchmeView : UIView {
    
    UIImageView *cupImage;
    UILabel *nameLabel;
    UIImageView *crown;     // 皇冠
    UILabel *someBoy;
    UILabel *vip;
}


@property (nonatomic,strong)UILabel *numLabel;      // 人数
@property (nonatomic,strong)UIButton *vipButton;
- (void)addWithcupImage:(NSString *)cup nameLabel:(NSString *)name crown:(NSString *)acrown someBoy:(NSString *)someboy vip:(NSString *)avip;
@end
