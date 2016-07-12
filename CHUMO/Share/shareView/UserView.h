//
//  UserView.h
//  CHUMO
//
//  Created by zxs on 16/2/19.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
#define Width [[UIScreen mainScreen] bounds].size.width
#define ImageW 212
#define ImageH 248
#define BcTW 96

@class UserView;
@protocol PhograpDelegate <NSObject>

- (void)setBut:(UserView *)phoBt btTag:(NSInteger)proTag;

@end
@interface UserView : UIView {

    UIImageView *_allImage;
    UIButton *_phograp;
    UIButton *_albumButton;
    UILabel *_hoTitle;
    UILabel *_prTitle;
}
@property (nonatomic, strong)UILabel *titlePi;
@property (nonatomic, strong)UIImageView *poImage;
@property (nonatomic,weak) id<PhograpDelegate>phograpDelegate;
@end
