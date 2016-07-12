//
//  ViewController+Activity.m
//  CHUMO
//
//  Created by xy2 on 16/6/21.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "ViewController+Activity.h"
#import "DHActivityAlertView.h"
#import "DHActivityPayViewController.h"
#import "DHActivityThirdPayViewController.h"
#import "DHActivityDetailViewController.h"
@implementation ViewController (Activity)


- (void)configActivity{
    [HttpOperation asyncGetVipListWithType:0 goodsCode:0 catagery:2 queue:dispatch_get_main_queue() completed:^(NSArray *vipArr, NSInteger code) {
        if (vipArr.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 delay:0.5 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
                    [DHActivityAlertView configActivityAlertViewInView:self.view delegate:self dataSource:[vipArr firstObject]];
                } completion:^(BOOL finished) {
                    
                }];
            });
        }
    }];
}

-(void)activityOnclickedWithModel:(YS_PayModel *)model{
    
    if ([CHUMOEDITION isEqualToString:@"GOTOAPPSTORE"]){
#pragma mark 商店版
        DHActivityPayViewController *vc = [[DHActivityPayViewController alloc]init];
        vc.dataArr = [NSArray arrayWithObject:model];
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:vc];
        nc.navigationBar.barTintColor = MainBarBackGroundColor;
        [nc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [self presentViewController:nc animated:YES completion:nil];
    }else {
#pragma mark 企业版
        DHActivityThirdPayViewController *temp = [[DHActivityThirdPayViewController alloc]init];
        temp.goodInfoArr = [NSArray arrayWithObject:model];
        temp.payMainCode=@"1003";
        temp.payComboType=@"1";//套餐
        temp.navigationItem.title=@"开通VIP会员";
//        [self.navigationController pushViewController:temp animated:YES];
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:temp];
        nc.navigationBar.barTintColor = MainBarBackGroundColor;
        [nc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [self presentViewController:nc animated:YES completion:nil];
    }
}
/**
 *  打开活动详情页
 */
- (void)activityOnclickedActivityDetail{

    DHActivityDetailViewController *vc = [[DHActivityDetailViewController alloc]init];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:vc];
    nc.navigationBar.barTintColor = MainBarBackGroundColor;
    [nc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self presentViewController:nc animated:YES completion:nil];

}

@end
