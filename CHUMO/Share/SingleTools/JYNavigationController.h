//
//  JYNavigationController.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/5/31.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYNavigationController : UINavigationController{
    BOOL _changing;
}
@property (nonatomic,retain)UIView *alphaView;
-(void)setAlph:(CGFloat)alpha;
-(void)setNavigationBarBackgroundImage:(NSString *)imageName;
-(void)setNavigationBarBackgroundImage:(NSString *)imageName andAlph:(CGFloat)alpha;
@end
