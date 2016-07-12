//
//  ReportResultController.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/2/23.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "ReportResultController.h"

@interface ReportResultController ()

@end

@implementation ReportResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(goBackAction)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)goBackAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
