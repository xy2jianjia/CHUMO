//
//  RefreshController.m
//  CHUMO
//
//  Created by zxs on 16/2/23.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "RefreshController.h"
@interface RefreshController ()<RefreshViewDelegate>

@end

@implementation RefreshController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    RefreshView *resh = [[RefreshView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    resh.refreshDelegate = self;
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:resh];
    
}
- (void)setRefre:(RefreshView *)refre inte:(NSInteger)inter {
    if (inter == 1000) {
        
        [self asyncTouchNetWorkingWithSuccess:^(id responseCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            });
            
        } falure:^(NSError *error) {
            return ;
        }];
    }
}
- (void)asyncTouchNetWorkingWithSuccess:(void(^)(id responseCode))succes falure:(void(^)(NSError *error))falure{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *url = [NSString stringWithFormat:@"%@f_120_10_1.service",kServerAddressTest];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        succes(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        falure(error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
