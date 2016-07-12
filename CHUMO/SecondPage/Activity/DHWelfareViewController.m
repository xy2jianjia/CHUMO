//
//  DHWelfareViewController.m
//  CHUMO
//
//  Created by xy2 on 16/6/22.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHWelfareViewController.h"
#import "DHWelfareView.h"

#import "DHActivityPayViewController.h"
#import "DHActivityThirdPayViewController.h"
#import "DHShareCodeViewController.h"
#import "DHShareCodeIPhone4ViewController.h"
#import "YS_VipCenterViewController.h"
#import "MonthlyViewController.h"
#import "YS_SelfPayViewController.h"
#import "YS_SelfMailPayViewController.h"
@interface DHWelfareViewController ()<DHWelfareViewDelegate>

@end

@implementation DHWelfareViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"领取福利";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    
    [self checkPermission];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [HttpOperation asyncCancelRequestWithQueue:dispatch_get_main_queue()];
}
/**
 *  查询是否有权限
 */
- (void)checkPermission{
    __weak typeof (&*self)weakSelf = self;
    [HttpOperation asyncChargesWithQueue:dispatch_get_main_queue() completed:^(BOOL permission, NSInteger code) {
        [weakSelf configViewsWithPermission:permission];
    }];
}

- (void)configViewsWithPermission:(BOOL )permission{
    dispatch_async(dispatch_get_main_queue(), ^{
        [DHWelfareView configViewsWithPermission:permission inView:self.view delegate:self];
    });
}
/**
 *  代理方法： 购买三个月会员
 */
-(void)selfareOnclickedGoBuyCalledBack{
    
    [HttpOperation asyncGetVipListWithType:0 goodsCode:0 catagery:2 queue:dispatch_get_main_queue() completed:^(NSArray *vipArr, NSInteger code) {
        
        NSArray *arr = [vipArr firstObject];
        if (arr.count > 0) {
            if ([CHUMOEDITION isEqualToString:@"GOTOAPPSTORE"]) {
#pragma mark 商店版
                MonthlyViewController *moVC=[[MonthlyViewController alloc]init];
                UINavigationController *moenthnc=[[UINavigationController alloc]initWithRootViewController:moVC];
                [self presentViewController:moenthnc animated:YES completion:nil];
                //                    [self.navigationController pushViewController:moVC animated:YES];
            }else{
#pragma mark 企业版
                YS_SelfMailPayViewController *temp = [[YS_SelfMailPayViewController alloc]init];
                NSDictionary *goodDict=[NSGetTools getSystemGoodsByType:2];
                
                temp.payMainCode=[goodDict objectForKey:@"b13"];
                temp.payComboType=[goodDict objectForKey:@"b78"];//套餐
                //        temp.payMainCode=@"1005";
                //        temp.payComboType=@"2";//单买
                temp.navigationItem.title=@"写信包月服务";
                UINavigationController *tempnc=[[UINavigationController alloc]initWithRootViewController:temp];
                [self presentViewController:tempnc animated:YES completion:nil];
                //                    [self.navigationController pushViewController:temp animated:YES];
            }
        }
        
    }];
}
/**
 *  代理方法：提交兑换数据
 */
-(void)selfareOnclickedConformButtonCalledBackWithInfo:(NSString *)conformInfo type:(NSInteger)type{
    __weak typeof (&*self) weakSelf = self;
    // type为1，兑换话费，将结果传给下一个页面
    if (type == 1) {
        [HttpOperation asyncExchangeChargesWithPhoneNumber:conformInfo queue:dispatch_get_main_queue() completed:^(NSDictionary *registerInfo, NSInteger code,NSString *msg) {
            if (registerInfo && code == 200) {
                if (iPhone4) {
                    DHShareCodeIPhone4ViewController *vc = [[DHShareCodeIPhone4ViewController alloc] initWithNibName:@"DHShareCodeIPhone4ViewController" bundle:nil];
                    vc.infoDict = [NSDictionary dictionaryWithDictionary:registerInfo];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    DHShareCodeViewController *vc = [[DHShareCodeViewController alloc] initWithNibName:@"DHShareCodeViewController" bundle:nil];
                    vc.infoDict = [NSDictionary dictionaryWithDictionary:registerInfo];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"%ld:%@",code,msg] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    [alert show];
//                    [self showHint:[NSString stringWithFormat:@"%ld:%@",code,msg]];
                });
//                if (iPhone4) {
//                    DHShareCodeIPhone4ViewController *vc = [[DHShareCodeIPhone4ViewController alloc] initWithNibName:@"DHShareCodeIPhone4ViewController" bundle:nil];
//                    vc.infoDict = [registerInfo copy];
//                    [self.navigationController pushViewController:vc animated:YES];
//                }else{
//                    DHShareCodeViewController *vc = [[DHShareCodeViewController alloc] initWithNibName:@"DHShareCodeViewController" bundle:nil];
//                    vc.infoDict = [registerInfo copy];
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
            }
        }];
    }else if (type == 2){
        [HttpOperation asyncExchangePrepaidCodeWithPrepaidCode:conformInfo queue:dispatch_get_main_queue() completed:^(NSInteger code,NSString *msg) {
            [weakSelf showTipWithCode:code msg:msg];
        }];
    }
    
}
- (void)showTipWithCode:(NSInteger )code msg:(NSString *)msg{
    __weak typeof (&*self) weakSelf = self;
    NSString *alertMsg = nil;
    if (code == 200) {
        alertMsg = @"兑换成功，您已获得1个月VIP。";
    }else{
        alertMsg = [msg length] == 0?@"兑换失败":msg;
    }
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        return ;
    }]];
    if (code == 200) {
        [alertVc addAction:[UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf gotoVipCenter];
        }]];
    }
    [self presentViewController:alertVc animated:YES completion:nil];
}
- (void)gotoVipCenter{
#pragma mark 支付原生
    YS_VipCenterViewController *vip = [[YS_VipCenterViewController alloc] init];
    vip.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vip animated:YES];
}
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
