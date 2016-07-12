//
//  YS_HistoryOrderOverInfoViewController.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/5/6.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "YS_HistoryOrderOverInfoViewController.h"

@interface YS_HistoryOrderOverInfoViewController ()
@property (nonatomic,strong)YS_OrderOverView *orderView;
@end

@implementation YS_HistoryOrderOverInfoViewController
-(void)loadView{
    self.orderView=[YS_OrderOverView orderOverInfoWithFrame:[[UIScreen mainScreen] bounds] AndInfoModel:self.model];
    
    self.view=self.orderView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"订单详情";
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self p_setupProgressHud];
//    });
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
