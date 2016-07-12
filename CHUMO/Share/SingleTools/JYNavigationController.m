//
//  JYNavigationController.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/5/31.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "JYNavigationController.h"

@implementation JYNavigationController
@synthesize alphaView;
-(id)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        CGRect frame = self.navigationBar.frame;
        alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+20)];
        [self.view insertSubview:alphaView belowSubview:self.navigationBar];
        
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bigShadow.png"] forBarMetrics:UIBarMetricsCompact];
        self.navigationBar.layer.masksToBounds = YES;
        
    }
    return self;
}
-(void)setNavigationBarBackgroundImage:(NSString *)imageName{
    alphaView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imageName]];
}
-(void)setNavigationBarBackgroundImage:(NSString *)imageName andAlph:(CGFloat)alpha{
    alphaView.alpha = alpha;
    alphaView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imageName]];
//    alphaView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navbg"]];
}
-(void)setAlph:(CGFloat)alpha{
    if (_changing == NO) {
        _changing = YES;
        [UIView animateWithDuration:0.1 animations:^{
            alphaView.alpha = alpha;
            
        } completion:^(BOOL finished) {
            _changing = NO;
        }];
        
    }
    
    
}

@end
